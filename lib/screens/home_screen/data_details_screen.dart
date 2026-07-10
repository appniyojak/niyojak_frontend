import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/names_data_model.dart';
import '../shaakhaa_milan_module/edit_shaakhaa_vrutta.dart';

class DataDetailsScreen extends StatelessWidget {
  final String infoName;
  final IconData? icon;
  final List<DataDetailsGroup> groupedData;

  const DataDetailsScreen({super.key, required this.groupedData, this.icon, required this.infoName});

  int get _totalEntries => groupedData.fold(0, (sum, g) => sum + g.items.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${Statics.getLabel('Information')} (${Statics.getLabel(infoName, returnKey: true)})"),
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
                return _DataGroupTile(group: groupedData[index], icon: icon);
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

  const _DataGroupTile({required this.group, this.icon});

  static const double _maxItemsHeight = 240;

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
                  onTap: person.id == 0 || person.id == null
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
                  trailing: person.id == 0 || person.id == null ? null : Icon(Icons.keyboard_arrow_right_rounded),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
