import 'package:flutter/material.dart';
import 'package:niyojak_prod/dialogs/hero_dialog.dart';
import 'package:niyojak_prod/models/request_model/get_sankalp_request_model.dart';
import 'package:niyojak_prod/models/request_model/save_sankalp_data_request_model.dart';
import 'package:niyojak_prod/models/response_model/get_sankalp_response_model.dart';
import 'package:niyojak_prod/models/response_model/save_sankalp_response_model.dart';
import 'package:niyojak_prod/providers/bals.dart';
import 'package:niyojak_prod/repository/sankalp_repo.dart';
import 'package:niyojak_prod/utils/hero_dialoge_route.dart';
import 'package:niyojak_prod/validation_blocks/validator.dart';
import 'package:rxdart/rxdart.dart';

import '../helpers/static_data.dart' as Statics;

class SankalpScreenProvider extends ChangeNotifier with SankalpValidator {
  int isLoading = 0;
  int isSaveLoading = 0;
  ScrollController horizontalScrollController = ScrollController();
  ScrollController verticalScrollController = ScrollController();
  ScrollController horizontalScrollController1 = ScrollController();
  ScrollController verticalScrollController1 = ScrollController();
  TextEditingController vastiHasShaakhaaSController = TextEditingController();
  TextEditingController vastiHasSaaptaahikSController = TextEditingController();
  TextEditingController vastiHasMaasikController = TextEditingController();
  TextEditingController vastiHasGatividhiSController = TextEditingController();
  TextEditingController graamHasShaakhaaSController = TextEditingController();
  TextEditingController graamHasSaaptaahikSController = TextEditingController();
  TextEditingController graamHasMaasikSController = TextEditingController();
  TextEditingController graamHasGatividhiSController = TextEditingController();
  TextEditingController mandalHasShaakhaaSController = TextEditingController();
  TextEditingController mandalHasSaaptaahikSController = TextEditingController();
  TextEditingController mandalHasMaasikSController = TextEditingController();
  TextEditingController mandalHasGatividhiSController = TextEditingController();
  TextEditingController sVShaakhaaCountSController = TextEditingController();
  TextEditingController mVShaakhaaCountSController = TextEditingController();
  TextEditingController tVShaakhaaCountSController = TextEditingController();
  TextEditingController pVShaakhaaCountSController = TextEditingController();
  TextEditingController sVSaaptaahikCountSSController = TextEditingController();
  TextEditingController mVSaaptaahikCountSController = TextEditingController();
  TextEditingController tVSaaptaahikCountSController = TextEditingController();
  TextEditingController pVSaaptaahikCountSController = TextEditingController();
  TextEditingController maasikCountSController = TextEditingController();
  TextEditingController mandaliCountSController = TextEditingController();
  TextEditingController pKAShaakhaaCountSController = TextEditingController();
  TextEditingController sKAShaakhaaCountSController = TextEditingController();
  TextEditingController sWAShaakhaaCountSController = TextEditingController();
  TextEditingController pKASaaptaahikCountSController = TextEditingController();
  TextEditingController sKASaaptaahikCountSController = TextEditingController();
  TextEditingController sWASaaptaahikCountSController = TextEditingController();
  TextEditingController pKAMaasikCountSController = TextEditingController();
  TextEditingController sKAMaasikCountSController = TextEditingController();
  TextEditingController sWAMaasikCountSController = TextEditingController();
  TextEditingController pKAGatividhiCountSController = TextEditingController();
  TextEditingController sKAGatividhiCountSController = TextEditingController();
  TextEditingController sWAGatividhiCountSController = TextEditingController();

  SankalpRepo sankalpRepo = SankalpRepo();
  GetSankalpResponseModel? getSankalp;
  final userSankalpYear = BehaviorSubject<String>();
  final userBhaagName = BehaviorSubject<String>();
  final userTaalukaa = BehaviorSubject<String>();

  List<GeoUnitMasterBAL> bhaagList = [];
  List<GeoUnitMasterBAL> taalukaaList = [];

  Stream<String> get sankalpYear => userSankalpYear.stream.transform(validateSankalpYear);
  Stream<String> get taalukaa => userTaalukaa.stream.transform(validateTaalukaa);
  Stream<String> get bhaagName => userBhaagName.stream.transform(validateBhaagName);
  Stream<bool> get validateGet => Rx.combineLatest2(
      sankalpYear,
      bhaagName,
      (
        a,
        b,
      ) =>
          true);

