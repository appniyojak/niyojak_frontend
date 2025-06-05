import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/get_vasti_data_by_id_model.dart';
import '../../../models/response_model/vasti_sarvekshan_dropdown_model.dart';
import '../../../providers/bals.dart';

class MandalSurveyFormScreen extends StatefulWidget {
  static const String routeName = '/mandal-survey';
  const MandalSurveyFormScreen({super.key});

  @override
  State<MandalSurveyFormScreen> createState() => _MandalSurveyFormScreenState();
}

class _MandalSurveyFormScreenState extends State<MandalSurveyFormScreen> with SingleTickerProviderStateMixin {

  final TextEditingController sanghaKaryaVastiPramukhNameController = TextEditingController();
  final TextEditingController sanghaKaryaVastiStithiController = TextEditingController();
  final TextEditingController vastiChatahuSimaController = TextEditingController();
  final TextEditingController niyamitChalnareUpkramGatividhiController = TextEditingController();
  final TextEditingController vsahatPrakarDurbhashController = TextEditingController();
  final TextEditingController vastitHonareSamajikAnyakaryakramController = TextEditingController();
  final TextEditingController sarpanchDoorbhasController = TextEditingController();
  final TextEditingController sarpanchNameController = TextEditingController();

  String? selectedFilePath;
  GetVastiDataByIdModel? vastiDataByIdModel;

