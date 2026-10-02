import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helpers/database_helper.dart';
import '../../../helpers/offline_data_api_repo.dart';
import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/shaakhaa_vistaar_vrutta_resp_model.dart';
import '../../../models/response_model/shaakhaa_vistar_list_resp_model.dart';
import '../../../providers/bals.dart';
import '../../../utils/globals.dart';
import '../../../utils/multi_select_option_widget.dart';
import '../../shaakhaa_milan_module/edit_shaakhaa_vrutta.dart';

class ShakhaaSaptahFormScreen extends StatefulWidget {
  static const String routeName = '/shaakhaa-vistar-saptah-vrutta-screen';
  final ShaakhaaList? shaakhaa;
  final int? shaakhaaId;
  final bool fromYesterday;
  final String? viewType;
  final bool showAppBar;
  final bool isNew;
  final DateTime? vruttadate;

  const ShakhaaSaptahFormScreen({this.shaakhaa, this.shaakhaaId, this.fromYesterday = false, this.isNew = false, this.showAppBar = true, this.viewType, this.vruttadate, super.key});

  @override
  State<ShakhaaSaptahFormScreen> createState() => _ShakhaaSaptahFormScreenState();
}

class _ShakhaaSaptahFormScreenState extends State<ShakhaaSaptahFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  VistaarVrutta? vrutta;
  DraftRecordSource? _loadedSource;
  bool _isFormViewOnly = false;

  Map<String, List<SelectItem<int>>> _sewaDaysGroup = {};

  var _isLoading = false;

  bool _isFetchingData = false;

  // DateTime? _vruttaDate;
  var _vruttaDateCntrl = TextEditingController();
  var _shishuCtrl = TextEditingController();
  var _newshishuCtrl = TextEditingController();
  var _baalCtrl = TextEditingController();
  var _newbaalCtrl = TextEditingController();
  var _tarunVidhyaarthiCtrl = TextEditingController();
  var _newtarunVidhyaarthiCtrl = TextEditingController();
  var _tarunVyavsaayeeCtrl = TextEditingController();
  var _newtarunVyavsaayeeCtrl = TextEditingController();
  var _proudhaCtrl = TextEditingController();
  var _newproudhaCtrl = TextEditingController();
  var _matrushaktiCtrl = TextEditingController();
  var _newmatrushaktiCtrl = TextEditingController();
  var _abhyaagatCtrl = TextEditingController();
  var _pravasiKaryakartaCountCtrl = TextEditingController();
  var _anyaPravasiKaryakartaCountCtrl = TextEditingController();
  var _remarkCtrl = TextEditingController();

  // bool _isMandatoryShaaririk = false;
  // bool _isMandatoryBouddhik = false;
  bool _isOptionalShaaririk = false;
  bool _isOptionalOther = false;
  var vayogatCode = '';
  var frequencyId = 0;
  List<StaticMasterBAL> _frequency = [];

  bool _isDoneDeepBreathing = false;
  bool _isDoneDandaPrahaar = false;
  bool _isDoneSooryaNamaskaar = false;
  bool _isDoneSanchalanAbhyaas = false;

  bool _isDoneUrdhvapad = false;
  bool _isDoneBoodhKatha = false;
  bool _isDoneBoudhikDays = false;
  String? _selectedBoudhikDaysId;
  var _anyaBoudhikDaysCtrl = TextEditingController();
  bool _isDoneSewaDays = false;

  // String? _selectedSewaDaysId;

  bool _isDoneSaanghikGeet = false;
  bool _isDoneAmrutaVachan = false;
  bool _isDoneSubhaashit = false;

  List<StaticMasterBAL?> _boudhikDaysList = [];

  // List<StaticMasterBAL?> _sewaDaysList = [];
  List<int> _selectedSewaDaysList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  @override
  void didUpdateWidget(covariant ShakhaaSaptahFormScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the ID or parameters actually changed
    if (oldWidget.shaakhaaId != widget.shaakhaaId || oldWidget.fromYesterday != widget.fromYesterday || oldWidget.viewType != widget.viewType) {
      // If they changed, re-fetch your data or reset your controllers!
      setState(() {
        initData();
      });
    }
  }

  initData() async {
    // int vruttaID = widget.shaakhaa == null ? 0 : widget.shaakhaa?.pkid ?? 0;
    print("widget.fromYesterday >>>>>>>>>>>> ${widget.fromYesterday}");
    int shaakhaaID = widget.shaakhaa == null ? (widget.shaakhaaId ?? 0) : widget.shaakhaa?.shaakhaaID ?? widget.shaakhaaId ?? 0;
    _vruttaDateCntrl.text = DateFormat("dd-MMM-yyyy").format(widget.fromYesterday ? DateTime.now().subtract(const Duration(days: 1)) : widget.vruttadate ?? DateTime.now());
    await populateShaakhaVayogat(shaakhaaID.toString());
    // if (vruttaID > 0) {
    await getSwDetails();
    if (mounted) setState(() {});
  }

  populateShaakhaVayogat(shaakhaaID) async {
    // var data = await Statics.getShaakhaaByID(shaakhaaID);
    var data2 = await Statics.getStaticLDB('ShaakhaaVayogat');
    var data3 = await Statics.getStaticLDB('ShaakhaaFrequency');
    _boudhikDaysList = await Statics.getStaticLDB('boudhikDaysList');
    // _sewaDaysList = await Statics.getStaticLDB('sewaDaysList');
    if (widget.shaakhaa != null) {
      var code = data2[data2.indexWhere((e) => e.staticID == widget.shaakhaa!.vayogatID)].code;
      var freq = widget.shaakhaa!.frequencyID;
      setState(() {
        vayogatCode = code!;
        _frequency = data3;
        frequencyId = freq ?? 0;
      });

      // print("code >>>>>>>>>>>>>>>>>>>>>>>>>>>>> $code");
      print("frequencyId >>>>>>>>>>>>>>>>>>>>>>>>>>>>> $frequencyId");
    }
    if (mounted) setState(() {});
    // _boudhikDaysList.forEach((e) => print("e >>>>>>>>>>>>>>>>>>>> ${e?.toJson()}"));
  }

  Map<String, List<SelectItem<int>>> buildGroupedItemsFromApi(List<SewaDaysGroupData> data) {
    // Step 1: collect headers (GroupId == 0) -> {StaticID: headerName}.
    final Map<int, String> groupHeaders = {};
    for (final item in data) {
      if (item.groupId == 0) {
        groupHeaders[item.staticId] = item.name;
      }
    }

    // Step 2: bucket every non-header row under its matching header,
    // preserving the order headers were first encountered.
    final Map<String, List<SelectItem<int>>> grouped = {};
    for (final item in data) {
      if (item.groupId == 0) continue; // header row itself, not selectable
      final headerName = groupHeaders[item.groupId] ?? 'Other';
      grouped.putIfAbsent(headerName, () => []);
      grouped[headerName]!.add(SelectItem<int>(item.staticId, item.name));
    }

    return grouped;
  }

  getSwDetails() async {
    if (!mounted) return;
    setState(() {
      _isFetchingData = true;
    });

    final _shaakhaaId = widget.isNew ? 0 : widget.shaakhaaId ?? widget.shaakhaa?.shaakhaaID ?? 0;
    final _vruttaDate = DateFormat("dd/MM/yyyy").format(DateFormat("dd-MMM-yyyy").parse(_vruttaDateCntrl.text));

    final _body = {
      "ShaakhaaID": widget.shaakhaaId ?? widget.shaakhaa?.shaakhaaID ?? 0,
      "pkid": widget.shaakhaa?.pkid,
      "date": _vruttaDate,
      "appuserid": int.parse(Statics.userDetails['userID']),
    };

    try {
      // VistaarVrutta? data;

      final _res = await OfflineDataApiRepo.loadWithFallback(
        masterTableName: widget.isNew ? "VistarShaakhaVruttaMaster" : "ShaakhaVruttaMaster",
        draftTableName: 'VruttaDraftMaster',
        keyColumns: ['ShaakhaaID', 'VruttaDate'],
        keyValues: [_body["ShaakhaaID"], _body["Vruttadate"]],
        where: 'ShaakhaaID = ? AND VruttaDate LIKE ?',
        whereArgs: [(widget.shaakhaa?.mapShaakhaaID ?? widget.shaakhaa?.shaakhaaID ?? widget.shaakhaaId), "${_vruttaDate}%"],
        fetchFromApi: () async {
          final vrutta = await Statics.getShaakhaaSaptahVruttaData(context, _body);
          return vrutta?.toJson();
        },
      );

      _loadedSource = _res.source;

      // final _vrutta = await Statics.getShaakhaaSaptahVruttaData(context, _body);
      // final _res = _vrutta?.toJson();

      final _data = await DatabaseHelper.getAllOfflineData<SewaDaysGroupData>(
        tableName: 'SewaSanskarData',
        fromMap: SewaDaysGroupData.fromJson,
      );

      // log("_res.data >>>>> ${_res.data}");

      if (_data.isNotEmpty) _sewaDaysGroup = buildGroupedItemsFromApi(_data);

      if (!mounted) return;
      if (_res.data == null)
        vrutta = VistaarVrutta();
      else
        vrutta = VistaarVrutta.fromJson(_res.data!);
      // vrutta = data;
      setState(() {
        if (vrutta != null) {
          // _vruttaDate = ((vrutta!.vruttaDate != null && vrutta!.vruttaDate != "") ? vrutta!.vruttaDate! : null);
          // _vruttaDateCntrl.text = ((vrutta!.vruttaDate != null && vrutta!.vruttaDate != "") ? DateFormat('dd-MMM-yyyy').format(_vruttaDate!) : '');
          _shishuCtrl.text = vrutta?.shishuCount == null ? "" : vrutta!.shishuCount.toString();
          _newshishuCtrl.text = vrutta?.newShishuCount == null ? "" : vrutta!.newShishuCount.toString();
          _baalCtrl.text = vrutta?.baalVidyaarthiCount == null ? "" : vrutta!.baalVidyaarthiCount.toString();
          _newbaalCtrl.text = vrutta?.newBaalVidyaarthiCount == null ? "" : vrutta!.newBaalVidyaarthiCount.toString();
          _tarunVidhyaarthiCtrl.text = vrutta?.tarunVidyaarthiCount == null ? "" : vrutta!.tarunVidyaarthiCount.toString();
          _newtarunVidhyaarthiCtrl.text = vrutta?.newTarunVidyaarthiCount == null ? "" : vrutta!.newTarunVidyaarthiCount.toString();
          _tarunVyavsaayeeCtrl.text = vrutta?.tarunVyavasaayeeCount == null ? "" : vrutta!.tarunVyavasaayeeCount.toString();
          _newtarunVyavsaayeeCtrl.text = vrutta?.newTarunVyavasaayeeCount == null ? "" : vrutta!.newTarunVyavasaayeeCount.toString();
          _proudhaCtrl.text = vrutta?.proudhaVyavasaayeeCount == null ? "" : vrutta!.proudhaVyavasaayeeCount.toString();
          _newproudhaCtrl.text = vrutta?.newProudhaVyavasaayeeCount == null ? "" : vrutta!.newProudhaVyavasaayeeCount.toString();
          _matrushaktiCtrl.text = vrutta?.matruskatiCount == null ? "" : vrutta!.matruskatiCount.toString();
          _newmatrushaktiCtrl.text = vrutta?.newmatruskatiCount == null ? "" : vrutta!.newmatruskatiCount.toString();
          _abhyaagatCtrl.text = vrutta?.abhyaagatCount == null ? "" : vrutta!.abhyaagatCount.toString();
          _pravasiKaryakartaCountCtrl.text = vrutta?.pravasiKaryakartaCount == null ? "" : vrutta!.pravasiKaryakartaCount.toString();
          _anyaPravasiKaryakartaCountCtrl.text = vrutta?.anyaPravasiKaryakartaCount == null ? "" : vrutta!.anyaPravasiKaryakartaCount.toString();
          _remarkCtrl.text = vrutta?.remark == null ? "" : vrutta!.remark.toString();

          // _isMandatoryShaaririk =
          //     vrutta?.isMandatoryShaaririk == true ? true : false;

          // _isMandatoryBouddhik =
          //     vrutta?.isMandatoryBouddhik == true ? true : false;

          _isOptionalShaaririk = vrutta?.isOptionalShaaririk ?? false;

          _isOptionalOther = vrutta?.isOptionalOther ?? false;

          _isDoneDeepBreathing = vrutta?.isDoneDeepBreathing ?? false;
          _isDoneDandaPrahaar = vrutta?.isDoneDandaPrahaar ?? false;
          _isDoneSooryaNamaskaar = vrutta?.isDoneSooryaNamaskaar ?? false;
          _isDoneSanchalanAbhyaas = vrutta?.isDoneSanchalanAbhyaas ?? false;
          _isDoneSaanghikGeet = vrutta?.isDoneSaanghikGeet ?? false;
          _isDoneAmrutaVachan = vrutta?.isDoneAmrutaVachan ?? false;
          _isDoneSubhaashit = vrutta?.isDoneSubhaashit ?? false;
          _isDoneUrdhvapad = vrutta?.isDoneUrdhvapad ?? false;
          _isDoneBoodhKatha = vrutta?.isDoneBoodhKatha ?? false;
          _isDoneBoudhikDays = vrutta?.isDoneBoudhikDays ?? false;
          _isDoneSewaDays = vrutta?.isDoneSewaDays ?? false;

          _selectedBoudhikDaysId = (vrutta?.boudhikDaysId == 0 || vrutta?.boudhikDaysId == null) ? null : vrutta?.boudhikDaysId?.toString();
          _anyaBoudhikDaysCtrl.text = vrutta?.anyaBoudhikDays ?? "";
          _selectedSewaDaysList = vrutta?.sewaDaysId?.split(',').map((e) => int.tryParse(e)).where((e) => e != null).cast<int>().toList() ?? [];
        }
      });

      if (_res.source == DraftRecordSource.masterOffline) {
        // Blocked AT LOAD TIME, per your condition 2.2.1 — before any editing starts.
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(Statics.getLabel("alert")),
              content: Text(Statics.getLabel("noInternetNoChanges")),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(Statics.getLabel("okay"))),
              ],
            );
          },
        );
        _isFormViewOnly = true;
        setState(() {});
        return;
      }
      // print(_vruttaDate);
    } catch (e) {
      log("printing the error on loadWithFallback >> VistarShaakhaVruttaMaster >> $e");
    } finally {
      if (mounted)
        setState(() {
          _isFetchingData = false;
        });
    }
  }

  _pickFromDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateFormat("dd-MMM-yyyy").parse(_vruttaDateCntrl.text),
        firstDate: DateTime((DateFormat("dd-MMM-yyyy").parse(_vruttaDateCntrl.text).year) - 80),
        lastDate: DateTime.now());

    /*var _todaysDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));

    if (date != null) {
      var _formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
      if (_formattedDate.isAfter(_todaysDate)) {
        Statics.showToast("Vrutta Date cannot be a Future Date.");
        return;
      }
    }*/

    if (date != null) {
      setState(() {
        // _vruttaDate = date;
        _vruttaDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
      });
      getSwDetails();
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await saveVruttaDetails(context);
    } catch (error) {
      log("Exception >>> Errors >>>>>>>>>> $error");
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }

    setState(() {
      _isLoading = false;
    });
  }

  saveVruttaDetails(BuildContext context) async {
    var inputData = {
      "ShaakhaaVruttaID": widget.shaakhaa?.pkid ?? widget.shaakhaaId,
      "PraantID": 1,
      "pkid": vrutta?.pkid ?? widget.shaakhaa?.pkid ?? widget.shaakhaaId,
      "ShaakhaaID": widget.shaakhaa?.mapShaakhaaID ?? widget.shaakhaa?.shaakhaaID ?? widget.shaakhaaId,
      "mapShaakhaaID": widget.shaakhaa?.mapShaakhaaID ?? widget.shaakhaa?.shaakhaaID ?? widget.shaakhaaId,
      "date": DateFormat("dd/MM/yyyy").format(DateFormat("dd-MMM-yyyy").parse(_vruttaDateCntrl.text)),
      "VruttaDate": DateFormat("dd/MM/yyyy").format(DateFormat("dd-MMM-yyyy").parse(_vruttaDateCntrl.text)),
      "VruttaDateStr": DateFormat("dd/MM/yyyy").format(DateFormat("dd-MMM-yyyy").parse(_vruttaDateCntrl.text)),
      "ShishuCount": _shishuCtrl.text.trim() == "" ? null : int.parse(_shishuCtrl.text),
      "NewShishuCount": _newshishuCtrl.text.trim() == "" ? null : int.parse(_newshishuCtrl.text),
      "BaalVidyaarthiCount": _baalCtrl.text.trim() == "" ? null : int.parse(_baalCtrl.text),
      "NewBaalVidyaarthiCount": _newbaalCtrl.text.trim() == "" ? null : int.parse(_newbaalCtrl.text),
      "TarunVidyaarthiCount": _tarunVidhyaarthiCtrl.text.trim() == "" ? null : int.parse(_tarunVidhyaarthiCtrl.text),
      "NewTarunVidyaarthiCount": _newtarunVidhyaarthiCtrl.text.trim() == "" ? null : int.parse(_newtarunVidhyaarthiCtrl.text),
      "TarunVyavasaayeeCount": _tarunVyavsaayeeCtrl.text.trim() == "" ? null : int.parse(_tarunVyavsaayeeCtrl.text),
      "NewTarunVyavasaayeeCount": _newtarunVyavsaayeeCtrl.text.trim() == "" ? null : int.parse(_newtarunVyavsaayeeCtrl.text),
      "ProudhaVyavasaayeeCount": _proudhaCtrl.text.trim() == "" ? null : int.parse(_proudhaCtrl.text),
      "NewProudhaVyavasaayeeCount": _newproudhaCtrl.text.trim() == "" ? null : int.parse(_newproudhaCtrl.text),
      "matruskatiCount": _matrushaktiCtrl.text.trim() == "" ? null : int.parse(_matrushaktiCtrl.text),
      "newmatruskatiCount": _newmatrushaktiCtrl.text.trim() == "" ? null : int.parse(_newmatrushaktiCtrl.text),
      "totalCount": ((int.tryParse(_shishuCtrl.text) ?? 0) +
          (int.tryParse(_baalCtrl.text) ?? 0) +
          (int.tryParse(_tarunVidhyaarthiCtrl.text) ?? 0) +
          (int.tryParse(_tarunVyavsaayeeCtrl.text) ?? 0) +
          (int.tryParse(_proudhaCtrl.text) ?? 0) +
          (int.tryParse(_matrushaktiCtrl.text) ?? 0)),
      "newtotalCount": ((int.tryParse(_newshishuCtrl.text) ?? 0) +
          (int.tryParse(_newbaalCtrl.text) ?? 0) +
          (int.tryParse(_newtarunVidhyaarthiCtrl.text) ?? 0) +
          (int.tryParse(_newtarunVyavsaayeeCtrl.text) ?? 0) +
          (int.tryParse(_newproudhaCtrl.text) ?? 0) +
          (int.tryParse(_newmatrushaktiCtrl.text) ?? 0)),
      "AbhyaagatCount": _abhyaagatCtrl.text.trim() == "" ? null : int.parse(_abhyaagatCtrl.text),
      "PravasiKaryakartaCount": _pravasiKaryakartaCountCtrl.text.trim() == "" ? null : int.parse(_pravasiKaryakartaCountCtrl.text),
      "AnyaPravasiKaryakartaCount": _anyaPravasiKaryakartaCountCtrl.text.trim() == "" ? null : int.parse(_anyaPravasiKaryakartaCountCtrl.text),
      // "IsMandatoryShaaririk": _isMandatoryShaaririk,
      // "IsMandatoryBouddhik": _isMandatoryBouddhik,
      "IsDoneDeepBreathing": vayogatCode == "Proudh Vyavasaayee" ? _isDoneDeepBreathing : null,
      "IsDoneDandaPrahaar": vayogatCode == "Proudh Vyavasaayee" ? null : _isDoneDandaPrahaar,
      "IsDoneSooryaNamaskaar": vayogatCode == "Proudh Vyavasaayee" ? null : _isDoneSooryaNamaskaar,
      "IsDoneSanchalanAbhyaas": vayogatCode == "Proudh Vyavasaayee" ? null : _isDoneSanchalanAbhyaas,
      "IsDoneUrdhvapad": vayogatCode == "Baal" ? _isDoneUrdhvapad : null,
      "IsDoneSaanghikGeet": _isDoneSaanghikGeet,
      "IsDoneAmrutaVachan": _isDoneAmrutaVachan,
      "IsDoneSubhaashit": _isDoneSubhaashit,
      "IsDoneBoodhKatha": _isDoneBoodhKatha,
      "IsDoneBoudhikDays": _isDoneBoudhikDays,
      "BoudhikDaysId": _selectedBoudhikDaysId,
      "AnyaBoudhikDays": _anyaBoudhikDaysCtrl.text.trim(),
      "IsDoneSewaDays": _isDoneSewaDays,
      "SewaDaysId": _selectedSewaDaysList.isNotEmpty ? _selectedSewaDaysList.where((e) => e != null).join(",") : "",
      "IsOptionalShaaririk": _isOptionalShaaririk,
      "IsOptionalOther": _isOptionalOther,
      "Remark": _remarkCtrl.text.trim() == "" ? null : _remarkCtrl.text,
      "ModifiedBy": Statics.userDetails["userID"],
      "appuserid": Statics.userDetails["userID"],
    };

    final _data = await OfflineDataApiRepo.saveWithFallback(
      masterTableName: '${widget.isNew ? "Vistar" : ""}ShaakhaVruttaMaster',
      draftTableName: 'VruttaDraftMaster',
      keyColumns: ['ShaakhaaID', 'VruttaDate'],
      loadedSource: _loadedSource!,
      formData: inputData,
      saveToApi: () async => await Statics.saveShaakhaaSaptahVruttaData(context, inputData),
    );
    // var data = await Statics.saveShaakhaaVruttaForApp(json.encode(inputData));

    if (_data.outcome == DraftSaveOutcome.savedToDraftOffline) {
      // Blocked AT LOAD TIME, per your condition 2.2.1 — before any editing starts.
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text(Statics.getLabel("alert")),
              content: Text(Statics.getLabel("uploadedToDraft")),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(Statics.getLabel("okay"))),
              ],
            ),
          );
        },
      );
      // _isFormViewOnly = true;
      // setState(() {});
      // return;
    }

    setState(() {});
    if (_data.data?["Status"] == "Success" || _data.outcome == DraftSaveOutcome.savedToDraftOffline) {
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      if (userLevelId != 1) Navigator.of(context).pop();
    } else {
      Statics.showToast(Statics.getLabel('unableToSaveData'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(
                Statics.getLabel('Vrutta'),
                style: TextStyle(fontSize: 24),
              ),
            )
          : null,
      body: ModalProgressHUD(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              width: Statics.getDeviceSize(context).width,
              child: AbsorbPointer(
                absorbing: _isFormViewOnly || widget.viewType == "ViewMenu",
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Row(
                      children: [
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.7,
                          child: TextFormField(
                            readOnly: true,
                            controller: _vruttaDateCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('VruttaDate')),
                            textInputAction: TextInputAction.done,
                            onTap: _pickFromDate,
                            validator: (value) {
                              if (value!.isEmpty) return (Statics.getLabel('VruttaDateValidationMessage'));
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          color: Colors.purple,
                          icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                          onPressed: _pickFromDate,
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('ShishuCount') + " " + Statics.getLabel('ShishuCountRange'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: numTextField(
                            controller: _shishuCtrl,
                            labelText: Statics.getLabel('Total'),
                            onSaved: (value) {
                              vrutta?.shishuCount = value == "" ? null : int.parse(value!);
                            },
                          ),
                        ),
                        Expanded(
                          child: numTextField(
                            readOnly: _shishuCtrl.text.isEmpty || _shishuCtrl.text == "0",
                            controller: _newshishuCtrl,
                            expectedController: _shishuCtrl,
                            labelText: Statics.getLabel('newAdmission'),
                            onSaved: (value) {
                              vrutta?.newShishuCount = value == "" ? null : int.parse(value!);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('BaalCount') + " " + Statics.getLabel('BaalCountRange'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(spacing: 12, children: [
                      Expanded(
                        child: numTextField(
                          controller: _baalCtrl,
                          labelText: Statics.getLabel('Total'),
                          onSaved: (value) {
                            vrutta?.baalVidyaarthiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: numTextField(
                          readOnly: _baalCtrl.text.isEmpty || _baalCtrl.text == "0",
                          controller: _newbaalCtrl,
                          expectedController: _baalCtrl,
                          labelText: Statics.getLabel('newAdmission'),
                          onSaved: (value) {
                            vrutta?.newBaalVidyaarthiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                    ]),
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('TarunVidyaarthiCount') + " " + Statics.getLabel('TarunVidyaarthiCountRange'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(spacing: 12, children: [
                      Expanded(
                        child: numTextField(
                          controller: _tarunVidhyaarthiCtrl,
                          labelText: Statics.getLabel('Total'),
                          onSaved: (value) {
                            vrutta?.tarunVidyaarthiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: numTextField(
                          readOnly: _tarunVidhyaarthiCtrl.text.isEmpty || _tarunVidhyaarthiCtrl.text == "0",
                          controller: _newtarunVidhyaarthiCtrl,
                          expectedController: _tarunVidhyaarthiCtrl,
                          labelText: Statics.getLabel('newAdmission'),
                          onSaved: (value) {
                            vrutta?.newTarunVidyaarthiCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                    ]),
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('TarunVyavasaayeeCount') + " " + Statics.getLabel('TarunVyavasaayeeCountRange'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(spacing: 12, children: [
                      Expanded(
                        child: numTextField(
                          controller: _tarunVyavsaayeeCtrl,
                          labelText: Statics.getLabel('Total'),
                          onSaved: (value) {
                            vrutta?.tarunVyavasaayeeCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: numTextField(
                          readOnly: _tarunVyavsaayeeCtrl.text.isEmpty || _tarunVyavsaayeeCtrl.text == "0",
                          controller: _newtarunVyavsaayeeCtrl,
                          expectedController: _tarunVyavsaayeeCtrl,
                          labelText: Statics.getLabel('newAdmission'),
                          onSaved: (value) {
                            vrutta?.newTarunVyavasaayeeCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                    ]),
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('ProudhaCount') + " " + Statics.getLabel('ProudhaCountRange'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(spacing: 12, children: [
                      Expanded(
                        child: numTextField(
                          controller: _proudhaCtrl,
                          labelText: Statics.getLabel('Total'),
                          onSaved: (value) {
                            vrutta?.proudhaVyavasaayeeCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: numTextField(
                          readOnly: _proudhaCtrl.text.isEmpty || _proudhaCtrl.text == "0",
                          controller: _newproudhaCtrl,
                          expectedController: _proudhaCtrl,
                          labelText: Statics.getLabel('newAdmission'),
                          onSaved: (value) {
                            vrutta?.newProudhaVyavasaayeeCount = value == "" ? null : int.parse(value!);
                          },
                        ),
                      ),
                    ]),
                    if (_frequency.isNotEmpty && _frequency.firstWhere((e) => e.staticID == frequencyId).code == "Monthly") ...[
                      SizedBox(height: 14),
                      Text(
                        Statics.getLabel('MatrushaktiCount'),
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      SizedBox(height: 8),
                      Row(spacing: 12, children: [
                        Expanded(
                          child: numTextField(
                            controller: _matrushaktiCtrl,
                            labelText: Statics.getLabel('Total'),
                            onSaved: (value) {
                              vrutta?.matruskatiCount = value == "" ? null : int.parse(value!);
                            },
                          ),
                        ),
                        Expanded(
                          child: numTextField(
                            readOnly: _matrushaktiCtrl.text.isEmpty || _matrushaktiCtrl.text == "0",
                            controller: _newmatrushaktiCtrl,
                            expectedController: _matrushaktiCtrl,
                            labelText: Statics.getLabel('newAdmission'),
                            onSaved: (value) {
                              vrutta?.newmatruskatiCount = value == "" ? null : int.parse(value!);
                            },
                          ),
                        ),
                      ])
                    ],
                    SizedBox(height: 14),
                    Text(
                      Statics.getLabel('TotalCountLabel'),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    Row(spacing: 12, children: [
                      Expanded(
                        child: numTextField(
                          readOnly: true,
                          fillColor: Colors.grey.shade300,
                          controller: TextEditingController(
                              text: ((int.tryParse(_shishuCtrl.text) ?? 0) +
                                      (int.tryParse(_baalCtrl.text) ?? 0) +
                                      (int.tryParse(_tarunVidhyaarthiCtrl.text) ?? 0) +
                                      (int.tryParse(_tarunVyavsaayeeCtrl.text) ?? 0) +
                                      (int.tryParse(_proudhaCtrl.text) ?? 0) +
                                      (int.tryParse(_matrushaktiCtrl.text) ?? 0))
                                  .toString()),
                          labelText: Statics.getLabel('Total'),
                          onChanged: (value) => setState(() => vrutta?.totalCount = value == "" ? null : int.parse(value!)),
                        ),
                      ),
                      Expanded(
                        child: numTextField(
                          readOnly: true,
                          fillColor: Colors.grey.shade300,
                          controller: TextEditingController(
                              text: ((int.tryParse(_newshishuCtrl.text) ?? 0) +
                                      (int.tryParse(_newbaalCtrl.text) ?? 0) +
                                      (int.tryParse(_newtarunVidhyaarthiCtrl.text) ?? 0) +
                                      (int.tryParse(_newtarunVyavsaayeeCtrl.text) ?? 0) +
                                      (int.tryParse(_newproudhaCtrl.text) ?? 0) +
                                      (int.tryParse(_newmatrushaktiCtrl.text) ?? 0))
                                  .toString()),
                          labelText: Statics.getLabel('TotalNewAddCountLabel'),
                          onChanged: (value) => setState(() => vrutta?.newtotalCount = value == "" ? null : int.parse(value!)),
                        ),
                      ),
                    ]),
                    SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _abhyaagatCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('AbhyaagatCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta?.abhyaagatCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _pravasiKaryakartaCountCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('PravasiKaryakartaCount2')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta?.abhyaagatCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(height: 10),
                    /*TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _anyaPravasiKaryakartaCountCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('AnyaPravasiKaryakartaCount')),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        vrutta?.abhyaagatCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                    SizedBox(height: 10),*/
                    if (_frequency.isNotEmpty && _frequency.firstWhere((e) => e.staticID == frequencyId).code != "Monthly") ...[
                      if (vayogatCode == "Proudh Vyavasaayee")
                        Column(
                          children: [
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.8,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(Statics.getLabel("Minimum5minutesDeepBreathing"), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _isDoneDeepBreathing,
                                onChanged: (value) {
                                  setState(() {
                                    _isDoneDeepBreathing = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        )
                      else if (vayogatCode == "Baal")
                        Column(
                          children: [
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.8,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(Statics.getLabel("Minimum5minutesUrdhvapad"), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _isDoneUrdhvapad,
                                onChanged: (value) {
                                  setState(() {
                                    _isDoneUrdhvapad = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        )
                      else
                        Column(
                          children: [
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.8,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(Statics.getLabel("Minimum1minuteDandaPrahaar"), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _isDoneDandaPrahaar,
                                onChanged: (value) {
                                  setState(() {
                                    _isDoneDandaPrahaar = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.8,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(Statics.getLabel("Minimum5minutesSooryaNamaskaar"), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _isDoneSooryaNamaskaar,
                                onChanged: (value) {
                                  setState(() {
                                    _isDoneSooryaNamaskaar = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.8,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(Statics.getLabel("Minimum5minutesSanchalanAbhyaas"), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _isDoneSanchalanAbhyaas,
                                onChanged: (value) {
                                  setState(() {
                                    _isDoneSanchalanAbhyaas = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("SaanghikGeet"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isDoneSaanghikGeet,
                          onChanged: (value) {
                            setState(() {
                              _isDoneSaanghikGeet = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("AmrutaVachan"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isDoneAmrutaVachan,
                          onChanged: (value) {
                            setState(() {
                              _isDoneAmrutaVachan = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("Subhaashit"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isDoneSubhaashit,
                          onChanged: (value) {
                            setState(() {
                              _isDoneSubhaashit = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("BoodhKathaOnceWeek"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isDoneBoodhKatha,
                          onChanged: (value) {
                            setState(() {
                              _isDoneBoodhKatha = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("BoudhikDays"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isDoneBoudhikDays,
                          onChanged: (value) {
                            setState(() {
                              _isDoneBoudhikDays = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_isDoneBoudhikDays) ...[
                        buildDropdownField(
                          label: Statics.getLabel('BoudhikDays'),
                          value: _selectedBoudhikDaysId,
                          items: _boudhikDaysList
                              .map((bg) => DropdownMenuItem(
                                    value: bg?.staticID.toString(),
                                    child: Text(bg?.codeForDisplay ?? "--"),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBoudhikDaysId = value;
                            });
                            print(_selectedBoudhikDaysId);
                            print(_boudhikDaysList.firstWhere((e) => e?.codeForDisplay == Statics.getLabel("anyaOption"))?.staticID);
                            print(_selectedBoudhikDaysId == _boudhikDaysList.firstWhere((e) => e?.codeForDisplay == Statics.getLabel("anyaOption"))?.staticID.toString());
                          },
                        ),
                        SizedBox(height: 10),
                        if (_selectedBoudhikDaysId == _boudhikDaysList.firstWhere((e) => e?.codeForDisplay == Statics.getLabel("anyaOption"))?.staticID.toString())
                          TextFormField(
                            controller: _anyaBoudhikDaysCtrl,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => setState(() {}),
                            decoration: InputDecoration(
                              labelText: Statics.getLabel("anyaOption"),
                              labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
                              // fillColor: Colors.grey.shade50,
                              // filled: true,
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(8),
                              //   borderSide: BorderSide.none, // Hide default border
                              // ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Align left of field
                            ),
                            style: const TextStyle(color: Colors.black, fontSize: 14), // Original fields looked greyed out
                          ),
                      ],
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("SewaDays"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isDoneSewaDays,
                          onChanged: (value) {
                            setState(() {
                              _isDoneSewaDays = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_isDoneSewaDays) ...[
                        GroupedMultiSelectField<int>(
                          title: Statics.getLabel('SewaDays'),
                          buttonText: Statics.getLabel('SewaDays'),
                          confirmText: Statics.getLabel('Submit'),
                          cancelText: Statics.getLabel('clear'),
                          groupedItems: _sewaDaysGroup,
                          initialValue: _selectedSewaDaysList,
                          onConfirm: (values) => setState(() => _selectedSewaDaysList = values),
                        ),
                        SizedBox(height: 10),
                      ],
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("ConductedOptionalShaaririkVishay"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isOptionalShaaririk,
                          onChanged: (value) {
                            setState(() {
                              _isOptionalShaaririk = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("ConductedOtherOptionalKaaryakram"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isOptionalOther,
                          onChanged: (value) {
                            setState(() {
                              _isOptionalOther = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _remarkCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Remarks')),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        vrutta?.remark = value == "" ? null : value;
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: (_isLoading)
                          ? CircularProgressIndicator()
                          : (_isFormViewOnly || widget.viewType == "ViewMenu")
                              ? Text(Statics.getLabel('canNotMakeChanges'))
                              : MaterialButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                  onPressed: () {
                                    // return;
                                    _submit(context);
                                  },
                                  child: Text(
                                    Statics.getLabel('Submit'),
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                    )
                  ]),
                ),
              ),
            ),
          ),
          inAsyncCall: _isFetchingData),
    );
  }

  Widget numTextField({
    required TextEditingController controller,
    Color? fillColor,
    bool readOnly = false,
    TextEditingController? expectedController,
    required String labelText,
    void Function(String?)? onSaved,
    void Function(String?)? onChanged,
    String? Function(String?)? validator,
  }) {
    if (expectedController != null) {
      expectedController.addListener(() {
        final expected = int.tryParse(expectedController.text) ?? 0;
        final current = int.tryParse(controller.text) ?? 0;

        if (current > expected) {
          controller.clear(); // or controller.text = "0";
        }
      });
    }
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      readOnly: readOnly,
      onSaved: onSaved,
      validator: validator,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        if (expectedController != null)
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.isEmpty) return newValue;

            final int? aValue = int.tryParse(expectedController.text);
            final int? bValue = int.tryParse(newValue.text);

            if (aValue == null || bValue == null) return newValue;

            if (bValue > aValue) {
              return oldValue; // reject input
            }

            return newValue;
          }),
      ],
      onChanged: onChanged ?? (value) => setState(() {}),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
        fillColor: fillColor ?? Colors.grey.shade50,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Hide default border
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Align left of field
      ),
      style: const TextStyle(color: Colors.black, fontSize: 14), // Original fields looked greyed out
    );
  }
}
