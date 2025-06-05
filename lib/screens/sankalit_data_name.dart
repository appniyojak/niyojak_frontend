// // import 'package:flutter/material.dart';
// // import '../helpers/static_data.dart' as Statics;
// // import '../models/response_model/sankalit_data_names_model.dart';
// //
// // class SankalitDataNamesView extends StatefulWidget {
// //   static const routeName = '/sankalit-data-names-view';
// //
// //   const SankalitDataNamesView({Key? key}) : super(key: key);
// //
// //   @override
// //   State<SankalitDataNamesView> createState() => _SankalitDataNamesViewState();
// // }
// //
// // class _SankalitDataNamesViewState extends State<SankalitDataNamesView> {
// //   late List<Listname> listData;
// //   late String? infoName;
// //   late Map<String, List<Listname>> groupedData;
// //   int initiallyExpandedIndex = 0;
// //   @override
// //   void didChangeDependencies() {
// //     super.didChangeDependencies();
// //     final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
// //     listData = args['listname'] as List<Listname>;
// //     infoName = args['infoName'] as String;
// //
// //     groupedData = {};
// //     for (var item in listData) {
// //       final title = item.title ?? 'No Title';
// //       if (!groupedData.containsKey(title)) {
// //         groupedData[title] = [];
// //       }
// //       groupedData[title]!.add(item);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("${Statics.getLabel('Information')} ($infoName)"),
// //       ),
// //       body: groupedData.isEmpty
// //           ? Center(
// //         child: Text(
// //           Statics.getLabel('NoDataAvailable'),
// //           style: const TextStyle(fontSize: 16),
// //         ),
// //       )
// //           : ListView.builder(
// //         itemCount: groupedData.entries.length,
// //         itemBuilder: (context, index) {
// //           final entry = groupedData.entries.elementAt(index);
// //           final title = entry.key;
// //           final items = entry.value;
// //
// //           return Card(
// //             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //             child: ExpansionTile(
// //               initiallyExpanded: index == initiallyExpandedIndex,
// //               title: Text(
// //                 "$title :  ${items.length}",
// //                 style: const TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //               children: [
// //                 ConstrainedBox(
// //                   constraints: const BoxConstraints(maxHeight: 400),
// //                   child: SingleChildScrollView(
// //                     child: ListView.builder(
// //                       shrinkWrap: true,
// //                       physics: const NeverScrollableScrollPhysics(),
// //                       itemCount: items.length,
// //                       itemBuilder: (context, itemIndex) {
// //                         final item = items[itemIndex];
// //                         return ListTile(
// //                           title: Row(
// //                             children: [
// //                               Text("${itemIndex +1}) "),
// //                               Text(
// //                                 [
// //                                   if (item.mahanagar != null && item.mahanagar!.isNotEmpty) '${itemIndex + 1}) ${item.mahanagar}',
// //                                   if (item.vibhag != null && item.vibhag!.isNotEmpty) '${item.vibhag}',
// //                                   if (item.bhaag != null && item.bhaag!.isNotEmpty) '${item.bhaag}',
// //                                   if (item.nagar != null && item.nagar!.isNotEmpty) '${item.nagar}',
// //                                   if (item.vasti != null && item.vasti!.isNotEmpty) '${item.vasti}',
// //                                   if (item.gram != null && item.gram!.isNotEmpty) '${item.gram}',
// //                                   if (item.mandal != null && item.mandal!.isNotEmpty) '${item.mandal}',
// //                                 ].join(' -> '),
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
//
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import '../helpers/static_data.dart' as Statics;
// import '../models/response_model/sankalit_data_names_model.dart';
//
// class SankalitDataNamesView extends StatefulWidget {
//   static const routeName = '/sankalit-data-names-view';
//
//   const SankalitDataNamesView({Key? key}) : super(key: key);
//
//   @override
//   State<SankalitDataNamesView> createState() => _SankalitDataNamesViewState();
// }
//
// class _SankalitDataNamesViewState extends State<SankalitDataNamesView> {
//   late List<Listname> listData;
//   late String? infoName;
//   late Map<String, List<Listname>> groupedData;
//   int initiallyExpandedIndex = 0;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
//     listData = args['listname'] as List<Listname>;
//     infoName = args['infoName'] as String;
//
//     groupedData = {};
//     for (var item in listData) {
//       final title = item.title ?? 'No Title';
//       if (!groupedData.containsKey(title)) {
//         groupedData[title] = [];
//       }
//       groupedData[title]!.add(item);
//     }
//   }
//
//   Future<void> exportToExcel() async {
//     var excel = Excel.createExcel(); // Create a new Excel sheet
//
//     // Create a sheet
//     final sheet = excel['Data'];
//     sheet.appendRow([
//       'Index',
//       'Mahanagar',
//       'Vibhag',
//       'Bhaag',
//       'Nagar',
//       'Vasti',
//       'Gram',
//       'Mandal'
//     ]); // Add header row
//
//     // Add data to Excel
//     int rowIndex = 1;
//     for (var entry in groupedData.entries) {
//       final items = entry.value;
//       for (var item in items) {
//         sheet.appendRow([
//           rowIndex++,
//           item.mahanagar ?? '',
//           item.vibhag ?? '',
//           item.bhaag ?? '',
//           item.nagar ?? '',
//           item.vasti ?? '',
//           item.gram ?? '',
//           item.mandal ?? '',
//         ]);
//       }
//     }
//
//     // Save the file
//     final directory = await getApplicationDocumentsDirectory();
//     final path = '${directory.path}/SankalitData.xlsx';
//     final file = File(path)
//       ..createSync(recursive: true)
//       ..writeAsBytesSync(excel.encode()!);
//
//     // Notify the user
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Excel file exported: $path')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${Statics.getLabel('Information')} ($infoName)"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.download),
//             onPressed: exportToExcel, // Call export function
//           ),
//         ],
//       ),
//       body: groupedData.isEmpty
//           ? Center(
//         child: Text(
//           Statics.getLabel('NoDataAvailable'),
//           style: const TextStyle(fontSize: 16),
//         ),
//       )
//           : ListView.builder(
//         itemCount: groupedData.entries.length,
//         itemBuilder: (context, index) {
//           final entry = groupedData.entries.elementAt(index);
//           final title = entry.key;
//           final items = entry.value;
//
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: ExpansionTile(
//               initiallyExpanded: index == initiallyExpandedIndex,
//               title: Text(
//                 "$title :  ${items.length}",
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               children: [
//                 ConstrainedBox(
//                   constraints: const BoxConstraints(maxHeight: 400),
//                   child: SingleChildScrollView(
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: items.length,
//                       itemBuilder: (context, itemIndex) {
//                         final item = items[itemIndex];
//                         return ListTile(
//                           title: Row(
//                             children: [
//                               Text("${itemIndex + 1}) "),
//                               Text(
//                                 [
//                                   if (item.mahanagar != null && item.mahanagar!.isNotEmpty) '${itemIndex + 1}) ${item.mahanagar}',
//                                   if (item.vibhag != null && item.vibhag!.isNotEmpty) '${item.vibhag}',
//                                   if (item.bhaag != null && item.bhaag!.isNotEmpty) '${item.bhaag}',
//                                   if (item.nagar != null && item.nagar!.isNotEmpty) '${item.nagar}',
//                                   if (item.vasti != null && item.vasti!.isNotEmpty) '${item.vasti}',
//                                   if (item.gram != null && item.gram!.isNotEmpty) '${item.gram}',
//                                   if (item.mandal != null && item.mandal!.isNotEmpty) '${item.mandal}',
//                                 ].join(' -> '),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../helpers/static_data.dart' as Statics;
import '../models/response_model/sankalit_data_names_model.dart';

class SankalitDataNamesView extends StatefulWidget {
  static const routeName = '/sankalit-data-names-view';

  const SankalitDataNamesView({Key? key}) : super(key: key);

  @override
  State<SankalitDataNamesView> createState() => _SankalitDataNamesViewState();
}

class _SankalitDataNamesViewState extends State<SankalitDataNamesView> {
  late List<Listname> listData;
  late String? infoName;
  late Map<String, List<Listname>> groupedData;
  int initiallyExpandedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    listData = args['listname'] as List<Listname>;
    infoName = args['infoName'] as String;

    groupedData = {};
    for (var item in listData) {
      final title = item.title ?? 'No Title';
      if (!groupedData.containsKey(title)) {
        groupedData[title] = [];
      }
      groupedData[title]!.add(item);
    }

    // print("Grouped Data: $groupedData");
  }


  Future<void> exportToExcel() async {
    var excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    sheet.appendRow([
      'Index',
      'Title',
      'Mahanagar',
      'Vibhag',
      'Bhaag',
      'Nagar',
      'Vasti',
      'Gram',
      'Mandal'
    ]);

    int rowIndex = 1;
    for (var entry in groupedData.entries) {
      final items = entry.value;
      for (var item in items) {
        final row = [
          rowIndex++,
          item.title ?? '-',
          item.mahanagar ?? '-',
          item.vibhag ?? '-',
          item.bhaag ?? '-',
          item.nagar ?? '-',
          item.vasti ?? '-',
          item.gram ?? '-',
          item.mandal ?? '-',
        ];
        // print("Adding Row: $row");
        sheet.appendRow(row);
      }
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/SankalitData.xlsx';
      final file = File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.encode()!);

      await OpenFilex.open(path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel file saved and opened successfully: $path')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${Statics.getLabel('Information')} ($infoName)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: exportToExcel,
          ),
        ],
      ),
      body: groupedData.isEmpty
          ? Center(
        child: Text(
          Statics.getLabel('NoDataAvailable'),
          style: const TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: groupedData.entries.length,
        itemBuilder: (context, index) {
          final entry = groupedData.entries.elementAt(index);
          final title = entry.key;
          final items = entry.value;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ExpansionTile(
              initiallyExpanded: index == initiallyExpandedIndex,
              title: Text(
                "$title :  ${items.length}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, itemIndex) {
                        final item = items[itemIndex];
                        return ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${itemIndex + 1}) "),
                              Flexible(
                                child: Text(
                                  [
                                    if (item.mahanagar != null && item.mahanagar!.isNotEmpty) '${item.mahanagar}',
                                    if (item.vibhag != null && item.vibhag!.isNotEmpty) '${item.vibhag}',
                                    if (item.bhaag != null && item.bhaag!.isNotEmpty) '${item.bhaag}',
                                    if (item.nagar != null && item.nagar!.isNotEmpty) '${item.nagar}',
                                    if (item.vasti != null && item.vasti!.isNotEmpty) '${item.vasti}',
                                    if (item.mandal != null && item.mandal!.isNotEmpty) '${item.mandal}',
                                    if (item.gram != null && item.gram!.isNotEmpty) '${item.gram}',
                                    if (item.shakha != null && item.shakha!.isNotEmpty) '${item.shakha}',
                                  ].join(' -> '),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