  Future<dynamic> searchVastiData(String? vastiId) async {
    // resetData();
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "vastiid": selctedLevelId,
        "isVasti": 0,
        "AppUserID":Statics.userDetails['userID'],
      });
      print("searchVastiData req param :-  $strInput");
      vastiDataByIdModel = await Statics.getVastidataByIDForApp(strInput);
      setDataAfterSearch();
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
  }

  void setDataAfterSearch() async {
    setState(() {
      gavatilMumbaikar = vastiDataByIdModel!.vastisarvekshan!.isGavatilMumbaikar;
      anyaVividhKshetracheKame = vastiDataByIdModel!.vastisarvekshan!.anyaVividhKshetracheKame;
      gavatilMumbaikarEnteredDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarGavatilMumbaikar ?? [];
      vividhadhyatmitStsangKendraEnteredDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVividhAdhyatmikKendra ?? [];
      vividhKshetaCHeKamEnteredDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVividhKshetracheKam ?? [];
      sewaPrakalpaEnteredDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarSewaPrakalpa ?? [];
      vadiGharLoksankhyaEnteredDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVadiGharLoksankhya ?? [];
      sarpanchNameController.text =  vastiDataByIdModel!.vastisarvekshan!.sarpanchacheNaav == null ?"":vastiDataByIdModel!.vastisarvekshan!.sarpanchacheNaav! ;
      sarpanchDoorbhasController.text =  vastiDataByIdModel!.vastisarvekshan!.sarpanchacheDoorbhash == null ?"":vastiDataByIdModel!.vastisarvekshan!.sarpanchacheDoorbhash! ;
      sanghaKaryaVastiStithiController.text = vastiDataByIdModel!.vastisarvekshan!.vastiShakhaType == null ?"":vastiDataByIdModel!.vastisarvekshan!.vastiShakhaType! ;
      sanghaKaryaVastiPramukhNameController.text = vastiDataByIdModel!.vastisarvekshan!.vastiShakhaPramukhName ?? "";
      loksankhyaController.text = vastiDataByIdModel!.vastisarvekshan!.lokasankhya ?? "";
      vadicheNaavController.text = vastiDataByIdModel!.vastisarvekshan!.vadicheNave ?? "";
      andajeGhareController.text = vastiDataByIdModel!.vastisarvekshan!.andajeGhare ?? "";
      gaavSamitiYesNo = int.parse(vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti == null ||vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti! == "null" || vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti == "" ? "2":vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti!);
      beforsanghaonnowisoff = vastiDataByIdModel!.vastisarvekshan!.beforeShakhaSaptahikIsOnNowOff == null ?  2 : vastiDataByIdModel!.vastisarvekshan!.beforeShakhaSaptahikIsOnNowOff;
      kuthalaVarshiDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarKuthalyavarsi ?? [];
      vastiChatahuSimaController.text = vastiDataByIdModel!.vastisarvekshan!.vasticyacatuSima ?? "";
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
      /// STEP 3 FORM DATA =====================================================================================================
      vastiPrashnaGarjaDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVastitilasamajika ?? [];
      dharmikNetrutvaDataList = vastiDataByIdModel!.vastisarvekshan!.vastisardhaarmiknetrtav ?? [];
      durjanShaktiDataList = vastiDataByIdModel!.vastisarvekshan!.vastisardurjanshakti ?? [];
      hinduVeerYadiDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarHinduvirayadi ?? [];
      // ============================================================================================================================================================================
      _isStep1Completed = vastiDataByIdModel!.vastisarvekshan!.stepOneComplete ?? true;
      _isStep2Completed = vastiDataByIdModel!.vastisarvekshan!.stepTwoComplete ?? true;
      print("_isStep1Completed $_isStep1Completed ----   _isStep2Completed $_isStep2Completed");
    });
  }

  void resetData() async {
    setState(() {
      sarpanchDoorbhasController.clear();
      sarpanchNameController.clear();
      sanghaKaryaVastiStithiController.clear();
      sanghaKaryaVastiPramukhNameController.clear();
      loksankhyaController.clear();
      vadicheNaavController.clear();
      andajeGhareController.clear();
      gaavSamitiYesNo = 2;
      beforsanghaonnowisoff = 2;
      kuthalaVarshiDataList = [];
      vividhadhyatmitStsangKendraEnteredDataList = [];
      sewaPrakalpaEnteredDataList = [];
      vadiGharLoksankhyaEnteredDataList = [];
      vastiChatahuSimaController.clear();
      jagranShreniEnteredDataList = [];
      vividhKshetaCHeKamEnteredDataList = [];
      anyaVividhKshetracheKame = 2;
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

      /// STEP 2 FORM DATA

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
      _linkedmandalValue = '';
      selctedLevelId = '';
      selctedLevelName = "";
      _linkedBhaag = null;
      _linkedNagar = null;
      _linkedvasti = null;
      _linkedmandal = null;
      _linkedgraam = null;
      _linkedgraamValue = null;
      isVastiSearch = false;
      selctedLevelName = '';
    });
  }


  void showPopupForVastiValidation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "सूचना",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
            fontSize: 18,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "माहिती भरण्यापूर्वी गाव निवडणे अनिवार्य आहे.",
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
              "ठीक",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  void showPopupForNaviagtetoOtherPage(BuildContext context, String pageName1,String pageName2,) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "सूचना",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
            fontSize: 18,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "$pageName2 भरण्यापूर्वी $pageName1 भरणे अनिवार्य आहे.\n $pageName1 संग्रह केल्यानंतर $pageName2 भरता येईल.",
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
              "ठीक",
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
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;
  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedNagarValue = '';
  String? _linkedgraamValue = '';
  String? _linkedmandalValue = '';
  String? _linkedvastiValue = '';
  String? mahanagarId = '';
  String? vibhagId = '';
  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? selctedLevelNameNew = '';
  String? selctedLevelIdNew = '';
  int? beforsanghaonnowisoff = 2 ;
  int? anyaVividhKshetracheKame = 2;
  int? gavatilMumbaikar = 2;
  int? agniShamanDalKendraAhe = 2;
  int? polichChoukiAhe = 2;
  int? gaavSamitiYesNo = 2;
  // String? _getValidDropdownValue() {
  //   if (_linkedgraamValue != "" && _linkedgraam!.any((bg) => bg.geoUnitID.toString() == _linkedgraamValue)) {
  //     return _linkedgraamValue;
  //   } else if (selectedVividhAAdhyatmikKendraGaavIDEdit != "" &&
  //       _linkedgraam!.any((bg) => bg.geoUnitID.toString() == selectedVividhAAdhyatmikKendraGaavIDEdit)) {
  //     return selectedVividhAAdhyatmikKendraGaavIDEdit;
  //   }
  //   return null;
  // }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    populatelinkedMahaanagarDropdown();
    populatelinkedVibhaagDropdown('');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    // print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForMandal(
        Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
    setState(() {
      _linkedVibhaag = data;
    });
    return data;
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    _linkedNagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;

    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkedNagar = (ngDD.length > 0 ? ngDD : null);
      });
      return ngDD;
    }
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedMandalDropdown(String nagarIDStr) async {
    _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParentForMandal(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    print("mandalIDStr mandalIDStr ==> $mandalIDStr");
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
    // log("_linkedgraam_linkedgraam --> $_linkedgraam");
    return gmDD;
  }

  late TabController _tabController;
  bool? _isStep1Completed = false;
  bool? _isStep2Completed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    populateDropdown();
    fetchVastiSurveyDropdownData();
    _tabController.addListener(_handleTabSelection);
  }
  void _handleTabSelection() {
    if (_tabController.index == 1 && !_isStep1Completed!) {
      showPopupForNaviagtetoOtherPage(context, "प्राथमिक माहिती", "अन्य माहिती");
      _tabController.index = 0;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          Statics.getLabel('mandalSurvey'),
          style: TextStyle(fontSize: 24),
        ),
        bottom:TabBar(
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
            Tab(text: Statics.getLabel('detailedInfo')),
            // Tab(text: Statics.getLabel('detailedInfo')),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            _buildStep1(),
            _buildStep3(),
          ],
        ),
      ),
    );
  }
  //=======================================================================================================================================================================================================
  // Widget textControllerField2({
  //   required String name,
  //   required TextEditingController controller,
  //   double height = 50.0,
  //   TextInputType keyboardType = TextInputType.text,
  //   bool isEdit = false,
  //   String? hintTextString,
  //   int? maxInput
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         name,
  //         style: TextStyle(
  //           fontSize: 15,
  //           fontWeight: FontWeight.bold
  //         ),
  //       ),
  //       SizedBox(height: 5),
  //       Container(
  //         height: height,
  //         child: TextFormField(
  //           controller: controller,
  //           keyboardType: keyboardType,
  //           decoration: InputDecoration(
  //               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  //               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //               filled: true,
  //               fillColor: Colors.white, // Background color
  //               hintText: hintTextString
  //           ),
  //           readOnly:isVastiSearch == false? true: isEdit,
  //           onTap: (){
  //             if (isVastiSearch) {
  //               print("Nothing");
  //             } else {
  //               showPopupForVastiValidation(context);
  //             }
  //           },
  //           maxLength: maxInput,
  //         ),
  //       ),
  //       SizedBox(height: 10),
  //     ],
  //   );
  // }
  Widget textControllerField2({
    required String name,
    required TextEditingController controller,
    double height = 50.0,
    TextInputType keyboardType = TextInputType.text,
    bool isEdit = false,
    String? hintTextString,
    String? imp,
    int? maxInput
  }) {
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
            inputFormatters: keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))]
                : [],
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
              onTap: (){
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
              onChanged: isDisable ? null : (value) {
                if (value != null) onChanged(value);
              },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              'होय',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(width: 20),
            Radio<int>(
              value: 0,
              groupValue: selectedOption,
              onChanged: isDisable ? null : (value) {
                if (value != null) onChanged(value);
              },
              activeColor: Colors.purpleAccent,
            ),
            Text(
              'नाही',
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
          Text(header,style: TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.bold,fontSize: 18,),),
          Divider(color: Colors.black87, thickness: 1),SizedBox(height: 10,),
          child,
        ],),);}
  //======================================================================================================================================================================================================
  Widget vastisarvekshanDropdown2({
    required VastisarvekshanDropDownDataModel dataModel,
    required String filterTypeName,
    required String hintText,
    required Function(int?, String?,int?) onItemSelected,
    String? question,
    double? width,
    int? questionNumber,
    int? editId,
    Masterdata? selectedValue,
    Function(Masterdata?)? onSelectionChanged,
  }) {
    List<Masterdata> filteredList = dataModel.masterdata!
        .where((item) => item.typename == filterTypeName)
        .toList();

    Masterdata? selectedItem = selectedValue;
    if (selectedItem == null && editId != null) {
      try {
        selectedItem = filteredList.firstWhere((item) => item.id == editId);
        onItemSelected(selectedItem.id, selectedItem.value,selectedItem.isOther);
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
                  onItemSelected(newValue.id, newValue.value,newValue.isOther);
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
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey,),borderRadius: BorderRadius.all(Radius.circular(15))),
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
                      title: Text("गाव निवडा",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                      trailing: IconButton(onPressed: (){
                        resetData();
                      }, icon: Icon(Icons.refresh,color: Colors.purpleAccent,)),
                    );
                  },
                  body: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                                                // if(_linkedMahaanagar != null)
                        //   DropdownButtonFormField(
                        //     decoration: InputDecoration(labelText: "महानगर"),
                        //     isExpanded: true,
                        //     value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                        //     items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(
                        //       value: bg.geoUnitID.toString(),
                        //       child: Text(bg.name!),
                        //     )).toList(),
                        //     onChanged: (value) {
                        //       final selectedItem = _linkedMahaanagar!.firstWhere(
                        //               (bg) => bg.geoUnitID.toString() == value);
                        //       setState(() {
                        //         _linkedMahaanagarValue = value;
                        //         _linkedVibhaagValue = null;
                        //         _linkedBhaagValue = null;
                        //         _linkedNagarValue = null;
                        //         populatelinkedVibhaagDropdown(value!);
                        //         mahanagarId = value;
                        //         selctedLevelId = value;
                        //         selctedLevelName = selectedItem.name ?? "";
                        //         selctedLevel = 'Mahanagar';
                        //       });
                        //       print("Selected Id: $value");
                        //       print("Selected Level Name: ${selectedItem.name}");
                        //     },
                        //   ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        if(_linkedVibhaag != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: "विभाग"),
                            isExpanded: true,
                            value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                            items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedVibhaag!.firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
                              print(value);
                              setState(() {
                                _linkedVibhaagValue = value;
                                populatelinkedBhaagDropdown(value!);
                                vibhagId = value;
                                _linkedBhaagValue  = _linkedNagarValue  = null;
                                _linkedBhaag  = _linkedNagar = null;
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
                        if(_linkedBhaag != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: "भाग/जिल्हा"),
                            isExpanded: true,
                            value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                            items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedBhaag!.firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
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
                            decoration: InputDecoration(labelText: "तालुका"),
                            isExpanded: true,
                            value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                            items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedNagar!.firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedNagarValue = value;
                                populatelinkedMandalDropdown(value!);
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
                        if (_linkedmandal != null && _linkedmandal!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: "मंडल"),
                            isExpanded: true,
                            value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                            items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedmandal!.firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedmandalValue = value;
                                selctedLevelId = value;
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Mandal';
                                populatelinkedGraamDropdown(value!);
                              });
                              print("Selected Id: $value");
                              print("Selected Level Name: ${selectedItem.name}");
                            },
                          ),
                        if (_linkedmandal != null && _linkedmandal!.length > 0)
                          SizedBox(height: 10,),
                        if (_linkedgraam != null && _linkedgraam!.length > 0)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: "गाव"),
                            isExpanded: true,
                            value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                            items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                            onChanged: (value) {
                              final selectedItem = _linkedgraam!.firstWhere(
                                      (bg) => bg.geoUnitID.toString() == value);
                              setState(() {
                                _linkedgraamValue = value;
                                selctedLevelId = value;
                                selctedLevelName = selectedItem.name ?? "";
                                selctedLevel = 'Graam';
                              });
                              print("Selected Id: $value");
                              print("Selected Level Name: ${selectedItem.name}");
                            },
                          ),
                        if (_linkedgraam != null && _linkedgraam!.length > 0)
                          SizedBox(height: 10,),
                        if(selctedLevel == "Graam")
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                              onPressed: (){
                                if(selctedLevel == "Graam"){
                                  setState(() {
                                    isVastiSearch = true;
                                    _isExpanded = false;
                                  });
                                  print("selctedLevel $selctedLevel -- selctedLevelId $selctedLevelId -- selctedLevelName $selctedLevelName");
                                  searchVastiData(selctedLevelId);
                                }else{
                                  Statics.showToast(Statics.getLabel('mandalValidation'));
                                }
                              },
                              child: Text("निवडा", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          if(isVastiSearch == false)SizedBox(height: 10,),
          if(isVastiSearch == false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "टीप :- माहिती भरण्यापूर्वी गाव निवडणे अनिवार्य आहे.",
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
          if(selctedLevel == "Graam" && selctedLevelName != "" && isVastiSearch == true)
            SizedBox(height: 20,),
          if(selctedLevel == "Graam" && selctedLevelName != "" && isVastiSearch == true)
            Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent,width: 1),borderRadius: BorderRadius.all(Radius.circular(15)),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("गाव ->  ",style: TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.bold,fontSize: 16),),
                    Text(" $selctedLevelName",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),),
                  ],
                )),
          if(isVastiSearch == true)
            SizedBox(height: 20,),
          if(isVastiSearch == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Icon(Icons.remove_red_eye, color: Colors.green, size: 15),
                    Icon(Icons.edit, color: Colors.blue, size: 15),
                    Icon(Icons.delete, color: Colors.red, size: 15),
                    Text(
                      "करीता पंक्ती (Row) निवडणे आवश्यक आहे.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  "आकडे हे पूर्णांक (Whole Numbers) मध्ये भरणे अनिवार्य आहे. उ.दा... (0123)",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          SizedBox(height: 20,),
// =====================================  SANGHA KARYA  STITHI ==================================================================================
          mainContainer("संघ कार्य",Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if (isVastiSearch) {
                              showVadiGharLoksankhyaPopup(context, onDataChanged: () {
                                setState(() {});
                              });
                            } else {
                              showPopupForVastiValidation(context,);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            width: 100,
                            decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: Colors.white, size: 15),
                                  Text(
                                    "नवीन",
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
                    GestureDetector(
                      behavior: HitTestBehavior.translucent, // ensures tap detection even on empty areas
                      onTap: () {
                        FocusScope.of(context).unfocus(); // dismiss keyboard if any
                        setState(() {
                          selectedvadiGharLoksankhyaIndex = null; // deselect row
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1.5,
                            child: DataTable(
                              showCheckboxColumn: false,
                              headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                              columnSpacing: 30,
                              horizontalMargin: 16,
                              headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                              columns: const [
                                DataColumn(label: Text("वाडी/पाड्याचे नाव",)),
                                DataColumn(label: Text("अंदाजे घर", )),
                                DataColumn(label: Text("अंदाजे लोकसंख्या",)),
                              ],
                              rows: vadiGharLoksankhyaEnteredDataList!
                                  .asMap()
                                  .entries
                                  .where((entry) => entry.value.isactive == 1)
                                  .map((entry) {
                                int index = entry.key;
                                var data = entry.value;
                                bool isSelected = selectedvadiGharLoksankhyaIndex == index;

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
                                        selectedvadiGharLoksankhyaIndex = index;
                                      });
                                    }
                                  },
                                  cells: [
                                    DataCell(Text(data.vadiCheNav ?? "")),
                                    DataCell(Text(data.andajeGhar ?? "")),
                                    DataCell(Text(data.andajeLoksankhya ?? "")),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              if (selectedvadiGharLoksankhyaIndex != null) {
                                var selectedData = vadiGharLoksankhyaEnteredDataList![selectedvadiGharLoksankhyaIndex!];
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
                                          "जागरण श्रेणी स्थिति",
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
                                          _buildInfoRow("वाडी/पाड्याचे नाव", selectedData.vadiCheNav),
                                          SizedBox(height: 12),
                                          _buildInfoRow("अंदाजे घर", selectedData.andajeGhar),
                                          SizedBox(height: 12),
                                          _buildInfoRow("अंदाजे लोकसंख्या", selectedData.andajeLoksankhya),
                                        ],
                                      ),
                                      actionsAlignment: MainAxisAlignment.center,
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                          SizedBox(width: 20,),
                          InkWell(
                            onTap: () {
                              showVadiGharLoksankhyaPopup(context, onDataChanged: () {setState(() {});},editIndex:selectedvadiGharLoksankhyaIndex );
                              print("selectedJagranShreniStithiRowIndex --> $selectedvadiGharLoksankhyaIndex");
                            },
                            child:Icon(Icons.edit, color: Colors.blue, size: 20),
                          ),
                          SizedBox(width: 20,),
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
                                      "पुष्टीकरण",
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
                                      "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                      child: const Text(
                                        "नाही",
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
                                      child: const Text(
                                        "होय",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (shouldDelete == true && selectedvadiGharLoksankhyaIndex != null) {
                                setState(() {
                                  vadiGharLoksankhyaEnteredDataList![selectedvadiGharLoksankhyaIndex!].isactive = 0;
                                  selectedvadiGharLoksankhyaIndex = null;
                                });
                              }
                            },
                            child: Icon(Icons.delete, color: Colors.red, size: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    textControllerField2(name: "सरपंचाचे नाव", controller: sarpanchNameController),
                    SizedBox(height: 10),
                    textControllerField2(name: "दूरभाष", controller: sarpanchDoorbhasController,keyboardType: TextInputType.number,maxInput: 10,),
                    SizedBox(height: 10),
                    yesNoRadioButton(
                      question: "गाव समिती आहे ?",
                      selectedOption: gaavSamitiYesNo ?? 2,
                      onChanged: (value) {
                        if (isVastiSearch) {
                          setState(() {gaavSamitiYesNo = value;});
                        } else {
                          showPopupForVastiValidation(context,);
                        }
                      },
                      imp: "*"
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    yesNoRadioButton(question: "पूर्वी कधीतरी संघाची शाखा/साप्ताहिक मिलन चालत होते पण आज बंद आहे का ?",selectedOption: beforsanghaonnowisoff ?? 2,
                        onChanged: (value) {
                          if (isVastiSearch) {
                            setState(() {beforsanghaonnowisoff = value;});
                          } else {
                            showPopupForVastiValidation(context,);
                          }
                        }),
                    if (beforsanghaonnowisoff == 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "तपशील",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () {
                              if (isVastiSearch) {
                                showKuthalaVarshiPopup(context, onDataChanged: () => setState(() {}));
                              } else {
                                showPopupForVastiValidation(context,);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              width: 100,
                              decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),

                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: Colors.white, size: 15),
                                    Text(
                                      "नवीन",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (beforsanghaonnowisoff == 1)SizedBox(height: 10),
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
                              headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                              columns: const [
                                DataColumn(label: Center(child: Text("वयोगट",))),
                                DataColumn(label: Center(child: Text("प्रकार",))),
                                DataColumn(label: Center(child: Text("वर्ष",))),
                              ],
                              rows: (kuthalaVarshiDataList != null && kuthalaVarshiDataList!.isNotEmpty)
                                  ? kuthalaVarshiDataList!
                                  .asMap()
                                  .entries
                                  .where((entry) => entry.value.isactive == 1)
                                  .map((entry) {
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

                    if (beforsanghaonnowisoff == 1)SizedBox(height: 10),
                    if (beforsanghaonnowisoff == 1)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6,),
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
                                            "तपशील माहिती",
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
                                            _buildInfoRow("वयोगट", selectedData.selectedDropdownValueName),
                                            SizedBox(height: 12),
                                            _buildInfoRow("शाखा प्रकार", selectedData.prakarName),
                                            SizedBox(height: 12),
                                            _buildInfoRow("वर्ष", selectedData.isShaakhaa == 1 ? selectedData.shaakhaa : selectedData.isShaakhaa == 2 ? selectedData.saptahik : ""),
                                          ],
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                            SizedBox(width: 20,),
                            InkWell(
                              onTap: () {
                                showKuthalaVarshiPopup(context, onDataChanged: () => setState(() {}),editIndex: selectedKuthalaVarshiIdIndex);
                              },
                              child:Icon(Icons.edit, color: Colors.blue, size: 20),
                            ),
                            SizedBox(width: 20,),
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
                                        "पुष्टीकरण",
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
                                        "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                        child: const Text(
                                          "नाही",
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
                                        child: const Text(
                                          "होय",
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
                    if (beforsanghaonnowisoff == 1)SizedBox(height: 10),
                  ],
                ),

              )

            ],
          ),),
          // =====================================SEWA PRAKALPAA  ==================================================================================
          mainContainer("सेवा प्रकल्प",Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (isVastiSearch) {
                        showSewaPrakalpaPopup(context, onDataChanged: () {
                          setState(() {});
                        });
                      } else {
                        showPopupForVastiValidation(context,);
                      }

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),

                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 15),
                            Text(
                              "नवीन",
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
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                      columns: const [
                        DataColumn(label: Text("प्रकार",)),
                        DataColumn(label: Text("चालवणारी संस्था/संघटन",)),
                      ],
                      rows: sewaPrakalpaEnteredDataList!
                          .asMap()
                          .entries
                          .where((entry) => entry.value.isactive == 1)
                          .map((entry) {
                        int index = entry.key;
                        var data = entry.value;
                        bool isSelected = selectedSewaprakalpaRowIndex == index;

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
                                selectedSewaprakalpaRowIndex = index;
                              });
                            }
                          },
                          cells: [
                            DataCell(Text(data.selectedDropdownValueName ?? "")),
                            DataCell(Text(data.selectedDropdownValueName1 ?? "")),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (selectedSewaprakalpaRowIndex != null) {
                          var selectedData = sewaPrakalpaEnteredDataList![selectedSewaprakalpaRowIndex!];
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
                                    "जागरण श्रेणी स्थिति",
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
                                    _buildInfoRow("प्रकार", selectedData.selectedDropdownValueName),
                                    SizedBox(height: 12),
                                    _buildInfoRow("अन्य प्रकार", selectedData.otherSewaPrakalpaPrakaar),
                                    SizedBox(height: 12),
                                    _buildInfoRow("चालवणारी\nसंस्था/संघटन", selectedData.selectedDropdownValueName1),
                                    SizedBox(height: 12),
                                    _buildInfoRow("अन्य चालवणारी\nसंस्था / संघटन", selectedData.otherSewaPrakalpaChalavinareShanstha),
                                  ],
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: () {
                        showSewaPrakalpaPopup(context, onDataChanged: () {setState(() {});},editIndex:selectedSewaprakalpaRowIndex );
                        print("selectedJagranShreniStithiRowIndex --> $selectedSewaprakalpaRowIndex");
                      },
                      child:Icon(Icons.edit, color: Colors.blue, size: 20),
                    ),
                    SizedBox(width: 20,),
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
                                "पुष्टीकरण",
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
                                "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                child: const Text(
                                  "नाही",
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
                                child: const Text(
                                  "होय",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true && selectedSewaprakalpaRowIndex != null) {
                          // setState(() {
                          //   jagranShreniEnteredDataList!
                          //       .removeAt(selectedJagranShreniStithiRowIndex!);
                          //   selectedJagranShreniStithiRowIndex = null;
                          // });
                          setState(() {
                            sewaPrakalpaEnteredDataList![selectedSewaprakalpaRowIndex!].isactive = 0;
                            selectedSewaprakalpaRowIndex = null;
                          });

                        }
                      },
                      child: Icon(Icons.delete, color: Colors.red, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),),
          // =====================================  ==================================================================================
          mainContainer("विविध क्षेत्राचे काम",Column(
            children: [
              yesNoRadioButton(question: "अन्य विविध क्षेत्राचे कामे चालतात?",selectedOption: anyaVividhKshetracheKame ?? 2,
                  onChanged: (value) {
                    if (isVastiSearch) {
                      setState(() {anyaVividhKshetracheKame = value;});
                    } else {
                      showPopupForVastiValidation(context,);
                    }
                  }),
              if(anyaVividhKshetracheKame == 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (isVastiSearch) {
                        showVividhKshetraCheKamePopup(context, onDataChanged: () {
                          setState(() {});
                        });
                      } else {
                        showPopupForVastiValidation(context,);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 15),
                            Text(
                              "नवीन",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              if(anyaVividhKshetracheKame == 1)
                SizedBox(height: 10),
              if(anyaVividhKshetracheKame == 1)
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
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),

                      columns: const [
                        DataColumn(label: Text("काम",)),
                        DataColumn(label: Text("चालवणारी संस्था/संघटन",)),
                      ],
                      rows: vividhKshetaCHeKamEnteredDataList!
                          .asMap()
                          .entries
                          .where((entry) => entry.value.isactive == 1)
                          .map((entry) {
                        int index = entry.key;
                        var data = entry.value;
                        bool isSelected = selectedVastisarVividhKshetracheIndex == index;

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
                                selectedVastisarVividhKshetracheIndex = index;
                              });
                            }
                          },
                          cells: [
                            DataCell(Text(data.kaam ?? "")),
                            DataCell(Text(data.chalavnariSansthaSanghatamn ?? "")),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              if(anyaVividhKshetracheKame == 1)
                SizedBox(height: 10),
              if(anyaVividhKshetracheKame == 1)
                Container(
                padding: EdgeInsets.symmetric(horizontal: 6,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (selectedVastisarVividhKshetracheIndex != null) {
                          var selectedData = vividhKshetaCHeKamEnteredDataList![selectedVastisarVividhKshetracheIndex!];
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
                                    "विविध क्षेत्राचे काम",
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
                                    _buildInfoRow("काम", selectedData.kaam),
                                    SizedBox(height: 12),
                                    _buildInfoRow("चालवणारी\nसंस्था/संघटन", selectedData.chalavnariSansthaSanghatamn),
                                    SizedBox(height: 12),
                                  ],
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: () {
                        showVividhKshetraCheKamePopup(context, onDataChanged: () {setState(() {});},editIndex:selectedVastisarVividhKshetracheIndex );
                        print("selectedJagranShreniStithiRowIndex --> $selectedVastisarVividhKshetracheIndex");
                      },
                      child:Icon(Icons.edit, color: Colors.blue, size: 20),
                    ),
                    SizedBox(width: 20,),
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
                                "पुष्टीकरण",
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
                                "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                child: const Text(
                                  "नाही",
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
                                child: const Text(
                                  "होय",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true && selectedVastisarVividhKshetracheIndex != null) {
                          // setState(() {
                          //   jagranShreniEnteredDataList!
                          //       .removeAt(selectedJagranShreniStithiRowIndex!);
                          //   selectedJagranShreniStithiRowIndex = null;
                          // });
                          setState(() {
                            vividhKshetaCHeKamEnteredDataList![selectedVastisarVividhKshetracheIndex!].isactive = 0;
                            selectedVastisarVividhKshetracheIndex = null;
                          });

                        }
                      },
                      child: Icon(Icons.delete, color: Colors.red, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),),
          // =====================================SEWA PRAKALPAA  ==================================================================================
          mainContainer("विविध संप्रदाय व आध्यात्मिक सत्संग केंद्र",
            Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (isVastiSearch) {
                        showVividhadhyatmitStsangKendraPopup(context, onDataChanged: () {
                          setState(() {});
                        });
                      } else {
                        showPopupForVastiValidation(context,);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 15),
                            Text(
                              "नवीन",
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
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                      columns: const [
                        DataColumn(label: Text("संस्था",)),
                        DataColumn(label: Text("गाव प्रमुखाचे नाव",)),
                      ],
                      rows: vividhadhyatmitStsangKendraEnteredDataList!
                          .asMap()
                          .entries
                          .where((entry) => entry.value.isactive == 1)
                          .map((entry) {
                        int index = entry.key;
                        var data = entry.value;
                        bool isSelected = selectedVastisarVividhadhyatmitStsangKendraIndex == index;
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
                                selectedVastisarVividhadhyatmitStsangKendraIndex = index;
                              });
                            }
                          },
                          cells: [
                            DataCell(Text(data.selectedDropdownValueName.toString())),
                            DataCell(Text(data.gaavPramukhName.toString())),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
                SizedBox(height: 10),
                Container(
                padding: EdgeInsets.symmetric(horizontal: 6,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (selectedVastisarVividhadhyatmitStsangKendraIndex != null) {
                          var selectedData = vividhadhyatmitStsangKendraEnteredDataList![selectedVastisarVividhadhyatmitStsangKendraIndex!];
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
                                    "आध्यात्मिक केंद्र",
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
                                    // _buildInfoRow("गाव", selectedData.selectedDropdownValueName1.toString()),
                                    // SizedBox(height: 12),
                                    _buildInfoRow("संस्था", selectedData.selectedDropdownValueName.toString()),
                                    SizedBox(height: 12),
                                    _buildInfoRow("अन्य संस्था", selectedData.isOtherAdhyatmitKendra.toString()),
                                    SizedBox(height: 12),
                                    _buildInfoRow("गाव प्रमुखाचे नाव", selectedData.gaavPramukhName.toString()),
                                    SizedBox(height: 12),
                                    _buildInfoRow("संपर्क सूत्र", selectedData.samparkSootra.toString()),
                                    SizedBox(height: 12),
                                  ],
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: () {
                        showVividhadhyatmitStsangKendraPopup(context, onDataChanged: () {setState(() {});},editIndex:selectedVastisarVividhadhyatmitStsangKendraIndex );
                        print("selectedJagranShreniStithiRowIndex --> $selectedVastisarVividhadhyatmitStsangKendraIndex");
                      },
                      child:Icon(Icons.edit, color: Colors.blue, size: 20),
                    ),
                    SizedBox(width: 20,),
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
                                "पुष्टीकरण",
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
                                "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                child: const Text(
                                  "नाही",
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
                                child: const Text(
                                  "होय",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true && selectedVastisarVividhadhyatmitStsangKendraIndex != null) {
                          setState(() {
                            vividhadhyatmitStsangKendraEnteredDataList![selectedVastisarVividhadhyatmitStsangKendraIndex!].isactive = 0;
                            selectedVastisarVividhadhyatmitStsangKendraIndex = null;
                          });

                        }
                      },
                      child: Icon(Icons.delete, color: Colors.red, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),),
          // =====================================  ==================================================================================
          mainContainer("गावातील मुंबईकर मंडळ",Column(
            children: [
              yesNoRadioButton(question: "गावातील मुंबईकर मंडळ आहे ?",selectedOption: gavatilMumbaikar ?? 2,
                  onChanged: (value) {
                    if (isVastiSearch) {
                      setState(() {gavatilMumbaikar = value;});
                    } else {
                      showPopupForVastiValidation(context,);
                    }
                  }),
              if(gavatilMumbaikar == 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showGavatilMumbaikarPopup(context, onDataChanged: () {
                            setState(() {});
                          });
                        } else {
                          showPopupForVastiValidation(context,);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 15),
                              Text(
                                "नवीन",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              if(gavatilMumbaikar == 1)
                SizedBox(height: 10),
              if(gavatilMumbaikar == 1)
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
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                        columns: const [
                          DataColumn(label: Text("स्थान", )),
                          DataColumn(label: Text("प्रमुखाचे नाव",)),
                        ],
                        rows: gavatilMumbaikarEnteredDataList!
                            .asMap()
                            .entries
                            .where((entry) => entry.value.isactive == 1)
                            .map((entry) {
                          int index = entry.key;
                          var data = entry.value;
                          bool isSelected = selectedGavatilMumbaikarIndex == index;

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
                                  selectedGavatilMumbaikarIndex = index;
                                });
                              }
                            },
                            cells: [
                              DataCell(Text(data.sthaan ?? "")),
                              DataCell(Text(data.pramukhachrNaav ?? "")),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              if(gavatilMumbaikar == 1)
                SizedBox(height: 10),
              if(gavatilMumbaikar == 1)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedGavatilMumbaikarIndex != null) {
                            var selectedData = gavatilMumbaikarEnteredDataList![selectedGavatilMumbaikarIndex!];
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
                                      "विविध क्षेत्राचे काम",
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
                                      _buildInfoRow("काम", selectedData.sthaan),
                                      SizedBox(height: 12),
                                      _buildInfoRow("चालवणारी\nसंस्था/संघटन", selectedData.pramukhachrNaav),
                                      SizedBox(height: 12),
                                    ],
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                      SizedBox(width: 20,),
                      InkWell(
                        onTap: () {
                          showGavatilMumbaikarPopup(context, onDataChanged: () {setState(() {});},editIndex:selectedGavatilMumbaikarIndex );
                          print("selectedJagranShreniStithiRowIndex --> $selectedGavatilMumbaikarIndex");
                        },
                        child:Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(width: 20,),
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
                                  "पुष्टीकरण",
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
                                  "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                  child: const Text(
                                    "नाही",
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
                                  child: const Text(
                                    "होय",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (shouldDelete == true && selectedGavatilMumbaikarIndex != null) {
                            setState(() {
                              gavatilMumbaikarEnteredDataList![selectedGavatilMumbaikarIndex!].isactive = 0;
                              selectedGavatilMumbaikarIndex = null;
                            });
                          }
                        },
                        child: Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                ),
            ],
          ),),
          // ===================================== रिलीजन ==================================================================================
          mainContainer("रिलीजन",Column(
            children: [
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: (){

                                if (isVastiSearch) {
                                  showReligionPopup(context, onDataChanged: () {setState(() {});},);
                                } else {
                                  showPopupForVastiValidation(context);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                width: 100,
                                decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, color: Colors.white,size: 15),
                                      Text(
                                        "नवीन",
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
                                headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                                columns: const [
                                  DataColumn(label: Text('कोणत्या रिलीजन चे',)),
                                  DataColumn(label: Text('अंदाजे (%)',)),
                                ],
                                rows: enteredreligionDataList.asMap()
                                    .entries
                                    .where((entry) => entry.value.isactive == 1)
                                    .map((entry) {
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
                                        DataCell(Text(data.andaje ?? "")),
                                      ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6,),
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
                                              "रिलीजन",
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
                                              _buildInfoRow("कोणत्या रिलीजन चे", selectedData.selectedDropdownValueName),
                                              SizedBox(height: 12),
                                              _buildInfoRow("अंदाजे (%)", selectedData.andaje),
                                            ],
                                          ),
                                          actionsAlignment: MainAxisAlignment.center,
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                                child:Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                              ),
                              SizedBox(width: 20,),
                              InkWell(
                                onTap: () {
                                  showReligionPopup(context,editIndex: selectedReligionIdRowIndex, onDataChanged: () {setState(() {});} );   },
                                child: Icon(Icons.edit, color: Colors.blue, size: 20),
                              ),
                              SizedBox(width: 20,),
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
                                          "पुष्टीकरण",
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
                                          "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                          child: const Text(
                                            "नाही",
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
                                          child: const Text(
                                            "होय",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (shouldDelete == true && selectedReligionIdRowIndex != null) {
                                    // setState(() {
                                    //   enteredreligionDataList
                                    //       .removeAt(selectedReligionIdRowIndex!);
                                    //   selectedReligionIdRowIndex = null;
                                    // });
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
                    "उपासना स्थळ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.purpleAccent),
                  ),
                  InkWell(
                    onTap: (){
                      if (isVastiSearch) {
                        showUpasnaSthalPopup(context, onDataChanged: () {setState(() {});},);
                      } else {
                        showPopupForVastiValidation(context);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white,size: 15),
                            Text(
                              "नवीन",
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
                width:double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(border: Border.all(color: Colors.black54,),borderRadius: BorderRadius.all(Radius.circular(15))),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: DataTable(
                        showCheckboxColumn: false,
                        headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                        columnSpacing: 20,
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                        columns: const [
                          DataColumn(label: Text("उपासना स्थळ",)),
                          DataColumn(label: Text("प्रकार",)),
                          DataColumn(label: Text("संख्या",)),
                        ],
                        rows: upasnaSthalDataList.asMap()
                            .entries
                            .where((entry) => entry.value.isactive == 1)
                            .map((entry) {
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
                                // DataCell(Row(
                                //   children: [
                                //     IconButton(
                                //       icon: const Icon(Icons.edit, color: Colors.blue),
                                //       onPressed: () => showUpasnaSthalPopup(context, editIndex: index),
                                //     ),
                                //     IconButton(
                                //       icon: const Icon(Icons.delete, color: Colors.red),
                                //       onPressed: () {
                                //         setState(() {
                                //           upasnaSthalDataList.removeAt(index);
                                //         });
                                //       },
                                //     ),
                                //   ],
                                // )),
                              ]);
                        }).toList(),
                      ),
                    )
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6,),
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
                                    "उपासना स्थळ",
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
                                    _buildInfoRow("उपासना स्थळ", selectedData.selectedDropdownValueName),
                                    SizedBox(height: 12),
                                    _buildInfoRow("अन्य उपासना स्थळ", selectedData.otherupaasanasthala),
                                    SizedBox(height: 12),
                                    _buildInfoRow("प्रकार", selectedData.selectedDropdownValueName1),
                                    SizedBox(height: 12),
                                    _buildInfoRow("संख्या", selectedData.sankhya),
                                  ],
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                      child:Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                    ),
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: () {
                        showUpasnaSthalPopup(context,editIndex:selectedUpasnaSthalRowIndex, onDataChanged: () {setState(() {});} );   },
                      child: Icon(Icons.edit, color: Colors.blue, size: 20),
                    ),
                    SizedBox(width: 20,),
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
                                "पुष्टीकरण",
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
                                "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                child: const Text(
                                  "नाही",
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
                                child: const Text(
                                  "होय",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true && selectedUpasnaSthalRowIndex != null) {
                          setState(() {
                            upasnaSthalDataList
                                .removeAt(selectedUpasnaSthalRowIndex!);
                            selectedUpasnaSthalRowIndex = null;
                          });
                        }
                      },
                      child:  Icon(Icons.delete, color: Colors.red, size: 20),
                    ),
                  ],
                ),
              ),

            ],
          )),
