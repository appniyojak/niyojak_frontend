import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:niyojak_prod/widgets/app_drawer.dart';

import '../../../../helpers/static_data.dart' as Statics;
import '../../../../models/response_model/get_vasti_data_by_id_model.dart';
import '../../../../models/response_model/vasti_sarvekshan_dropdown_model.dart';
import '../../../../providers/bals.dart';

class VastiSurveyFormScreen extends StatefulWidget {
  static const String routeName = '/vasti-survey';

  const VastiSurveyFormScreen({super.key});

  @override
  State<VastiSurveyFormScreen> createState() => _VastiSurveyFormScreenState();
}

class _VastiSurveyFormScreenState extends State<VastiSurveyFormScreen> with SingleTickerProviderStateMixin {
  final TextEditingController sanghaKaryaVastiPramukhNameController = TextEditingController();
  final TextEditingController sanghaKaryaVastiStithiController = TextEditingController();
  final TextEditingController loksankhyaController = TextEditingController();
  final TextEditingController femaleController = TextEditingController();
  final TextEditingController maleController = TextEditingController();
  final TextEditingController vastiChatahuSimaController = TextEditingController();
  final TextEditingController niyamitChalnareUpkramController = TextEditingController();
  final TextEditingController niyamitChalnareUpkramGatividhiController = TextEditingController();
  final TextEditingController vsahatPrakarBhavnacheNavController = TextEditingController();
  final TextEditingController vsahatPrakarSamparkKshetraController = TextEditingController();
  final TextEditingController vsahatPrakarDurbhashController = TextEditingController();
  final TextEditingController vastitHonareSamajikAnyakaryakramController = TextEditingController();

  GetVastiDataByIdModel? vastiDataByIdModel;

