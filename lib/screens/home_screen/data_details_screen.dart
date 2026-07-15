import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart' as ex;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/names_data_model.dart';
import '../../widgets/swayamsevak_card.dart';
import '../shaakhaa_milan_module/edit_shaakhaa_vrutta.dart';
import '../swayamsevak_module/edit_module/edit_swayamsevak_basic_info.dart';
import '../swayamsevak_module/edit_module/edit_swayamsevak_daayitva.dart';
import '../swayamsevak_module/edit_module/edit_swayamsevak_other_info.dart';
import '../swayamsevak_module/edit_module/edit_swayamsevak_screen.dart';
import '../swayamsevak_module/edit_module/edit_swayamsevak_transfer.dart';

class DataDetailsScreen extends StatelessWidget {
  final String infoName;
  final IconData? icon;
  final String from;
  final List<DataDetailsGroup> groupedData;

  const DataDetailsScreen({super.key, required this.groupedData, required this.from, this.icon, required this.infoName});

  int get _totalEntries => groupedData.fold(0, (sum, g) => sum + g.items.length);

  Future<void> exportToExcel(BuildContext context) async {
    if (context != null) Statics.showLoaderDialog(context);

    try {
      var excel = ex.Excel.createExcel();
      final sheet = excel['Sheet1'];

      for (final group in groupedData) {
        // Group Header
        sheet.appendRow([
          group.groupType,
        ]);

        // Column Headers
        sheet.appendRow([
          'Index',
          'Value',
        ]);

        int index = 1;

        // Data
        for (final item in group.items) {
          sheet.appendRow([
            index++,
            item.value ?? '-',
          ]);
        }

        // Total Row
        sheet.appendRow([
          'Total',
          group.items.length,
        ]);

        // Empty row between groups
        sheet.appendRow([]);
      }
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${Statics.getLabel(infoName, returnKey: true)}_${Statics.getLabel('Information')}_${DateTime.now().millisecondsSinceEpoch}.xlsx';

      final file = File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.encode()!);

      await OpenFilex.open(path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Excel exported successfully.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to export file: $e'),
        ),
      );
    } finally {
      if (context != null) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${Statics.getLabel('Information')} (${Statics.getLabel(infoName, returnKey: true)})"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => exportToExcel(context),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // ── Summary bar ──
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.list_alt_outlined, size: 18, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  '$_totalEntries entries across ${groupedData.length} groups',
                  style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey.shade200),

          // ── Group list — only visible tiles are built ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: groupedData.length,
              itemBuilder: (context, index) {
                return _DataGroupTile(group: groupedData[index], icon: icon, from: from);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DataGroupTile extends StatelessWidget {
  final DataDetailsGroup group;
  final IconData? icon;
  final String from;

  const _DataGroupTile({required this.group, required this.from, this.icon});

  static const double _maxItemsHeight = 240;

  PermissionSet _getPermissions() {
    final levelName = Statics.userDetails['LevelName'];
    final daayitvaName = Statics.userDetails['DaayitvaName'];
    final levelID = int.tryParse(Statics.userDetails['LevelID'] ?? '0') ?? 0;
    final mobileNumber = Statics.userDetails['MobileNumber'];

    return PermissionSet(
      canTransfer: false,
      // _checkTransferPermission(levelName, daayitvaName),
      canEdit: true,
      canResetPassword: false,
      canDelete: false,
      // _checkDeletePermission(levelName, daayitvaName),
      isDevUser: mobileNumber == '9322406725-1234',
    );
  }

  void _handleMenuSelection(BuildContext context, String value, int swayamsevakID, PermissionSet permissions) {
    switch (value) {
      case "ResetPassword":
        Statics.showConfirmationBox(context, Statics.getLabel('ConfirmResetpassword'), "ResetPassword", swayamsevakID.toString());
        break;
      case "Delete":
        _deleteSwayamSevak(context, swayamsevakID);
        break;
      case "Transfer":
        Navigator.of(context).pushNamed(
          EditSwayamsevakTransferScreen.routeName,
          arguments: Statics.ScreenArgumentsSwayamsevakTransfer('0', swayamsevakID.toString(), value),
        );
        break;
      case "EditMenuNew":
        Navigator.of(context).pushNamed(EditSwayamsevakBasicInfo.routeName, arguments: Statics.ScreenArgumentsNew(swayamsevakID, value));
        break;
      case "DaayitvaMenu":
        Navigator.of(context).pushNamed(EditSwayamsevakDaayitva.routeName, arguments: Statics.ScreenArguments(swayamsevakID, value));
        break;
      case "OtherInfoMenu":
        Navigator.of(context).pushNamed(EditSwayamsevakOtherInfo.routeName, arguments: Statics.ScreenArguments(swayamsevakID, value));
        break;
      default:
        Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(swayamsevakID, value));
    }
  }

  Future<void> _deleteSwayamSevak(BuildContext context, int id) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
        return;
      }

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(Statics.getLabel('AskConfirmation')),
          content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSwayamsevak')),
          actions: [
            TextButton(
              child: Text(Statics.getLabel('ConfirmationNo'), style: TextStyle(color: Colors.grey[700], fontSize: 16)),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(Statics.getLabel('ConfirmationYes'), style: TextStyle(fontSize: 16)),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        final inputData = json.encode({"SwayamsevakID": id});
        final data = await Statics.deleteSwayamsevakDataForApp(inputData);
        if (data.contains("Deleted Successfully")) {
          Statics.showToast(Statics.getLabel('SwayamsevakDeletedSuccessfully'));
        } else {
          Statics.showToast(Statics.getLabel('CouldnotDeleteSwayamsevak'));
        }
      }
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
  }

  List<PopupMenuEntry<String>> _buildMenuItems(PermissionSet permissions) {
    final items = <PopupMenuEntry<String>>[];

    if (permissions.canEdit) {
      items.add(_buildMenuItem('EditMenu', Icons.edit, Statics.getLabel('EditMenu')));
      if (permissions.isDevUser) {
        items.add(_buildMenuItem('EditMenuNew', Icons.edit_note, '${Statics.getLabel('EditMenu')}-New'));
        items.add(_buildMenuItem('DaayitvaMenu', Icons.work, '${Statics.getLabel('Daayitva')}-New'));
        items.add(_buildMenuItem('OtherInfoMenu', Icons.info, '${Statics.getLabel('OtherInfo')}-New'));
      }
    }

    items.add(_buildMenuItem('ViewMenu', Icons.visibility, Statics.getLabel('ViewMenu')));

    if (permissions.canResetPassword) {
      items.add(_buildMenuItem('ResetPassword', Icons.lock_reset, Statics.getLabel('ResetPassword')));
    }
    if (permissions.canDelete) {
      items.add(_buildMenuItem('Delete', Icons.delete, Statics.getLabel('Delete')));
    }
    if (permissions.canTransfer) {
      items.add(_buildMenuItem('Transfer', Icons.swap_horiz, Statics.getLabel('CardMenuSwayamsevakTransfer')));
    }

    return items;
  }

  PopupMenuItem<String> _buildMenuItem(String key, IconData icon, String label) {
    return PopupMenuItem(
      value: key,
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: EdgeInsets.zero,
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.grey.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.purple.shade200, width: 0.5)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.grey.shade200)),
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.space_dashboard, size: 16, color: Colors.purple.shade700),
        ),
        title: Text(
          Statics.getLabel(group.groupType, returnKey: true),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        subtitle: Text(
          '${group.items.length} entries',
          style: const TextStyle(fontSize: 12, color: Colors.black45),
        ),
        children: [
          Container(height: 0.5, color: Colors.purple.shade200),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: _maxItemsHeight),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: group.items.length,
              itemBuilder: (context, i) {
                final person = group.items[i];
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  onTap: (from != "shaakhaaNames" && (person.id == 0 || person.id == null))
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditShaakhaaVrutta(
                                    shaakhaaID: person.id.toString(),
                                    vruttaID: null,
                                    onSaveDetails: null,
                                    viewType: "EditVrutta",
                                    vruttadate: person.vdate != null && (person.vdate?.isNotEmpty == true) ? DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd').parse(person.vdate!)) : null,
                                  ))),
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.indigo.shade50,
                    child: Icon(icon ?? Icons.person_outline, size: 14, color: Colors.indigo.shade400),
                  ),
                  title: Text(
                    person.value ?? '—',
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  trailing: from == "shaakhaaNames"
                      ? person.id == 0 || person.id == null
                          ? null
                          : Icon(Icons.keyboard_arrow_right_rounded)
                      : _buildMenuButton(context, person.id ?? 0, _getPermissions()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, int id, PermissionSet permissions) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: Colors.purple.shade50,
      position: PopupMenuPosition.under,
      borderRadius: BorderRadius.circular(16),
      onSelected: (value) => _handleMenuSelection(context, value, id, permissions),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => _buildMenuItems(permissions),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.more_vert, size: 16, color: Colors.deepPurple),
            SizedBox(width: 2),
            Text(Statics.getLabel("menu"), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.deepPurple)),
          ],
        ),
      ),
    );
  }
}