  Function(String) get changeUserSankalpYear => userSankalpYear.sink.add;
  Function(String) get changeUserBhaagname => userBhaagName.sink.add;
  Function(String) get changeUserTaalukaa => userTaalukaa.sink.add;

  List<String> sankalpYearList = [];
  SaveSankalpDataResponseModel? sankalpDataResponseModel;
  GetSankalpResponseModel? get getSankalpModel => getSankalp;

  List<String> get getSankalpYearList => sankalpYearList;
  List<GeoUnitMasterBAL> get getBhaagList => bhaagList;
  List<GeoUnitMasterBAL> get getTaalukaaList => taalukaaList;
  SaveSankalpDataResponseModel? get getSaveSankalpData => sankalpDataResponseModel;
  int get getIsGetLoading => isLoading;
  int get getIsSaveLoading => isSaveLoading;

  set setSankalpYearList(List<String> val) {
    sankalpYearList = val;
    notifyListeners();
  }

  set setIsSaveLoading(int val) {
    isSaveLoading = val;
    notifyListeners();
  }

  set setIsGetLoading(int val) {
    isLoading = val;
    notifyListeners();
  }

  set setSaveSankalpData(SaveSankalpDataResponseModel val) {
    sankalpDataResponseModel = val;

    notifyListeners();
  }

  set setSankalpModel(GetSankalpResponseModel val) {
    getSankalp = val;
    // getSankalp!.sankalpInfo!.isSankalpOpen = false;
    notifyListeners();
  }

  set setBhaagList(List<GeoUnitMasterBAL> val) {
    bhaagList = val;
    notifyListeners();
  }

  set setTaalukaalist(List<GeoUnitMasterBAL> val) {
    taalukaaList = val;
    notifyListeners();
  }

  Future<void> initiatestate() async {
    await generateSankalpYearList();
    await populateBhaagDropdown();

    await listenToField();
  }

  Future<void> generateSankalpYearList() async {
    int startYear = 2022;
    var currentYear = DateTime.now().year;
    List<String> subYearList = List.generate((currentYear - startYear) + 1, (index) => "${2022 + index}");
    subYearList.addAll(List.generate(2, (index) => "${currentYear + index + 1}"));
    setSankalpYearList = subYearList;
    print(subYearList);
  }

  Future<void> populateBhaagDropdown() async {
    setBhaagList = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
  }