  Future<dynamic> searchVastiData(String? vastiId) async {
    // resetData();
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "vastiid": vastiId,
        "isVasti": 1,
        "AppUserID": Statics.userDetails['userID'],
      });
      print("searchVastiData req param :-  $strInput");
      vastiDataByIdModel = await Statics.getVastidataByIDForApp(context, strInput);
      setDataAfterSearch();
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
  }

  int? step1completepercentage;
  int? step2completepercentage;
  int? step3completepercentage;

  String? step1pendingpoints;
  String? step2pendingpoints;
  String? step3pendingpoints;

  void setDataAfterSearch() async {
    setState(() {
      sanghaKaryaVastiStithiController.text = vastiDataByIdModel!.vastisarvekshan!.vastiShakhaType == null ? "" : vastiDataByIdModel!.vastisarvekshan!.vastiShakhaType!;
      sanghaKaryaVastiPramukhNameController.text = vastiDataByIdModel!.vastisarvekshan!.vastiShakhaPramukhName ?? "";
      loksankhyaController.text = vastiDataByIdModel!.vastisarvekshan!.lokasankhya ?? "";
      vastiSamitiYesNo = int.parse(vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti == null ||
              vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti! == "null" ||
              vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti == ""
          ? "2"
          : vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti!);
      durjanShaktiYesNo = vastiDataByIdModel!.vastisarvekshan!.durjanShaktiYesNo!;
      beforsanghaonnowisoff = vastiDataByIdModel!.vastisarvekshan!.beforeShakhaSaptahikIsOnNowOff == null ? 2 : vastiDataByIdModel!.vastisarvekshan!.beforeShakhaSaptahikIsOnNowOff;
      kuthalaVarshiDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarKuthalyavarsi ?? [];
      vastiChatahuSimaController.text = vastiDataByIdModel!.vastisarvekshan!.vasticyacatuSima ?? "";
      selectedFileName = vastiDataByIdModel!.vastisarvekshan!.googlemap ?? "";
      jagranShreniEnteredDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarJaagaranshreneesthiti ?? [];
      enteredDataListGatividhi = vastiDataByIdModel!.vastisarvekshan!.vastisarGatividhikaryasthiti ?? [];
      enteredVasahatPrakarDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVasahatprakara ?? [];
      enteredVividhBhashaBolnareDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVividhaprakara ?? [];
      enteredKontyaPraantacheDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarKonatyaprantache ?? [];
      enteredreligionDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarReligion ?? [];
      upasnaSthalDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarupaasana ?? [];
      sajjanShaktiDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarsajjanshakti ?? [];
      anyaPrabhaviLokDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarAnyaprabhavilokam ?? [];
      vastitSajarHonareSanDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVastitamahatvacesana ?? [];
      vastitSajarHonareSamajikKaryakramDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVastitasajaraSamajikkaryakram ?? [];

      step1completepercentage = vastiDataByIdModel!.vastisarvekshan!.step1completepercentage;

      step1pendingpoints = vastiDataByIdModel!.vastisarvekshan!.step1pendingpoints;

      /// STEP 2 FORM DATA =====================================================================================================
      vastitBalopasanaKendraDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVastitilabalopasanakendra ?? [];
      motheVyasayikKendraDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarMothevyavasayikakendra ?? [];
      nirmandhinMothePrakalpaDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarNirmanadhinamothe ?? [];
      motheRugnalayDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarMotherugnalaya ?? [];
      agniShamanDalKendraAhe = vastiDataByIdModel!.vastisarvekshan!.agnishamandal == null ? 2 : vastiDataByIdModel!.vastisarvekshan!.agnishamandal;
      polichChoukiAhe = vastiDataByIdModel!.vastisarvekshan!.policethane == null ? 2 : vastiDataByIdModel!.vastisarvekshan!.policethane;
      allShaikshanikPrakarDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarschooltapasila ?? [];
      maidanUddyanDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarmaidan ?? [];
      jahirKaryakramDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarJahirakaryakramasambandhi ?? [];

      step2completepercentage = vastiDataByIdModel!.vastisarvekshan!.step2completepercentage;

      step2pendingpoints = vastiDataByIdModel!.vastisarvekshan!.step2pendingpoints;

      /// STEP 3 FORM DATA =====================================================================================================
      vastiPrashnaGarjaDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVastitilasamajika ?? [];
      dharmikNetrutvaDataList = vastiDataByIdModel!.vastisarvekshan!.vastisardhaarmiknetrtav ?? [];
      durjanShaktiDataList = vastiDataByIdModel!.vastisarvekshan!.vastisardurjanshakti ?? [];
      hinduVeerYadiDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarHinduvirayadi ?? [];

      step3completepercentage = vastiDataByIdModel!.vastisarvekshan!.step3completepercentage;
      step3pendingpoints = vastiDataByIdModel!.vastisarvekshan!.step3pendingpoints;
      // ===========================================
      _isStep1Completed = vastiDataByIdModel!.vastisarvekshan!.stepOneComplete ?? true;
      _isStep2Completed = vastiDataByIdModel!.vastisarvekshan!.stepTwoComplete ?? true;
      print("_isStep1Completed $_isStep1Completed ----   _isStep2Completed $_isStep2Completed");
    });
  }

  void resetData() async {
    setState(() {
      sanghaKaryaVastiStithiController.clear();
      sanghaKaryaVastiPramukhNameController.clear();
      loksankhyaController.clear();
      vastiSamitiYesNo = 2;
      durjanShaktiYesNo = 2;
      beforsanghaonnowisoff = 2;
      kuthalaVarshiDataList = [];
      vastiChatahuSimaController.clear();
      jagranShreniEnteredDataList = [];
      enteredDataListGatividhi = [];
      enteredVasahatPrakarDataList = [];
      enteredVividhBhashaBolnareDataList = [];
      enteredKontyaPraantacheDataList = [];
      enteredreligionDataList = [];
      upasnaSthalDataList = [];
      sajjanShaktiDataList = [];
      anyaPrabhaviLokDataList = [];
      vastitSajarHonareSanDataList = [];
      vastitSajarHonareSamajikKaryakramDataList = [];
      imageAdd = 0;

      /// STEP 2 FORM DATA
      vastitBalopasanaKendraDataList = [];
      motheVyasayikKendraDataList = [];
      nirmandhinMothePrakalpaDataList = [];
      motheRugnalayDataList = [];
      agniShamanDalKendraAhe = 2;
      polichChoukiAhe = 2;
      allShaikshanikPrakarDataList = [];
      maidanUddyanDataList = [];
      jahirKaryakramDataList = [];

      /// STEP 3 FORM DATA
      vastiPrashnaGarjaDataList = [];
      dharmikNetrutvaDataList = [];
      durjanShaktiDataList = [];
      hinduVeerYadiDataList = [];

      ///
      _isStep1Completed = false;
      _isStep2Completed = false;
      _linkedMahaanagarValue = null;
      _linkedVibhaagValue = null;
      _linkedBhaagValue = null;
      _linkedNagarValue = null;
      mahanagarId = '';
      selctedLevelName = "";
      selctedLevel = 'praant';
      _linkedvastiValue = '';
      selctedLevelId = '';
      selctedLevelName = "";
      _linkedBhaag = null;
      _linkedNagar = null;
      _linkedvasti = null;
      isVastiSearch = false;
      selctedLevelName = '';
    });
  }

  void showPopupForVastiValidation(BuildContext context) {
    log("showPopupForVastiValidation is opened >>>>>>>>>>>>>> ");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "${Statics.getLabel('suchana')}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
            fontSize: 18,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "${Statics.getLabel('vastiSelectMandetoryValidation')}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red.shade800,
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "${Statics.getLabel('okay')}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void showPopupForNaviagtetoOtherPage(
    BuildContext context,
    String pageName1,
    String pageName2,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "${Statics.getLabel('suchana')}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
            fontSize: 18,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "$pageName2 ${Statics.getLabel('bharnyaPurvi')} $pageName1 ${Statics.getLabel('bharneImportant')}\n $pageName1 ${Statics.getLabel('sangrahKelyaNantr')} $pageName2 ${Statics.getLabel('bhartaYeil')}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red.shade800,
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "${Statics.getLabel('okay')}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

// ==================   DROP - DOWNS ====================================================================================================================================
  bool _isExpanded = true;
  bool isVastiSearch = false;
  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedNagarValue = '';
  String? _linkedgraamValue = '';
  String? _linkedMandalValue = '';
  String? _linkedvastiValue = '';
  String? mahanagarId = '';
  String? vibhagId = '';
  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? selctedLevelNameNew = '';
  String? selctedLevelIdNew = '';
  int? vastiSamitiYesNo = 2;
  int? durjanShaktiYesNo = 2;
  int? beforsanghaonnowisoff = 2;
  int? anyaVividhKshetracheKame = 2;
  int? gavatilMumbaikar = 2;
  int? agniShamanDalKendraAhe = 2;
  int? polichChoukiAhe = 2;
  int? gaavSamitiYesNo = 2;

  String? selectedValueAll;
  String? selectedValueMale;
  String? selectedValueFemale;
  String? ekunLoksankhya;

  final Map<String, String> options = {
    '{Statics.getLabel(moreThan40000)}': '44444',
    '{Statics.getLabel(20000to40000)}': '22222',
    '{Statics.getLabel(10000to20000)}': '11111',
    '{Statics.getLabel(5000to10000)}': '5555',
    '{Statics.getLabel(3000to5000)}': '3333',
    '{Statics.getLabel(1000to3000)}': '1111',
    '{Statics.getLabel(lessThan1000)}': '999',
  };

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVastiDropdown(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }

  late TabController _tabController;
  bool? _isStep1Completed = false;
  bool? _isStep2Completed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    populateDropdown();
    fetchVastiSurveyDropdownData();
    _tabController.addListener(_handleTabSelection);
    if ((int.parse(Statics.userDetails['LevelID']) <= 2)) {
      setState(() {
        isVastiSearch = true;
        _isExpanded = false;
        selctedLevelId = Statics.userDetails['LinkedVastiID'].toString();
        selctedLevelName = Statics.userDetails['LinkedVastiName'].toString();
        selctedLevel = "Vasti";
      });
      searchVastiData(Statics.userDetails['LinkedVastiID'].toString());
      print("Statics.userDetails['LinkedVastiID']  ${Statics.userDetails['LinkedVastiID']}");
      print("DOOOOOOOOOOOOOOOOOOOOONE");
    } else {
      print("NOOOOOOOOOOOOOOOOOOOTTTTTTTTTT   DOOOOOOOOOOOOOOOOOOOOONE");
    }
  }

  void _handleTabSelection() {
    if (_tabController.index == 1 && !_isStep1Completed!) {
      showPopupForNaviagtetoOtherPage(context, Statics.getLabel('basicInfo'), Statics.getLabel('OtherInfo'));
      _tabController.index = 0;
    } else if (_tabController.index == 2) {
      if (!_isStep1Completed!) {
        showPopupForNaviagtetoOtherPage(context, Statics.getLabel('basicInfo'), Statics.getLabel('detailedInfo'));
        _tabController.index = 0;
      } else if (!_isStep2Completed!) {
        showPopupForNaviagtetoOtherPage(context, Statics.getLabel('OtherInfo'), Statics.getLabel('detailedInfo'));
        _tabController.index = 1;
      }
    }
  }

  VastisarvekshanDropDownDataModel? vastisarvekshanDropDownDataModel;

  Future<void> fetchVastiSurveyDropdownData() async {
    try {
      vastisarvekshanDropDownDataModel = await Statics.getVastiSurveyDropDownList(Statics.userDetails["userID"]);
      setState(() {});
    } catch (e) {
      print('Error fetching notification data: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    // maleController.dispose();
    // femaleController.dispose();
    loksankhyaController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          Statics.getLabel('vastiSurvey'),
          style: TextStyle(fontSize: 24),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 5.0, color: Colors.white),
            insets: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: Statics.getLabel('basicInfo')),
            Tab(text: Statics.getLabel('otherInfo')),
            Tab(text: Statics.getLabel('detailedInfo')),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            _buildStep1(),
            _buildStep2(),
            _buildStep3(),
          ],
        ),
      ),
    );
  }

  //=======================================================================================================================================================================================================
  String? selectedFilePath;
  String? filePathOg;
  String? selectedFileName; // To display the file name
  int? imageAdd = 0;
  ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  Widget filePickerField({
    required BuildContext context,
    required String question,
    required Function(String?, String?) onFileSelected,
    List<String>? allowedExtensions,
    String? selectedFileName,
    int? questionNumber,
    bool isLoading = false,
    ValueNotifier<bool>? loadingNotifier,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${questionNumber != null ? "$questionNumber. " : ""}$question",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                if (selectedFileName != null && selectedFileName.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: imageAdd == 1
                                  ? Image.file(
                                      File(filePathOg!),
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(
                                      '${Statics.baseUrl}/Files/Vastisarvekshanforms/$selectedFileName',
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
              icon: Icon(Icons.remove_red_eye, color: Colors.purpleAccent),
            ),
          ],
        ),
        InkWell(
          onTap: () async {
            loadingNotifier?.value = true;
            try {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: allowedExtensions == null ? FileType.any : FileType.custom,
                allowedExtensions: allowedExtensions,
              );
              if (result != null && result.files.isNotEmpty) {
                String filePath = result.files.single.path!;
                filePathOg = result.files.single.path!;
                String fileName = result.files.single.name;
                File file = File(filePath);
                img.Image? originalImage = img.decodeImage(file.readAsBytesSync());
                if (originalImage != null) {
                  img.Image compressedImage = img.copyResize(originalImage, width: originalImage.width);
                  while (compressedImage.length > 2 * 1024 * 1024) {
                    compressedImage = img.copyResize(compressedImage, width: (compressedImage.width * 0.9).toInt());
                  }
                  List<int> compressedBytes = img.encodeJpg(compressedImage, quality: 85);
                  String base64String = base64Encode(compressedBytes);
                  String base64File = "data:image/jpg;base64,$base64String";
                  onFileSelected(base64File, fileName);
                }
              }
            } catch (e) {
              log("Error during file processing: $e");
            } finally {
              loadingNotifier?.value = false;
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedFileName ?? "${Statics.getLabel('selectFile')}",
                    style: TextStyle(color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                loadingNotifier != null
                    ? ValueListenableBuilder<bool>(
                        valueListenable: loadingNotifier,
                        builder: (context, isLoading, _) {
                          return isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(Icons.attach_file, color: Colors.blue);
                        },
                      )
                    : Icon(Icons.attach_file, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget textControllerField2(
      {required String name,
      required TextEditingController controller,
      double height = 50.0,
      TextInputType keyboardType = TextInputType.text,
      bool isEdit = false,
      String? hintTextString,
      String? imp,
      int? maxInput}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: imp,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: height,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white,
              hintText: hintTextString,
            ),
            readOnly: isVastiSearch == false ? true : isEdit,
            onTap: () {
              if (isVastiSearch) {
                print("Nothing");
              } else {
                showPopupForVastiValidation(context);
              }
            },
            maxLength: maxInput,
            buildCounter: (context, {int? currentLength, int? maxLength, bool? isFocused}) => null,
            inputFormatters: keyboardType == TextInputType.number ? [FilteringTextInputFormatter.digitsOnly] : null,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  //=======================================================================================================================================================================================================
  Widget textControllerField(
    String? hintText,
    TextEditingController controller,
    BuildContext context, {
    int? questionNumber,
    double? height,
    TextInputType keyboardType = TextInputType.text,
  }) {
    Size size = MediaQuery.of(context).size;

    // Responsive height based on screen size
    double defaultHeight = size.height * 0.07;
    double responsiveFontSize(double scale) => size.width * scale;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.012),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hintText != null)
            Text(
              "${questionNumber != null ? "$questionNumber. " : ""}$hintText",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
          SizedBox(height: size.height * 0.008),
          Container(
            height: height ?? defaultHeight,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              maxLines: null,
              expands: true,
              keyboardType: keyboardType,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.015,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(color: Colors.black54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(color: Colors.black87, width: 1.5),
                ),
              ),
              readOnly: isVastiSearch == false ? true : false,
              onTap: () {
                if (isVastiSearch) {
                  print("Nothing");
                } else {
                  showPopupForVastiValidation(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //=======================================================================================================================================================================================================
  Widget yesNoRadioButton({
    required String question,
    required Function(int) onChanged,
    required int selectedOption,
    int? questionNumber,
    String? imp,
    bool isDisable = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${questionNumber != null ? "$questionNumber. " : ""}$question",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: imp,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Radio<int>(
              value: 1,
              groupValue: selectedOption,
              onChanged: isDisable
                  ? null
                  : (value) {
                      if (value != null) onChanged(value);
                    },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              "${Statics.getLabel('ConfirmationYes')}",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(width: 20),
            Radio<int>(
              value: 0,
              groupValue: selectedOption,
              onChanged: isDisable
                  ? null
                  : (value) {
                      if (value != null) onChanged(value);
                    },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              "${Statics.getLabel('ConfirmationNo')}",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  //=======================================================================================================================================================================================================
  Widget mainContainer(String header, Widget child) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Divider(color: Colors.black87, thickness: 1),
          SizedBox(
            height: 10,
          ),
          child,
        ],
      ),
    );
  }

//======================================================================================================================================================================================================
  Widget vastisarvekshanDropdown(
      {required String filterTypeName,
      required String hintText,
      required Function(int, String) onValueSelected,
      Function(int, String)? onDependentValueSelected,
      Function(int, String)? onThirdLevelValueSelected,
      BoxDecoration? decoration,
      Color? textColor,
      Color? borderColor,
      Color? iconColor,
      bool? viewName}) {
    List<Masterdata> masterDataList = vastisarvekshanDropDownDataModel!.masterdata!;
    Masterdata? selectedValue;
    Masterdata? selectedDependentValue;
    Masterdata? selectedThirdLevelValue;

    List<Masterdata> filteredItems = masterDataList.where((e) => e.typename == filterTypeName).toList();
    List<Masterdata> dependentItems = [];
    List<Masterdata> thirdLevelItems = [];

    void updateDependentItems(int parentId, Function setState) {
      setState(() {
        dependentItems = masterDataList.where((e) => e.parentid == parentId).toList();
        selectedDependentValue = null;
        thirdLevelItems = [];
        selectedThirdLevelValue = null;
      });
    }

    void updateThirdLevelItems(int parentId, Function setState) {
      setState(() {
        thirdLevelItems = masterDataList.where((e) => e.parentid == parentId).toList();
        selectedThirdLevelValue = null;
      });
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (filteredItems.isNotEmpty)
              _buildDropdown(
                  hintText: hintText,
                  value: selectedValue,
                  items: filteredItems,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedValue = newValue;
                        print("Selected ID: ${selectedValue!.id}, Selected Name: ${selectedValue!.value}");
                        onValueSelected(selectedValue!.id!, selectedValue!.value!);
                        updateDependentItems(selectedValue!.id!, setState);
                      });
                    }
                  },
                  decoration: decoration,
                  borderColor: borderColor,
                  iconColor: iconColor,
                  textColor: textColor,
                  viewName: viewName),
            if (dependentItems.isNotEmpty) SizedBox(height: 10),
            if (dependentItems.isNotEmpty)
              _buildDropdown(
                  hintText: "Select Dependent Value",
                  value: selectedDependentValue,
                  items: dependentItems,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedDependentValue = newValue;
                        print("Selected Dependent ID: ${selectedDependentValue!.id}, Name: ${selectedDependentValue!.value}");
                        if (onDependentValueSelected != null) {
                          onDependentValueSelected(selectedDependentValue!.id!, selectedDependentValue!.value!);
                        }
                        updateThirdLevelItems(selectedDependentValue!.id!, setState);
                      });
                    }
                  },
                  decoration: decoration,
                  borderColor: borderColor,
                  iconColor: iconColor,
                  textColor: textColor,
                  viewName: viewName),
            if (thirdLevelItems.isNotEmpty) SizedBox(height: 10),
            if (thirdLevelItems.isNotEmpty)
              _buildDropdown(
                hintText: "Select Third Level Value",
                value: selectedThirdLevelValue,
                items: thirdLevelItems,
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedThirdLevelValue = newValue;
                      print("Selected Third Level ID: ${selectedThirdLevelValue!.id}, Name: ${selectedThirdLevelValue!.value}");
                      if (onThirdLevelValueSelected != null) {
                        onThirdLevelValueSelected(selectedThirdLevelValue!.id!, selectedThirdLevelValue!.value!);
                      }
                    });
                  }
                },
                decoration: decoration,
                borderColor: borderColor,
                iconColor: iconColor,
                textColor: textColor,
                viewName: viewName,
              ),
          ],
        );
      },
    );
  }

  Widget _buildDropdown<T extends Masterdata>(
      {required String hintText,
      required T? value,
      required List<T> items,
      required Function(T?) onChanged,
      BoxDecoration? decoration,
      Color? textColor,
      Color? borderColor,
      Color? iconColor,
      bool? viewName}) {
    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: decoration ??
          BoxDecoration(
            border: Border.all(color: borderColor ?? Colors.white, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          iconEnabledColor: iconColor ?? Colors.white,
          // Customizable icon color
          hint: Text(
            value != null && viewName == true ? value.value ?? "No Value" : hintText,
            style: TextStyle(color: textColor ?? Colors.white),
          ),
          value: value,
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      item.value ?? "No Value",
                      style: TextStyle(color: textColor ?? Colors.black), // Dropdown items color
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  //======================================================================================================================================================================================================
  Widget vastisarvekshanDropdown2({
    required VastisarvekshanDropDownDataModel dataModel,
    required String filterTypeName,
    required String hintText,
    required Function(int?, String?, int?) onItemSelected,
    String? question,
    double? width,
    int? questionNumber,
    int? editId,
    Masterdata? selectedValue,
    Function(Masterdata?)? onSelectionChanged,
  }) {
    List<Masterdata> filteredList = dataModel.masterdata!.where((item) => item.typename == filterTypeName).toList();

    Masterdata? selectedItem = selectedValue;
    if (selectedItem == null && editId != null) {
      try {
        selectedItem = filteredList.firstWhere((item) => item.id == editId);
        onItemSelected(selectedItem.id, selectedItem.value, selectedItem.isOther);
        if (onSelectionChanged != null) {
          onSelectionChanged(selectedItem);
        }
      } catch (e) {
        selectedItem = null;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question != null)
          Text(
            "${questionNumber != null ? "$questionNumber. " : ""}$question",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        SizedBox(height: 5),
        Container(
          height: 50,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Masterdata>(
              hint: Text(hintText, style: TextStyle(color: Colors.black54)),
              value: selectedItem,
              isExpanded: true,
              items: filteredList.map((Masterdata item) {
                return DropdownMenuItem<Masterdata>(
                  value: item,
                  child: Text(item.value ?? "", style: TextStyle(color: Colors.black)),
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
      ],
    );
  }

//====================================================================================================================================================================================================================

  Widget vastisarvekshanDropdown4({
    required VastisarvekshanDropDownDataModel dataModel,
    required String filterTypeName,
    required String hintText,
    required Function(int?, String?, int?) onItemSelected,
    required List<int> excludedItemIds,
    String? question,
    double? width,
    int? questionNumber,
    int? editId,
    Masterdata? selectedValue,
    Function(Masterdata?)? onSelectionChanged,
  }) {
    List<Masterdata> filteredList = dataModel.masterdata!.where((item) => item.typename == filterTypeName && !excludedItemIds.contains(item.id)).toList();

    Masterdata? selectedItem = selectedValue;

    if (selectedItem == null && editId != null) {
      try {
        selectedItem = dataModel.masterdata!.firstWhere((item) => item.id == editId && item.typename == filterTypeName);
        onItemSelected(selectedItem.id, selectedItem.value, selectedItem.isOther);
        if (onSelectionChanged != null) {
          onSelectionChanged(selectedItem);
        }
      } catch (e) {
        selectedItem = null;
      }
    }

    if (selectedItem != null && !filteredList.any((item) => item.id == selectedItem!.id)) {
      filteredList.add(selectedItem!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              "${questionNumber != null ? "$questionNumber. " : ""}$question",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        Container(
          height: 50,
          width: width ?? double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Masterdata>(
              hint: Text(hintText, style: TextStyle(color: Colors.black54)),
              value: selectedItem,
              isExpanded: true,
              items: filteredList.map((Masterdata item) {
                return DropdownMenuItem<Masterdata>(
                  value: item,
                  child: Text(item.value ?? "", style: TextStyle(color: Colors.black)),
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
      ],
    );
  }

// ================================================   BASIC INFO FORM =================================================================================================================================
  Widget _buildStep1() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          if ((int.parse(Statics.userDetails['LevelID']) > 5))
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
                        children: [
                          if (_linkedMahaanagar != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: "${Statics.getLabel('MahaanagarKaaryakartaaCount')}"),
                              isExpanded: true,
                              value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                              items: _linkedMahaanagar!
                                  .map((bg) => DropdownMenuItem(
                                        value: bg.geoUnitID.toString(),
                                        child: Text(bg.name!),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedMahaanagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  _linkedMahaanagarValue = value;
                                  _linkedVibhaagValue = null;
                                  _linkedBhaagValue = null;
                                  _linkedNagarValue = null;
                                  populatelinkedVibhaagDropdown(value!);
                                  mahanagarId = value;
                                  selctedLevelId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Mahanagar';
                                });
                                print("Selected Id: $value");
                                print("Selected Level Name: ${selectedItem.name}");
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedVibhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: "${Statics.getLabel('Vibhaag')}"),
                              isExpanded: true,
                              value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                              items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                print(value);
                                setState(() {
                                  _linkedVibhaagValue = value;
                                  populatelinkedBhaagDropdown(value!);
                                  vibhagId = value;
                                  _linkedBhaagValue = _linkedNagarValue = null;
                                  _linkedBhaag = _linkedNagar = null;
                                  selctedLevelId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Vibhaag';
                                });
                                print("Selected Id: $value");
                                print("Selected Level Name: ${selectedItem.name}");
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedBhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: "${Statics.getLabel('Bhaag')}"),
                              isExpanded: true,
                              value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                              items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  _linkedBhaagValue = value;
                                  populatelinkedNagarDropdown(value, null);
                                  selctedLevelId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Bhaag';
                                });
                                print("Selected Id: $value");
                                print("Selected Level Name: ${selectedItem.name}");
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: "${Statics.getLabel('Nagar')}"),
                              isExpanded: true,
                              value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                              items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  _linkedNagarValue = value;
                                  populatelinkedVastiDropdown(value!);
                                  selctedLevelId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Nagar';
                                });
                                print("Selected Id: $value");
                                print("Selected Level Name: ${selectedItem.name}");
                              },
                            ),
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_linkedvasti != null && _linkedvasti!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: "${Statics.getLabel('Vasti')}"),
                              isExpanded: true,
                              value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                              items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedvasti!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  _linkedvastiValue = value;
                                  selctedLevelId = value;
                                  selctedLevelName = selectedItem.name ?? "";
                                  selctedLevel = 'Vasti';
                                });
                                print("Selected Id: $value");
                                print("Selected Level Name: ${selectedItem.name}");
                              },
                            ),
                          if (_linkedvasti != null && _linkedvasti!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (selctedLevel == "Vasti")
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                                onPressed: () {
                                  if (selctedLevel == "Vasti") {
                                    setState(() {
                                      isVastiSearch = true;
                                      _isExpanded = false;
                                    });
                                    print("selctedLevel $selctedLevel -- selctedLevelId $selctedLevelId -- selctedLevelName $selctedLevelName");
                                    searchVastiData(selctedLevelId);
                                  } else {
                                    Statics.showToast(Statics.getLabel('vastiGramValidation'));
                                  }
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
          if (isVastiSearch == false)
            SizedBox(
              height: 10,
            ),
          if (isVastiSearch == false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${Statics.getLabel('Note')} :- ${Statics.getLabel('vastiSelectMandetoryValidation')}",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Container(
                  height: 2,
                  width: 300,
                  color: Colors.red,
                ),
              ],
            ),
          if (selctedLevel == "Vasti" && selctedLevelName != "" && isVastiSearch == true)
            SizedBox(
              height: 20,
            ),
          if (selctedLevel == "Vasti" && selctedLevelName != "" && isVastiSearch == true)
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
                      "${Statics.getLabel('VastiKaaryakartaaCount')} ->  ",
                      style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      " $selctedLevelName",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                )),
          if (isVastiSearch == true)
            SizedBox(
              height: 10,
            ),
          if (isVastiSearch == true)
            if (step1completepercentage != null)
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    dynamicProgressBar(context: context, value: double.parse(step1completepercentage.toString()), detailListItems: step1pendingpoints!.split(',')),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        // Filter out empty or whitespace-only strings
                        final filteredDetails = step1pendingpoints!.split(',').where((item) => item.trim().isNotEmpty).toList();

                        print("Filtered step1pendingpoints!.split(','): $filteredDetails");

                        if (filteredDetails.isEmpty) {
                          Statics.showToast(Statics.getLabel('allInfoSubmit'));
                          return;
                        }

                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon and Title
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
                                        SizedBox(width: 8),
                                        Text(
                                          Statics.getLabel('remainingQuestion'),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 300,
                                      child: ListView.builder(
                                        itemCount: filteredDetails.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              "${index + 1}. ${filteredDetails[index]}",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text(Statics.getLabel('bandKara')),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.red.shade300,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "${Statics.getLabel('remainingQuestion')}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          if (isVastiSearch == true)
            SizedBox(
              height: 10,
            ),
          if (isVastiSearch == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• ", style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Icon(Icons.remove_red_eye, color: Colors.green, size: 15),
                        Icon(Icons.edit, color: Colors.blue, size: 15),
                        Icon(Icons.delete, color: Colors.red, size: 15),
                      ],
                    ),
                    Expanded(
                      child: Text(
                        "${Statics.getLabel('rowSelectionImportant')}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• ", style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Expanded(
                      child: Text(
                        "${Statics.getLabel('wholeNoValidation')}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          SizedBox(
            height: 20,
          ),
          // ===================================== SANGHA KARYA  STITHI ==================================================================================
          mainContainer(
            "${Statics.getLabel('sanghakarya')}",
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Align(alignment: Alignment.centerLeft, child: Text("${Statics.getLabel('vastiPramukhName')}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15))),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "- ${sanghaKaryaVastiPramukhNameController.text}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: sanghaKaryaVastiPramukhNameController.text == "नियुक्त नाही" ? Colors.red : Colors.purple,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      textControllerField2(name: "${Statics.getLabel('Population')}", controller: loksankhyaController, keyboardType: TextInputType.number, imp: "*"),
                      // Column(
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Expanded(
                      //           child: textControllerField2(
                      //               name:
                      //                   "${Statics.getLabel('prushaanchiSankhya')}",
                      //               controller: maleController,
                      //               keyboardType: TextInputType.number,
                      //               imp: "*"),
                      //         ),
                      //         SizedBox(width: 16),
                      //         Expanded(
                      //           child: textControllerField2(
                      //               name:
                      //                   "${Statics.getLabel('mahilanchiSankhya')}",
                      //               controller: femaleController,
                      //               keyboardType: TextInputType.number,
                      //               imp: "*"),
                      //         ),
                      //       ],
                      //     ),
                      //     // SizedBox(height: 10),
                      //     Text(
                      //       '${Statics.getLabel('Population')}: $total',
                      //       style: TextStyle(
                      //           fontSize: 15, fontWeight: FontWeight.bold),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(height: 10),
                      yesNoRadioButton(
                          question: "${Statics.getLabel('isVastiSamiti')}",
                          selectedOption: vastiSamitiYesNo ?? 2,
                          onChanged: (value) {
                            if (isVastiSearch) {
                              setState(() {
                                vastiSamitiYesNo = value;
                              });
                            } else {
                              showPopupForVastiValidation(
                                context,
                              );
                            }
                          },
                          imp: "*"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      yesNoRadioButton(
                          question: "${Statics.getLabel('purvuKadhitarishakha')}",
                          selectedOption: beforsanghaonnowisoff ?? 2,
                          onChanged: (value) {
                            if (isVastiSearch) {
                              setState(() {
                                beforsanghaonnowisoff = value;
                              });
                            } else {
                              showPopupForVastiValidation(
                                context,
                              );
                            }
                          }),
                      if (beforsanghaonnowisoff == 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${Statics.getLabel('tapshil')}",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                              onTap: () {
                                if (isVastiSearch) {
                                  showKuthalaVarshiPopup(context, onDataChanged: () => setState(() {}));
                                } else {
                                  showPopupForVastiValidation(
                                    context,
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                width: 100,
                                decoration:
                                    BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, color: Colors.white, size: 15),
                                      Text(
                                        "${Statics.getLabel('AddButton')}",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (beforsanghaonnowisoff == 1) SizedBox(height: 10),
                      if (beforsanghaonnowisoff == 1)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              child: DataTable(
                                showCheckboxColumn: false,
                                headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                columns: [
                                  DataColumn(
                                      label: Center(
                                          child: Text(
                                    "${Statics.getLabel('Vayogat')}",
                                  ))),
                                  DataColumn(
                                      label: Center(
                                          child: Text(
                                    "${Statics.getLabel('SelectFrequency')}",
                                  ))),
                                  DataColumn(
                                      label: Center(
                                          child: Text(
                                    "${Statics.getLabel('SankalpCompletionYear')}",
                                  ))),
                                ],
                                rows: (kuthalaVarshiDataList != null && kuthalaVarshiDataList!.isNotEmpty)
                                    ? kuthalaVarshiDataList!.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                        int index = entry.key;
                                        var data = entry.value;
                                        bool isSelected = selectedKuthalaVarshiIdIndex == index;
                                        return DataRow(
                                          selected: isSelected,
                                          color: MaterialStateProperty.resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                              if (isSelected) return Colors.yellow.shade100;
                                              return null;
                                            },
                                          ),
                                          onSelectChanged: (bool? selected) {
                                            if (selected != null && selected) {
                                              setState(() {
                                                selectedKuthalaVarshiIdIndex = index;
                                                print(" selectedKuthalaVarshiIdIndex Data :- $data");
                                              });
                                            }
                                          },
                                          cells: [
                                            DataCell(Text(data.selectedDropdownValueName ?? '')),
                                            DataCell(Text(data.prakarName ?? '')),
                                            DataCell(Text(
                                              data.isShaakhaa == 1
                                                  ? data.shaakhaa ?? ''
                                                  : data.isShaakhaa == 0
                                                      ? data.saptahik ?? ''
                                                      : '',
                                            )),
                                          ],
                                        );
                                      }).toList()
                                    : [],
                              ),
                            ),
                          ),
                        ),
                      if (beforsanghaonnowisoff == 1) SizedBox(height: 10),
                      if (beforsanghaonnowisoff == 1)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (selectedKuthalaVarshiIdIndex != null) {
                                    var selectedData = kuthalaVarshiDataList![selectedKuthalaVarshiIdIndex!];
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.white,
                                          title: Center(
                                            child: Text(
                                              "${Statics.getLabel('tapshilInfo')}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.purpleAccent,
                                              ),
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Divider(thickness: 1, color: Colors.purpleAccent.shade100),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('Vayogat')}", selectedData.selectedDropdownValueName),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('shaakhaPrakar')}", selectedData.prakarName),
                                              SizedBox(height: 12),
                                              _buildInfoRow(
                                                  "${Statics.getLabel('SankalpCompletionYear')}",
                                                  selectedData.isShaakhaa == 1
                                                      ? selectedData.shaakhaa
                                                      : selectedData.isShaakhaa == 2
                                                          ? selectedData.saptahik
                                                          : ""),
                                            ],
                                          ),
                                          actionsAlignment: MainAxisAlignment.center,
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.purpleAccent,
                                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  showKuthalaVarshiPopup(context, onDataChanged: () => setState(() {}), editIndex: selectedKuthalaVarshiIdIndex);
                                },
                                child: Icon(Icons.edit, color: Colors.blue, size: 20),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Colors.white,
                                      title: Center(
                                        child: Text(
                                          "${Statics.getLabel('pusthikarn')}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Text(
                                          "${Statics.getLabel('deleteconfirmText')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey.shade300,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text(
                                            "${Statics.getLabel('ConfirmationNo')}",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text(
                                            "${Statics.getLabel('ConfirmationYes')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (shouldDelete == true && selectedKuthalaVarshiIdIndex != null) {
                                    // setState(() {
                                    //   kuthalaVarshiDataList
                                    //       .removeAt(selectedKuthalaVarshiIdIndex!);
                                    //   selectedKuthalaVarshiIdIndex = null;
                                    // });
                                    setState(() {
                                      kuthalaVarshiDataList![selectedKuthalaVarshiIdIndex!].isactive = 0;
                                      selectedKuthalaVarshiIdIndex = null;
                                    });
                                  }
                                },
                                child: Icon(Icons.delete, color: Colors.red, size: 20),
                              ),
                            ],
                          ),
                        ),
                      if (beforsanghaonnowisoff == 1) SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
          // ===================================== Bhougolik STITHI  STITHI ==================================================================================
          mainContainer(
            "${Statics.getLabel('bhougolikSthiti')}",
            Column(
              children: [
                textControllerField("${Statics.getLabel('vastichaChatahuSima')}", vastiChatahuSimaController, context, height: 100),
                filePickerField(
                  question: "${Statics.getLabel('vastiGoogleMap')}",
                  selectedFileName: selectedFileName,
                  onFileSelected: (base64File, fileName) {
                    setState(() {
                      selectedFilePath = base64File;
                      selectedFileName = fileName;
                      imageAdd = 1;
                    });
                    log("Selected File Path (Base64): $selectedFilePath");
                  },
                  loadingNotifier: loadingNotifier,
                  context: context,
                ),
              ],
            ),
          ),
          // ===================================== JAGRAN SHRENI STITHI ==================================================================================
          mainContainer(
            "${Statics.getLabel('jagranShreniSthiti')}",
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showJagranShreniPopup(context, onDataChanged: () {
                            setState(() {});
                          });
                        } else {
                          showPopupForVastiValidation(
                            context,
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              Text(
                                "${Statics.getLabel('AddButton')}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DataTable(
                        showCheckboxColumn: false,
                        headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                        columnSpacing: 30,
                        horizontalMargin: 16,
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        columns: [
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('Category')}",
                          )),
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('upkram')}",
                          )),
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('varamvarita')}",
                          )),
                        ],
                        rows: jagranShreniEnteredDataList!.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                          int index = entry.key;
                          var data = entry.value;
                          bool isSelected = selectedJagranShreniStithiRowIndex == index;

                          return DataRow(
                            selected: isSelected,
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (isSelected) return Colors.yellow.shade100;
                                return null;
                              },
                            ),
                            onSelectChanged: (bool? selected) {
                              if (selected != null && selected) {
                                setState(() {
                                  selectedJagranShreniStithiRowIndex = index;
                                });
                              }
                            },
                            cells: [
                              DataCell(Text(data.selectedDropdownValueName ?? "")),
                              DataCell(
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: Text(
                                    data.niyamitacalanareupakrama ?? "",
                                    softWrap: true,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(data.selectedDropdownValueName1 == "अन्य" ? "${data.selectedDropdownValueName1} - ${data.otherVaranvarita}" : data.selectedDropdownValueName1 ?? ""),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedJagranShreniStithiRowIndex != null) {
                            var selectedData = jagranShreniEnteredDataList![selectedJagranShreniStithiRowIndex!];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.white,
                                  title: Center(
                                    child: Text(
                                      "${Statics.getLabel('jagranShreniSthiti')}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Divider(thickness: 1, color: Colors.purpleAccent.shade100),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('Category')}", selectedData.selectedDropdownValueName),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('niyamitUpkram')}", selectedData.niyamitacalanareupakrama),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('varamvarita')}", selectedData.selectedDropdownValueName1),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('anyaVaramvarita')}", selectedData.otherVaranvarita),
                                    ],
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purpleAccent,
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showJagranShreniPopup(context, onDataChanged: () {
                            setState(() {});
                          }, editIndex: selectedJagranShreniStithiRowIndex);
                          print("selectedJagranShreniStithiRowIndex --> $selectedJagranShreniStithiRowIndex");
                        },
                        child: Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Center(
                                child: Text(
                                  "${Statics.getLabel('pusthikarn')}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "${Statics.getLabel('deleteconfirmText')}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationNo')}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationYes')}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true && selectedJagranShreniStithiRowIndex != null) {
                            setState(() {
                              jagranShreniEnteredDataList![selectedJagranShreniStithiRowIndex!].isactive = 0;
                              selectedJagranShreniStithiRowIndex = null;
                            });
                          }
                        },
                        child: Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ===================================== GATIVIDHI KAARYA STITHI ==================================================================================
          mainContainer(
            "${Statics.getLabel('gatividhiKaryaStithi')}",
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showGatividhiPopup(context, onDataChanged: () {
                            setState(() {});
                          });
                        } else {
                          showPopupForVastiValidation(
                            context,
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              Text(
                                "${Statics.getLabel('AddButton')}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width * 1.5,
                      ),
                      child: DataTable(
                        showCheckboxColumn: false,
                        headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                        columnSpacing: 30,
                        horizontalMargin: 16,
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        columns: [
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('Gatividhi')}",
                          )),
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('niyamitUpkram')}",
                          )),
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('varamvarita')}",
                          )),
                        ],
                        rows: enteredDataListGatividhi.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                          int index = entry.key;
                          var data = entry.value;
                          bool isSelected = selectedGatividhiKaryaStithiRowIndex == index;
                          return DataRow(
                            selected: isSelected,
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (isSelected) return Colors.yellow.shade100;
                                return null;
                              },
                            ),
                            onSelectChanged: (bool? selected) {
                              if (selected != null && selected) {
                                setState(() {
                                  selectedGatividhiKaryaStithiRowIndex = index;
                                });
                              }
                            },
                            cells: [
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 200),
                                  child: Text(data.selectedDropdownValueName ?? "", softWrap: true),
                                ),
                              ),
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 200),
                                  child: Text(data.niyamitacalanareupakrama ?? "", softWrap: true),
                                ),
                              ),
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 200),
                                  child: Text(
                                    data.selectedDropdownValueName1 == "अन्य" ? "अन्य - ${data.otherVaranvarita ?? ''}" : data.selectedDropdownValueName1 ?? "",
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedGatividhiKaryaStithiRowIndex != null) {
                            var selectedData = enteredDataListGatividhi![selectedGatividhiKaryaStithiRowIndex!];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.white,
                                  title: Center(
                                    child: Text(
                                      "${Statics.getLabel('gatividhiKaryaStithi')}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Divider(thickness: 1, color: Colors.purpleAccent.shade100),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('GatividhiKaaryakartaaCount')}", selectedData.selectedDropdownValueName),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('niyamitUpkram')}", selectedData.niyamitacalanareupakrama),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('varamvarita')}", selectedData.selectedDropdownValueName1),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('anyaVaramvarita')}", selectedData.otherVaranvarita),
                                    ],
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purpleAccent,
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showGatividhiPopup(context, onDataChanged: () {
                            setState(() {});
                          }, editIndex: selectedGatividhiKaryaStithiRowIndex);
                        },
                        child: Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Center(
                                child: Text(
                                  "${Statics.getLabel('pusthikarn')}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "${Statics.getLabel('deleteconfirmText')}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationNo')}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationYes')}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true && selectedGatividhiKaryaStithiRowIndex != null) {
                            setState(() {
                              enteredDataListGatividhi[selectedGatividhiKaryaStithiRowIndex!].isactive = 0;
                              selectedGatividhiKaryaStithiRowIndex = null;
                            });
                          }
                        },
                        child: Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ===================================== VASIHAT PRAKAR ==================================================================================
          mainContainer(
              "${Statics.getLabel('vasahatPrakar')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isVastiSearch) {
                            showVsahatTypePopup(context, onDataChanged: () {
                              setState(() {});
                            });
                          } else {
                            showPopupForVastiValidation(
                              context,
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          width: 100,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                Text(
                                  "${Statics.getLabel('AddButton')}",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 1.1, // Ensure min width
                        ),
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                          headingTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: MediaQuery.of(context).size.width < 400 ? 12 : 14,
                          ),
                          dataRowHeight: MediaQuery.of(context).size.width < 400 ? 40 : 48,
                          // smaller rows on mobile
                          columnSpacing: 16,
                          // spacing between columns
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: MediaQuery.of(context).size.width < 400 ? 120 : 160,
                                child: Text(
                                  "${Statics.getLabel('SelectFrequency')}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: MediaQuery.of(context).size.width < 400 ? 100 : 140,
                                child: Text(
                                  "${Statics.getLabel('bhavnacheNaav')}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: MediaQuery.of(context).size.width < 400 ? 120 : 160,
                                child: Text(
                                  "${Statics.getLabel('samparkStithi')}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          rows: enteredVasahatPrakarDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                            int index = entry.key;
                            var data = entry.value;
                            bool isSelected = selectedvsahatPrakarIdRowIndex == index;

                            return DataRow(
                              selected: isSelected,
                              color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (isSelected) return Colors.yellow.shade100;
                                  return null;
                                },
                              ),
                              onSelectChanged: (bool? selected) {
                                if (selected != null && selected) {
                                  setState(() {
                                    selectedvsahatPrakarIdRowIndex = index;
                                  });
                                }
                              },
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width < 400 ? 120 : 160,
                                    child: Text(
                                      data.selectedDropdownValueName ?? "",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width < 400 ? 100 : 140,
                                    child: Text(
                                      data.bhavanachenav ?? "",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width < 400 ? 120 : 160,
                                    child: Text(
                                      data.selectedDropdownValueName1 ?? "",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (selectedvsahatPrakarIdRowIndex != null) {
                              var selectedData = enteredVasahatPrakarDataList[selectedvsahatPrakarIdRowIndex!];
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('vasahatPrakar')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Divider(thickness: 1, color: Colors.purpleAccent.shade100),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('SelectFrequency')}", selectedData.selectedDropdownValueName),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('bhavnacheNaav')}", selectedData.bhavanachenav),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('samparkStithi')}", selectedData.selectedDropdownValueName1),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('samparkSootraNaav')}", selectedData.samparksootr),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('samparakSootraDoorbhash')}", selectedData.doorabhaash),
                                      ],
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purpleAccent,
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            showVsahatTypePopup(context, onDataChanged: () {
                              setState(() {});
                            }, editIndex: selectedvsahatPrakarIdRowIndex);
                          },
                          child: Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.white,
                                title: Center(
                                  child: Text(
                                    "${Statics.getLabel('pusthikarn')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    "${Statics.getLabel('deleteconfirmText')}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text(
                                      "${Statics.getLabel('ConfirmationNo')}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text(
                                      "${Statics.getLabel('ConfirmationYes')}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (shouldDelete == true && selectedvsahatPrakarIdRowIndex != null) {
                              setState(() {
                                enteredVasahatPrakarDataList[selectedvsahatPrakarIdRowIndex!].isactive = 0;
                                selectedvsahatPrakarIdRowIndex = null;
                              });
                            }
                          },
                          child: Icon(Icons.delete, color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                  ),
                  //=======================================================================================================
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${Statics.getLabel('vividhBhashaBolnare')}",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (isVastiSearch) {
                                      showVividhBhashaBolnarePopup(
                                        context,
                                        onDataChanged: () {
                                          setState(() {});
                                        },
                                      );
                                    } else {
                                      showPopupForVastiValidation(
                                        context,
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    width: 100,
                                    decoration:
                                        BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add, color: Colors.white, size: 16),
                                          Text(
                                            "${Statics.getLabel('AddButton')}",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 220,
                                    child: DataTable(
                                      showCheckboxColumn: false,
                                      headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                      columnSpacing: 1,
                                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                      columns: [
                                        DataColumn(
                                            label: Text(
                                          "${Statics.getLabel('onlyBhasha')}",
                                        )),
                                        DataColumn(
                                            label: Center(
                                          child: Text(
                                            "${Statics.getLabel('avgPersent')}",
                                          ),
                                        )),
                                      ],
                                      rows: enteredVividhBhashaBolnareDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                        int index = entry.key;
                                        var data = entry.value;
                                        bool isSelected = selectedVividhBhashaBolnarerIdRowIndex == index;
                                        return DataRow(
                                            selected: isSelected,
                                            color: MaterialStateProperty.resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                if (isSelected) return Colors.yellow.shade100;
                                                return null;
                                              },
                                            ),
                                            onSelectChanged: (bool? selected) {
                                              if (selected != null && selected) {
                                                setState(() {
                                                  selectedVividhBhashaBolnarerIdRowIndex = index;
                                                });
                                              }
                                            },
                                            cells: [
                                              DataCell(Text(data.otherbhaasha != "" ? "${data.selectedDropdownValueName} - ${data.otherbhaasha}" : data.selectedDropdownValueName ?? "")),
                                              DataCell(Align(alignment: Alignment.centerRight, child: Text(data.andaje ?? ""))),
                                            ]);
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (selectedVividhBhashaBolnarerIdRowIndex != null) {
                                        var selectedData = enteredVividhBhashaBolnareDataList[selectedVividhBhashaBolnarerIdRowIndex!];
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              backgroundColor: Colors.white,
                                              title: Center(
                                                child: Text(
                                                  "${Statics.getLabel('vividhBhashaBolnare')}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.purpleAccent,
                                                  ),
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Divider(thickness: 1, color: Colors.purpleAccent.shade100),
                                                  SizedBox(height: 12),
                                                  _buildInfoRow("${Statics.getLabel('onlyBhasha')}", selectedData.selectedDropdownValueName),
                                                  SizedBox(height: 12),
                                                  _buildInfoRow("${Statics.getLabel('OtherLanguage')}", selectedData.otherbhaasha),
                                                  SizedBox(height: 12),
                                                  _buildInfoRow("${Statics.getLabel('avgPersent')}", selectedData.andaje),
                                                ],
                                              ),
                                              actionsAlignment: MainAxisAlignment.center,
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.purpleAccent,
                                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showVividhBhashaBolnarePopup(context, editIndex: selectedVividhBhashaBolnarerIdRowIndex, onDataChanged: () {
                                        setState(() {});
                                      });
                                    },
                                    child: Icon(Icons.edit, color: Colors.blue, size: 20),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final shouldDelete = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.white,
                                          title: Center(
                                            child: Text(
                                              "${Statics.getLabel('pusthikarn')}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Text(
                                              "${Statics.getLabel('deleteconfirmText')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey.shade300,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () => Navigator.pop(context, false),
                                              child: Text(
                                                "${Statics.getLabel('ConfirmationNo')}",
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.redAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () => Navigator.pop(context, true),
                                              child: Text(
                                                "${Statics.getLabel('ConfirmationYes')}",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (shouldDelete == true && selectedVividhBhashaBolnarerIdRowIndex != null) {
                                        setState(() {
                                          enteredVividhBhashaBolnareDataList[selectedVividhBhashaBolnarerIdRowIndex!].isactive = 0;
                                          selectedVividhBhashaBolnarerIdRowIndex = null;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.delete, color: Colors.red, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //============================  KONTYA PRANTACHE ???===========================================================================
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${Statics.getLabel('kontyaPrantache')}",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (isVastiSearch) {
                                      showKontyaPraantachePopup(
                                        context,
                                        onDataChanged: () {
                                          setState(() {});
                                        },
                                      );
                                    } else {
                                      showPopupForVastiValidation(context);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    width: 100,
                                    decoration:
                                        BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add, color: Colors.white, size: 15),
                                          Text(
                                            "${Statics.getLabel('AddButton')}",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: DataTable(
                                      showCheckboxColumn: false,
                                      headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                      columnSpacing: 1,
                                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                      columns: [
                                        DataColumn(
                                            label: Text(
                                          "${Statics.getLabel('Praant')}",
                                        )),
                                        DataColumn(
                                            label: Text(
                                          "${Statics.getLabel('avgPersent')}",
                                        )),
                                      ],
                                      rows: enteredKontyaPraantacheDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                        int index = entry.key;
                                        var data = entry.value;
                                        bool isSelected = selectedKontyaPraantacheIdRowIndex == index;
                                        return DataRow(
                                            selected: isSelected,
                                            color: MaterialStateProperty.resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                if (isSelected) return Colors.yellow.shade100;
                                                return null;
                                              },
                                            ),
                                            onSelectChanged: (bool? selected) {
                                              if (selected != null && selected) {
                                                setState(() {
                                                  selectedKontyaPraantacheIdRowIndex = index;
                                                });
                                              }
                                            },
                                            cells: [
                                              DataCell(Text(data.selectedDropdownValueName ?? "")),
                                              DataCell(Align(alignment: Alignment.centerRight, child: Text(data.andaje ?? ""))),
                                            ]);
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (selectedKontyaPraantacheIdRowIndex != null) {
                                        var selectedData = enteredKontyaPraantacheDataList[selectedKontyaPraantacheIdRowIndex!];
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              backgroundColor: Colors.white,
                                              title: Center(
                                                child: Text(
                                                  "${Statics.getLabel('kontyaPrantache')}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.purpleAccent,
                                                  ),
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Divider(thickness: 1, color: Colors.purpleAccent.shade100),
                                                  SizedBox(height: 12),
                                                  _buildInfoRow("${Statics.getLabel('Praant')}", selectedData.selectedDropdownValueName),
                                                  SizedBox(height: 12),
                                                  _buildInfoRow("${Statics.getLabel('anyaPraant')}", selectedData.anyaPraantName),
                                                  SizedBox(height: 12),
                                                  _buildInfoRow("${Statics.getLabel('avgPersent')}", selectedData.andaje),
                                                ],
                                              ),
                                              actionsAlignment: MainAxisAlignment.center,
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.purpleAccent,
                                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showKontyaPraantachePopup(context, editIndex: selectedKontyaPraantacheIdRowIndex, onDataChanged: () {
                                        setState(() {});
                                      });
                                    },
                                    child: Icon(Icons.edit, color: Colors.blue, size: 20),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final shouldDelete = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.white,
                                          title: Center(
                                            child: Text(
                                              "${Statics.getLabel('pusthikarn')}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Text(
                                              "${Statics.getLabel('deleteconfirmText')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey.shade300,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () => Navigator.pop(context, false),
                                              child: Text(
                                                "${Statics.getLabel('ConfirmationNo')}",
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.redAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () => Navigator.pop(context, true),
                                              child: Text(
                                                "${Statics.getLabel('ConfirmationYes')}",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (shouldDelete == true && selectedKontyaPraantacheIdRowIndex != null) {
                                        setState(() {
                                          enteredKontyaPraantacheDataList[selectedKontyaPraantacheIdRowIndex!].isactive = 0;
                                          selectedKontyaPraantacheIdRowIndex = null;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.delete, color: Colors.red, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //======================= RELIGION ================================================================================
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${Statics.getLabel('religion')}",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (isVastiSearch) {
                                      showReligionPopup(
                                        context,
                                        onDataChanged: () {
                                          setState(() {});
                                        },
                                      );
                                    } else {
                                      showPopupForVastiValidation(context);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    width: 100,
                                    decoration:
                                        BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add, color: Colors.white, size: 15),
                                          Text(
                                            "${Statics.getLabel('AddButton')}",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: DataTable(
                                      showCheckboxColumn: false,
                                      headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                      columnSpacing: 1,
                                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                      columns: [
                                        DataColumn(
                                            label: Text(
                                          '${Statics.getLabel('konteReligion')}',
                                        )),
                                        DataColumn(
                                            label: Text(
                                          '${Statics.getLabel('avgPersent')}',
                                        )),
                                      ],
                                      rows: enteredreligionDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                        int index = entry.key;
                                        var data = entry.value;
                                        bool isSelected = selectedReligionIdRowIndex == index;
                                        return DataRow(
                                            selected: isSelected,
                                            color: MaterialStateProperty.resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                                if (isSelected) return Colors.yellow.shade100;
                                                return null;
                                              },
                                            ),
                                            onSelectChanged: (bool? selected) {
                                              if (selected != null && selected) {
                                                setState(() {
                                                  selectedReligionIdRowIndex = index;
                                                });
                                              }
                                            },
                                            cells: [
                                              DataCell(Text(data.selectedDropdownValueName ?? "")),
                                              DataCell(Align(alignment: Alignment.centerRight, child: Text(data.andaje ?? ""))),
                                            ]);
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (selectedReligionIdRowIndex != null) {
                                        var selectedData = enteredreligionDataList[selectedReligionIdRowIndex!];
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              backgroundColor: Colors.white,
                                              title: Center(
                                                child: Text(
                                                  "${Statics.getLabel('religion')}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.purpleAccent,
                                                  ),
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Divider(thickness: 1, color: Colors.purpleAccent.shade100),
                                                  SizedBox(height: 12),
                                                  _buildInfoRow("${Statics.getLabel('konteReligion')}", selectedData.selectedDropdownValueName),
                                                  SizedBox(height: 12),
                                                  _buildInfoRow("${Statics.getLabel('avgPersent')}", selectedData.andaje),
                                                ],
                                              ),
                                              actionsAlignment: MainAxisAlignment.center,
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.purpleAccent,
                                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showReligionPopup(context, editIndex: selectedReligionIdRowIndex, onDataChanged: () {
                                        setState(() {});
                                      });
                                    },
                                    child: Icon(Icons.edit, color: Colors.blue, size: 20),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final shouldDelete = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.white,
                                          title: Center(
                                            child: Text(
                                              "${Statics.getLabel('pusthikarn')}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                          content: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Text(
                                              "${Statics.getLabel('deleteconfirmText')}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey.shade300,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () => Navigator.pop(context, false),
                                              child: Text(
                                                "${Statics.getLabel('ConfirmationNo')}",
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.redAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () => Navigator.pop(context, true),
                                              child: Text(
                                                "${Statics.getLabel('ConfirmationYes')}",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (shouldDelete == true && selectedReligionIdRowIndex != null) {
                                        setState(() {
                                          enteredreligionDataList[selectedReligionIdRowIndex!].isactive = 0;
                                          selectedReligionIdRowIndex = null;
                                        });
                                      }
                                    },
                                    child: Icon(Icons.delete, color: Colors.red, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //======================================  UPASNA Sthal =====================================================
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Statics.getLabel('UpasanaSthal')}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                      ),
                      InkWell(
                        onTap: () {
                          if (isVastiSearch) {
                            showUpasnaSthalPopup(
                              context,
                              onDataChanged: () {
                                setState(() {});
                              },
                            );
                          } else {
                            showPopupForVastiValidation(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          width: 100,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                Text(
                                  "${Statics.getLabel('AddButton')}",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 1,
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                            columnSpacing: 20,
                            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                            columns: [
                              DataColumn(
                                  label: Text(
                                "${Statics.getLabel('UpasanaSthal')}",
                              )),
                              DataColumn(
                                  label: Text(
                                "${Statics.getLabel('SelectFrequency')}",
                              )),
                              DataColumn(
                                  label: Text(
                                "${Statics.getLabel('count')}",
                              )),
                            ],
                            rows: upasnaSthalDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                              int index = entry.key;
                              var data = entry.value;
                              bool isSelected = selectedUpasnaSthalRowIndex == index;
                              return DataRow(
                                  selected: isSelected,
                                  color: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (isSelected) return Colors.yellow.shade100;
                                      return null;
                                    },
                                  ),
                                  onSelectChanged: (bool? selected) {
                                    if (selected != null && selected) {
                                      setState(() {
                                        selectedUpasnaSthalRowIndex = index;
                                      });
                                    }
                                  },
                                  cells: [
                                    DataCell(Text(data.selectedDropdownValueName ?? "")),
                                    DataCell(Text(data.selectedDropdownValueName1 ?? "")),
                                    DataCell(Text(data.sankhya ?? "")),
                                  ]);
                            }).toList(),
                          ),
                        )),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (selectedUpasnaSthalRowIndex != null) {
                              var selectedData = upasnaSthalDataList[selectedUpasnaSthalRowIndex!];
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('UpasanaSthal')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Divider(thickness: 1, color: Colors.purpleAccent.shade100),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('UpasanaSthal')}", selectedData.selectedDropdownValueName),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('otherUpasanaSthal')}", selectedData.otherupaasanasthala),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('SelectFrequency')}", selectedData.selectedDropdownValueName1),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('count')}", selectedData.sankhya),
                                      ],
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purpleAccent,
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            showUpasnaSthalPopup(context, editIndex: selectedUpasnaSthalRowIndex, onDataChanged: () {
                              setState(() {});
                            });
                          },
                          child: Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.white,
                                title: Center(
                                  child: Text(
                                    "${Statics.getLabel('pusthikarn')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    "${Statics.getLabel('deleteconfirmText')}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text(
                                      "${Statics.getLabel('ConfirmationNo')}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text(
                                      "${Statics.getLabel('ConfirmationYes')}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (shouldDelete == true && selectedUpasnaSthalRowIndex != null) {
                              setState(() {
                                upasnaSthalDataList[selectedUpasnaSthalRowIndex!].isactive = 0;
                                selectedUpasnaSthalRowIndex = null;
                              });
                            }
                          },
                          child: Icon(Icons.delete, color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
//==========================  SAJJAN SHAKTI JODA =================================================================================================================================================================================
          SizedBox(
            height: 20,
          ),
          mainContainer(
              "${Statics.getLabel('SajjanShakti')}",
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showSajjanShaktiPopup(
                            context,
                            onDataChanged: () {
                              setState(() {});
                            },
                          );
                        } else {
                          showPopupForVastiValidation(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              Text(
                                "${Statics.getLabel('AddButton')}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: DataTable(
                        showCheckboxColumn: false,
                        headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                        columnSpacing: 40,
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        columns: [
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('Name')}",
                          )),
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('Category')}",
                          )),
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('samparkStithi')}",
                          )),
                        ],
                        rows: sajjanShaktiDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                          int index = entry.key;
                          var data = entry.value;
                          bool isSelected = selectedsajjanShaktiRowIndex == index;
                          return DataRow(
                              selected: isSelected,
                              color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (isSelected) return Colors.yellow.shade100;
                                  return null;
                                },
                              ),
                              onSelectChanged: (bool? selected) {
                                if (selected != null && selected) {
                                  setState(() {
                                    selectedsajjanShaktiRowIndex = index;
                                  });
                                }
                              },
                              cells: [
                                DataCell(Text(data.name ?? "")),
                                DataCell(Text(data.selectedDropdownValueName ?? "")),
                                DataCell(Text(data.selectedDropdownValueName1 ?? "")),
                              ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedsajjanShaktiRowIndex != null) {
                            var selectedData = sajjanShaktiDataList[selectedsajjanShaktiRowIndex!];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.white,
                                  title: Center(
                                    child: Text(
                                      "${Statics.getLabel('UpasanaSthal')}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Divider(thickness: 1, color: Colors.purpleAccent.shade100),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('Address')}", selectedData.address),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('doorBhash')}", selectedData.doorabhaash),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('Gender')}", Statics.getLabel(selectedData.isfemale == 1 ? 'Female' : 'Male')),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('Category')}", selectedData.selectedDropdownValueName),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('OtherCategory')}", selectedData.otherShreniName),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('OrganizationName')}", selectedData.sanstheCheNaav),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('kontyaPadavar')}", selectedData.sansthechaKuthalaPadavar),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('samparkStithi')}", selectedData.selectedDropdownValueName1),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('special')}", selectedData.selectedDropdownValueName2),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('otherSpecial')}", selectedData.otherVisheshName),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('prabhavKshetra')}", selectedData.selectedDropdownValueName3),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('samparkSootraNaav')}", selectedData.samparkasutranava),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('samparakSootraDoorbhash')}", selectedData.samparkasutraMobileNumber),
                                      ],
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purpleAccent,
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showSajjanShaktiPopup(context, editIndex: selectedsajjanShaktiRowIndex, onDataChanged: () {
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Center(
                                child: Text(
                                  "${Statics.getLabel('pusthikarn')}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "${Statics.getLabel('deleteconfirmText')}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationNo')}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationYes')}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true && selectedsajjanShaktiRowIndex != null) {
                            setState(() {
                              sajjanShaktiDataList[selectedsajjanShaktiRowIndex!].isactive = 0;
                              selectedsajjanShaktiRowIndex = null;
                            });
                          }
                        },
                        child: Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                ),
              ])),
          //==========================  ANYA PRABHAVI LOK  ==============================================================
          SizedBox(
            height: 20,
          ),
          mainContainer(
            "${Statics.getLabel('anyaPrabhaviLok')} (${Statics.getLabel('samparkVibhaagYaadi')})",
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showAnyaPrabhaviPopup(context, editIndex: null, onDataChanged: () {
                            setState(() {});
                          });
                        } else {
                          showPopupForVastiValidation(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              Text(
                                "${Statics.getLabel('AddButton')}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: DataTable(
                        showCheckboxColumn: false,
                        headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                        columnSpacing: 1,
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        columns: [
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('Name')}",
                          )),
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('special')}",
                          )),
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('prabhavKshetra')}",
                          )),
                        ],
                        rows: anyaPrabhaviLokDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                          int index = entry.key;
                          var data = entry.value;
                          bool isSelected = selectedanyaPrabhaviLokRowIndex == index;
                          return DataRow(
                              selected: isSelected,
                              color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (isSelected) return Colors.yellow.shade100;
                                  return null;
                                },
                              ),
                              onSelectChanged: (bool? selected) {
                                if (selected != null && selected) {
                                  setState(() {
                                    selectedanyaPrabhaviLokRowIndex = index;
                                  });
                                }
                              },
                              cells: [
                                DataCell(Text(data.name ?? "")),
                                DataCell(Text(data.selectedDropdownValueName3 ?? "")),
                                DataCell(Text(data.selectedDropdownValueName4 ?? "")),
                              ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedanyaPrabhaviLokRowIndex != null) {
                            var selectedData = anyaPrabhaviLokDataList[selectedanyaPrabhaviLokRowIndex!];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.white,
                                  title: Center(
                                    child: Text(
                                      "${Statics.getLabel('anyaPrabhaviLok')}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                        _buildInfoRow("${Statics.getLabel('Address')}", selectedData.address),
                                        _buildInfoRow("${Statics.getLabel('doorBhash')}", selectedData.doorabhaash),
                                        _buildInfoRow("${Statics.getLabel('Gender')}", Statics.getLabel(selectedData.isfemale == 1 ? 'Female' : 'Male')),
                                        _buildInfoRow("${Statics.getLabel('Category')}", selectedData.selectedDropdownValueName),
                                        _buildInfoRow("${Statics.getLabel('upshreni')}", selectedData.selectedDropdownValueName1),
                                        _buildInfoRow("${Statics.getLabel('otherUpshreni')}", selectedData.otherupshrenee),
                                        _buildInfoRow("${Statics.getLabel('upshreni')} 1", selectedData.selectedDropdownValueName2),
                                        _buildInfoRow("${Statics.getLabel('special')}", selectedData.selectedDropdownValueName3),
                                        _buildInfoRow("${Statics.getLabel('prabhavKshetra')}", selectedData.selectedDropdownValueName4),
                                        _buildInfoRow("${Statics.getLabel('anyaVisheshMahiti')}", selectedData.othervishesh),
                                        _buildInfoRow("${Statics.getLabel('samparkStithi')}", selectedData.selectedDropdownValueName5),
                                        _buildInfoRow("${Statics.getLabel('samparkSootraNaav')}", selectedData.samparkasutranav),
                                        _buildInfoRow("${Statics.getLabel('samparakSootraDoorbhash')}", selectedData.samparkaSutraDoorbhash),
                                      ],
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purpleAccent,
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showAnyaPrabhaviPopup(context, onDataChanged: () {
                            setState(() {});
                          }, editIndex: selectedanyaPrabhaviLokRowIndex);
                        },
                        child: Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Center(
                                child: Text(
                                  "${Statics.getLabel('pusthikarn')}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "${Statics.getLabel('deleteconfirmText')}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationNo')}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationYes')}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (shouldDelete == true && selectedanyaPrabhaviLokRowIndex != null) {
                            setState(() {
                              anyaPrabhaviLokDataList[selectedanyaPrabhaviLokRowIndex!].isactive = 0;
                              selectedanyaPrabhaviLokRowIndex = null;
                            });
                          }
                        },
                        child: Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                ),
                //=================================================== VASTIT SAJAR HONARE SAN FORM ====================================================================================
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${Statics.getLabel('sajareHonareSan')}",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                    ),
                    InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showVastitSajarHonareSanPopup(
                            context,
                            onDataChanged: () {
                              setState(() {});
                            },
                          );
                        } else {
                          showPopupForVastiValidation(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.shade100, borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              Text(
                                "${Statics.getLabel('AddButton')}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1.5,
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                          headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          columns: [
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('festivals')}",
                            )),
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('aayojakSansthachiNave')}",
                            )),
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('aayojakNaav')}",
                            )),
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('Sampark')}",
                            )),
                          ],
                          rows: vastitSajarHonareSanDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                            int index = entry.key;
                            var data = entry.value;
                            bool isSelected = selectedSanIdIndex == index;
                            return DataRow(
                                selected: isSelected,
                                color: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (isSelected) return Colors.yellow.shade100;
                                    return null;
                                  },
                                ),
                                onSelectChanged: (bool? selected) {
                                  if (selected != null && selected) {
                                    setState(() {
                                      selectedSanIdIndex = index;
                                    });
                                  }
                                },
                                cells: [
                                  DataCell(Text(
                                      /*data['sanName'] == "अन्य"? "${data['sanName']} - ${data['vastitSajarHonareAnyaSan']}" :*/
                                      data.selectedDropdownValueName ?? '')),
                                  DataCell(Text(data.ayojakasansthacinave ?? '')),
                                  DataCell(Text(data.ayojakancinave ?? '')),
                                  DataCell(Text(data.aayojaksamparksootr ?? '')),
                                ]);
                          }).toList(),
                        ),
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedSanIdIndex != null) {
                            var selectedData = vastitSajarHonareSanDataList[selectedSanIdIndex!];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.white,
                                  title: Center(
                                    child: Text(
                                      "${Statics.getLabel('sajareHonareSan')}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('festivals')}", selectedData.selectedDropdownValueName),
                                        _buildInfoRow("${Statics.getLabel('otherFestivals')}", selectedData.otherSajareSan),
                                        _buildInfoRow("${Statics.getLabel('aayojakSansthachiNave')}", selectedData.ayojakasansthacinave),
                                        _buildInfoRow("${Statics.getLabel('aayojakNaav')}", selectedData.ayojakancinave),
                                        _buildInfoRow("${Statics.getLabel('samparkSootraNaav')}", selectedData.aayojaksamparksootr),
                                      ],
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purpleAccent,
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showVastitSajarHonareSanPopup(context, editIndex: selectedSanIdIndex, onDataChanged: () {
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Center(
                                child: Text(
                                  "${Statics.getLabel('pusthikarn')}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "${Statics.getLabel('deleteconfirmText')}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationNo')}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationYes')}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (shouldDelete == true && selectedSanIdIndex != null) {
                            setState(() {
                              vastitSajarHonareSanDataList[selectedSanIdIndex!].isactive = 0;
                              selectedSanIdIndex = null;
                            });
                          }
                        },
                        child: Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                ),
                //=================================================== VASTIT SAJAR HONARE samajik karyakyram FORM ====================================================================================
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        "${Statics.getLabel('sajareHonareKaryakram')}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showVastitSajarHonareSamajikKaryakramPopup(
                            context,
                            onDataChanged: () {
                              setState(() {});
                            },
                          );
                        } else {
                          showPopupForVastiValidation(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.shade100, borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              SizedBox(width: 5),
                              Text(
                                "${Statics.getLabel('AddButton')}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1.5,
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                          headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          columns: [
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('samajikKaryakram')}",
                            )),
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('aayojakSansthachiNave')}",
                            )),
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('aayojakNaav')}",
                            )),
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('Sampark')}",
                            )),
                          ],
                          rows: vastitSajarHonareSamajikKaryakramDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                            int index = entry.key;
                            var data = entry.value;
                            bool isSelected = selectedSamajikKaryakramIdIndex == index;
                            return DataRow(
                                selected: isSelected,
                                color: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (isSelected) return Colors.yellow.shade100;
                                    return null;
                                  },
                                ),
                                onSelectChanged: (bool? selected) {
                                  if (selected != null && selected) {
                                    setState(() {
                                      selectedSamajikKaryakramIdIndex = index;
                                    });
                                  }
                                },
                                cells: [
                                  DataCell(Text(data.selectedDropdownValueName ?? '')),
                                  DataCell(Text(data.ayojakasansthacinave ?? '')),
                                  DataCell(Text(data.ayojakancinave ?? '')),
                                  DataCell(Text(data.aayojaksamparksootr ?? '')),
                                ]);
                          }).toList(),
                        ),
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedSamajikKaryakramIdIndex != null) {
                            var selectedData = vastitSajarHonareSamajikKaryakramDataList[selectedSamajikKaryakramIdIndex!];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.white,
                                  title: Center(
                                    child: Text(
                                      "${Statics.getLabel('sajareHonareKaryakram')}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('samajikKaryakram')}", selectedData.selectedDropdownValueName),
                                        _buildInfoRow("${Statics.getLabel('otherEnter')}", selectedData.otherKaryakram),
                                        _buildInfoRow("${Statics.getLabel('aayojakSansthachiNave')}", selectedData.ayojakasansthacinave),
                                        _buildInfoRow("${Statics.getLabel('aayojakNaav')}", selectedData.ayojakancinave),
                                        _buildInfoRow("${Statics.getLabel('Sampark')}", selectedData.aayojaksamparksootr),
                                      ],
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purpleAccent,
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showVastitSajarHonareSamajikKaryakramPopup(context, editIndex: selectedSamajikKaryakramIdIndex, onDataChanged: () {
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Center(
                                child: Text(
                                  "${Statics.getLabel('pusthikarn')}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "${Statics.getLabel('deleteconfirmText')}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationNo')}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationYes')}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (shouldDelete == true && selectedSamajikKaryakramIdIndex != null) {
                            setState(() {
                              vastitSajarHonareSamajikKaryakramDataList[selectedSamajikKaryakramIdIndex!].isactive = 0;
                              selectedSamajikKaryakramIdIndex = null;
                            });
                          }
                        },
                        child: Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                ),
                //=================================================================================================================================================================
                //                     SizedBox(height: 5),
                //                     textControllerField( "वस्तीत साजरे होणारे अन्य महत्वाचे सामाजिक कार्यक्रम", vastitHonareSamajikAnyakaryakramController,context,height: 80,),

                //===========================  SUBMIT BUTTON ===============================================================================================================================================================================================
                Divider(thickness: 2),
                InkWell(
                  onTap: () {
                    if (isVastiSearch) {
                      if (loksankhyaController.text != "" && vastiSamitiYesNo == 0 || vastiSamitiYesNo == 1) {
                        submitStep1Form();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              "${Statics.getLabel('suchana')}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                                fontSize: 18,
                              ),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "${Statics.getLabel('vastiSamitiAndLoksankhyaValidation')}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red.shade800,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "${Statics.getLabel('okay')}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      showPopupForVastiValidation(context);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.5),
                          offset: const Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "प्राथमिक माहिती संग्रह",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitStep1Form() async {
    setState(() {
      _isStep1Completed = true;
    });
    log("Selected File Path (Base64): $selectedFilePath");
    log("Selected File Name: $selectedFileName");
    Map<String, dynamic> formData = {
      "cuserid": int.parse(Statics.userDetails['userID']),
      "vastiid": int.parse(selctedLevelId!),
      "vastiShakhaPramukhName": sanghaKaryaVastiPramukhNameController.text,
      "vastiShakhaSamiti": vastiSamitiYesNo,
      "Lokasankhya": loksankhyaController.text,
      "beforeShakhaSaptahikIsOnNowOff": beforsanghaonnowisoff,
      "VasticyacatuSima": vastiChatahuSimaController.text,
      "googlemap": imageAdd == 1 ? selectedFilePath : selectedFileName,
      "Vastitasajaraanyakaryakaram": vastitHonareSamajikAnyakaryakramController.text,
      "VastisarKuthalyavarsi": kuthalaVarshiDataList,
      "VastisarJaagaranshreneesthiti": jagranShreniEnteredDataList,
      "VastisarGatividhikaryasthiti": enteredDataListGatividhi,
      "VastisarVasahatprakara": enteredVasahatPrakarDataList,
      "VastisarVividhaprakara": enteredVividhBhashaBolnareDataList,
      "VastisarKonatyaprantache": enteredKontyaPraantacheDataList,
      "VastisarReligion": enteredreligionDataList,
      "Vastisarupaasana": upasnaSthalDataList,
      "Vastisarsajjanshakti": sajjanShaktiDataList,
      "VastisarAnyaprabhavilokam": anyaPrabhaviLokDataList,
      "VastisarVastitamahatvacesana": vastitSajarHonareSanDataList,
      "VastisarVastitasajaraSamajikkaryakram": vastitSajarHonareSamajikKaryakramDataList,
      "stepOneComplete": _isStep1Completed == true ? 1 : 0,
      "isImage": imageAdd,
      "isvasti": 1,
      "VastisarvadiGharLoksankhya": [],
      "VastisarSewaPrakalpa": [],
      "VastisarvividhKshetaCheKam": [],
      "VastisarvividhSampradhaySatsangKendra": [],
      "VastisargavatilMumbaikar": [],
      "maleCount": "",
      "femaleCount": "",
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Step 1 Form Data (JSON):\n$formattedJson");

    String result = await Statics.vastiSarvekshanStep1FormSubmit(context, jsonEncode(formData));
    if (result == "success") {
      setState(() {
        sanghaKaryaVastiStithiController.clear();
        sanghaKaryaVastiPramukhNameController.clear();
        loksankhyaController.clear();
        vastiSamitiYesNo = 2;
        beforsanghaonnowisoff = 2;
        kuthalaVarshiDataList = [];
        vastiChatahuSimaController.clear();
        jagranShreniEnteredDataList = [];
        enteredDataListGatividhi = [];
        enteredVasahatPrakarDataList = [];
        enteredVividhBhashaBolnareDataList = [];
        enteredKontyaPraantacheDataList = [];
        enteredreligionDataList = [];
        upasnaSthalDataList = [];
        sajjanShaktiDataList = [];
        anyaPrabhaviLokDataList = [];
        vastitSajarHonareSanDataList = [];
        vastitSajarHonareSamajikKaryakramDataList = [];
        imageAdd = 0;

        /// STEP 2 FORM DATA
        vastitBalopasanaKendraDataList = [];
        motheVyasayikKendraDataList = [];
        nirmandhinMothePrakalpaDataList = [];
        motheRugnalayDataList = [];
        agniShamanDalKendraAhe = 2;
        polichChoukiAhe = 2;
        allShaikshanikPrakarDataList = [];
        maidanUddyanDataList = [];
        jahirKaryakramDataList = [];

        /// STEP 3 FORM DATA
        vastiPrashnaGarjaDataList = [];
        dharmikNetrutvaDataList = [];
        durjanShaktiDataList = [];
        hinduVeerYadiDataList = [];
      });
      await Future.delayed(Duration(seconds: 2));
      searchVastiData(selctedLevelId);
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (result == "failed") {
      print("failllleeeeddddddddddddd");
    } else {
      // for unexpected error
      print("unexpected error");
    }
  }

//=================================================== ANYA PRABHAVI Prabhav Kshetra FORM ====================================================================================
  int? anyaPrabhaviLokPrabhavKshetraId;
  String? anyaPrabhaviLokPrabhavKshetraName;
  int? selectedAnyaPrabhaviLokPrabhavKshetraIDEdit;
  Masterdata? selectedAnyaPrabhaviLokPrabhavKshetra;

//=================================================== ANYA PRABHAVI VISHESH FORM ====================================================================================
  int? anyaPrabhaviLokVisheshId;
  String? anyaPrabhaviLokVisheshName;
  int? selectedAnyaPrabhaviLokVisheshIDEdit;
  Masterdata? selectedAnyaPrabhaviLokVishesh;

//=====================================================================================================================================

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
          _buildDropdown2(
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
        if (dependentItems.isNotEmpty) SizedBox(height: 10),
        if (dependentItems.isNotEmpty)
          _buildDropdown2(
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
        if (thirdLevelItems.isNotEmpty) SizedBox(height: 10),
        if (thirdLevelItems.isNotEmpty)
          _buildDropdown2(
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
            style: TextStyle(color: textColor ?? Colors.black),
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

  // Widget _buildDropdown2<T extends Masterdata>({
  //   required String hintText,
  //   required T? value,
  //   required List<T> items,
  //   required Function(T?) onChanged,
  //   BoxDecoration? decoration,
  //   Color? textColor,
  //   Color? borderColor,
  //   Color? iconColor,
  //   bool? viewName,
  // }) {
  //   return Container(
  //     height: 50,
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     decoration: decoration ??
  //         BoxDecoration(
  //           color: Colors.white,
  //           border: Border.all(color: borderColor ?? Colors.black54),
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<T>(
  //         iconEnabledColor: iconColor ?? Colors.black,
  //         hint: Text(
  //           value != null && viewName == true ? value.value ?? "" : hintText,
  //           style: TextStyle(color: textColor ?? Colors.black),
  //         ),
  //         value: items.any((e) => e.id == value?.id) ? value : null,
  //         isExpanded: true,
  //         items: items
  //             .map((item) => DropdownMenuItem<T>(
  //                   value: item,
  //                   child: Text(
  //                     item.value ?? "",
  //                     style: TextStyle(color: textColor ?? Colors.black),
  //                   ),
  //                 ))
  //             .toList(),
  //         onChanged: onChanged,
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDropdown2<T extends Masterdata>(
  //     {required String hintText,
  //     required T? value,
  //     required List<T> items,
  //     required Function(T?) onChanged,
  //     BoxDecoration? decoration,
  //     Color? textColor,
  //     Color? borderColor,
  //     Color? iconColor,
  //     bool? viewName}) {
  //   return Container(
  //     height: 50,
  //     width: double.infinity,
  //     padding: EdgeInsets.symmetric(horizontal: 12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border.all(color: Colors.black54),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<T>(
  //         iconEnabledColor: iconColor ?? Colors.black,
  //         hint: Text(
  //           value != null && viewName == true
  //               ? value.value ?? "No Value"
  //               : hintText,
  //           style: TextStyle(color: textColor ?? Colors.black),
  //         ),
  //         value: value,
  //         isExpanded: true,
  //         items: items
  //             .map((item) => DropdownMenuItem<T>(
  //                   value: item,
  //                   child: Text(
  //                     item.value ?? "No Value",
  //                     style: TextStyle(color: textColor ?? Colors.black),
  //                   ),
  //                 ))
  //             .toList(),
  //         onChanged: onChanged,
  //       ),
  //     ),
  //   );
  // }

//=============================================================================================================
  Widget _buildInfoRow(String title, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "$title : ",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.purpleAccent,
          ),
        ),
        Expanded(
          child: Text(
            value ?? "—",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  List<VastisarKuthalyavarsi>? kuthalaVarshiDataList;
  int? selectedKuthalaVarshiIdIndex;
  int? selectedKuthalaVarshiIdEdit;
  int? selectedKuthalaVarshiId;
  String? selectedKuthalaVarshiName;
  Masterdata? selectedMasterKuthalaVarshiName;
  String? selectedYearType = "shaakha";
  int? selectedisActive = 1;
  int? selectedPkId = 0;
  TextEditingController kuthalaVarshiVayogatShaakhaYearController = TextEditingController();
  TextEditingController kuthalaVarshiVayogatSaptahikYearController = TextEditingController();

  void showKuthalaVarshiPopup(
    BuildContext context, {
    int? editIndex,
    VoidCallback? onDataChanged,
  }) {
    if (editIndex != null) {
      var data = kuthalaVarshiDataList![editIndex];
      selectedKuthalaVarshiId = data.id;
      selectedKuthalaVarshiIdEdit = data.id;
      selectedPkId = data.pkid;
      selectedKuthalaVarshiName = data.selectedDropdownValueName;
      selectedYearType = data.isShaakhaa == 1 ? "shaakha" : "saptahikMilan" ?? "";
      selectedisActive = data.isactive;
      selectedMasterKuthalaVarshiName = vastisarvekshanDropDownDataModel!.masterdata!.firstWhere((item) => item.id == selectedKuthalaVarshiId);
      if (selectedYearType == 'shaakha') {
        kuthalaVarshiVayogatShaakhaYearController.text = data.shaakhaa ?? '';
      } else if (selectedYearType == 'saptahikMilan') {
        kuthalaVarshiVayogatSaptahikYearController.text = data.saptahik ?? '';
      }
      print("selectedYearType $selectedYearType");
      print("data.isactive ${data.isactive}");
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('tapshil')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearKuthalaVarshi();
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vastisarvekshanDropDownDataModel?.masterdata != null
                        ? vastisarvekshanDropdown2(
                            dataModel: vastisarvekshanDropDownDataModel!,
                            filterTypeName: "कुठल्या वर्षी",
                            hintText: "${Statics.getLabel('selectVayogat')}",
                            onItemSelected: (id, value, isOther) {
                              selectedKuthalaVarshiId = id;
                              selectedKuthalaVarshiName = value;
                            },
                            width: double.infinity,
                            selectedValue: selectedMasterKuthalaVarshiName,
                            onSelectionChanged: (newValue) {
                              setState(() {
                                selectedMasterKuthalaVarshiName = newValue;
                              });
                            },
                            editId: selectedKuthalaVarshiIdEdit,
                          )
                        : Container(),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'shaakha',
                          groupValue: selectedYearType,
                          onChanged: (value) {
                            setState(() {
                              selectedYearType = value;
                              kuthalaVarshiVayogatSaptahikYearController.clear();
                            });
                          },
                        ),
                        Text("${Statics.getLabel('Shaakhaa')}"),
                        SizedBox(width: 20),
                        Radio<String>(
                          value: 'saptahikMilan',
                          groupValue: selectedYearType,
                          onChanged: (value) {
                            setState(() {
                              selectedYearType = value;
                              kuthalaVarshiVayogatShaakhaYearController.clear();
                            });
                          },
                        ),
                        Text("${Statics.getLabel('SaaptaahikMilan')}"),
                      ],
                    ),
                    if (selectedYearType == 'shaakha')
                      textControllerField2(
                          name: "${Statics.getLabel('kuthalaVarshi')}",
                          controller: kuthalaVarshiVayogatShaakhaYearController,
                          keyboardType: TextInputType.number,
                          hintTextString: "e.g. 2025",
                          maxInput: 4),
                    if (selectedYearType == 'saptahikMilan')
                      textControllerField2(
                          name: "${Statics.getLabel('kuthalaVarshi')}",
                          controller: kuthalaVarshiVayogatSaptahikYearController,
                          keyboardType: TextInputType.number,
                          hintTextString: "e.g. 2025",
                          maxInput: 4),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  int? saptahikYear = int.tryParse(kuthalaVarshiVayogatSaptahikYearController.text);
                  int? shaakhaYear = int.tryParse(kuthalaVarshiVayogatShaakhaYearController.text);

                  if ((saptahikYear != null && saptahikYear >= 1925 && saptahikYear <= 2025) || (shaakhaYear != null && shaakhaYear >= 1925 && shaakhaYear <= 2025)) {
                    int currentType = selectedYearType == "shaakha"
                        ? 1
                        : selectedYearType == "saptahikMilan"
                            ? 0
                            : 2;

                    var matchedEntries = kuthalaVarshiDataList!.where((e) => e.id == selectedKuthalaVarshiId).toList();

                    bool hasShaakha = matchedEntries.any((e) => e.isShaakhaa == 1);
                    bool hasSaptahik = matchedEntries.any((e) => e.isShaakhaa == 0);

                    if (editIndex == null && matchedEntries.isNotEmpty) {
                      if (currentType == 1 && hasShaakha) {
                        Statics.showToast("${Statics.getLabel('alreadyShakhaSelected')}");
                        return;
                      } else if (currentType == 0 && hasSaptahik) {
                        Statics.showToast("${Statics.getLabel('alreadySaptahikSelected')}");
                        return;
                      } else if (hasShaakha && hasSaptahik) {
                        Statics.showToast("${Statics.getLabel('alreadyVayogatSelected')}");
                        return;
                      }
                    }

                    final data = VastisarKuthalyavarsi(
                      id: selectedKuthalaVarshiId,
                      prakarName: currentType == 1
                          ? "शाखा"
                          : currentType == 0
                              ? "साप्ताहिक मिलन"
                              : "-",
                      isShaakhaa: currentType,
                      pkid: selectedPkId,
                      vastiid: int.parse(selctedLevelId!),
                      shaakhaa: currentType == 1 ? kuthalaVarshiVayogatShaakhaYearController.text.trim() : "",
                      saptahik: currentType == 0 ? kuthalaVarshiVayogatSaptahikYearController.text.trim() : "",
                      isactive: selectedisActive,
                      selectedDropdownValueName: selectedKuthalaVarshiName,
                    );

                    if (editIndex != null) {
                      kuthalaVarshiDataList![editIndex] = data;
                    } else {
                      kuthalaVarshiDataList!.add(data);
                    }

                    if (onDataChanged != null) onDataChanged();
                    Navigator.of(ctx).pop();
                    clearKuthalaVarshi();
                    print("Year is valid.");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${Statics.getLabel('yearValidation')}"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearKuthalaVarshi() {
    selectedKuthalaVarshiId = null;
    selectedKuthalaVarshiIdEdit = null;
    selectedKuthalaVarshiName = null;
    selectedYearType = null;
    selectedMasterKuthalaVarshiName = null;
    kuthalaVarshiVayogatShaakhaYearController.clear();
    kuthalaVarshiVayogatSaptahikYearController.clear();
    FocusScope.of(context).unfocus();
  }

//========================  2. JAAGRAN SHRENI FORM ===========================================
  List<VastisarJaagaranshreneesthiti>? jagranShreniEnteredDataList = [];
  int? selectedJagranShreniStithiRowIndex;
  int? selectedShreniID;
  String? selectedShreniName;
  int? selectedVaramvaritaID;
  String? selectedVaramvaritaName;
  int? selectedVaramvaritaIDEdit;
  int? selectedShreniIDEdit;
  bool showSubmittedData = false;
  Masterdata? selectedJagranShreni;
  Masterdata? selectedVaramvarita;
  int? isActiveJagranShreniStithi = 1;
  int? jagranShreniPkId;
  TextEditingController isOtherJaganVaramvaritaConroller = TextEditingController();

  void showJagranShreniPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = jagranShreniEnteredDataList![editIndex];
      selectedShreniID = data.shreneeid;
      selectedShreniIDEdit = data.shreneeid;
      selectedShreniName = data.selectedDropdownValueName;
      niyamitChalnareUpkramController.text = data.niyamitacalanareupakrama ?? '';
      selectedVaramvaritaIDEdit = data.varanvaritaid;
      selectedVaramvaritaName = data.selectedDropdownValueName1;
      isActiveJagranShreniStithi = data.isactive;
      jagranShreniPkId = data.pkid;
      isOtherJaganVaramvaritaConroller.text = data.otherVaranvarita ?? '';

      // ✅ Get selected Masterdata objects for editing dropdowns
      selectedJagranShreni = vastisarvekshanDropDownDataModel?.masterdata?.firstWhere((e) => e.id == selectedShreniID && e.typename == "जागरण श्रेणी", orElse: () => Masterdata());

      selectedVaramvarita = vastisarvekshanDropDownDataModel?.masterdata?.firstWhere((e) => e.id == selectedVaramvaritaIDEdit && e.typename == "जागरण वारंवारिता", orElse: () => Masterdata());
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(16),
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔹 Title Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Statics.getLabel('jagranShreniTapshil')}",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[700]),
                            onPressed: () {
                              clearFields2();
                              Navigator.of(ctx).pop();
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 🔹 Dropdowns and fields
                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                              dataModel: vastisarvekshanDropDownDataModel!,
                              filterTypeName: "जागरण श्रेणी",
                              onItemSelected: (id, value, isOther) {
                                selectedShreniID = id;
                                selectedShreniName = value;
                              },
                              hintText: "${Statics.getLabel('otherUpshreni')}",
                              question: "${Statics.getLabel('otherUpshreni')}",
                              editId: selectedShreniIDEdit,
                              selectedValue: selectedJagranShreni,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedJagranShreni = newValue;
                                });
                              },
                            )
                          : Container(),

                      const SizedBox(height: 10),

                      textControllerField(
                        "${Statics.getLabel('niyamitUpkram')}",
                        niyamitChalnareUpkramController,
                        context,
                        height: 100,
                      ),

                      const SizedBox(height: 10),

                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                              dataModel: vastisarvekshanDropDownDataModel!,
                              filterTypeName: "जागरण वारंवारिता",
                              onItemSelected: (id, value, isOther) {
                                selectedVaramvaritaID = id;
                                selectedVaramvaritaName = value;
                                isOtherJaganVaramvaritaConroller.clear();
                              },
                              hintText: "${Statics.getLabel('varamvarita')}",
                              question: "${Statics.getLabel('selectVaramvarita')}",
                              editId: selectedVaramvaritaIDEdit,
                              selectedValue: selectedVaramvarita,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedVaramvarita = newValue;
                                });
                              },
                            )
                          : Container(),

                      const SizedBox(height: 10),

                      if (selectedVaramvarita?.isOther == 1)
                        textControllerField2(
                          name: "${Statics.getLabel('other')}",
                          controller: isOtherJaganVaramvaritaConroller,
                        ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            if (selectedVaramvarita?.isOther == 1 && isOtherJaganVaramvaritaConroller.text == "") {
                              Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                            } else {
                              final data = VastisarJaagaranshreneesthiti(
                                pkid: jagranShreniPkId,
                                vastiid: int.parse(selctedLevelId!),
                                shreneeid: selectedShreniID,
                                niyamitacalanareupakrama: niyamitChalnareUpkramController.text.trim(),
                                varanvaritaid: selectedVaramvaritaID,
                                isactive: isActiveJagranShreniStithi,
                                otherVaranvarita: isOtherJaganVaramvaritaConroller.text,
                                selectedDropdownValueName: selectedShreniName,
                                selectedDropdownValueName1: selectedVaramvaritaName,
                              );

                              if (editIndex != null) {
                                jagranShreniEnteredDataList![editIndex] = data;
                              } else {
                                jagranShreniEnteredDataList!.add(data);
                              }

                              Navigator.of(ctx).pop();
                              clearFields2();
                              onDataChanged?.call();
                            }
                          },
                          child: Text(
                            "${Statics.getLabel('Submit')}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void clearFields2() {
    setState(() {
      jagranShreniPkId = null;
      selectedShreniID = null;
      selectedShreniName = null;
      selectedShreniIDEdit = null;
      selectedShreni = null;
      selectedVaramvaritaID = null;
      selectedVaramvaritaName = null;
      selectedVaramvaritaIDEdit = null;
      selectedVaramvarita = null;
      niyamitChalnareUpkramController.clear();
      isOtherJaganVaramvaritaConroller.clear();
      isActiveJagranShreniStithi = 1;
    });
  }

//========================  3. GATIVIDHI FORM ===========================================
  List<VastisarGatividhikaryasthiti> enteredDataListGatividhi = [];
  int? selectedGatividhiKaryaStithiRowIndex;
  int? selectedShreniIDGatividhi;
  String? selectedShreniNameGatividhi;
  int? selectedVaramvaritaIDGatividhi;
  String? selectedVaramvaritaNameGatividhi;
  int? selectedVaramvaritaIDEditGatividhi;
  int? selectedShreniIDEditGatividhi;
  bool showSubmittedDataGatividhi = false;
  Masterdata? selectedShreniGatividhi;
  Masterdata? selectedVaramvaritaGatividhi;
  int? isActiveGatividhi = 1;
  int? gatividhiPkId;
  TextEditingController anyaGatividhiVaramvaritaController = TextEditingController();

  void showGatividhiPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    // Pre-fill data if editing
    if (editIndex != null) {
      var data = enteredDataListGatividhi[editIndex];
      selectedShreniIDGatividhi = data.gatividhiid;
      selectedShreniNameGatividhi = data.selectedDropdownValueName;
      selectedShreniGatividhi = vastisarvekshanDropDownDataModel!.masterdata!.firstWhere((item) => item.id == selectedShreniIDGatividhi);
      niyamitChalnareUpkramGatividhiController.text = data.niyamitacalanareupakrama ?? "";
      selectedVaramvaritaIDGatividhi = data.varanvaritaid;
      selectedVaramvaritaNameGatividhi = data.selectedDropdownValueName1;
      selectedVaramvaritaGatividhi = vastisarvekshanDropDownDataModel!.masterdata!.firstWhere((item) => item.id == selectedVaramvaritaIDGatividhi);
      isActiveGatividhi = data.isactive;
      gatividhiPkId = data.pkid;
      anyaGatividhiVaramvaritaController.text = data.otherVaranvarita ?? "";
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(16),
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${Statics.getLabel('gatividhiKaryaStithi')}", style: TextStyle(fontSize: 20, color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[700]),
                            onPressed: () {
                              clearFields3();
                              Navigator.of(ctx).pop();
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                              dataModel: vastisarvekshanDropDownDataModel!,
                              filterTypeName: "गतिविधी कार्य",
                              onItemSelected: (id, value, isOther) {
                                selectedShreniIDGatividhi = id;
                                selectedShreniNameGatividhi = value;
                              },
                              hintText: "${Statics.getLabel('gatividhiNivada')}",
                              question: "${Statics.getLabel('gatividhiNivada')}",
                              editId: selectedShreniIDGatividhi,
                              selectedValue: selectedShreniGatividhi,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedShreniGatividhi = newValue;
                                });
                              },
                            )
                          : Container(),
                      SizedBox(height: 10),
                      textControllerField("${Statics.getLabel('niyamitUpkram')}", niyamitChalnareUpkramGatividhiController, context, height: 100),
                      SizedBox(height: 10),
                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                              dataModel: vastisarvekshanDropDownDataModel!,
                              filterTypeName: "गतिविधी वारंवारिता",
                              onItemSelected: (id, value, isOther) {
                                selectedVaramvaritaIDGatividhi = id;
                                selectedVaramvaritaNameGatividhi = value;
                              },
                              hintText: "${Statics.getLabel('varamvarita')}",
                              question: "${Statics.getLabel('selectVaramvarita')}",
                              editId: selectedVaramvaritaIDGatividhi,
                              selectedValue: selectedVaramvaritaGatividhi,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedVaramvaritaGatividhi = newValue;
                                  anyaGatividhiVaramvaritaController.clear();
                                });
                              },
                            )
                          : Container(),
                      SizedBox(height: 10),
                      if (selectedVaramvaritaGatividhi?.isOther == 1)
                        textControllerField2(name: "${Statics.getLabel('other')}", controller: anyaGatividhiVaramvaritaController, hintTextString: "${Statics.getLabel('anyaVaramvarita')}"),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            if (selectedVaramvaritaGatividhi?.isOther == 1 && anyaGatividhiVaramvaritaController.text == "") {
                              Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                            } else {
                              if (selectedShreniIDGatividhi == null || selectedVaramvaritaIDGatividhi == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${Statics.getLabel('fillAllIMPInfo')}")),
                                );
                                return;
                              }
                              var data = VastisarGatividhikaryasthiti(
                                pkid: gatividhiPkId ?? 0,
                                vastiid: int.parse(selctedLevelId!),
                                gatividhiid: selectedShreniIDGatividhi!,
                                selectedDropdownValueName: selectedShreniNameGatividhi,
                                niyamitacalanareupakrama: niyamitChalnareUpkramGatividhiController.text.trim(),
                                varanvaritaid: selectedVaramvaritaIDGatividhi,
                                selectedDropdownValueName1: selectedVaramvaritaNameGatividhi,
                                isactive: isActiveGatividhi,
                                otherVaranvarita: anyaGatividhiVaramvaritaController.text,
                              );
                              if (editIndex != null) {
                                enteredDataListGatividhi[editIndex] = data;
                              } else {
                                enteredDataListGatividhi.add(data);
                              }
                              clearFields3();
                              Navigator.of(ctx).pop();
                              if (onDataChanged != null) onDataChanged();
                            }
                          },
                          child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void clearFields3() {
    selectedShreniIDGatividhi = null;
    selectedShreniNameGatividhi = null;
    selectedShreniIDEditGatividhi = null;
    selectedShreniGatividhi = null;
    selectedVaramvaritaIDGatividhi = null;
    selectedVaramvaritaNameGatividhi = null;
    selectedVaramvaritaIDEditGatividhi = null;
    selectedVaramvaritaGatividhi = null;
    gatividhiPkId = null;
    niyamitChalnareUpkramGatividhiController.clear();
    anyaGatividhiVaramvaritaController.clear();
  }

