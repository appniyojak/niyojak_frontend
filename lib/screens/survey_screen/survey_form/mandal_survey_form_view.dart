import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/abhiyaan_karyakarta_model.dart';
import '../../../models/response_model/dropdown_level_responsemodel.dart';
import '../../../models/response_model/get_vasti_data_by_id_model.dart';
import '../../../models/response_model/vasti_sarvekshan_dropdown_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';

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

  int? isFemale = 0;

  String? selectedFilePath;
  GetVastiDataByIdModel? vastiDataByIdModel;

  Future<dynamic> searchVastiData(String? vastiId) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "vastiid": vastiId,
        "isVasti": 0,
        "AppUserID": Statics.userDetails['userID'],
      });
      print("searchVastiData req param :-  $strInput");
      vastiDataByIdModel = await Statics.getVastidataByIDForApp(context, strInput);
      setState(() {
        isVastiSearch = true;
        _isExpanded = false;
      });
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
      sarpanchNameController.text = vastiDataByIdModel!.vastisarvekshan!.sarpanchacheNaav == null ? "" : vastiDataByIdModel!.vastisarvekshan!.sarpanchacheNaav!;
      maleController.text = vastiDataByIdModel!.vastisarvekshan!.maleSankhya == null ? "" : vastiDataByIdModel!.vastisarvekshan!.maleSankhya.toString();
      femaleController.text = vastiDataByIdModel!.vastisarvekshan!.femaleSankhya == null ? "" : vastiDataByIdModel!.vastisarvekshan!.femaleSankhya.toString();
      sarpanchDoorbhasController.text = vastiDataByIdModel!.vastisarvekshan!.sarpanchacheDoorbhash == null ? "" : vastiDataByIdModel!.vastisarvekshan!.sarpanchacheDoorbhash!;
      sanghaKaryaVastiStithiController.text = vastiDataByIdModel!.vastisarvekshan!.vastiShakhaType == null ? "" : vastiDataByIdModel!.vastisarvekshan!.vastiShakhaType!;
      sanghaKaryaVastiPramukhNameController.text = vastiDataByIdModel!.vastisarvekshan!.vastiShakhaPramukhName ?? "";
      total = int.parse(vastiDataByIdModel!.vastisarvekshan!.maleSankhya == null ? "" : vastiDataByIdModel!.vastisarvekshan!.maleSankhya.toString()) +
          int.parse(vastiDataByIdModel!.vastisarvekshan!.femaleSankhya == null ? "" : vastiDataByIdModel!.vastisarvekshan!.femaleSankhya.toString());
      //     int.parse(vastiDataByIdModel!.vastisarvekshan!.lokasankhya ?? "0");
      vadicheNaavController.text = vastiDataByIdModel!.vastisarvekshan!.vadicheNave ?? "";
      andajeGhareController.text = vastiDataByIdModel!.vastisarvekshan!.andajeGhare ?? "";
      gaavSamitiYesNo = int.parse(vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti == null ||
              vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti! == "null" ||
              vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti == ""
          ? "2"
          : vastiDataByIdModel!.vastisarvekshan!.vastiShakhaSamiti!);
      beforsanghaonnowisoff = vastiDataByIdModel!.vastisarvekshan!.beforeShakhaSaptahikIsOnNowOff == null ? 2 : vastiDataByIdModel!.vastisarvekshan!.beforeShakhaSaptahikIsOnNowOff;
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
      step1completepercentage = vastiDataByIdModel!.vastisarvekshan!.step1completepercentage;
      step1pendingpoints = vastiDataByIdModel!.vastisarvekshan!.step1pendingpoints;

      /// STEP 3 FORM DATA =====================================================================================================
      vastiPrashnaGarjaDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarVastitilasamajika ?? [];
      dharmikNetrutvaDataList = vastiDataByIdModel!.vastisarvekshan!.vastisardhaarmiknetrtav ?? [];
      durjanShaktiDataList = vastiDataByIdModel!.vastisarvekshan!.vastisardurjanshakti ?? [];
      hinduVeerYadiDataList = vastiDataByIdModel!.vastisarvekshan!.vastisarHinduvirayadi ?? [];
      step3completepercentage = vastiDataByIdModel!.vastisarvekshan!.step3completepercentage;
      durjanShaktiYesNo = vastiDataByIdModel!.vastisarvekshan!.durjanShaktiYesNo!;
      step3pendingpoints = vastiDataByIdModel!.vastisarvekshan!.step3pendingpoints;
      // ============================================================================================================================================================================
      _isStep1Completed = vastiDataByIdModel!.vastisarvekshan!.stepOneComplete ?? true;
      _isStep2Completed = vastiDataByIdModel!.vastisarvekshan!.stepTwoComplete ?? true;
      print("_isStep1Completed $_isStep1Completed ----   _isStep2Completed $_isStep2Completed");
    });
  }

  void resetData() async {
    setState(() {
      durjanShaktiYesNo = 2;
      sarpanchDoorbhasController.clear();
      sarpanchNameController.clear();
      femaleController.clear();
      maleController.clear();
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
      isFemale = null;
      isVastiSearch = false;
    });
    populateDropdown();
  }

  void showPopupForVastiValidation(BuildContext context) {
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
            "${Statics.getLabel('GaavSelectionImportant')}",
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

  List<StaticMasterBAL>? _baithakTypes;
  String? _linkedgraamValue = '';

  // String? selctedLevelIdNew = '';
  int? beforsanghaonnowisoff = 2;
  int? anyaVividhKshetracheKame = 2;
  int? gavatilMumbaikar = 2;
  int? agniShamanDalKendraAhe = 2;
  int? polichChoukiAhe = 2;
  int? gaavSamitiYesNo = 2;
  int? durjanShaktiYesNo = 2;
  final TextEditingController maleController = TextEditingController();
  final TextEditingController femaleController = TextEditingController();

  int? step1completepercentage;
  int? step3completepercentage;

  String? step1pendingpoints;
  String? step3pendingpoints;

  Future<void> populateDropdown({bool fromClear = false}) async {
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    if (!mounted) return;
    _baithakTypes = data;
    _baithakTypes = _baithakTypes!.where((element) => element.showAnnualBaithakkey!.contains('1')).toList();
    // print("_baithakTypes :-- $_baithakTypes");
    setState(() {});
  }

  late TabController _tabController;
  bool? _isStep1Completed = false;
  bool? _isStep2Completed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchVastiSurveyDropdownData();
    _tabController.addListener(_handleTabSelection);
    maleController.addListener(_updateTotal);
    femaleController.addListener(_updateTotal);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    final dm = await MyAppGlobals.getLevelLDB();

    final controller = context.read<GeoHierarchyController>();

    await controller.initialize(dm, fetchMode: GeoHierarchyFetchMode.mandalOnly);

    setState(() {});
    await populateDropdown();
  }

  int total = 0;

  void _updateTotal() {
    final int male = int.tryParse(maleController.text) ?? 0;
    final int female = int.tryParse(femaleController.text) ?? 0;
    setState(() {
      total = male + female;
    });
  }

  void _handleTabSelection() {
    if (mounted) setState(() {}); // Rebuilds to update the PopScope's allowed status
    print("_tabController.index ${_tabController.index}----- _isStep1Completed ${_isStep1Completed}");
    if (_tabController.index == 1 && !_isStep1Completed!) {
      showPopupForNaviagtetoOtherPage(context, Statics.getLabel('basicInfo'), Statics.getLabel('OtherInfo'));
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
    _tabController?.removeListener(_handleTabSelection);
    _tabController.dispose();
    maleController.dispose();
    femaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Determine if the system back button is allowed to close/pop the screen.
    // It should pop normally if it's a single screen OR if the user is already on the first tab (index 0).
    final bool canPopScreen = _tabController?.index == 0;

    return PopScope(
      canPop: canPopScreen,
      onPopInvokedWithResult: (didPop, result) {
        // If the system already handled the pop (canPop was true), do nothing.
        if (didPop) return;

        // If canPop was false, it means we are on the multi-tab layout and on the second tab (index 1).
        // Move back to the first tab instead of exiting.
        if (_tabController?.index == 1 || _tabController?.index == 2) {
          _tabController?.animateTo(0);
        }
      },
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text(
            Statics.getLabel('mandalSurvey'),
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
              _buildStep3(),
            ],
          ),
        ),
      ),
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
            inputFormatters: keyboardType == TextInputType.number ? [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))] : [],
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
  Widget vastisarvekshanDropdown2({
    required VastisarvekshanDropDownDataModel dataModel,
    required String filterTypeName,
    required String hintText,
    required Function(int?, String?, int?) onItemSelected,
    String? question,
    String? imp,
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
          Row(
            children: [
              Text(
                "${questionNumber != null ? "$questionNumber. " : ""}$question",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              if (imp != null)
                Text(
                  imp,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
            ],
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

// ================================================   BASIC INFO FORM =================================================================================================================================
  Widget _buildStep1() {
    int total = (int.tryParse(maleController.text) ?? 0) + (int.tryParse(femaleController.text) ?? 0);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          graamMandalDropdown(),

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
                      children: const [
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
// =====================================  SANGHA KARYA  STITHI ==================================================================================
          mainContainer(
            "${Statics.getLabel('GraamInfo')}",
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.grey),
                  //     borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${Statics.getLabel('vadipadyacheInfo')}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: " *",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (isVastiSearch) {
                                showVadiGharLoksankhyaPopup(context, onDataChanged: () {
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
                                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('vadipadyacheNaav')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('andaajeGhar')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('andajeLoksankhya')}",
                                  )),
                                ],
                                rows: vadiGharLoksankhyaEnteredDataList!.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
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
                                            _buildInfoRow("${Statics.getLabel('vadipadyacheNaav')}", selectedData.vadiCheNav),
                                            SizedBox(height: 12),
                                            _buildInfoRow("${Statics.getLabel('andaajeGhar')}", selectedData.andajeGhar),
                                            SizedBox(height: 12),
                                            _buildInfoRow("${Statics.getLabel('andajeLoksankhya')}", selectedData.andajeLoksankhya),
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
                                if (selectedvadiGharLoksankhyaIndex == null) return;
                                showVadiGharLoksankhyaPopup(context, onDataChanged: () {
                                  setState(() {});
                                }, editIndex: selectedvadiGharLoksankhyaIndex);
                                print("selectedJagranShreniStithiRowIndex --> $selectedvadiGharLoksankhyaIndex");
                              },
                              child: Icon(Icons.edit, color: Colors.blue, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                if (selectedvadiGharLoksankhyaIndex == null) return;
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
                      textControllerField2(name: "${Statics.getLabel('SarpanchacheNaav')}", controller: sarpanchNameController, imp: "*"),
                      SizedBox(height: 10),
                      textControllerField2(
                        name: "${Statics.getLabel('doorBhash')}",
                        controller: sarpanchDoorbhasController,
                        keyboardType: TextInputType.number,
                        maxInput: 10,
                      ),
                      SizedBox(height: 10),
                      yesNoRadioButton(
                          question: "${Statics.getLabel('gaavSamitiAhe')}",
                          selectedOption: gaavSamitiYesNo ?? 2,
                          onChanged: (value) {
                            if (isVastiSearch) {
                              setState(() {
                                gaavSamitiYesNo = value;
                              });
                            } else {
                              showPopupForVastiValidation(
                                context,
                              );
                            }
                          },
                          imp: "*"),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${Statics.getLabel('Population')}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "*",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: maleController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: '${Statics.getLabel('Men')}',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: femaleController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: '${Statics.getLabel('Women')}',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${Statics.getLabel('ekunLoksankhya')}: $total',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // =====================================  SANGHA KARYA  STITHI ==================================================================================
          mainContainer(
            "${Statics.getLabel('sanghakarya')}",
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
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
                          },
                          imp: "*"),
                      if (beforsanghaonnowisoff == 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${Statics.getLabel('tapshil')}",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                                  if (selectedKuthalaVarshiIdIndex == null) return;
                                  showKuthalaVarshiPopup(context, onDataChanged: () => setState(() {}), editIndex: selectedKuthalaVarshiIdIndex);
                                },
                                child: Icon(Icons.edit, color: Colors.blue, size: 20),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (selectedKuthalaVarshiIdIndex == null) return;
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
                ),
              ],
            ),
          ),
          // =====================================SEWA PRAKALPAA  ==================================================================================
          mainContainer(
            "${Statics.getLabel('SewaPrakalpa')}",
            Column(
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
                            "${Statics.getLabel('SelectFrequency')}",
                          )),
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('chalavnariSanghatana')}",
                          )),
                        ],
                        rows: sewaPrakalpaEnteredDataList!.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
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
                                      _buildInfoRow("${Statics.getLabel('SelectFrequency')}", selectedData.selectedDropdownValueName),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('otherType')}", selectedData.otherSewaPrakalpaPrakaar),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('chalavnariSansthaSanghatana')}", selectedData.selectedDropdownValueName1),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('chalavnariSansthaSanghatanaOther')}", selectedData.otherSewaPrakalpaChalavinareShanstha),
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
                          if (selectedSewaprakalpaRowIndex == null) return;
                          showSewaPrakalpaPopup(context, onDataChanged: () {
                            setState(() {});
                          }, editIndex: selectedSewaprakalpaRowIndex);
                          print("selectedJagranShreniStithiRowIndex --> $selectedSewaprakalpaRowIndex");
                        },
                        child: Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          if (selectedSewaprakalpaRowIndex == null) return;
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
            ),
          ),
          // =====================================  ==================================================================================
          mainContainer(
            "${Statics.getLabel('vividhKshetracheKaam')}",
            Column(
              children: [
                yesNoRadioButton(
                    question: "${Statics.getLabel('otherVividhKshetraWork')}",
                    selectedOption: anyaVividhKshetracheKame ?? 2,
                    onChanged: (value) {
                      if (isVastiSearch) {
                        setState(() {
                          anyaVividhKshetracheKame = value;
                        });
                      } else {
                        showPopupForVastiValidation(
                          context,
                        );
                      }
                    },
                    imp: "*"),
                if (anyaVividhKshetracheKame == 1)
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
                if (anyaVividhKshetracheKame == 1) SizedBox(height: 10),
                if (anyaVividhKshetracheKame == 1)
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
                              "${Statics.getLabel('kaam')}",
                            )),
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('chalavnariSanghatana')}",
                            )),
                          ],
                          rows: vividhKshetaCHeKamEnteredDataList!.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
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
                if (anyaVividhKshetracheKame == 1) SizedBox(height: 10),
                if (anyaVividhKshetracheKame == 1)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
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
                                        "${Statics.getLabel('vividhKshetracheKaam')}",
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
                                        _buildInfoRow("${Statics.getLabel('kaam')}", selectedData.kaam),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('chalavnariSansthaSanghatana')}", selectedData.chalavnariSansthaSanghatamn),
                                        SizedBox(height: 12),
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
                            if (selectedVastisarVividhKshetracheIndex == null) return;
                            showVividhKshetraCheKamePopup(context, onDataChanged: () {
                              setState(() {});
                            }, editIndex: selectedVastisarVividhKshetracheIndex);
                            print("selectedJagranShreniStithiRowIndex --> $selectedVastisarVividhKshetracheIndex");
                          },
                          child: Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            if (selectedVastisarVividhKshetracheIndex == null) return;
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
            ),
          ),
          // =====================================SEWA PRAKALPAA  ==================================================================================
          mainContainer(
            "${Statics.getLabel('satsangKendra')}",
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
                            "${Statics.getLabel('sansthaa')}",
                          )),
                          DataColumn(
                              label: Text(
                            "${Statics.getLabel('gaavPramukhName')}",
                          )),
                        ],
                        rows: vividhadhyatmitStsangKendraEnteredDataList!.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
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
                                      "${Statics.getLabel('aadhyatmikKendra')}",
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
                                      // _buildInfoRow("${Statics.getLabel('gaav')}", selectedData.selectedDropdownValueName1.toString()),
                                      // SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('sansthaa')}", selectedData.selectedDropdownValueName.toString()),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('otherSanstha')}", selectedData.isOtherAdhyatmitKendra.toString()),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('gaavPramukhName')}", selectedData.gaavPramukhName.toString()),
                                      SizedBox(height: 12),
                                      _buildInfoRow("${Statics.getLabel('samparkSootraNaav')}", selectedData.samparkSootra.toString()),
                                      SizedBox(height: 12),
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
                          if (selectedVastisarVividhadhyatmitStsangKendraIndex == null) return;
                          showVividhadhyatmitStsangKendraPopup(context, onDataChanged: () {
                            setState(() {});
                          }, editIndex: selectedVastisarVividhadhyatmitStsangKendraIndex);
                          print("selectedJagranShreniStithiRowIndex --> $selectedVastisarVividhadhyatmitStsangKendraIndex");
                        },
                        child: Icon(Icons.edit, color: Colors.blue, size: 20),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          if (selectedVastisarVividhadhyatmitStsangKendraIndex == null) return;
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
            ),
          ),
          // =====================================  ==================================================================================
          mainContainer(
            "${Statics.getLabel('gavatilMuymbaikarMandal')}",
            Column(
              children: [
                yesNoRadioButton(
                    question: "${Statics.getLabel('gavatilMuymbaikarMandalAahe')}",
                    selectedOption: gavatilMumbaikar ?? 2,
                    onChanged: (value) {
                      if (isVastiSearch) {
                        setState(() {
                          gavatilMumbaikar = value;
                        });
                      } else {
                        showPopupForVastiValidation(
                          context,
                        );
                      }
                    },
                    imp: "*"),
                if (gavatilMumbaikar == 1)
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
                if (gavatilMumbaikar == 1) SizedBox(height: 10),
                if (gavatilMumbaikar == 1)
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
                              "${Statics.getLabel('sthaan')}",
                            )),
                            DataColumn(
                                label: Text(
                              "${Statics.getLabel('pramukhaacheNaav')}",
                            )),
                          ],
                          rows: gavatilMumbaikarEnteredDataList!.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
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
                if (gavatilMumbaikar == 1) SizedBox(height: 10),
                if (gavatilMumbaikar == 1)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                    ),
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
                                        "${Statics.getLabel('vividhKshetracheKaam')}",
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
                                        _buildInfoRow("${Statics.getLabel('kaam')}", selectedData.sthaan),
                                        SizedBox(height: 12),
                                        _buildInfoRow("${Statics.getLabel('chalavnariSansthaSanghatana')}", selectedData.pramukhachrNaav),
                                        SizedBox(height: 12),
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
                            if (selectedGavatilMumbaikarIndex == null) return;
                            showGavatilMumbaikarPopup(context, onDataChanged: () {
                              setState(() {});
                            }, editIndex: selectedGavatilMumbaikarIndex);
                            print("selectedJagranShreniStithiRowIndex --> $selectedGavatilMumbaikarIndex");
                          },
                          child: Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            if (selectedGavatilMumbaikarIndex == null) return;
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
            ),
          ),
          // ===================================== रिलीजन ==================================================================================
          mainContainer(
              "${Statics.getLabel('religion')}",
              Column(
                children: [
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
                                            DataCell(Text(data.andaje ?? "")),
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
                                      if (selectedReligionIdRowIndex == null) return;
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
                                      if (selectedReligionIdRowIndex == null) return;
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
                            if (selectedUpasnaSthalRowIndex == null) return;
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
                            if (selectedUpasnaSthalRowIndex == null) return;
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
                              // upasnaSthalDataList
                              //     .removeAt(selectedUpasnaSthalRowIndex!);
                              // selectedUpasnaSthalRowIndex = null;
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
/*//================================== ABHIYAAN KARYAKARTA FORM =================================================================================================================================================
          SizedBox(
            height: 20,
          ),
          mainContainer(
              "${Statics.getLabel('abhiyaanKaryakartaFormTitle')}",
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (isVastiSearch) {
                            showAbhiyaanKaryakartaPopup(context);
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
                                columnSpacing: 12,
                                showCheckboxColumn: false,
                                headingRowColor: MaterialStatePropertyAll(Colors.purple.shade50),
                                headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                columns: [
                                  // DataColumn(
                                  //     label: Text(
                                  //   "${Statics.getLabel('serialNo')}",
                                  // )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('Name')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('mobileNumberLabel')}",
                                  )),
                                  DataColumn(
                                      label: Text(
                                    "${Statics.getLabel('daayitvaName')}",
                                  )),
                                ],
                                rows: abhiyaanKaryakartaList.asMap().entries.where((entry) => entry.value.isactive == 1).map((entry) {
                                  int index = entry.key;
                                  var data = entry.value;
                                  bool isSelected = selectedAbhiyaanKaryakartaIdIndex == index;
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
                                            selectedAbhiyaanKaryakartaIdIndex = index;
                                          });
                                        }
                                      },
                                      cells: [
                                        // DataCell(Text("${index + 1}")),
                                        DataCell(Text(data.name ?? '')),
                                        DataCell(Text(data.mobileno ?? '')),
                                        DataCell(Text(Statics.getLabel(data.daayitva.toString()))),
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
                                if (selectedAbhiyaanKaryakartaIdIndex != null) {
                                  var selectedData = abhiyaanKaryakartaList[selectedAbhiyaanKaryakartaIdIndex!];
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
                                            "${Statics.getLabel('abhiyaanKaryakartaFormTitle')}",
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
                                              _buildInfoRow("${Statics.getLabel('mobileNumberLabel')}", selectedData.mobileno),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('Email')}", selectedData.email),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('Gender')}", Statics.getLabel(selectedData.isfemale == 1 ? 'Female' : 'Male')),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('sanstha')}", selectedData.sansthaname),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('OrganizationName')}", selectedData.padh),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('sansthetKuthalaPadavar')}", selectedData.sanstha),
                                              SizedBox(height: 12),
                                              _buildInfoRow("${Statics.getLabel('SelectDaayitva')}", Statics.getLabel(selectedData.daayitva.toString())),
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
                                if (selectedAbhiyaanKaryakartaIdIndex != null) {
                                  showAbhiyaanKaryakartaPopup(
                                    context,
                                    editIndex: selectedAbhiyaanKaryakartaIdIndex,
                                  );
                                }
                              },
                              child: Icon(Icons.edit, color: Colors.blue, size: 20),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                if (selectedAbhiyaanKaryakartaIdIndex == null) return;
                                if (abhiyaanKaryakartaList[selectedAbhiyaanKaryakartaIdIndex!].isdefault == 1) {
                                  await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        "${Statics.getLabel('alert')}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: Text(
                                          "${Statics.getLabel('cannotDeleteTheData')}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      actionsAlignment: MainAxisAlignment.spaceEvenly,
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
                                  return;
                                }
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
                                if (shouldDelete == true && selectedAbhiyaanKaryakartaIdIndex != null) {
                                  setState(() {
                                    abhiyaanKaryakartaList[selectedAbhiyaanKaryakartaIdIndex!].isactive = 0;
                                    selectedAbhiyaanKaryakartaIdIndex = null;
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
              )),*/
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
                                      "${Statics.getLabel('SajjanShakti')}",
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
                          if (selectedsajjanShaktiRowIndex == null) return;
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
                          if (selectedsajjanShaktiRowIndex == null) return;
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
            "${Statics.getLabel('anyaPrabhaviLok')} (${Statics.getLabel('samparkVibhaagYaadi')} )",
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        if (isVastiSearch) {
                          showAnyaPrabhaviPopup(context, onDataChanged: () {
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
                          // DataColumn(label: Text("क्रिया", style: TextStyle(color: Colors.black54))),
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
                          if (selectedanyaPrabhaviLokRowIndex == null) return;
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
                          if (selectedanyaPrabhaviLokRowIndex == null) return;
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
                      "${Statics.getLabel('GavatsajareHonareSan')}",
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
                                      "${Statics.getLabel('GavatsajareHonareSan')}",
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
                          if (selectedSanIdIndex == null) return;
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
                          if (selectedSanIdIndex == null) return;
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
                        "${Statics.getLabel('GavatHonareKaryakram')}",
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
                                      "${Statics.getLabel('GavatHonareKaryakram')}",
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
                                        _buildInfoRow("${Statics.getLabel('other')}", selectedData.otherKaryakram),
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
                          if (selectedSamajikKaryakramIdIndex == null) return;
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
                          if (selectedSamajikKaryakramIdIndex == null) return;
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
                      if (gaavSamitiYesNo == 0 || gaavSamitiYesNo == 1) {
                        print("1");

                        String sarpanchName = sarpanchNameController.text.trim();
                        if (sarpanchName.isEmpty) {
                          print("2");

                          Statics.showToast("${Statics.getLabel('sarpanchNavValidation')}");
                          return;
                        }
                        if (beforsanghaonnowisoff != 0 && beforsanghaonnowisoff != 1) {
                          print("3");

                          Statics.showToast("${Statics.getLabel('purviShakhaValidation')}");
                          return;
                        }
                        if (anyaVividhKshetracheKame != 0 && anyaVividhKshetracheKame != 1) {
                          print("4");

                          Statics.showToast("${Statics.getLabel('anyaVividhValidation')}");
                          return;
                        }
                        if (gavatilMumbaikar != 0 && gavatilMumbaikar != 1) {
                          print("5");

                          Statics.showToast("${Statics.getLabel('mumbaikarValidation')}");
                          return;
                        }
                        if (vadiGharLoksankhyaEnteredDataList!.isEmpty) {
                          print("6");

                          Statics.showToast("${Statics.getLabel('vadipadyachiInfoValidation')}");
                          return;
                        }
                        if (maleController.text == "" && femaleController.text == "") {
                          print(maleController.text);
                          print(femaleController.text);
                          print("7");

                          Statics.showToast("${Statics.getLabel('maleFemaleCountValidation')}");
                          return;
                        }
                        print("8");
                        if (sarpanchDoorbhasController.text.length != 10) {
                          Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                          return;
                        }
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
                                "${Statics.getLabel('gaavSamitiValidation')}",
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
                        "${Statics.getLabel('prathamikSubmit')}",
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

  Widget graamMandalDropdown() {
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
                      title: Text(Statics.getLabel('gaavNivada'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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

                        if (ctrl.hasItems(GeoLevel.Graam))
                          GeoDropdownWidget(
                            level: GeoLevel.Graam,
                            title: 'Graam',
                            controller: ctrl,
                          ),
                        if (ctrl.deepestSelectedLevelId == 3)
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                              onPressed: () => searchVastiData(ctrl.deepestSelectedGeoUnitId),
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
                  "${Statics.getLabel('Note')} :- ${Statics.getLabel('GaavSelectionImportant')}",
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
          if (ctrl.deepestSelectedLevelId == 3 && ctrl.deepestSelectedGeoUnitName != null && ctrl.deepestSelectedGeoUnitName != "" && isVastiSearch == true)
            SizedBox(
              height: 20,
            ),
          if (ctrl.deepestSelectedLevelId == 3 && ctrl.deepestSelectedGeoUnitName != null && ctrl.deepestSelectedGeoUnitName != "" && isVastiSearch == true)
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
                      "${Statics.getLabel('gaav')} ->  ",
                      style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      " ${ctrl.deepestSelectedGeoUnitName}",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                )),
        ],
      );
    });
  }

  Future<void> submitStep1Form() async {
    setState(() {
      _isStep1Completed = true;
    });

    Map<String, dynamic> formData = {
      "cuserid": int.parse(Statics.userDetails['userID']),
      "vastiid": int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
      "VastisarvadiGharLoksankhya": vadiGharLoksankhyaEnteredDataList,
      "vastiShakhaSamiti": gaavSamitiYesNo,
      "VastisarKuthalyavarsi": kuthalaVarshiDataList,
      "VastisarSewaPrakalpa": sewaPrakalpaEnteredDataList,
      "VastisarvividhKshetaCheKam": vividhKshetaCHeKamEnteredDataList,
      "anyaVividhKshetracheKame": anyaVividhKshetracheKame,
      "VastisarvividhSampradhaySatsangKendra": vividhadhyatmitStsangKendraEnteredDataList,
      "VastisargavatilMumbaikar": gavatilMumbaikarEnteredDataList,
      "isGavatilMumbaikar": gavatilMumbaikar,
      "VastisarReligion": enteredreligionDataList,
      "Vastisarupaasana": upasnaSthalDataList,
      "Vastisarsajjanshakti": sajjanShaktiDataList,
      "VastisarAnyaprabhavilokam": anyaPrabhaviLokDataList,
      "VastisarVastitasajaraSamajikkaryakram": vastitSajarHonareSamajikKaryakramDataList,
      "VastisarVastitamahatvacesana": vastitSajarHonareSanDataList,
      "sarpanchaName": sarpanchNameController.text,
      "maleCount": maleController.text,
      "femaleCount": femaleController.text,
      "sarpanchDoorbhash": sarpanchDoorbhasController.text,
      "abhiyaanKaryakartaList": abhiyaanKaryakartaList,
//====================================================================================================
      "VastisarKonatyaprantache": enteredKontyaPraantacheDataList,
      "vastiShakhaPramukhName": sanghaKaryaVastiPramukhNameController.text,
      "Lokasankhya": total,
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
      // "isfemale": isFemale ? 1 : 0,
    };
    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Step 1 Form Data (JSON):\n$formattedJson");
    String response = await Statics.vastiSarvekshanStep1FormSubmit(context, jsonEncode(formData));
    setState(() {
      _isStep1Completed = response == "success";
      _isStep2Completed = response == "success";
      sarpanchDoorbhasController.clear();
      sarpanchNameController.clear();
      femaleController.clear();
      maleController.clear();
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

      /// STEP 3 FORM DATA
      vastiPrashnaGarjaDataList = [];
      dharmikNetrutvaDataList = [];
      durjanShaktiDataList = [];
      hinduVeerYadiDataList = [];
    });
    await Future.delayed(Duration.zero);
    searchVastiData(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId);
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
    log("reset called >>>>>>>>>>>>>>>>>>>>>>> ");
    setState(() {
      selectedShreni = null;
      selectedUpShreni = null;
      selectedUpShreni2 = null;
      anyaPrabhaviLokShreniId = null;
      anyaPrabhaviLokUpShreniId = null;
      anyaPrabhaviLokUpShreni1Id = null;
      anyaPrabhaviLokShreniIdEdit = null;
      anyaPrabhaviLokUpShreniIdEdit = null;
      anyaPrabhaviLokUpShreni1IdEdit = null;
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

  Widget _buildDropdown2<T extends Masterdata>(
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
                            "${Statics.getLabel('tapshil')}",
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
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
                            textControllerField2(
                              name: "${Statics.getLabel('vadipadyacheNaav')}",
                              controller: vadicheNaavController,
                            ),
                            const SizedBox(height: 10),
                            textControllerField2(name: "${Statics.getLabel('andaajeGhar')}", controller: andajeGhareController, keyboardType: TextInputType.number),
                            const SizedBox(height: 10),
                            textControllerField2(name: "${Statics.getLabel('andajeLoksankhya')}", controller: loksankhyaController, keyboardType: TextInputType.number),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                // onPressed: () {
                                //   VastisarVadiGharLoksankhya data =
                                //       VastisarVadiGharLoksankhya(
                                //     pkid: VastisarVividhKshetracheKamPkId,
                                //     isactive:
                                //         isActiveVastisarVividhKshetracheKam,
                                //     vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
                                //     vadiCheNav: vadicheNaavController.text,
                                //     andajeGhar: andajeGhareController.text,
                                //     andajeLoksankhya: loksankhyaController.text,
                                //   );
                                //   if (editIndex != null) {
                                //     vadiGharLoksankhyaEnteredDataList![
                                //         editIndex] = data;
                                //   } else {
                                //     vadiGharLoksankhyaEnteredDataList!
                                //         .add(data);
                                //   }
                                //   Navigator.of(ctx).pop();
                                //   clearFieldsVadiGharLoksankhya();
                                //   if (onDataChanged != null) {
                                //     onDataChanged();
                                //   }
                                // },
                                onPressed: () {
                                  String andajeGharInput = loksankhyaController.text.trim();

                                  // Check if input is a valid number between 0 and 100
                                  if (!RegExp(r'^\d+$').hasMatch(andajeGharInput) || // only digits
                                          int.tryParse(andajeGharInput) == null // not a number
                                          ||
                                          int.parse(andajeGharInput) < 0
                                      // || int.parse(andajeGharInput) > 100
                                      ) {
                                    Statics.showToast("${Statics.getLabel('persentValidation')}");
                                    return;
                                  }
                                  VastisarVadiGharLoksankhya data = VastisarVadiGharLoksankhya(
                                    pkid: VastisarVividhKshetracheKamPkId,
                                    isactive: isActiveVastisarVividhKshetracheKam,
                                    vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
                                    vadiCheNav: vadicheNaavController.text,
                                    andajeGhar: andajeGhareController.text,
                                    andajeLoksankhya: loksankhyaController.text,
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

                                child: Text(
                                  "${Statics.getLabel('Submit')}",
                                  style: TextStyle(color: Colors.white),
                                ),
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
      selectedYearType = data.isactive == 1
          ? "shaakha"
          : data.isactive == 1
              ? "saptahikMilan"
              : "";
      selectedisActive = data.isactive;
      selectedMasterKuthalaVarshiName = vastisarvekshanDropDownDataModel!.masterdata!.firstWhere((item) => item.id == selectedKuthalaVarshiId);
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

                  // ✅ Step 1: Check if years are in valid range
                  if ((saptahikYear != null && saptahikYear >= 1925 && saptahikYear <= 2025) || (shaakhaYear != null && shaakhaYear >= 1925 && shaakhaYear <= 2025)) {
                    // ✅ Step 2: Validation - Already exists check
                    int currentType = selectedYearType == "shaakha"
                        ? 1
                        : selectedYearType == "saptahikMilan"
                            ? 0
                            : 2;

                    // Get all entries with same ID
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

                    // ✅ Step 3: Save data if valid
                    final data = VastisarKuthalyavarsi(
                      id: selectedKuthalaVarshiId,
                      prakarName: currentType == 1
                          ? "शाखा"
                          : currentType == 0
                              ? "साप्ताहिक मिलन"
                              : "-",
                      isShaakhaa: currentType,
                      pkid: selectedPkId,
                      vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
                            "${Statics.getLabel('sewaPrakalpaTapshil')}",
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
                                    onItemSelected: (id, value, isOther) {
                                      selectedSewaprakalpaPrakaarID = id;
                                      selectedSewaprakalpaPrakaarName = value;
                                    },
                                    hintText: "${Statics.getLabel('SelectPrakar')}",
                                    question: "${Statics.getLabel('SelectPrakar')}",
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
                            if (selectedSewaprakalpaPrakaar?.isOther == 1)
                              textControllerField2(
                                name: "${Statics.getLabel('otherType')}",
                                controller: isOtherSewaprakalpaPrakaarConroller,
                              ),
                            const SizedBox(height: 10),
                            vastisarvekshanDropDownDataModel != null
                                ? vastisarvekshanDropdown2(
                                    dataModel: vastisarvekshanDropDownDataModel!,
                                    filterTypeName: "सेवाप्रकल्पचालवणारीसंस्थासंघटन",
                                    onItemSelected: (id, value, isOther) {
                                      selectedSewaprakalpaChalanvariSansthaID = id;
                                      selectedSewaprakalpaChalanvariSansthaName = value;
                                      print("selectedVaramvaritaID $selectedSewaprakalpaChalanvariSansthaID |||| selectedVaramvaritaName $selectedSewaprakalpaChalanvariSansthaName");
                                      isOtherSewaprakalpaChalanvariSansthaConroller.clear();
                                    },
                                    hintText: "${Statics.getLabel('sansthaSanghatan')}",
                                    question: "${Statics.getLabel('sansthaSanghatan')}",
                                    editId: selectedSewaprakalpaChalanvariSansthaIDEdit,
                                    selectedValue: selectedSewaprakalpaChalanvariSanstha,
                                    onSelectionChanged: (newValue) {
                                      setState(() {
                                        selectedSewaprakalpaChalanvariSanstha = newValue;
                                      });
                                    },
                                  )
                                : Container(),
                            const SizedBox(height: 10),
                            if (selectedSewaprakalpaChalanvariSanstha?.isOther == 1)
                              textControllerField2(name: "${Statics.getLabel('other')}", controller: isOtherSewaprakalpaChalanvariSansthaConroller),
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
                                    vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
                                    sewaPrakalpaPrakaarId: selectedSewaprakalpaPrakaarID,
                                    otherSewaPrakalpaPrakaar: isOtherSewaprakalpaPrakaarConroller.text,
                                    selectedDropdownValueName: selectedSewaprakalpaPrakaarName,
                                    sewaprakalpaChalvanariSansthaId: selectedSewaprakalpaChalanvariSansthaID,
                                    selectedDropdownValueName1: selectedSewaprakalpaChalanvariSansthaName,
                                    otherSewaPrakalpaChalavinareShanstha: isOtherSewaprakalpaChalanvariSansthaConroller.text,
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
                                child: Text(
                                  "${Statics.getLabel('Submit')}",
                                  style: TextStyle(color: Colors.white),
                                ),
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
                            "${Statics.getLabel('vividhKshetracheKaam')}",
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
                            textControllerField2(
                              name: "${Statics.getLabel('kaam')}",
                              controller: vividhkshetraKaamConroller,
                            ),
                            const SizedBox(height: 10),
                            textControllerField2(name: "${Statics.getLabel('chalavnariSanghatana')}", controller: vividhkshetraChalavnareSansthaSanghatanConroller),
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
                                    vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
                                    kaam: vividhkshetraKaamConroller.text,
                                    chalavnariSansthaSanghatamn: vividhkshetraChalavnareSansthaSanghatanConroller.text,
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
                                child: Text(
                                  "${Statics.getLabel('Submit')}",
                                  style: TextStyle(color: Colors.white),
                                ),
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
                            "${Statics.getLabel('aadhyatmikKendra')}",
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
                              hintText: "${Statics.getLabel('aadhyatmikKendra')}",
                              question: "${Statics.getLabel('aadhyatmikKendra')}",
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
                      if (selectedVividhAAdhyatmikKendraMasterDAta?.isOther == 1) textControllerField2(name: "${Statics.getLabel('other')}", controller: isOtherVividhAAdhyatmikKendraController),
                      textControllerField2(name: "${Statics.getLabel('gaavPramukhName')}", controller: gavPramukhAdhyatmikKendraController),
                      textControllerField2(name: "${Statics.getLabel('doorBhash')}", controller: samparkSootraAdhyatmikKendraController, keyboardType: TextInputType.number, maxInput: 10, height: 80),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            if (samparkSootraAdhyatmikKendraController.text.length != 10) {
                              Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                              return;
                            }
                            VastisarVividhAdhyatmikKendra data = VastisarVividhAdhyatmikKendra(
                              pkid: pkIdVividhAAdhyatmikKendra,
                              isactive: isActiveVividhAAdhyatmikKendra,
                              vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
                            "${Statics.getLabel('gavatilMuymbaikarMandal')}",
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
                            textControllerField2(
                              name: "${Statics.getLabel('sthaan')}",
                              controller: gavatilMumbaikarSthanNameConroller,
                            ),
                            const SizedBox(height: 10),
                            textControllerField2(name: "${Statics.getLabel('pramukhaacheNaav')}", controller: gavatilMumbaikarPramukhNameConroller),
                            const SizedBox(height: 20),
                            textControllerField2(
                                name: "${Statics.getLabel('doorBhash')}", controller: gavatilMumbaikarDoorbhashConroller, keyboardType: TextInputType.number, maxInput: 10, height: 80),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  if (gavatilMumbaikarDoorbhashConroller.text.length != 10) {
                                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                                    return;
                                  }
                                  VastisarGavatilMumbaikar data = VastisarGavatilMumbaikar(
                                    pkid: VastisarVividhKshetracheKamPkId,
                                    isactive: isActiveVastisarVividhKshetracheKam,
                                    vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
                                    sthaan: gavatilMumbaikarSthanNameConroller.text,
                                    pramukhachrNaav: gavatilMumbaikarPramukhNameConroller.text,
                                    doorbhash: gavatilMumbaikarDoorbhashConroller.text,
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
                                child: Text(
                                  "${Statics.getLabel('Submit')}",
                                  style: TextStyle(color: Colors.white),
                                ),
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
      selectedreligion = Masterdata(
        id: religionId,
        value: religionName ?? "",
      );
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
                          hintTextString: "उदा. ० ते १००",
                          maxInput: 3),
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
                          //     vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
                            // Convert text to double for comparison
                            double? average = double.tryParse(religionAveragePersentCount.text.trim());

                            // Check if the value is null or not in range
                            if (average == null || average < 0 || average > 100) {
                              Statics.showToast(
                                "${Statics.getLabel('persentValidation')}",
                              );
                              return;
                            }

                            VastisarReligion newReligion = VastisarReligion(
                              pkid: pkIdReligion ?? 0,
                              vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
                  print("CLICKED >>>>>>>>>>>>>>>>>>>>");
                  log("CLICKED >>>>>>>>>>>>>>>>>>>>");
                  if (selectedUpasnaSthal?.isOther == 1 && anyaUpasnaSthalNameController.text == "") {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                  } else {
                    if (upasnaSthalCountController.text.isEmpty) {
                      Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                      return;
                    }
                    Vastisarupaasana newData = Vastisarupaasana(
                      upaasanasthalaid: selectedUpasnaSthalId,
                      selectedDropdownValueName: selectedUpasnaSthalName,
                      prakarid: selectedUpasnaSthalTypeId,
                      selectedDropdownValueName1: selectedUpasnaSthalTypeName,
                      sankhya: upasnaSthalCountController.text.trim(),
                      isactive: isActiveUpasanaSthal,
                      otherupaasanasthala: anyaUpasnaSthalNameController.text,
                      vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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

//========================================   ABHIYAAN KARYAKARTA POPUP =====================================================

  String selectedAbhiyanValue = "";
  String selectedSansthaValue = "";

  // String selectedDayitvValue = "";

  int? selectedAbhiyaanKaryakartaIdIndex;

  TextEditingController _anyaSansthaCntrl = TextEditingController();
  TextEditingController _sansthaNameCntrl = TextEditingController();
  TextEditingController _sansthaPadhCntrl = TextEditingController();
  TextEditingController _fullNameCntrl = TextEditingController();
  TextEditingController _emailCntrl = TextEditingController();
  TextEditingController _mobileCntrl = TextEditingController();

  List<AbhiyaanKaryakartaModel> abhiyaanKaryakartaList = [];

  void showAbhiyaanKaryakartaPopup(BuildContext context, {int? editIndex}) {
    if (editIndex != null) {
      var data = abhiyaanKaryakartaList[editIndex];
      _fullNameCntrl.text = data.name ?? "";
      _emailCntrl.text = data.email ?? "";
      _mobileCntrl.text = data.mobileno ?? "";
      // _anyaSansthaCntrl.text = data.sansthaName ?? "";
      _sansthaNameCntrl.text = data.sansthaname ?? "";
      _sansthaPadhCntrl.text = data.padh ?? "";
      selectedSansthaValue = data.sanstha ?? "";
      // selectedDayitvValue = data.daayitva ?? "";
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          // titlePadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          // contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 6),
          insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "अभियान कार्यकर्ता जोडा",
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
                  clearAbhiyaanKaryakartaFormFields();
                },
              )
            ],
          ),
          content: StatefulBuilder(
            builder: (context, set) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _fullNameCntrl,
                      decoration: InputDecoration(
                        labelText: Statics.getLabel('FullName'),
                        isDense: true,
                        border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return (Statics.getLabel('FullNameValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        // swDetails.fullName = value.trim();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _mobileCntrl,
                      decoration: InputDecoration(
                        labelText: Statics.getLabel('Mobile'),
                        isDense: true,
                        border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value!.isEmpty || value!.trim().length < 10) return (Statics.getLabel('MobileValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        // swDetails.mobileNumber = value.trim();
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _emailCntrl,
                      decoration: InputDecoration(
                        labelText: Statics.getLabel('Email'),
                        isDense: true,
                        border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return (Statics.getLabel('ValidEmailBodyValidationMessage'));
                        return null;
                      },
                      onSaved: (value) {
                        // swDetails.fullName = value.trim();
                      },
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<int>(
                            contentPadding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            title: Text("${Statics.getLabel('Male')}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            value: 0,
                            groupValue: isFemale,
                            onChanged: (value) => set(() {
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
                            onChanged: (value) => set(() {
                              isFemale = value;
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    ///
                    Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 9.0),
                          child: Text(
                            "${Statics.getLabel('sanstha')} :",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.58,
                            // margin: EdgeInsets.only(right: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    isDense: true,
                                    iconSize: 30,
                                    underline: SizedBox(),
                                    value: selectedSansthaValue == "" ? null : selectedSansthaValue,
                                    onChanged: (String? newValue) {
                                      set(() {
                                        selectedSansthaValue = newValue!;
                                      });
                                    },
                                    items: <String>["धार्मिक", "सामाजिक", "शैक्षणिक", "सेवा", "सांस्कृतिक", "अन्य"].map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 3.0),
                                          child: Text(value),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                if (selectedSansthaValue == "अन्य")
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      autofocus: true,
                                      textInputAction: TextInputAction.done,
                                      controller: _anyaSansthaCntrl,
                                      decoration: InputDecoration(
                                        hintText: "संस्था कुठल्या विषयात काम करते",
                                      ),
                                      keyboardType: TextInputType.text,
                                      onSaved: (value) {
                                        // swDetails.fullName = value.trim();
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _sansthaNameCntrl,
                      decoration: InputDecoration(
                        labelText: "${Statics.getLabel('OrganizationName')}",
                        isDense: true,
                        border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        // swDetails.fullName = value.trim();
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _sansthaPadhCntrl,
                      decoration: InputDecoration(
                        labelText: "${Statics.getLabel('sansthetKuthalaPadavar')}",
                        isDense: true,
                        border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        // swDetails.fullName = value.trim();
                      },
                    ),
                    SizedBox(height: 15),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //       flex: 1,
                    //       child: Text(
                    //         "${Statics.getLabel('SelectLevel')}",
                    //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       flex: 1,
                    //       child: Text(
                    //         ":",
                    //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //     if (_level != null)
                    //       Expanded(
                    //         flex: 4,
                    //         child: Container(
                    //           // alignment: Alignment.center,
                    //           padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                    //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                    //           child: Text(
                    //             Statics.getLabel(selctedLevel.toString()),
                    //             style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    //           ),
                    //         ),
                    //       )
                    //     else
                    //       Expanded(flex: 4, child: SizedBox()),
                    //   ],
                    // ),
                    // SizedBox(height: 15),
                    //
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //       flex: 1,
                    //       child: Text(
                    //         "${Statics.getLabel('SelectLevelName')}",
                    //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       flex: 1,
                    //       child: Text(
                    //         ":",
                    //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //     // if (_geoUnits != null)
                    //     Expanded(
                    //       flex: 4,
                    //       child: Container(
                    //         // alignment: Alignment.center,
                    //         padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                    //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                    //         child: Text(
                    //           selctedLevelName.toString(),
                    //           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    //         ),
                    //       ),
                    //     )
                    //     // else
                    //     //   Expanded(flex: 4, child: SizedBox()),
                    //   ],
                    // ),
                    // SizedBox(height: 15),
                    // if (_levelValue != "" && _geoUnitsValue != "")
                    // _levelValue == "2" || _levelValue == "3" ?
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //       flex: 1,
                    //       child: Text(
                    //         Statics.getLabel("SelectDaayitva"),
                    //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       flex: 1,
                    //       child: Text(
                    //         ":",
                    //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       flex: 4,
                    //       child: Container(
                    //         alignment: Alignment.center,
                    //         padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                    //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                    //         child: DropdownButton<String>(
                    //           isExpanded: true,
                    //           isDense: true,
                    //           iconSize: 30,
                    //           underline: SizedBox(),
                    //           value: selectedDayitvValue == "" ? null : selectedDayitvValue,
                    //           onChanged: (String? newValue) {
                    //             set(() {
                    //               selectedDayitvValue = newValue!;
                    //             });
                    //           },
                    //           items: <String>["abhiyaanKaryakartaFormTitle", "abhiyaanPramukhKey"].map<DropdownMenuItem<String>>((String value) {
                    //             return DropdownMenuItem<String>(
                    //               value: value,
                    //               child: Padding(
                    //                 padding: const EdgeInsets.only(top: 3.0),
                    //                 child: Text(Statics.getLabel(value)),
                    //               ),
                    //             );
                    //           }).toList(),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                onPressed: () async {
                  if (_fullNameCntrl.text.isEmpty) {
                    print("पूर्ण नाव प्रविष्ट करा");
                    Statics.showToast("पूर्ण नाव प्रविष्ट करा");
                    return null;
                  } else if (_mobileCntrl.text.isEmpty || _mobileCntrl.text.length < 10) {
                    print("मोबाइल क्रमांक प्रविष्ट करा");
                    Statics.showToast("मोबाइल क्रमांक प्रविष्ट करा");
                    return null;
                    // } else if (showFields && _linkedvastiValue == null && _linkedgraamValue == null) {
                    //   print("निवास स्थान निवडा");
                    //   Statics.showToast("निवास स्थान निवडा");
                    //   return null;
                  } else if (selectedSansthaValue == "अन्य" && _anyaSansthaCntrl.text.isEmpty) {
                    print("अन्य संस्था प्रविष्ट करा");
                    Statics.showToast("अन्य संस्था प्रविष्ट करा");
                    return null;
                  } else if (selectedSansthaValue != "" && _sansthaNameCntrl.text.isEmpty) {
                    print("संस्थेचे नाव प्रविष्ट करा");
                    Statics.showToast("संस्थेचे नाव प्रविष्ट करा");
                    return null;
                  } else if (selectedSansthaValue != "" && _sansthaPadhCntrl.text.isEmpty) {
                    print("संस्थेमध्ये पद प्रविष्ट करा");
                    Statics.showToast("संस्थेमध्ये पद प्रविष्ट करा");
                    return null;
                    // } else if (selectedDayitvValue.isEmpty) {
                    //   print("दायित्व निवडा");
                    //   Statics.showToast("दायित्व निवडा");
                    //   return null;
                  } else {
                    print("saving data");
                    final _alreadyThere = abhiyaanKaryakartaList.any((e) => e.mobileno == _mobileCntrl.text.trim());
                    if (_alreadyThere) {
                      Statics.showToast(Statics.getLabel('karyakartaAlreadyExists'));
                      return;
                    }
                    final _result = await Statics.checkExistAbhiyanKaryakartaData(editIndex == null ? 0 : abhiyaanKaryakartaList[editIndex].pkid, _mobileCntrl.text.trim(), context: context);
                    if (_result == 0) {
                      final newData = AbhiyaanKaryakartaModel(
                        pkid: editIndex == null ? 0 : abhiyaanKaryakartaList[editIndex].pkid,
                        geounitid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
                        isvasti: 0,
                        name: _fullNameCntrl.text.trim(),
                        mobileno: _mobileCntrl.text.trim(),
                        email: _emailCntrl.text.trim(),
                        isfemale: isFemale,
                        sanstha: selectedSansthaValue,
                        sansthaname: _sansthaNameCntrl.text.trim(),
                        padh: _sansthaPadhCntrl.text.trim(),
                        daayitva: "",
                        isactive: 1,
                        isdefault: 0,
                      );
                      if (editIndex != null) {
                        abhiyaanKaryakartaList[editIndex] = newData;
                      } else {
                        abhiyaanKaryakartaList.add(newData);
                      }
                      clearAbhiyaanKaryakartaFormFields();
                    } else if (_result == 1) {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(Statics.getLabel('alert')),
                          content: Text(Statics.getLabel("karyakartaAlreadyExists")),
                          actions: <Widget>[
                            TextButton(
                              child: Text(Statics.getLabel('okay')),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        ),
                      );
                      return;
                    } else {
                      Statics.showToast(Statics.getLabel('errorOccurred'));
                    }
                    // setState(() {});
                  }
                  Navigator.of(ctx).pop();
                },
                child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  clearAbhiyaanKaryakartaFormFields() {
    selectedAbhiyanValue = "";
    selectedSansthaValue = "";
    // selectedDayitvValue = "";
    selectedAbhiyaanKaryakartaIdIndex = null;
    _anyaSansthaCntrl.clear();
    _sansthaNameCntrl.clear();
    _sansthaPadhCntrl.clear();
    _fullNameCntrl.clear();
    _emailCntrl.clear();
    _mobileCntrl.clear();
    setState(() {});
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
                //       vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
                  if (sajjanShaktiPhoneController.text.length != 10) {
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                    return;
                  }
                  if (sajjanShaktiContactPersonDoorbhashController.text.length != 10) {
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                    return;
                  }
                  if ((sajjanShaktiShreniEditDataId?.isOther == 1 && sajjanShaktiAnyaShreniNameController.text == "") ||
                      (sajjanShaktiVisheshEditDataId?.isOther == 1 && sajjanShaktiAnyaVisheshNameController.text == "")) {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
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
                      vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
    isFemale = null;
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

  // void showAnyaPrabhaviPopup(BuildContext context,
  //     {int? editIndex, VoidCallback? onDataChanged}) {
  //   if (editIndex != null) {
  //     var data = anyaPrabhaviLokDataList[editIndex];
  //     anyaPrabhaviLokNaavController.text = data.name ?? "";
  //     anyaPrabhaviLokAddressController.text = data.address ?? "";
  //     anyaPrabhaviLokMobileNoController.text = data.doorabhaash ?? "";
  //     anyaPrabhaviLokShreniId = data.shreneeid;
  //     anyaPrabhaviLokShreniName = data.selectedDropdownValueName;
  //     anyaPrabhaviLokUpShreniId = data.upshreneeid;
  //     anyaPrabhaviLokUpShreniName = data.selectedDropdownValueName1;
  //     anyaPrabhaviLokAnyaUppshreniController.text = data.otherupshrenee ?? "";
  //     anyaPrabhaviLokUpShreni1Id = data.upshreneeid2;
  //     anyaPrabhaviLokUpShreni1Name = data.selectedDropdownValueName2;
  //     anyaPrabhaviLokAnyaUppshreni1Controller.text = data.otherupshrenee2 ?? "";
  //     anyaPrabhaviLokVisheshId = data.visheshid;
  //     anyaPrabhaviLokVisheshName = data.selectedDropdownValueName3;
  //     anyaPrabhaviLokPrabhavKshetraId = data.prabhaavkshetrid;
  //     anyaPrabhaviLokPrabhavKshetraName = data.selectedDropdownValueName4;
  //     anyaPrabhaviLokAnyaVisheshMahitiController.text = data.othervishesh ?? "";
  //     anyaPrabhaviLokSamparkStithiId = data.samparksthitiid;
  //     anyaPrabhaviLokSamparkStithiName = data.selectedDropdownValueName5;
  //     anyaPrabhaviLokSamparkSutraNaavController.text =
  //         data.samparkasutranav ?? "";
  //     anyaPrabhaviLokSamparkSutraDoorbhashController.text =
  //         data.samparkaSutraDoorbhash ?? "";
  //     pkidAnyaPrabhaviLok = data.pkid;
  //   }
  //   showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       return AlertDialog(
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               "${Statics.getLabel('anyaPrabhaviLok')}",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 20,
  //                 color: Colors.purpleAccent,
  //               ),
  //             ),
  //             IconButton(
  //               icon: Icon(Icons.close, color: Colors.grey),
  //               onPressed: () => Navigator.of(context).pop(),
  //             ),
  //           ],
  //         ),
  //         content: StatefulBuilder(
  //           builder: (context, setState) {
  //             return SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   textControllerField2(
  //                       name: "${Statics.getLabel('Name')}",
  //                       controller: anyaPrabhaviLokNaavController,
  //                       height: 50),
  //                   textControllerField2(
  //                       name: "${Statics.getLabel('Address')}",
  //                       controller: anyaPrabhaviLokAddressController,
  //                       height: 80),
  //                   textControllerField2(
  //                     name: "${Statics.getLabel('doorBhash')}",
  //                     controller: anyaPrabhaviLokMobileNoController,
  //                     height: 50,
  //                     keyboardType: TextInputType.number,
  //                     maxInput: 10,
  //                   ),
  //                   SizedBox(height: 10),
  //                   Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: Text(
  //                       "श्रेणी/उपश्रेणी",
  //                       style: TextStyle(
  //                           fontSize: 15, fontWeight: FontWeight.w500),
  //                     ),
  //                   ),
  //                   SizedBox(height: 5),
  //                   vastisarvekshanDropDownDataModel != null
  //                       ? vastisarvekshanDropdown3(
  //                           filterTypeName: "श्रेणी",
  //                           hintText: "${Statics.getLabel('otherUpshreni')}",
  //                           selectedValue: selectedShreni,
  //                           selectedDependentValue: selectedUpShreni,
  //                           selectedThirdLevelValue: selectedUpShreni2,
  //                           onValueSelected: (id, name, value) {
  //                             anyaPrabhaviLokShreniId = id;
  //                             anyaPrabhaviLokShreniName = name;
  //                             setState(() {
  //                               selectedShreni = value;
  //                               selectedUpShreni = null;
  //                               selectedUpShreni2 = null;
  //                             });
  //                           },
  //                           onDependentValueSelected: (id, name, value) {
  //                             anyaPrabhaviLokUpShreniId = id;
  //                             anyaPrabhaviLokUpShreniName = name;
  //                             setState(() {
  //                               selectedUpShreni = value;
  //                               selectedUpShreni2 = null;
  //                             });
  //                           },
  //                           onThirdLevelValueSelected: (id, name, value) {
  //                             anyaPrabhaviLokUpShreni1Id = id;
  //                             anyaPrabhaviLokUpShreni1Name = name;
  //                             setState(() {
  //                               selectedUpShreni2 = value;
  //                             });
  //                           },
  //                           viewName: true,
  //                         )
  //                       : Container(),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   if (selectedUpShreni?.isOther == 1)
  //                     textControllerField2(
  //                         name: ${Statics.getLabel('otherUpshreni')},
  //                         controller: anyaPrabhaviLokAnyaUppshreniController),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   if (selectedUpShreni2?.isOther == 1)
  //                     textControllerField2(
  //                         name: "${Statics.getLabel('otherUpshreni2')}",
  //                         controller: anyaPrabhaviLokAnyaUppshreni1Controller),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   vastisarvekshanDropDownDataModel != null
  //                       ? vastisarvekshanDropdown2(
  //                           hintText: "${Statics.getLabel('selectVishesh')}",
  //                           filterTypeName: "अन्यप्रभावीलोकंविशेष",
  //                           onItemSelected: (valueId, valueName, isOther) {
  //                             anyaPrabhaviLokVisheshId = valueId;
  //                             anyaPrabhaviLokVisheshName = valueName;
  //                             print("id = $valueId --- Name = $valueName");
  //                           },
  //                           dataModel: vastisarvekshanDropDownDataModel!,
  //                           question: "${Statics.getLabel('special')}",
  //                           editId: selectedAnyaPrabhaviLokVisheshIDEdit,
  //                           selectedValue: selectedAnyaPrabhaviLokVishesh,
  //                           onSelectionChanged: (newValue) {
  //                             setState(() {
  //                               selectedAnyaPrabhaviLokVishesh = newValue;
  //                             });
  //                           },
  //                         )
  //                       : Container(),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   vastisarvekshanDropDownDataModel != null
  //                       ? vastisarvekshanDropdown2(
  //                           hintText: "${Statics.getLabel('prabhavKshetraSelect')}",
  //                           filterTypeName: "अन्यप्रभावीलोकंप्रभावक्षेत्र",
  //                           onItemSelected: (valueId, valueName, isOther) {
  //                             anyaPrabhaviLokPrabhavKshetraId = valueId;
  //                             anyaPrabhaviLokPrabhavKshetraName = valueName;
  //                             print("id = $valueId --- Name = $valueName");
  //                           },
  //                           dataModel: vastisarvekshanDropDownDataModel!,
  //                           question: "${Statics.getLabel('prabhavKshetra')}",
  //                           editId: selectedAnyaPrabhaviLokPrabhavKshetraIDEdit,
  //                           selectedValue:
  //                               selectedAnyaPrabhaviLokPrabhavKshetra,
  //                           onSelectionChanged: (newValue) {
  //                             setState(() {
  //                               selectedAnyaPrabhaviLokPrabhavKshetra =
  //                                   newValue;
  //                             });
  //                           },
  //                         )
  //                       : Container(),
  //                   textControllerField2(
  //                       name: ${Statics.getLabel('anyaVisheshMahiti')},
  //                       controller: anyaPrabhaviLokAnyaVisheshMahitiController,
  //                       height: 80),
  //                   // SizedBox(height: 10,),
  //                   vastisarvekshanDropDownDataModel != null
  //                       ? vastisarvekshanDropdown2(
  //                           hintText: "${Statics.getLabel('samparkSthitiSelect')}",
  //                           filterTypeName: "अन्यप्रभावीलोकंसंपर्कस्थिति",
  //                           onItemSelected: (valueId, valueName, isOther) {
  //                             anyaPrabhaviLokSamparkStithiId = valueId;
  //                             anyaPrabhaviLokSamparkStithiName = valueName;
  //                             print("id = $valueId --- Name = $valueName");
  //                           },
  //                           dataModel: vastisarvekshanDropDownDataModel!,
  //                           question: "${Statics.getLabel('samparkStithi')}",
  //                           editId: selectedAnyaPrabhaviLokSamparkStithiIDEdit,
  //                           selectedValue: selectedAnyaPrabhaviLokSamparkStithi,
  //                           onSelectionChanged: (newValue) {
  //                             setState(() {
  //                               selectedAnyaPrabhaviLokSamparkStithi = newValue;
  //                             });
  //                           },
  //                         )
  //                       : Container(),
  //                   // textControllerField(${Statics.getLabel('anyaVisheshMahiti')}, anyaPrabhaviLokAnyaVisheshMahitiController, context, height: 80),
  //                   textControllerField2(
  //                       name: ""${Statics.getLabel('samparkSootraNaav')}"",
  //                       controller: anyaPrabhaviLokSamparkSutraNaavController,
  //                       height: 50),
  //                   textControllerField2(
  //                     name: "${Statics.getLabel('samparakSootraDoorbhash')}",
  //                     controller:
  //                         anyaPrabhaviLokSamparkSutraDoorbhashController,
  //                     height: 50,
  //                     keyboardType: TextInputType.number,
  //                     maxInput: 10,
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //         actions: [
  //           Align(
  //             alignment: Alignment.center,
  //             child: ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.purple,
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8)),
  //               ),
  //               // onPressed: () {
  //               //   VastisarAnyaprabhavilokam data = VastisarAnyaprabhavilokam(
  //               //     name: anyaPrabhaviLokNaavController.text,
  //               //     address: anyaPrabhaviLokAddressController.text,
  //               //     doorabhaash: anyaPrabhaviLokMobileNoController.text,
  //               //     shreneeid: anyaPrabhaviLokShreniId,
  //               //     selectedDropdownValueName : anyaPrabhaviLokShreniName,
  //               //     upshreneeid : anyaPrabhaviLokUpShreniId,
  //               //     selectedDropdownValueName1 : anyaPrabhaviLokUpShreniName,
  //               //     upshreneeid2: anyaPrabhaviLokUpShreni1Id,
  //               //     selectedDropdownValueName2: anyaPrabhaviLokUpShreni1Name,
  //               //     visheshid : anyaPrabhaviLokVisheshId,
  //               //     selectedDropdownValueName3: anyaPrabhaviLokVisheshName,
  //               //     prabhaavkshetrid: anyaPrabhaviLokPrabhavKshetraId,
  //               //     selectedDropdownValueName4: anyaPrabhaviLokPrabhavKshetraName,
  //               //     othervishesh: anyaPrabhaviLokAnyaVisheshMahitiController.text,
  //               //     samparksthitiid : anyaPrabhaviLokSamparkStithiId,
  //               //     selectedDropdownValueName5: anyaPrabhaviLokSamparkStithiName,
  //               //     samparkasutranav: anyaPrabhaviLokSamparkSutraNaavController.text,
  //               //     samparkaSutraDoorbhash: anyaPrabhaviLokSamparkSutraDoorbhashController.text,
  //               //     pkid: pkidAnyaPrabhaviLok,
  //               //     anyavisesamahiti:anyaPrabhaviLokAnyaVisheshMahitiController.text,
  //               //     otherupshrenee: anyaPrabhaviLokAnyaUppshreniController.text,
  //               //     otherupshrenee2:  anyaPrabhaviLokAnyaUppshreni1Controller.text,
  //               //     isactive:  isActiveAnyaPrabhavilok,
  //               //     vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
  //               //   );
  //               //   if (editIndex != null) {
  //               //     anyaPrabhaviLokDataList[editIndex] = data;
  //               //   } else {
  //               //     anyaPrabhaviLokDataList.add(data);
  //               //   }
  //               //   clearAnyaPrabhaviLokFields();
  //               //   if (onDataChanged != null) {
  //               //     onDataChanged();
  //               //   }
  //               //   Navigator.of(ctx).pop();
  //               // },
  //               onPressed: () {
  //                 if ((selectedUpShreni?.isOther == 1 &&
  //                         anyaPrabhaviLokAnyaUppshreniController.text == "") ||
  //                     (selectedUpShreni2?.isOther == 1 &&
  //                         anyaPrabhaviLokAnyaUppshreni1Controller.text == "")) {
  //                   Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
  //                 } else {
  //                   VastisarAnyaprabhavilokam data = VastisarAnyaprabhavilokam(
  //                     name: anyaPrabhaviLokNaavController.text,
  //                     address: anyaPrabhaviLokAddressController.text,
  //                     doorabhaash: anyaPrabhaviLokMobileNoController.text,
  //                     shreneeid: anyaPrabhaviLokShreniId,
  //                     selectedDropdownValueName: anyaPrabhaviLokShreniName,
  //                     upshreneeid: anyaPrabhaviLokUpShreniId,
  //                     selectedDropdownValueName1: anyaPrabhaviLokUpShreniName,
  //                     upshreneeid2: anyaPrabhaviLokUpShreni1Id,
  //                     selectedDropdownValueName2: anyaPrabhaviLokUpShreni1Name,
  //                     visheshid: anyaPrabhaviLokVisheshId,
  //                     selectedDropdownValueName3: anyaPrabhaviLokVisheshName,
  //                     prabhaavkshetrid: anyaPrabhaviLokPrabhavKshetraId,
  //                     selectedDropdownValueName4:
  //                         anyaPrabhaviLokPrabhavKshetraName,
  //                     othervishesh:
  //                         anyaPrabhaviLokAnyaVisheshMahitiController.text,
  //                     samparksthitiid: anyaPrabhaviLokSamparkStithiId,
  //                     selectedDropdownValueName5:
  //                         anyaPrabhaviLokSamparkStithiName,
  //                     samparkasutranav:
  //                         anyaPrabhaviLokSamparkSutraNaavController.text,
  //                     samparkaSutraDoorbhash:
  //                         anyaPrabhaviLokSamparkSutraDoorbhashController.text,
  //                     pkid: pkidAnyaPrabhaviLok,
  //                     anyavisesamahiti:
  //                         anyaPrabhaviLokAnyaVisheshMahitiController.text,
  //                     otherupshrenee:
  //                         anyaPrabhaviLokAnyaUppshreniController.text,
  //                     otherupshrenee2:
  //                         anyaPrabhaviLokAnyaUppshreni1Controller.text,
  //                     isactive: isActiveAnyaPrabhavilok,
  //                     vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
  //                   );
  //                   if (editIndex != null) {
  //                     anyaPrabhaviLokDataList[editIndex] = data;
  //                   } else {
  //                     anyaPrabhaviLokDataList.add(data);
  //                   }
  //                   clearAnyaPrabhaviLokFields();
  //                   if (onDataChanged != null) {
  //                     onDataChanged();
  //                   }
  //                   Navigator.of(ctx).pop();
  //                 }
  //               },
  //
  //               child: Text("${Statics.getLabel('Submit')}", style: TextStyle(color: Colors.white)),
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
  void showAnyaPrabhaviPopup(BuildContext context, {int? editIndex, VoidCallback? onDataChanged}) {
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
                    textControllerField2(name: "${Statics.getLabel('Name')}", controller: anyaPrabhaviLokNaavController, height: 50, imp: " *"),
                    textControllerField2(name: "${Statics.getLabel('Address')}", controller: anyaPrabhaviLokAddressController, height: 50),
                    textControllerField2(
                      name: "${Statics.getLabel('doorBhash')}",
                      controller: anyaPrabhaviLokMobileNoController,
                      height: 50,
                      keyboardType: TextInputType.number,
                      maxInput: 10,
                      imp: " *",
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
                      children: [
                        Text(
                          "${Statics.getLabel('Category')}/${Statics.getLabel('upshreni')}",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
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
                    if (selectedUpShreni?.isOther == 1) textControllerField2(name: "${Statics.getLabel('otherUpshreni')}", controller: anyaPrabhaviLokAnyaUppshreniController, imp: " *"),
                    if (selectedUpShreni2?.isOther == 1)
                      SizedBox(
                        height: 10,
                      ),
                    if (selectedUpShreni2?.isOther == 1) textControllerField2(name: "${Statics.getLabel('otherUpshreni2')}", controller: anyaPrabhaviLokAnyaUppshreni1Controller, imp: " *"),
                    SizedBox(
                      height: 10,
                    ),
                    vastisarvekshanDropDownDataModel != null
                        ? vastisarvekshanDropdown2(
                            imp: " *",
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
                            imp: " *",
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
                            imp: " *",
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
                    textControllerField2(name: "${Statics.getLabel('samparkSootraNaav')}", controller: anyaPrabhaviLokSamparkSutraNaavController, height: 50, imp: " *"),
                    textControllerField2(
                      name: "${Statics.getLabel('samparakSootraDoorbhash')}",
                      controller: anyaPrabhaviLokSamparkSutraDoorbhashController,
                      keyboardType: TextInputType.number,
                      maxInput: 10,
                      imp: " *",
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
                  bool isEmpty(String? text) => text == null || text.trim().isEmpty;
                  // 🔹 Required field checks
                  if (isEmpty(anyaPrabhaviLokNaavController.text)) {
                    Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                    // isValid = false;
                    // } else if (isEmpty(anyaPrabhaviLokAddressController.text)) {
                    //   Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                    //   isValid = false;
                  } else if (anyaPrabhaviLokMobileNoController.text.length != 10) {
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                    // isValid = false;
                  } else if (anyaPrabhaviLokSamparkStithiId == null ||
                      anyaPrabhaviLokPrabhavKshetraId == null ||
                      anyaPrabhaviLokVisheshId == null ||
                      // anyaPrabhaviLokUpShreni1Id == null ||
                      anyaPrabhaviLokUpShreniId == null ||
                      anyaPrabhaviLokShreniId == null) {
                    Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                    // isValid = false;
                  } else if (isEmpty(anyaPrabhaviLokSamparkSutraNaavController.text)) {
                    Statics.showToast("${Statics.getLabel('impInfoRequired')}");
                    // isValid = false;
                  } else if (anyaPrabhaviLokSamparkSutraDoorbhashController.text.length != 10) {
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                    // isValid = false;
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
                      vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
      vastitSajarHonareAnyaSanController.text = data.otherSajareSan ?? "";
      pkidSajareHonareSan = data.pkid;

      selectedMasterSanName = Masterdata(
        id: selectedSanId,
        value: selectedSanName ?? "",
      );
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${Statics.getLabel('GavatsajareHonareSan')}",
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
                  clearvastitSajarHonareSanFields();
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
                    if (selectedMasterSanName?.isOther == 1) textControllerField2(name: "${Statics.getLabel('otherFestivals')}", controller: vastitSajarHonareAnyaSanController, height: 50),
                    textControllerField2(name: "${Statics.getLabel('aayojakSansthachiNave')}", controller: vastitSajarHonareSanAyojakSansthaNameController, height: 50),
                    textControllerField2(name: "${Statics.getLabel('aayojakNaav')}", controller: vastitSajarHonareSanAyojakNameController, height: 50),
                    textControllerField2(
                      name: "${Statics.getLabel('aayojakSamparkSootra')}",
                      controller: vastitSajarHonareSanAyojakSamparkController,
                      height: 50,
                      keyboardType: TextInputType.number,
                      maxInput: 10,
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
                  if (vastitSajarHonareSanAyojakSamparkController.text.length != 10) {
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                    return;
                  }
                  if ((selectedMasterSanName?.isOther == 1 && vastitSajarHonareAnyaSanController.text == "")) {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                  } else {
                    VastisarVastitamahatvacesana data = VastisarVastitamahatvacesana(
                      id: selectedSanId,
                      selectedDropdownValueName: selectedSanName,
                      ayojakasansthacinave: vastitSajarHonareSanAyojakSansthaNameController.text,
                      ayojakancinave: vastitSajarHonareSanAyojakNameController.text,
                      aayojaksamparksootr: vastitSajarHonareSanAyojakSamparkController.text,
                      // selectedMasterSanName = data['sanObj'];
                      otherSajareSan: vastitSajarHonareAnyaSanController.text,
                      isactive: isActiveSajareHonareSan,
                      pkid: pkidSajareHonareSan ?? 0,
                      vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
                "${Statics.getLabel('GavatHonareKaryakram')}",
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
                    if (selectedSamajikKaryakramName == "अन्य")
                      textControllerField2(name: "${Statics.getLabel('otherEnter')}", controller: vastitSajarHonareSamajikKaryakramAnya1Controller, height: 50),
                    textControllerField2(name: "${Statics.getLabel('aayojakSansthachiNave')}", controller: vastitSajarHonareSamajikKaryakramAyojakSansthaNameController, height: 50),
                    textControllerField2(name: " ${Statics.getLabel('aayojakNaav')}", controller: vastitSajarHonareSamajikKaryakramAyojakNameController, height: 80),
                    textControllerField2(
                      name: "${Statics.getLabel('aayojakSamparkSootra')}",
                      controller: vastitSajarHonareSamajikKaryakramAyojakSamparkController,
                      height: 50,
                      keyboardType: TextInputType.number,
                      maxInput: 10,
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
                // onPressed: () {
                //   VastisarVastitasajaraSamajikkaryakram data = VastisarVastitasajaraSamajikkaryakram(
                //       id: selectedSamajikKaryakramId,
                //       vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
                  if (vastitSajarHonareSamajikKaryakramAyojakSamparkController.text.length != 10) {
                    Statics.showToast("${Statics.getLabel('mobileNumberLimit')}");
                    return;
                  }
                  if ((selectedMasterSamajikKaryakramName?.isOther == 1 && vastitSajarHonareSamajikKaryakramAnya1Controller.text == "")) {
                    Statics.showToast("${Statics.getLabel('otherInfoValidation')}");
                  } else {
                    VastisarVastitasajaraSamajikkaryakram data = VastisarVastitasajaraSamajikkaryakram(
                        id: selectedSamajikKaryakramId,
                        vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
                        pkid: pkidSamajikKaryakram,
                        isactive: isActiveSamajikKaryakram,
                        selectedDropdownValueName: selectedSamajikKaryakramName,
                        otherKaryakram: vastitSajarHonareSamajikKaryakramAnya1Controller.text,
                        ayojakasansthacinave: vastitSajarHonareSamajikKaryakramAyojakSansthaNameController.text,
                        ayojakancinave: vastitSajarHonareSamajikKaryakramAyojakNameController.text,
                        aayojaksamparksootr: vastitSajarHonareSamajikKaryakramAyojakSamparkController.text);
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
                        vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
                  VastisarHinduvirayadi data = VastisarHinduvirayadi(
                    vastiid: int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
      child: Column(
        children: [
          if (isVastiSearch == true)
            if (step3completepercentage != null)
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    dynamicProgressBar(context: context, value: double.parse(step1completepercentage.toString()), detailListItems: step3pendingpoints!.split(',')),
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
                                              "${Statics.getLabel('DurjanShakti')}",
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
                                  if (selectedDurjanShaktiIdIndex == null) return;
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
                                  if (selectedDurjanShaktiIdIndex == null) return;
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
                                  DataColumn(label: Text("${Statics.getLabel('serialNo')}")),
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

  void submitStep3Form() {
    Map<String, dynamic> formData = {
      "vastiid": int.tryParse(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId ?? "0") ?? 0,
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
    setState(() {
      sarpanchDoorbhasController.clear();
      sarpanchNameController.clear();
      femaleController.clear();
      maleController.clear();
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
    });
    searchVastiData(context.read<GeoHierarchyController>().deepestSelectedGeoUnitId);
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
    // 🔹 Start with filtered list
    List<Masterdata> filteredList = dataModel.masterdata!.where((item) => item.typename == filterTypeName && !excludedItemIds.contains(item.id)).toList();

    Masterdata? selectedItem = selectedValue;

    // 🔹 If selectedItem is not already set and editId is provided, get it
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

    // 🔹 Ensure selectedItem is in the dropdown list
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
