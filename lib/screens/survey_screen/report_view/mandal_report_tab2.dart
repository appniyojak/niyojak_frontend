import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/mandalVastisarvekshanReportModel.dart';
import '../../../models/response_model/nagar_vasti_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';
import '../../../widgets/single_column_row.dart';
import '../../../widgets/two_column_row.dart';

class MandalSurveyReportViewScreen2 extends StatefulWidget {
  static const String routeName = '/mandal-survey-report-tab2';

  const MandalSurveyReportViewScreen2({super.key});

  @override
  State<MandalSurveyReportViewScreen2> createState() => _MandalSurveyReportViewScreen2State();
}

class _MandalSurveyReportViewScreen2State extends State<MandalSurveyReportViewScreen2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm, fetchMode: GeoHierarchyFetchMode.mandalOnly);

    setState(() {});
    await populateDropdown();
  }

  bool _isExpanded = true;
  bool isVastiSearch = false;

  List<StaticMasterBAL>? _baithakTypes;

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    // print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  void resetData() async {
    setState(() {
      isVastiSearch = false;
      _isExpanded = false;
    });
    populateDropdown();
  }

  MandalVastisarvekshanReportModel? data;

  void getMyDetailsColumnsAndRows(String? selectedGeoUnitId, String? selctedLevel) async {
    data = await Statics.vastisarvekshanOnlyMandalReportData(context, Statics.userDetails["userID"], selectedGeoUnitId, selctedLevel);
    setState(() {});
  }

  void showPopupList(BuildContext context, String vastiStepStartedNames) {
    if (vastiStepStartedNames.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "${Statics.getLabel('vastiNotAvailable')}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }

    final List<String> namesList = vastiStepStartedNames.split('::').map((e) => e.trim()).toList();

    if (namesList.isEmpty || namesList.first.isEmpty) {
      Fluttertoast.showToast(
        msg: "${Statics.getLabel('vastiNotAvailable')}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.maxFinite,
          height: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.list_alt, color: Colors.purpleAccent),
                  SizedBox(width: 10),
                  Text(
                    "${Statics.getLabel('vastiYaadi')}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 1, height: 20),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 6,
                  radius: Radius.circular(10),
                  child: ListView.builder(
                    itemCount: namesList.length,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1})  ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              namesList[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: Text("${Statics.getLabel('bandKara')}"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Sajjanshakkati>> groupedData = {};

    if (data?.sajjanshakkati != null && data!.sajjanshakkati!.isNotEmpty) {
      for (var item in data!.sajjanshakkati!) {
        final key = item.sajjanshakkati;
        if (key != null) {
          groupedData.putIfAbsent(key, () => []).add(item);
        }
      }
    }

    final Map<String, List<Anyaprabhavilok>> groupedDataAnyaPrabhaviLok = {};

    if (data?.anyaprabhavilok != null && data!.anyaprabhavilok!.isNotEmpty) {
      for (var item in data!.anyaprabhavilok!) {
        final key = item.sajjanshakkati;
        if (key != null) {
          groupedDataAnyaPrabhaviLok.putIfAbsent(key, () => []).add(item);
        }
      }
    }

    // Get unique subvalue list
    final subvalues = data?.durjanshakti!.map((e) => e.subvalue).toSet().toList();

    // Get unique value list
    final values = data?.durjanshakti!.map((e) => e.value).toSet().toList();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              mandalDropdown(),
//===================================================================================================================================================

              if (isVastiSearch == true) Divider(),
              // if (isVastiSearch == true)
              //   Container(
              //     child: SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: DataTable(
              //         headingRowColor:
              //             MaterialStateProperty.all(Colors.teal.shade100),
              //         headingTextStyle: const TextStyle(
              //             fontSize: 15,
              //             color: Colors.black,
              //             fontWeight: FontWeight.bold),
              //         columns: [
              //           DataColumn(
              //               label: Text(
              //                   "${Statics.getLabel('sarvekshanSthiti')}")),
              //           DataColumn(
              //               label: Text("${Statics.getLabel('Mandal')}")),
              //           DataColumn(label: Text("${Statics.getLabel('gaav')}")),
              //           DataColumn(label: Text('')),
              //         ],
              //         rows: [
              //           DataRow(
              //             color:
              //                 MaterialStateProperty.all(Colors.green.shade50),
              //             cells: [
              //               DataCell(Text(
              //                   "${Statics.getLabel('prathamikSurveyComplete')}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.mandalStep1CompleteCount ?? ""}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.gramStep1CompleteCount ?? ""}")),
              //               DataCell(IconButton(
              //                 icon: Icon(Icons.remove_red_eye,
              //                     color: Colors.teal),
              //                 onPressed: () {
              //                   showPopupList(
              //                       context,
              //                       data!.mandalVastisarvekshanReportwithname!
              //                           .gramStep1CompleteNames!
              //                           .toString());
              //                 },
              //               )),
              //             ],
              //           ),
              //           DataRow(
              //             color:
              //                 MaterialStateProperty.all(Colors.green.shade50),
              //             cells: [
              //               DataCell(Text(
              //                   "${Statics.getLabel('vistrutSurveyComplete')}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.mandalStep3CompleteCount ?? ""}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.gramStep3CompleteCount ?? ""}")),
              //               DataCell(IconButton(
              //                 icon: Icon(Icons.remove_red_eye,
              //                     color: Colors.teal),
              //                 onPressed: () {
              //                   showPopupList(
              //                       context,
              //                       data!.mandalVastisarvekshanReportwithname!
              //                           .gramStep3CompleteNames!
              //                           .toString());
              //                 },
              //               )),
              //             ],
              //           ),
              //           DataRow(
              //             color:
              //                 MaterialStateProperty.all(Colors.orange.shade50),
              //             cells: [
              //               DataCell(
              //                   Text("${Statics.getLabel('surveyStart')}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.mandalStepStartedCount ?? ""}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.gramStepStartedCount ?? ""}")),
              //               DataCell(IconButton(
              //                 icon: Icon(Icons.remove_red_eye,
              //                     color: Colors.teal),
              //                 onPressed: () {
              //                   showPopupList(
              //                       context,
              //                       data!.mandalVastisarvekshanReportwithname!
              //                           .gramStepStartedNames!
              //                           .toString());
              //                 },
              //               )),
              //             ],
              //           ),
              //           DataRow(
              //             color:
              //                 MaterialStateProperty.all(Colors.orange.shade50),
              //             cells: [
              //               DataCell(
              //                   Text("${Statics.getLabel('surveyComplete')}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.mandalAllStepsCompleteCount ?? ""}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.gramAllStepsCompleteCount ?? ""}")),
              //               DataCell(IconButton(
              //                 icon: Icon(Icons.remove_red_eye,
              //                     color: Colors.teal),
              //                 onPressed: () {
              //                   showPopupList(
              //                       context,
              //                       data!.mandalVastisarvekshanReportwithname!
              //                           .gramAllStepsCompleteNames!
              //                           .toString());
              //                 },
              //               )),
              //             ],
              //           ),
              //           DataRow(
              //             color:
              //                 MaterialStateProperty.all(Colors.orange.shade50),
              //             cells: [
              //               DataCell(Text(
              //                   "${Statics.getLabel('surveyNotStarted')}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.mandalStepsNotstartedCount ?? ""}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.gramStepsNotstartedCount ?? ""}")),
              //               DataCell(IconButton(
              //                 icon: Icon(Icons.remove_red_eye,
              //                     color: Colors.teal),
              //                 onPressed: () {
              //                   showPopupList(
              //                       context,
              //                       data!.mandalVastisarvekshanReportwithname!
              //                           .gramStepsNotstartedNames!
              //                           .toString());
              //                 },
              //               )),
              //             ],
              //           ),
              //           DataRow(
              //             color:
              //                 MaterialStateProperty.all(Colors.grey.shade200),
              //             cells: [
              //               DataCell(Text("${Statics.getLabel('Total')}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.mandalcount ?? ""}")),
              //               DataCell(Text(
              //                   "${data?.mandalVastisarvekshanReportwithname?.gramcount ?? ""}")),
              //               DataCell(Text("-")),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              if (isVastiSearch == true)
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.blueAccent),
                      headingTextStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      columns: [
                        DataColumn(label: Text("${Statics.getLabel('sarvekshanSthiti')}")),
                        DataColumn(label: Text("${Statics.getLabel('taalukaa')}")),
                        DataColumn(label: Text("${Statics.getLabel('Mandal')}")),
                        DataColumn(label: Text("${Statics.getLabel('gaav')}")),
                        DataColumn(label: Text('')),
                      ],
                      rows: [
                        DataRow(
                          color: MaterialStateProperty.all(Colors.orange.shade50),
                          cells: [
                            DataCell(Text("${Statics.getLabel('surveyStart')}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStepStartedCount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStepStartedCount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStepStartedCount ?? ""}")),
                            DataCell(IconButton(
                              icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                              onPressed: () => showPopupList(context, data!.mandalVastisarvekshanReportwithname!.gramStepStartedNames!.toString()),
                            )),
                          ],
                        ),
                        DataRow(
                          color: MaterialStateProperty.all(Colors.orange.shade50),
                          cells: [
                            DataCell(Text("${Statics.getLabel('surveyComplete')}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramAllStepsCompleteCount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramAllStepsCompleteCount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramAllStepsCompleteCount ?? ""}")),
                            DataCell(IconButton(
                              icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                              onPressed: () => showPopupList(context, data!.mandalVastisarvekshanReportwithname!.gramAllStepsCompleteNames!.toString()),
                            )),
                          ],
                        ),
                        DataRow(
                          color: MaterialStateProperty.all(Colors.orange.shade50),
                          cells: [
                            DataCell(Text("${Statics.getLabel('surveyNotStarted')}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStepsNotstartedCount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStepsNotstartedCount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStepsNotstartedCount ?? ""}")),
                            DataCell(IconButton(
                              icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                              onPressed: () => showPopupList(context, data!.mandalVastisarvekshanReportwithname!.gramStepsNotstartedNames!.toString()),
                            )),
                          ],
                        ),
                        DataRow(
                          color: MaterialStateProperty.all(Colors.grey.shade200),
                          cells: [
                            DataCell(Text("${Statics.getLabel('Total')}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramcount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramcount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramcount ?? ""}")),
                            DataCell(Text("-")),
                          ],
                        ),
                        DataRow(
                          color: MaterialStateProperty.all(Colors.white),
                          cells: [
                            DataCell(Text("")),
                            DataCell(Text("")),
                            DataCell(Text("")),
                            DataCell(Text("")),
                            DataCell(Text("")),
                          ],
                        ),
                        DataRow(
                          color: MaterialStateProperty.all(Colors.teal.shade100),
                          cells: [
                            DataCell(
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity, // makes it span available width
                                child: Text("${Statics.getLabel('surveyStart')} ${Statics.getLabel('Status')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                              ),
                            ),
                            DataCell(
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity, // makes it span available width
                                child: Text("${Statics.getLabel('taalukaa')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                              ),
                            ),
                            DataCell(
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity, // makes it span available width
                                child: Text("${Statics.getLabel('Mandal')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                              ),
                            ),
                            DataCell(
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity, // makes it span available width
                                child: Text("${Statics.getLabel('gaav')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16)),
                              ),
                            ),
                            DataCell.empty,
                          ],
                        ),
                        DataRow(
                          color: MaterialStateProperty.all(Colors.green.shade50),
                          cells: [
                            DataCell(Text("${Statics.getLabel('prathamikSurveyComplete')}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStep1CompleteCount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStep1CompleteCount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStep1CompleteCount ?? ""}")),
                            DataCell(IconButton(
                              icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                              onPressed: () => showPopupList(context, data!.mandalVastisarvekshanReportwithname!.gramStep1CompleteNames!.toString()),
                            )),
                          ],
                        ),
                        DataRow(
                          color: MaterialStateProperty.all(Colors.green.shade50),
                          cells: [
                            DataCell(Text("${Statics.getLabel('vistrutSurveyComplete')}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStep3CompleteCount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStep3CompleteCount ?? ""}")),
                            DataCell(Text("${data?.mandalVastisarvekshanReportwithname?.gramStep3CompleteCount ?? ""}")),
                            DataCell(IconButton(
                              icon: Icon(Icons.remove_red_eye, color: Colors.teal),
                              onPressed: () => showPopupList(context, data!.mandalVastisarvekshanReportwithname!.gramStep3CompleteNames!.toString()),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
//===================================================================================================================================================
//               Container(
//                 margin: EdgeInsets.symmetric(
//                   horizontal: 10,
//                 ),
//                 child: Column(
//                   children: [
//                     commonExpansionTile(
//                       title: 'VastisurveuAbhiyanStithi',
//                       children: [
//                         // Container(
//                         //   height: 500,
//                         //   decoration: BoxDecoration(
//                         //     border: Border.all(color: Colors.grey.shade300),
//                         //     borderRadius: BorderRadius.circular(8),
//                         //   ),
//                         //   child: SingleChildScrollView(
//                         //     child: ListView.builder(
//                         //       shrinkWrap: true,
//                         //       physics: NeverScrollableScrollPhysics(),
//                         //       itemCount: data?.mandaldata?.length ?? 0,
//                         //       itemBuilder: (context, index) {
//                         //         final data =
//                         //             nagarVastisarvekshanReportwithnamedata?[
//                         //                 index];
//                         //         return Column(
//                         //           crossAxisAlignment: CrossAxisAlignment.start,
//                         //           children: [
//                         //             Padding(
//                         //               padding:
//                         //                   const EdgeInsets.symmetric(vertical: 8),
//                         //               child: Center(
//                         //                 child: Text(
//                         //                   data.name ??
//                         //                       "${Statics.getLabel('nagarVastiName')}",
//                         //                   style: TextStyle(
//                         //                       fontSize: 18,
//                         //                       fontWeight: FontWeight.bold),
//                         //                 ),
//                         //               ),
//                         //             ),
//                         //             DataTable(
//                         //               headingRowColor: MaterialStateProperty.all(
//                         //                   Colors.purpleAccent.shade100),
//                         //               headingTextStyle: TextStyle(
//                         //                   fontSize: 15,
//                         //                   color: Colors.black,
//                         //                   fontWeight: FontWeight.bold),
//                         //               columns: [
//                         //                 DataColumn(
//                         //                     label: Text(
//                         //                         "${Statics.getLabel('sarvekshanSthiti')}")),
//                         //                 DataColumn(
//                         //                     label: Text(
//                         //                         "${Statics.getLabel('NagarShahari')}")),
//                         //                 DataColumn(
//                         //                     label: Text(
//                         //                         "${Statics.getLabel('Vasti')}")),
//                         //               ],
//                         //               rows: [
//                         //                 DataRow(
//                         //                   color: MaterialStateProperty.all(
//                         //                       Colors.lightBlue.shade50),
//                         //                   cells: [
//                         //                     DataCell(Text(
//                         //                         "${Statics.getLabel('prathamikSurveyComplete')}")),
//                         //                     DataCell(Text(
//                         //                         "${data.nagarStep1CompleteCount ?? ""}")),
//                         //                     DataCell(Text(
//                         //                         "${data.vastiStep1CompleteCount ?? ""}")),
//                         //                   ],
//                         //                 ),
//                         //                 DataRow(
//                         //                   color: MaterialStateProperty.all(
//                         //                       Colors.lightBlue.shade50),
//                         //                   cells: [
//                         //                     DataCell(Text(
//                         //                         "${Statics.getLabel('otherSuerveyComplete')}")),
//                         //                     DataCell(Text(
//                         //                         "${data.nagarStep2CompleteCount ?? ""}")),
//                         //                     DataCell(Text(
//                         //                         "${data.vastiStep2CompleteCount ?? ""}")),
//                         //                   ],
//                         //                 ),
//                         //                 DataRow(
//                         //                   color: MaterialStateProperty.all(
//                         //                       Colors.lightBlue.shade50),
//                         //                   cells: [
//                         //                     DataCell(Text(
//                         //                         "${Statics.getLabel('vistrutSurveyComplete')}")),
//                         //                     DataCell(Text(
//                         //                         "${data.nagarStep3CompleteCount ?? ""}")),
//                         //                     DataCell(Text(
//                         //                         "${data.vastiStep3CompleteCount ?? ""}")),
//                         //                   ],
//                         //                 ),
//                         //                 DataRow(
//                         //                   color: MaterialStateProperty.all(
//                         //                       Colors.red.shade50),
//                         //                   cells: [
//                         //                     DataCell(Text(
//                         //                         "${Statics.getLabel('surveyStart')}")),
//                         //                     DataCell(Text(
//                         //                         "${data.nagarStepStartedCount ?? ""}")),
//                         //                     DataCell(Text(
//                         //                         "${data.vastiStepStartedCount ?? ""}")),
//                         //                   ],
//                         //                 ),
//                         //                 DataRow(
//                         //                   color: MaterialStateProperty.all(
//                         //                       Colors.red.shade50),
//                         //                   cells: [
//                         //                     DataCell(Text(
//                         //                         "${Statics.getLabel('surveyComplete')}")),
//                         //                     DataCell(Text(
//                         //                         "${data.nagarAllStepsCompleteCount ?? ""}")),
//                         //                     DataCell(Text(
//                         //                         "${data.vastiAllStepsCompleteCount ?? ""}")),
//                         //                   ],
//                         //                 ),
//                         //                 DataRow(
//                         //                   color: MaterialStateProperty.all(
//                         //                       Colors.red.shade50),
//                         //                   cells: [
//                         //                     DataCell(Text(
//                         //                         "${Statics.getLabel('surveyNotStarted')}")),
//                         //                     DataCell(Text(
//                         //                         "${data.nagarStepsNotstartedCount ?? ""}")),
//                         //                     DataCell(Text(
//                         //                         "${data.vastiStepsNotstartedCount ?? ""}")),
//                         //                   ],
//                         //                 ),
//                         //                 DataRow(
//                         //                   color: MaterialStateProperty.all(
//                         //                       Colors.yellow.shade50),
//                         //                   cells: [
//                         //                     DataCell(Text(
//                         //                         "${Statics.getLabel('Total')}")),
//                         //                     DataCell(
//                         //                         Text("${data.nagarcount ?? ""}")),
//                         //                     DataCell(
//                         //                         Text("${data.vasticount ?? ""}")),
//                         //                   ],
//                         //                 ),
//                         //               ],
//                         //             ),
//                         //             Divider(thickness: 2),
//                         //           ],
//                         //         );
//                         //       },
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//===================================================================================================================================================
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    commonExpansionTile(
                      title: 'mandalSurveySankalan',
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              SingleColumnRow(txtString: "${Statics.getLabel("mandalName")}", value: "${data?.mandaldata?.mandalname}", fontsize: 15),
                              SingleColumnRow(txtString: "${Statics.getLabel("talukaName")}", value: "${data?.mandaldata?.nagarname}", fontsize: 15),
                              SingleColumnRow(txtString: "${Statics.getLabel("zilhaName")}", value: "${data?.mandaldata?.bhagname}", fontsize: 15),
                              SingleColumnRow(txtString: "${Statics.getLabel("vibhagName")}", value: "${data?.mandaldata?.vibhagname}", fontsize: 15),
                              SingleColumnRow(txtString: "${Statics.getLabel("mandalPramukhacheNaav")}", value: "${data?.mandaldata?.mandalPramukhName}", fontsize: 15),
                              SingleColumnRow(txtString: "${Statics.getLabel("gavanchiSankhya")}", value: "${data?.mandaldata?.gavachiSankhya}", fontsize: 15),
                              SingleColumnRow(txtString: "${Statics.getLabel("mumbaikarGaav")}", value: "${data?.mandaldata?.mumbaikarCount}", fontsize: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
//===================================================================================================================================================
                    commonExpansionTile(
                      title: 'sewaPrakalpa',
                      children: [
                        if (data != null && data?.sewaPrakalpa != null) buildSewaPrakalpaDataTable(data!.sewaPrakalpa!),
                      ],
                    ),
                  ],
                ),
              ),
//===================================================================================================================================================
              commonExpansionTile(
                title: 'karyamahiti',
                children: [
                  if (data != null && data != null)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.purpleAccent[200],
                          ),
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          columns: [
                            DataColumn(
                              label: Expanded(
                                child: Center(
                                  child: Text(
                                    "${Statics.getLabel('karyaSankhya')}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Center(
                                  child: Text(
                                    "${Statics.getLabel('kitiGaavat')}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Center(
                                  child: Text(
                                    "${Statics.getLabel('chalavnareCount')}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          rows: [
                            DataRow(
                              cells: [
                                DataCell(
                                  Center(
                                    child: Text(
                                      data!.vividhKshetaCheKam![0].sankhya.toString(),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      data!.vividhKshetaCheKam![0].gramCount.toString(),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      data!.vividhKshetaCheKam![0].value.toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
//===================================================================================================================================================
              commonExpansionTile(
                title: 'satsangKendra',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.vividhSampradhaySatsang != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('saampradaay')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('TotalGraamCount')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.vividhSampradhaySatsang!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.value ?? ''))),
                                      DataCell(Center(child: Text(item.gramCount.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
//===================================================================================================================================================
              commonExpansionTile(
                title: 'SwayamsevakCount',
                children: [
                  SingleColumnRow(txtString: Statics.getLabel('TotalKaaryakartaaCount'), value: data?.loksankhyaformandal?.totalKaaryakartaaCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('PratidnyitCount'), value: data?.loksankhyaformandal?.pratidnyitCount.toString(), fontsize: 15),
                ],
              ),
              commonExpansionTile(
                title: 'SwayamsevakCountByAge',
                children: [
                  SingleColumnRow(txtString: Statics.getLabel('Shishu'), value: data?.loksankhyaformandal?.shishuCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('Baal'), value: data?.loksankhyaformandal?.baalCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('TarunVidyaarthi'), value: data?.loksankhyaformandal?.tarunVidyaarthiCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('TarunVyavasaayee'), value: data?.loksankhyaformandal?.tarunVyavasaayeeCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('ProudhVyavasaayee'), value: data?.loksankhyaformandal?.proudhaVyavasaayeeCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('UnkownAge'), value: data?.loksankhyaformandal?.unknownAgeCount.toString(), fontsize: 15),
                ],
              ),
              commonExpansionTile(
                title: 'ShikshitSwayamsevakCount',
                children: [
                  SingleColumnRow(txtString: Statics.getLabel('PrarambhikShikshit'), value: data?.loksankhyaformandal?.prarambhikShikshitCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('PraathamikShikshit'), value: data?.loksankhyaformandal?.praathamikShikshitCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('PrathamVarshShikshit'), value: data?.loksankhyaformandal?.prathamVarshaShikshitCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('DwitiyaVarshShikshit'), value: data?.loksankhyaformandal?.dwitiyaVarshaShikshitCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('TrutiyaVarshShikshit'), value: data?.loksankhyaformandal?.trutiyaVarshaShikshitCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('NoShikshan'), value: data?.loksankhyaformandal?.noShikshanCount.toString(), fontsize: 15),
                ],
              ),
              commonExpansionTile(
                title: 'KaaryakartaaCountByLevel',
                children: [
                  TwoColumnRow(
                    txtString: Statics.getLabel('Shaakhaa'),
                    value: data?.loksankhyaformandal?.dailyShaakhaaKaaryakartaaCount.toString(),
                    txtString2: Statics.getLabel('SaaptaahikLabelShort'),
                    value2: data?.loksankhyaformandal?.saaptaahikMilanKaaryakartaaCount.toString(),
                    fontsize: 15,
                  ),
                  TwoColumnRow(
                    txtString: Statics.getLabel('MilanMandali'),
                    value: data?.loksankhyaformandal?.maasikMilanKaaryakartaaCount.toString(),
                    txtString2: Statics.getLabel('VastiKaaryakartaaCount'),
                    value2: data?.loksankhyaformandal?.vastiKaaryakartaaCount.toString(),
                    fontsize: 15,
                  ),
                  TwoColumnRow(
                    txtString: Statics.getLabel('GraamKaaryakartaaCount'),
                    value: data?.loksankhyaformandal?.graamKaaryakartaaCount.toString(),
                    txtString2: Statics.getLabel('MandalKaaryakartaaCount'),
                    value2: data?.loksankhyaformandal?.mandalKaaryakartaaCount.toString(),
                    fontsize: 15,
                  ),
                  TwoColumnRow(
                    txtString: Statics.getLabel('NagarKaaryakartaaCount'),
                    value: data?.loksankhyaformandal?.nagarKaaryakartaaCount.toString(),
                    txtString2: Statics.getLabel('ShaharKaaryakartaaCount'),
                    value2: data?.loksankhyaformandal?.shaharKaaryakartaaCount.toString(),
                    fontsize: 15,
                  ),
                  TwoColumnRow(
                    txtString: Statics.getLabel('BhaagKaaryakartaaCount'),
                    value: data?.loksankhyaformandal?.bhaagKaaryakartaaCount.toString(),
                    txtString2: Statics.getLabel('VibhaagKaaryakartaaCount'),
                    value2: data?.loksankhyaformandal?.vibhaagKaaryakartaaCount.toString(),
                    fontsize: 15,
                  ),
                  TwoColumnRow(
                    txtString: Statics.getLabel('MahaanagarKaaryakartaaCount'),
                    value: data?.loksankhyaformandal?.mahaanagarKaaryakartaaCount.toString(),
                    txtString2: Statics.getLabel('PraantKaaryakartaaCount'),
                    value2: data?.loksankhyaformandal?.praantKaaryakartaaCount.toString(),
                    fontsize: 15,
                  ),
                  TwoColumnRow(
                    txtString: Statics.getLabel('KshetraKaaryakartaaCount'),
                    value: data?.loksankhyaformandal?.kshetraKaaryakartaaCount.toString(),
                    txtString2: Statics.getLabel('AkhilBhaaratiyaKaaryakartaaCount'),
                    value2: data?.loksankhyaformandal?.akhilBhaaratiyaKaaryakartaaCount.toString(),
                    fontsize: 15,
                  ),
                  TwoColumnRow(
                    txtString: Statics.getLabel('PravaaseeKaaryakartaaCount'),
                    value: data?.loksankhyaformandal?.pravaaseeKaaryakartaaCount.toString(),
                    txtString2: Statics.getLabel('TotalKaaryakartaaCount'),
                    value2: data?.loksankhyaformandal?.totalKaaryakartaaCount.toString(),
                    fontsize: 15,
                  ),
                ],
              ),
              commonExpansionTile(
                title: 'GatividhiAayaamSansthaaKaaryakartaaCount',
                children: [
                  SingleColumnRow(txtString: Statics.getLabel('GatividhiKaaryakartaaCount'), value: data?.loksankhyaformandal?.gatividhiKaaryakartaaCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('AayaamKaaryakartaaCount'), value: data?.loksankhyaformandal?.aayaamKaaryakartaaCount.toString(), fontsize: 15),
                  SingleColumnRow(
                      txtString: Statics.getLabel('SanghaPreritSansthaaKaaryakartaaCount'), value: data?.loksankhyaformandal?.sanghaPreritSansthaaKaaryakartaaCount.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('SocialOrganizationKaaryakartaaCount'), value: data?.loksankhyaformandal?.socialOrganizationKaaryakartaaCount.toString(), fontsize: 15),
                ],
              ),
              commonExpansionTile(
                title: 'Gatividhi',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.kaaryakartaaCountByGatividhi != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          'गतिविधी',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('count')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.kaaryakartaaCountByGatividhi!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.gatividhiName ?? ''))),
                                      DataCell(Center(child: Text(item.kaaryakartaaCount.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
              commonExpansionTile(
                title: 'Aayaam',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.kaaryakartaaCountByAayaam != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('Aayaam')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('count')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.kaaryakartaaCountByAayaam!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.aayaamName ?? ''))),
                                      DataCell(Center(child: Text(item.kaaryakartaaCount.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
              commonExpansionTile(
                title: 'Sangha-PreritSansthaa',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.sanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('sanghaPreritSanghatana')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('count')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.sanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.areaOfOperation ?? ''))),
                                      DataCell(Center(child: Text(item.kaaryakartaaCount.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
              commonExpansionTile(
                title: 'OtherSocialOrganization',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.socialOrganizationKaaryakartaaCountByAreaOfOperation != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('OtherSocialOrganization')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('count')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.socialOrganizationKaaryakartaaCountByAreaOfOperation!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.studentCategoryName ?? ''))),
                                      DataCell(Center(child: Text(item.countByStudentCategory.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
              commonExpansionTile(
                title: 'StudentCategory',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.swayamsevakCountByStudentCategory != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('StudentCategory')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('count')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.swayamsevakCountByStudentCategory!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.studentCategoryName ?? ''))),
                                      DataCell(Center(child: Text(item.countByStudentCategory.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
              commonExpansionTile(
                title: 'VyavasaayeeCategory',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.listSwayamsevakCountByVyavasaayeeCategory != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('VyavasaayeeCategory')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('count')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.listSwayamsevakCountByVyavasaayeeCategory!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.vyavasaayeeCategoryName ?? ''))),
                                      DataCell(Center(child: Text(item.countByVyavasaayeeCategory.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
//===================================================================================================================================================
              commonExpansionTile(
                title: 'Population',
                children: [
                  Text(Statics.getLabel("gaavachiLoksankhya"), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent, fontSize: 20)),
                  Divider(),
                  SingleColumnRow(txtString: Statics.getLabel('moreThan40000'), value: data?.mandaldata?.greaterthen4000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('20000to40000'), value: data?.mandaldata?.between2000And4000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('10000to20000'), value: data?.mandaldata?.between1000And2000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('5000to10000'), value: data?.mandaldata?.between5000And10000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('3000to5000'), value: data?.mandaldata?.between3000And5000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('1000to3000'), value: data?.mandaldata?.between1000And3000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('1000to3000'), value: data?.mandaldata?.lessThan1000.toString(), fontsize: 15),
                  Text(Statics.getLabel("purushLoksankhya"), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent, fontSize: 20)),
                  Divider(),
                  SingleColumnRow(txtString: Statics.getLabel('moreThan40000'), value: data?.mandaldata?.maleCountgreaterthen4000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('20000to40000'), value: data?.mandaldata?.maleCountBetween2000And4000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('10000to20000'), value: data?.mandaldata?.maleCountBetween1000And2000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('5000to10000'), value: data?.mandaldata?.maleCountBetween5000And10000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('3000to5000'), value: data?.mandaldata?.maleCountBetween3000And5000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('1000to3000'), value: data?.mandaldata?.maleCountBetween1000And3000.toString(), fontsize: 15),
                  SingleColumnRow(txtString: Statics.getLabel('1000to3000'), value: data?.mandaldata?.maleCountLessThan1000.toString(), fontsize: 15),
                ],
              ),
//===================================================================================================================================================
              commonExpansionTile(
                title: 'religion',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.religion != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('religion')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('GraamCount')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.religion!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.value ?? ''))),
                                      DataCell(Center(child: Text(item.gramCount.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),

//===================================================================================================================================================
              commonExpansionTile(
                title: 'SajjanShakti',
                children: [
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView(
                      children: groupedData.entries.map((entry) {
                        final sajjanType = entry.key;
                        final data = entry.value;

                        // Unique prabhavishetra & samparkashiti
                        final prabhavishetraList = {...data.map((e) => e.prabhavishetra).toSet()}.toList();
                        final samparkList = {...data.map((e) => e.samparkashiti).toSet()}.toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                "${Statics.getLabel('SajjanShakti')} (${sajjanType})",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Table(
                              border: TableBorder.all(),
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              children: [
                                // Header Row
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.purpleAccent.shade200, // Header background
                                  ),
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          '${Statics.getLabel('SajjanShakti')} ${Statics.getLabel('samparkSthiti')}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    ...prabhavishetraList.map((header) => Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            header!,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  ],
                                ),
                                // Data Rows
                                ...samparkList.map((sampark) {
                                  return TableRow(
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(sampark!),
                                        ),
                                      ),
                                      ...prabhavishetraList.map((prabhav) {
                                        final match = data.firstWhere(
                                          (item) => item.samparkashiti == sampark && item.prabhavishetra == prabhav,
                                          orElse: () => Sajjanshakkati(),
                                        );
                                        return Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text('${match.vasticnt ?? ''}'),
                                        );
                                      }),
                                    ],
                                  );
                                }).toList(),
                                // Total Row
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.grey.shade200),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        "${Statics.getLabel('Total')}",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ...prabhavishetraList.map((prabhav) {
                                      final total = data.where((item) => item.prabhavishetra == prabhav).fold<int>(0, (sum, item) => sum + (item.vasticnt ?? 0));

                                      return Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          '$total',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
// ===================================================================================================================================================
              commonExpansionTile(
                title: 'anyaPrabhaviLok',
                children: [
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView(
                      children: groupedDataAnyaPrabhaviLok.entries.map((entry) {
                        final sajjanType = entry.key;
                        final data = entry.value;

                        // Unique prabhavishetra & samparkashiti
                        final prabhavishetraList = {...data.map((e) => e.prabhavishetra).toSet()}.toList();
                        final samparkList = {...data.map((e) => e.samparkashiti).toSet()}.toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                "${Statics.getLabel('anyaPrabhaviLok')} (${sajjanType})",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Table(
                              border: TableBorder.all(),
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              children: [
                                // Header Row
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.purpleAccent.shade200, // Header background
                                  ),
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          '${Statics.getLabel('anyaPrabhaviLok')} ${Statics.getLabel('samparkSthiti')}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    ...prabhavishetraList.map((header) => Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            header!,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  ],
                                ),
                                // Data Rows
                                ...samparkList.map((sampark) {
                                  return TableRow(
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(sampark!),
                                        ),
                                      ),
                                      ...prabhavishetraList.map((prabhav) {
                                        final match = data.firstWhere(
                                          (item) => item.samparkashiti == sampark && item.prabhavishetra == prabhav,
                                          orElse: () => Anyaprabhavilok(),
                                        );
                                        return Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text('${match.vasticnt ?? ''}'),
                                        );
                                      }),
                                    ],
                                  );
                                }).toList(),
                                // Total Row
                                TableRow(
                                  decoration: BoxDecoration(color: Colors.grey.shade200),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        "${Statics.getLabel('Total')}",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ...prabhavishetraList.map((prabhav) {
                                      final total = data.where((item) => item.prabhavishetra == prabhav).fold<int>(0, (sum, item) => sum + (item.vasticnt ?? 0));

                                      return Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          '$total',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
// ===================================================================================================================================================
              commonExpansionTile(
                title: 'UpsanaSthal',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.upaasana != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('UpsanaSthal')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('count')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('GraamCount')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.upaasana!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.value ?? ''))),
                                      DataCell(Center(child: Text(item.sankhya.toString()))),
                                      DataCell(Center(child: Text(item.gramCount.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
// ===================================================================================================================================================
              commonExpansionTile(
                title: 'GavatsajareHonareSan',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.mahatvacesana != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('SelectFrequency')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('count')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('GraamCount')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.mahatvacesana!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.value ?? ''))),
                                      DataCell(Center(child: Text(item.sankhya.toString()))),
                                      DataCell(Center(child: Text(item.gramCount.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
// ===================================================================================================================================================
              commonExpansionTile(
                title: 'GavatHonareKaryakram',
                children: [
                  Container(
                    // height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        if (data != null && data?.samajikkaryakram != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: DataTable(
                                headingRowColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.purpleAccent[200],
                                ),
                                headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('SelectFrequency')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('count')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                      child: Center(
                                        child: Text(
                                          "${Statics.getLabel('GraamCount')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: data!.samajikkaryakram!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Center(child: Text(item.value ?? ''))),
                                      DataCell(Center(child: Text(item.sankhya.toString()))),
                                      DataCell(Center(child: Text(item.gramCount.toString()))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    )),
                  ),
                ],
              ),
// ===================================================================================================================================================
              commonExpansionTile(
                title: 'DurjanShakti',
                children: [
                  if (data != null && data?.durjanshakti != null)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.purpleAccent.shade100),
                        columns: [
                          DataColumn(label: Text(Statics.getLabel("DurjanShakti"))),
                          ...subvalues!.map((sub) => DataColumn(label: Text(sub!))),
                        ],
                        rows: values!.map((val) {
                          return DataRow(cells: [
                            DataCell(Text(val!)),
                            ...subvalues.map((sub) {
                              final match = data?.durjanshakti!.firstWhere(
                                (e) => e.value == val && e.subvalue == sub,
                                // orElse: () => {"gramCount": 0},
                              );
                              return DataCell(Text(match!.gramCount.toString()));
                            })
                          ]);
                        }).toList(),
                      ),
                    ),
                ],
              ),
// ===================================================================================================================================================
              commonExpansionTile(
                title: 'HinduVeer',
                children: [
                  SingleChildScrollView(
                      child: Column(
                    children: [
                      if (data != null && data!.hinduvirayadi != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal, // horizontal scroll
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.purpleAccent[200],
                              ),
                              headingTextStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              columns: [
                                DataColumn(
                                  label: Expanded(
                                    child: Center(
                                      child: Text(
                                        "${Statics.getLabel('hinduVeerCount')}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Center(
                                      child: Text(
                                        "${Statics.getLabel('GraamCount')}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              rows: data!.hinduvirayadi!.map((item) {
                                return DataRow(
                                  cells: [
                                    DataCell(Center(child: Text(item.sankhya.toString()))),
                                    DataCell(Center(child: Text(item.gramCount.toString()))),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  )),
                ],
              ),
// ===================================================================================================================================================
            ],
          ),
        ),
      ),
    );
  }

  Widget mandalDropdown() {
    return Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _isExpanded = isExpanded;
                });
              },
              dividerColor: Colors.black,
              expandIconColor: Colors.purpleAccent,
              elevation: 0,
              children: [
                ExpansionPanel(
                  backgroundColor: Colors.transparent,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text("${Statics.getLabel('selectStar')}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      trailing: IconButton(
                          onPressed: () {
                            resetData();
                            ctrl.loadHierarchyForUser(fetchMode: GeoHierarchyFetchMode.mandalOnly);
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.purpleAccent,
                          )),
                    );
                  },
                  body: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      spacing: 10,
                      children: [
                        // GeoDropdownWidget(
                        //   level: GeoLevel.Mahaanagar,
                        //   title: 'Mahaanagar',
                        //   controller: ctrl,
                        //   fetchMode: GeoHierarchyFetchMode.mandalOnly,
                        // ),

                        // if (ctrl.hasItems(GeoLevel.vibhaag))
                        GeoDropdownWidget(
                          level: GeoLevel.Vibhaag,
                          title: 'Vibhaag',
                          controller: ctrl,
                          fetchMode: GeoHierarchyFetchMode.mandalOnly,
                        ),

                        if (ctrl.hasItems(GeoLevel.Bhaag))
                          GeoDropdownWidget(
                            level: GeoLevel.Bhaag,
                            title: 'Bhaag',
                            controller: ctrl,
                            fetchMode: GeoHierarchyFetchMode.mandalOnly,
                          ),

                        if (ctrl.hasItems(GeoLevel.Nagar))
                          GeoDropdownWidget(
                            level: GeoLevel.Nagar,
                            title: 'Nagar',
                            controller: ctrl,
                            fetchMode: GeoHierarchyFetchMode.mandalOnly,
                          ),

                        /// CONDITIONAL
                        if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                          GeoDropdownWidget(
                            level: GeoLevel.upnagarUpkhanda,
                            title: 'upnagarUpkhanda',
                            controller: ctrl,
                          ),

                        if (ctrl.hasItems(GeoLevel.Mandal))
                          GeoDropdownWidget(
                            level: GeoLevel.Mandal,
                            title: 'Mandal',
                            controller: ctrl,
                          ),
                        if (ctrl.deepestSelectedLevelId == 4)
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                              onPressed: () {
                                setState(() {
                                  isVastiSearch = true;
                                  _isExpanded = false;
                                });
                                getMyDetailsColumnsAndRows(ctrl.deepestSelectedGeoUnitId, ctrl.deepestSelectedLevelName);
                              },
                              child: Text("${Statics.getLabel('Filters')}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          )
                      ],
                    ),
                  ),
                  isExpanded: _isExpanded,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          if (ctrl.deepestSelectedLevelId == 4 && ctrl.deepestSelectedGeoUnitName != null && ctrl.deepestSelectedGeoUnitName != "" && isVastiSearch == true) SizedBox(height: 20),
          if (ctrl.deepestSelectedLevelId == 4 && ctrl.deepestSelectedGeoUnitName != null && ctrl.deepestSelectedGeoUnitName != "" && isVastiSearch == true)
            Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purpleAccent, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "मंडल ->  ",
                      style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      " ${ctrl.deepestSelectedGeoUnitName}",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                )),
          if (isVastiSearch == true) SizedBox(height: 40),
          if (isVastiSearch == true)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  '${Statics.getLabel('sharaansh')} (${Statics.getLabel(ctrl.deepestSelectedLevelName ?? "praant")})',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget buildSewaPrakalpaDataTable(List<SewaPrakalpa> dataList) {
    dataList = data!.sewaPrakalpa ?? [];

    // 1. Unique subtypes for header columns
    final List<String> uniqueSubtypes = dataList.map((e) => e.subvalue ?? '').toSet().where((s) => s.isNotEmpty).toList();

    // 2. Unique maintypes for row headers
    final List<String> uniqueMaintypes = dataList.map((e) => e.value ?? '').toSet().where((m) => m.isNotEmpty).toList();

    // 3. Construct DataTable rows
    List<DataRow> rows = uniqueMaintypes.map((maintype) {
      List<DataCell> cells = [
        DataCell(Text(maintype)), // First cell: maintype
        ...uniqueSubtypes.map((subtype) {
          final match = dataList.firstWhere(
            (e) => e.value == maintype && e.subvalue == subtype,
            orElse: () => SewaPrakalpa(sankhya: null),
          );
          return DataCell(Text(match.sankhya?.toString() ?? '-'));
        }).toList(),
      ];
      return DataRow(cells: cells);
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.purpleAccent.shade200),
        headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        columns: [
          DataColumn(label: Text("${Statics.getLabel('mukhyaPrakar')}")),
          ...uniqueSubtypes.map((subtype) => DataColumn(label: Text(subtype))),
        ],
        rows: rows,
      ),
    );
  }

  Widget commonExpansionTile({
    required String title,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(
            Statics.getLabel(title),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          initiallyExpanded: initiallyExpanded,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