//========================  4. VASAHAT PRAKAR FORM ===========================================
  List<VastisarVasahatprakara> enteredVasahatPrakarDataList = [];
  int? selectedvsahatPrakarIdRowIndex;
  int? vsahatPrakarId;
  String? vsahatPrakarName;
  Masterdata? selectedVsahatPrakar;
  int? vsahatSamparkId;
  String? vsahatSamparkName;
  Masterdata? selectedvsahatSampark;
  int? selectedVsahatPrakarEditId;
  int? selectedvsahatSamparkEditId;
  int? isActiveVsahatPrakar = 1;
  int? pkIdVsahatPrakar = 0;

  void showVsahatTypePopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = enteredVasahatPrakarDataList[editIndex];
      vsahatPrakarName = data.selectedDropdownValueName;
      vsahatPrakarId = data.prakarid;
      selectedVsahatPrakarEditId = data.prakarid;
      vsahatPrakarBhavnacheNavController.text = data.bhavanachenav ?? "";
      vsahatSamparkName = data.selectedDropdownValueName1;
      vsahatSamparkId = data.samparksthitiid;
      pkIdVsahatPrakar = data.pkid;
      selectedvsahatSamparkEditId = data.samparksthitiid;
      vsahatPrakarSamparkKshetraController.text = data.samparksootr ?? "";
      vsahatPrakarDurbhashController.text = data.doorabhaash ?? "";
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(16),
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Statics.getLabel('vasahatPrakar')}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              clearFields();
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      textControllerField2(controller: vsahatPrakarBhavnacheNavController, name: "${Statics.getLabel('bhavnacheNaav')}", keyboardType: TextInputType.text, height: 50),
                      const SizedBox(height: 10),
                      // Dropdown 1
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${Statics.getLabel('SelectPrakar')}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      vastisarvekshanDropdown2(
                        dataModel: vastisarvekshanDropDownDataModel!,
                        filterTypeName: "वसाहत प्रकार",
                        hintText: "${Statics.getLabel('SelectFrequency')}",
                        onItemSelected: (id, value, isOther) {
                          vsahatPrakarName = value;
                          vsahatPrakarId = id;
                        },
                        width: double.infinity,
                        questionNumber: 12,
                        selectedValue: selectedVsahatPrakar,
                        onSelectionChanged: (newValue) {
                          setState(() {
                            selectedVsahatPrakar = newValue;
                          });
                        },
                        editId: selectedVsahatPrakarEditId,
                      ),
                      const SizedBox(height: 10),
                      // Dropdown 2
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${Statics.getLabel('samparkSthitiSelect')}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      vastisarvekshanDropdown2(
                        dataModel: vastisarvekshanDropDownDataModel!,
                        filterTypeName: "वसाहत संपर्क स्थिति",
                        hintText: "${Statics.getLabel('samparkSthitiSelect')}",
                        onItemSelected: (id, value, isOther) {
                          vsahatSamparkName = value;
                          vsahatSamparkId = id;
                        },
                        width: double.infinity,
                        questionNumber: 12,
                        selectedValue: selectedvsahatSampark,
                        onSelectionChanged: (newValue) {
                          setState(() {
                            selectedvsahatSampark = newValue;
                          });
                        },
                        editId: selectedvsahatSamparkEditId,
                      ),
                      const SizedBox(height: 10),
                      textControllerField2(controller: vsahatPrakarSamparkKshetraController, name: "${Statics.getLabel('samparkSootraNaav')}", keyboardType: TextInputType.text, height: 50),
                      const SizedBox(height: 10),
                      textControllerField2(
                        controller: vsahatPrakarDurbhashController,
                        name: "${Statics.getLabel('samparakSootraDoorbhash')}",
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                      ),

                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          // onPressed: () {
                          //   final data = VastisarVasahatprakara(
                          //     pkid: pkIdVsahatPrakar,
                          //     vastiid: int.parse(selctedLevelId!),
                          //     prakarid: vsahatPrakarId ?? 0,
                          //     selectedDropdownValueName: vsahatPrakarName ?? '',
                          //     bhavanachenav: vsahatPrakarBhavnacheNavController
                          //         .text
                          //         .trim(),
                          //     samparksthitiid: vsahatSamparkId ?? 0,
                          //     selectedDropdownValueName1:
                          //         vsahatSamparkName ?? '',
                          //     samparksootr: vsahatPrakarSamparkKshetraController
                          //         .text
                          //         .trim(),
                          //     doorabhaash:
                          //         vsahatPrakarDurbhashController.text.trim(),
                          //     isactive: isActiveVsahatPrakar,
                          //   );
                          //
                          //   if (editIndex != null) {
                          //     enteredVasahatPrakarDataList[editIndex] = data;
                          //   } else {
                          //     enteredVasahatPrakarDataList.add(data);
                          //   }
                          //   clearFields();
                          //   setState(() {});
                          //   Navigator.of(ctx).pop();
                          //   if (onDataChanged != null) onDataChanged();
                          // },

                          onPressed: () {
                            if (vsahatPrakarDurbhashController.text.length != 10) {
                              Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                            } else {
                              final data = VastisarVasahatprakara(
                                pkid: pkIdVsahatPrakar,
                                vastiid: int.parse(selctedLevelId!),
                                prakarid: vsahatPrakarId ?? 0,
                                selectedDropdownValueName: vsahatPrakarName ?? '',
                                bhavanachenav: vsahatPrakarBhavnacheNavController.text.trim(),
                                samparksthitiid: vsahatSamparkId ?? 0,
                                selectedDropdownValueName1: vsahatSamparkName ?? '',
                                samparksootr: vsahatPrakarSamparkKshetraController.text.trim(),
                                doorabhaash: vsahatPrakarDurbhashController.text.trim(),
                                isactive: isActiveVsahatPrakar,
                              );

                              if (editIndex != null) {
                                enteredVasahatPrakarDataList[editIndex] = data;
                              } else {
                                enteredVasahatPrakarDataList.add(data);
                              }
                              clearFields();
                              setState(() {});
                              Navigator.of(ctx).pop();
                              if (onDataChanged != null) onDataChanged();
                            }
                          },

                          child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void clearFields() {
    vsahatPrakarBhavnacheNavController.clear();
    vsahatPrakarSamparkKshetraController.clear();
    vsahatPrakarDurbhashController.clear();
    vsahatPrakarName = "";
    vsahatPrakarId = null;
    vsahatSamparkName = "";
    vsahatSamparkId = null;
    selectedVsahatPrakar = null;
    selectedvsahatSampark = null;
    selectedVsahatPrakarEditId = null;
    selectedvsahatSamparkEditId = null;
    pkIdVsahatPrakar = 0;
  }

