// vrutta_draft_screen.dart
//
// Shows VruttaDraftMaster rows, split into two sections by `tablename`
// (ShaakhaVruttaMaster / VistarShaakhaVruttaMaster), using Flutter's own
// DataTable instead of the HorizontalDataTable package — columns are driven
// by a declarative spec list instead of hand-duplicated widget arrays per
// column, so adding/removing a column is a one-line change, not a rewrite
// of three places (header, row builder, column-count maths).

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:marquee/marquee.dart';
import 'package:niyojak_prod/helpers/static_data.dart';

import '../../helpers/database_helper.dart';
import '../../helpers/static_data.dart' as Statics;
import '../../providers/bals.dart';
import '../shaakhaa_milan_module/edit_shaakhaa_vrutta.dart';

enum _CellType { text, int, bool, date }

class _ColumnDef {
  final String key; // column name in VruttaDraftMaster
  final String label; // header text shown to user
  final _CellType type;

  const _ColumnDef(this.key, this.label, this.type);
}

// Fixed superset — every column always shown, '-' where not applicable to
// a given row's vayogat/frequency. Matches your confirmed answer.
const _kColumns = <_ColumnDef>[
  _ColumnDef('VruttaDate', 'दिनांक', _CellType.date),
  _ColumnDef('ShishuCount', 'शिशु', _CellType.int),
  _ColumnDef('NewShishuCount', 'नवीन शिशु', _CellType.int),
  _ColumnDef('BaalVidyaarthiCount', 'बाल', _CellType.int),
  _ColumnDef('NewBaalVidyaarthiCount', 'नवीन बाल', _CellType.int),
  _ColumnDef('TarunVidyaarthiCount', 'त.वि.', _CellType.int),
  _ColumnDef('NewTarunVidyaarthiCount', 'नवीन त.वि.', _CellType.int),
  _ColumnDef('TarunVyavasaayeeCount', 'त.व्य.', _CellType.int),
  _ColumnDef('NewTarunVyavasaayeeCount', 'नवीन त.व्य.', _CellType.int),
  _ColumnDef('ProudhaVyavasaayeeCount', 'प्रौ.', _CellType.int),
  _ColumnDef('NewProudhaVyavasaayeeCount', 'नवीन प्रौ.', _CellType.int),
  _ColumnDef('matruskatiCount', 'मातृ.', _CellType.int),
  _ColumnDef('newmatruskatiCount', 'नवीन मातृ.', _CellType.int),
  _ColumnDef('PravasiKaryakartaCount', 'प्रवासी कार्य.', _CellType.int),
  _ColumnDef('AnyaPravasiKaryakartaCount', 'अन्य प्र. कार्य', _CellType.int),
  _ColumnDef('AbhyaagatCount', 'अभ्यागत', _CellType.int),
  _ColumnDef('IsDoneDeepBreathing', 'दीर्घश्वसन', _CellType.bool),
  _ColumnDef('IsDoneUrdhvapad', 'उर्ध्वपाद', _CellType.bool),
  _ColumnDef('IsDoneDandaPrahaar', 'दंडप्रहार', _CellType.bool),
  _ColumnDef('IsDoneSooryaNamaskaar', 'सूर्यनमस्कार', _CellType.bool),
  _ColumnDef('IsDoneSanchalanAbhyaas', 'संचलन अभ्यास', _CellType.bool),
  _ColumnDef('IsDoneBoodhKatha', 'बोध कथा', _CellType.bool),
  _ColumnDef('IsDoneBoudhikDays', 'बौद्धिक दिवस', _CellType.bool),
  _ColumnDef('IsDoneSewaDays', 'सेवा दिवस', _CellType.bool),
  _ColumnDef('IsDoneSaanghikGeet', 'सांघिक गीत', _CellType.bool),
  _ColumnDef('IsDoneAmrutaVachan', 'अमृतवचन', _CellType.bool),
  _ColumnDef('IsDoneSubhaashit', 'सुभाषित', _CellType.bool),
  _ColumnDef('IsOptionalShaaririk', 'वैकल्पिक शारीरिक विषय', _CellType.bool),
  _ColumnDef('IsOptionalOther', 'अन्य वैकल्पिक कार्यक्रम', _CellType.bool),
];

extension _ColorShade on Color {
  Color darken([double amount = 0.3]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
}

class VruttaDraftScreen extends StatefulWidget {
  const VruttaDraftScreen({super.key});