  Future<void> populateTaalukaaDropdown() async {
    setTaalukaalist = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), "${userBhaagName.value}", "", "");
  }

  Future<void> listenToField() async {
    userBhaagName.listen((value) async {
      if (userBhaagName.hasValue) {
        await populateTaalukaaDropdown();
      }
    });
  }

  @override
  void dispose() {
    userSankalpYear.close();
    userBhaagName.close();
    userTaalukaa.close();
    super.dispose();
  }

  Future<void> controlSankalpData(BuildContext context) async {
    await callGetSankalpData(context);
    assignFieldValue();
  }

  Future<bool> callGetSankalpData(BuildContext context) async {
    try {
      setIsGetLoading = 1;
      setSankalpModel = await sankalpRepo.getSankalp(GetSankalpRequestModel(
        kaaryaSthitiMonth: 6,
        appUserID: int.parse(Statics.userDetails["userID"]),
        geoUnitID: 195, //int.parse(userBhaagName.value),
        sankalpYear: int.parse(userSankalpYear.value),
      ).toJson());
      setIsGetLoading = 2;
      if (getSankalpModel != null && getSankalpModel!.sankalpInfo!.isSankalpOpen != null) {
        return true;
      } else {
        setIsGetLoading = 3;
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<void> assignFieldValue() async {
    vastiHasShaakhaaSController.text = "${getSankalpModel!.sankalpInfo!.vastiHasShaakhaaS ?? 0}";
    vastiHasSaaptaahikSController.text = "${getSankalpModel!.sankalpInfo!.vastiHasSaaptaahikS ?? 0}";
    vastiHasMaasikController.text = "${getSankalpModel!.sankalpInfo!.vastiHasMaasikS ?? 0}";
    vastiHasGatividhiSController.text = "${getSankalpModel!.sankalpInfo!.vastiHasGatividhiS ?? 0}";
    graamHasShaakhaaSController.text = "${getSankalpModel!.sankalpInfo!.graamHasShaakhaaS ?? 0}";
    graamHasSaaptaahikSController.text = "${getSankalpModel!.sankalpInfo!.graamHasSaaptaahikS ?? 0}";
    graamHasMaasikSController.text = "${getSankalpModel!.sankalpInfo!.graamHasMaasikS ?? 0}";
    graamHasGatividhiSController.text = "${getSankalpModel!.sankalpInfo!.graamHasGatividhiS ?? 0}";
    mandalHasShaakhaaSController.text = "${getSankalpModel!.sankalpInfo!.mandalHasShaakhaaS ?? 0}";
    mandalHasSaaptaahikSController.text = "${getSankalpModel!.sankalpInfo!.mandalHasSaaptaahikS ?? 0}";
    mandalHasMaasikSController.text = "${getSankalpModel!.sankalpInfo!.mandalHasMaasikS ?? 0}";
    mandalHasGatividhiSController.text = "${getSankalpModel!.sankalpInfo!.mandalHasGatividhiS ?? 0}";
    sVShaakhaaCountSController.text = "${getSankalpModel!.sankalpInfo!.sVShaakhaaCountS ?? 0}";
    mVShaakhaaCountSController.text = "${getSankalpModel!.sankalpInfo!.mVShaakhaaCountS ?? 0}";
    tVShaakhaaCountSController.text = "${getSankalpModel!.sankalpInfo!.tVShaakhaaCountS ?? 0}";
    pVShaakhaaCountSController.text = "${getSankalpModel!.sankalpInfo!.pVShaakhaaCountS ?? 0}";
    sVSaaptaahikCountSSController.text = "${getSankalpModel!.sankalpInfo!.sVSaaptaahikCountS ?? 0}";
    mVSaaptaahikCountSController.text = "${getSankalpModel!.sankalpInfo!.mVSaaptaahikCountS ?? 0}";
    tVSaaptaahikCountSController.text = "${getSankalpModel!.sankalpInfo!.tVSaaptaahikCountS ?? 0}";
    pVSaaptaahikCountSController.text = "${getSankalpModel!.sankalpInfo!.pVSaaptaahikCountS ?? 0}";
    maasikCountSController.text = "${getSankalpModel!.sankalpInfo!.maasikCountS ?? 0}";
    mandaliCountSController.text = "${getSankalpModel!.sankalpInfo!.mandaliCountS ?? 0}";
    pKAShaakhaaCountSController.text = "${getSankalpModel!.sankalpInfo!.pKAShaakhaaCountS ?? 0}";
    sKAShaakhaaCountSController.text = "${getSankalpModel!.sankalpInfo!.sKAShaakhaaCountS ?? 0}";
    sWAShaakhaaCountSController.text = "${getSankalpModel!.sankalpInfo!.sWAShaakhaaCountS ?? 0}";
    pKASaaptaahikCountSController.text = "${getSankalpModel!.sankalpInfo!.pKASaaptaahikCountS ?? 0}";
    sKASaaptaahikCountSController.text = "${getSankalpModel!.sankalpInfo!.sKASaaptaahikCountS ?? 0}";
    sWASaaptaahikCountSController.text = "${getSankalpModel!.sankalpInfo!.sWASaaptaahikCountS ?? 0}";
    pKAMaasikCountSController.text = "${getSankalpModel!.sankalpInfo!.pKAMaasikCountS ?? 0}";
    sKAMaasikCountSController.text = "${getSankalpModel!.sankalpInfo!.sKAMaasikCountS ?? 0}";
    sWAMaasikCountSController.text = "${getSankalpModel!.sankalpInfo!.sWAMaasikCountS ?? 0}";
    pKAGatividhiCountSController.text = "${getSankalpModel!.sankalpInfo!.pKAGatividhiCountS ?? 0}";
    sKAGatividhiCountSController.text = "${getSankalpModel!.sankalpInfo!.sKAGatividhiCountS ?? 0}";
    sWAGatividhiCountSController.text = "${getSankalpModel!.sankalpInfo!.sWAGatividhiCountS ?? 0}";
  }

  Future<void> showEditDialog(BuildContext context, TextEditingController controller, String title, String tag) async {
    controller.text = await Navigator.push(
        context,
        HeroDialogRoute(
          builder: (context) => EditDialog(
            title: title,
            value: controller.text,
            year: "${getSankalpModel!.sankalpInfo!.sankalpYear}",
            tag: tag,
          ),
        ));
  }

  bool get getIsEditEnabled => getSankalpModel != null ? getSankalpModel!.sankalpInfo!.isSankalpOpen ?? false : false;

  Future<bool> saveSankalpData(BuildContext context) async {
    try {
      setIsSaveLoading = 1;
      setSaveSankalpData = await sankalpRepo.saveData(SaveSankalpDataRequestModel(
          modifiedBy: int.parse(Statics.userDetails["userID"]),
          sankalpInfo: UpdateSankalpInfo(
            geoUnitID: 195,
            sankalpID: getSankalpModel!.sankalpInfo!.sankalpID,
            sankalpYear: getSankalpModel!.sankalpInfo!.sankalpYear,
            modifiedBy: int.parse(Statics.userDetails["userID"]),
            vastiHasShaakhaaS: int.parse(vastiHasShaakhaaSController.text),
            vastiHasSaaptaahikS: int.parse(vastiHasSaaptaahikSController.text),
            vastiHasMaasik: int.parse(vastiHasMaasikController.text),
            vastiHasGatividhiS: int.parse(vastiHasGatividhiSController.text),
            graamHasShaakhaaS: int.parse(graamHasShaakhaaSController.text),
            graamHasSaaptaahikS: int.parse(graamHasSaaptaahikSController.text),
            graamHasMaasikS: int.parse(graamHasMaasikSController.text),
            graamHasGatividhiS: int.parse(graamHasGatividhiSController.text),
            mandalHasShaakhaaS: int.parse(mandalHasShaakhaaSController.text),
            mandalHasSaaptaahikS: int.parse(mandalHasSaaptaahikSController.text),
            mandalHasMaasikS: int.parse(mandalHasMaasikSController.text),
            mandalHasGatividhiS: int.parse(mandalHasGatividhiSController.text),
            sVShaakhaaCountS: int.parse(sVShaakhaaCountSController.text),
            mVShaakhaaCountS: int.parse(mVShaakhaaCountSController.text),
            tVShaakhaaCountS: int.parse(tVShaakhaaCountSController.text),
            pVShaakhaaCountS: int.parse(pVShaakhaaCountSController.text),
            sVSaaptaahikCountS: int.parse(sVSaaptaahikCountSSController.text),
            mVSaaptaahikCountS: int.parse(mVSaaptaahikCountSController.text),
            pVSaaptaahikCountS: int.parse(pVSaaptaahikCountSController.text),
            tVSaaptaahikCountS: int.parse(tVSaaptaahikCountSController.text),
            maasikCountS: int.parse(maasikCountSController.text),
            mandaliCountS: int.parse(mandaliCountSController.text),
            sKAShaakhaaCountS: int.parse(sKAShaakhaaCountSController.text),
            sWAShaakhaaCountS: int.parse(sWAShaakhaaCountSController.text),
            pKAShaakhaaCountS: int.parse(pKAShaakhaaCountSController.text),
            pKASaaptaahikCountS: int.parse(pKASaaptaahikCountSController.text),
            sKASaaptaahikCountS: int.parse(sKASaaptaahikCountSController.text),
            sWASaaptaahikCountS: int.parse(sWASaaptaahikCountSController.text),
            pKAMaasikCountS: int.parse(pKAMaasikCountSController.text),
            sKAMaasikCountS: int.parse(sKAMaasikCountSController.text),
            sWAMaasikCountS: int.parse(sWAMaasikCountSController.text),
            pKAGatividhiCountS: int.parse(pKAGatividhiCountSController.text),
            sKAGatividhiCountS: int.parse(sKAGatividhiCountSController.text),
            sWAGatividhiCountS: int.parse(sWAGatividhiCountSController.text),
          )).toJson());
      setIsSaveLoading = 0;
      if (getSaveSankalpData!.status == "Success") {
        Statics.showToast(Statics.getLabel("dataSavedSuccessfully"));
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      return false;
    }
  }

  void onTapResetLink() {
    changeUserSankalpYear("");
    changeUserBhaagname("");
    changeUserTaalukaa("");
    setIsGetLoading = 0;
  }
}