//========================  5. VIVIDH BHASHA BOLNARE FORM ===========================================
  List<VastisarVividhaprakara> enteredVividhBhashaBolnareDataList = [];
  int? selectedVividhBhashaBolnarerIdRowIndex;
  int? bhashaId;
  String? bhashaName;
  Masterdata? selectedbhasha;
  int? selectedbhashaEditId;
  int? isActiveBhasha = 1;
  int? pkIdVividhBhasha = 0;
  TextEditingController bhashaPersentCount = TextEditingController();
  TextEditingController anyaBhashaNameController = TextEditingController();
  String? bhashaCount;

  void showVividhBhashaBolnarePopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = enteredVividhBhashaBolnareDataList[editIndex];
      bhashaId = data.bhaashaid;
      bhashaName = data.selectedDropdownValueName;
      // selectedbhasha = data.bhaashaid;
      selectedbhashaEditId = data.bhaashaid;
      pkIdVividhBhasha = data.pkid;
      bhashaPersentCount.text = data.andaje ?? "";
      anyaBhashaNameController.text = data.otherbhaasha!;
      bhashaCount = data.andajeForShow;
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(16),
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Statics.getLabel('vividhBhashaBolnare')}",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              clearFields4();
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Dropdown 1
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${Statics.getLabel('selectLanguage')}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      vastisarvekshanDropdown2(
                        dataModel: vastisarvekshanDropDownDataModel!,
                        filterTypeName: "विविध भाषा",
                        hintText: "${Statics.getLabel('selectLanguage')}",
                        onItemSelected: (id, value, isOther) {
                          bhashaName = value;
                          bhashaId = id;
                          anyaBhashaNameController.clear();
                        },
                        width: double.infinity,
                        questionNumber: 12,
                        selectedValue: selectedbhasha,
                        onSelectionChanged: (newValue) {
                          setState(() {
                            selectedbhasha = newValue;
                          });
                        },
                        editId: selectedbhashaEditId,
                      ),
                      SizedBox(height: 10),
                      if (selectedbhasha?.isOther == 1)
                        textControllerField2(controller: anyaBhashaNameController, name: "${Statics.getLabel('OtherLanguage')}", height: 50, hintTextString: "${Statics.getLabel('onlyBhasha')}"),
                      SizedBox(height: 10),
                      textControllerField2(
                        controller: bhashaPersentCount,
                        name: "${Statics.getLabel('avgPersent')}",
                        keyboardType: TextInputType.number,
                        height: 50,
                        hintTextString: "${Statics.getLabel('example0to100')}",
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            double? average = double.tryParse(bhashaPersentCount.text.trim());
                            if (selectedbhasha?.isOther == 1 && anyaBhashaNameController.text == "") {
                              Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                              return;
                            }
                            if (average == null || average < 0 || average > 100) {
                              Statics.showToast("${Statics.getLabel('persentValidation')}");
                              return;
                            }

                            bool isDuplicate =
                                enteredVividhBhashaBolnareDataList.any((item) => item.bhaashaid == bhashaId && (editIndex == null || enteredVividhBhashaBolnareDataList.indexOf(item) != editIndex));

                            if (isDuplicate) {
                              Statics.showToast("${Statics.getLabel('bhashaValidation')}");
                              return;
                            }
                            double totalPercent = 0;
                            for (int i = 0; i < enteredVividhBhashaBolnareDataList.length; i++) {
                              if (editIndex != null && i == editIndex) continue;
                              totalPercent += double.tryParse(enteredVividhBhashaBolnareDataList[i].andaje!) ?? 0;
                            }
                            totalPercent += average;

                            if (totalPercent > 100) {
                              Statics.showToast("${Statics.getLabel('notMoreThan100')}");
                              return;
                            }

                            final newData = VastisarVividhaprakara(
                              pkid: pkIdVividhBhasha,
                              vastiid: int.parse(selctedLevelId!),
                              bhaashaid: bhashaId,
                              selectedDropdownValueName: bhashaName,
                              andaje: bhashaPersentCount.text.trim(),
                              otherbhaasha: anyaBhashaNameController.text,
                              isactive: isActiveBhasha,
                            );
                            print("newData ${json.encode(newData)}");
                            if (editIndex != null) {
                              enteredVividhBhashaBolnareDataList[editIndex] = newData;
                            } else {
                              enteredVividhBhashaBolnareDataList.add(newData);
                            }
                            clearFields4();
                            setState(() {});
                            Navigator.of(ctx).pop();
                            if (onDataChanged != null) onDataChanged();
                          },
                          child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // void showVividhBhashaBolnarePopup(BuildContext context,
  //     {int? editIndex, VoidCallback? onDataChanged}) {
  //   if (editIndex != null) {
  //     var data = enteredVividhBhashaBolnareDataList[editIndex];
  //     bhashaId = data.bhaashaid;
  //     bhashaName = data.selectedDropdownValueName;
  //     selectedbhashaEditId = data.bhaashaid;
  //     pkIdVividhBhasha = data.pkid;
  //     bhashaPersentCount.text = data.andaje ?? "";
  //     anyaBhashaNameController.text = data.otherbhaasha ?? "";
  //     bhashaCount = data.andajeForShow;
  //     isActiveBhasha = data.isactive;
  //   } else {
  //     isActiveBhasha = 1;
  //   }
  //
  //   showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       return Dialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //         child: StatefulBuilder(
  //           builder: (context, setState) {
  //             return Container(
  //               padding: EdgeInsets.all(16),
  //               width: 350,
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           "${Statics.getLabel('vividhBhashaBolnare')}",
  //                           style: TextStyle(
  //                               fontSize: 20,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.purpleAccent),
  //                         ),
  //                         IconButton(
  //                           icon: const Icon(Icons.close),
  //                           onPressed: () {
  //                             clearFields4();
  //                             Navigator.of(ctx).pop();
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 10),
  //
  //                     // Language Dropdown
  //                     Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         "${Statics.getLabel('selectLanguage')}",
  //                         style: TextStyle(fontSize: 15),
  //                       ),
  //                     ),
  //                     vastisarvekshanDropdown2(
  //                       dataModel: vastisarvekshanDropDownDataModel!,
  //                       filterTypeName: "विविध भाषा",
  //                       hintText: "${Statics.getLabel('selectLanguage')}",
  //                       onItemSelected: (id, value, isOther) {
  //                         bhashaName = value;
  //                         bhashaId = id;
  //                         anyaBhashaNameController.clear();
  //                       },
  //                       width: double.infinity,
  //                       questionNumber: 12,
  //                       selectedValue: selectedbhasha,
  //                       onSelectionChanged: (newValue) {
  //                         setState(() {
  //                           selectedbhasha = newValue;
  //                         });
  //                       },
  //                       editId: selectedbhashaEditId,
  //                     ),
  //                     SizedBox(height: 10),
  //
  //                     // Other Language Field
  //                     if (selectedbhasha?.isOther == 1)
  //                       textControllerField2(
  //                         controller: anyaBhashaNameController,
  //                         name: "${Statics.getLabel('OtherLanguage')}",
  //                         height: 50,
  //                         hintTextString: "${Statics.getLabel('onlyBhasha')}",
  //                       ),
  //
  //                     SizedBox(height: 10),
  //
  //                     // Percentage Dropdown
  //                     Column(
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.centerLeft,
  //                           child: RichText(
  //                             text: TextSpan(
  //                               children: [
  //                                 TextSpan(
  //                                   text:
  //                                       "${Statics.getLabel('prushaanchiSankhya')}",
  //                                   style: TextStyle(
  //                                     fontSize: 15,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.black,
  //                                   ),
  //                                 ),
  //                                 TextSpan(
  //                                   text: "*",
  //                                   style: TextStyle(
  //                                     fontSize: 15,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.red,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(height: 5),
  //                         Container(
  //                           height: 50,
  //                           width: double.infinity,
  //                           padding: EdgeInsets.symmetric(horizontal: 12),
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             border: Border.all(color: Colors.black54),
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           child: DropdownButtonHideUnderline(
  //                             child: DropdownButton<String>(
  //                               isExpanded: true,
  //                               value: bhashaCount != null
  //                                   ? bhashaOptions[bhashaCount!]
  //                                   : null,
  //                               items: bhashaOptions.entries.map((entry) {
  //                                 return DropdownMenuItem<String>(
  //                                   value: entry.value, // 55 / 30 / 19
  //                                   child: Text(entry.key), // "अधिक ५०%" etc.
  //                                 );
  //                               }).toList(),
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   bhashaPersentCount.text = value!;
  //
  //                                   // Store label in bhashaCount for andajeForShow
  //                                   bhashaCount = bhashaOptions.entries
  //                                       .firstWhere(
  //                                           (entry) => entry.value == value)
  //                                       .key;
  //                                 });
  //                               },
  //                               hint: Text(
  //                                   Statics.getLabel('prushaanchiSankhya')),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //
  //                     SizedBox(height: 10),
  //
  //                     // Submit Button
  //                     Align(
  //                       alignment: Alignment.center,
  //                       child: ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.purple,
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8)),
  //                         ),
  //                         onPressed: () {
  //                           double? average =
  //                               double.tryParse(bhashaPersentCount.text.trim());
  //
  //                           if (selectedbhasha?.isOther == 1 &&
  //                               anyaBhashaNameController.text == "") {
  //                             Statics.showToast(
  //                                 "${Statics.getLabel('otherInfoValidation')}");
  //                             return;
  //                           }
  //
  //                           if (average == null ||
  //                               average < 0 ||
  //                               average > 100) {
  //                             Statics.showToast(
  //                                 "${Statics.getLabel('persentValidation')}");
  //                             return;
  //                           }
  //
  //                           bool isDuplicate =
  //                               enteredVividhBhashaBolnareDataList.any((item) =>
  //                                   item.bhaashaid == bhashaId &&
  //                                   (editIndex == null ||
  //                                       enteredVividhBhashaBolnareDataList
  //                                               .indexOf(item) !=
  //                                           editIndex));
  //
  //                           if (isDuplicate) {
  //                             Statics.showToast(
  //                                 "${Statics.getLabel('bhashaValidation')}");
  //                             return;
  //                           }
  //
  //                           double totalPercent = 0;
  //                           for (int i = 0;
  //                               i < enteredVividhBhashaBolnareDataList.length;
  //                               i++) {
  //                             if (editIndex != null && i == editIndex) continue;
  //
  //                             var item = enteredVividhBhashaBolnareDataList[i];
  //                             if (item.isactive == 1) {
  //                               totalPercent +=
  //                                   double.tryParse(item.andaje ?? "") ?? 0;
  //                             }
  //                           }
  //
  //                           if (isActiveBhasha == 1) {
  //                             totalPercent += average;
  //                           }
  //
  //                           if (totalPercent > 100) {
  //                             Statics.showToast(
  //                                 "${Statics.getLabel('notMoreThan100')}");
  //                             return;
  //                           }
  //
  //                           final newData = VastisarVividhaprakara(
  //                             pkid: pkIdVividhBhasha,
  //                             vastiid: int.parse(selctedLevelId!),
  //                             bhaashaid: bhashaId,
  //                             selectedDropdownValueName: bhashaName,
  //                             andaje:
  //                                 bhashaPersentCount.text.trim(), // e.g., "55"
  //                             otherbhaasha: anyaBhashaNameController.text,
  //                             isactive: isActiveBhasha,
  //                             andajeForShow: bhashaCount, // e.g., "अधिक ५०%"
  //                           );
  //
  //                           print("newData ${json.encode(newData)}");
  //                           if (editIndex != null) {
  //                             enteredVividhBhashaBolnareDataList[editIndex] =
  //                                 newData;
  //                           } else {
  //                             enteredVividhBhashaBolnareDataList.add(newData);
  //                           }
  //                           clearFields4();
  //                           setState(() {});
  //                           Navigator.of(ctx).pop();
  //                           if (onDataChanged != null) onDataChanged();
  //                         },
  //                         child: Text("${Statics.getLabel('Submit')}",
  //                             style: TextStyle(color: Colors.white)),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  void clearFields4() {
    bhashaId = null;
    bhashaName = null;
    selectedbhasha = null;
    selectedbhashaEditId = null;
    pkIdVividhBhasha = 0;
    bhashaPersentCount.clear();
    anyaBhashaNameController.clear();
  }

//========================  6.KONTYA PRANTACHE FORM ===========================================
  List<VastisarKonatyaprantache> enteredKontyaPraantacheDataList = [];
  int? selectedKontyaPraantacheIdRowIndex;
  int? KontyaPraantacheId;
  String? KontyaPraantacheName;
  Masterdata? selectedKontyaPraantache;
  int? selectedKontyaPraantacheEditId;
  int? isActiveKontyaPraantache = 1;
  int? pkIdKontyaPrantache = 0;
  TextEditingController loksankhyaAveragePersentCount = TextEditingController();
  TextEditingController anyaKontyaPrantacheNameController = TextEditingController();

  void showKontyaPraantachePopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = enteredKontyaPraantacheDataList[editIndex];
      KontyaPraantacheId = data.praantid;
      pkIdKontyaPrantache = data.pkid;
      KontyaPraantacheName = data.selectedDropdownValueName;
      selectedKontyaPraantacheEditId = data.praantid;
      loksankhyaAveragePersentCount.text = data.andaje ?? "";
      anyaKontyaPrantacheNameController.text = data.anyaPraantName ?? "";
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(16),
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Statics.getLabel('kontyaPrantache')}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              clearFields5();
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${Statics.getLabel('Praant')}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      vastisarvekshanDropdown4(
                        dataModel: vastisarvekshanDropDownDataModel!,
                        filterTypeName: "कोणत्या प्रांताचे",
                        hintText: "${Statics.getLabel('selectPraant')}",
                        onItemSelected: (id, value, isOther) {
                          KontyaPraantacheName = value;
                          KontyaPraantacheId = id;
                        },
                        width: double.infinity,
                        selectedValue: selectedKontyaPraantache,
                        onSelectionChanged: (newValue) {
                          setState(() {
                            selectedKontyaPraantache = newValue;
                          });
                        },
                        editId: selectedKontyaPraantacheEditId,
                        excludedItemIds: enteredKontyaPraantacheDataList.map((e) => e.praantid!).toList(),
                      ),
                      SizedBox(height: 10),
                      if (selectedKontyaPraantache?.isOther == 1)
                        textControllerField2(
                          controller: anyaKontyaPrantacheNameController,
                          name: "${Statics.getLabel('otherPraant')}",
                          height: 50,
                          hintTextString: "${Statics.getLabel('otherPraant')}",
                        ),
                      textControllerField2(
                        controller: loksankhyaAveragePersentCount,
                        name: "${Statics.getLabel('avgPersent')}",
                        keyboardType: TextInputType.number,
                        height: 50,
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          // onPressed: () {
                          //   if (selectedKontyaPraantache?.isOther == 1 &&
                          //       anyaKontyaPrantacheNameController.text == "") {
                          //     Statics.showToast(
                          //         "${Statics.getLabel('otherInfoValidation')}");
                          //   } else {
                          //     final item = VastisarKonatyaprantache(
                          //       pkid: pkIdKontyaPrantache ?? 0,
                          //       vastiid: int.parse(selctedLevelId!),
                          //       praantid: KontyaPraantacheId,
                          //       andaje:
                          //           loksankhyaAveragePersentCount.text.trim(),
                          //       anyaPraantName:
                          //           anyaKontyaPrantacheNameController.text
                          //               .trim(),
                          //       isactive: isActiveKontyaPraantache,
                          //       selectedDropdownValueName: KontyaPraantacheName,
                          //     );
                          //     if (editIndex != null) {
                          //       enteredKontyaPraantacheDataList[editIndex] =
                          //           item;
                          //     } else {
                          //       enteredKontyaPraantacheDataList.add(item);
                          //     }
                          //     clearFields5();
                          //     setState(() {});
                          //     Navigator.of(ctx).pop();
                          //     if (onDataChanged != null) onDataChanged();
                          //   }
                          // },
                          // onPressed: () {
                          //   String input =
                          //       loksankhyaAveragePersentCount.text.trim();
                          //
                          //   // Check if input is a valid number between 0-100
                          //   if (!RegExp(r'^\d+$')
                          //           .hasMatch(input) || // only digits
                          //       int.tryParse(input) == null || // valid integer
                          //       int.parse(input) < 0 ||
                          //       int.parse(input) > 100) {
                          //     Statics.showToast(
                          //         "${Statics.getLabel('persentValidation')}"); // Your localized label
                          //     return;
                          //   }
                          //
                          //   if (selectedKontyaPraantache?.isOther == 1 &&
                          //       anyaKontyaPrantacheNameController.text == "") {
                          //     Statics.showToast(
                          //         "${Statics.getLabel('otherInfoValidation')}");
                          //   } else {
                          //     final item = VastisarKonatyaprantache(
                          //       pkid: pkIdKontyaPrantache ?? 0,
                          //       vastiid: int.parse(selctedLevelId!),
                          //       praantid: KontyaPraantacheId,
                          //       andaje: input,
                          //       anyaPraantName:
                          //           anyaKontyaPrantacheNameController.text
                          //               .trim(),
                          //       isactive: isActiveKontyaPraantache,
                          //       selectedDropdownValueName: KontyaPraantacheName,
                          //     );
                          //     if (editIndex != null) {
                          //       enteredKontyaPraantacheDataList[editIndex] =
                          //           item;
                          //     } else {
                          //       enteredKontyaPraantacheDataList.add(item);
                          //     }
                          //     clearFields5();
                          //     setState(() {});
                          //     Navigator.of(ctx).pop();
                          //     if (onDataChanged != null) onDataChanged();
                          //   }
                          // },
                          onPressed: () {
                            String input = loksankhyaAveragePersentCount.text.trim();

                            // Check if input is a valid number between 0-100
                            if (!RegExp(r'^\d+$').hasMatch(input) || // only digits
                                int.tryParse(input) == null || // valid integer
                                int.parse(input) < 0 ||
                                int.parse(input) > 100) {
                              Statics.showToast("${Statics.getLabel('persentValidation')}");
                              return;
                            }

                            int newValue = int.parse(input);

                            // Calculate total of andaje where isactive == 1
                            int total = 0;
                            for (int i = 0; i < enteredKontyaPraantacheDataList.length; i++) {
                              if (enteredKontyaPraantacheDataList[i].isactive == 1) {
                                total += int.tryParse(enteredKontyaPraantacheDataList[i].andaje!) ?? 0;
                              }
                            }

                            // If editing, subtract old value before adding new one
                            if (editIndex != null && enteredKontyaPraantacheDataList[editIndex].isactive == 1) {
                              total -= int.tryParse(enteredKontyaPraantacheDataList[editIndex].andaje!) ?? 0;
                            }

                            total += newValue;

                            // Check if total exceeds 100
                            if (total > 100) {
                              Statics.showToast("${Statics.getLabel('notMoreThan100')}");
                              return;
                            }

                            if (selectedKontyaPraantache?.isOther == 1 && anyaKontyaPrantacheNameController.text == "") {
                              Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                            } else {
                              final item = VastisarKonatyaprantache(
                                pkid: pkIdKontyaPrantache ?? 0,
                                vastiid: int.parse(selctedLevelId!),
                                praantid: KontyaPraantacheId,
                                andaje: input,
                                anyaPraantName: anyaKontyaPrantacheNameController.text.trim(),
                                isactive: isActiveKontyaPraantache,
                                selectedDropdownValueName: KontyaPraantacheName,
                              );
                              if (editIndex != null) {
                                enteredKontyaPraantacheDataList[editIndex] = item;
                              } else {
                                enteredKontyaPraantacheDataList.add(item);
                              }
                              clearFields5();
                              setState(() {});
                              Navigator.of(ctx).pop();
                              if (onDataChanged != null) onDataChanged();
                            }
                          },

                          child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void clearFields5() {
    KontyaPraantacheId = null;
    KontyaPraantacheName = null;
    selectedKontyaPraantache = null;
    selectedKontyaPraantacheEditId = null;
    loksankhyaAveragePersentCount.clear();
    anyaKontyaPrantacheNameController.clear();
  }

//========================  7. RELIGION FORM ===========================================
  List<VastisarReligion> enteredreligionDataList = [];
  int? selectedReligionIdRowIndex;
  int? religionId;
  String? religionName;
  Masterdata? selectedreligion;
  int? selectedreligionEditId;
  int? isActiveReligion = 1;
  int? pkIdReligion = 0;
  TextEditingController religionAveragePersentCount = TextEditingController();

  void showReligionPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = enteredreligionDataList[editIndex];
      religionId = data.konatyarilijanaceid;
      religionName = data.selectedDropdownValueName;
      selectedreligionEditId = data.konatyarilijanaceid;
      pkIdReligion = data.pkid;
      religionAveragePersentCount.text = data.andaje ?? "";
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(16),
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${Statics.getLabel('religion')}",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              clearFields6();
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("${Statics.getLabel('wichRiligion')}", style: TextStyle(fontSize: 15)),
                      ),
                      vastisarvekshanDropdown4(
                        dataModel: vastisarvekshanDropDownDataModel!,
                        filterTypeName: "रिलीजन",
                        hintText: "${Statics.getLabel('selectRelegion')}",
                        onItemSelected: (id, value, isOther) {
                          religionName = value;
                          religionId = id;
                        },
                        width: double.infinity,
                        selectedValue: selectedreligion,
                        onSelectionChanged: (newValue) {
                          setState(() {
                            selectedreligion = newValue;
                          });
                        },
                        editId: selectedreligionEditId,
                        excludedItemIds: enteredreligionDataList.map((e) => e.konatyarilijanaceid!).toList(),
                      ),
                      SizedBox(height: 10),
                      textControllerField2(
                        controller: religionAveragePersentCount,
                        name: "${Statics.getLabel('avgPersent')}",
                        keyboardType: TextInputType.number,
                        height: 50,
                        hintTextString: "${Statics.getLabel('example0to100')}",
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            double? average = double.tryParse(religionAveragePersentCount.text.trim());
                            if (average == null || average < 0 || average > 100) {
                              Statics.showToast(
                                "${Statics.getLabel('persentValidation')}",
                              );
                              return;
                            }

                            VastisarReligion newReligion = VastisarReligion(
                              pkid: pkIdReligion ?? 0,
                              vastiid: int.parse(selctedLevelId!),
                              konatyarilijanaceid: religionId,
                              selectedDropdownValueName: religionName,
                              andaje: religionAveragePersentCount.text.trim(),
                              isactive: isActiveReligion ?? 1,
                            );

                            if (editIndex != null) {
                              enteredreligionDataList[editIndex] = newReligion;
                            } else {
                              enteredreligionDataList.add(newReligion);
                            }

                            clearFields6();
                            setState(() {});
                            Navigator.of(ctx).pop();
                            if (onDataChanged != null) onDataChanged();
                          },
                          child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void clearFields6() {
    religionId = null;
    religionName = null;
    selectedreligion = null;
    selectedreligionEditId = null;
    religionAveragePersentCount.clear();
  }

