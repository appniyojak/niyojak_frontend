import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/bulk_excel_sajjan_anya_resp_model.dart';
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/get_vasti_data_by_id_model.dart';
import '../../../models/response_model/vasti_sarvekshan_dropdown_model.dart';
import '../../../models/response_model/vasti_up_data_model.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';

class AddSajjanAnyaPrakukhJanScreen extends StatefulWidget {
  static const String routeName = '/add-sajjan-anya_pramukh-jan';

  const AddSajjanAnyaPrakukhJanScreen({Key? key}) : super(key: key);

  @override
  State<AddSajjanAnyaPrakukhJanScreen> createState() => _AddSajjanAnyaPrakukhJanScreenState();
}

class _AddSajjanAnyaPrakukhJanScreenState extends State<AddSajjanAnyaPrakukhJanScreen> {
  final _controller = createGeoController();

  List<Vastisarsajjanshakti> sajjanShaktiDataList = [];

  // int? isVastiOrGraam;

  // All your variables here
  int? sajjanShaktiShreniId;
  String? sajjanShaktiShreniName;
  int? sajjanShaktiShreniEditId;
  Masterdata? sajjanShaktiShreniEditDataId;

  int? sajjanShaktiSamparkStithiId;
  String? sajjanShaktiSamparkStithiName;
  int? sajjanShaktiSamparkStithiEditId;
  Masterdata? sajjanShaktiSamparkStithiEditDataId;

  int? sajjanShaktiPrabhavKeshtraId;
  String? sajjanShaktiPrabhavKeshtraName;
  int? sajjanShaktiPrabhavKeshtraEditId;
  Masterdata? sajjanShaktiPrabhavKeshtraEditDataId;

  int? isFemale = 0;

  int? sajjanShaktiVisheshId;
  String? sajjanShaktiVisheshName;
  int? sajjanShaktiVisheshEditId;
  Masterdata? sajjanShaktiVisheshEditDataId;

  TextEditingController sajjanShaktiNameController = TextEditingController();
  TextEditingController sajjanShaktiAddressController = TextEditingController();
  TextEditingController sajjanShaktiPhoneController = TextEditingController();
  TextEditingController sajjanShaktiContactPersonNameController = TextEditingController();
  TextEditingController sajjanShaktiContactPersonDoorbhashController = TextEditingController();
  TextEditingController sajjanShaktiSansthecheNaavController = TextEditingController();
  TextEditingController sajjanShaktiSansthKuthalyaPadavarController = TextEditingController();
  TextEditingController sajjanShaktiAnyaShreniNameController = TextEditingController();
  TextEditingController sajjanShaktiAnyaVisheshNameController = TextEditingController();

  VastisarvekshanDropDownDataModel? vastisarvekshanDropDownDataModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await _controller.initialize(dm);
    await fetchVastiSurveyDropdownData();
  }

  Future<void> fetchVastiSurveyDropdownData() async {
    // await ();
    try {
      vastisarvekshanDropDownDataModel = await Statics.getVastiSurveyDropDownList(Statics.userDetails["userID"]);
      setState(() {});
    } catch (e) {
      print('Error fetching notification data: $e');
    }
  }

  List<Upnagarmandallist> vastimandallist = [];
  Upnagarmandallist? vastimandalData;

  // ---------------- BULK UPLOAD STATE ----------------