//==========================  SAJJAN SHAKTI JODA =================================================================================================================================================================================
          SizedBox(height: 20,),
          mainContainer("सज्जन शक्ति",Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: (){
                        if (isVastiSearch) {
                          showSajjanShaktiPopup(context, onDataChanged: () {setState(() {});},);
                        } else {
                          showPopupForVastiValidation(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: 100,
                        decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white,size: 15),
                              Text(
                                "नवीन",
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
                  width:double.infinity,
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
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                        columns: const [
                          DataColumn(label: Text("नाव",)),
                          DataColumn(label: Text("श्रेणी",)),
                          DataColumn(label: Text("संपर्क स्थिति",)),
                        ],
                        rows: sajjanShaktiDataList.asMap()
                            .entries
                            .where((entry) => entry.value.isactive == 1)
                            .map((entry) {
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
                  padding: EdgeInsets.symmetric(horizontal: 6,),
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
                                      "सज्जन शक्ति",
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
                                        _buildInfoRow("नाव", selectedData.name),
                                        SizedBox(height: 12),
                                        _buildInfoRow("पत्ता", selectedData.address),
                                        SizedBox(height: 12),
                                        _buildInfoRow("दूरभाष", selectedData.doorabhaash),
                                        SizedBox(height: 12),
                                        _buildInfoRow("श्रेणी", selectedData.selectedDropdownValueName),
                                        SizedBox(height: 12),
                                        _buildInfoRow("अन्य श्रेणी", selectedData.otherShreniName),
                                        SizedBox(height: 12),
                                        _buildInfoRow("संस्थेचे नाव", selectedData.sanstheCheNaav),
                                        SizedBox(height: 12),
                                        _buildInfoRow("संस्थेचा कुठल्या\nपदावर", selectedData.sansthechaKuthalaPadavar),
                                        SizedBox(height: 12),
                                        _buildInfoRow("संपर्क स्थिति", selectedData.selectedDropdownValueName1),
                                        SizedBox(height: 12),
                                        _buildInfoRow("विशेष", selectedData.selectedDropdownValueName2),
                                        SizedBox(height: 12),
                                        _buildInfoRow("अन्य विशेष", selectedData.otherVisheshName),
                                        SizedBox(height: 12),
                                        _buildInfoRow("प्रभाव क्षेत्र", selectedData.selectedDropdownValueName3),
                                        SizedBox(height: 12),
                                        _buildInfoRow("संपर्क सूत्र\nनाव", selectedData.samparkasutranava),
                                        SizedBox(height: 12),
                                        _buildInfoRow("संपर्क सूत्रांचे\nदूरभाष ", selectedData.samparkasutraMobileNumber),
                                      ],
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                      SizedBox(width: 20,),
                      InkWell(
                        onTap: () {
                          showSajjanShaktiPopup(context,editIndex:selectedsajjanShaktiRowIndex, onDataChanged: () {setState(() {});} );
                        },
                        child: Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(width: 20,),
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
                                  "पुष्टीकरण",
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
                                  "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                  child: const Text(
                                    "नाही",
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
                                  child: const Text(
                                    "होय",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true && selectedsajjanShaktiRowIndex != null) {
                            setState(() {
                              sajjanShaktiDataList
                                  .removeAt(selectedsajjanShaktiRowIndex!);
                              selectedsajjanShaktiRowIndex = null;
                            });
                          }
                        },
                        child:  Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                ),
              ]
          )),
          //==========================  ANYA PRABHAVI LOK  ==============================================================
          SizedBox(height: 20,),
          mainContainer("अन्य प्रभावी लोकं (संपर्क विभागाची यादी )",Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){


                      if (isVastiSearch) {
                        showAnyaPrabhaviPopup(context,onDataChanged: () { setState(() {});});
                      } else {
                        showPopupForVastiValidation(context);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white,size: 15),
                            Text(
                              "नवीन",
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
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                      columns: const [
                        // DataColumn(label: Text("क्रिया", style: TextStyle(color: Colors.black54))),
                        DataColumn(label: Text("नाव",)),
                        DataColumn(label: Text("विशेष",)),
                        DataColumn(label: Text("प्रभाव क्षेत्र",)),
                      ],
                      rows: anyaPrabhaviLokDataList.asMap()
                          .entries
                          .where((entry) => entry.value.isactive == 1)
                          .map((entry) {
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
                padding: EdgeInsets.symmetric(horizontal: 6,),
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
                                    "अन्य प्रभावी लोकं",
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
                                      _buildInfoRow("नाव", selectedData.name),
                                      _buildInfoRow("पत्ता", selectedData.address),
                                      _buildInfoRow("दूरभाष", selectedData.doorabhaash),
                                      _buildInfoRow("श्रेणी", selectedData.selectedDropdownValueName),
                                      _buildInfoRow("उपश्रेणी", selectedData.selectedDropdownValueName1),
                                      _buildInfoRow("अन्य उपश्रेणी", selectedData.otherupshrenee),
                                      _buildInfoRow("उपश्रेणी 1", selectedData.selectedDropdownValueName2),
                                      _buildInfoRow("विशेष", selectedData.selectedDropdownValueName3),
                                      _buildInfoRow("प्रभाव क्षेत्र", selectedData.selectedDropdownValueName4),
                                      _buildInfoRow("अन्य विशेष माहिती", selectedData.othervishesh),
                                      _buildInfoRow("संपर्क स्थिति", selectedData.selectedDropdownValueName5),
                                      _buildInfoRow("संपर्क सूत्र नाव", selectedData.samparkasutranav),
                                      _buildInfoRow("संपर्क सूत्रांचे दूरभाष", selectedData.samparkaSutraDoorbhash),
                                    ],
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                      child:Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                    ),
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: () {
                        showAnyaPrabhaviPopup(context, onDataChanged: () {setState(() {});},editIndex:selectedanyaPrabhaviLokRowIndex);   },
                      child:Icon(Icons.edit, color: Colors.blue, size: 20),
                    ),
                    SizedBox(width: 20,),
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
                                "पुष्टीकरण",
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
                                "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                child: const Text(
                                  "नाही",
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
                                child: const Text(
                                  "होय",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (shouldDelete == true && selectedanyaPrabhaviLokRowIndex != null) {
                          // setState(() {
                          //   anyaPrabhaviLokDataList
                          //       .removeAt(selectedanyaPrabhaviLokRowIndex!);
                          //   selectedanyaPrabhaviLokRowIndex = null;
                          // });
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
                    "गावात साजरे होणारे महत्त्वाचे सण",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.purpleAccent),

                  ),
                  InkWell(
                    onTap: (){
                      if (isVastiSearch) {
                        showVastitSajarHonareSanPopup(context, onDataChanged: () {setState(() {});},);
                      } else {
                        showPopupForVastiValidation(context);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.shade100 ,borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white,size: 15),
                            Text(
                              "नवीन",
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
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                        columns: const [
                          DataColumn(label: Text("सण",)),
                          DataColumn(label: Text("आयोजक संस्था",)),
                          DataColumn(label: Text("आयोजक", )),
                          DataColumn(label: Text("संपर्क", )),
                        ],
                        rows: vastitSajarHonareSanDataList.asMap()
                            .entries
                            .where((entry) => entry.value.isactive == 1)
                            .map((entry) {
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
                                DataCell(Text(/*data['sanName'] == "अन्य"? "${data['sanName']} - ${data['vastitSajarHonareAnyaSan']}" :*/ data.selectedDropdownValueName ?? '')),
                                DataCell(Text(data.ayojakasansthacinave ?? '')),
                                DataCell(Text(data.ayojakancinave ?? '')),
                                DataCell(Text(data.aayojaksamparksootr ?? '')),
                              ]);
                        }).toList(),
                      ),
                    )
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6,),
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
                                    "गावात साजरे होणारे महत्त्वाचे सण",
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
                                      _buildInfoRow("सण", selectedData.selectedDropdownValueName),
                                      _buildInfoRow("अन्य सण", selectedData.otherSajareSan),
                                      _buildInfoRow("आयोजक संस्था", selectedData.ayojakasansthacinave),
                                      _buildInfoRow("आयोजक", selectedData.ayojakancinave),
                                      _buildInfoRow("संपर्क सूत्र", selectedData.aayojaksamparksootr),
                                    ],
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                      child:Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                    ),
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: () {showVastitSajarHonareSanPopup(context, editIndex: selectedSanIdIndex, onDataChanged: () { setState(() {});});},
                      child:Icon(Icons.edit, color: Colors.blue, size: 20),
                    ),
                    SizedBox(width: 20,),
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
                                "पुष्टीकरण",
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
                                "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                child: const Text(
                                  "नाही",
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
                                child: const Text(
                                  "होय",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (shouldDelete == true && selectedSanIdIndex != null) {
                          // setState(() {
                          //   vastitSajarHonareSanDataList
                          //       .removeAt(selectedSanIdIndex!);
                          //   selectedSanIdIndex = null;
                          // });
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
                      "गावात साजरे होणारे महत्वाचे सामाजिक कार्यक्रम",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.purpleAccent),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      if (isVastiSearch) {
                        showVastitSajarHonareSamajikKaryakramPopup(context, onDataChanged: () {setState(() {});},);
                      } else {
                        showPopupForVastiValidation(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.shade100 ,borderRadius: BorderRadius.circular(15)),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 15),
                            SizedBox(width: 5),
                            Text(
                              "नवीन",
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
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                        columns: const [
                          DataColumn(label: Text("सामाजिक कार्यक्रम",)),
                          DataColumn(label: Text("आयोजक संस्था",)),
                          DataColumn(label: Text("आयोजक",)),
                          DataColumn(label: Text("संपर्क",)),
                        ],
                        rows: vastitSajarHonareSamajikKaryakramDataList.asMap()
                            .entries
                            .where((entry) => entry.value.isactive == 1)
                            .map((entry) {
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
                    )
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6,),
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
                                    "गावात होणारे सामाजिक कार्यक्रम",
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
                                      _buildInfoRow("सामाजिक कार्यक्रम", selectedData.selectedDropdownValueName),
                                      _buildInfoRow("अन्य", selectedData.otherKaryakram),
                                      _buildInfoRow("आयोजक संस्था", selectedData.ayojakasansthacinave),
                                      _buildInfoRow("आयोजक", selectedData.ayojakancinave),
                                      _buildInfoRow("संपर्क", selectedData.aayojaksamparksootr),
                                    ],
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                      child:Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                    ),
                    SizedBox(width: 20,),
                    InkWell(
                      onTap: () {showVastitSajarHonareSamajikKaryakramPopup(context, editIndex: selectedSamajikKaryakramIdIndex, onDataChanged: () { setState(() {});});},
                      child:Icon(Icons.edit, color: Colors.blue, size: 20),
                    ),
                    SizedBox(width: 20,),
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
                                "पुष्टीकरण",
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
                                "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                child: const Text(
                                  "नाही",
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
                                child: const Text(
                                  "होय",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (shouldDelete == true && selectedSamajikKaryakramIdIndex != null) {
                          // setState(() {
                          //   vastitSajarHonareSamajikKaryakramDataList
                          //       .removeAt(selectedSamajikKaryakramIdIndex!);
                          //   selectedSamajikKaryakramIdIndex = null;
                          // });
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
              //                     textControllerField( "गावात साजरे होणारे अन्य महत्वाचे सामाजिक कार्यक्रम", vastitHonareSamajikAnyakaryakramController,context,height: 80,),
              //===========================  SUBMIT BUTTON ===============================================================================================================================================================================================
              Divider(thickness: 2),
              InkWell(
                onTap: () {

                  if (isVastiSearch) {
                    if( gaavSamitiYesNo == 0 || gaavSamitiYesNo == 1){
                      submitStep1Form();
                    }else{
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(
                            "सूचना",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                              fontSize: 18,
                            ),
                          ),
                          content: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "गाव समिती आवश्यक.",
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
                                "ठीक",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }else{
                    showPopupForVastiValidation(context);}
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  padding: const EdgeInsets.symmetric( horizontal: 20),
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
                      "प्रार्थमिक माहिती संग्रह",
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
          ),),
        ],
      ),
    );
  }
  Future<void> submitStep1Form() async {

    Map<String, dynamic> formData = {
      "cuserid": int.parse(Statics.userDetails['userID']),
      "vastiid": int.parse(selctedLevelId!),
      "VastisarvadiGharLoksankhya": vadiGharLoksankhyaEnteredDataList,
      "vastiShakhaSamiti": gaavSamitiYesNo,
      "VastisarKuthalyavarsi": kuthalaVarshiDataList,
      "VastisarSewaPrakalpa" :sewaPrakalpaEnteredDataList,
      "VastisarvividhKshetaCheKam" :vividhKshetaCHeKamEnteredDataList,
      "anyaVividhKshetracheKame" :anyaVividhKshetracheKame,
      "VastisarvividhSampradhaySatsangKendra" :vividhadhyatmitStsangKendraEnteredDataList,
      "VastisargavatilMumbaikar" :gavatilMumbaikarEnteredDataList,
      "isGavatilMumbaikar" :gavatilMumbaikar,
      "VastisarReligion": enteredreligionDataList,
      "Vastisarupaasana": upasnaSthalDataList,
      "Vastisarsajjanshakti": sajjanShaktiDataList,
      "VastisarAnyaprabhavilokam": anyaPrabhaviLokDataList,
      "VastisarVastitasajaraSamajikkaryakram": vastitSajarHonareSamajikKaryakramDataList,
      "VastisarVastitamahatvacesana": vastitSajarHonareSanDataList,
      "sarpanchaName": sarpanchNameController.text,
      "sarpanchDoorbhash": sarpanchDoorbhasController.text,
//====================================================================================================
      "VastisarKonatyaprantache": enteredKontyaPraantacheDataList,
      "vastiShakhaPramukhName": sanghaKaryaVastiPramukhNameController.text,
      "Lokasankhya": loksankhyaController.text,
      "beforeShakhaSaptahikIsOnNowOff": beforsanghaonnowisoff,
      "VasticyacatuSima": vastiChatahuSimaController.text,
      "googlemap": selectedFilePath,
      "Vastitasajaraanyakaryakaram": vastitHonareSamajikAnyakaryakramController.text,
      "VastisarJaagaranshreneesthiti": jagranShreniEnteredDataList,
      "VastisarGatividhikaryasthiti": enteredDataListGatividhi,
      "VastisarVasahatprakara": enteredVasahatPrakarDataList,
      "VastisarVividhaprakara": enteredVividhBhashaBolnareDataList,
      "stepOneComplete": _isStep1Completed == true ? 1 : 0,
      "vadichenav": vadicheNaavController.text,
      "andajeGhare": andajeGhareController.text,
      "isImage": 0,
      "isvasti": 0,

    };
    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Step 1 Form Data (JSON):\n$formattedJson");
    // Statics.vastiSarvekshanStep1FormSubmit(jsonEncode(formData));
    // setState(() {
    //   _isStep1Completed = true;
    // });
    String response = await Statics.vastiSarvekshanStep1FormSubmit(context,jsonEncode(formData));
    setState(() {
      _isStep1Completed = response == "success";
    });
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
    });
  }

  Widget vastisarvekshanDropdown3({
    required String filterTypeName,
    required String hintText,
    required Function(int, String, Masterdata) onValueSelected,
    Function(int, String, Masterdata)? onDependentValueSelected,
    Function(int, String, Masterdata)? onThirdLevelValueSelected,
    Masterdata? selectedValue,
    Masterdata? selectedDependentValue,
    Masterdata? selectedThirdLevelValue,
    BoxDecoration? decoration,
    Color? textColor,
    Color? borderColor,
    Color? iconColor,
    bool? viewName,
  }) {
    List<Masterdata> masterDataList = vastisarvekshanDropDownDataModel!.masterdata!;
    List<Masterdata> filteredItems = masterDataList.where((e) => e.typename == filterTypeName).toList();
    List<Masterdata> dependentItems = selectedValue != null
        ? masterDataList.where((e) => e.parentid == selectedValue.id).toList()
        : [];
    List<Masterdata> thirdLevelItems = selectedDependentValue != null
        ? masterDataList.where((e) => e.parentid == selectedDependentValue.id).toList()
        : [];

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
            hintText: "उपश्रेणी निवडा",
            value: selectedDependentValue,
            items: dependentItems,
            onChanged: (newValue) {
              if (newValue != null && onDependentValueSelected != null) {
                onDependentValueSelected(newValue.id!, newValue.value!, newValue);
              }
            },
            decoration: decoration,
            borderColor: borderColor,
            iconColor: iconColor,
            textColor: textColor,
            viewName: viewName,
          ),
        if (thirdLevelItems.isNotEmpty)
          SizedBox(height: 10),
        if (thirdLevelItems.isNotEmpty)
          _buildDropdown2(
            hintText: "उपश्रेणी 2 निवडा",
            value: selectedThirdLevelValue,
            items: thirdLevelItems,
            onChanged: (newValue) {
              if (newValue != null && onThirdLevelValueSelected != null) {
                onThirdLevelValueSelected(newValue.id!, newValue.value!, newValue);
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
    bool? viewName
  }) {
    return         Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          iconEnabledColor: iconColor ?? Colors.black,
          hint: Text(
            value != null && viewName == true ? value.value ?? "No Value" : hintText,
            style: TextStyle(color: textColor ?? Colors.black),
          ),
          value: value,
          isExpanded: true,
          items: items
              .map((item) => DropdownMenuItem<T>(
            value: item,
            child: Text(
              item.value ?? "No Value",
              style: TextStyle(color: textColor ?? Colors.black),
            ),
          ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }


  //======================== ==================================================================
  List<VastisarVadiGharLoksankhya>? vadiGharLoksankhyaEnteredDataList = [];
  int? selectedvadiGharLoksankhyaIndex;
   TextEditingController vadicheNaavController = TextEditingController();
   TextEditingController andajeGhareController = TextEditingController();
   TextEditingController loksankhyaController = TextEditingController();
  int? isActiveVadiGharLoksankhya = 1;
  int? pkIdVadiGharLoksankhya = 0;
  void showVadiGharLoksankhyaPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = vadiGharLoksankhyaEnteredDataList![editIndex];
      vadicheNaavController.text = data.vadiCheNav ?? "";
      andajeGhareController.text = data.andajeGhar ?? "";
      loksankhyaController.text = data.andajeLoksankhya ?? "";
      isActiveGavatilMumbaikar = data.isactive;
      pkIdGavatilMumbaikar = data.pkid;
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
                            "तपशील",style: TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.bold,fontSize: 20,),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[700]),
                            onPressed: () {
                              clearFieldsVadiGharLoksankhya();
                              Navigator.of(ctx).pop();
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            textControllerField2(name:'वाडी/पाड्याचे नाव',controller:vadicheNaavController,),
                            const SizedBox(height: 10),
                            textControllerField2(name: "अंदाजे घर",controller: andajeGhareController,keyboardType: TextInputType.number),
                            const SizedBox(height: 10),
                            textControllerField2(name: "अंदाजे लोकसंख्या",controller: loksankhyaController,keyboardType: TextInputType.number),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  VastisarVadiGharLoksankhya data = VastisarVadiGharLoksankhya(
                                    pkid: VastisarVividhKshetracheKamPkId,
                                    isactive: isActiveVastisarVividhKshetracheKam,
                                    vastiid: int.parse(selctedLevelId!),
                                    vadiCheNav: vadicheNaavController.text,
                                    andajeGhar: andajeGhareController.text ,
                                    andajeLoksankhya: loksankhyaController.text ,
                                  );
                                  if (editIndex != null) {
                                    vadiGharLoksankhyaEnteredDataList![editIndex] = data;
                                  } else {
                                    vadiGharLoksankhyaEnteredDataList!.add(data);
                                  }
                                  Navigator.of(ctx).pop();
                                  clearFieldsVadiGharLoksankhya();
                                  if (onDataChanged != null) {
                                    onDataChanged();
                                  }
                                },
                                child: const Text("संग्रह",style: TextStyle(color: Colors.white),),
                              ),
                            )
                          ],
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
  void clearFieldsVadiGharLoksankhya() {
     vadicheNaavController.clear();
     andajeGhareController.clear();
     loksankhyaController.clear();
     isActiveVadiGharLoksankhya = 1;
     pkIdVadiGharLoksankhya = 0;
  }
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
      selectedYearType = data.isactive == 1 ? "shaakha" : data.isactive == 1 ? "saptahikMilan" : "";
      selectedisActive = data.isactive;
      selectedMasterKuthalaVarshiName = vastisarvekshanDropDownDataModel!.masterdata!
          .firstWhere((item) => item.id == selectedKuthalaVarshiId);
      if (selectedYearType == 'shaakha') {
        kuthalaVarshiVayogatShaakhaYearController.text = data.shaakhaa ?? '';
      } else if (selectedYearType == 'saptahikMilan') {
        kuthalaVarshiVayogatSaptahikYearController.text = data.saptahik ?? '';
      }
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "तपशील",
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
                    vastisarvekshanDropDownDataModel?.masterdata != null ?
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "कुठल्या वर्षी",
                      hintText: "वयोगट निवडा",
                      onItemSelected: (id, value,isOther) {
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
                    ):Container(),
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
                        Text('शाखा'),
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
                        Text('सा. मिलन'),
                      ],
                    ),

                    if (selectedYearType == 'shaakha')
                      textControllerField2(
                          name: 'कुठल्या वर्षी ?',
                          controller: kuthalaVarshiVayogatShaakhaYearController,
                          keyboardType: TextInputType.number,
                          hintTextString: "e.g. 2025",
                          maxInput: 4
                      ),
                    if (selectedYearType == 'saptahikMilan')
                      textControllerField2(
                          name: 'कुठल्या वर्षी ?',
                          controller: kuthalaVarshiVayogatSaptahikYearController,
                          keyboardType: TextInputType.number,
                          hintTextString: "e.g. 2025",
                          maxInput: 4
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
                  int? saptahikYear = int.tryParse(kuthalaVarshiVayogatSaptahikYearController.text);
                  int? shaakhaYear = int.tryParse(kuthalaVarshiVayogatShaakhaYearController.text);

                  if ((saptahikYear != null && saptahikYear >= 1925 && saptahikYear <= 2025) ||
                      (shaakhaYear != null && shaakhaYear >= 1925 && shaakhaYear <= 2025)) {
                    final data = VastisarKuthalyavarsi(
                      id: selectedKuthalaVarshiId,
                      prakarName: selectedYearType == "shaakha" ? "शाखा" : selectedYearType == "saptahikMilan" ? "साप्ताहिक मिलन" : "-",
                      isShaakhaa: selectedYearType == "shaakha" ? 1 : selectedYearType == "saptahikMilan" ? 0 : 2,
                      pkid: selectedPkId,
                      vastiid: int.parse(selctedLevelId!),
                      shaakhaa: selectedYearType == "shaakha"
                          ? kuthalaVarshiVayogatShaakhaYearController.text.trim()
                          : "",
                      saptahik: selectedYearType == "saptahikMilan"
                          ? kuthalaVarshiVayogatSaptahikYearController.text.trim()
                          : "",
                      isactive: selectedisActive,
                      selectedDropdownValueName: selectedKuthalaVarshiName,
                    );
                    if (editIndex != null) {
                      kuthalaVarshiDataList![editIndex] = data;
                    } else {
                      kuthalaVarshiDataList!.add(data);
                    }
                    if (onDataChanged != null) {
                      onDataChanged();
                    }
                    Navigator.of(ctx).pop();
                    clearKuthalaVarshi();
                    print("Year is valid.");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("वर्ष १९२५ आणि २०२५ च्या दरम्यान असले पाहिजे."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text("संग्रह", style: TextStyle(color: Colors.white)),
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
//========================  Sewa PRAKALPA FORM ===========================================
  List<VastisarSewaPrakalpa>? sewaPrakalpaEnteredDataList = [];
  int? selectedSewaprakalpaRowIndex;
  int? selectedSewaprakalpaPrakaarID;
  String? selectedSewaprakalpaPrakaarName;
  int? selectedSewaprakalpaChalanvariSansthaID;
  String? selectedSewaprakalpaChalanvariSansthaName;
  int? selectedSewaprakalpaPrakaarIDEdit;
  int? selectedSewaprakalpaChalanvariSansthaIDEdit;
  Masterdata? selectedSewaprakalpaPrakaar;
  Masterdata? selectedSewaprakalpaChalanvariSanstha;
  int? isActiveSewaprakalpa = 1;
  int? sewaprakalpaPkId = 0;

  TextEditingController isOtherSewaprakalpaPrakaarConroller = TextEditingController();
  TextEditingController isOtherSewaprakalpaChalanvariSansthaConroller = TextEditingController();
  void showSewaPrakalpaPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = sewaPrakalpaEnteredDataList![editIndex];
      selectedSewaprakalpaPrakaarID = data.sewaPrakalpaPrakaarId;
      selectedSewaprakalpaPrakaarIDEdit = data.sewaPrakalpaPrakaarId;
      selectedSewaprakalpaPrakaarName = data.selectedDropdownValueName;
      selectedSewaprakalpaChalanvariSansthaIDEdit = data.sewaprakalpaChalvanariSansthaId!;
      selectedSewaprakalpaChalanvariSansthaID = data.sewaprakalpaChalvanariSansthaId!;
      selectedSewaprakalpaChalanvariSansthaName = data.selectedDropdownValueName1;
      isOtherSewaprakalpaPrakaarConroller.text = data.otherSewaPrakalpaPrakaar ?? "";
      isOtherSewaprakalpaChalanvariSansthaConroller.text = data.otherSewaPrakalpaChalavinareShanstha ?? "";
      isActiveSewaprakalpa = data.isactive;
      sewaprakalpaPkId = data.pkid;
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
                            "सेवा प्रकल्प तपशील",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[700]),
                            onPressed: () {
                              clearFieldsSewaprakalpaChalanvariSanstha();
                              Navigator.of(ctx).pop();
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            vastisarvekshanDropDownDataModel != null
                                ? vastisarvekshanDropdown2(
                              dataModel: vastisarvekshanDropDownDataModel!,
                              filterTypeName: "सेवाप्रकल्पप्रकार",
                              onItemSelected: (id, value,isOther) {
                                selectedSewaprakalpaPrakaarID = id;
                                selectedSewaprakalpaPrakaarName = value;
                              },
                              hintText: "प्रकार निवडा",
                              question: "प्रकार निवडा",
                              editId: selectedSewaprakalpaPrakaarIDEdit,
                              selectedValue: selectedSewaprakalpaPrakaar,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedSewaprakalpaPrakaar = newValue;
                                });
                              },
                            )
                                : Container(),
                            const SizedBox(height: 10),
                            if(selectedSewaprakalpaPrakaar?.isOther == 1)
                            textControllerField2(name:
                              'अन्य प्रकार',controller:
                              isOtherSewaprakalpaPrakaarConroller,
                            ),
                            const SizedBox(height: 10),
                            vastisarvekshanDropDownDataModel != null
                                ? vastisarvekshanDropdown2(
                              dataModel: vastisarvekshanDropDownDataModel!,
                              filterTypeName: "सेवाप्रकल्पचालवणारीसंस्थासंघटन",
                              onItemSelected: (id, value,isOther) {
                                selectedSewaprakalpaChalanvariSansthaID = id;
                                selectedSewaprakalpaChalanvariSansthaName = value;
                                print("selectedVaramvaritaID $selectedSewaprakalpaChalanvariSansthaID |||| selectedVaramvaritaName $selectedSewaprakalpaChalanvariSansthaName");
                                isOtherSewaprakalpaChalanvariSansthaConroller.clear();
                              },
                              hintText: "संस्था/संघटन",
                              question: "संस्था/संघटन",
                              editId: selectedSewaprakalpaChalanvariSansthaIDEdit,
                              selectedValue: selectedSewaprakalpaChalanvariSanstha,
                              onSelectionChanged: (newValue) {
                                setState(() {
                                  selectedSewaprakalpaChalanvariSanstha = newValue;
                                });
                              },
                            ): Container(),
                            const SizedBox(height: 10),
                            if(selectedSewaprakalpaChalanvariSanstha?.isOther == 1)
                              textControllerField2(name: "अन्य",controller: isOtherSewaprakalpaChalanvariSansthaConroller),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  VastisarSewaPrakalpa data = VastisarSewaPrakalpa(
                                     pkid: sewaprakalpaPkId,
                                     isactive: isActiveSewaprakalpa,
                                     vastiid: int.parse(selctedLevelId!),
                                    sewaPrakalpaPrakaarId: selectedSewaprakalpaPrakaarID,
                                    otherSewaPrakalpaPrakaar: isOtherSewaprakalpaPrakaarConroller.text,
                                    selectedDropdownValueName: selectedSewaprakalpaPrakaarName,
                                    sewaprakalpaChalvanariSansthaId: selectedSewaprakalpaChalanvariSansthaID,
                                    selectedDropdownValueName1: selectedSewaprakalpaChalanvariSansthaName,
                                    otherSewaPrakalpaChalavinareShanstha:   isOtherSewaprakalpaChalanvariSansthaConroller.text ,
                                  );
                                  if (editIndex != null) {
                                    sewaPrakalpaEnteredDataList![editIndex] = data;
                                  } else {
                                    sewaPrakalpaEnteredDataList!.add(data);
                                  }
                                  Navigator.of(ctx).pop();
                                  clearFieldsSewaprakalpaChalanvariSanstha();
                                  if (onDataChanged != null) {
                                    onDataChanged();
                                  }
                                },
                                child: const Text("संग्रह",style: TextStyle(color: Colors.white),),
                              ),
                            )
                          ],
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
  void clearFieldsSewaprakalpaChalanvariSanstha() {
    selectedSewaprakalpaRowIndex = null;
    selectedSewaprakalpaPrakaarID = null;
    selectedSewaprakalpaPrakaarName = null;
    selectedSewaprakalpaChalanvariSansthaID = null;
    selectedSewaprakalpaChalanvariSansthaName = null;
    selectedSewaprakalpaPrakaarIDEdit = null;
    selectedSewaprakalpaChalanvariSansthaIDEdit = null;
    selectedSewaprakalpaPrakaar = null;
    selectedSewaprakalpaChalanvariSanstha = null;
    isActiveSewaprakalpa = 1;
    sewaprakalpaPkId = 0;
    isOtherSewaprakalpaChalanvariSansthaConroller.clear();
    isOtherSewaprakalpaPrakaarConroller.clear();
  }