//=================================================== 8. UPASNA STHAL FORM ====================================================================================
  List<Vastisarupaasana> upasnaSthalDataList = [];
  int? selectedUpasnaSthalRowIndex;
  int? selectedUpasnaSthalId;
  String? selectedUpasnaSthalName;
  Masterdata? selectedUpasnaSthal;
  int? editUpasnaSthalId;
  int? selectedUpasnaSthalTypeId;
  String? selectedUpasnaSthalTypeName;
  Masterdata? selectedUpasnaSthalType;
  int? editUpasnaSthalTypeId;
  int? isActiveUpasanaSthal = 1;
  int? upasnaSthalPkid = 0;
  final TextEditingController upasnaSthalCountController = TextEditingController();
  final TextEditingController anyaUpasnaSthalNameController = TextEditingController();

  void showUpasnaSthalPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = upasnaSthalDataList[editIndex];
      selectedUpasnaSthalName = data.selectedDropdownValueName1;
      selectedUpasnaSthalId = data.upaasanasthalaid;
      editUpasnaSthalId = data.upaasanasthalaid;
      upasnaSthalCountController.text = data.sankhya ?? "";
      selectedUpasnaSthalTypeName = data.selectedDropdownValueName1;
      selectedUpasnaSthalTypeId = data.prakarid;
      editUpasnaSthalTypeId = data.prakarid;
      upasnaSthalPkid = data.pkid;
      anyaUpasnaSthalNameController.text = data.otherupaasanasthala ?? "";
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('UpsanaSthal')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  clearUpasnaSthalFields();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "उपासना स्थळ",
                      hintText: "${Statics.getLabel('selectUpasanaSthal')}",
                      onItemSelected: (id, value, isOther) {
                        selectedUpasnaSthalName = value;
                        selectedUpasnaSthalId = id;
                      },
                      width: 250,
                      selectedValue: selectedUpasnaSthal,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedUpasnaSthal = newValue;
                        });
                      },
                      editId: editUpasnaSthalId,
                    ),
                    if (selectedUpasnaSthal?.isOther == 1) SizedBox(height: 10),
                    if (selectedUpasnaSthal?.isOther == 1)
                      textControllerField2(
                          controller: anyaUpasnaSthalNameController, name: "${Statics.getLabel('otherUpasanaSthal')}", height: 50, hintTextString: "${Statics.getLabel('otherUpasanaSthal')}"),
                    const SizedBox(height: 10),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "प्रकार",
                      hintText: "${Statics.getLabel('SelectPrakar')}",
                      onItemSelected: (id, value, isOther) {
                        selectedUpasnaSthalTypeName = value;
                        selectedUpasnaSthalTypeId = id;
                      },
                      width: 250,
                      selectedValue: selectedUpasnaSthalType,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedUpasnaSthalType = newValue;
                        });
                      },
                      editId: editUpasnaSthalTypeId,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: upasnaSthalCountController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "${Statics.getLabel('count')}",
                        labelText: "${Statics.getLabel('count')}",
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // Trimmed inputs
                  final upasnaCount = upasnaSthalCountController.text.trim();
                  final anyaName = anyaUpasnaSthalNameController.text.trim();

                  // Validation block
                  if (selectedUpasnaSthal == null) {
                    Statics.showToast("${Statics.getLabel('upasanaSthalMandetory')}");
                  } else if (selectedUpasnaSthal?.isOther == 1 && anyaName.isEmpty) {
                    Statics.showToast("${Statics.getLabel('anyaInfoMandetory')}");
                  } else if (selectedUpasnaSthalTypeId == null || selectedUpasnaSthalTypeId.toString().trim().isEmpty) {
                    Statics.showToast("${Statics.getLabel('PrakarSelectMandetory')}");
                  } else if (upasnaCount.isEmpty) {
                    Statics.showToast("${Statics.getLabel('sankhyaFillMandetory')}");
                  } else {
                    // All validations passed, proceed
                    Vastisarupaasana newData = Vastisarupaasana(
                      upaasanasthalaid: selectedUpasnaSthalId,
                      selectedDropdownValueName: selectedUpasnaSthalName,
                      prakarid: selectedUpasnaSthalTypeId,
                      selectedDropdownValueName1: selectedUpasnaSthalTypeName,
                      sankhya: upasnaCount,
                      isactive: isActiveUpasanaSthal,
                      otherupaasanasthala: anyaName,
                      vastiid: int.parse(selctedLevelId!),
                      pkid: upasnaSthalPkid,
                    );

                    if (editIndex != null) {
                      upasnaSthalDataList[editIndex] = newData;
                    } else {
                      upasnaSthalDataList.add(newData);
                    }

                    clearUpasnaSthalFields();
                    onDataChanged?.call();
                    Navigator.of(ctx).pop();
                  }
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearUpasnaSthalFields() {
    selectedUpasnaSthalId = null;
    selectedUpasnaSthalName = null;
    selectedUpasnaSthal = null;
    editUpasnaSthalId = null;

    selectedUpasnaSthalTypeId = null;
    selectedUpasnaSthalTypeName = null;
    selectedUpasnaSthalType = null;
    editUpasnaSthalTypeId = null;

    upasnaSthalCountController.clear();
    anyaUpasnaSthalNameController.clear();
  }

  //=================================================== 9. SAJJAN SHAKRTI FORM ====================================================================================
  List<Vastisarsajjanshakti> sajjanShaktiDataList = [];
  int? selectedsajjanShaktiRowIndex;
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

  int? sajjanShaktiVisheshId;
  String? sajjanShaktiVisheshName;
  int? sajjanShaktiVisheshEditId;
  Masterdata? sajjanShaktiVisheshEditDataId;

  int? isActiveSajjanShakti = 1;
  int? pkidSajjanShakti = 0;

  int? isFemale = 0;

  TextEditingController sajjanShaktiNameController = TextEditingController();
  TextEditingController sajjanShaktiAddressController = TextEditingController();
  TextEditingController sajjanShaktiPhoneController = TextEditingController();
  TextEditingController sajjanShaktiContactPersonNameController = TextEditingController();
  TextEditingController sajjanShaktiContactPersonDoorbhashController = TextEditingController();
  TextEditingController sajjanShaktiSansthecheNaavController = TextEditingController();
  TextEditingController sajjanShaktiSansthKuthalyaPadavarController = TextEditingController();
  TextEditingController sajjanShaktiAnyaShreniNameController = TextEditingController();
  TextEditingController sajjanShaktiAnyaVisheshNameController = TextEditingController();

  void showSajjanShaktiPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = sajjanShaktiDataList[editIndex];
      sajjanShaktiNameController.text = data.name ?? '';
      sajjanShaktiAddressController.text = data.address ?? '';
      sajjanShaktiPhoneController.text = data.doorabhaash ?? '';
      sajjanShaktiShreniName = data.selectedDropdownValueName;
      sajjanShaktiShreniId = data.shreneeid;
      sajjanShaktiShreniEditId = data.shreneeid;
      sajjanShaktiSamparkStithiName = data.selectedDropdownValueName1;
      sajjanShaktiSamparkStithiId = data.samparksthitiid;
      sajjanShaktiSamparkStithiEditId = data.samparksthitiid;
      sajjanShaktiPrabhavKeshtraName = data.selectedDropdownValueName3;
      sajjanShaktiPrabhavKeshtraId = data.prabhaavkshetrid;
      sajjanShaktiPrabhavKeshtraEditId = data.prabhaavkshetrid;
      sajjanShaktiVisheshName = data.selectedDropdownValueName2;
      sajjanShaktiVisheshId = data.visheshId;
      sajjanShaktiVisheshEditId = data.visheshId;
      sajjanShaktiContactPersonNameController.text = data.samparkasutranava ?? '';
      sajjanShaktiContactPersonDoorbhashController.text = data.samparkasutraMobileNumber ?? '';
      sajjanShaktiSansthecheNaavController.text = data.sanstheCheNaav ?? '';
      sajjanShaktiSansthKuthalyaPadavarController.text = data.sansthechaKuthalaPadavar ?? '';
      sajjanShaktiAnyaShreniNameController.text = data.otherShreniName ?? '';
      sajjanShaktiAnyaVisheshNameController.text = data.otherVisheshName ?? '';
      isActiveSajjanShakti = data.isactive;
      isFemale = data.isfemale;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('sajjanShaktiInfo')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  clearSajjanShaktiFields();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textControllerField2(
                      name: "${Statics.getLabel('Name')}",
                      controller: sajjanShaktiNameController,
                    ),
                    textControllerField2(name: "${Statics.getLabel('Address')}", controller: sajjanShaktiAddressController),
                    textControllerField2(
                      name: "${Statics.getLabel('doorBhash')}",
                      controller: sajjanShaktiPhoneController,
                      keyboardType: TextInputType.number,
                      maxInput: 10,
                    ),
                    //
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
                    SizedBox(height: 10),
                    //
                    vastisarvekshanDropdown2(
                      question: "${Statics.getLabel('Category')}",
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति श्रेणी",
                      hintText: "${Statics.getLabel('Category')}",
                      onItemSelected: (id, value, isOther) {
                        sajjanShaktiShreniName = value;
                        sajjanShaktiShreniId = id;
                      },
                      width: 250,
                      selectedValue: sajjanShaktiShreniEditDataId,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          sajjanShaktiShreniEditDataId = newValue;
                        });
                      },
                      editId: sajjanShaktiShreniEditId,
                    ),
                    if (sajjanShaktiShreniEditDataId?.isOther == 1) const SizedBox(height: 5),
                    if (sajjanShaktiShreniEditDataId?.isOther == 1) textControllerField2(name: "${Statics.getLabel('OtherCategory')}", controller: sajjanShaktiAnyaShreniNameController),
                    const SizedBox(height: 5),
                    textControllerField2(name: "${Statics.getLabel('OrganizationName')}", controller: sajjanShaktiSansthecheNaavController),
                    const SizedBox(height: 5),
                    textControllerField2(name: "${Statics.getLabel('sansthetKuthalaPadavar')}", controller: sajjanShaktiSansthKuthalyaPadavarController),
                    const SizedBox(height: 5),
                    vastisarvekshanDropdown2(
                      question: "${Statics.getLabel('samparkStithi')}",
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति संपर्क स्थिति",
                      hintText: "${Statics.getLabel('samparkStithi')}",
                      onItemSelected: (id, value, isOther) {
                        sajjanShaktiSamparkStithiName = value;
                        sajjanShaktiSamparkStithiId = id;
                      },
                      width: 250,
                      selectedValue: sajjanShaktiSamparkStithiEditDataId,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          sajjanShaktiSamparkStithiEditDataId = newValue;
                        });
                      },
                      editId: sajjanShaktiSamparkStithiEditId,
                    ),
                    const SizedBox(height: 5),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति विशेष",
                      hintText: "${Statics.getLabel('special')}",
                      question: "${Statics.getLabel('special')}",
                      onItemSelected: (id, value, isOther) {
                        sajjanShaktiVisheshName = value;
                        sajjanShaktiVisheshId = id;
                      },
                      width: 250,
                      selectedValue: sajjanShaktiVisheshEditDataId,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          sajjanShaktiVisheshEditDataId = newValue;
                        });
                      },
                      editId: sajjanShaktiVisheshEditId,
                    ),
                    if (sajjanShaktiVisheshEditDataId?.isOther == 1) const SizedBox(height: 5),
                    if (sajjanShaktiVisheshEditDataId?.isOther == 1) textControllerField2(name: "${Statics.getLabel('otherSpecial')}", controller: sajjanShaktiAnyaVisheshNameController),
                    const SizedBox(height: 5),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति प्रभाव क्षेत्र",
                      hintText: "${Statics.getLabel('prabhavKshetra')}",
                      question: "${Statics.getLabel('prabhavKshetra')}",
                      onItemSelected: (id, value, isOther) {
                        sajjanShaktiPrabhavKeshtraName = value;
                        sajjanShaktiPrabhavKeshtraId = id;
                      },
                      width: 250,
                      selectedValue: sajjanShaktiPrabhavKeshtraEditDataId,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          sajjanShaktiPrabhavKeshtraEditDataId = newValue;
                        });
                      },
                      editId: sajjanShaktiPrabhavKeshtraEditId,
                    ),
                    const SizedBox(height: 5),
                    textControllerField2(name: "${Statics.getLabel('samparkSootraNaav')}", controller: sajjanShaktiContactPersonNameController),
                    const SizedBox(height: 5),
                    textControllerField2(
                      name: "${Statics.getLabel('samparakSootraDoorbhash')}",
                      controller: sajjanShaktiContactPersonDoorbhashController,
                      keyboardType: TextInputType.number,
                      maxInput: 10,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                // onPressed: () {
                //   if ((sajjanShaktiShreniEditDataId?.isOther == 1 &&
                //           sajjanShaktiAnyaShreniNameController.text == "") ||
                //       (sajjanShaktiVisheshEditDataId?.isOther == 1 &&
                //           sajjanShaktiAnyaVisheshNameController.text == "")) {
                //     Statics.showToast(
                //         "${Statics.getLabel('otherInfoValidation')}");
                //   } else {
                //     Vastisarsajjanshakti newData = Vastisarsajjanshakti(
                //         name: sajjanShaktiNameController.text.trim(),
                //         address: sajjanShaktiAddressController.text.trim(),
                //         doorabhaash: sajjanShaktiPhoneController.text.trim(),
                //         shreneeid: sajjanShaktiShreniId,
                //         selectedDropdownValueName: sajjanShaktiShreniName,
                //         otherShreniName:
                //             sajjanShaktiAnyaShreniNameController.text.trim(),
                //         sanstheCheNaav:
                //             sajjanShaktiSansthecheNaavController.text.trim(),
                //         sansthechaKuthalaPadavar:
                //             sajjanShaktiSansthKuthalyaPadavarController.text
                //                 .trim(),
                //         samparksthitiid: sajjanShaktiSamparkStithiId,
                //         selectedDropdownValueName1:
                //             sajjanShaktiSamparkStithiName,
                //         visheshId: sajjanShaktiVisheshId,
                //         selectedDropdownValueName2: sajjanShaktiVisheshName,
                //         otherVisheshName:
                //             sajjanShaktiAnyaVisheshNameController.text.trim(),
                //         prabhaavkshetrid: sajjanShaktiPrabhavKeshtraId,
                //         selectedDropdownValueName3:
                //             sajjanShaktiPrabhavKeshtraName,
                //         samparkasutranava:
                //             sajjanShaktiContactPersonNameController.text.trim(),
                //         samparkasutraMobileNumber:
                //             sajjanShaktiContactPersonDoorbhashController.text
                //                 .trim(),
                //         isactive: isActiveSajjanShakti,
                //         vastiid: int.parse(selctedLevelId!),
                //         pkid: pkidSajjanShakti);
                //     if (editIndex != null) {
                //       sajjanShaktiDataList[editIndex] = newData;
                //     } else {
                //       sajjanShaktiDataList.add(newData);
                //     }
                //     clearSajjanShaktiFields();
                //     if (onDataChanged != null) {
                //       onDataChanged();
                //     }
                //     Navigator.of(ctx).pop();
                //   }
                // },
                onPressed: () {
                  if ((sajjanShaktiShreniEditDataId?.isOther == 1 && sajjanShaktiAnyaShreniNameController.text == "") ||
                      (sajjanShaktiVisheshEditDataId?.isOther == 1 && sajjanShaktiAnyaVisheshNameController.text == "")) {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                  } else if (sajjanShaktiPhoneController.text.length != 10) {
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                  } else {
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
                      isactive: isActiveSajjanShakti,
                      vastiid: int.parse(selctedLevelId!),
                      pkid: pkidSajjanShakti,
                      isfemale: isFemale,
                    );
                    if (editIndex != null) {
                      sajjanShaktiDataList[editIndex] = newData;
                    } else {
                      sajjanShaktiDataList.add(newData);
                    }
                    clearSajjanShaktiFields();
                    if (onDataChanged != null) {
                      onDataChanged();
                    }
                    Navigator.of(ctx).pop();
                  }
                },

                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearSajjanShaktiFields() {
    sajjanShaktiNameController.clear();
    sajjanShaktiAddressController.clear();
    sajjanShaktiPhoneController.clear();
    sajjanShaktiContactPersonNameController.clear();
    sajjanShaktiContactPersonDoorbhashController.clear();
    sajjanShaktiSansthecheNaavController.clear();
    sajjanShaktiSansthKuthalyaPadavarController.clear();
    sajjanShaktiAnyaShreniNameController.clear();
    sajjanShaktiAnyaVisheshNameController.clear();
    sajjanShaktiShreniId = null;
    sajjanShaktiShreniName = null;
    sajjanShaktiShreniEditId = null;
    sajjanShaktiShreniEditDataId = null;
    sajjanShaktiSamparkStithiId = null;
    sajjanShaktiSamparkStithiName = null;
    sajjanShaktiSamparkStithiEditId = null;
    sajjanShaktiSamparkStithiEditDataId = null;
    sajjanShaktiVisheshId = null;
    sajjanShaktiVisheshName = null;
    sajjanShaktiVisheshEditId = null;
    sajjanShaktiVisheshEditDataId = null;
    sajjanShaktiPrabhavKeshtraId = null;
    sajjanShaktiPrabhavKeshtraName = null;
    sajjanShaktiPrabhavKeshtraEditId = null;
    sajjanShaktiPrabhavKeshtraEditDataId = null;
  }

  //=================================================== 9. AnyaPrabhavi Lok FORM ====================================================================================
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
  final TextEditingController anyaPrabhaviLokNaavController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAddressController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAnyaVisheshMahitiController = TextEditingController();
  final TextEditingController anyaPrabhaviLokSamparkSutraNaavController = TextEditingController();
  final TextEditingController anyaPrabhaviLokSamparkSutraDoorbhashController = TextEditingController();
  final TextEditingController anyaPrabhaviLokMobileNoController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAnyaUppshreniController = TextEditingController();
  final TextEditingController anyaPrabhaviLokAnyaUppshreni1Controller = TextEditingController();

  void showAnyaPrabhaviPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    log("showAnyaPrabhaviPopup is opened >>>>>>>>>>>>>> ");
    if (editIndex != null) {
      var data = anyaPrabhaviLokDataList[editIndex];
      anyaPrabhaviLokNaavController.text = data.name ?? "";
      anyaPrabhaviLokAddressController.text = data.address ?? "";
      anyaPrabhaviLokMobileNoController.text = data.doorabhaash ?? "";
      anyaPrabhaviLokShreniId = data.shreneeid;
      anyaPrabhaviLokShreniIdEdit = data.shreneeid;
      anyaPrabhaviLokShreniName = data.selectedDropdownValueName;
      anyaPrabhaviLokUpShreniId = data.upshreneeid;
      anyaPrabhaviLokUpShreniIdEdit = data.upshreneeid;
      anyaPrabhaviLokUpShreniName = data.selectedDropdownValueName1;
      anyaPrabhaviLokAnyaUppshreniController.text = data.otherupshrenee ?? "";
      anyaPrabhaviLokUpShreni1Id = data.upshreneeid2;
      anyaPrabhaviLokUpShreni1IdEdit = data.upshreneeid2;
      anyaPrabhaviLokUpShreni1Name = data.selectedDropdownValueName2;
      anyaPrabhaviLokAnyaUppshreni1Controller.text = data.otherupshrenee2 ?? "";
      anyaPrabhaviLokVisheshId = data.visheshid;
      selectedAnyaPrabhaviLokVisheshIDEdit = data.visheshid;
      anyaPrabhaviLokVisheshName = data.selectedDropdownValueName3;
      anyaPrabhaviLokPrabhavKshetraId = data.prabhaavkshetrid;
      selectedAnyaPrabhaviLokPrabhavKshetraIDEdit = data.prabhaavkshetrid;
      anyaPrabhaviLokPrabhavKshetraName = data.selectedDropdownValueName4;
      anyaPrabhaviLokAnyaVisheshMahitiController.text = data.othervishesh ?? "";
      anyaPrabhaviLokSamparkStithiId = data.samparksthitiid;
      selectedAnyaPrabhaviLokSamparkStithiIDEdit = data.samparksthitiid;
      anyaPrabhaviLokSamparkStithiName = data.selectedDropdownValueName5;
      anyaPrabhaviLokSamparkSutraNaavController.text = data.samparkasutranav ?? "";
      anyaPrabhaviLokSamparkSutraDoorbhashController.text = data.samparkaSutraDoorbhash ?? "";
      pkidAnyaPrabhaviLok = data.pkid;
      isFemale = data.isfemale;
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('anyaPrabhaviLok')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  clearAnyaPrabhaviLokFields();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textControllerField2(name: "${Statics.getLabel('Name')}", controller: anyaPrabhaviLokNaavController, height: 50),
                    textControllerField2(name: "${Statics.getLabel('Address')}", controller: anyaPrabhaviLokAddressController, height: 50),
                    textControllerField2(
                      name: "${Statics.getLabel('doorBhash')}",
                      controller: anyaPrabhaviLokMobileNoController,
                      height: 50,
                      keyboardType: TextInputType.number,
                      maxInput: 10,
                    ),
                    SizedBox(height: 5),
                    //
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
                    SizedBox(height: 10),
                    //
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${Statics.getLabel('Category')}/${Statics.getLabel('upshreni')}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 5),
                    vastisarvekshanDropDownDataModel != null
                        ? vastisarvekshanDropdown3(
                            filterTypeName: "श्रेणी",
                            hintText: "${Statics.getLabel('otherUpshreni')}",
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
                            },
                            onDependentValueSelected: (id, name, value) {
                              anyaPrabhaviLokUpShreniId = id;
                              anyaPrabhaviLokUpShreniName = name;
                              setState(() {
                                selectedUpShreni = value;
                                selectedUpShreni2 = null;
                              });
                            },
                            onThirdLevelValueSelected: (id, name, value) {
                              anyaPrabhaviLokUpShreni1Id = id;
                              anyaPrabhaviLokUpShreni1Name = name;
                              setState(() {
                                selectedUpShreni2 = value;
                              });
                            },
                            viewName: true,
                          )
                        : Container(),
                    if (selectedUpShreni?.isOther == 1)
                      SizedBox(
                        height: 10,
                      ),
                    if (selectedUpShreni?.isOther == 1) textControllerField2(name: "${Statics.getLabel('otherUpshreni')}", controller: anyaPrabhaviLokAnyaUppshreniController),
                    if (selectedUpShreni2?.isOther == 1)
                      SizedBox(
                        height: 10,
                      ),
                    if (selectedUpShreni2?.isOther == 1) textControllerField2(name: "${Statics.getLabel('otherUpshreni2')}", controller: anyaPrabhaviLokAnyaUppshreni1Controller),
                    SizedBox(
                      height: 10,
                    ),
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
                    textControllerField2(name: "${Statics.getLabel('anyaVisheshMahiti')}", controller: anyaPrabhaviLokAnyaVisheshMahitiController, height: 50),
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
                    textControllerField2(name: "${Statics.getLabel('samparkSootraNaav')}", controller: anyaPrabhaviLokSamparkSutraNaavController, height: 50),
                    textControllerField2(
                      name: "${Statics.getLabel('samparakSootraDoorbhash')}",
                      controller: anyaPrabhaviLokSamparkSutraDoorbhashController,
                      keyboardType: TextInputType.number,
                      maxInput: 10,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if ((selectedUpShreni?.isOther == 1 && anyaPrabhaviLokAnyaUppshreniController.text == "") ||
                      (selectedUpShreni2?.isOther == 1 && anyaPrabhaviLokAnyaUppshreni1Controller.text == "")) {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                  } else if (anyaPrabhaviLokMobileNoController.text.length != 10) {
                    log("anyaPrabhaviLokMobileNoController.text.length  -->> ${anyaPrabhaviLokMobileNoController.text.length}");
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                  } else if (anyaPrabhaviLokSamparkSutraDoorbhashController.text.length != 10) {
                    log("anyaPrabhaviLokSamparkSutraDoorbhashController.text.length  -->> ${anyaPrabhaviLokSamparkSutraDoorbhashController.text.length}");
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                  } else {
                    VastisarAnyaprabhavilokam data = VastisarAnyaprabhavilokam(
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
                      pkid: pkidAnyaPrabhaviLok,
                      anyavisesamahiti: anyaPrabhaviLokAnyaVisheshMahitiController.text,
                      otherupshrenee: anyaPrabhaviLokAnyaUppshreniController.text,
                      otherupshrenee2: anyaPrabhaviLokAnyaUppshreni1Controller.text,
                      isactive: isActiveAnyaPrabhavilok,
                      vastiid: int.parse(selctedLevelId!),
                      isfemale: isFemale,
                    );
                    if (editIndex != null) {
                      anyaPrabhaviLokDataList[editIndex] = data;
                    } else {
                      anyaPrabhaviLokDataList.add(data);
                    }
                    clearAnyaPrabhaviLokFields();
                    if (onDataChanged != null) {
                      onDataChanged();
                    }
                    Navigator.of(ctx).pop();
                  }
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearAnyaPrabhaviLokFields() {
    anyaPrabhaviLokNaavController.clear();
    anyaPrabhaviLokAddressController.clear();
    anyaPrabhaviLokMobileNoController.clear();
    anyaPrabhaviLokAnyaVisheshMahitiController.clear();
    anyaPrabhaviLokSamparkSutraNaavController.clear();
    anyaPrabhaviLokSamparkSutraDoorbhashController.clear();
    anyaPrabhaviLokAnyaUppshreniController.clear();
    anyaPrabhaviLokAnyaVisheshMahitiController.clear();
    anyaPrabhaviLokAnyaUppshreni1Controller.clear();
    anyaPrabhaviLokShreniId = null;
    anyaPrabhaviLokShreniName = null;
    anyaPrabhaviLokUpShreniId = null;
    anyaPrabhaviLokUpShreniName = null;
    anyaPrabhaviLokUpShreni1Id = null;
    anyaPrabhaviLokUpShreni1Name = null;
    anyaPrabhaviLokVisheshId = null;
    anyaPrabhaviLokVisheshName = null;
    selectedAnyaPrabhaviLokVishesh = null;
    anyaPrabhaviLokPrabhavKshetraId = null;
    anyaPrabhaviLokPrabhavKshetraName = null;
    selectedAnyaPrabhaviLokPrabhavKshetra = null;
    anyaPrabhaviLokSamparkStithiId = null;
    anyaPrabhaviLokSamparkStithiName = null;
    selectedAnyaPrabhaviLokSamparkStithi = null;
    anyaPrabhaviLokVisheshId = null;
    anyaPrabhaviLokVisheshName = null;
    selectedAnyaPrabhaviLokVishesh = null;
    anyaPrabhaviLokPrabhavKshetraId = null;
    anyaPrabhaviLokPrabhavKshetraName = null;
    selectedAnyaPrabhaviLokPrabhavKshetra = null;
    selectedAnyaPrabhaviLokVisheshIDEdit = null;
    selectedAnyaPrabhaviLokPrabhavKshetraIDEdit = null;
    selectedAnyaPrabhaviLokSamparkStithiIDEdit = null;
    isFemale = null;
    resetDropdowns();
  }

  //=================================================== 10. VASTIT SAJAR HONARE SAN Lok FORM ====================================================================================
  List<VastisarVastitamahatvacesana> vastitSajarHonareSanDataList = [];
  int? selectedSanIdIndex;
  int? selectedSanId;
  int? selectedSanIdEdit;
  String? selectedSanName;
  Masterdata? selectedMasterSanName;
  int? isActiveSajareHonareSan = 1;
  int? pkidSajareHonareSan = 0;
  final TextEditingController vastitSajarHonareSanAyojakSansthaNameController = TextEditingController();
  final TextEditingController vastitSajarHonareSanAyojakNameController = TextEditingController();
  final TextEditingController vastitSajarHonareSanAyojakSamparkController = TextEditingController();
  final TextEditingController vastitSajarHonareAnyaSanController = TextEditingController();

  void showVastitSajarHonareSanPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = vastitSajarHonareSanDataList[editIndex];
      selectedSanId = data.id;
      selectedSanIdEdit = data.id;
      selectedSanName = data.selectedDropdownValueName;
      vastitSajarHonareSanAyojakSansthaNameController.text = data.ayojakasansthacinave ?? "";
      vastitSajarHonareSanAyojakNameController.text = data.ayojakancinave ?? "";
      vastitSajarHonareSanAyojakSamparkController.text = data.aayojaksamparksootr ?? "";
      // selectedMasterSanName = data['sanObj'];
      vastitSajarHonareAnyaSanController.text = data.otherSajareSan ?? "";
      pkidSajareHonareSan = data.pkid;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('sajareHonareSan')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "वस्तीतसाजरहोणारेमहत्वाचेसण",
                      hintText: "${Statics.getLabel('selectFestival')}",
                      onItemSelected: (id, value, isOther) {
                        selectedSanId = id;
                        selectedSanName = value;
                        print("selectedMasterSanName ${json.encode(selectedMasterSanName)}");
                      },
                      width: 250,
                      selectedValue: selectedMasterSanName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasterSanName = newValue;
                        });
                        setState(() {});
                      },
                      editId: selectedSanIdEdit,
                    ),
                    const SizedBox(height: 10),
                    if (selectedMasterSanName?.isOther == 1) textControllerField("${Statics.getLabel('otherFestivals')}", vastitSajarHonareAnyaSanController, context, height: 50),
                    textControllerField("${Statics.getLabel('aayojakSansthachiNave')}", vastitSajarHonareSanAyojakSansthaNameController, context, height: 50),
                    textControllerField("${Statics.getLabel('aayojakNaav')}", vastitSajarHonareSanAyojakNameController, context, height: 80),
                    textControllerField2(
                        name: "${Statics.getLabel('aayojakSamparkSootra')}", controller: vastitSajarHonareSanAyojakSamparkController, keyboardType: TextInputType.number, maxInput: 10, height: 50),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
          actions: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                // onPressed: () {
                //   if ((selectedMasterSanName?.isOther == 1 &&
                //       vastitSajarHonareAnyaSanController.text == "")) {
                //     Statics.showToast(
                //         "${Statics.getLabel('otherInfoValidation')}");
                //   } else {
                //     VastisarVastitamahatvacesana data =
                //         VastisarVastitamahatvacesana(
                //       id: selectedSanId,
                //       selectedDropdownValueName: selectedSanName,
                //       ayojakasansthacinave:
                //           vastitSajarHonareSanAyojakSansthaNameController.text,
                //       ayojakancinave:
                //           vastitSajarHonareSanAyojakNameController.text,
                //       aayojaksamparksootr:
                //           vastitSajarHonareSanAyojakSamparkController.text,
                //       // selectedMasterSanName = data['sanObj'];
                //       otherSajareSan: vastitSajarHonareAnyaSanController.text,
                //       isactive: isActiveSajareHonareSan,
                //       pkid: pkidSajareHonareSan ?? 0,
                //       vastiid: int.parse(selctedLevelId!),
                //     );
                //     if (editIndex != null) {
                //       vastitSajarHonareSanDataList[editIndex] = data;
                //     } else {
                //       vastitSajarHonareSanDataList.add(data);
                //     }
                //     clearvastitSajarHonareSanFields();
                //     if (onDataChanged != null) {
                //       onDataChanged();
                //     }
                //     Navigator.of(ctx).pop();
                //   }
                // },
                onPressed: () {
                  if ((selectedMasterSanName?.isOther == 1 && vastitSajarHonareAnyaSanController.text == "")) {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                  } else if (vastitSajarHonareSanAyojakSamparkController.text.length != 10) {
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                  } else {
                    VastisarVastitamahatvacesana data = VastisarVastitamahatvacesana(
                      id: selectedSanId,
                      selectedDropdownValueName: selectedSanName,
                      ayojakasansthacinave: vastitSajarHonareSanAyojakSansthaNameController.text,
                      ayojakancinave: vastitSajarHonareSanAyojakNameController.text,
                      aayojaksamparksootr: vastitSajarHonareSanAyojakSamparkController.text,
                      otherSajareSan: vastitSajarHonareAnyaSanController.text,
                      isactive: isActiveSajareHonareSan,
                      pkid: pkidSajareHonareSan ?? 0,
                      vastiid: int.parse(selctedLevelId!),
                    );
                    if (editIndex != null) {
                      vastitSajarHonareSanDataList[editIndex] = data;
                    } else {
                      vastitSajarHonareSanDataList.add(data);
                    }
                    clearvastitSajarHonareSanFields();
                    if (onDataChanged != null) {
                      onDataChanged();
                    }
                    Navigator.of(ctx).pop();
                  }
                },

                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearvastitSajarHonareSanFields() {
    selectedSanId = null;
    selectedSanName = null;
    selectedMasterSanName = null;
    vastitSajarHonareSanAyojakSansthaNameController.clear();
    vastitSajarHonareSanAyojakNameController.clear();
    vastitSajarHonareSanAyojakSamparkController.clear();
    vastitSajarHonareAnyaSanController.clear();
  }

  //=================================================== 10. VASTIT SAJAR HONARE SAMAJIK KARYAKRAM FORM ====================================================================================
  List<VastisarVastitasajaraSamajikkaryakram> vastitSajarHonareSamajikKaryakramDataList = [];
  int? selectedSamajikKaryakramIdIndex;
  int? selectedSamajikKaryakramId;
  int? selectedSamajikKaryakramIdEdit;
  String? selectedSamajikKaryakramName;
  Masterdata? selectedMasterSamajikKaryakramName;
  int? isActiveSamajikKaryakram = 1;
  int? pkidSamajikKaryakram = 0;
  final TextEditingController vastitSajarHonareSamajikKaryakramAyojakSansthaNameController = TextEditingController();
  final TextEditingController vastitSajarHonareSamajikKaryakramAyojakNameController = TextEditingController();
  final TextEditingController vastitSajarHonareSamajikKaryakramAyojakSamparkController = TextEditingController();
  final TextEditingController vastitSajarHonareSamajikKaryakramAnya1Controller = TextEditingController();

  void showVastitSajarHonareSamajikKaryakramPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = vastitSajarHonareSamajikKaryakramDataList[editIndex];
      pkidSamajikKaryakram = data.pkid;
      selectedSamajikKaryakramId = data.id;
      selectedSamajikKaryakramName = data.selectedDropdownValueName;
      vastitSajarHonareSamajikKaryakramAyojakSansthaNameController.text = data.ayojakasansthacinave ?? "";
      vastitSajarHonareSamajikKaryakramAyojakNameController.text = data.ayojakancinave ?? "";
      vastitSajarHonareSamajikKaryakramAyojakSamparkController.text = data.aayojaksamparksootr ?? "";
      vastitSajarHonareSamajikKaryakramAnya1Controller.text = data.otherKaryakram ?? "";
      // selectedMasterSamajikKaryakramName = data['samajikKaryakramObj'];
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('sajareHonareKaryakram')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "वस्तीतसाजरहोणारेमहत्वाचेसामाजिककार्यक्रम",
                      hintText: "${Statics.getLabel('SelectKaryakram')}",
                      onItemSelected: (id, value, isOther) {
                        selectedSamajikKaryakramId = id;
                        selectedSamajikKaryakramName = value;
                      },
                      width: 250,
                      selectedValue: selectedMasterSamajikKaryakramName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasterSamajikKaryakramName = newValue;
                        });
                      },
                      editId: selectedSamajikKaryakramIdEdit,
                    ),
                    const SizedBox(height: 10),
                    if (selectedMasterSamajikKaryakramName?.isOther == 1) textControllerField("${Statics.getLabel('other')}", vastitSajarHonareSamajikKaryakramAnya1Controller, context, height: 50),
                    textControllerField("${Statics.getLabel('aayojakSansthachiNave')}", vastitSajarHonareSamajikKaryakramAyojakSansthaNameController, context, height: 50),
                    textControllerField("${Statics.getLabel('aayojakNaav')}", vastitSajarHonareSamajikKaryakramAyojakNameController, context, height: 80),
                    textControllerField2(
                        name: "${Statics.getLabel('aayojakSamparkSootra')}",
                        controller: vastitSajarHonareSamajikKaryakramAyojakSamparkController,
                        height: 50,
                        keyboardType: TextInputType.number,
                        maxInput: 10),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
          actions: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                // onPressed: () {
                //   if ((selectedMasterSamajikKaryakramName?.isOther == 1 &&
                //       vastitSajarHonareSamajikKaryakramAnya1Controller.text ==
                //           "")) {
                //     Statics.showToast(
                //         "${Statics.getLabel('otherInfoValidation')}");
                //   } else {
                //     VastisarVastitasajaraSamajikkaryakram data =
                //         VastisarVastitasajaraSamajikkaryakram(
                //             id: selectedSamajikKaryakramId,
                //             vastiid: int.parse(selctedLevelId!),
                //             pkid: pkidSamajikKaryakram,
                //             isactive: isActiveSamajikKaryakram,
                //             selectedDropdownValueName:
                //                 selectedSamajikKaryakramName,
                //             otherKaryakram:
                //                 vastitSajarHonareSamajikKaryakramAnya1Controller
                //                     .text,
                //             ayojakasansthacinave:
                //                 vastitSajarHonareSamajikKaryakramAyojakSansthaNameController
                //                     .text,
                //             ayojakancinave:
                //                 vastitSajarHonareSamajikKaryakramAyojakNameController
                //                     .text,
                //             aayojaksamparksootr:
                //                 vastitSajarHonareSamajikKaryakramAyojakSamparkController
                //                     .text);
                //     if (editIndex != null) {
                //       vastitSajarHonareSamajikKaryakramDataList[editIndex] =
                //           data;
                //     } else {
                //       vastitSajarHonareSamajikKaryakramDataList.add(data);
                //     }
                //     clearvastitSajarHonareSamajikKaryakramFields();
                //     if (onDataChanged != null) {
                //       onDataChanged();
                //     }
                //     Navigator.of(ctx).pop();
                //   }
                // },
                onPressed: () {
                  if ((selectedMasterSamajikKaryakramName?.isOther == 1 && vastitSajarHonareSamajikKaryakramAnya1Controller.text == "")) {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                  } else if (vastitSajarHonareSamajikKaryakramAyojakSamparkController.text.length != 10) {
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                  } else {
                    VastisarVastitasajaraSamajikkaryakram data = VastisarVastitasajaraSamajikkaryakram(
                      id: selectedSamajikKaryakramId,
                      vastiid: int.parse(selctedLevelId!),
                      pkid: pkidSamajikKaryakram,
                      isactive: isActiveSamajikKaryakram,
                      selectedDropdownValueName: selectedSamajikKaryakramName,
                      otherKaryakram: vastitSajarHonareSamajikKaryakramAnya1Controller.text,
                      ayojakasansthacinave: vastitSajarHonareSamajikKaryakramAyojakSansthaNameController.text,
                      ayojakancinave: vastitSajarHonareSamajikKaryakramAyojakNameController.text,
                      aayojaksamparksootr: vastitSajarHonareSamajikKaryakramAyojakSamparkController.text,
                    );
                    if (editIndex != null) {
                      vastitSajarHonareSamajikKaryakramDataList[editIndex] = data;
                    } else {
                      vastitSajarHonareSamajikKaryakramDataList.add(data);
                    }
                    clearvastitSajarHonareSamajikKaryakramFields();
                    if (onDataChanged != null) {
                      onDataChanged();
                    }
                    Navigator.of(ctx).pop();
                  }
                },

                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearvastitSajarHonareSamajikKaryakramFields() {
    selectedSamajikKaryakramId = null;
    selectedSamajikKaryakramName = null;
    vastitSajarHonareSamajikKaryakramAyojakSansthaNameController.clear();
    vastitSajarHonareSamajikKaryakramAyojakNameController.clear();
    vastitSajarHonareSamajikKaryakramAyojakSamparkController.clear();
    vastitSajarHonareSamajikKaryakramAnya1Controller.clear();
  }