  @override
  State<VruttaDraftScreen> createState() => _VruttaDraftScreenState();
}

class _VruttaDraftScreenState extends State<VruttaDraftScreen> {
  List<Map<String, dynamic>> _shaakhaRows = [];
  List<Map<String, dynamic>> _vistarRows = [];
  final Set<int> _alreadyOnlineKeys = {}; // UniqueKeys flagged by last sync as existing online
  final Map<String, String> _shaakhaNameCache = {}; // ShaakhaaID -> resolved display name
  bool _loading = false;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    setState(() => _loading = true);
    final all = await DatabaseHelper.getAllOfflineData<Map<String, dynamic>>(
      tableName: 'VruttaDraftMaster',
      fromMap: (m) => m,
      orderBy: 'VruttaDate DESC',
    );
    _shaakhaRows = all.where((r) => r['tablename'] == 'ShaakhaVruttaMaster').toList();
    _vistarRows = all.where((r) => r['tablename'] == 'VistarShaakhaVruttaMaster').toList();

    await _resolveShaakhaNames(all);

    if (!mounted) return;
    setState(() => _loading = false);
  }

  ///FOR CUSTOM SEARCHING
  // Future<void> _resolveShaakhaNames(List<Map<String, dynamic>> rows) async {
  //   final toResolve = <String, Map<String, dynamic>>{}; // cacheKey -> {id, tablename}
  //   for (final row in rows) {
  //     final tablename = row['tablename'] as String?;
  //     if (tablename == null) continue;
  //
  //     // Shaakha rows key off ShaakhaaID; Vistar rows key off pkid (vistarshaakhaid).
  //     final id = tablename == 'VistarShaakhaVruttaMaster' ? row['pkid'] as int? : row['ShaakhaaID'] as int?;
  //     if (id == null) continue;
  //
  //     final cacheKey = '$tablename:$id';
  //     if (!_shaakhaNameCache.containsKey(cacheKey)) {
  //       toResolve[cacheKey] = {'id': id, 'tablename': tablename};
  //     }
  //   }
  //   if (toResolve.isEmpty) return;
  //
  //   final results = await Future.wait(toResolve.entries.map((entry) async {
  //     final id = entry.value['id'] as int;
  //     final tablename = entry.value['tablename'] as String;
  //
  //     final geo = tablename == 'VistarShaakhaVruttaMaster' ? await Statics.getLocalVistarShaakhaaByID(id.toString()) : await Statics.getLocalShaakhaaByID(id.toString());
  //
  //     return MapEntry(entry.key, geo == null ? '-' : _resolveName(geo));
  //   }));
  //
  //   for (final entry in results) {
  //     _shaakhaNameCache[entry.key] = entry.value;
  //   }
  // }

  ///if ShaakhaaID is only used
  Future<void> _resolveShaakhaNames(List<Map<String, dynamic>> rows) async {
    final toResolve = <String, Map<String, dynamic>>{}; // cacheKey -> {id, tablename}
    for (final row in rows) {
      final id = row['ShaakhaaID'] as int?;
      final tablename = row['tablename'] as String?;
      if (id == null || tablename == null) continue;
      final cacheKey = '$tablename:$id';
      if (!_shaakhaNameCache.containsKey(cacheKey)) {
        toResolve[cacheKey] = {'id': id, 'tablename': tablename};
      }
    }
    if (toResolve.isEmpty) return;

    final results = await Future.wait(toResolve.entries.map((entry) async {
      final id = entry.value['id'] as int;
      final tablename = entry.value['tablename'] as String;

      final geo = tablename == 'VistarShaakhaVruttaMaster' ? await Statics.getLocalVistarShaakhaaByID(id.toString()) : await Statics.getLocalShaakhaaByID(id.toString());

      return MapEntry(entry.key, geo == null ? '-' : _resolveName(geo));
    }));

    for (final entry in results) {
      _shaakhaNameCache[entry.key] = entry.value;
    }
  }

  String _resolveName(GeoUnitMasterBAL geo) {
    final lang = userDetails['languagePreference']?.toString();
    final value = switch (lang) {
      'English' => geo.geoUnitNameEnglish,
      'Hindi' => geo.geoUnitNameHindi,
      'Marathi' => geo.geoUnitNameMarathi,
      _ => geo.geoUnitNameMarathi,
    };
    if (value != null && value.trim().isNotEmpty) return value;
    return geo.geoUnitName ?? geo.fullName ?? '-'; // fallback chain if the language-specific field is empty
  }

  // ── sync ────────────────────────────────────────────────────────────