//======================== ==================================================================
  List<VastisarVividhKshetracheKam>? vividhKshetaCHeKamEnteredDataList = [];
  int? selectedVastisarVividhKshetracheIndex;
  TextEditingController vividhkshetraKaamConroller = TextEditingController();
  TextEditingController vividhkshetraChalavnareSansthaSanghatanConroller = TextEditingController();
  int? isActiveVastisarVividhKshetracheKam = 1;
  int? VastisarVividhKshetracheKamPkId = 0;
  void showVividhKshetraCheKamePopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = vividhKshetaCHeKamEnteredDataList![editIndex];
      vividhkshetraKaamConroller.text = data.kaam ?? "";
      vividhkshetraChalavnareSansthaSanghatanConroller.text = data.chalavnariSansthaSanghatamn ?? "";
      isActiveVastisarVividhKshetracheKam = data.isactive;
      VastisarVividhKshetracheKamPkId = data.pkid;
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
                            "विविध क्षेत्राचे काम",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[700]),
                            onPressed: () {
                              clearFieldsVastisarVividhKshetracheKam();
                              Navigator.of(ctx).pop();
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            textControllerField2(name:
                              'काम',controller:
                            vividhkshetraKaamConroller,
                            ),
                            const SizedBox(height: 10),
                              textControllerField2(name: "चालवणारी संस्था/संघटन",controller: vividhkshetraChalavnareSansthaSanghatanConroller),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  VastisarVividhKshetracheKam data = VastisarVividhKshetracheKam(
                                     pkid: VastisarVividhKshetracheKamPkId,
                                     isactive: isActiveVastisarVividhKshetracheKam,
                                     vastiid: int.parse(selctedLevelId!),
                                    kaam:  vividhkshetraKaamConroller.text,
                                    chalavnariSansthaSanghatamn: vividhkshetraChalavnareSansthaSanghatanConroller.text ,
                                  );
                                  if (editIndex != null) {
                                    vividhKshetaCHeKamEnteredDataList![editIndex] = data;
                                  } else {
                                    vividhKshetaCHeKamEnteredDataList!.add(data);
                                  }
                                  Navigator.of(ctx).pop();
                                  clearFieldsVastisarVividhKshetracheKam();
                                  if (onDataChanged != null) {
                                    onDataChanged();
                                  }
                                },
                                child: const Text("संग्रह",style: TextStyle(color: Colors.white),),
                              ),
                            )
                          ],
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
  void clearFieldsVastisarVividhKshetracheKam() {
     selectedVastisarVividhKshetracheIndex = null;
     vividhkshetraKaamConroller.clear();
     vividhkshetraChalavnareSansthaSanghatanConroller.clear();
     isActiveVastisarVividhKshetracheKam = 1;
     VastisarVividhKshetracheKamPkId = 0;
  }