//========================   Other INFO FORM ===========================================
//========================   Other INFO FORM ===========================================
//========================   Other INFO FORM ===========================================
//========================   Other INFO FORM ===========================================
//========================   Other INFO FORM ===========================================
//========================   Other INFO FORM ===========================================

  Widget _buildStep2() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          if (isVastiSearch == true)
            if (step2completepercentage != null)
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    dynamicProgressBar(context: context, value: double.parse(step2completepercentage.toString()), detailListItems: step2pendingpoints!.split(',')),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        // Filter out empty or whitespace-only strings
                        final filteredDetails = step2pendingpoints!.split(',').where((item) => item.trim().isNotEmpty).toList();

                        print("Filtered step1pendingpoints!.split(','): $filteredDetails");

                        if (filteredDetails.isEmpty) {
                          Statics.showToast(Statics.getLabel('allInfoSubmit'));
                          return;
                        }

                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon and Title
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
                                        SizedBox(width: 8),
                                        Text(
                                          Statics.getLabel('remainingQuestion'),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 300,
                                      child: ListView.builder(
                                        itemCount: filteredDetails.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              "${index + 1}. ${filteredDetails[index]}",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text(Statics.getLabel('bandKara')),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.red.shade300,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "${Statics.getLabel('remainingQuestion')}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
//======================== VASTITIL BALOSAPANA KENDRA  =======================================================
          mainContainer(
            "${Statics.getLabel('BalopasanaKendra')}",
            Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      if (isVastiSearch) {
                        showVastitBalopasanaKendraPopup(
                          context,
                          onDataChanged: () {
                            setState(() {});
                          },
                        );
                      } else {
                        showPopupForVastiValidation(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 15),
                            SizedBox(width: 5),
                            Text(
                              "${Statics.getLabel('AddButton')}",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1.2,
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                          headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          columns: [
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('balopasanaOnly')}",
                            )),
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('Name')}",
                            )),
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('konasathi')}",
                            )),
                          ],
                          rows: vastitBalopasanaKendraDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                            int index = entry.key;
                            var data = entry.value;
                            bool isSelected = selectedVastitBalopasanaKendraIdIndex == index;
                            return DataRow(
                                selected: isSelected,
                                color: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (isSelected) return Colors.yellow.shade100;
                                    return null;
                                  },
                                ),
                                onSelectChanged: (bool? selected) {
                                  if (selected != null && selected) {
                                    setState(() {
                                      selectedVastitBalopasanaKendraIdIndex = index;
                                    });
                                  }
                                },
                                cells: [
                                  DataCell(Text(data.selectedDropdownValueName ?? '')),
                                  DataCell(Text(data.name ?? '')),
                                  DataCell(Text(data.konasathi ?? '')),
                                ]);
                          }).toList(),
                        ),
                      )),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedVastitBalopasanaKendraIdIndex != null) {
                            var selectedData = vastitBalopasanaKendraDataList[selectedVastitBalopasanaKendraIdIndex!];
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Colors.white,
                                  title: Center(
                                    child: Text(
                                      "${Statics.getLabel('BalopasanaKendra')}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('balopasanaOnly')}", selectedData.selectedDropdownValueName),
                                        _buildInfoRow("${Statics.getLabel('otherBalopasanaKendra')}", selectedData.otherBalopasanaShreniName),
                                        _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                        _buildInfoRow("${Statics.getLabel('konasathi')}", selectedData.konasathi),
                                      ],
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purpleAccent,
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showVastitBalopasanaKendraPopup(context, editIndex: selectedVastitBalopasanaKendraIdIndex, onDataChanged: () {
                            setState(() {});
                          });
                        },
                        child: Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.white,
                              title: Center(
                                child: Text(
                                  "${Statics.getLabel('pusthikarn')}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              content: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "${Statics.getLabel('deleteconfirmText')}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationNo')}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(
                                    "${Statics.getLabel('ConfirmationYes')}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (shouldDelete == true && selectedVastitBalopasanaKendraIdIndex != null) {
                            setState(() {
                              vastitBalopasanaKendraDataList[selectedVastitBalopasanaKendraIdIndex!].isactive = 0;
                              selectedVastitBalopasanaKendraIdIndex = null;
                            });
                          }
                        },
                        child: Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
//======================== VASTITIL BALOSAPANA KENDRA  =======================================================
          mainContainer(
              "${Statics.getLabel('MotheVyasaayiKendra')}",
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showMotheVyavsayikKendraPopup(context, onDataChanged: () {
                            setState(() {});
                          });
                        } else {
                          showPopupForVastiValidation(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              SizedBox(width: 5),
                              Text(
                                "${Statics.getLabel('AddButton')}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                            columns: [
                              DataColumn(
                                  label: Text(
                                "${Statics.getLabel('MotheVyasaayiKendra')}",
                              )),
                              DataColumn(
                                  label: Text(
                                "${Statics.getLabel('Name')}",
                              )),
                            ],
                            rows: motheVyasayikKendraDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                              int index = entry.key;
                              var data = entry.value;
                              bool isSelected = selectedMotheVyasayikKendraIdIndex == index;
                              return DataRow(
                                  selected: isSelected,
                                  color: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (isSelected) return Colors.yellow.shade100;
                                      return null;
                                    },
                                  ),
                                  onSelectChanged: (bool? selected) {
                                    if (selected != null && selected) {
                                      setState(() {
                                        selectedMotheVyasayikKendraIdIndex = index;
                                      });
                                    }
                                  },
                                  cells: [
                                    DataCell(Text(data.selectedDropdownValueName ?? '')),
                                    DataCell(Text(data.name ?? '')),
                                  ]);
                            }).toList(),
                          ),
                        )),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (selectedMotheVyasayikKendraIdIndex != null) {
                              var selectedData = motheVyasayikKendraDataList[selectedMotheVyasayikKendraIdIndex!];
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('MotheVyasaayiKendra')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                          SizedBox(height: 12),
                                          _buildInfoRow("${Statics.getLabel('MotheVyasaayiKendra')}", selectedData.selectedDropdownValueName),
                                          _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                        ],
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purpleAccent,
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            showMotheVyavsayikKendraPopup(context, editIndex: selectedMotheVyasayikKendraIdIndex, onDataChanged: () {
                              setState(() {});
                            });
                          },
                          child: Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.white,
                                title: Center(
                                  child: Text(
                                    "${Statics.getLabel('pusthikarn')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    "${Statics.getLabel('deleteconfirmText')}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text(
                                      "${Statics.getLabel('ConfirmationNo')}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text(
                                      "${Statics.getLabel('ConfirmationYes')}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (shouldDelete == true && selectedMotheVyasayikKendraIdIndex != null) {
                              setState(() {
                                motheVyasayikKendraDataList[selectedMotheVyasayikKendraIdIndex!].isactive = 0;
                                selectedMotheVyasayikKendraIdIndex = null;
                              });
                            }
                          },
                          child: Icon(Icons.delete, color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
//======================== NIRMANDHIN MOTHE PRAKALPA KENDRA  =======================================================
          mainContainer(
              "${Statics.getLabel('nirmanadhinMothePrakalpa')}",
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showNirmaandhinMothePopup(context, onDataChanged: () {
                            setState(() {});
                          });
                        } else {
                          showPopupForVastiValidation(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              SizedBox(width: 5),
                              Text(
                                "${Statics.getLabel('AddButton')}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                            columns: [
                              DataColumn(
                                  label: Text(
                                "${Statics.getLabel('Name')}",
                              )),
                              DataColumn(
                                  label: Text(
                                "${Statics.getLabel('prakalpaOnly')}",
                              )),
                            ],
                            rows: nirmandhinMothePrakalpaDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                              int index = entry.key;
                              var data = entry.value;
                              bool isSelected = selectednirmandhinMothePrakalpaIdIndex == index;
                              return DataRow(
                                  selected: isSelected,
                                  color: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (isSelected) return Colors.yellow.shade100;
                                      return null;
                                    },
                                  ),
                                  onSelectChanged: (bool? selected) {
                                    if (selected != null && selected) {
                                      setState(() {
                                        selectednirmandhinMothePrakalpaIdIndex = index;
                                      });
                                    }
                                  },
                                  cells: [
                                    DataCell(Text(data.name ?? '')),
                                    DataCell(Text(data.selectedDropdownValueName ?? '')),
                                  ]);
                            }).toList(),
                          ),
                        )),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (selectednirmandhinMothePrakalpaIdIndex != null) {
                              var selectedData = nirmandhinMothePrakalpaDataList[selectednirmandhinMothePrakalpaIdIndex!];
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('nirmanadhinMothePrakalpa')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                          SizedBox(height: 12),
                                          _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                          _buildInfoRow("${Statics.getLabel('prakalpaOnly')}", selectedData.selectedDropdownValueName),
                                        ],
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purpleAccent,
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            showNirmaandhinMothePopup(context, editIndex: selectednirmandhinMothePrakalpaIdIndex, onDataChanged: () {
                              setState(() {});
                            });
                          },
                          child: Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.white,
                                title: Center(
                                  child: Text(
                                    "${Statics.getLabel('pusthikarn')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    "${Statics.getLabel('deleteconfirmText')}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text(
                                      "${Statics.getLabel('ConfirmationNo')}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text(
                                      "${Statics.getLabel('ConfirmationYes')}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (shouldDelete == true && selectednirmandhinMothePrakalpaIdIndex != null) {
                              setState(() {
                                nirmandhinMothePrakalpaDataList[selectednirmandhinMothePrakalpaIdIndex!].isactive = 0;
                                selectednirmandhinMothePrakalpaIdIndex = null;
                              });
                            }
                          },
                          child: Icon(Icons.delete, color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
//======================== MOTHE RUGNALAY KENDRA  =======================================================
          mainContainer(
              "${Statics.getLabel('MotheRugnalay')}",
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showMotheRugnalayPopup(context, onDataChanged: () {
                            setState(() {});
                          });
                        } else {
                          showPopupForVastiValidation(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              SizedBox(width: 5),
                              Text(
                                "${Statics.getLabel('AddButton')}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DataTable(
                            showCheckboxColumn: false,
                            headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                            columns: [
                              DataColumn(
                                  label: Text(
                                "${Statics.getLabel('hospitals')}",
                              )),
                              DataColumn(
                                  label: Text(
                                "${Statics.getLabel('Name')}",
                              )),
                            ],
                            rows: motheRugnalayDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                              int index = entry.key;
                              var data = entry.value;
                              bool isSelected = selectedmotheRugnalayIdIndex == index;
                              return DataRow(
                                  selected: isSelected,
                                  color: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (isSelected) return Colors.yellow.shade100;
                                      return null;
                                    },
                                  ),
                                  onSelectChanged: (bool? selected) {
                                    if (selected != null && selected) {
                                      setState(() {
                                        selectedmotheRugnalayIdIndex = index;
                                      });
                                    }
                                  },
                                  cells: [
                                    DataCell(Text(data.selectedDropdownValueName ?? '')),
                                    DataCell(Text(data.name ?? '')),
                                  ]);
                            }).toList(),
                          ),
                        )),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (selectedmotheRugnalayIdIndex != null) {
                              var selectedData = motheRugnalayDataList[selectedmotheRugnalayIdIndex!];
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('nirmanadhinMothePrakalpa')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                          SizedBox(height: 12),
                                          _buildInfoRow("${Statics.getLabel('hospitals')}", selectedData.selectedDropdownValueName),
                                          _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                        ],
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purpleAccent,
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            showMotheRugnalayPopup(context, editIndex: selectedmotheRugnalayIdIndex, onDataChanged: () {
                              setState(() {});
                            });
                          },
                          child: Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.white,
                                title: Center(
                                  child: Text(
                                    "${Statics.getLabel('pusthikarn')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    "${Statics.getLabel('deleteconfirmText')}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text(
                                      "${Statics.getLabel('ConfirmationNo')}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text(
                                      "${Statics.getLabel('ConfirmationYes')}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (shouldDelete == true && selectedmotheRugnalayIdIndex != null) {
                              setState(() {
                                motheRugnalayDataList[selectedmotheRugnalayIdIndex!].isactive = 0;
                                selectedmotheRugnalayIdIndex = null;
                              });
                            }
                          },
                          child: Icon(Icons.delete, color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
//===================================================================================================================================================================================
          mainContainer(
              "${Statics.getLabel('fireBrigateCenter')}",
              Column(
                children: [
                  yesNoRadioButton(
                      question: "${Statics.getLabel('isFireBrigateCenter')}",
                      onChanged: (value) {
                        if (isVastiSearch) {
                          setState(() {
                            agniShamanDalKendraAhe = value;
                          });
                        } else {
                          showPopupForVastiValidation(
                            context,
                          );
                        }
                      },
                      selectedOption: agniShamanDalKendraAhe ?? 2)
                ],
              )),
//===================================================================================================================================================================================
          mainContainer(
              "${Statics.getLabel('policeStations')}",
              Column(
                children: [
                  yesNoRadioButton(
                      question: "${Statics.getLabel('isPoliceStation')}",
                      onChanged: (value) {
                        if (isVastiSearch) {
                          setState(() {
                            polichChoukiAhe = value;
                          });
                        } else {
                          showPopupForVastiValidation(
                            context,
                          );
                        }
                      },
                      selectedOption: polichChoukiAhe ?? 2)
                ],
              )),
//==================================  SHAIKSHANIK SANSTHA FORM =================================================================================================================================================
          mainContainer(
              "${Statics.getLabel('shaikshanikSanstha')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isVastiSearch) {
                            showShaikshanikSansthaPopup(
                              context,
                              onDataChanged: () {
                                setState(() {});
                              },
                            );
                          } else {
                            showPopupForVastiValidation(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 100,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('AddButton')}",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 1.3,
                              child: DataTable(
                                showCheckboxColumn: false,
                                headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('shaikshnikSansthaPrakar')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('shaikshnikSansthaNaav')}",
                                  )),
                                ],
                                rows: allShaikshanikPrakarDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                  int index = entry.key;
                                  var data = entry.value;
                                  bool isSelected = selectedShaikshanikSansthaIdIndex == index;
                                  return DataRow(
                                      selected: isSelected,
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                          if (isSelected) return Colors.yellow.shade100;
                                          return null;
                                        },
                                      ),
                                      onSelectChanged: (bool? selected) {
                                        if (selected != null && selected) {
                                          setState(() {
                                            selectedShaikshanikSansthaIdIndex = index;
                                          });
                                        }
                                      },
                                      cells: [
                                        DataCell(Text(data.selectedDropdownValueName ?? '')),
                                        DataCell(Text(data.name ?? '')),
                                      ]);
                                }).toList(),
                              ),
                            )),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (selectedShaikshanikSansthaIdIndex != null) {
                                  var selectedData = allShaikshanikPrakarDataList[selectedShaikshanikSansthaIdIndex!];
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Center(
                                          child: Text(
                                            "${Statics.getLabel('mahavidyalayTapshil')}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('shaikshanikSanstha')}", selectedData.name),
                                              if (selectedData.shaikshaniksansthaan == 315) _buildInfoRow("${Statics.getLabel('schoolPrakar')}", selectedData.selectedDropdownValueName),
                                              if (selectedData.shaikshaniksansthaan == 315) _buildInfoRow("${Statics.getLabel('shikshanacheMadhyam')}", selectedData.selectedDropdownValueName1),
                                              if (selectedData.shaikshaniksansthaan == 315) _buildInfoRow("${Statics.getLabel('sansthaCHalakPrakar')}", selectedData.selectedDropdownValueName2),
                                              if (selectedData.shaikshaniksansthaan == 316) _buildInfoRow("${Statics.getLabel('mahavidyalayinPrakaar')}", selectedData.selectedDropdownValueName),
                                              _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                              _buildInfoRow("${Statics.getLabel('milkat')}", selectedData.selectedDropdownValueName4),
                                            ],
                                          ),
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.purpleAccent,
                                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                showShaikshanikSansthaPopup(
                                  context,
                                  editIndex: selectedShaikshanikSansthaIdIndex,
                                  onDataChanged: () {
                                    setState(() {});
                                  },
                                );
                              },
                              child: Icon(Icons.edit, color: Colors.blue, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('pusthikarn')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        "${Statics.getLabel('deleteconfirmText')}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade300,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationNo')}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationYes')}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (shouldDelete == true && selectedShaikshanikSansthaIdIndex != null) {
                                  setState(() {
                                    allShaikshanikPrakarDataList[selectedShaikshanikSansthaIdIndex!].isactive = 0;
                                    selectedShaikshanikSansthaIdIndex = null;
                                  });
                                }
                              },
                              child: Icon(Icons.delete, color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
//================================== MAIDAAN UDYAAN FORM =================================================================================================================================================
          mainContainer(
              "${Statics.getLabel('MaidaanUdyan')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isVastiSearch) {
                            showMaidanUdyanPopup(context, onDataChanged: () {
                              setState(() {});
                            });
                          } else {
                            showPopupForVastiValidation(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 100,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('AddButton')}",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: DataTable(
                                columnSpacing: 20,
                                showCheckboxColumn: false,
                                headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('serialNo')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('Name')}",
                                  )),
                                ],
                                rows: maidanUddyanDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                  int index = entry.key;
                                  var data = entry.value;
                                  bool isSelected = selectedMaidanUdyanIdIndex == index;
                                  return DataRow(
                                      selected: isSelected,
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                          if (isSelected) return Colors.yellow.shade100;
                                          return null;
                                        },
                                      ),
                                      onSelectChanged: (bool? selected) {
                                        if (selected != null && selected) {
                                          setState(() {
                                            selectedMaidanUdyanIdIndex = index;
                                          });
                                        }
                                      },
                                      cells: [
                                        DataCell(Text("${index + 1}")),
                                        DataCell(Text(data.name ?? '')),
                                      ]);
                                }).toList(),
                              ),
                            )),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (selectedMaidanUdyanIdIndex != null) {
                                  var selectedData = maidanUddyanDataList[selectedMaidanUdyanIdIndex!];
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Center(
                                          child: Text(
                                            "${Statics.getLabel('MaidaanUdyan')}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                            ],
                                          ),
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.purpleAccent,
                                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                showMaidanUdyanPopup(context, editIndex: selectedMaidanUdyanIdIndex, onDataChanged: () {
                                  setState(() {});
                                });
                              },
                              child: Icon(Icons.edit, color: Colors.blue, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('pusthikarn')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        "${Statics.getLabel('deleteconfirmText')}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade300,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationNo')}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationYes')}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (shouldDelete == true && selectedMaidanUdyanIdIndex != null) {
                                  setState(() {
                                    maidanUddyanDataList[selectedMaidanUdyanIdIndex!].isactive = 0;
                                    selectedMaidanUdyanIdIndex = null;
                                  });
                                }
                              },
                              child: Icon(Icons.delete, color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
//================================== JAHIR KARYAKRAM SAMBANDHI FORM =================================================================================================================================================
          mainContainer(
              "${Statics.getLabel('jahirKaryakramSambhandhi')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isVastiSearch) {
                            showjahirKaryakramPopup(context, onDataChanged: () {
                              setState(() {});
                            });
                          } else {
                            showPopupForVastiValidation(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 100,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('AddButton')}",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 1.5,
                              child: DataTable(
                                columnSpacing: 20,
                                showCheckboxColumn: false,
                                headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('SelectFrequency')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('Name')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('shamta')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('NnivaasAvailable')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('nivaasShamta')}",
                                  )),
                                ],
                                rows: jahirKaryakramDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                  int index = entry.key;
                                  var data = entry.value;
                                  bool isSelected = selectedjahirKaryakramIdIndex == index;
                                  return DataRow(
                                      selected: isSelected,
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                          if (isSelected) return Colors.yellow.shade100;
                                          return null;
                                        },
                                      ),
                                      onSelectChanged: (bool? selected) {
                                        if (selected != null && selected) {
                                          setState(() {
                                            selectedjahirKaryakramIdIndex = index;
                                          });
                                        }
                                      },
                                      cells: [
                                        DataCell(Text(data.selectedDropdownValueName ?? '')),
                                        DataCell(Text(data.name ?? '')),
                                        DataCell(Text(data.shamta ?? '')),
                                        DataCell(Text(data.nivasasathiupalabdha == 1
                                            ? "${Statics.getLabel('ConfirmationYes')}"
                                            : data.nivasasathiupalabdha == 0
                                                ? "${Statics.getLabel('ConfirmationNo')}"
                                                : "-")),
                                        DataCell(Text(data.nivaaskshamata ?? '')),
                                      ]);
                                }).toList(),
                              ),
                            )),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (selectedjahirKaryakramIdIndex != null) {
                                  var selectedData = jahirKaryakramDataList[selectedjahirKaryakramIdIndex!];
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Center(
                                          child: Text(
                                            "${Statics.getLabel('jahirKaryakramSambhandhi')}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('SelectFrequency')}", selectedData.selectedDropdownValueName),
                                              _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                              _buildInfoRow("${Statics.getLabel('shamta')}", selectedData.shamta),
                                              _buildInfoRow(
                                                  "${Statics.getLabel('NnivaasAvailable')}",
                                                  selectedData.nivasasathiupalabdha == 1
                                                      ? "${Statics.getLabel('ConfirmationYes')}"
                                                      : selectedData.nivasasathiupalabdha == 0
                                                          ? "${Statics.getLabel('ConfirmationNo')}"
                                                          : "-"),
                                              _buildInfoRow("${Statics.getLabel('nivaasShamta')}", selectedData.nivaaskshamata),
                                            ],
                                          ),
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.purpleAccent,
                                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                showjahirKaryakramPopup(context, editIndex: selectedjahirKaryakramIdIndex, onDataChanged: () {
                                  setState(() {});
                                });
                              },
                              child: Icon(Icons.edit, color: Colors.blue, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('pusthikarn')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        "${Statics.getLabel('deleteconfirmText')}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade300,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationNo')}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationYes')}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (shouldDelete == true && selectedjahirKaryakramIdIndex != null) {
                                  setState(() {
                                    jahirKaryakramDataList[selectedjahirKaryakramIdIndex!].isactive = 0;
                                    selectedjahirKaryakramIdIndex = null;
                                  });
                                }
                              },
                              child: Icon(Icons.delete, color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
//============================================================================================================================================================
          Divider(thickness: 2),
          InkWell(
            onTap: () {
              submitStep2Form();
            },
            child: Container(
              width: double.infinity,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withOpacity(0.5),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "${Statics.getLabel('anyaMahitiSangrah')}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> submitStep2Form() async {
    setState(() {
      _isStep2Completed = true;
    });
    Map<String, dynamic> formData = {
      "vastiid": int.parse(selctedLevelId!),
      "cuserid": int.parse(Statics.userDetails['userID']),
      "VastisarVastitilabalopasanakendra": vastitBalopasanaKendraDataList,
      "VastisarMothevyavasayikakendra": motheVyasayikKendraDataList,
      "VastisarNirmanadhinamothe": nirmandhinMothePrakalpaDataList,
      "VastisarMotherugnalaya": motheRugnalayDataList,
      "agnishamandal": agniShamanDalKendraAhe,
      "Policethane": polichChoukiAhe,
      "Vastisarmaidan": maidanUddyanDataList,
      "VastisarJahirakaryakramasambandhi": jahirKaryakramDataList,
      "Vastisarschooltapasila": allShaikshanikPrakarDataList,
      "stepTwoComplete": _isStep2Completed == true ? 1 : 0,
    };
    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Step 2 Form Data (JSON):\n$formattedJson");
    Statics.vastiSarvekshanStep2FormSubmit(context, jsonEncode(formData));
    await Future.delayed(Duration(seconds: 2));
    searchVastiData(selctedLevelId);
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  //=================================================== 11. VASTIT BALOPASANA KENDRA FORM ====================================================================================
  List<VastisarVastitilabalopasanakendra> vastitBalopasanaKendraDataList = [];
  int? selectedVastitBalopasanaKendraIdIndex;
  int? selectedVastitBalopasanaKendraId;
  int? selectedVastitBalopasanaKendraIdEdit;
  String? selectedVastitBalopasanaKendraName;
  Masterdata? selectedMasterVastitBalopasanaKendraName;
  final TextEditingController vastitBalopasanaKendraAnyaController = TextEditingController();
  final TextEditingController vastitBalopasanaKendraAnyaNameController = TextEditingController();
  final TextEditingController vastitBalopasanaKendraNaavController = TextEditingController();
  String? _selectedGender;
  int? selectedGenderIndex;
  int? isActiveBalopasanakendra = 1;
  int? pkidBalopasanakendra = 0;

  void showVastitBalopasanaKendraPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = vastitBalopasanaKendraDataList[editIndex];
      selectedVastitBalopasanaKendraId = data.shreneeid;
      selectedVastitBalopasanaKendraIdEdit = data.shreneeid;
      selectedVastitBalopasanaKendraName = data.selectedDropdownValueName;
      selectedMasterVastitBalopasanaKendraName = vastisarvekshanDropDownDataModel!.masterdata!.firstWhere((e) => e.id == data.shreneeid, orElse: () => Masterdata());
      vastitBalopasanaKendraAnyaNameController.text = data.otherBalopasanaShreniName ?? "";
      vastitBalopasanaKendraNaavController.text = data.name ?? "";
      _selectedGender = data.konasathi;
      isActiveBalopasanakendra = data.isactive;
      pkidBalopasanakendra = data.pkid;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('BalopasanaKendra')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
                maxLines: 2,
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearvastitBalopasanaKendraFields();
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              final Map<int, String> genderMap = {
                0: 'महिला',
                1: 'पुरुष',
                2: 'दोघांसाठी',
              };
              int? getGenderIndexFromLabel(String? label) {
                if (label == null) return null;
                return genderMap.entries.firstWhere((entry) => entry.value == label, orElse: () => const MapEntry(-1, '')).key;
              }

              selectedGenderIndex = getGenderIndexFromLabel(_selectedGender);
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "बलोपासनाकेंद्र",
                      hintText: "${Statics.getLabel('selectKendra')}",
                      onItemSelected: (id, value, isOther) {
                        selectedVastitBalopasanaKendraId = id;
                        selectedVastitBalopasanaKendraName = value;
                        print("id = $selectedVastitBalopasanaKendraId //////  name = $selectedVastitBalopasanaKendraName");
                      },
                      width: 250,
                      selectedValue: selectedMasterVastitBalopasanaKendraName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasterVastitBalopasanaKendraName = newValue;
                        });
                      },
                      editId: selectedVastitBalopasanaKendraIdEdit,
                    ),
                    const SizedBox(height: 10),
                    if (selectedMasterVastitBalopasanaKendraName?.isOther == 1)
                      textControllerField("${Statics.getLabel('otherKendra')}", vastitBalopasanaKendraAnyaNameController, context, height: 50),
                    textControllerField("${Statics.getLabel('Name')}", vastitBalopasanaKendraNaavController, context, height: 50),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${Statics.getLabel('balopasanaKendraForWhom')}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ...genderMap.entries.map((entry) {
                          return RadioListTile<int>(
                            title: Text(entry.value),
                            value: entry.key,
                            groupValue: selectedGenderIndex,
                            onChanged: (value) {
                              setState(() {
                                selectedGenderIndex = value;
                                _selectedGender = genderMap[value!]; // Store label
                              });
                              print('Selected Gender: $_selectedGender (index: $value)');
                            },
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              );
            },
          ),
          actions: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if ((selectedMasterVastitBalopasanaKendraName?.isOther == 1 && vastitBalopasanaKendraAnyaNameController.text == "")) {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                  } else {
                    VastisarVastitilabalopasanakendra data = VastisarVastitilabalopasanakendra(
                        shreneeid: selectedVastitBalopasanaKendraId,
                        selectedDropdownValueName: selectedVastitBalopasanaKendraName,
                        isactive: isActiveBalopasanakendra,
                        pkid: pkidBalopasanakendra,
                        vastiid: int.parse(selctedLevelId!),
                        name: vastitBalopasanaKendraNaavController.text,
                        konasathi: _selectedGender,
                        otherBalopasanaShreniName: vastitBalopasanaKendraAnyaNameController.text);
                    if (editIndex != null) {
                      vastitBalopasanaKendraDataList[editIndex] = data;
                    } else {
                      vastitBalopasanaKendraDataList.add(data);
                    }
                    if (onDataChanged != null) {
                      onDataChanged();
                    }
                    Navigator.of(ctx).pop();
                    clearvastitBalopasanaKendraFields();
                  }
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearvastitBalopasanaKendraFields() {
    selectedVastitBalopasanaKendraIdIndex = null;
    selectedVastitBalopasanaKendraId = null;
    selectedVastitBalopasanaKendraIdEdit = null;
    selectedVastitBalopasanaKendraName = null;
    selectedMasterVastitBalopasanaKendraName = null;
    vastitBalopasanaKendraAnyaNameController.clear();
    vastitBalopasanaKendraNaavController.clear();
    _selectedGender = null;
    selectedGenderIndex = null;
    isActiveBalopasanakendra = 1;
    pkidBalopasanakendra = 0;
  }

  //=================================================== 12. MOTHE VYASAYIK KENDRA FORM ====================================================================================
  List<VastisarMothevyavasayikakendra> motheVyasayikKendraDataList = [];
  int? selectedMotheVyasayikKendraIdIndex;
  int? selectedMotheVyasayikKendraId;
  int? selectedMotheVyasayikKendraIdEdit;
  String? selectedMotheVyasayikKendraName;
  Masterdata? selectedMasterMotheVyasayikKendraName;
  int? pkidMotheVyasayikKendra = 0;
  int? isActiveMotheVyasayikKendra = 1;
  final TextEditingController motheVyasayikKendraNaavController = TextEditingController();

  void showMotheVyavsayikKendraPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = motheVyasayikKendraDataList[editIndex];
      selectedMotheVyasayikKendraId = data.id;
      selectedMotheVyasayikKendraName = data.selectedDropdownValueName;
      motheVyasayikKendraNaavController.text = data.name ?? "";
      selectedMotheVyasayikKendraIdEdit = data.id;
      isActiveMotheVyasayikKendra = data.isactive;
      pkidMotheVyasayikKendra = data.pkid;
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('MotheVyasaayiKendra')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearMotheVyasayikFields();
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "मोठेव्यवसायिककेंद्र",
                      hintText: "${Statics.getLabel('selectKendra')}",
                      onItemSelected: (id, value, isOther) {
                        selectedMotheVyasayikKendraId = id;
                        selectedMotheVyasayikKendraName = value;
                        print("id = $selectedMotheVyasayikKendraId //////  name = $selectedMotheVyasayikKendraName");
                      },
                      width: 250,
                      selectedValue: selectedMasterMotheVyasayikKendraName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasterMotheVyasayikKendraName = newValue;
                        });
                      },
                      editId: selectedMotheVyasayikKendraIdEdit,
                    ),
                    const SizedBox(height: 10),
                    textControllerField("${Statics.getLabel('Name')}", motheVyasayikKendraNaavController, context, height: 50),
                    const SizedBox(height: 5),
                  ],
                ),
              );
            },
          ),
          actions: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  VastisarMothevyavasayikakendra data = VastisarMothevyavasayikakendra(
                    name: motheVyasayikKendraNaavController.text,
                    vastiid: int.parse(selctedLevelId!),
                    pkid: pkidMotheVyasayikKendra,
                    isactive: isActiveMotheVyasayikKendra,
                    selectedDropdownValueName: selectedMotheVyasayikKendraName,
                    id: selectedMotheVyasayikKendraId,
                  );
                  if (editIndex != null) {
                    motheVyasayikKendraDataList[editIndex] = data;
                  } else {
                    motheVyasayikKendraDataList.add(data);
                  }
                  if (onDataChanged != null) {
                    onDataChanged();
                  }
                  Navigator.of(ctx).pop();
                  clearMotheVyasayikFields();
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearMotheVyasayikFields() {
    selectedMotheVyasayikKendraIdIndex = null;
    selectedMotheVyasayikKendraId = null;
    selectedMotheVyasayikKendraIdEdit = null;
    selectedMotheVyasayikKendraName = null;
    selectedMasterMotheVyasayikKendraName = null;
    pkidMotheVyasayikKendra = 0;
    isActiveMotheVyasayikKendra = 1;
    motheVyasayikKendraNaavController.clear();
  }

  //=================================================== 13. NIRMANDHIN MOTHE PRAKALPA FORM ====================================================================================
  List<VastisarNirmanadhinamothe> nirmandhinMothePrakalpaDataList = [];
  int? selectednirmandhinMothePrakalpaIdIndex;
  int? selectednirmandhinMothePrakalpaId;
  int? selectednirmandhinMothePrakalpaIdEdit;
  String? selectednirmandhinMothePrakalpaName;
  Masterdata? selectedMasternirmandhinMothePrakalpaName;
  int? nirmandhinMothePrakalpaPkid = 0;
  int? nirmandhinMothePrakalpaIsActive = 1;
  final TextEditingController nirmandhinMothePrakalpaNaavController = TextEditingController();

  void showNirmaandhinMothePopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = nirmandhinMothePrakalpaDataList[editIndex];
      selectednirmandhinMothePrakalpaId = data.id;
      selectednirmandhinMothePrakalpaIdEdit = data.id;
      selectednirmandhinMothePrakalpaName = data.selectedDropdownValueName;
      nirmandhinMothePrakalpaNaavController.text = data.name ?? "";
      nirmandhinMothePrakalpaPkid = data.pkid;
      nirmandhinMothePrakalpaIsActive = data.isactive;

      selectedMasternirmandhinMothePrakalpaName = vastisarvekshanDropDownDataModel!.masterdata!.firstWhere((e) => e.id == data.id, orElse: () => Masterdata());
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('nirmanadhinMothePrakalpa')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textControllerField("${Statics.getLabel('Name')}", nirmandhinMothePrakalpaNaavController, context, height: 50),
                    const SizedBox(height: 5),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "निर्माणाधीनमोठेप्रकल्प",
                      hintText: "${Statics.getLabel('selectPrakalpa')}",
                      onItemSelected: (id, value, isOther) {
                        selectednirmandhinMothePrakalpaId = id;
                        selectednirmandhinMothePrakalpaName = value;
                        print("id = $selectednirmandhinMothePrakalpaId //////  name = $selectednirmandhinMothePrakalpaName");
                      },
                      width: 250,
                      selectedValue: selectedMasternirmandhinMothePrakalpaName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasternirmandhinMothePrakalpaName = newValue;
                        });
                      },
                      editId: selectednirmandhinMothePrakalpaIdEdit,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
          actions: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  VastisarNirmanadhinamothe data = VastisarNirmanadhinamothe(
                    id: selectednirmandhinMothePrakalpaId,
                    selectedDropdownValueName: selectednirmandhinMothePrakalpaName,
                    name: nirmandhinMothePrakalpaNaavController.text,
                    pkid: nirmandhinMothePrakalpaPkid,
                    isactive: nirmandhinMothePrakalpaIsActive,
                    vastiid: int.parse(selctedLevelId!),
                  );
                  if (editIndex != null) {
                    nirmandhinMothePrakalpaDataList[editIndex] = data;
                  } else {
                    nirmandhinMothePrakalpaDataList.add(data);
                  }
                  if (onDataChanged != null) {
                    onDataChanged();
                  }
                  Navigator.of(ctx).pop();
                  clearNirmandhinMothePrakalpaFields();
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearNirmandhinMothePrakalpaFields() {
    selectednirmandhinMothePrakalpaIdIndex = null;
    selectednirmandhinMothePrakalpaId = null;
    selectednirmandhinMothePrakalpaIdEdit = null;
    selectednirmandhinMothePrakalpaName = null;
    selectedMasternirmandhinMothePrakalpaName = null;
    nirmandhinMothePrakalpaPkid = 0;
    nirmandhinMothePrakalpaIsActive = 1;
    nirmandhinMothePrakalpaNaavController.clear();
  }

  //=================================================== 14. MOTHE RUGNALAY PRAKALPA FORM ====================================================================================
  List<VastisarMotherugnalaya> motheRugnalayDataList = [];
  int? selectedmotheRugnalayIdIndex;
  int? selectedmotheRugnalayId;
  int? selectedmotheRugnalayIdEdit;
  String? selectedmotheRugnalayName;
  Masterdata? selectedMastermotheRugnalayName;
  int? selectedmotheRugnalayPkId = 0;
  int? selectedmotheRugnalayIsActive = 1;

  final TextEditingController motheRugnalayNaavController = TextEditingController();

  void showMotheRugnalayPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = motheRugnalayDataList[editIndex];
      selectedmotheRugnalayId = data.id;
      selectedmotheRugnalayIdEdit = data.id;
      selectedmotheRugnalayName = data.selectedDropdownValueName;
      motheRugnalayNaavController.text = data.name ?? "";
      selectedmotheRugnalayPkId = data.pkid;
      selectedmotheRugnalayIsActive = data.isactive;

      /// ✅ Set selected dropdown item for edit
      selectedMastermotheRugnalayName = vastisarvekshanDropDownDataModel!.masterdata!.firstWhere((e) => e.id == data.id, orElse: () => Masterdata());
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('MotheRugnalay')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearMotheRugnalayFields();
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "मोठेरुग्णालयद्र",
                      hintText: "${Statics.getLabel('selectPrakalpa')}",
                      onItemSelected: (id, value, isOther) {
                        selectedmotheRugnalayId = id;
                        selectedmotheRugnalayName = value;
                        print("id = $selectedmotheRugnalayId //////  name = $selectedmotheRugnalayName");
                      },
                      width: 250,
                      selectedValue: selectedMastermotheRugnalayName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMastermotheRugnalayName = newValue;
                        });
                      },
                      editId: selectedmotheRugnalayIdEdit,
                    ),
                    const SizedBox(height: 10),
                    textControllerField("${Statics.getLabel('Name')}", motheRugnalayNaavController, context, height: 50),
                    const SizedBox(height: 5),
                  ],
                ),
              );
            },
          ),
          actions: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  VastisarMotherugnalaya data = VastisarMotherugnalaya(
                    vastiid: int.parse(selctedLevelId!),
                    isactive: selectedmotheRugnalayIsActive,
                    pkid: selectedmotheRugnalayPkId,
                    selectedDropdownValueName: selectedmotheRugnalayName,
                    name: motheRugnalayNaavController.text,
                    id: selectedmotheRugnalayId,
                  );
                  if (editIndex != null) {
                    motheRugnalayDataList[editIndex] = data;
                  } else {
                    motheRugnalayDataList.add(data);
                  }
                  if (onDataChanged != null) {
                    onDataChanged();
                  }
                  Navigator.of(ctx).pop();
                  clearMotheRugnalayFields();
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearMotheRugnalayFields() {
    selectedmotheRugnalayIdIndex = null;
    selectedmotheRugnalayId = null;
    selectedmotheRugnalayIdEdit = null;
    selectedmotheRugnalayName = null;
    selectedMastermotheRugnalayName = null;
    motheRugnalayNaavController.clear();
  }