  Map<String, dynamic> _toVruttaJson(Map<String, dynamic> row) => {
        'UniqueKey': row['UniqueKey'],
        'PraantID': row['PraantID'],
        'ShaakhaaID': row['ShaakhaaID'],
        'pkid': row['pkid'],
        'VruttaDate': _toDdMmYyyy(row['VruttaDate']?.toString()),
        'ShishuCount': row['ShishuCount'],
        'NewShishuCount': row['NewShishuCount'],
        'BaalVidyaarthiCount': row['BaalVidyaarthiCount'],
        'NewBaalVidyaarthiCount': row['NewBaalVidyaarthiCount'],
        'TarunVidyaarthiCount': row['TarunVidyaarthiCount'],
        'NewTarunVidyaarthiCount': row['NewTarunVidyaarthiCount'],
        'TarunVyavasaayeeCount': row['TarunVyavasaayeeCount'],
        'NewTarunVyavasaayeeCount': row['NewTarunVyavasaayeeCount'],
        'ProudhaVyavasaayeeCount': row['ProudhaVyavasaayeeCount'],
        'NewProudhaVyavasaayeeCount': row['NewProudhaVyavasaayeeCount'],
        'matruskatiCount': row['matruskatiCount'],
        'newmatruskatiCount': row['newmatruskatiCount'],
        'totalCount': row['totalCount'],
        'newtotalCount': row['newtotalCount'],
        'AbhyaagatCount': row['AbhyaagatCount'],
        'IsDoneDeepBreathing': _toBool(row['IsDoneDeepBreathing']),
        'IsDoneDandaPrahaar': _toBool(row['IsDoneDandaPrahaar']),
        'IsDoneSooryaNamaskaar': _toBool(row['IsDoneSooryaNamaskaar']),
        'IsDoneSanchalanAbhyaas': _toBool(row['IsDoneSanchalanAbhyaas']),
        'IsDoneSaanghikGeet': _toBool(row['IsDoneSaanghikGeet']),
        'IsDoneAmrutaVachan': _toBool(row['IsDoneAmrutaVachan']),
        'IsDoneSubhaashit': _toBool(row['IsDoneSubhaashit']),
        'IsOptionalShaaririk': _toBool(row['IsOptionalShaaririk']),
        'IsOptionalOther': _toBool(row['IsOptionalOther']),
        'Remark': row['Remark'],
        'ModifiedBy': row['ModifiedBy'],
        'PravasiKaryakartaCount': row['PravasiKaryakartaCount'],
        'AnyaPravasiKaryakartaCount': row['AnyaPravasiKaryakartaCount'],
        'BoudhikDaysId': row['BoudhikDaysId'],
        'SewaDaysId': row['SewaDaysId'],
        'AnyaBoudhikDays': row['AnyaBoudhikDays'],
        'IsDoneUrdhvapad': _toBool(row['IsDoneUrdhvapad']),
        'IsDoneBoodhKatha': _toBool(row['IsDoneBoodhKatha']),
        'IsDoneBoudhikDays': _toBool(row['IsDoneBoudhikDays']),
        'IsDoneSewaDays': _toBool(row['IsDoneSewaDays']),
      };

  Future<void> _syncDrafts() async {
    if (_shaakhaRows.isEmpty && _vistarRows.isEmpty) return;

    final connected = await isInternetConnected();
    if (connected != true) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No internet — cannot sync drafts')));
      return;
    }

    setState(() => _syncing = true);