//======================== ==================================================================
  List<VastisarVividhAdhyatmikKendra>? vividhadhyatmitStsangKendraEnteredDataList = [];
  int? selectedVastisarVividhadhyatmitStsangKendraIndex;
  int? selectedVividhAAdhyatmikKendraIDEdit;
  int? selectedVividhAAdhyatmikKendraID;
  String? selectedVividhAAdhyatmikKendraName;
  Masterdata? selectedVividhAAdhyatmikKendraMasterDAta;
  // String? selectedVividhAAdhyatmikKendraGaavID;
  // String? selectedVividhAAdhyatmikKendraGaavIDEdit;
  // String? selectedVividhAAdhyatmikKendraGaavName;
  int? isActiveVividhAAdhyatmikKendra = 1;
  int? pkIdVividhAAdhyatmikKendra = 0;
  TextEditingController isOtherVividhAAdhyatmikKendraController = TextEditingController();
  TextEditingController gavPramukhAdhyatmikKendraController = TextEditingController();
  TextEditingController samparkSootraAdhyatmikKendraController = TextEditingController();
  void showVividhadhyatmitStsangKendraPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = vividhadhyatmitStsangKendraEnteredDataList![editIndex];
      selectedVividhAAdhyatmikKendraID = data.aadhyatmikKendraId;
      selectedVividhAAdhyatmikKendraIDEdit = data.aadhyatmikKendraId;
      selectedVividhAAdhyatmikKendraName = data.selectedDropdownValueName;
      isOtherVividhAAdhyatmikKendraController.text = data.isOtherAdhyatmitKendra ?? "";
      gavPramukhAdhyatmikKendraController.text = data.gaavPramukhName ?? "";
      samparkSootraAdhyatmikKendraController.text = data.samparkSootra ?? "";
      isActiveVividhAAdhyatmikKendra = data.isactive;
      pkIdVividhAAdhyatmikKendra = data.pkid;
      _linkedgraamValue = data.selectedGaavId ?? "";
      // selectedVividhAAdhyatmikKendraGaavIDEdit = data.selectedGaavId ?? "";
      // selectedVividhAAdhyatmikKendraGaavName = data.selectedDropdownValueName1;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(16),
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "आध्यात्मिक केंद्र",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[700]),
                            onPressed: () {
                              clearVividhadhyatmitStsangKendra();
                              Navigator.of(ctx).pop();
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      vastisarvekshanDropDownDataModel != null
                          ? vastisarvekshanDropdown2(
                        dataModel: vastisarvekshanDropDownDataModel!,
                        filterTypeName: "आध्यात्मिकसत्संगकेंद्र",
                        onItemSelected: (id, value, isOther) {
                          selectedVividhAAdhyatmikKendraID = id;
                          selectedVividhAAdhyatmikKendraName = value;
                        },
                        hintText: "आध्यात्मिक केंद्र",
                        question: "आध्यात्मिक केंद्र",
                        editId: selectedVividhAAdhyatmikKendraID,
                        selectedValue: selectedVividhAAdhyatmikKendraMasterDAta,
                        onSelectionChanged: (newValue) {
                          setState(() {
                            selectedVividhAAdhyatmikKendraMasterDAta = newValue;
                          });
                        },
                      )
                          : Container(),
                      const SizedBox(height: 10),
                      if (selectedVividhAAdhyatmikKendraMasterDAta?.isOther == 1)
                        textControllerField2(name: "अन्य", controller: isOtherVividhAAdhyatmikKendraController),
                      textControllerField2(name: "गाव प्रमुखाचे नाव", controller: gavPramukhAdhyatmikKendraController),
                      textControllerField2(name: "दूरभाष", controller: samparkSootraAdhyatmikKendraController,keyboardType: TextInputType.number,maxInput: 10,height: 80),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            VastisarVividhAdhyatmikKendra data = VastisarVividhAdhyatmikKendra(
                              pkid: pkIdVividhAAdhyatmikKendra,
                              isactive: isActiveVividhAAdhyatmikKendra,
                              vastiid: int.parse(selctedLevelId!),
                              selectedDropdownValueName: selectedVividhAAdhyatmikKendraName,
                              aadhyatmikKendraId: selectedVividhAAdhyatmikKendraID,
                              gaavPramukhName: gavPramukhAdhyatmikKendraController.text,
                              isOtherAdhyatmitKendra: isOtherVividhAAdhyatmikKendraController.text,
                              samparkSootra: samparkSootraAdhyatmikKendraController.text,
                              // selectedGaavId: selectedVividhAAdhyatmikKendraGaavID,
                              // selectedDropdownValueName1: selectedVividhAAdhyatmikKendraGaavName,
                            );

                            if (editIndex != null) {
                              vividhadhyatmitStsangKendraEnteredDataList![editIndex] = data;
                            } else {
                              vividhadhyatmitStsangKendraEnteredDataList!.add(data);
                            }

                            Navigator.of(ctx).pop();
                            clearVividhadhyatmitStsangKendra();
                            if (onDataChanged != null) {
                              onDataChanged();
                            }
                          },
                          child: const Text("संग्रह", style: TextStyle(color: Colors.white)),
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

  void clearVividhadhyatmitStsangKendra() {
     selectedVividhAAdhyatmikKendraIDEdit = null;
     selectedVividhAAdhyatmikKendraID = null;
     selectedVividhAAdhyatmikKendraName = null;
     selectedVividhAAdhyatmikKendraMasterDAta = null;
     // selectedVividhAAdhyatmikKendraGaavID = null;
     // selectedVividhAAdhyatmikKendraGaavIDEdit = null;
     // selectedVividhAAdhyatmikKendraGaavName = null;
     // _linkedgraamValue = "";
     isActiveVividhAAdhyatmikKendra = 1;
     pkIdVividhAAdhyatmikKendra = 0;
     isOtherVividhAAdhyatmikKendraController.clear();
     gavPramukhAdhyatmikKendraController.clear();
     samparkSootraAdhyatmikKendraController.clear();
  }
  //======================== ==================================================================
  List<VastisarGavatilMumbaikar>? gavatilMumbaikarEnteredDataList = [];
  int? selectedGavatilMumbaikarIndex;
  TextEditingController gavatilMumbaikarSthanNameConroller = TextEditingController();
  TextEditingController gavatilMumbaikarPramukhNameConroller = TextEditingController();
  TextEditingController gavatilMumbaikarDoorbhashConroller = TextEditingController();
  int? isActiveGavatilMumbaikar = 1;
  int? pkIdGavatilMumbaikar = 0;
  void showGavatilMumbaikarPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
    if (editIndex != null) {
      var data = gavatilMumbaikarEnteredDataList![editIndex];
      gavatilMumbaikarSthanNameConroller.text = data.sthaan ?? "";
      gavatilMumbaikarPramukhNameConroller.text = data.pramukhachrNaav ?? "";
      gavatilMumbaikarDoorbhashConroller.text = data.doorbhash ?? "";
      isActiveGavatilMumbaikar = data.isactive;
      pkIdGavatilMumbaikar = data.pkid;
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
                            "गावातील मुंबईकर मंडळ",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[700]),
                            onPressed: () {
                              clearFieldsGavatilMumbaikar();
                              Navigator.of(ctx).pop();
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            textControllerField2(name:
                            'स्थान',controller:
                            gavatilMumbaikarSthanNameConroller,
                            ),
                            const SizedBox(height: 10),
                            textControllerField2(name: "प्रमुखाचे नाव",controller: gavatilMumbaikarPramukhNameConroller),
                            const SizedBox(height: 20),
                            textControllerField2(name: "दूरभाष", controller: gavatilMumbaikarDoorbhashConroller,keyboardType: TextInputType.number,maxInput: 10,height: 80),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  VastisarGavatilMumbaikar data = VastisarGavatilMumbaikar(
                                    pkid: VastisarVividhKshetracheKamPkId,
                                    isactive: isActiveVastisarVividhKshetracheKam,
                                    vastiid: int.parse(selctedLevelId!),
                                    sthaan: gavatilMumbaikarSthanNameConroller.text,
                                    pramukhachrNaav: gavatilMumbaikarPramukhNameConroller.text ,
                                    doorbhash: gavatilMumbaikarDoorbhashConroller.text ,
                                  );
                                  if (editIndex != null) {
                                    gavatilMumbaikarEnteredDataList![editIndex] = data;
                                  } else {
                                    gavatilMumbaikarEnteredDataList!.add(data);
                                  }
                                  Navigator.of(ctx).pop();
                                  clearFieldsGavatilMumbaikar();
                                  if (onDataChanged != null) {
                                    onDataChanged();
                                  }
                                },
                                child: const Text("संग्रह",style: TextStyle(color: Colors.white),),
                              ),
                            )
                          ],
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
  void clearFieldsGavatilMumbaikar() {
    gavatilMumbaikarSthanNameConroller.clear();
    gavatilMumbaikarPramukhNameConroller.clear();
    gavatilMumbaikarDoorbhashConroller.clear();
    isActiveGavatilMumbaikar = 1;
    pkIdGavatilMumbaikar = 0;
  }