//================================  15. SHAIKSHANIK SANSTHA FORM ===================================================================================================
  List<Vastisarschooltapasila> allShaikshanikPrakarDataList = [];
  TextEditingController allShaikshanikPrakarNaavController = TextEditingController();
  int? selectedShaikshanikSansthaIdIndex;
  int? selectedShaikshanikSansthaId;
  int? selectedShaikshanikSansthaIdEdit;
  String? selectedShaikshanikSansthaName;
  Masterdata? selectedMasterShaikshanikSansthaName;

  //========== if(sansthaType == 315) ============
  int? selectedShalaPrakarIdIndex;
  int? selectedShalaPrakarId;
  int? selectedShalaPrakarIdEdit;
  String? selectedShalaPrakarName;
  Masterdata? selectedMasterShalaPrakarName;
  int? selectedShikshanacheMadhyamId;
  int? selectedShikshanacheMadhyamIdEdit;
  String? selectedShikshanacheMadhyamName;
  Masterdata? selectedMasterShikshanacheMadhyamName;
  int? selectedSansthaChalakPrakarId;
  int? selectedSansthaChalakPrakarIdEdit;
  String? selectedSansthaChalakPrakarName;
  Masterdata? selectedMasterSansthaChalakPrakarName;

  //========== if(sansthaType == 316) ====================================
  int? selectedMahavidyalayinPrakarIdIndex;
  int? selectedMahavidyalayinPrakarId;
  int? selectedMahavidyalayinPrakarIdEdit;
  String? selectedMahavidyalayinPrakarName;
  Masterdata? selectedMasterMahavidyalayinPrakarName;

  //========== if(sansthaType == 317) ====================================
  int? selectedAllShaikshanikPrakarIdIndex;
  int? selectedAllShaikshanikPrakarTapshilMilkatId;
  int? selectedAllShaikshanikPrakarTapshilMilkatIdEdit;
  String? selectedAllShaikshanikPrakarTapshilMilkatName;
  Masterdata? selectedMasterAllShaikshanikPrakarTapshilMilkatName;

  int? isActiveSchool = 1;
  int? pkidSchool = 0;

  void showShaikshanikSansthaPopup(
    BuildContext context, {
    int? editIndex,
    VoidCallback? onDataChanged,
  }) {
    print("editIndex $editIndex ||| sansthaType $selectedShaikshanikSansthaId");
    if (editIndex != null) {
      var data = allShaikshanikPrakarDataList[editIndex];
      selectedShalaPrakarId = data.prakaarid;
      selectedShalaPrakarIdEdit = data.prakaarid;
      selectedShalaPrakarName = data.selectedDropdownValueName;
      selectedShikshanacheMadhyamId = data.maadhyam;
      selectedShikshanacheMadhyamIdEdit = data.maadhyam;
      selectedShikshanacheMadhyamName = data.selectedDropdownValueName1;

      selectedSansthaChalakPrakarId = data.chaalakprakaar;
      selectedSansthaChalakPrakarIdEdit = data.chaalakprakaar;
      selectedSansthaChalakPrakarName = data.selectedDropdownValueName2;

      selectedMahavidyalayinPrakarId = data.prakaarid;
      selectedMahavidyalayinPrakarIdEdit = data.prakaarid;
      selectedMahavidyalayinPrakarName = data.selectedDropdownValueName3;

      selectedShaikshanikSansthaId = data.shaikshaniksansthaan;
      selectedShaikshanikSansthaIdEdit = data.shaikshaniksansthaan;
      selectedShaikshanikSansthaName = data.selectedDropdownValueName;
      selectedAllShaikshanikPrakarTapshilMilkatId = data.milkat;
      selectedAllShaikshanikPrakarTapshilMilkatIdEdit = data.milkat;
      selectedAllShaikshanikPrakarTapshilMilkatName = data.selectedDropdownValueName4;

      allShaikshanikPrakarNaavController.text = data.name ?? "";
      pkidSchool = data.pkid;
      isActiveSchool = data.isactive;
      print("selectedShaikshanikSansthaName $selectedShaikshanikSansthaName");
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${Statics.getLabel('shaikshanikSanstha')}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.purpleAccent)),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearShalaPrakarDataListFields();
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: selectedShaikshanikSansthaId == 315
                      ? [
                          vastisarvekshanDropDownDataModel != null
                              ? vastisarvekshanDropdown2(
                                  dataModel: vastisarvekshanDropDownDataModel!,
                                  filterTypeName: "शैक्षणिकसंस्थान",
                                  hintText: "${Statics.getLabel('selectShaikshanikSanstha')}",
                                  onItemSelected: (id, value, isOther) {
                                    selectedShaikshanikSansthaId = id;
                                    selectedShaikshanikSansthaName = value;
                                    print("id = $selectedShaikshanikSansthaId //////  name = $selectedShaikshanikSansthaName//////  iD Edit = $selectedShaikshanikSansthaIdEdit");
                                  },
                                  width: 250,
                                  selectedValue: selectedMasterShaikshanikSansthaName,
                                  onSelectionChanged: (newValue) {
                                    setState(() {
                                      selectedMasterShaikshanikSansthaName = newValue;
                                    });
                                  },
                                  editId: selectedShaikshanikSansthaIdEdit,
                                )
                              : Container(),
                          const SizedBox(height: 5),
                          vastisarvekshanDropdown2(
                            dataModel: vastisarvekshanDropDownDataModel!,
                            filterTypeName: "शाळाप्रकार",
                            hintText: "${Statics.getLabel('schoolPrakar')}",
                            onItemSelected: (id, value, isOther) {
                              selectedShalaPrakarId = id;
                              selectedShalaPrakarName = value;
                            },
                            width: 250,
                            selectedValue: selectedMasterShalaPrakarName,
                            onSelectionChanged: (newValue) {
                              setState(() {
                                selectedMasterShalaPrakarName = newValue;
                              });
                            },
                            editId: selectedShalaPrakarIdEdit,
                          ),
                          const SizedBox(height: 5),
                          vastisarvekshanDropdown2(
                            dataModel: vastisarvekshanDropDownDataModel!,
                            filterTypeName: "शिक्षणाचेमाध्यम",
                            hintText: "${Statics.getLabel('madhyamPrakaar')}",
                            onItemSelected: (id, value, isOther) {
                              selectedShikshanacheMadhyamId = id;
                              selectedShikshanacheMadhyamName = value;
                            },
                            width: 250,
                            selectedValue: selectedMasterShikshanacheMadhyamName,
                            onSelectionChanged: (newValue) {
                              setState(() {
                                selectedMasterShikshanacheMadhyamName = newValue;
                              });
                            },
                            editId: selectedShikshanacheMadhyamIdEdit,
                          ),
                          const SizedBox(height: 5),
                          vastisarvekshanDropdown2(
                            dataModel: vastisarvekshanDropDownDataModel!,
                            filterTypeName: "संस्थाचालकप्रकार",
                            hintText: "${Statics.getLabel('sansthaCHalakPrakar')}",
                            onItemSelected: (id, value, isOther) {
                              selectedSansthaChalakPrakarId = id;
                              selectedSansthaChalakPrakarName = value;
                            },
                            width: 250,
                            selectedValue: selectedMasterSansthaChalakPrakarName,
                            onSelectionChanged: (newValue) {
                              setState(() {
                                selectedMasterSansthaChalakPrakarName = newValue;
                              });
                            },
                            editId: selectedSansthaChalakPrakarIdEdit,
                          ),
                          const SizedBox(height: 5),
                          textControllerField("${Statics.getLabel('Name')}", allShaikshanikPrakarNaavController, context, height: 50),
                          vastisarvekshanDropdown2(
                            dataModel: vastisarvekshanDropDownDataModel!,
                            filterTypeName: "शाळातपशीलमिळकत",
                            hintText: "${Statics.getLabel('milkat')}",
                            onItemSelected: (id, value, isOther) {
                              selectedAllShaikshanikPrakarTapshilMilkatId = id;
                              selectedAllShaikshanikPrakarTapshilMilkatName = value;
                            },
                            width: 250,
                            selectedValue: selectedMasterAllShaikshanikPrakarTapshilMilkatName,
                            onSelectionChanged: (newValue) {
                              setState(() {
                                selectedMasterAllShaikshanikPrakarTapshilMilkatName = newValue;
                              });
                            },
                            editId: selectedAllShaikshanikPrakarTapshilMilkatIdEdit,
                          ),
                          const SizedBox(height: 5),
                        ]
                      : selectedShaikshanikSansthaId == 316
                          ? [
                              vastisarvekshanDropDownDataModel != null
                                  ? vastisarvekshanDropdown2(
                                      dataModel: vastisarvekshanDropDownDataModel!,
                                      filterTypeName: "शैक्षणिकसंस्थान",
                                      hintText: "${Statics.getLabel('selectShaikshanikSanstha')}",
                                      onItemSelected: (id, value, isOther) {
                                        selectedShaikshanikSansthaId = id;
                                        selectedShaikshanikSansthaName = value;
                                        print("id = $selectedShaikshanikSansthaId //////  name = $selectedShaikshanikSansthaName//////  iD Edit = $selectedShaikshanikSansthaIdEdit");
                                      },
                                      width: 250,
                                      selectedValue: selectedMasterShaikshanikSansthaName,
                                      onSelectionChanged: (newValue) {
                                        setState(() {
                                          selectedMasterShaikshanikSansthaName = newValue;
                                        });
                                      },
                                      editId: selectedShaikshanikSansthaIdEdit,
                                    )
                                  : Container(),
                              const SizedBox(height: 5),
                              vastisarvekshanDropDownDataModel != null
                                  ? vastisarvekshanDropdown2(
                                      dataModel: vastisarvekshanDropDownDataModel!,
                                      filterTypeName: "महाविद्यालयीनप्रकार",
                                      hintText: "महाविद्यालयीन प्रकार",
                                      onItemSelected: (id, value, isOther) {
                                        selectedMahavidyalayinPrakarId = id;
                                        selectedMahavidyalayinPrakarName = value;
                                        print("id = $selectedMahavidyalayinPrakarId //////  name = $selectedMahavidyalayinPrakarName");
                                      },
                                      width: 250,
                                      selectedValue: selectedMasterMahavidyalayinPrakarName,
                                      onSelectionChanged: (newValue) {
                                        setState(() {
                                          selectedMasterMahavidyalayinPrakarName = newValue;
                                        });
                                      },
                                      editId: selectedMahavidyalayinPrakarIdEdit,
                                    )
                                  : Container(),
                              textControllerField("${Statics.getLabel('Name')}", allShaikshanikPrakarNaavController, context, height: 50),
                              vastisarvekshanDropdown2(
                                dataModel: vastisarvekshanDropDownDataModel!,
                                filterTypeName: "महाविद्यालयीनतपशीलमिळकत",
                                hintText: "${Statics.getLabel('milkat')}",
                                onItemSelected: (id, value, isOther) {
                                  selectedAllShaikshanikPrakarTapshilMilkatId = id;
                                  selectedAllShaikshanikPrakarTapshilMilkatName = value;
                                },
                                width: 250,
                                selectedValue: selectedMasterAllShaikshanikPrakarTapshilMilkatName,
                                onSelectionChanged: (newValue) {
                                  setState(() {
                                    selectedMasterAllShaikshanikPrakarTapshilMilkatName = newValue;
                                  });
                                },
                                editId: selectedAllShaikshanikPrakarTapshilMilkatIdEdit,
                              ),
                              const SizedBox(height: 5),
                            ]
                          : selectedShaikshanikSansthaId == 317
                              ? [
                                  vastisarvekshanDropDownDataModel != null
                                      ? vastisarvekshanDropdown2(
                                          dataModel: vastisarvekshanDropDownDataModel!,
                                          filterTypeName: "शैक्षणिकसंस्थान",
                                          hintText: "${Statics.getLabel('selectShaikshanikSanstha')}",
                                          onItemSelected: (id, value, isOther) {
                                            selectedShaikshanikSansthaId = id;
                                            selectedShaikshanikSansthaName = value;
                                            print("id = $selectedShaikshanikSansthaId //////  name = $selectedShaikshanikSansthaName//////  iD Edit = $selectedShaikshanikSansthaIdEdit");
                                          },
                                          width: 250,
                                          selectedValue: selectedMasterShaikshanikSansthaName,
                                          onSelectionChanged: (newValue) {
                                            setState(() {
                                              selectedMasterShaikshanikSansthaName = newValue;
                                            });
                                          },
                                          editId: selectedShaikshanikSansthaIdEdit,
                                        )
                                      : Container(),
                                  textControllerField("${Statics.getLabel('Name')}", allShaikshanikPrakarNaavController, context, height: 50),
                                  vastisarvekshanDropdown2(
                                    dataModel: vastisarvekshanDropDownDataModel!,
                                    filterTypeName: "विशिष्टसंस्थामिळकत",
                                    hintText: "${Statics.getLabel('milkat')}",
                                    onItemSelected: (id, value, isOther) {
                                      selectedAllShaikshanikPrakarTapshilMilkatId = id;
                                      selectedAllShaikshanikPrakarTapshilMilkatName = value;
                                    },
                                    width: 250,
                                    selectedValue: selectedMasterAllShaikshanikPrakarTapshilMilkatName,
                                    onSelectionChanged: (newValue) {
                                      setState(() {
                                        selectedMasterAllShaikshanikPrakarTapshilMilkatName = newValue;
                                      });
                                    },
                                    editId: selectedAllShaikshanikPrakarTapshilMilkatIdEdit,
                                  ),
                                  const SizedBox(height: 5),
                                ]
                              : [
                                  vastisarvekshanDropDownDataModel != null
                                      ? vastisarvekshanDropdown2(
                                          dataModel: vastisarvekshanDropDownDataModel!,
                                          filterTypeName: "शैक्षणिकसंस्थान",
                                          hintText: "${Statics.getLabel('selectShaikshanikSanstha')}",
                                          onItemSelected: (id, value, isOther) {
                                            selectedShaikshanikSansthaId = id;
                                            selectedShaikshanikSansthaName = value;
                                            print("id = $selectedShaikshanikSansthaId //////  name = $selectedShaikshanikSansthaName");
                                          },
                                          width: 250,
                                          selectedValue: selectedMasterShaikshanikSansthaName,
                                          onSelectionChanged: (newValue) {
                                            setState(() {
                                              selectedMasterShaikshanikSansthaName = newValue;
                                            });
                                          },
                                          editId: selectedShaikshanikSansthaIdEdit,
                                        )
                                      : Container(),
                                  SizedBox(height: 10),
                                  Text("${Statics.getLabel('selectShaikshanikSanstha')}")
                                ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Vastisarschooltapasila data = Vastisarschooltapasila(
                    name: allShaikshanikPrakarNaavController.text,
                    pkid: pkidSchool,
                    isactive: isActiveSchool,
                    vastiid: int.parse(selctedLevelId!),
                    selectedDropdownValueName: selectedShaikshanikSansthaName,
                    prakaarid: selectedShalaPrakarId ?? selectedMahavidyalayinPrakarId,
                    selectedDropdownValueName3: selectedShalaPrakarName ?? selectedMahavidyalayinPrakarName,
                    selectedDropdownValueName2: selectedSansthaChalakPrakarName,
                    selectedDropdownValueName1: selectedShikshanacheMadhyamName,
                    selectedDropdownValueName4: selectedAllShaikshanikPrakarTapshilMilkatName,
                    maadhyam: selectedShikshanacheMadhyamId,
                    milkat: selectedAllShaikshanikPrakarTapshilMilkatId,
                    shaikshaniksansthaan: selectedShaikshanikSansthaId,
                    chaalakprakaar: selectedSansthaChalakPrakarId,
                  );

                  if (editIndex != null) {
                    allShaikshanikPrakarDataList[editIndex] = data;
                  } else {
                    allShaikshanikPrakarDataList.add(data);
                  }
                  if (onDataChanged != null) {
                    onDataChanged();
                  }
                  Navigator.of(ctx).pop();
                  clearShalaPrakarDataListFields();
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearShalaPrakarDataListFields() {
    selectedShalaPrakarId = null;
    selectedShalaPrakarIdEdit = null;
    selectedShalaPrakarName = null;
    selectedMasterShalaPrakarName = null;

    selectedShikshanacheMadhyamId = null;
    selectedShikshanacheMadhyamIdEdit = null;
    selectedShikshanacheMadhyamName = null;
    selectedMasterShikshanacheMadhyamName = null;

    selectedSansthaChalakPrakarId = null;
    selectedSansthaChalakPrakarIdEdit = null;
    selectedSansthaChalakPrakarName = null;
    selectedMasterSansthaChalakPrakarName = null;

    selectedMahavidyalayinPrakarId = null;
    selectedMahavidyalayinPrakarIdEdit = null;
    selectedMahavidyalayinPrakarName = null;
    selectedMasterMahavidyalayinPrakarName = null;

    selectedAllShaikshanikPrakarTapshilMilkatId = null;
    selectedAllShaikshanikPrakarTapshilMilkatIdEdit = null;
    selectedAllShaikshanikPrakarTapshilMilkatName = null;
    selectedMasterAllShaikshanikPrakarTapshilMilkatName = null;

    allShaikshanikPrakarNaavController.clear();
  }

  //=================================================== 16. MAIDAAN UDYAAN FORM ====================================================================================
  List<Vastisarmaidan> maidanUddyanDataList = [];
  int? selectedMaidanUdyanIdIndex;
  int? pkidMaidanUdyan = 0;
  int? isActiveMaidanUdyan = 1;
  TextEditingController maidanUdyanNameControler = TextEditingController();

  void showMaidanUdyanPopup(
    BuildContext context, {
    int? editIndex,
    VoidCallback? onDataChanged,
  }) {
    if (editIndex != null) {
      var data = maidanUddyanDataList[editIndex];
      maidanUdyanNameControler.text = data.name ?? "";
      selectedMaidanUdyanIdIndex = data.id;
      pkidMaidanUdyan = data.pkid;
      isActiveMaidanUdyan = data.isactive;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('MaidaanUdyan')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearShalaPrakarDataListFields();
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textControllerField(
                      "${Statics.getLabel('Name')}",
                      maidanUdyanNameControler,
                      context,
                      height: 50,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Vastisarmaidan data = Vastisarmaidan(
                    id: selectedMaidanUdyanIdIndex,
                    name: maidanUdyanNameControler.text.trim(),
                    pkid: pkidMaidanUdyan,
                    isactive: isActiveMaidanUdyan,
                    vastiid: int.parse(selctedLevelId!),
                  );
                  if (editIndex != null) {
                    maidanUddyanDataList[editIndex] = data;
                  } else {
                    maidanUddyanDataList.add(data);
                  }
                  if (onDataChanged != null) {
                    onDataChanged();
                  }
                  Navigator.of(ctx).pop();
                  maidanUdyanNameControler.clear();
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  //=================================================== 17. JAAHIR KARYAKRAM SAMBANDHI FORM ====================================================================================
  List<VastisarJahirakaryakramasambandhi> jahirKaryakramDataList = [];
  int? selectedjahirKaryakramIdIndex;
  int? selectedJahirKaryakramId;
  int? selectedJahirKaryakramIdEdit;
  String? selectedJahirKaryakramName;
  Masterdata? selectedMasterJahirKaryakramName;
  TextEditingController jahirKaryakramNaavControler = TextEditingController();
  TextEditingController jahirKaryakramShamtaControler = TextEditingController();
  TextEditingController jahirKaryakramNivasControler = TextEditingController();
  int? nivasaSathiUplabdhaYesNo;
  int? isActiveJahirKaryakram = 1;
  int? pkidJahirKaryakram = 0;

  void showjahirKaryakramPopup(
    BuildContext context, {
    int? editIndex,
    VoidCallback? onDataChanged,
  }) {
    if (editIndex != null) {
      var data = jahirKaryakramDataList[editIndex];
      jahirKaryakramNaavControler.text = data.name ?? "";
      jahirKaryakramShamtaControler.text = data.nivaaskshamata ?? "";
      jahirKaryakramNivasControler.text = data.shamta ?? "";
      selectedJahirKaryakramId = data.prakaarid;
      selectedJahirKaryakramIdEdit = data.prakaarid;
      pkidJahirKaryakram = data.pkid;
      isActiveJahirKaryakram = data.isactive;
      selectedJahirKaryakramName = data.selectedDropdownValueName;
      nivasaSathiUplabdhaYesNo = data.nivasasathiupalabdha;
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('jahirKaryakramSambhandhi')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearjahirKaryakram(); // optional reset
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "जाहीरकार्यक्रमसंबंधीप्रकार1",
                      hintText: "${Statics.getLabel('SelectFrequency')}",
                      onItemSelected: (id, value, isOther) {
                        selectedJahirKaryakramId = id;
                        selectedJahirKaryakramName = value;
                      },
                      width: 250,
                      selectedValue: selectedMasterJahirKaryakramName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasterJahirKaryakramName = newValue;
                        });
                      },
                      editId: selectedJahirKaryakramIdEdit,
                      question: "${Statics.getLabel('SelectFrequency')}",
                    ),
                    textControllerField("${Statics.getLabel('Name')}", jahirKaryakramNaavControler, context, height: 50),
                    textControllerField("${Statics.getLabel('shamta')}", jahirKaryakramShamtaControler, context, height: 50),
                    yesNoRadioButton(
                      question: "${Statics.getLabel('NnivaasAvailable')}",
                      onChanged: (value) {
                        if (isVastiSearch) {
                          setState(() {
                            nivasaSathiUplabdhaYesNo = value;
                          });
                        } else {
                          showPopupForVastiValidation(
                            context,
                          );
                        }
                      },
                      selectedOption: nivasaSathiUplabdhaYesNo ?? 2,
                    ),
                    if (nivasaSathiUplabdhaYesNo == 1) textControllerField("${Statics.getLabel('nivaasShamta')}", jahirKaryakramNivasControler, context, height: 50),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  VastisarJahirakaryakramasambandhi data = VastisarJahirakaryakramasambandhi(
                    vastiid: int.parse(selctedLevelId!),
                    isactive: isActiveJahirKaryakram,
                    pkid: pkidJahirKaryakram,
                    name: jahirKaryakramNaavControler.text,
                    selectedDropdownValueName: selectedJahirKaryakramName,
                    nivaaskshamata: jahirKaryakramShamtaControler.text,
                    nivasasathiupalabdha: nivasaSathiUplabdhaYesNo,
                    prakaarid: selectedJahirKaryakramId,
                    shamta: jahirKaryakramNivasControler.text,
                  );
                  if (editIndex != null) {
                    jahirKaryakramDataList[editIndex] = data;
                  } else {
                    jahirKaryakramDataList.add(data);
                  }

                  if (onDataChanged != null) {
                    onDataChanged();
                  }

                  Navigator.of(ctx).pop();
                  clearjahirKaryakram(); // ✅ Clear fields after saving
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearjahirKaryakram() {
    jahirKaryakramNaavControler.clear();
    jahirKaryakramShamtaControler.clear();
    jahirKaryakramNivasControler.clear();
    selectedJahirKaryakramId = null;
    selectedJahirKaryakramIdEdit = null;
    selectedJahirKaryakramName = null;
    selectedMasterJahirKaryakramName = null;
    nivasaSathiUplabdhaYesNo = null;
  }

//========================   Detailed INFO FORM ===========================================
//========================   Detailed INFO FORM ===========================================
//========================   Detailed INFO FORM ===========================================
//========================   Detailed INFO FORM ===========================================

  //=================================================== 18. Vasti Prashna Garja FORM ====================================================================================

  List<VastisarVastitilasamajika> vastiPrashnaGarjaDataList = [];
  int? selectedVastiPrashnaGarjaIdIndex;
  int? selectedVastiPrashnaGarjaId;
  int? selectedVastiPrashnaGarjaIdEdit;
  String? selectedVastiPrashnaGarjaName;
  Masterdata? selectedMasterVastiPrashnaGarjaName;
  int? pkidVastiPrashnaGarjaName = 0;
  int? isActiveVastiPrashnaGarjaName = 1;
  TextEditingController vastiPrashnaGarjaTapshilController = TextEditingController();

  void showVastiPrashnaGarjaPopup(
    BuildContext context, {
    int? editIndex,
    VoidCallback? onDataChanged,
  }) {
    if (editIndex != null) {
      var data = vastiPrashnaGarjaDataList[editIndex];
      selectedVastiPrashnaGarjaId = data.id;
      selectedVastiPrashnaGarjaIdEdit = data.id;
      pkidVastiPrashnaGarjaName = data.pkid;
      isActiveVastiPrashnaGarjaName = data.isactive;
      selectedVastiPrashnaGarjaName = data.selectedDropdownValueName;
      // selectedMasterVastiPrashnaGarjaName = data['vastiPrashnaGarjaObj'];
      vastiPrashnaGarjaTapshilController.text = data.name ?? "";
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${Statics.getLabel('VastiSamajikGarja')}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.purpleAccent)),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearVastiPrashnaGarja();
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "वस्तीतीलसामाजिकप्रश्न/गरजा",
                      hintText: "${Statics.getLabel('VastiSamajikGarja')}",
                      onItemSelected: (id, value, isOther) {
                        selectedVastiPrashnaGarjaId = id;
                        selectedVastiPrashnaGarjaName = value;
                      },
                      width: 250,
                      selectedValue: selectedMasterVastiPrashnaGarjaName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasterVastiPrashnaGarjaName = newValue;
                        });
                      },
                      editId: selectedVastiPrashnaGarjaIdEdit,
                    ),
                    const SizedBox(height: 5),
                    textControllerField("${Statics.getLabel('tapshil')}", vastiPrashnaGarjaTapshilController, context, height: 50),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  VastisarVastitilasamajika data = VastisarVastitilasamajika(
                    name: vastiPrashnaGarjaTapshilController.text,
                    selectedDropdownValueName: selectedVastiPrashnaGarjaName,
                    pkid: pkidVastiPrashnaGarjaName,
                    isactive: isActiveVastiPrashnaGarjaName,
                    vastiid: int.parse(selctedLevelId!),
                    id: selectedVastiPrashnaGarjaId,
                  );
                  if (editIndex != null) {
                    vastiPrashnaGarjaDataList[editIndex] = data;
                  } else {
                    vastiPrashnaGarjaDataList.add(data);
                  }

                  if (onDataChanged != null) {
                    onDataChanged();
                  }
                  Navigator.of(ctx).pop();
                  clearVastiPrashnaGarja();
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearVastiPrashnaGarja() {
    selectedVastiPrashnaGarjaId = null;
    selectedVastiPrashnaGarjaIdEdit = null;
    selectedVastiPrashnaGarjaName = null;
    selectedMasterVastiPrashnaGarjaName = null;
    vastiPrashnaGarjaTapshilController.clear();
  }

  TextEditingController vastiPrashnaAnyaController = TextEditingController();

  //=================================================== 19. DHARMIK NETRUTVA FORM ====================================================================================

  List<Vastisardhaarmiknetrtav> dharmikNetrutvaDataList = [];
  int? selectedDharmikNetrutvaIdIndex;
  int? selectedDharmikNetrutvaId;
  int? selectedDharmikNetrutvaIdEdit;
  String? selectedDharmikNetrutvaName;
  Masterdata? selectedMasterDharmikNetrutvaName;
  int? pkidDharmikNetrutva = 0;
  int? isActiveDharmikNetrutva = 1;

  TextEditingController dharmikNetrutvaController = TextEditingController();
  TextEditingController dharmikNetrutvaAnyaNameController = TextEditingController();

  void showDharmikNetrutvaPopup(
    BuildContext context, {
    int? editIndex,
    VoidCallback? onDataChanged,
  }) {
    if (editIndex != null) {
      var data = dharmikNetrutvaDataList[editIndex];
      selectedDharmikNetrutvaId = data.id;
      selectedDharmikNetrutvaIdEdit = data.id;
      pkidDharmikNetrutva = data.pkid;
      isActiveDharmikNetrutva = data.isactive;
      selectedDharmikNetrutvaName = data.selectedDropdownValueName;
      // selectedMasterDharmikNetrutvaName = data['dharmikNetrutvaObj'];
      dharmikNetrutvaController.text = data.name ?? "";
      dharmikNetrutvaAnyaNameController.text = data.otherNetrutwa ?? "";
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${Statics.getLabel('DharmikNetrutwa')}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.purpleAccent)),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearDharmikNetrutva();
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "धर्मिकनेतृत्व",
                      hintText: "${Statics.getLabel('DharmikNetrutwa')}",
                      onItemSelected: (id, value, isOther) {
                        selectedDharmikNetrutvaId = id;
                        selectedDharmikNetrutvaName = value;
                      },
                      width: 250,
                      selectedValue: selectedMasterDharmikNetrutvaName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasterDharmikNetrutvaName = newValue;
                        });
                      },
                      editId: selectedDharmikNetrutvaIdEdit,
                    ),
                    const SizedBox(height: 5),
                    if (selectedMasterDharmikNetrutvaName?.isOther == 1) textControllerField("${Statics.getLabel('anyaDharmikNetrutva')}", dharmikNetrutvaAnyaNameController, context, height: 50),
                    const SizedBox(height: 5),
                    textControllerField("${Statics.getLabel('Name')}", dharmikNetrutvaController, context, height: 50),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if ((selectedMasterDharmikNetrutvaName?.isOther == 1 && dharmikNetrutvaAnyaNameController.text == "")) {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                  } else {
                    Vastisardhaarmiknetrtav data = Vastisardhaarmiknetrtav(
                      id: selectedDharmikNetrutvaId,
                      vastiid: int.parse(selctedLevelId!),
                      isactive: isActiveDharmikNetrutva,
                      pkid: pkidDharmikNetrutva,
                      selectedDropdownValueName: selectedDharmikNetrutvaName,
                      name: dharmikNetrutvaController.text,
                      otherNetrutwa: dharmikNetrutvaAnyaNameController.text,
                    );
                    if (editIndex != null) {
                      dharmikNetrutvaDataList[editIndex] = data;
                    } else {
                      dharmikNetrutvaDataList.add(data);
                    }

                    if (onDataChanged != null) {
                      onDataChanged();
                    }
                    Navigator.of(ctx).pop();
                    clearDharmikNetrutva();
                  }
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearDharmikNetrutva() {
    selectedDharmikNetrutvaId = null;
    selectedDharmikNetrutvaIdEdit = null;
    selectedDharmikNetrutvaName = null;
    selectedMasterDharmikNetrutvaName = null;
    dharmikNetrutvaController.clear();
    dharmikNetrutvaAnyaNameController.clear();
  }

  TextEditingController dharmikNetrutvaAnyaController = TextEditingController();

  //=================================================== 19. DHARMIK NETRUTVA FORM ====================================================================================
  List<Vastisardurjanshakti> durjanShaktiDataList = [];

  TextEditingController durjanShaktiNaavController = TextEditingController();

  int? selectedDurjanShaktiIdIndex;
  int? selectedDurjanShaktiPrakarId;
  int? selectedDurjanShaktiPrakarIdEdit;
  String? selectedDurjanShaktiPrakarName;
  Masterdata? selectedMasterDurjanShaktiPrakarName;

  int? selectedDurjanShaktiShikshaId;
  int? selectedDurjanShaktiShikshaIdEdit;
  String? selectedDurjanShaktiShikashaName;
  Masterdata? selectedMasterDurjanShaktiShikshaName;

  int? selectedDurjanShaktiGunhaId;
  int? selectedDurjanShaktiGunhaIdEdit;
  String? selectedDurjanShaktiGunhaName;
  Masterdata? selectedMasterDurjanShaktiGunhaName;

  TextEditingController durjanShaktiAnyaPrkarController = TextEditingController();

  int? pkidDurjanShaktiGunha = 0;
  int? isActivedDurjanShaktiGunha = 1;

  void showDurjanShaktiPopup(
    BuildContext context, {
    int? editIndex,
    VoidCallback? onDataChanged,
  }) {
    if (editIndex != null) {
      var data = durjanShaktiDataList[editIndex];
      durjanShaktiNaavController.text = data.name ?? '';
      selectedDurjanShaktiPrakarId = data.prakar;
      selectedDurjanShaktiPrakarIdEdit = data.prakar;
      selectedDurjanShaktiPrakarName = data.selectedDropdownValueName;

      selectedDurjanShaktiShikshaId = data.shiksha;
      selectedDurjanShaktiShikshaIdEdit = data.shiksha;
      selectedDurjanShaktiShikashaName = data.selectedDropdownValueName1;

      selectedDurjanShaktiGunhaId = data.gunha;
      selectedDurjanShaktiGunhaIdEdit = data.gunha;
      selectedDurjanShaktiGunhaName = data.selectedDropdownValueName2;

      durjanShaktiAnyaPrkarController.text = data.otherPrakar ?? "";
      pkidDurjanShaktiGunha = data.pkid;
      isActivedDurjanShaktiGunha = data.isactive;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${Statics.getLabel('DurjanShakti')}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.purpleAccent)),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearDurjanShakti();
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textControllerField("${Statics.getLabel('Name')}", durjanShaktiNaavController, context, height: 50),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "दुर्जनशक्तिप्रकार",
                      hintText: "${Statics.getLabel('SelectFrequency')}",
                      onItemSelected: (id, value, isOther) {
                        selectedDurjanShaktiPrakarId = id;
                        selectedDurjanShaktiPrakarName = value;
                      },
                      width: 250,
                      selectedValue: selectedMasterDurjanShaktiPrakarName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasterDurjanShaktiPrakarName = newValue;
                        });
                      },
                      editId: selectedDurjanShaktiPrakarIdEdit,
                    ),
                    const SizedBox(height: 5),
                    if (selectedMasterDurjanShaktiPrakarName?.isOther == 1) textControllerField("${Statics.getLabel('otherType')}", durjanShaktiAnyaPrkarController, context, height: 50),
                    const SizedBox(height: 5),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "दुर्जनशक्तिशिक्षा",
                      hintText: "${Statics.getLabel('shiksha')}",
                      onItemSelected: (id, value, isOther) {
                        selectedDurjanShaktiShikshaId = id;
                        selectedDurjanShaktiShikashaName = value;
                      },
                      width: 250,
                      selectedValue: selectedMasterDurjanShaktiShikshaName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasterDurjanShaktiShikshaName = newValue;
                        });
                      },
                      editId: selectedDurjanShaktiShikshaIdEdit,
                    ),
                    const SizedBox(height: 5),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "दुर्जनशक्तिगुन्हा",
                      hintText: "${Statics.getLabel('crime')}",
                      onItemSelected: (id, value, isOther) {
                        selectedDurjanShaktiGunhaId = id;
                        selectedDurjanShaktiGunhaName = value;
                      },
                      width: 250,
                      selectedValue: selectedMasterDurjanShaktiGunhaName,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedMasterDurjanShaktiGunhaName = newValue;
                        });
                      },
                      editId: selectedDurjanShaktiGunhaIdEdit,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if ((selectedMasterDurjanShaktiPrakarName?.isOther == 1 && durjanShaktiAnyaPrkarController.text == "")) {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                  } else {
                    Vastisardurjanshakti data = Vastisardurjanshakti(
                        name: durjanShaktiNaavController.text,
                        pkid: pkidDurjanShaktiGunha,
                        isactive: isActivedDurjanShaktiGunha,
                        vastiid: int.parse(selctedLevelId!),
                        selectedDropdownValueName: selectedDurjanShaktiPrakarName,
                        selectedDropdownValueName1: selectedDurjanShaktiShikashaName,
                        selectedDropdownValueName2: selectedDurjanShaktiGunhaName,
                        gunha: selectedDurjanShaktiGunhaId,
                        prakar: selectedDurjanShaktiPrakarId,
                        shiksha: selectedDurjanShaktiShikshaId,
                        otherPrakar: durjanShaktiAnyaPrkarController.text);
                    if (editIndex != null) {
                      durjanShaktiDataList[editIndex] = data;
                    } else {
                      durjanShaktiDataList.add(data);
                    }
                    if (onDataChanged != null) {
                      onDataChanged();
                    }
                    Navigator.of(ctx).pop();
                    clearDurjanShakti();
                  }
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  void clearDurjanShakti() {
    durjanShaktiNaavController.clear();
    durjanShaktiAnyaPrkarController.clear();
    selectedDurjanShaktiPrakarId = null;
    selectedDurjanShaktiPrakarIdEdit = null;
    selectedDurjanShaktiPrakarName = null;
    selectedMasterDurjanShaktiPrakarName = null;

    selectedDurjanShaktiShikshaId = null;
    selectedDurjanShaktiShikshaIdEdit = null;
    selectedDurjanShaktiShikashaName = null;
    selectedMasterDurjanShaktiShikshaName = null;

    selectedDurjanShaktiGunhaId = null;
    selectedDurjanShaktiGunhaIdEdit = null;
    selectedDurjanShaktiGunhaName = null;
    selectedMasterDurjanShaktiGunhaName = null;
  }