    final body = {
      'shaakhavruttaList': _shaakhaRows.map(_toVruttaJson).toList(),
      'shaakhavistarvruttaList': _vistarRows.map(_toVruttaJson).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse(urlsyncshaakhaavruttadata), // confirm this constant's actual name
        headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Sync failed: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final conflictShaakhaIds = _parseCsvIds(decoded['shaakhavruttaList']);
      final conflictVistarIds = _parseCsvIds(decoded['shaakhavistarvruttaList']);
      final allConflictIds = {...conflictShaakhaIds, ...conflictVistarIds};

      // Everything sent, minus what came back as a conflict, is confirmed synced.
      final allSent = [..._shaakhaRows, ..._vistarRows];
      for (final row in allSent) {
        final key = row['UniqueKey'] as int;
        if (allConflictIds.contains(key)) continue; // keep as draft, flag below

        final masterTable = row['tablename'] as String;
        final masterData = Map<String, dynamic>.from(row)
          ..remove('UniqueKey')
          ..remove('tablename')
          ..remove('isdraft');

        await DatabaseHelper.upsertOne<Map<String, dynamic>>(
          tableName: masterTable,
          item: masterData,
          toMap: (m) => m,
          keyColumns: ['ShaakhaaID', 'VruttaDate'],
          hasUniqueConstraint: false, // flip to true once that UNIQUE constraint is confirmed on both master tables
        );

        await DatabaseHelper.deleteOne(
          tableName: 'VruttaDraftMaster',
          keyColumns: ['UniqueKey'],
          keyValues: [key],
        );
      }

      setState(() {
        _alreadyOnlineKeys
          ..clear()
          ..addAll(allConflictIds);
      });

      await _loadDrafts();

      if (!mounted) return;
      final syncedCount = allSent.length - allConflictIds.length;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Synced $syncedCount — ${allConflictIds.length} already exist online')),
      );
    } catch (e) {
      log('Sync exception: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sync failed — try again later')));
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  Set<int> _parseCsvIds(dynamic raw) {
    final s = raw?.toString() ?? '';
    if (s.trim().isEmpty) return {};
    return s.split(',').map((e) => int.tryParse(e.trim())).whereType<int>().toSet();
  }

  // ── row actions ─────────────────────────────────────────────────────

  Future<void> _deleteDraft(Map<String, dynamic> row) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete draft?'),
        content: const Text('This local draft will be removed permanently.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;

    await DatabaseHelper.deleteOne(
      tableName: 'VruttaDraftMaster',
      keyColumns: ['UniqueKey'],
      keyValues: [row['UniqueKey']],
    );
    await _loadDrafts();
  }

  // ⚠️ Left unimplemented pending your answer above — pkid may be null
  // for a never-synced draft, and EditShaakhaaVrutta needs a vruttaID.
  void _editDraft(Map<String, dynamic> row) {
    final vruttaId = row['pkid'];
    if (vruttaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This draft has not synced yet — edit not available offline')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditShaakhaaVrutta(
          shaakhaaID: row['ShaakhaaID'].toString(),
          vruttaID: vruttaId.toString(),
          vruttadate: _toDdMmYyyy(row['VruttaDate']?.toString()),
          onSaveDetails: _loadDrafts,
          viewType: 'EditVrutta',
        ),
      ),
    );
  }

  // ── table building (cosmetic pass) ──────────────────────────────────

  Widget _buildSection(String title, IconData icon, Color accent, List<Map<String, dynamic>> rows) {
    final flaggedCount = rows.where((r) => _alreadyOnlineKeys.contains(r['UniqueKey'] as int)).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header: icon chip + title + count badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: accent.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(icon, color: accent, size: 20),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: Text('${rows.length}', style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              if (flaggedCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 12, color: Colors.deepOrange),
                      const SizedBox(width: 3),
                      Text('$flaggedCount online', style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),

          if (rows.isEmpty)
            Card(
              elevation: 0,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inbox_outlined, size: 32, color: Colors.grey.shade400),
                      const SizedBox(height: 6),
                      Text('No pending drafts', style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ),
            )
          else
            Card(
              elevation: 1,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(accent.withOpacity(0.08)),
                  headingTextStyle: TextStyle(fontWeight: FontWeight.w700, color: accent.darken(), fontSize: 12.5),
                  dataRowMinHeight: 46,
                  dataRowMaxHeight: 50,
                  columnSpacing: 20,
                  horizontalMargin: 14,
                  columns: [
                    const DataColumn(label: Text('')),
                    DataColumn(label: Text(Statics.getLabel('Shaakhaa')), headingRowAlignment: MainAxisAlignment.center), // NEW — leading column
                    ..._kColumns.map((c) => DataColumn(label: Text(c.label), headingRowAlignment: MainAxisAlignment.center)),
                    DataColumn(label: Text(Statics.getLabel('Status')), headingRowAlignment: MainAxisAlignment.center),
                  ],
                  rows: List.generate(rows.length, (i) => _buildRow(rows[i], i, accent)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _shaakhaNameCell(String name) {
    const maxWidth = 140.0;
    const cellHeight = 20.0;
    const style = TextStyle(fontWeight: FontWeight.w600, fontSize: 13);

    final tp = TextPainter(
      text: TextSpan(text: name, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final overflows = tp.width > maxWidth;

    return SizedBox(
      width: overflows ? maxWidth : tp.width,
      height: cellHeight,
      child: overflows
          ? Marquee(
              text: name,
              style: style,
              scrollAxis: Axis.horizontal,
              velocity: 27.0,
              blankSpace: 30.0,
              startAfter: const Duration(milliseconds: 300),
              pauseAfterRound: const Duration(seconds: 1),
              fadingEdgeStartFraction: 0.05,
              fadingEdgeEndFraction: 0.05,
            )
          : Align(
              alignment: Alignment.centerLeft,
              child: Text(name, style: style, overflow: TextOverflow.ellipsis),
            ),
    );
  }

  DataRow _buildRow(Map<String, dynamic> row, int index, Color accent) {
    final isFlagged = _alreadyOnlineKeys.contains(row['UniqueKey'] as int);
    final zebra = index.isEven ? Colors.transparent : Colors.grey.shade50;

    return DataRow(
      color: WidgetStateProperty.resolveWith((states) {
        if (isFlagged) return Colors.deepOrange.withOpacity(0.06);
        if (states.contains(WidgetState.hovered)) return accent.withOpacity(0.05);
        return zebra;
      }),
      cells: [
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _actionButton(Icons.edit_outlined, Colors.indigo, 'Edit', () => _editDraft(row)),
            const SizedBox(width: 4),
            _actionButton(Icons.delete_outline, Colors.redAccent, 'Delete', () => _deleteDraft(row)),
          ],
        )),
        DataCell(_shaakhaNameCell(_shaakhaNameCache['${row['tablename']}:${row['ShaakhaaID']}'] ?? '-')),
        // DataCell(_shaakhaNameCell(_shaakhaNameCache['${row['tablename']}:${row['tablename'] == 'VistarShaakhaVruttaMaster' ? row['pkid'] : row['ShaakhaaID']}'] ?? '-')),
        ..._kColumns.map((c) => DataCell(_cellContent(c, row[c.key]))),
        DataCell(_statusChip(isFlagged)),
      ],
    );
  }

  Widget _statusChip(bool isFlagged) {
    if (!isFlagged) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.schedule, size: 14, color: Colors.grey),
          SizedBox(width: 4),
          Text('Pending', style: TextStyle(color: Colors.grey, fontSize: 11.5)),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.deepOrange.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_done_outlined, size: 13, color: Colors.deepOrange),
          SizedBox(width: 4),
          Text('Already online', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 19, color: color),
        ),
      ),
    );
  }

  Widget _cellContent(_ColumnDef col, dynamic value) {
    switch (col.type) {
      case _CellType.bool:
        final v = _toBool(value);
        return v == true ? Center(child: const Icon(Icons.check_circle, size: 17, color: Colors.green)) : Center(child: Text('-', style: TextStyle(color: Colors.grey.shade400)));
      case _CellType.date:
        return Center(child: Text(_toDdMmYyyy(value?.toString()), style: const TextStyle(fontWeight: FontWeight.w500)));
      case _CellType.int:
      case _CellType.text:
        final text = value?.toString();
        return Center(
          child: Text(
            text ?? '-',
            style: text == null ? TextStyle(color: Colors.grey.shade400) : null,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalDrafts = _shaakhaRows.length + _vistarRows.length;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Vrutta Drafts', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(
              child: TextButton.icon(
                onPressed: (_syncing || totalDrafts == 0) ? null : _syncDrafts,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                icon: _syncing ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.sync, size: 18),
                label: Text(_syncing ? 'Syncing...' : 'Sync all'),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDrafts,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  _buildSection('Shaakhaa Vrutta', Icons.home_work_outlined, Colors.indigo, _shaakhaRows),
                  _buildSection('Vistar Shaakhaa Vrutta', Icons.map_outlined, Colors.teal, _vistarRows),
                ],
              ),
            ),
    );
  }
}

// ── helpers ──────────────────────────────────────────────────────────

bool? _toBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is int) return v == 1;
  return v.toString() == '1' || v.toString().toLowerCase() == 'true';
}

// ASSUMPTION, not confirmed: VruttaDate in the draft table is already
// stored as dd/MM/yyyy (matching how the live screen parses it). If that
// turns out false, this needs the real stored format to parse correctly.
String _toDdMmYyyy(String? raw) {
  if (raw == null || raw.isEmpty) return '-';
  try {
    final parsed = intl.DateFormat('dd/MM/yyyy').parseStrict(raw);
    return intl.DateFormat('dd/MM/yyyy').format(parsed);
  } catch (_) {
    return raw; // couldn't confirm the stored format — pass through rather than guess-reformat
  }
}