// Default entry mode is single; user can switch to bulk.
  bool isBulkMode = false;

  bool isDownloadingTemplate = false;
  bool isAnalyzingExcel = false;
  bool isSubmittingBulk = false;

  PlatformFile? pickedExcelFile;

  BulkExcelSajjanAnyaRespModel? bulkResponse;
  List<SajjanAnyaData> bulkValidList = [];
  List<SajjanAnyaData> bulkInvalidList = [];
  List<SajjanAnyaData> bulkDuplicateList = [];

  //////////////////////////////////////////////////////////////////////////////////////

  int? sajjanShaktiType;
  bool? showTypeOfForm = false;
  List<VastisarAnyaprabhavilokam> anyaPrabhaviLokDataList = [];
  int? selectedanyaPrabhaviLokRowIndex;
  int? anyaPrabhaviLokSamparkStithiId;
  String? anyaPrabhaviLokSamparkStithiName;
  int? selectedAnyaPrabhaviLokSamparkStithiIDEdit;
  Masterdata? selectedAnyaPrabhaviLokSamparkStithi;
  int? isActiveAnyaPrabhavilok = 1;
  int? pkidAnyaPrabhaviLok = 0;
  int? anyaPrabhaviLokShreniId;
  int? anyaPrabhaviLokShreniIdEdit;
  String? anyaPrabhaviLokShreniName;
  int? anyaPrabhaviLokUpShreniId;
  int? anyaPrabhaviLokUpShreniIdEdit;
  String? anyaPrabhaviLokUpShreniName;
  int? anyaPrabhaviLokUpShreni1Id;
  int? anyaPrabhaviLokUpShreni1IdEdit;
  String? anyaPrabhaviLokUpShreni1Name;
  Masterdata? selectedShreni;
  Masterdata? selectedUpShreni;
  Masterdata? selectedUpShreni2;
  int? anyaPrabhaviLokVisheshId;
  String? anyaPrabhaviLokVisheshName;
  int? selectedAnyaPrabhaviLokVisheshIDEdit;
  Masterdata? selectedAnyaPrabhaviLokVishesh;
  int? anyaPrabhaviLokPrabhavKshetraId;
  String? anyaPrabhaviLokPrabhavKshetraName;
  int? selectedAnyaPrabhaviLokPrabhavKshetraIDEdit;
  Masterdata? selectedAnyaPrabhaviLokPrabhavKshetra;
  final TextEditingController anyaPrabhaviLokNaavController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAddressController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAnyaVisheshMahitiController = TextEditingController();
  final TextEditingController anyaPrabhaviLokSamparkSutraNaavController = TextEditingController();
  final TextEditingController anyaPrabhaviLokSamparkSutraDoorbhashController = TextEditingController();
  final TextEditingController anyaPrabhaviLokMobileNoController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAnyaUppshreniController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAnyaUppshreni1Controller = TextEditingController();

  resetSajjanShaktiAndAnyaPrabhaviLokData() async {
    // Sajjan Shakti list
    sajjanShaktiDataList.clear();

    // Sajjan Shakti IDs and names reset
    sajjanShaktiShreniId = null;
    sajjanShaktiShreniName = null;
    sajjanShaktiShreniEditId = null;
    sajjanShaktiShreniEditDataId = null;

    sajjanShaktiSamparkStithiId = null;
    sajjanShaktiSamparkStithiName = null;
    sajjanShaktiSamparkStithiEditId = null;
    sajjanShaktiSamparkStithiEditDataId = null;

    sajjanShaktiPrabhavKeshtraId = null;
    sajjanShaktiPrabhavKeshtraName = null;
    sajjanShaktiPrabhavKeshtraEditId = null;
    sajjanShaktiPrabhavKeshtraEditDataId = null;

    sajjanShaktiVisheshId = null;
    sajjanShaktiVisheshName = null;
    sajjanShaktiVisheshEditId = null;
    sajjanShaktiVisheshEditDataId = null;

    // Sajjan Shakti controllers reset
    sajjanShaktiNameController.clear();
    sajjanShaktiAddressController.clear();
    sajjanShaktiPhoneController.clear();
    sajjanShaktiContactPersonNameController.clear();
    sajjanShaktiContactPersonDoorbhashController.clear();
    sajjanShaktiSansthecheNaavController.clear();
    sajjanShaktiSansthKuthalyaPadavarController.clear();
    sajjanShaktiAnyaShreniNameController.clear();
    sajjanShaktiAnyaVisheshNameController.clear();

    // Sajjan Shakti type
    sajjanShaktiType = null;

    // Anya Prabhavi Lok
    anyaPrabhaviLokDataList.clear();
    selectedanyaPrabhaviLokRowIndex = null;
    anyaPrabhaviLokSamparkStithiId = null;
    anyaPrabhaviLokSamparkStithiName = null;
    selectedAnyaPrabhaviLokSamparkStithiIDEdit = null;
    selectedAnyaPrabhaviLokSamparkStithi = null;

    isActiveAnyaPrabhavilok = 1;
    pkidAnyaPrabhaviLok = 0;
    isFemale = 0;

    anyaPrabhaviLokShreniId = null;
    anyaPrabhaviLokShreniIdEdit = null;
    anyaPrabhaviLokShreniName = null;

    anyaPrabhaviLokUpShreniId = null;
    anyaPrabhaviLokUpShreniIdEdit = null;
    anyaPrabhaviLokUpShreniName = null;

    anyaPrabhaviLokUpShreni1Id = null;
    anyaPrabhaviLokUpShreni1IdEdit = null;
    anyaPrabhaviLokUpShreni1Name = null;

    selectedShreni = null;
    selectedUpShreni = null;
    selectedUpShreni2 = null;

    anyaPrabhaviLokVisheshId = null;
    anyaPrabhaviLokVisheshName = null;
    selectedAnyaPrabhaviLokVisheshIDEdit = null;
    selectedAnyaPrabhaviLokVishesh = null;

    anyaPrabhaviLokPrabhavKshetraId = null;
    anyaPrabhaviLokPrabhavKshetraName = null;
    selectedAnyaPrabhaviLokPrabhavKshetraIDEdit = null;
    selectedAnyaPrabhaviLokPrabhavKshetra = null;

    // Controllers reset
    anyaPrabhaviLokNaavController.clear();
    anyaPrabhaviLokAddressController.clear();
    anyaPrabhaviLokAnyaVisheshMahitiController.clear();
    anyaPrabhaviLokSamparkSutraNaavController.clear();
    anyaPrabhaviLokSamparkSutraDoorbhashController.clear();
    anyaPrabhaviLokMobileNoController.clear();
    anyaPrabhaviLokAnyaUppshreniController.clear();
    anyaPrabhaviLokAnyaUppshreni1Controller.clear();

    // Dropdown data reset
    vastisarvekshanDropDownDataModel = null;

    // add inside resetSajjanShaktiAndAnyaPrabhaviLokData(), near the other resets
    isBulkMode = false;
    pickedExcelFile = null;
    bulkResponse = null;
    bulkValidList.clear();
    bulkInvalidList.clear();
    bulkDuplicateList.clear();
    isDownloadingTemplate = false;
    isAnalyzingExcel = false;
    isSubmittingBulk = false;

    fetchVastiSurveyDropdownData();
  }

  Future<void> submitForm() async {
    Map<String, dynamic> formData = {
      "GeoUnitID": int.tryParse(_controller.deepestSelectedGeoUnitId ?? "0") ?? 0,
      "AppUserID": int.parse(Statics.userDetails['userID']),
      "isnagar": _controller.deepestSelectedLevelId == 2 ? 1 : 0,
      "Vastisarsajjanshakti": sajjanShaktiDataList,
      "VastisarAnyaprabhavilokam": anyaPrabhaviLokDataList,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    final _result = await Statics.saveVishishthaAtithiData(context, formData);
    await resetSajjanShaktiAndAnyaPrabhaviLokData();
    setState(() {});
    if (_result) {
      Navigator.of(context).pop();
    }
  }

  /////////////////////////////////////// NEW BULK LOGIC ///////////////////////////////////////

  Future<void> downloadExcelTemplate() async {
    final String fileName = sajjanShaktiType == 1 ? "Sajjan_Shakti_Format.xlsx" : "Anyaprabhavi_Format.xlsx";
    final String url = "${Statics.baseUrl}/format/$fileName";

    setState(() => isDownloadingTemplate = true);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Directory dir = await getApplicationDocumentsDirectory();
        final String savePath = "${dir.path}/$fileName";
        final File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);

        await OpenFilex.open(savePath);
      } else {
        Statics.showToast("${Statics.getLabel('templateDownloadFailed')}");
      }
    } catch (e) {
      print("Error downloading template: $e");
      Statics.showToast("${Statics.getLabel('templateDownloadFailed')}");
    } finally {
      setState(() => isDownloadingTemplate = false);
    }
  }

  Future<void> pickExcelFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true, // ensures bytes are available even on Android/iOS
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => pickedExcelFile = result.files.first);
    }
  }

  Future<void> uploadAndAnalyzeExcel() async {
    if (pickedExcelFile == null || pickedExcelFile!.bytes == null) {
      Statics.showToast("${Statics.getLabel('pleaseSelectFile')}");
      return;
    }
    bulkValidList = bulkInvalidList = bulkDuplicateList = [];
    setState(() => isAnalyzingExcel = true);

    try {
      final String base64File = base64Encode(pickedExcelFile!.bytes!);

      final Map<String, dynamic> body = {
        "AppUserID": int.parse(Statics.userDetails['userID']),
        "type": sajjanShaktiType == 1 ? "SajjanShakti" : "AnyaPrabhavi",
        "ExcelBase64": base64File,
      };

      final response = await Statics.bulkExcelUploadSajjanAnyaData(body);

      if (response != null) {
        bulkResponse = response;

        bulkValidList = response.valid ?? [];
        bulkInvalidList = response.invalid ?? [];
        bulkDuplicateList = response.duplicate ?? [];

        setState(() {});
      } else {
        debugPrint("analyzeFailed >>>>>>>>>>>>>>> else");
        Statics.showToast("${Statics.getLabel('analyzeFailed')}");
      }
    } catch (e) {
      debugPrint("Error analyzing excel: $e");
      Statics.showToast("${Statics.getLabel('analyzeFailed')}");
    } finally {
      setState(() => isAnalyzingExcel = false);
    }
  }

  bool isEmptyStr(String? text) => text == null || text.trim().isEmpty;

  bool isSajjanRowValid(SajjanAnyaData row) {
    if (isEmptyStr(row.naav)) return false;
    if (row.doorbhash == null || row.doorbhash!.trim().length != 10) return false;
    if (row.shreniid == null) return false;
    if (row.sajjanSamparkSthitiid == null) return false;
    if (row.sajjanVisheshid == null) return false;
    if (row.sajjanPrabhavKshetraid == null) return false;
    if (isEmptyStr(row.samparkSutraNaav)) return false;
    if (row.samparkSutraDoorbhash == null || row.samparkSutraDoorbhash!.trim().length != 10) return false;
    return true;
  }

  bool isAnyaRowValid(SajjanAnyaData row) {
    if (isEmptyStr(row.naav)) return false;
    if (row.doorbhash == null || row.doorbhash!.trim().length != 10) return false;
    if (row.shreniid == null) return false;
    if (row.upshreniid == null || row.upshreniid!.trim().isEmpty) return false;
    if (row.anyaSamparkSthitiid == null) return false;
    if (row.anyaVisheshid == null) return false;
    if (row.anyaPrabhavKshetraid == null) return false;
    if (isEmptyStr(row.samparkSutraNaav)) return false;
    if (row.samparkSutraDoorbhash == null || row.samparkSutraDoorbhash!.trim().length != 10) return false;
    return true;
  }

  bool isBulkRowValid(SajjanAnyaData row) {
    return sajjanShaktiType == 1 ? isSajjanRowValid(row) : isAnyaRowValid(row);
  }

  /// Call this after editing a row in the bottom sheet — moves it between
  /// invalid/valid lists based on current field values. Does NOT touch
  /// bulkDuplicateList (duplicate status only comes from the server).
  void reclassifyBulkRow(SajjanAnyaData row) {
    bulkInvalidList.removeWhere((r) => r.excelRowNumber == row.excelRowNumber);
    bulkValidList.removeWhere((r) => r.excelRowNumber == row.excelRowNumber);

    if (isBulkRowValid(row)) {
      bulkValidList.add(row);
    } else {
      bulkInvalidList.add(row);
    }
    setState(() {});
  }

  Vastisarsajjanshakti sajjanAnyaDataToSajjanShakti(SajjanAnyaData row) {
    return Vastisarsajjanshakti(
      name: row.naav,
      address: row.patta,
      doorabhaash: row.doorbhash,
      shreneeid: row.shreniid,
      selectedDropdownValueName: row.shreni,
      sanstheCheNaav: row.sansthaNaav,
      sansthechaKuthalaPadavar: row.sansthaPadavi,
      samparksthitiid: row.sajjanSamparkSthitiid,
      selectedDropdownValueName1: row.sajjanSamparkSthiti,
      visheshId: row.sajjanVisheshid,
      selectedDropdownValueName2: row.sajjanVishesh,
      prabhaavkshetrid: row.sajjanPrabhavKshetraid,
      selectedDropdownValueName3: row.sajjanPrabhavKshetra,
      samparkasutranava: row.samparkSutraNaav,
      samparkasutraMobileNumber: row.samparkSutraDoorbhash,
      isactive: 1,
      isfemale: row.isfemale,
      vastiid: int.tryParse(_controller.deepestSelectedGeoUnitId ?? "0") ?? 0,
      pkid: 0,
    );
  }

  VastisarAnyaprabhavilokam sajjanAnyaDataToAnyaPrabhaviLok(SajjanAnyaData row) {
    return VastisarAnyaprabhavilokam(
      name: row.naav,
      address: row.patta,
      doorabhaash: row.doorbhash,
      shreneeid: row.shreniid,
      selectedDropdownValueName: row.shreni,
      upshreneeid: int.tryParse(row.upshreniid ?? ""),
      selectedDropdownValueName1: row.upshreni,
      visheshid: row.anyaVisheshid,
      selectedDropdownValueName3: row.anyaVishesh,
      prabhaavkshetrid: row.anyaPrabhavKshetraid,
      selectedDropdownValueName4: row.anyaPrabhavKshetra,
      othervishesh: row.anyaVisheshMahiti,
      anyavisesamahiti: row.anyaVisheshMahiti,
      samparksthitiid: row.anyaSamparkSthitiid,
      selectedDropdownValueName5: row.anyaSamparkSthiti,
      samparkasutranav: row.samparkSutraNaav,
      samparkaSutraDoorbhash: row.samparkSutraDoorbhash,
      isactive: 1,
      isfemale: row.isfemale,
      vastiid: int.tryParse(_controller.deepestSelectedGeoUnitId ?? "0") ?? 0,
      pkid: 0,
    );
  }

  Future<void> submitBulkData() async {
    if (bulkValidList.isEmpty) {
      Statics.showToast("${Statics.getLabel('noValidRowsToSubmit')}");
      return;
    }

    setState(() => isSubmittingBulk = true);

    if (sajjanShaktiType == 1) {
      sajjanShaktiDataList.addAll(bulkValidList.map(sajjanAnyaDataToSajjanShakti));
    } else {
      anyaPrabhaviLokDataList.addAll(bulkValidList.map(sajjanAnyaDataToAnyaPrabhaviLok));
    }

    await submitForm(); // reuses your existing save + navigation-pop logic

    setState(() => isSubmittingBulk = false);
  }

  //////////////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    resetSajjanShaktiAndAnyaPrabhaviLokData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(Statics.getLabel('addPresentMahanubhav'), style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.purpleAccent)),
                child: Column(children: [
                  Text(
                    "${Statics.getLabel('selectedBhougolikkaryastithi')}",
                    style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  nagarDropdown(),
                  if (showTypeOfForm == true)
                    DropdownButtonFormField<int>(
                      value: sajjanShaktiType,
                      decoration: InputDecoration(
                        labelText: Statics.getLabel(
                          'SelectPrakar',
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Text("${Statics.getLabel('SajjanShakti')}"),
                        ),
                        DropdownMenuItem(
                          value: 0,
                          child: Text("${Statics.getLabel('anyaPrabhaviLok')}"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          sajjanShaktiType = value!;
                        });
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                ]),
              ),
              SizedBox(height: 15),
              if (showTypeOfForm == true && sajjanShaktiType != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          title: Text("${Statics.getLabel('singleEntry')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          value: false,
                          groupValue: isBulkMode,
                          onChanged: (value) => setState(() => isBulkMode = value!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          title: Text("${Statics.getLabel('bulkUpload')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          value: true,
                          groupValue: isBulkMode,
                          onChanged: (value) => setState(() => isBulkMode = value!),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 15),
              if (sajjanShaktiType == 1 && !isBulkMode)
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.purpleAccent)),
                  child: Column(
                    children: [
                      Text(
                        "${Statics.getLabel('SajjanShakti')}",
                        style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      textControllerField2(
                        name: Statics.getLabel('Name'),
                        controller: sajjanShaktiNameController,
                        fieldHeight: 45,
                        isRequired: true,
                      ),
                      textControllerField2(
                        name: Statics.getLabel('Address'),
                        controller: sajjanShaktiAddressController,
                        maxLines: 4,
                      ),
                      textControllerField2(
                        name: Statics.getLabel('doorBhash'),
                        controller: sajjanShaktiPhoneController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                        isRequired: true,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              title: Text("${Statics.getLabel('Male')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              value: 0,
                              groupValue: isFemale,
                              onChanged: (value) => setState(() {
                                isFemale = value;
                              }),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              title: Text("${Statics.getLabel('Female')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              value: 1,
                              groupValue: isFemale,
                              onChanged: (value) => setState(() {
                                isFemale = value;
                              }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      if (vastisarvekshanDropDownDataModel != null)
                        vastisarvekshanDropdown2(
                          question: Statics.getLabel('Category'),
                          dataModel: vastisarvekshanDropDownDataModel!,
                          filterTypeName: "सज्जन शक्ति श्रेणी",
                          hintText: Statics.getLabel('Category'),
                          onItemSelected: (id, value, isOther) {
                            sajjanShaktiShreniName = value;
                            sajjanShaktiShreniId = id;
                            print("id = $id --- Name = $value");
                          },
                          selectedValue: sajjanShaktiShreniEditDataId,
                          onSelectionChanged: (newValue) {
                            setState(() {
                              sajjanShaktiShreniEditDataId = newValue;
                            });
                            print("Selection changes called >>>>>>>>>>");
                          },
                          editId: sajjanShaktiShreniEditId,
                        ),
                      if (sajjanShaktiShreniEditDataId?.isOther == 1)
                        textControllerField2(
                          name: Statics.getLabel('OtherCategory'),
                          controller: sajjanShaktiAnyaShreniNameController,
                        ),
                      textControllerField2(
                        name: Statics.getLabel('OrganizationName'),
                        controller: sajjanShaktiSansthecheNaavController,
                      ),
                      textControllerField2(
                        name: Statics.getLabel('sansthetKuthalaPadavar'),
                        controller: sajjanShaktiSansthKuthalyaPadavarController,
                      ),
                      if (vastisarvekshanDropDownDataModel != null)
                        vastisarvekshanDropdown2(
                          question: Statics.getLabel('samparkStithi'),
                          dataModel: vastisarvekshanDropDownDataModel!,
                          filterTypeName: "सज्जन शक्ति संपर्क स्थिति",
                          hintText: Statics.getLabel('samparkStithi'),
                          onItemSelected: (id, value, isOther) {
                            sajjanShaktiSamparkStithiName = value;
                            sajjanShaktiSamparkStithiId = id;
                            print("id = $id --- Name = $value");
                          },
                          selectedValue: sajjanShaktiSamparkStithiEditDataId,
                          onSelectionChanged: (newValue) {
                            setState(() {
                              sajjanShaktiSamparkStithiEditDataId = newValue;
                            });
                          },
                          editId: sajjanShaktiSamparkStithiEditId,
                        ),
                      if (vastisarvekshanDropDownDataModel != null)
                        vastisarvekshanDropdown2(
                          question: Statics.getLabel('special'),
                          dataModel: vastisarvekshanDropDownDataModel!,
                          filterTypeName: "सज्जन शक्ति विशेष",
                          hintText: Statics.getLabel('special'),
                          onItemSelected: (id, value, isOther) {
                            sajjanShaktiVisheshName = value;
                            sajjanShaktiVisheshId = id;
                            print("id = $id --- Name = $value");
                          },
                          selectedValue: sajjanShaktiVisheshEditDataId,
                          onSelectionChanged: (newValue) {
                            setState(() {
                              sajjanShaktiVisheshEditDataId = newValue;
                            });
                          },
                          editId: sajjanShaktiVisheshEditId,
                        ),
                      if (sajjanShaktiVisheshEditDataId?.isOther == 1)
                        textControllerField2(
                          name: Statics.getLabel('otherSpecial'),
                          controller: sajjanShaktiAnyaVisheshNameController,
                        ),
                      if (vastisarvekshanDropDownDataModel != null)
                        vastisarvekshanDropdown2(
                          question: Statics.getLabel('prabhavKshetra'),
                          dataModel: vastisarvekshanDropDownDataModel!,
                          filterTypeName: "सज्जन शक्ति प्रभाव क्षेत्र",
                          hintText: Statics.getLabel('prabhavKshetra'),
                          onItemSelected: (id, value, isOther) {
                            sajjanShaktiPrabhavKeshtraName = value;
                            sajjanShaktiPrabhavKeshtraId = id;
                            print("id = $id --- Name = $value");
                          },
                          selectedValue: sajjanShaktiPrabhavKeshtraEditDataId,
                          onSelectionChanged: (newValue) {
                            setState(() {
                              sajjanShaktiPrabhavKeshtraEditDataId = newValue;
                            });
                          },
                          editId: sajjanShaktiPrabhavKeshtraEditId,
                        ),
                      textControllerField2(
                        name: Statics.getLabel('samparkSootraNaav'),
                        controller: sajjanShaktiContactPersonNameController,
                        isRequired: true,
                      ),
                      textControllerField2(
                        name: Statics.getLabel('samparakSootraDoorbhash'),
                        controller: sajjanShaktiContactPersonDoorbhashController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                        isRequired: true,
                      ),
                    ],
                  ),
                ),
              if (sajjanShaktiType == 0 && !isBulkMode)
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.purpleAccent)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${Statics.getLabel('anyaPrabhaviLok')}",
                        style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      textControllerField2(
                        name: "${Statics.getLabel('Name')}",
                        controller: anyaPrabhaviLokNaavController,
                        isRequired: true,
                      ),
                      textControllerField2(
                        name: "${Statics.getLabel('Address')}",
                        controller: anyaPrabhaviLokAddressController,
                      ),
                      textControllerField2(
                        name: "${Statics.getLabel('doorBhash')}",
                        controller: anyaPrabhaviLokMobileNoController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                        isRequired: true,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              title: Text("${Statics.getLabel('Male')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              value: 0,
                              groupValue: isFemale,
                              onChanged: (value) => setState(() {
                                isFemale = value;
                              }),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              contentPadding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              title: Text("${Statics.getLabel('Female')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              value: 1,
                              groupValue: isFemale,
                              onChanged: (value) => setState(() {
                                isFemale = value;
                              }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ---- Left side label ----
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${Statics.getLabel('Category')}/\n${Statics.getLabel('upshreni')}",
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 6),
                                child: Text(
                                  "  *",
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// ---- Separator ----
                          Text(
                            ":",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),

                          /// ---- Right side (Dropdown + conditions) ----
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Dropdown
                                  if (vastisarvekshanDropDownDataModel != null)
                                    vastisarvekshanDropdown3(
                                      filterTypeName: "श्रेणी",
                                      hintText: "${Statics.getLabel('selectShrenihint')}",
                                      anyaPrabhaviLokShreniId: anyaPrabhaviLokShreniIdEdit,
                                      anyaPrabhaviLokUpShreniId: anyaPrabhaviLokUpShreniIdEdit,
                                      anyaPrabhaviLokUpShreni1Id: anyaPrabhaviLokUpShreni1IdEdit,
                                      onValueSelected: (id, name, value) {
                                        anyaPrabhaviLokShreniId = id;
                                        anyaPrabhaviLokShreniName = name;
                                        setState(() {
                                          selectedShreni = value;
                                          selectedUpShreni = null;
                                          selectedUpShreni2 = null;
                                        });
                                        print("id = $id --- Name = $value");
                                      },
                                      onDependentValueSelected: (id, name, value) {
                                        anyaPrabhaviLokUpShreniId = id;
                                        anyaPrabhaviLokUpShreniName = name;
                                        setState(() {
                                          selectedUpShreni = value;
                                          selectedUpShreni2 = null;
                                        });
                                        print("id = $id --- Name = $value");
                                      },
                                      onThirdLevelValueSelected: (id, name, value) {
                                        anyaPrabhaviLokUpShreni1Id = id;
                                        anyaPrabhaviLokUpShreni1Name = name;
                                        setState(() {
                                          selectedUpShreni2 = value;
                                        });
                                        print("id = $id --- Name = $value");
                                      },
                                      viewName: true,
                                    ),

                                  const SizedBox(height: 10),

                                  /// Other Upshreni (1st level)
                                  if (selectedUpShreni?.isOther == 1)
                                    textControllerField2(
                                      name: "${Statics.getLabel('otherUpshreni')}",
                                      controller: anyaPrabhaviLokAnyaUppshreniController,
                                    ),

                                  if (selectedUpShreni?.isOther == 1) const SizedBox(height: 10),

                                  /// Other Upshreni (2nd level)
                                  if (selectedUpShreni2?.isOther == 1)
                                    textControllerField2(
                                      name: "${Statics.getLabel('otherUpshreni2')}",
                                      controller: anyaPrabhaviLokAnyaUppshreni1Controller,
                                    ),

                                  if (selectedUpShreni2?.isOther == 1) const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5),

                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                              hintText: "${Statics.getLabel('selectVishesh')}",
                              filterTypeName: "अन्यप्रभावीलोकंविशेष",
                              onItemSelected: (valueId, valueName, isOther) {
                                anyaPrabhaviLokVisheshId = valueId;
                                anyaPrabhaviLokVisheshName = valueName;
                                print("id = $valueId --- Name = $valueName");
                              },
                              dataModel: vastisarvekshanDropDownDataModel!,
                              question: "${Statics.getLabel('special')}",
                              editId: selectedAnyaPrabhaviLokVisheshIDEdit,
                              selectedValue: selectedAnyaPrabhaviLokVishesh,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedAnyaPrabhaviLokVishesh = newValue;
                                });
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                              hintText: "${Statics.getLabel('prabhavKshetraSelect')}",
                              filterTypeName: "अन्यप्रभावीलोकंप्रभावक्षेत्र",
                              onItemSelected: (valueId, valueName, isOther) {
                                anyaPrabhaviLokPrabhavKshetraId = valueId;
                                anyaPrabhaviLokPrabhavKshetraName = valueName;
                                print("id = $valueId --- Name = $valueName");
                              },
                              dataModel: vastisarvekshanDropDownDataModel!,
                              question: "${Statics.getLabel('prabhavKshetra')}",
                              editId: selectedAnyaPrabhaviLokPrabhavKshetraIDEdit,
                              selectedValue: selectedAnyaPrabhaviLokPrabhavKshetra,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedAnyaPrabhaviLokPrabhavKshetra = newValue;
                                });
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      textControllerField2(
                        name: "${Statics.getLabel('anyaVisheshMahiti')}",
                        controller: anyaPrabhaviLokAnyaVisheshMahitiController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                              hintText: "${Statics.getLabel('samparkSthitiSelect')}",
                              filterTypeName: "अन्यप्रभावीलोकंसंपर्कस्थिति",
                              onItemSelected: (valueId, valueName, isOther) {
                                anyaPrabhaviLokSamparkStithiId = valueId;
                                anyaPrabhaviLokSamparkStithiName = valueName;
                                print("id = $valueId --- Name = $valueName");
                              },
                              dataModel: vastisarvekshanDropDownDataModel!,
                              question: "${Statics.getLabel('samparkStithi')}",
                              editId: selectedAnyaPrabhaviLokSamparkStithiIDEdit,
                              selectedValue: selectedAnyaPrabhaviLokSamparkStithi,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedAnyaPrabhaviLokSamparkStithi = newValue;
                                });
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      // textControllerField(${Statics.getLabel('anyaVisheshMahiti')}, anyaPrabhaviLokAnyaVisheshMahitiController, context, height: 80),
                      textControllerField2(
                        name: "${Statics.getLabel('samparkSootraNaav')}",
                        controller: anyaPrabhaviLokSamparkSutraNaavController,
                        isRequired: true,
                      ),
                      textControllerField2(
                        name: "${Statics.getLabel('samparakSootraDoorbhash')}",
                        controller: anyaPrabhaviLokSamparkSutraDoorbhashController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                        isRequired: true,
                      ),
                    ],
                  ),
                ),
              if (sajjanShaktiType != null && isBulkMode) bulkUploadSection(),
              if (sajjanShaktiType == 0 || sajjanShaktiType == 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45, // fixed button height
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        bool isValid = true;

                        // Helper function
                        bool isEmpty(String? text) => text == null || text.trim().isEmpty;

                        if (sajjanShaktiType == 1) {
                          // 🔹 Required field checks
                          if (isEmpty(sajjanShaktiNameController.text)) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                            // } else if (isEmpty(sajjanShaktiAddressController.text)) {
                            //   Statics.showToast("${Statics.getLabel('allInfoRequired')}");
                            //   isValid = false;
                          } else if (sajjanShaktiPhoneController.text.length != 10) {
                            Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            isValid = false;
                            // } else if (isEmpty(sajjanShaktiSansthecheNaavController.text)) {
                            //   Statics.showToast("${Statics.getLabel('allInfoRequired')}");
                            //   isValid = false;
                            // } else if (isEmpty(sajjanShaktiSansthKuthalyaPadavarController.text)) {
                            //   Statics.showToast("${Statics.getLabel('allInfoRequired')}");
                            //   isValid = false;
                          } else if (isEmpty(sajjanShaktiContactPersonNameController.text)) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                          } else if (sajjanShaktiContactPersonDoorbhashController.text.length != 10) {
                            Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            isValid = false;
                          } else if (sajjanShaktiPrabhavKeshtraId == null || sajjanShaktiVisheshId == null || sajjanShaktiSamparkStithiId == null || sajjanShaktiShreniId == null) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                          } else if (isEmpty(sajjanShaktiContactPersonNameController.text)) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                          } else if (sajjanShaktiContactPersonDoorbhashController.text.length != 10) {
                            Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            isValid = false;
                          }

                          if (isValid) {
                            Vastisarsajjanshakti newData = Vastisarsajjanshakti(
                              name: sajjanShaktiNameController.text.trim(),
                              address: sajjanShaktiAddressController.text.trim(),
                              doorabhaash: sajjanShaktiPhoneController.text.trim(),
                              shreneeid: sajjanShaktiShreniId,
                              selectedDropdownValueName: sajjanShaktiShreniName,
                              otherShreniName: sajjanShaktiAnyaShreniNameController.text.trim(),
                              sanstheCheNaav: sajjanShaktiSansthecheNaavController.text.trim(),
                              sansthechaKuthalaPadavar: sajjanShaktiSansthKuthalyaPadavarController.text.trim(),
                              samparksthitiid: sajjanShaktiSamparkStithiId,
                              selectedDropdownValueName1: sajjanShaktiSamparkStithiName,
                              visheshId: sajjanShaktiVisheshId,
                              selectedDropdownValueName2: sajjanShaktiVisheshName,
                              otherVisheshName: sajjanShaktiAnyaVisheshNameController.text.trim(),
                              prabhaavkshetrid: sajjanShaktiPrabhavKeshtraId,
                              selectedDropdownValueName3: sajjanShaktiPrabhavKeshtraName,
                              samparkasutranava: sajjanShaktiContactPersonNameController.text.trim(),
                              samparkasutraMobileNumber: sajjanShaktiContactPersonDoorbhashController.text.trim(),
                              isactive: 1,
                              vastiid: int.tryParse(_controller.deepestSelectedGeoUnitId ?? "0") ?? 0,
                              pkid: 0,
                              isfemale: isFemale,
                            );
                            sajjanShaktiDataList.add(newData);
                          }
                        }

                        if (sajjanShaktiType == 0) {
                          // 🔹 Required field checks
                          if (isEmpty(anyaPrabhaviLokNaavController.text)) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                            // } else if (isEmpty(anyaPrabhaviLokAddressController.text)) {
                            //   Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            //   isValid = false;
                          } else if (anyaPrabhaviLokMobileNoController.text.length != 10) {
                            Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            isValid = false;
                          } else if (anyaPrabhaviLokSamparkStithiId == null ||
                              anyaPrabhaviLokPrabhavKshetraId == null ||
                              anyaPrabhaviLokVisheshId == null ||
                              // anyaPrabhaviLokUpShreni1Id == null ||
                              anyaPrabhaviLokUpShreniId == null ||
                              anyaPrabhaviLokShreniId == null) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                          } else if (isEmpty(anyaPrabhaviLokSamparkSutraNaavController.text)) {
                            Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                            isValid = false;
                          } else if (anyaPrabhaviLokSamparkSutraDoorbhashController.text.length != 10) {
                            Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            isValid = false;
                          }

                          if (isValid) {
                            VastisarAnyaprabhavilokam newData = VastisarAnyaprabhavilokam(
                              name: anyaPrabhaviLokNaavController.text,
                              address: anyaPrabhaviLokAddressController.text,
                              doorabhaash: anyaPrabhaviLokMobileNoController.text,
                              shreneeid: anyaPrabhaviLokShreniId,
                              selectedDropdownValueName: anyaPrabhaviLokShreniName,
                              upshreneeid: anyaPrabhaviLokUpShreniId,
                              selectedDropdownValueName1: anyaPrabhaviLokUpShreniName,
                              upshreneeid2: anyaPrabhaviLokUpShreni1Id,
                              selectedDropdownValueName2: anyaPrabhaviLokUpShreni1Name,
                              visheshid: anyaPrabhaviLokVisheshId,
                              selectedDropdownValueName3: anyaPrabhaviLokVisheshName,
                              prabhaavkshetrid: anyaPrabhaviLokPrabhavKshetraId,
                              selectedDropdownValueName4: anyaPrabhaviLokPrabhavKshetraName,
                              othervishesh: anyaPrabhaviLokAnyaVisheshMahitiController.text,
                              samparksthitiid: anyaPrabhaviLokSamparkStithiId,
                              selectedDropdownValueName5: anyaPrabhaviLokSamparkStithiName,
                              samparkasutranav: anyaPrabhaviLokSamparkSutraNaavController.text,
                              samparkaSutraDoorbhash: anyaPrabhaviLokSamparkSutraDoorbhashController.text,
                              pkid: 0,
                              anyavisesamahiti: anyaPrabhaviLokAnyaVisheshMahitiController.text,
                              otherupshrenee: anyaPrabhaviLokAnyaUppshreniController.text,
                              otherupshrenee2: anyaPrabhaviLokAnyaUppshreni1Controller.text,
                              isactive: 1,
                              isfemale: isFemale,
                              vastiid: int.tryParse(_controller.deepestSelectedGeoUnitId ?? "0") ?? 0,
                            );
                            anyaPrabhaviLokDataList.add(newData);
                          }
                        }

                        // ✅ Final form submit
                        if (isValid) {
                          submitForm();
                        }
                      },
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nagarDropdown() {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
        return Container(
          child: Column(
            children: [
              GeoDropdownWidget(
                level: GeoLevel.Mahaanagar,
                title: 'Mahaanagar',
                controller: ctrl,
                onChanged: (p0) => setState(() {
                  sajjanShaktiType = null;
                  showTypeOfForm = false;
                }),
              ),

              // if (ctrl.hasItems(GeoLevel.vibhaag))
              GeoDropdownWidget(
                level: GeoLevel.Vibhaag,
                title: 'Vibhaag',
                controller: ctrl,
                onChanged: (p0) => setState(() {
                  sajjanShaktiType = null;
                  showTypeOfForm = false;
                }),
              ),

              if (ctrl.hasItems(GeoLevel.Bhaag))
                GeoDropdownWidget(
                  level: GeoLevel.Bhaag,
                  title: 'Bhaag',
                  controller: ctrl,
                  onChanged: (p0) => setState(() {
                    sajjanShaktiType = null;
                    showTypeOfForm = false;
                  }),
                ),

              if (ctrl.hasItems(GeoLevel.Nagar))
                GeoDropdownWidget(
                  level: GeoLevel.Nagar,
                  title: 'Nagar',
                  controller: ctrl,
                  onChanged: (p0) => setState(() {
                    sajjanShaktiType = null;
                    showTypeOfForm = false;
                  }),
                ),

              ////////////////////////////////////////
              /// CONDITIONAL

              if (ctrl.hasItems(GeoLevel.upnagarUpkhanda))
                GeoDropdownWidget(
                  level: GeoLevel.upnagarUpkhanda,
                  title: 'upnagarUpkhanda',
                  controller: ctrl,
                  onChanged: (p0) => setState(() {
                    sajjanShaktiType = null;
                    showTypeOfForm = false;
                  }),
                ),

              ////////////////////////////////////////

              if (ctrl.hasItems(GeoLevel.Mandal))
                GeoDropdownWidget(
                  level: GeoLevel.Mandal,
                  title: 'Mandal',
                  controller: ctrl,
                  onChanged: (p0) => setState(() {
                    sajjanShaktiType = null;
                    showTypeOfForm = false;
                  }),
                ),

              if (ctrl.hasItems(GeoLevel.Graam))
                GeoDropdownWidget(
                  level: GeoLevel.Graam,
                  title: 'Graam',
                  controller: ctrl,
                  onChanged: (p0) => setState(() => showTypeOfForm = true),
                ),

              if (ctrl.hasItems(GeoLevel.Vasti))
                GeoDropdownWidget(
                  level: GeoLevel.Vasti,
                  title: 'Vasti',
                  controller: ctrl,
                  onChanged: (p0) => setState(() => showTypeOfForm = true),
                ),
              SizedBox(height: 15),
            ],
          ),
        );
      }),
    );
  }

  Widget bulkUploadSection() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.purpleAccent)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.download, color: Colors.purpleAccent),
                  label: Text("${Statics.getLabel('downloadTemplate')}"),
                  onPressed: isDownloadingTemplate ? null : downloadExcelTemplate,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.upload_file, color: Colors.purpleAccent),
                  label: Text(
                    pickedExcelFile != null ? pickedExcelFile!.name : "${Statics.getLabel('chooseFile')}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: pickExcelFile,
                ),
              ),
            ],
          ),
          if (isDownloadingTemplate) Padding(padding: EdgeInsets.only(top: 8), child: CircularProgressIndicator()),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
              onPressed: (pickedExcelFile == null || isAnalyzingExcel) ? null : uploadAndAnalyzeExcel,
              child: isAnalyzingExcel
                  ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text("${Statics.getLabel('analyze')}", style: TextStyle(color: Colors.white)),
            ),
          ),
          if (bulkResponse != null) ...[
            SizedBox(height: 16),
            bulkPreviewTable(
              title: "${Statics.getLabel('validEntries')}",
              color: Colors.green,
              rows: bulkValidList,
              showEdit: false,
              onDelete: (row) => setState(() => bulkValidList.remove(row)),
            ),
            SizedBox(height: 16),
            bulkPreviewTable(
              title: "${Statics.getLabel('invalidEntries')}",
              color: Colors.orange,
              rows: bulkInvalidList,
              showEdit: true,
              onDelete: (row) => setState(() => bulkInvalidList.remove(row)),
              onEdit: (row) => openBulkEditSheet(row),
            ),
            SizedBox(height: 16),
            bulkPreviewTable(
              title: "${Statics.getLabel('duplicateEntries')}",
              color: Colors.red,
              rows: bulkDuplicateList,
              showEdit: false,
              onDelete: (row) => setState(() => bulkDuplicateList.remove(row)),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                onPressed: (bulkValidList.isEmpty || isSubmittingBulk) ? null : submitBulkData,
                child: isSubmittingBulk
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("${Statics.getLabel('Submit')} (${bulkValidList.length})", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget bulkPreviewTable({
    required String title,
    required Color color,
    required List<SajjanAnyaData> rows,
    required bool showEdit,
    required Function(SajjanAnyaData) onDelete,
    Function(SajjanAnyaData)? onEdit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
        Divider(color: color.withOpacity(0.4)),
        if (rows.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text("${Statics.getLabel('noEntries')}", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12)),
          ),
        if (rows.isNotEmpty)
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(color.withOpacity(0.15)),
                columnSpacing: 20,
                columns: [
                  DataColumn(label: Text("${Statics.getLabel('action')}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5))),
                  DataColumn(label: Text("${Statics.getLabel('Name')}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5))),
                  DataColumn(label: Text("${Statics.getLabel('doorBhash')}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5))),
                ],
                rows: rows.map((row) {
                  return DataRow(
                    color: MaterialStateProperty.all(color.withOpacity(0.06)),
                    cells: [
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (showEdit)
                              IconButton(
                                icon: Icon(Icons.info_outline, color: Colors.blueGrey, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () => showRowErrorDialog(row),
                              ),
                            if (showEdit) SizedBox(width: 6),
                            if (showEdit)
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.purpleAccent, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () => onEdit?.call(row),
                              ),
                            if (showEdit) SizedBox(width: 6),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () => onDelete(row),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(row.naav ?? '-', style: TextStyle(fontSize: 13))),
                      DataCell(Text(row.doorbhash ?? '-', style: TextStyle(fontSize: 13))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  void showRowErrorDialog(SajjanAnyaData row) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("${Statics.getLabel('errorDetails')}", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w600)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: (row.errorMessages == null || row.errorMessages!.isEmpty)
                  ? [Text("${Statics.getLabel('noErrorDetails')}")]
                  : row.errorMessages!
                      .map((msg) => Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red, size: 16),
                                SizedBox(width: 6),
                                Expanded(child: Text(msg, style: TextStyle(fontSize: 13))),
                              ],
                            ),
                          ))
                      .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("${Statics.getLabel('close')}", style: TextStyle(color: Colors.purpleAccent)),
            ),
          ],
        );
      },
    );
  }

  void openBulkEditSheet(SajjanAnyaData row) {
    if (sajjanShaktiType == 1) {
      _openSajjanBulkEditSheet(row);
    } else {
      _openAnyaBulkEditSheet(row);
    }
  }

  void _openSajjanBulkEditSheet(SajjanAnyaData row) {
    final naavCtrl = TextEditingController(text: row.naav);
    final pattaCtrl = TextEditingController(text: row.patta);
    final doorbhashCtrl = TextEditingController(text: row.doorbhash);
    final sansthaNaavCtrl = TextEditingController(text: row.sansthaNaav);
    final sansthaPadaviCtrl = TextEditingController(text: row.sansthaPadavi);
    final samparkNaavCtrl = TextEditingController(text: row.samparkSutraNaav);
    final samparkDoorbhashCtrl = TextEditingController(text: row.samparkSutraDoorbhash);

    int? localIsFemale = row.isfemale;
    Masterdata? localShreni;
    Masterdata? localSamparkSthiti;
    Masterdata? localVishesh;
    Masterdata? localPrabhavKshetra;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, margin: EdgeInsets.only(bottom: 14), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3))),
                  Text("${Statics.getLabel('editEntry')}", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w600, fontSize: 18)),
                  SizedBox(height: 12),
                  textControllerField2(name: Statics.getLabel('Name'), controller: naavCtrl, isRequired: true),
                  textControllerField2(name: Statics.getLabel('Address'), controller: pattaCtrl, maxLines: 4),
                  textControllerField2(name: Statics.getLabel('doorBhash'), controller: doorbhashCtrl, keyboardType: TextInputType.number, maxInput: 10, isRequired: true),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<int>(
                          contentPadding: EdgeInsets.zero,
                          title: Text("${Statics.getLabel('Male')}"),
                          value: 0,
                          groupValue: localIsFemale,
                          onChanged: (v) => setSheetState(() => localIsFemale = v),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<int>(
                          contentPadding: EdgeInsets.zero,
                          title: Text("${Statics.getLabel('Female')}"),
                          value: 1,
                          groupValue: localIsFemale,
                          onChanged: (v) => setSheetState(() => localIsFemale = v),
                        ),
                      ),
                    ],
                  ),
                  if (vastisarvekshanDropDownDataModel != null)
                    vastisarvekshanDropdown2(
                      question: Statics.getLabel('Category'),
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति श्रेणी",
                      hintText: Statics.getLabel('Category'),
                      editId: row.shreniid,
                      selectedValue: localShreni,
                      onItemSelected: (id, value, isOther) {},
                      onSelectionChanged: (v) => setSheetState(() => localShreni = v),
                    ),
                  textControllerField2(name: Statics.getLabel('OrganizationName'), controller: sansthaNaavCtrl),
                  textControllerField2(name: Statics.getLabel('sansthetKuthalaPadavar'), controller: sansthaPadaviCtrl),
                  if (vastisarvekshanDropDownDataModel != null)
                    vastisarvekshanDropdown2(
                      question: Statics.getLabel('samparkStithi'),
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति संपर्क स्थिति",
                      hintText: Statics.getLabel('samparkStithi'),
                      editId: row.sajjanSamparkSthitiid,
                      selectedValue: localSamparkSthiti,
                      onItemSelected: (id, value, isOther) {},
                      onSelectionChanged: (v) => setSheetState(() => localSamparkSthiti = v),
                    ),
                  if (vastisarvekshanDropDownDataModel != null)
                    vastisarvekshanDropdown2(
                      question: Statics.getLabel('special'),
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति विशेष",
                      hintText: Statics.getLabel('special'),
                      editId: row.sajjanVisheshid,
                      selectedValue: localVishesh,
                      onItemSelected: (id, value, isOther) {},
                      onSelectionChanged: (v) => setSheetState(() => localVishesh = v),
                    ),
                  if (vastisarvekshanDropDownDataModel != null)
                    vastisarvekshanDropdown2(
                      question: Statics.getLabel('prabhavKshetra'),
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति प्रभाव क्षेत्र",
                      hintText: Statics.getLabel('prabhavKshetra'),
                      editId: row.sajjanPrabhavKshetraid,
                      selectedValue: localPrabhavKshetra,
                      onItemSelected: (id, value, isOther) {},
                      onSelectionChanged: (v) => setSheetState(() => localPrabhavKshetra = v),
                    ),
                  textControllerField2(name: Statics.getLabel('samparkSootraNaav'), controller: samparkNaavCtrl, isRequired: true),
                  textControllerField2(name: Statics.getLabel('samparakSootraDoorbhash'), controller: samparkDoorbhashCtrl, keyboardType: TextInputType.number, maxInput: 10, isRequired: true),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                      onPressed: () {
                        bool isValid = true;

                        if (isEmptyStr(naavCtrl.text)) {
                          Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                          isValid = false;
                        } else if (doorbhashCtrl.text.trim().length != 10) {
                          Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                          isValid = false;
                        } else if (isEmptyStr(samparkNaavCtrl.text)) {
                          Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                          isValid = false;
                        } else if (samparkDoorbhashCtrl.text.trim().length != 10) {
                          Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                          isValid = false;
                        } else if ((localPrabhavKshetra?.id ?? row.sajjanPrabhavKshetraid) == null ||
                            (localVishesh?.id ?? row.sajjanVisheshid) == null ||
                            (localSamparkSthiti?.id ?? row.sajjanSamparkSthitiid) == null ||
                            (localShreni?.id ?? row.shreniid) == null) {
                          Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                          isValid = false;
                        }

                        if (!isValid) return;

                        row.naav = naavCtrl.text.trim();
                        row.patta = pattaCtrl.text.trim();
                        row.doorbhash = doorbhashCtrl.text.trim();
                        row.isfemale = localIsFemale;
                        row.sansthaNaav = sansthaNaavCtrl.text.trim();
                        row.sansthaPadavi = sansthaPadaviCtrl.text.trim();
                        row.samparkSutraNaav = samparkNaavCtrl.text.trim();
                        row.samparkSutraDoorbhash = samparkDoorbhashCtrl.text.trim();
                        if (localShreni != null) {
                          row.shreniid = localShreni!.id;
                          row.shreni = localShreni!.value;
                        }
                        if (localSamparkSthiti != null) {
                          row.sajjanSamparkSthitiid = localSamparkSthiti!.id;
                          row.sajjanSamparkSthiti = localSamparkSthiti!.value;
                        }
                        if (localVishesh != null) {
                          row.sajjanVisheshid = localVishesh!.id;
                          row.sajjanVishesh = localVishesh!.value;
                        }
                        if (localPrabhavKshetra != null) {
                          row.sajjanPrabhavKshetraid = localPrabhavKshetra!.id;
                          row.sajjanPrabhavKshetra = localPrabhavKshetra!.value;
                        }

                        reclassifyBulkRow(row);
                        Navigator.of(ctx).pop();
                      },
                      child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _openAnyaBulkEditSheet(SajjanAnyaData row) {
    final naavCtrl = TextEditingController(text: row.naav);
    final pattaCtrl = TextEditingController(text: row.patta);
    final doorbhashCtrl = TextEditingController(text: row.doorbhash);
    final anyaVisheshMahitiCtrl = TextEditingController(text: row.anyaVisheshMahiti);
    final samparkNaavCtrl = TextEditingController(text: row.samparkSutraNaav);
    final samparkDoorbhashCtrl = TextEditingController(text: row.samparkSutraDoorbhash);

    int? localIsFemale = row.isfemale;

    Masterdata? localShreni;
    Masterdata? localUpShreni;
    Masterdata? localUpShreni2;
    Masterdata? localVishesh;
    Masterdata? localPrabhavKshetra;
    Masterdata? localSamparkSthiti;

    // Pre-fill cascade from row ids, same pattern the main form uses.
    final masterDataList = vastisarvekshanDropDownDataModel?.masterdata ?? [];

    if (row.shreniid != null) {
      localShreni = masterDataList.firstWhere(
        (e) => e.typename == "श्रेणी" && e.id == row.shreniid,
        orElse: () => Masterdata(),
      );
      if (localShreni.id == null) localShreni = null;
    }

    final int? rowUpshreniId = int.tryParse(row.upshreniid ?? "");
    if (localShreni != null && rowUpshreniId != null) {
      localUpShreni = masterDataList.firstWhere(
        (e) => e.parentid == localShreni!.id && e.id == rowUpshreniId,
        orElse: () => Masterdata(),
      );
      if (localUpShreni.id == null) localUpShreni = null;
    }

    final int? rowUpshreni2Id = int.tryParse(row.upshreni2id ?? "");
    if (localUpShreni != null && rowUpshreni2Id != null) {
      localUpShreni2 = masterDataList.firstWhere(
        (e) => e.parentid == localUpShreni!.id && e.id == rowUpshreni2Id,
        orElse: () => Masterdata(),
      );
      if (localUpShreni2.id == null) localUpShreni2 = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, margin: EdgeInsets.only(bottom: 14), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3))),
                  Text("${Statics.getLabel('editEntry')}", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.w600, fontSize: 18)),
                  SizedBox(height: 12),
                  textControllerField2(name: Statics.getLabel('Name'), controller: naavCtrl, isRequired: true),
                  textControllerField2(name: Statics.getLabel('Address'), controller: pattaCtrl),
                  textControllerField2(name: Statics.getLabel('doorBhash'), controller: doorbhashCtrl, keyboardType: TextInputType.number, maxInput: 10, isRequired: true),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<int>(
                          contentPadding: EdgeInsets.zero,
                          title: Text("${Statics.getLabel('Male')}"),
                          value: 0,
                          groupValue: localIsFemale,
                          onChanged: (v) => setSheetState(() => localIsFemale = v),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<int>(
                          contentPadding: EdgeInsets.zero,
                          title: Text("${Statics.getLabel('Female')}"),
                          value: 1,
                          groupValue: localIsFemale,
                          onChanged: (v) => setSheetState(() => localIsFemale = v),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("${Statics.getLabel('Category')}/${Statics.getLabel('upshreni')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: 6),
                  bulkAnyaCascadeDropdown(
                    localShreni: localShreni,
                    localUpShreni: localUpShreni,
                    localUpShreni2: localUpShreni2,
                    onShreniChanged: (v) => setSheetState(() {
                      localShreni = v;
                      localUpShreni = null;
                      localUpShreni2 = null;
                    }),
                    onUpShreniChanged: (v) => setSheetState(() {
                      localUpShreni = v;
                      localUpShreni2 = null;
                    }),
                    onUpShreni2Changed: (v) => setSheetState(() => localUpShreni2 = v),
                  ),
                  SizedBox(height: 12),
                  if (vastisarvekshanDropDownDataModel != null)
                    vastisarvekshanDropdown2(
                      question: Statics.getLabel('special'),
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "अन्यप्रभावीलोकंविशेष",
                      hintText: Statics.getLabel('selectVishesh'),
                      editId: row.anyaVisheshid,
                      selectedValue: localVishesh,
                      onItemSelected: (id, value, isOther) {},
                      onSelectionChanged: (v) => setSheetState(() => localVishesh = v),
                    ),
                  if (vastisarvekshanDropDownDataModel != null)
                    vastisarvekshanDropdown2(
                      question: Statics.getLabel('prabhavKshetra'),
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "अन्यप्रभावीलोकंप्रभावक्षेत्र",
                      hintText: Statics.getLabel('prabhavKshetraSelect'),
                      editId: row.anyaPrabhavKshetraid,
                      selectedValue: localPrabhavKshetra,
                      onItemSelected: (id, value, isOther) {},
                      onSelectionChanged: (v) => setSheetState(() => localPrabhavKshetra = v),
                    ),
                  textControllerField2(name: Statics.getLabel('anyaVisheshMahiti'), controller: anyaVisheshMahitiCtrl),
                  if (vastisarvekshanDropDownDataModel != null)
                    vastisarvekshanDropdown2(
                      question: Statics.getLabel('samparkStithi'),
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "अन्यप्रभावीलोकंसंपर्कस्थिति",
                      hintText: Statics.getLabel('samparkSthitiSelect'),
                      editId: row.anyaSamparkSthitiid,
                      selectedValue: localSamparkSthiti,
                      onItemSelected: (id, value, isOther) {},
                      onSelectionChanged: (v) => setSheetState(() => localSamparkSthiti = v),
                    ),
                  textControllerField2(name: Statics.getLabel('samparkSootraNaav'), controller: samparkNaavCtrl, isRequired: true),
                  textControllerField2(name: Statics.getLabel('samparakSootraDoorbhash'), controller: samparkDoorbhashCtrl, keyboardType: TextInputType.number, maxInput: 10, isRequired: true),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                      onPressed: () {
                        bool isValid = true;

                        if (isEmptyStr(naavCtrl.text)) {
                          Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                          isValid = false;
                        } else if (doorbhashCtrl.text.trim().length != 10) {
                          Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                          isValid = false;
                        } else if ((localSamparkSthiti?.id ?? row.anyaSamparkSthitiid) == null ||
                            (localPrabhavKshetra?.id ?? row.anyaPrabhavKshetraid) == null ||
                            (localVishesh?.id ?? row.anyaVisheshid) == null ||
                            (localUpShreni?.id ?? int.tryParse(row.upshreniid ?? "")) == null ||
                            (localShreni?.id ?? row.shreniid) == null) {
                          Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                          isValid = false;
                        } else if (isEmptyStr(samparkNaavCtrl.text)) {
                          Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                          isValid = false;
                        } else if (samparkDoorbhashCtrl.text.trim().length != 10) {
                          Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                          isValid = false;
                        }

                        if (!isValid) return;

                        row.naav = naavCtrl.text.trim();
                        row.patta = pattaCtrl.text.trim();
                        row.doorbhash = doorbhashCtrl.text.trim();
                        row.isfemale = localIsFemale;
                        row.anyaVisheshMahiti = anyaVisheshMahitiCtrl.text.trim();
                        row.samparkSutraNaav = samparkNaavCtrl.text.trim();
                        row.samparkSutraDoorbhash = samparkDoorbhashCtrl.text.trim();
                        if (localShreni != null) {
                          row.shreniid = localShreni!.id;
                          row.shreni = localShreni!.value;
                        }
                        if (localUpShreni != null) {
                          row.upshreniid = localUpShreni!.id?.toString();
                          row.upshreni = localUpShreni!.value;
                        }
                        if (localUpShreni2 != null) {
                          row.upshreni2id = localUpShreni2!.id?.toString();
                          row.upshreni2 = localUpShreni2!.value;
                        }
                        if (localVishesh != null) {
                          row.anyaVisheshid = localVishesh!.id;
                          row.anyaVishesh = localVishesh!.value;
                        }
                        if (localPrabhavKshetra != null) {
                          row.anyaPrabhavKshetraid = localPrabhavKshetra!.id;
                          row.anyaPrabhavKshetra = localPrabhavKshetra!.value;
                        }
                        if (localSamparkSthiti != null) {
                          row.anyaSamparkSthitiid = localSamparkSthiti!.id;
                          row.anyaSamparkSthiti = localSamparkSthiti!.value;
                        }

                        reclassifyBulkRow(row);
                        Navigator.of(ctx).pop();
                      },
                      child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget bulkAnyaCascadeDropdown({
    required Masterdata? localShreni,
    required Masterdata? localUpShreni,
    required Masterdata? localUpShreni2,
    required void Function(Masterdata?) onShreniChanged,
    required void Function(Masterdata?) onUpShreniChanged,
    required void Function(Masterdata?) onUpShreni2Changed,
  }) {
    List<Masterdata> masterDataList = vastisarvekshanDropDownDataModel?.masterdata ?? [];
    List<Masterdata> shreniItems = masterDataList.where((e) => e.typename == "श्रेणी").toList();
    List<Masterdata> upshreniItems = localShreni != null ? masterDataList.where((e) => e.parentid == localShreni.id).toList() : [];
    List<Masterdata> upshreni2Items = localUpShreni != null ? masterDataList.where((e) => e.parentid == localUpShreni.id).toList() : [];

    return Column(
      children: [
        _buildDropdown2(
          hintText: "${Statics.getLabel('selectShrenihint')}",
          value: localShreni,
          items: shreniItems,
          onChanged: (v) {
            onShreniChanged(v);
            onUpShreniChanged(null);
            onUpShreni2Changed(null);
          },
          viewName: true,
        ),
        if (upshreniItems.isNotEmpty) SizedBox(height: 10),
        if (upshreniItems.isNotEmpty)
          _buildDropdown2(
            hintText: "${Statics.getLabel('selectUpshreni')}",
            value: localUpShreni,
            items: upshreniItems,
            onChanged: (v) {
              onUpShreniChanged(v);
              onUpShreni2Changed(null);
            },
            viewName: true,
          ),
        if (upshreni2Items.isNotEmpty) SizedBox(height: 10),
        if (upshreni2Items.isNotEmpty)
          _buildDropdown2(
            hintText: "${Statics.getLabel('selectUpshreni2')}",
            value: localUpShreni2,
            items: upshreni2Items,
            onChanged: (v) => onUpShreni2Changed(v),
            viewName: true,
          ),
      ],
    );
  }

  /// ----------- COMMON FIELD WIDGETS ----------------
  Widget textControllerField2({
    required String name,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int? maxInput,
    double fieldHeight = 48, // 👈 sirf textfield ke liye height
    int minLines = 1,
    int maxLines = 1,
    int textFlex = 1,
    int valueFlex = 3,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: (name == Statics.getLabel('samparkSootraNaav') || name == Statics.getLabel('samparakSootraDoorbhash') || name == Statics.getLabel('sansthetKuthalaPadavar')) ? 2 : 1,
            // width: 120, // Label width fixed
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    "$name",
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (isRequired)
                  Container(
                    margin: EdgeInsets.only(right: 4),
                    child: Text(
                      "  *",
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            ":",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: (name == Statics.getLabel('samparkSootraNaav') || name == Statics.getLabel('samparakSootraDoorbhash') || name == Statics.getLabel('sansthetKuthalaPadavar')) ? 5 : 3,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxInput,
              minLines: minLines,
              maxLines: maxLines,
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: (fieldHeight - 20) / 2,
                  // 👆 fieldHeight ke hisaab se adjust hoga
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                ),
              ),
              // validator: (value) {
              //   if(isRequired){
              //     if(value == null || value.trim().isEmpty){
              //       return ;
              //     }
              //   }
              //   return null;
              // },
            ),
          ),
        ],
      ),
    );
  }

  Widget vastisarvekshanDropdown2({
    required VastisarvekshanDropDownDataModel dataModel,
    required String filterTypeName,
    required String hintText,
    required Function(int?, String?, int?) onItemSelected,
    String? question,
    int? editId,
    Masterdata? selectedValue,
    Function(Masterdata?)? onSelectionChanged,
    bool isRequired = true,
    bool isDisable = false,
  }) {
    List<Masterdata> filteredList = dataModel.masterdata!.where((item) => item.typename == filterTypeName).toList();

    Masterdata? selectedItem = selectedValue;
    if (selectedItem == null && editId != null) {
      try {
        selectedItem = filteredList.firstWhere((item) => item.id == editId);
        onItemSelected(selectedItem.id, selectedItem.value, selectedItem.isOther);
        onSelectionChanged?.call(selectedItem);
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (question != null)
            Expanded(
              flex: 1,
              // width: 120, // 👈 label ka fixed width (adjustable)
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      "$question",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (isRequired)
                    Flexible(
                      child: Text(
                        "*",
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (question != null)
            Text(
              ":",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          if (question != null) const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: IgnorePointer(
              ignoring: isDisable,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Masterdata>(
                    hint: Text(
                      hintText,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    value: selectedItem,
                    isExpanded: true,
                    items: filteredList.map((Masterdata item) {
                      return DropdownMenuItem<Masterdata>(
                        value: item,
                        child: Text(
                          item.value ?? "",
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (Masterdata? newValue) {
                      if (newValue != null) {
                        onItemSelected(newValue.id, newValue.value, newValue.isOther);
                        onSelectionChanged?.call(newValue);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetDropdowns() {
    setState(() {
      selectedShreni = null;
      selectedUpShreni = null;
      selectedUpShreni2 = null;
      anyaPrabhaviLokShreniId = null;
      anyaPrabhaviLokUpShreniId = null;
      anyaPrabhaviLokUpShreni1Id = null;
    });
  }

  Widget vastisarvekshanDropdown3({
    required String filterTypeName,
    required String hintText,
    required Function(int, String, Masterdata) onValueSelected,
    Function(int, String, Masterdata)? onDependentValueSelected,
    Function(int, String, Masterdata)? onThirdLevelValueSelected,
    int? anyaPrabhaviLokShreniId,
    int? anyaPrabhaviLokUpShreniId,
    int? anyaPrabhaviLokUpShreni1Id,
    BoxDecoration? decoration,
    Color? textColor,
    Color? borderColor,
    Color? iconColor,
    bool? viewName,
    bool isRequired = true,
    bool ignoreFirst = false,
    bool ignoreSecond = false,
    bool ignoreThird = false,
  }) {
    Masterdata? selectedValue = selectedShreni;
    Masterdata? selectedDependentValue = selectedUpShreni;
    Masterdata? selectedThirdLevelValue = selectedUpShreni2;

    List<Masterdata> masterDataList = vastisarvekshanDropDownDataModel?.masterdata ?? [];
    List<Masterdata> filteredItems = masterDataList.where((e) => e.typename == filterTypeName).toList();

    if (anyaPrabhaviLokShreniId != null && selectedValue == null) {
      selectedValue = filteredItems.firstWhere(
        (e) => e.id == anyaPrabhaviLokShreniId,
        orElse: () => filteredItems.isNotEmpty ? filteredItems.first : Masterdata(),
      );
      selectedShreni = selectedValue;
    }

    List<Masterdata> dependentItems = selectedValue != null ? masterDataList.where((e) => e.parentid == selectedValue!.id).toList() : [];

    if (anyaPrabhaviLokUpShreniId != null && selectedDependentValue == null) {
      selectedDependentValue = dependentItems.firstWhere(
        (e) => e.id == anyaPrabhaviLokUpShreniId,
        orElse: () => dependentItems.isNotEmpty ? dependentItems.first : Masterdata(),
      );

      selectedUpShreni = selectedDependentValue;
    }

    List<Masterdata> thirdLevelItems = selectedDependentValue != null ? masterDataList.where((e) => e.parentid == selectedDependentValue!.id).toList() : [];

    if (anyaPrabhaviLokUpShreni1Id != null && selectedThirdLevelValue == null) {
      selectedThirdLevelValue = thirdLevelItems.firstWhere(
        (e) => e.id == anyaPrabhaviLokUpShreni1Id,
        orElse: () => thirdLevelItems.isNotEmpty ? thirdLevelItems.first : Masterdata(),
      );

      selectedUpShreni2 = selectedThirdLevelValue;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (filteredItems.isNotEmpty)
          IgnorePointer(
            ignoring: ignoreFirst,
            child: _buildDropdown2(
              hintText: hintText,
              value: selectedValue,
              items: filteredItems,
              onChanged: (newValue) {
                if (newValue != null) {
                  anyaPrabhaviLokShreniId = newValue.id;
                  anyaPrabhaviLokShreniName = newValue.value;

                  setState(() {
                    selectedShreni = newValue;
                    selectedUpShreni = null;
                    selectedUpShreni2 = null;
                  });

                  onValueSelected(newValue.id!, newValue.value!, newValue);
                }
              },
              decoration: decoration,
              borderColor: borderColor,
              iconColor: iconColor,
              textColor: textColor,
              viewName: viewName,
            ),
          ),
        if (dependentItems.isNotEmpty) SizedBox(height: 10),
        if (dependentItems.isNotEmpty)
          IgnorePointer(
            ignoring: ignoreSecond,
            child: _buildDropdown2(
              hintText: "${Statics.getLabel('selectUpshreni')}",
              value: selectedDependentValue,
              items: dependentItems,
              onChanged: (newValue) {
                if (newValue != null) {
                  anyaPrabhaviLokUpShreniId = newValue.id;
                  anyaPrabhaviLokUpShreniName = newValue.value;

                  setState(() {
                    selectedUpShreni = newValue;
                    selectedUpShreni2 = null;
                  });

                  if (onDependentValueSelected != null) {
                    onDependentValueSelected(newValue.id!, newValue.value!, newValue);
                  }
                }
              },
              decoration: decoration,
              borderColor: borderColor,
              iconColor: iconColor,
              textColor: textColor,
              viewName: viewName,
            ),
          ),
        if (thirdLevelItems.isNotEmpty) SizedBox(height: 10),
        if (thirdLevelItems.isNotEmpty)
          IgnorePointer(
            ignoring: ignoreThird,
            child: _buildDropdown2(
              hintText: "${Statics.getLabel('selectUpshreni2')}",
              value: selectedThirdLevelValue,
              items: thirdLevelItems,
              onChanged: (newValue) {
                if (newValue != null) {
                  anyaPrabhaviLokUpShreni1Id = newValue.id;
                  anyaPrabhaviLokUpShreni1Name = newValue.value;

                  setState(() {
                    selectedUpShreni2 = newValue;
                  });

                  if (onThirdLevelValueSelected != null) {
                    onThirdLevelValueSelected(newValue.id!, newValue.value!, newValue);
                  }
                }
              },
              decoration: decoration,
              borderColor: borderColor,
              iconColor: iconColor,
              textColor: textColor,
              viewName: viewName,
            ),
          ),
      ],
    );
  }

  Widget _buildDropdown2<T extends Masterdata>({
    required String hintText,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    BoxDecoration? decoration,
    Color? textColor,
    Color? borderColor,
    Color? iconColor,
    bool? viewName,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: decoration ??
          BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor ?? Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          iconEnabledColor: iconColor ?? Colors.black,
          hint: Text(
            value != null && viewName == true ? value.value ?? "" : hintText,
            style: TextStyle(color: textColor ?? Colors.grey.shade600),
          ),
          value: items.any((e) => e.id == value?.id) ? value : null,
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.value ?? "",
                      style: TextStyle(color: textColor ?? Colors.black),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