//========================================   HINDU VEER YAADI =====================================================
  List<VastisarHinduvirayadi> hinduVeerYadiDataList = [];
  int? selectedHinduVeerYadiIdIndex;
  int? pkidHinduVeerYadi = 0;
  int? isActiveHinduVeerYadi = 1;
  TextEditingController hinduVeerYadiNameControler = TextEditingController();

  void showHinduVeerYadiPopup(
    BuildContext context, {
    int? editIndex,
    VoidCallback? onDataChanged,
  }) {
    if (editIndex != null) {
      var data = hinduVeerYadiDataList[editIndex];
      hinduVeerYadiNameControler.text = data.name ?? "";
      selectedHinduVeerYadiIdIndex = data.id;
      isActiveHinduVeerYadi = data.isactive;
      pkidHinduVeerYadi = data.pkid;
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('HinduVeer')}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purpleAccent,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                  clearShalaPrakarDataListFields();
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textControllerField(
                      "${Statics.getLabel('Name')}",
                      hinduVeerYadiNameControler,
                      context,
                      height: 50,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Map<String, dynamic> data = {
                  //   'hinduVeerYadiName': hinduVeerYadiNameControler.text.trim(), // ✅ fixed this line
                  // };
                  VastisarHinduvirayadi data = VastisarHinduvirayadi(
                    vastiid: int.parse(selctedLevelId!),
                    isactive: isActiveHinduVeerYadi,
                    pkid: pkidHinduVeerYadi,
                    name: hinduVeerYadiNameControler.text,
                    id: selectedHinduVeerYadiIdIndex,
                  );

                  if (editIndex != null) {
                    hinduVeerYadiDataList[editIndex] = data;
                  } else {
                    hinduVeerYadiDataList.add(data);
                  }

                  if (onDataChanged != null) {
                    onDataChanged();
                  }

                  Navigator.of(ctx).pop();
                  hinduVeerYadiNameControler.clear();
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          if (isVastiSearch == true)
            if (step3completepercentage != null)
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    dynamicProgressBar(context: context, value: double.parse(step3completepercentage.toString()), detailListItems: step3pendingpoints!.split(',')),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        // Filter out empty or whitespace-only strings
                        final filteredDetails = step3pendingpoints!.split(',').where((item) => item.trim().isNotEmpty).toList();

                        print("Filtered step3pendingpoints!.split(','): $filteredDetails");

                        if (filteredDetails.isEmpty) {
                          Statics.showToast(Statics.getLabel('allInfoSubmit'));
                          return;
                        }

                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon and Title
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
                                        SizedBox(width: 8),
                                        Text(
                                          Statics.getLabel('remainingQuestion'),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 300,
                                      child: ListView.builder(
                                        itemCount: filteredDetails.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              "${index + 1}. ${filteredDetails[index]}",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text(Statics.getLabel('bandKara')),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.red.shade300,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "${Statics.getLabel('remainingQuestion')}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          //=====================  SAMAJIK PRASHANA AND GARJA ================================================================
          mainContainer(
              "${Statics.getLabel('VastiSamajikGarja')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isVastiSearch) {
                            showVastiPrashnaGarjaPopup(context, onDataChanged: () {
                              setState(() {});
                            });
                          } else {
                            showPopupForVastiValidation(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 100,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('AddButton')}",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              showCheckboxColumn: false,
                              headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                              headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                              columns: [
                                DataColumn(
                                    label: Text(
                                  "${Statics.getLabel('VastiSamajikGarja')}",
                                )),
                                DataColumn(
                                    label: Center(
                                  child: Text(
                                    "${Statics.getLabel('tapshil')}",
                                  ),
                                )),
                              ],
                              rows: vastiPrashnaGarjaDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                int index = entry.key;
                                var data = entry.value;
                                bool isSelected = selectedVastiPrashnaGarjaIdIndex == index;
                                return DataRow(
                                    selected: isSelected,
                                    color: MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        if (isSelected) return Colors.yellow.shade100;
                                        return null;
                                      },
                                    ),
                                    onSelectChanged: (bool? selected) {
                                      if (selected != null && selected) {
                                        setState(() {
                                          selectedVastiPrashnaGarjaIdIndex = index;
                                        });
                                      }
                                    },
                                    cells: [
                                      DataCell(Text(data.selectedDropdownValueName ?? '')),
                                      DataCell(Text(data.name ?? '')),
                                    ]);
                              }).toList(),
                            )),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (selectedVastiPrashnaGarjaIdIndex != null) {
                                  var selectedData = vastiPrashnaGarjaDataList[selectedVastiPrashnaGarjaIdIndex!];
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Center(
                                          child: Text(
                                            "${Statics.getLabel('VastiSamajikGarja')}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('VastiSamajikGarja')}", selectedData.selectedDropdownValueName),
                                              _buildInfoRow("${Statics.getLabel('tapshil')}", selectedData.name),
                                            ],
                                          ),
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.purpleAccent,
                                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                showVastiPrashnaGarjaPopup(context, editIndex: selectedVastiPrashnaGarjaIdIndex, onDataChanged: () {
                                  setState(() {});
                                });
                              },
                              child: Icon(Icons.edit, color: Colors.blue, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('pusthikarn')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        "${Statics.getLabel('deleteconfirmText')}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade300,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationNo')}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationYes')}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (shouldDelete == true && selectedVastiPrashnaGarjaIdIndex != null) {
                                  setState(() {
                                    vastiPrashnaGarjaDataList[selectedVastiPrashnaGarjaIdIndex!].isactive = 0;
                                    selectedVastiPrashnaGarjaIdIndex = null;
                                  });
                                }
                              },
                              child: Icon(Icons.delete, color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          //=====================  DHARMIK NETRUTVA  ================================================================
          mainContainer(
              "${Statics.getLabel('DharmikNetrutwa')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isVastiSearch) {
                            showDharmikNetrutvaPopup(context, onDataChanged: () {
                              setState(() {});
                            });
                          } else {
                            showPopupForVastiValidation(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 100,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('AddButton')}",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: DataTable(
                                columnSpacing: 20,
                                showCheckboxColumn: false,
                                headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('DharmikNetrutwa')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('Name')}",
                                  )),
                                ],
                                rows: dharmikNetrutvaDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                  int index = entry.key;
                                  var data = entry.value;
                                  bool isSelected = selectedDharmikNetrutvaIdIndex == index;
                                  return DataRow(
                                      selected: isSelected,
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                          if (isSelected) return Colors.yellow.shade100;
                                          return null;
                                        },
                                      ),
                                      onSelectChanged: (bool? selected) {
                                        if (selected != null && selected) {
                                          setState(() {
                                            selectedDharmikNetrutvaIdIndex = index;
                                          });
                                        }
                                      },
                                      cells: [
                                        DataCell(Text(data.selectedDropdownValueName ?? '')),
                                        DataCell(Text(data.name ?? '')),
                                      ]);
                                }).toList(),
                              ),
                            )),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (selectedDharmikNetrutvaIdIndex != null) {
                                  var selectedData = dharmikNetrutvaDataList[selectedDharmikNetrutvaIdIndex!];
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Center(
                                          child: Text(
                                            "${Statics.getLabel('DharmikNetrutwa')}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('DharmikNetrutwa')}", selectedData.selectedDropdownValueName),
                                              _buildInfoRow("${Statics.getLabel('anyaDharmikNetrutva')}", selectedData.otherNetrutwa),
                                              _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                            ],
                                          ),
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.purpleAccent,
                                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                showDharmikNetrutvaPopup(context, editIndex: selectedDharmikNetrutvaIdIndex, onDataChanged: () {
                                  setState(() {});
                                });
                              },
                              child: Icon(Icons.edit, color: Colors.blue, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('pusthikarn')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        "${Statics.getLabel('deleteconfirmText')}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade300,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationNo')}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationYes')}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (shouldDelete == true && selectedDharmikNetrutvaIdIndex != null) {
                                  setState(() {
                                    dharmikNetrutvaDataList[selectedDharmikNetrutvaIdIndex!].isactive = 0;
                                    selectedDharmikNetrutvaIdIndex = null;
                                  });
                                }
                              },
                              child: Icon(Icons.delete, color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          //=====================  DHARMIK NETRUTVA  ================================================================
          mainContainer(
              "${Statics.getLabel('DurjanShakti')}",
              Column(
                children: [
                  yesNoRadioButton(
                      question: "${Statics.getLabel('isDurjanShakti')}",
                      selectedOption: durjanShaktiYesNo ?? 2,
                      onChanged: (value) {
                        if (isVastiSearch) {
                          setState(() {
                            durjanShaktiYesNo = value;
                          });
                        } else {
                          showPopupForVastiValidation(
                            context,
                          );
                        }
                      }),
                  if (durjanShaktiYesNo == 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (isVastiSearch) {
                              showDurjanShaktiPopup(context, onDataChanged: () {
                                setState(() {});
                              });
                            } else {
                              showPopupForVastiValidation(context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            width: 100,
                            decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: Colors.white, size: 15),
                                  SizedBox(width: 5),
                                  Text(
                                    "${Statics.getLabel('AddButton')}",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (durjanShaktiYesNo == 1) SizedBox(height: 20),
                  if (durjanShaktiYesNo == 1)
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: DataTable(
                                  columnSpacing: 20,
                                  showCheckboxColumn: false,
                                  headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                      "${Statics.getLabel('Name')}",
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "${Statics.getLabel('SelectFrequency')}",
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "${Statics.getLabel('shiksha')}",
                                    )),
                                    DataColumn(
                                        label: Text(
                                      "${Statics.getLabel('crime')}",
                                    )),
                                  ],
                                  rows: durjanShaktiDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                    int index = entry.key;
                                    var data = entry.value;
                                    bool isSelected = selectedDurjanShaktiIdIndex == index;
                                    return DataRow(
                                        selected: isSelected,
                                        color: MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                            if (isSelected) return Colors.yellow.shade100;
                                            return null;
                                          },
                                        ),
                                        onSelectChanged: (bool? selected) {
                                          if (selected != null && selected) {
                                            setState(() {
                                              selectedDurjanShaktiIdIndex = index;
                                            });
                                          }
                                        },
                                        cells: [
                                          DataCell(Text(data.name ?? '')),
                                          DataCell(Text(data.selectedDropdownValueName ?? '')),
                                          DataCell(Text(data.selectedDropdownValueName1 ?? '')),
                                          DataCell(Text(data.selectedDropdownValueName2 ?? '')),
                                        ]);
                                  }).toList(),
                                ),
                              )),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (selectedDurjanShaktiIdIndex != null) {
                                    var selectedData = durjanShaktiDataList[selectedDurjanShaktiIdIndex!];
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.white,
                                          title: Center(
                                            child: Text(
                                              "${Statics.getLabel('DharmikNetrutwa')}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.purpleAccent,
                                              ),
                                            ),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                                SizedBox(height: 12),
                                                _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                                _buildInfoRow("${Statics.getLabel('SelectFrequency')}", selectedData.selectedDropdownValueName),
                                                _buildInfoRow("${Statics.getLabel('otherType')}", selectedData.otherPrakar),
                                                _buildInfoRow("${Statics.getLabel('shiksha')}", selectedData.selectedDropdownValueName1),
                                                _buildInfoRow("${Statics.getLabel('crime')}", selectedData.selectedDropdownValueName2),
                                              ],
                                            ),
                                          ),
                                          actionsAlignment: MainAxisAlignment.center,
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.purpleAccent,
                                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  showDurjanShaktiPopup(context, editIndex: selectedDurjanShaktiIdIndex, onDataChanged: () {
                                    setState(() {});
                                  });
                                },
                                child: Icon(Icons.edit, color: Colors.blue, size: 20),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Colors.white,
                                      title: Center(
                                        child: Text(
                                          "${Statics.getLabel('pusthikarn')}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Text(
                                          "${Statics.getLabel('deleteconfirmText')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey.shade300,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text(
                                            "${Statics.getLabel('ConfirmationNo')}",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text(
                                            "${Statics.getLabel('ConfirmationYes')}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (shouldDelete == true && selectedDurjanShaktiIdIndex != null) {
                                    setState(() {
                                      durjanShaktiDataList[selectedDurjanShaktiIdIndex!].isactive = 0;
                                      selectedDurjanShaktiIdIndex = null;
                                    });
                                  }
                                },
                                child: Icon(Icons.delete, color: Colors.red, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              )),
//================================== HINDU VEER YAADI FORM =================================================================================================================================================
          mainContainer(
              "${Statics.getLabel('HinduVeer')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isVastiSearch) {
                            showHinduVeerYadiPopup(context, onDataChanged: () {
                              setState(() {});
                            });
                          } else {
                            showPopupForVastiValidation(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: 100,
                          decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100), color: Colors.purpleAccent.withOpacity(0.7), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  "${Statics.getLabel('AddButton')}",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: DataTable(
                                columnSpacing: 20,
                                showCheckboxColumn: false,
                                headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('serialNo')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('Name')}",
                                  )),
                                ],
                                rows: hinduVeerYadiDataList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                  int index = entry.key;
                                  var data = entry.value;
                                  bool isSelected = selectedHinduVeerYadiIdIndex == index;
                                  return DataRow(
                                      selected: isSelected,
                                      color: MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                          if (isSelected) return Colors.yellow.shade100;
                                          return null;
                                        },
                                      ),
                                      onSelectChanged: (bool? selected) {
                                        if (selected != null && selected) {
                                          setState(() {
                                            selectedHinduVeerYadiIdIndex = index;
                                          });
                                        }
                                      },
                                      cells: [
                                        DataCell(Text("${index + 1}")),
                                        DataCell(Text(data.name ?? '')),
                                      ]);
                                }).toList(),
                              ),
                            )),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                if (selectedHinduVeerYadiIdIndex != null) {
                                  var selectedData = hinduVeerYadiDataList[selectedHinduVeerYadiIdIndex!];
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.white,
                                        title: Center(
                                          child: Text(
                                            "${Statics.getLabel('HinduVeer')}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Divider(thickness: 1, color: Colors.deepPurple.shade100),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('Name')}", selectedData.name),
                                            ],
                                          ),
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("${Statics.getLabel('bandKara')}", style: TextStyle(color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.purpleAccent,
                                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                showHinduVeerYadiPopup(context, editIndex: selectedHinduVeerYadiIdIndex, onDataChanged: () {
                                  setState(() {});
                                });
                              },
                              child: Icon(Icons.edit, color: Colors.blue, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "${Statics.getLabel('pusthikarn')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Text(
                                        "${Statics.getLabel('deleteconfirmText')}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade300,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationNo')}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text(
                                          "${Statics.getLabel('ConfirmationYes')}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (shouldDelete == true && selectedHinduVeerYadiIdIndex != null) {
                                  setState(() {
                                    hinduVeerYadiDataList[selectedHinduVeerYadiIdIndex!].isactive = 0;
                                    selectedHinduVeerYadiIdIndex = null;
                                  });
                                }
                              },
                              child: Icon(Icons.delete, color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                      ),
//============================================================================================================================================================
                      Divider(thickness: 2),
                      InkWell(
                        onTap: () {
                          submitStep3Form();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.purpleAccent,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.5),
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "${Statics.getLabel('visrutMahitiSubmit')}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Future<void> submitStep3Form() async {
    Map<String, dynamic> formData = {
      "vastiid": int.parse(selctedLevelId!),
      "cuserid": int.parse(Statics.userDetails['userID']),
      "VastisarVastitilasamajika": vastiPrashnaGarjaDataList,
      "Vastisardhaarmiknetrtav": dharmikNetrutvaDataList,
      "Vastisardurjanshakti": durjanShaktiDataList,
      "VastisarHinduvirayadi": hinduVeerYadiDataList,
      "isdurjanskhatti": durjanShaktiYesNo,
      "Vastitilasamajikaque": "",
      "anyadhaarmik": "",
    };
    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Step 3 Form Data (JSON):\n$formattedJson");
    Statics.vastiSarvekshanStep3FormSubmit(context, jsonEncode(formData));
    await Future.delayed(Duration(seconds: 2));
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    searchVastiData(selctedLevelId);
  }

  // Widget dynamicProgressBar(double value) {
  //   final progress = (value / 100).clamp(0.0, 1.0);
  //   return TweenAnimationBuilder<double>(
  //     tween: Tween<double>(begin: 0, end: progress),
  //     duration: const Duration(milliseconds: 800),
  //     builder: (context, animatedProgress, _) {
  //       return Stack(
  //         children: [
  //           Container(
  //             width: 300,
  //             height: 24,
  //             decoration: BoxDecoration(
  //               color: Colors.grey,
  //               borderRadius: BorderRadius.circular(12),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.black12,
  //                   blurRadius: 4,
  //                   offset: Offset(0, 2),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(12),
  //             child: Container(
  //               width: 300 * animatedProgress,
  //               height: 24,
  //               decoration: const BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [Colors.deepOrange, Colors.deepOrangeAccent],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Positioned.fill(
  //             child: Center(
  //               child: Text(
  //                 "${value.toInt()}% ${Statics.getLabel('surveyCompleted')}",
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 13,
  //                   color: Colors.white,
  //                   shadows: [
  //                     Shadow(
  //                       offset: Offset(0.5, 0.5),
  //                       blurRadius: 2.0,
  //                       color: Colors.black45,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  Widget dynamicProgressBar({
    required BuildContext context,
    required double value,
    required List<String> detailListItems,
  }) {
    final progress = (value / 100).clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(milliseconds: 800),
      builder: (context, animatedProgress, _) {
        return Stack(
          children: [
            Container(
              width: 300,
              height: 24,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFcfd8dc), Color(0xFF90a4ae)], // Blue-grey background
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 300 * animatedProgress,
                height: 24,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFEA80FC),
                      Colors.purpleAccent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${value.toInt()}% ${Statics.getLabel('surveyCompleted')}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2.5,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