//========================  GATIVIDHI FORM ===========================================
  List<VastisarGatividhikaryasthiti> enteredDataListGatividhi = [];
//========================  4. VASAHAT PRAKAR FORM ===========================================
  List<VastisarVasahatprakara> enteredVasahatPrakarDataList = [];
//========================  5. VIVIDH BHASHA BOLNARE FORM ===========================================
  List<VastisarVividhaprakara> enteredVividhBhashaBolnareDataList = [];
//========================  6.KONTYA PRANTACHE FORM ===========================================
  List<VastisarKonatyaprantache> enteredKontyaPraantacheDataList = [];
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
                          const Text("रिलीजन",
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
                        child: Text("कोणत्या रिलीजनचे", style: TextStyle(fontSize: 15)),
                      ),

                      vastisarvekshanDropdown2(
                        dataModel: vastisarvekshanDropDownDataModel!,
                        filterTypeName: "रिलीजन",
                        hintText: "रिलीजन निवडा",
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
                      ),
                      SizedBox(height: 10),
                      textControllerField2(
                        controller: religionAveragePersentCount,
                        name: "अंदाजे (%)",
                        keyboardType: TextInputType.number,
                        height: 50,
                        hintTextString: "उदा. ० ते १०० ",
                        maxInput: 3
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
                          //   VastisarReligion newReligion = VastisarReligion(
                          //     pkid: pkIdReligion ?? 0,
                          //     vastiid: int.parse(selctedLevelId!),
                          //     konatyarilijanaceid: religionId,
                          //     selectedDropdownValueName: religionName,
                          //     andaje: religionAveragePersentCount.text.trim(),
                          //     isactive: isActiveReligion ?? 1,
                          //   );
                          //   if (editIndex != null) {
                          //     enteredreligionDataList[editIndex] = newReligion;
                          //   } else {
                          //     enteredreligionDataList.add(newReligion);
                          //   }
                          //   clearFields6();
                          //   setState(() {});
                          //   Navigator.of(ctx).pop();
                          //   if (onDataChanged != null) onDataChanged();
                          // },
                          onPressed: () {
                            // Parse percentage safely
                            double? percent = double.tryParse(religionAveragePersentCount.text.trim());

                            if (percent == null) {
                              Statics.showToast("कृपया वैध टक्केवारी एंटर करा.");
                              return;
                            }

                            if (percent > 100) {
                              Statics.showToast("टक्केवारी १०० पेक्षा जास्त असू शकत नाही.");

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

                          child: Text("संग्रह", style: TextStyle(color: Colors.white)),
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
                "उपासना स्थळ माहिती",
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
                      hintText: "उपासना स्थळ निवडा",
                      onItemSelected: (id, value,isOther) {
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
                    if(selectedUpasnaSthal?.isOther == 1)
                      SizedBox(height: 10),
                    if(selectedUpasnaSthal?.isOther == 1)
                      textControllerField2(controller:anyaUpasnaSthalNameController,name:"अन्य उपासना स्थळ",height: 50,hintTextString: "अन्य उपासना स्थळ"),
                    const SizedBox(height: 10),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "प्रकार",
                      hintText: "प्रकार निवडा",
                      onItemSelected: (id, value,isOther) {
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "संख्या",
                        labelText: "संख्या",
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
                  if(selectedUpasnaSthal?.isOther == 1 && anyaUpasnaSthalNameController.text == ""){
                    Statics.showToast("'अन्य' माहिती आवश्यक.");
                  } else {
                    Vastisarupaasana newData = Vastisarupaasana(
                      upaasanasthalaid: selectedUpasnaSthalId,
                      selectedDropdownValueName: selectedUpasnaSthalName,
                      prakarid: selectedUpasnaSthalTypeId,
                      selectedDropdownValueName1: selectedUpasnaSthalTypeName,
                      sankhya: upasnaSthalCountController.text.trim(),
                      isactive: isActiveUpasanaSthal,
                      otherupaasanasthala: anyaUpasnaSthalNameController.text,
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
                child: Text("संग्रह", style: TextStyle(color: Colors.white)),
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

    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "सज्जन शक्ति माहिती",
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
                } ,
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textControllerField2(name: "नाव", controller: sajjanShaktiNameController ,),
                    textControllerField2(name: "पत्ता", controller: sajjanShaktiAddressController),
                    textControllerField2(name: "दूरभाष", controller: sajjanShaktiPhoneController,keyboardType: TextInputType.number,maxInput: 10,),
                    vastisarvekshanDropdown2(
                      question:  "श्रेणी",
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति श्रेणी",
                      hintText: "श्रेणी",
                      onItemSelected: (id, value,isOther) {
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
                    if(sajjanShaktiShreniEditDataId?.isOther == 1)
                      const SizedBox(height: 5),
                    if(sajjanShaktiShreniEditDataId?.isOther == 1)
                    textControllerField2(name: "अन्य श्रेणी", controller: sajjanShaktiAnyaShreniNameController),
                    const SizedBox(height: 5),
                    textControllerField2(name: "संस्थेचे नाव", controller: sajjanShaktiSansthecheNaavController),
                    const SizedBox(height: 5),
                    textControllerField2(name: "संस्थेत कुठल्या पदावर", controller: sajjanShaktiSansthKuthalyaPadavarController),
                    const SizedBox(height: 5),
                    vastisarvekshanDropdown2(
                      question: "संपर्क स्थिति",
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति संपर्क स्थिति",
                      hintText: "संपर्क स्थिति",
                      onItemSelected: (id, value,isOther) {
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
                      hintText: "विशेष",
                      question: "विशेष",
                      onItemSelected: (id, value,isOther) {
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
                    if(sajjanShaktiVisheshEditDataId?.isOther == 1)
                      const SizedBox(height: 5),
                    if(sajjanShaktiVisheshEditDataId?.isOther == 1)
                    textControllerField2(name: "अन्य विशेष", controller: sajjanShaktiAnyaVisheshNameController),
                    const SizedBox(height: 5),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "सज्जन शक्ति प्रभाव क्षेत्र",
                      hintText: "प्रभाव क्षेत्र",
                      question: "प्रभाव क्षेत्र",
                      onItemSelected: (id, value,isOther) {
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
                    textControllerField2(name: "संपर्क सूत्र नाव", controller: sajjanShaktiContactPersonNameController),
                    const SizedBox(height: 5),
                    textControllerField2(name: "संपर्क सूत्रांचे दूरभाष", controller: sajjanShaktiContactPersonDoorbhashController,keyboardType: TextInputType.number,maxInput: 10,),

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
                //
                //
                //
                //   Vastisarsajjanshakti newData = Vastisarsajjanshakti(
                //       name: sajjanShaktiNameController.text.trim(),
                //       address: sajjanShaktiAddressController.text.trim(),
                //       doorabhaash: sajjanShaktiPhoneController.text.trim(),
                //       shreneeid: sajjanShaktiShreniId,
                //       selectedDropdownValueName: sajjanShaktiShreniName,
                //       otherShreniName: sajjanShaktiAnyaShreniNameController.text.trim(),
                //       sanstheCheNaav: sajjanShaktiSansthecheNaavController.text.trim(),
                //       sansthechaKuthalaPadavar: sajjanShaktiSansthKuthalyaPadavarController.text.trim(),
                //       samparksthitiid: sajjanShaktiSamparkStithiId,
                //       selectedDropdownValueName1: sajjanShaktiSamparkStithiName,
                //       visheshId: sajjanShaktiVisheshId,
                //       selectedDropdownValueName2: sajjanShaktiVisheshName,
                //       otherVisheshName: sajjanShaktiAnyaVisheshNameController.text.trim(),
                //       prabhaavkshetrid: sajjanShaktiPrabhavKeshtraId,
                //       selectedDropdownValueName3: sajjanShaktiPrabhavKeshtraName,
                //       samparkasutranava: sajjanShaktiContactPersonNameController.text.trim(),
                //       samparkasutraMobileNumber: sajjanShaktiContactPersonDoorbhashController.text.trim(),
                //       isactive: isActiveSajjanShakti,
                //       vastiid: int.parse(selctedLevelId!),
                //       pkid: pkidSajjanShakti
                //   );
                //   if (editIndex != null) {
                //     sajjanShaktiDataList[editIndex] = newData;
                //   } else {
                //     sajjanShaktiDataList.add(newData);
                //   }
                //   clearSajjanShaktiFields();
                //   if (onDataChanged != null) {
                //     onDataChanged();
                //   }
                //   Navigator.of(ctx).pop();
                // },
                onPressed: () {
                  if((sajjanShaktiShreniEditDataId?.isOther == 1 && sajjanShaktiAnyaShreniNameController.text == "")||
                      (sajjanShaktiVisheshEditDataId?.isOther == 1 && sajjanShaktiAnyaVisheshNameController.text == "")){
                    Statics.showToast("'अन्य' माहिती आवश्यक.");
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
                        pkid: pkidSajjanShakti
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
                child: Text("संग्रह", style: TextStyle(color: Colors.white)),
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
  String? anyaPrabhaviLokShreniName;
  int? anyaPrabhaviLokUpShreniId;
  String? anyaPrabhaviLokUpShreniName;
  int? anyaPrabhaviLokUpShreni1Id;
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
    if (editIndex != null) {
      var data = anyaPrabhaviLokDataList[editIndex];
      anyaPrabhaviLokNaavController.text = data.name ?? "";
      anyaPrabhaviLokAddressController.text = data.address ?? "";
      anyaPrabhaviLokMobileNoController.text = data.doorabhaash ?? "";
      anyaPrabhaviLokShreniId = data.shreneeid;
      anyaPrabhaviLokShreniName = data.selectedDropdownValueName;
      anyaPrabhaviLokUpShreniId = data.upshreneeid;
      anyaPrabhaviLokUpShreniName = data.selectedDropdownValueName1;
      anyaPrabhaviLokAnyaUppshreniController.text = data.otherupshrenee ?? "";
      anyaPrabhaviLokUpShreni1Id = data.upshreneeid2;
      anyaPrabhaviLokUpShreni1Name = data.selectedDropdownValueName2;
      anyaPrabhaviLokAnyaUppshreni1Controller.text = data.otherupshrenee2 ?? "";
      anyaPrabhaviLokVisheshId = data.visheshid;
      anyaPrabhaviLokVisheshName = data.selectedDropdownValueName3;
      anyaPrabhaviLokPrabhavKshetraId = data.prabhaavkshetrid;
      anyaPrabhaviLokPrabhavKshetraName = data.selectedDropdownValueName4;
      anyaPrabhaviLokAnyaVisheshMahitiController.text = data.othervishesh ?? "";
      anyaPrabhaviLokSamparkStithiId = data.samparksthitiid;
      anyaPrabhaviLokSamparkStithiName = data.selectedDropdownValueName5;
      anyaPrabhaviLokSamparkSutraNaavController.text = data.samparkasutranav ?? "";
      anyaPrabhaviLokSamparkSutraDoorbhashController.text = data.samparkaSutraDoorbhash ?? "";
      pkidAnyaPrabhaviLok = data.pkid;
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "अन्य प्रभावी लोकं",
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
                    textControllerField2(name: "नाव",controller:  anyaPrabhaviLokNaavController,  height: 50),
                    textControllerField2(name: "पत्ता",controller:  anyaPrabhaviLokAddressController,  height: 80),
                    textControllerField2(name: "दूरभाष", controller: anyaPrabhaviLokMobileNoController,  height: 50,keyboardType: TextInputType.number,maxInput: 10,),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "श्रेणी/उपश्रेणी",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 5),
                    vastisarvekshanDropDownDataModel != null?
                    vastisarvekshanDropdown3(
                      filterTypeName: "श्रेणी",
                      hintText: "श्रेणी निवडा",
                      selectedValue: selectedShreni,
                      selectedDependentValue: selectedUpShreni,
                      selectedThirdLevelValue: selectedUpShreni2,
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
                    ):Container(),
                    SizedBox(height: 10,),
                    if(selectedUpShreni?.isOther  == 1)
                      textControllerField2(name: "अन्य उपश्रेणी", controller: anyaPrabhaviLokAnyaUppshreniController),
                    SizedBox(height: 10,),
                    if(selectedUpShreni2?.isOther  == 1)
                      textControllerField2(name: "अन्य उपश्रेणी 2", controller: anyaPrabhaviLokAnyaUppshreni1Controller),
                    SizedBox(height: 10,),
                    vastisarvekshanDropDownDataModel != null ?
                    vastisarvekshanDropdown2(
                      hintText: "विशेष निवडा",
                      filterTypeName: "अन्यप्रभावीलोकंविशेष",
                      onItemSelected: (valueId, valueName,isOther) {
                        anyaPrabhaviLokVisheshId = valueId;
                        anyaPrabhaviLokVisheshName =  valueName;
                        print("id = $valueId --- Name = $valueName");
                      },
                      dataModel: vastisarvekshanDropDownDataModel!,
                      question: "विशेष",
                      editId: selectedAnyaPrabhaviLokVisheshIDEdit,
                      selectedValue:selectedAnyaPrabhaviLokVishesh,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedAnyaPrabhaviLokVishesh = newValue;
                        });
                      },
                    ):Container(),
                    SizedBox(height: 10,),
                    vastisarvekshanDropDownDataModel != null ?
                    vastisarvekshanDropdown2(
                      hintText: "प्रभाव क्षेत्र निवडा",
                      filterTypeName: "अन्यप्रभावीलोकंप्रभावक्षेत्र",
                      onItemSelected: (valueId, valueName,isOther) {
                        anyaPrabhaviLokPrabhavKshetraId = valueId;
                        anyaPrabhaviLokPrabhavKshetraName =  valueName;
                        print("id = $valueId --- Name = $valueName");
                      },
                      dataModel: vastisarvekshanDropDownDataModel!,
                      question: "प्रभाव क्षेत्र",
                      editId: selectedAnyaPrabhaviLokPrabhavKshetraIDEdit,
                      selectedValue:selectedAnyaPrabhaviLokPrabhavKshetra,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedAnyaPrabhaviLokPrabhavKshetra = newValue;
                        });
                      },
                    ):Container(),
                    textControllerField2(name: "अन्य विशेष माहिती",controller: anyaPrabhaviLokAnyaVisheshMahitiController,height: 80),
                    // SizedBox(height: 10,),
                    vastisarvekshanDropDownDataModel != null ?
                    vastisarvekshanDropdown2(
                      hintText: "संपर्क स्थिति निवडा",
                      filterTypeName: "अन्यप्रभावीलोकंसंपर्कस्थिति",
                      onItemSelected: (valueId, valueName,isOther) {
                        anyaPrabhaviLokSamparkStithiId = valueId;
                        anyaPrabhaviLokSamparkStithiName =  valueName;
                        print("id = $valueId --- Name = $valueName");
                      },
                      dataModel: vastisarvekshanDropDownDataModel!,
                      question: "संपर्क स्थिति",
                      editId: selectedAnyaPrabhaviLokSamparkStithiIDEdit,
                      selectedValue:selectedAnyaPrabhaviLokSamparkStithi,
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedAnyaPrabhaviLokSamparkStithi = newValue;
                        });
                      },
                    ):Container(),
                    // textControllerField("अन्य विशेष माहिती", anyaPrabhaviLokAnyaVisheshMahitiController, context, height: 80),
                    textControllerField2(name: "संपर्क सूत्र नाव", controller: anyaPrabhaviLokSamparkSutraNaavController, height: 50),
                    textControllerField2(name: "संपर्क सूत्रांचे दूरभाष", controller: anyaPrabhaviLokSamparkSutraDoorbhashController, height: 50,keyboardType: TextInputType.number,maxInput: 10,),
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
                //   VastisarAnyaprabhavilokam data = VastisarAnyaprabhavilokam(
                //     name: anyaPrabhaviLokNaavController.text,
                //     address: anyaPrabhaviLokAddressController.text,
                //     doorabhaash: anyaPrabhaviLokMobileNoController.text,
                //     shreneeid: anyaPrabhaviLokShreniId,
                //     selectedDropdownValueName : anyaPrabhaviLokShreniName,
                //     upshreneeid : anyaPrabhaviLokUpShreniId,
                //     selectedDropdownValueName1 : anyaPrabhaviLokUpShreniName,
                //     upshreneeid2: anyaPrabhaviLokUpShreni1Id,
                //     selectedDropdownValueName2: anyaPrabhaviLokUpShreni1Name,
                //     visheshid : anyaPrabhaviLokVisheshId,
                //     selectedDropdownValueName3: anyaPrabhaviLokVisheshName,
                //     prabhaavkshetrid: anyaPrabhaviLokPrabhavKshetraId,
                //     selectedDropdownValueName4: anyaPrabhaviLokPrabhavKshetraName,
                //     othervishesh: anyaPrabhaviLokAnyaVisheshMahitiController.text,
                //     samparksthitiid : anyaPrabhaviLokSamparkStithiId,
                //     selectedDropdownValueName5: anyaPrabhaviLokSamparkStithiName,
                //     samparkasutranav: anyaPrabhaviLokSamparkSutraNaavController.text,
                //     samparkaSutraDoorbhash: anyaPrabhaviLokSamparkSutraDoorbhashController.text,
                //     pkid: pkidAnyaPrabhaviLok,
                //     anyavisesamahiti:anyaPrabhaviLokAnyaVisheshMahitiController.text,
                //     otherupshrenee: anyaPrabhaviLokAnyaUppshreniController.text,
                //     otherupshrenee2:  anyaPrabhaviLokAnyaUppshreni1Controller.text,
                //     isactive:  isActiveAnyaPrabhavilok,
                //     vastiid: int.parse(selctedLevelId!),
                //   );
                //   if (editIndex != null) {
                //     anyaPrabhaviLokDataList[editIndex] = data;
                //   } else {
                //     anyaPrabhaviLokDataList.add(data);
                //   }
                //   clearAnyaPrabhaviLokFields();
                //   if (onDataChanged != null) {
                //     onDataChanged();
                //   }
                //   Navigator.of(ctx).pop();
                // },
                onPressed: () {
                  if((selectedUpShreni?.isOther == 1 && anyaPrabhaviLokAnyaUppshreniController.text == "")||
                      (selectedUpShreni2?.isOther == 1 && anyaPrabhaviLokAnyaUppshreni1Controller.text == "")){
                    Statics.showToast("'अन्य' माहिती आवश्यक.");
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
                      samparkaSutraDoorbhash: anyaPrabhaviLokSamparkSutraDoorbhashController
                          .text,
                      pkid: pkidAnyaPrabhaviLok,
                      anyavisesamahiti: anyaPrabhaviLokAnyaVisheshMahitiController.text,
                      otherupshrenee: anyaPrabhaviLokAnyaUppshreniController.text,
                      otherupshrenee2: anyaPrabhaviLokAnyaUppshreni1Controller.text,
                      isactive: isActiveAnyaPrabhavilok,
                      vastiid: int.parse(selctedLevelId!),
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

                child: Text("संग्रह", style: TextStyle(color: Colors.white)),
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
                "गावात होणारे सण",
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
                      hintText: "सण निवडा",
                      onItemSelected: (id, value,isOther) {
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
                        setState((){});
                      },
                      editId: selectedSanIdEdit,
                    ),
                    const SizedBox(height: 10),
                    if(selectedMasterSanName?.isOther == 1)
                      textControllerField2(name: "अन्य सण",controller:  vastitSajarHonareAnyaSanController, height: 50),
                    textControllerField2(name: "आयोजक संस्थाची नावे",controller:  vastitSajarHonareSanAyojakSansthaNameController, height: 50),
                    textControllerField2(name: "आयोजकांची नावे",controller:  vastitSajarHonareSanAyojakNameController,  height: 50),
                    textControllerField2(name: "आयोजक संपर्क सूत्र",controller:  vastitSajarHonareSanAyojakSamparkController,  height: 50),
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
                //   VastisarVastitamahatvacesana data =VastisarVastitamahatvacesana(
                //     id : selectedSanId ,
                //     selectedDropdownValueName: selectedSanName,
                //     ayojakasansthacinave: vastitSajarHonareSanAyojakSansthaNameController.text,
                //     ayojakancinave: vastitSajarHonareSanAyojakNameController.text,
                //     aayojaksamparksootr: vastitSajarHonareSanAyojakSamparkController.text,
                //     // selectedMasterSanName = data['sanObj'];
                //     otherSajareSan : vastitSajarHonareAnyaSanController.text,
                //     isactive: isActiveSajareHonareSan,
                //     pkid: pkidSajareHonareSan ?? 0,
                //     vastiid: int.parse(selctedLevelId!),
                //   );
                //   if (editIndex != null) {
                //     vastitSajarHonareSanDataList[editIndex] = data;
                //   } else {
                //     vastitSajarHonareSanDataList.add(data);
                //   }
                //   clearvastitSajarHonareSanFields();
                //   if (onDataChanged != null) {
                //     onDataChanged();
                //   }
                //   Navigator.of(ctx).pop();
                // },
                onPressed: () {
                  if((selectedMasterSanName?.isOther == 1 && vastitSajarHonareAnyaSanController.text == "")){
                    Statics.showToast("'अन्य' माहिती आवश्यक.");
                  } else {
                    VastisarVastitamahatvacesana data = VastisarVastitamahatvacesana(
                      id: selectedSanId,
                      selectedDropdownValueName: selectedSanName,
                      ayojakasansthacinave: vastitSajarHonareSanAyojakSansthaNameController
                          .text,
                      ayojakancinave: vastitSajarHonareSanAyojakNameController.text,
                      aayojaksamparksootr: vastitSajarHonareSanAyojakSamparkController
                          .text,
                      // selectedMasterSanName = data['sanObj'];
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

                child: Text("संग्रह", style: TextStyle(color: Colors.white)),
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

  //=================================================== 10. VASTIT SAJAR HONARE SAN Lok FORM ====================================================================================
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
      selectedSamajikKaryakramIdEdit = data.id;
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
                "गावातील महत्वाचे\nसामाजिक कार्यक्रम",
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
                      hintText: "कार्यक्रम निवडा",
                      onItemSelected: (id, value,isOther) {
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
                    if(selectedSamajikKaryakramName == "अन्य")
                      textControllerField("अन्य", vastitSajarHonareSamajikKaryakramAnya1Controller, context, height: 50),
                    textControllerField("आयोजक संस्थाची नावे", vastitSajarHonareSamajikKaryakramAyojakSansthaNameController, context, height: 50),
                    textControllerField("आयोजकांची नावे", vastitSajarHonareSamajikKaryakramAyojakNameController, context, height: 80),
                    textControllerField("आयोजक संपर्क सूत्र", vastitSajarHonareSamajikKaryakramAyojakSamparkController, context, height: 50),
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
                //   VastisarVastitasajaraSamajikkaryakram data = VastisarVastitasajaraSamajikkaryakram(
                //       id: selectedSamajikKaryakramId,
                //       vastiid: int.parse(selctedLevelId!),
                //       pkid: pkidSamajikKaryakram,
                //       isactive: isActiveSamajikKaryakram,
                //       selectedDropdownValueName: selectedSamajikKaryakramName,
                //       otherKaryakram:vastitSajarHonareSamajikKaryakramAnya1Controller.text,
                //       ayojakasansthacinave:vastitSajarHonareSamajikKaryakramAyojakSansthaNameController.text,
                //       ayojakancinave: vastitSajarHonareSamajikKaryakramAyojakNameController.text,
                //       aayojaksamparksootr: vastitSajarHonareSamajikKaryakramAyojakSamparkController.text
                //   );
                //   if (editIndex != null) {
                //     vastitSajarHonareSamajikKaryakramDataList[editIndex] = data;
                //   } else {
                //     vastitSajarHonareSamajikKaryakramDataList.add(data);
                //   }
                //   clearvastitSajarHonareSamajikKaryakramFields();
                //   if (onDataChanged != null) {
                //     onDataChanged();
                //   }
                //   Navigator.of(ctx).pop();
                // },
                onPressed: () {
                  if((selectedMasterSamajikKaryakramName?.isOther == 1 && vastitSajarHonareSamajikKaryakramAnya1Controller.text == "")){
                    Statics.showToast("'अन्य' माहिती आवश्यक.");
                  } else {
                    VastisarVastitasajaraSamajikkaryakram data = VastisarVastitasajaraSamajikkaryakram(
                        id: selectedSamajikKaryakramId,
                        vastiid: int.parse(selctedLevelId!),
                        pkid: pkidSamajikKaryakram,
                        isactive: isActiveSamajikKaryakram,
                        selectedDropdownValueName: selectedSamajikKaryakramName,
                        otherKaryakram: vastitSajarHonareSamajikKaryakramAnya1Controller
                            .text,
                        ayojakasansthacinave: vastitSajarHonareSamajikKaryakramAyojakSansthaNameController
                            .text,
                        ayojakancinave: vastitSajarHonareSamajikKaryakramAyojakNameController
                            .text,
                        aayojaksamparksootr: vastitSajarHonareSamajikKaryakramAyojakSamparkController
                            .text
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

                child: Text("संग्रह", style: TextStyle(color: Colors.white)),
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

//========================   Detailed INFO FORM ===========================================
//========================   Detailed INFO FORM ===========================================
//========================   Detailed INFO FORM ===========================================
//========================   Detailed INFO FORM ===========================================

  //=================================================== 18. Vasti Prashna Garja FORM ====================================================================================

  List<VastisarVastitilasamajika> vastiPrashnaGarjaDataList = [];
  //=================================================== 19. DHARMIK NETRUTVA FORM ====================================================================================
  List<Vastisardhaarmiknetrtav> dharmikNetrutvaDataList = [];
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
              Text("दुर्जन शक्ति", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.purpleAccent)),
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
                    textControllerField("नाव", durjanShaktiNaavController, context, height: 50),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "दुर्जनशक्तिप्रकार",
                      hintText: "प्रकार",
                      onItemSelected: (id, value,isOther) {
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
                    if(selectedMasterDurjanShaktiPrakarName?.isOther == 1)
                      textControllerField("अन्य प्रकार", durjanShaktiAnyaPrkarController, context, height: 50),
                    const SizedBox(height: 5),
                    vastisarvekshanDropdown2(
                      dataModel: vastisarvekshanDropDownDataModel!,
                      filterTypeName: "दुर्जनशक्तिशिक्षा",
                      hintText: "शिक्षा",
                      onItemSelected: (id, value,isOther) {
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
                      hintText: "गुन्हा",
                      onItemSelected: (id, value,isOther) {
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
                // onPressed: () {
                //   Vastisardurjanshakti data = Vastisardurjanshakti (
                //       name: durjanShaktiNaavController.text,
                //       pkid: pkidDurjanShaktiGunha,
                //       isactive: isActivedDurjanShaktiGunha,
                //       vastiid:  int.parse(selctedLevelId!),
                //       selectedDropdownValueName: selectedDurjanShaktiPrakarName,
                //       selectedDropdownValueName1: selectedDurjanShaktiShikashaName,
                //       selectedDropdownValueName2: selectedDurjanShaktiGunhaName,
                //       gunha: selectedDurjanShaktiGunhaId,
                //       prakar: selectedDurjanShaktiPrakarId,
                //       shiksha: selectedDurjanShaktiShikshaId,
                //       otherPrakar: durjanShaktiAnyaPrkarController.text
                //   );
                //   if (editIndex != null) {
                //     durjanShaktiDataList[editIndex] = data;
                //   } else {
                //     durjanShaktiDataList.add(data);
                //   }
                //   if (onDataChanged != null) {
                //     onDataChanged();
                //   }
                //   Navigator.of(ctx).pop();
                //   clearDurjanShakti();
                // },
                onPressed: () {
                  if((selectedMasterDurjanShaktiPrakarName?.isOther == 1 && durjanShaktiAnyaPrkarController.text == "")){
                    Statics.showToast("'अन्य' माहिती आवश्यक.");
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
                        otherPrakar: durjanShaktiAnyaPrkarController.text
                    );
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

                child: Text("संग्रह", style: TextStyle(color: Colors.white)),
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
                "हिंदू वीर यादी",
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
                  hinduVeerYadiNameControler.clear();
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
                      "नाव",
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
                    vastiid:  int.parse(selctedLevelId!),
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
                child: Text("संग्रह", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      child: Column(
        children: [
          //=====================  DHARMIK NETRUTVA  ================================================================
          mainContainer("दुर्जन शक्ति",Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {

                      if (isVastiSearch) {
                        showDurjanShaktiPopup(context,onDataChanged: () { setState(() {});});
                      } else {
                        showPopupForVastiValidation(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),

                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 15),
                            SizedBox(width: 5),
                            Text(
                              "नवीन",
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
                            headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                            columns: const [
                              DataColumn(label: Text("नाव",)),
                              DataColumn(label: Text("प्रकार",)),
                              DataColumn(label: Text("शिक्षा", )),
                              DataColumn(label: Text("गुन्हा",)),
                            ],
                            rows: durjanShaktiDataList.asMap()
                                .entries
                                .where((entry) => entry.value.isactive == 1)
                                .map((entry) {
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
                        )
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6,),
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
                                        "दुर्जन शक्ति",
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
                                          _buildInfoRow("नाव", selectedData.name),
                                          _buildInfoRow("प्रकार", selectedData.selectedDropdownValueName),
                                          _buildInfoRow("अन्य प्रकार", selectedData.otherPrakar),
                                          _buildInfoRow("शिक्षा", selectedData.selectedDropdownValueName1),
                                          _buildInfoRow("गुन्हा", selectedData.selectedDropdownValueName2),
                                        ],
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                          child:Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                        ),
                        SizedBox(width: 20,),
                        InkWell(
                          onTap: () {showDurjanShaktiPopup(context, editIndex: selectedDurjanShaktiIdIndex, onDataChanged: () { setState(() {});});},
                          child:Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                        SizedBox(width: 20,),
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
                                    "पुष्टीकरण",
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
                                    "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                    child: const Text(
                                      "नाही",
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
                                    child: const Text(
                                      "होय",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (shouldDelete == true && selectedDurjanShaktiIdIndex != null) {
                              // setState(() {
                              //   durjanShaktiDataList
                              //       .removeAt(selectedDurjanShaktiIdIndex!);
                              //   selectedDurjanShaktiIdIndex = null;
                              // });
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
          mainContainer("हिंदू वीर यादी",Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (isVastiSearch) {
                        showHinduVeerYadiPopup(context,onDataChanged: () { setState(() {});});
                      } else {
                        showPopupForVastiValidation(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      width: 100,
                      decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent.shade100),color: Colors.purpleAccent.withOpacity(0.7) ,borderRadius: BorderRadius.circular(15)),

                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 15),
                            SizedBox(width: 5),
                            Text(
                              "नवीन",
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
                            headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                            columns: const [
                              DataColumn(label: Text("क्र.")),
                              DataColumn(label: Text("नाव",)),
                            ],
                            rows: hinduVeerYadiDataList.asMap()
                                .entries
                                .where((entry) => entry.value.isactive == 1)
                                .map((entry) {
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
                                    DataCell(Text("${index+1}")),
                                    DataCell(Text(data.name ?? '')),
                                  ]);
                            }).toList(),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6,),
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
                                        "हिंदू वीर यादी",
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
                                          _buildInfoRow("नाव", selectedData.name),
                                        ],
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("बंद करा", style: TextStyle(color: Colors.white)),
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
                          child:Icon(Icons.remove_red_eye, color: Colors.green, size: 20),
                        ),
                        SizedBox(width: 20,),
                        InkWell(
                          onTap: () {showHinduVeerYadiPopup(context, editIndex: selectedHinduVeerYadiIdIndex, onDataChanged: () { setState(() {});});},
                          child:Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                        SizedBox(width: 20,),
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
                                    "पुष्टीकरण",
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
                                    "तुम्हाला हि माहिती नक्की काढून टाकायची आहे का ?",
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
                                    child: const Text(
                                      "नाही",
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
                                    child: const Text(
                                      "होय",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (shouldDelete == true && selectedHinduVeerYadiIdIndex != null) {
                              // setState(() {
                              //   hinduVeerYadiDataList
                              //       .removeAt(selectedHinduVeerYadiIdIndex!);
                              //   selectedHinduVeerYadiIdIndex = null;
                              // });
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
                      padding: const EdgeInsets.symmetric( horizontal: 20),
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
                          "विस्तृत माहिती संग्रह",
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

  void submitStep3Form() {
    Map<String, dynamic> formData = {
      "vastiid":  int.parse(selctedLevelId!),
      "cuserid": int.parse(Statics.userDetails['userID']),
      "VastisarVastitilasamajika": vastiPrashnaGarjaDataList,
      "Vastisardhaarmiknetrtav": dharmikNetrutvaDataList,
      "Vastisardurjanshakti": durjanShaktiDataList,
      "VastisarHinduvirayadi": hinduVeerYadiDataList,
      "Vastitilasamajikaque": "",
      "anyadhaarmik": "",
    };
    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Step 3 Form Data (JSON):\n$formattedJson");
    Statics.vastiSarvekshanStep3FormSubmit(context,jsonEncode(formData));
  }
}


