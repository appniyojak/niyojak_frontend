// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import '../providers/bals.dart';
//
// import '../helpers/static_data.dart' as Statics;
//
// class EditAnnualBaithakShaakhaaVrutta extends StatefulWidget {
//   static const String routeName = '/edit-annual-baithak-shaakhaa-vrutta';
//   var annualBaithakShaakhaaVruttaID;
//   var geoUnitID;
//   var geoUnitName;
//   var annualBaithakTypeID;
//   var annualBaithakTypeCode;
//   var onSaveDetails;
//   var viewType;
//   var locId;
//   var loctype;
//   EditAnnualBaithakShaakhaaVrutta(
//       {Key? key,
//       this.annualBaithakShaakhaaVruttaID,
//       this.geoUnitID,
//       this.geoUnitName,
//       this.annualBaithakTypeID,
//       this.annualBaithakTypeCode,
//       this.onSaveDetails,
//       this.viewType,
//       this.locId,
//       this.loctype,
//       })
//       : super(key: key);
//   @override
//   _EditAnnualBaithakShaakhaaVruttaState createState() => _EditAnnualBaithakShaakhaaVruttaState();
// }
//
// class _EditAnnualBaithakShaakhaaVruttaState extends State<EditAnnualBaithakShaakhaaVrutta> {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//
//   var _isLoading = false;
//
//   bool _isFetchingData = false;
//
//   AnnualBaithakShaakhaaVruttaBAL? shaakhaaVrutta;
//
//   var _conductingDaysCtrl = TextEditingController();
//   var _baalAvgCntrl = TextEditingController();
//   var _vidyaarthiAvgCtrl = TextEditingController();
//   var _vyavasaayeeAvgCtrl = TextEditingController();
//   var _proudhAvgCtrl = TextEditingController();
//   var _sewaVastiSamparkCountCtrl = TextEditingController();
//   var _sewaUpakramCountCtrl = TextEditingController();
//   var _anyaUpakramCountCtrl = TextEditingController();
//   var _praathamikCountCtrl = TextEditingController();
//   var _praathamikSakriyaCountCtrl = TextEditingController();
//   var _prathamGeneralCountCtrl = TextEditingController();
//   var _prathamGeneralSakriyaCountCtrl = TextEditingController();
//   var _prathamSpecialCountCtrl = TextEditingController();
//   var _prathamSpecialSakriyaCountCtrl = TextEditingController();
//   var _dwitiyaGeneralCountCtrl = TextEditingController();
//   var _dwitiyaGeneralSakriyaCountCtrl = TextEditingController();
//   var _dwitiyaSpecialCountCtrl = TextEditingController();
//   var _dwitiyaSpecialSakriyaCountCtrl = TextEditingController();
//   var _trutiyaGeneralCountCtrl = TextEditingController();
//   var _trutiyaGeneralSakriyaCountCtrl = TextEditingController();
//   var _trutiyaSpecialCountCtrl = TextEditingController();
//   var _trutiyaSpecialSakriyaCountCtrl = TextEditingController();
//   var _patSankhyaaCtrl = TextEditingController();
//   var _sanghaDaayitvawaanSwCountCtrl = TextEditingController();
//   var _preritSansthaaSangathanDaayitvawaanSwCountCtrl = TextEditingController();
//   var _gatividhiDaayitvawaanSwCountCtrl = TextEditingController();
//   var _aayaamDaayitvawaanSwCountCtrl = TextEditingController();
//   var _sociallyActiveSwCountCtrl = TextEditingController();
//   var _shishuAverageCtrl = TextEditingController();
//   var _shaakhaaToliBaithakCountCtrl = TextEditingController();
//   var _vaartaapatraCountCtrl = TextEditingController();
//   int? _baithakTypeID;
//   String? _vaarshikotsavMonthValue;
//   int? _isActive ;
//   bool _isSewaVastiDefined = false;
//   bool _isSewaKaaryakartaaDefined = false;
//   bool _isShaakhaaToli = false;
//   bool _isShaakhaaPaalak = false;
//   bool _isVaarshikNiyojanDone = false;
//
//   @override
//   void initState() {
//     super.initState();
//     int abShaakhaaVruttaID = (widget.annualBaithakShaakhaaVruttaID == null ? 0 : (widget.annualBaithakShaakhaaVruttaID as int));
//     int geoUnitID = (widget.geoUnitID as int);
//     String geoUnitName = widget.geoUnitName.toString();
//     int baithakTypeID = (widget.annualBaithakTypeID as int);
//     String baithakTypeCode = widget.annualBaithakTypeCode.toString();
//     populateAnnualBaithakShaakhaaVrutta(baithakTypeID, geoUnitID);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _conductingDaysCtrl.dispose();
//     _baalAvgCntrl.dispose();
//     _vidyaarthiAvgCtrl.dispose();
//     _vyavasaayeeAvgCtrl.dispose();
//     _proudhAvgCtrl.dispose();
//     _sewaVastiSamparkCountCtrl.dispose();
//     _sewaUpakramCountCtrl.dispose();
//     _anyaUpakramCountCtrl.dispose();
//     _praathamikCountCtrl.dispose();
//     _praathamikSakriyaCountCtrl.dispose();
//     _prathamGeneralCountCtrl.dispose();
//     _prathamGeneralSakriyaCountCtrl.dispose();
//     _prathamSpecialCountCtrl.dispose();
//     _prathamSpecialSakriyaCountCtrl.dispose();
//     _dwitiyaGeneralCountCtrl.dispose();
//     _dwitiyaGeneralSakriyaCountCtrl.dispose();
//     _dwitiyaSpecialCountCtrl.dispose();
//     _dwitiyaSpecialSakriyaCountCtrl.dispose();
//     _trutiyaGeneralCountCtrl.dispose();
//     _trutiyaGeneralSakriyaCountCtrl.dispose();
//     _trutiyaSpecialCountCtrl.dispose();
//     _trutiyaSpecialSakriyaCountCtrl.dispose();
//     _patSankhyaaCtrl.dispose();
//     _sanghaDaayitvawaanSwCountCtrl.dispose();
//     _preritSansthaaSangathanDaayitvawaanSwCountCtrl.dispose();
//     _gatividhiDaayitvawaanSwCountCtrl.dispose();
//     _aayaamDaayitvawaanSwCountCtrl.dispose();
//     _sociallyActiveSwCountCtrl.dispose();
//     _shishuAverageCtrl.dispose();
//     _shaakhaaToliBaithakCountCtrl.dispose();
//     _vaartaapatraCountCtrl.dispose();
//   }
//
//   void populateAnnualBaithakShaakhaaVrutta(int btID, int guID) async {
//     setState(() {
//       _isFetchingData = true;
//     });
//     dynamic retVal;
//     bool isConnected = await Statics.isInternetConnected();
//     if (isConnected) {
//       String strInput = json.encode({
//         "AppUserID": Statics.userDetails['userID'],
//         "ShaharID": null,
//         "NagarID": null,
//         "AnnualBaithakTypeID": btID,
//         "GeoUnitID": guID,
//         "LocId": "0",
//         "type":"old",
//         // "LocId": widget.locId,
//         // "type":widget.loctype,
//       });
//       print("strInput --> $strInput   ");
//       retVal = (await Statics.getAnnualBaithakShaakhaaVruttaForApp(strInput)).firstWhere(  (item) => item["AnnualBaithakShaakhaaVruttaID"] == widget.annualBaithakShaakhaaVruttaID &&
//           item["GeoUnitID"] == widget.geoUnitID,orElse: () => null, );
//       //return retVal['ListShaakhaaVrutta'];
//
//       log("retVal ---- >  ${jsonEncode(retVal)}");
//       setState(() {
//         shaakhaaVrutta = AnnualBaithakShaakhaaVruttaBAL.fromMap(retVal);
//         _baithakTypeID = btID;
//         _isActive = shaakhaaVrutta?.isSadhyaSuruAahe;
//         _conductingDaysCtrl.text = (shaakhaaVrutta!.conductingDayCount == null ? '' : shaakhaaVrutta!.conductingDayCount.toString());
//         _baalAvgCntrl.text = (shaakhaaVrutta!.baalAverage == null ? '' : shaakhaaVrutta!.baalAverage.toString());
//         _vidyaarthiAvgCtrl.text = (shaakhaaVrutta!.tarunVidyaarthiAverage == null ? '' : shaakhaaVrutta!.tarunVidyaarthiAverage.toString());
//         _vyavasaayeeAvgCtrl.text = (shaakhaaVrutta!.tarunVyavasaayeeAverage == null ? '' : shaakhaaVrutta!.tarunVyavasaayeeAverage.toString());
//         _proudhAvgCtrl.text = (shaakhaaVrutta!.proudhVyavasaayeeAverage == null ? '' : shaakhaaVrutta!.proudhVyavasaayeeAverage.toString());
//         _vaarshikotsavMonthValue = (shaakhaaVrutta!.vaarshikotsavMonth == null ? '' : shaakhaaVrutta!.vaarshikotsavMonth.toString());
//         _isSewaVastiDefined = shaakhaaVrutta!.isSewaVastiDefined == true ? true : false;
//         _sewaVastiSamparkCountCtrl.text = (shaakhaaVrutta!.sewaVastiSamparkCount == null ? '' : shaakhaaVrutta!.sewaVastiSamparkCount.toString());
//         _isSewaKaaryakartaaDefined = shaakhaaVrutta!.isSewaKaaryakartaaDefined == true ? true : false;
//         _sewaUpakramCountCtrl.text = (shaakhaaVrutta!.sewaUpakramCount == null ? '' : shaakhaaVrutta!.sewaUpakramCount.toString());
//         _anyaUpakramCountCtrl.text = (shaakhaaVrutta!.anyaUpakramCount == null ? '' : shaakhaaVrutta!.anyaUpakramCount.toString());
//         _praathamikCountCtrl.text = (shaakhaaVrutta!.praathamikCount == null ? '' : shaakhaaVrutta!.praathamikCount.toString());
//         _praathamikSakriyaCountCtrl.text = (shaakhaaVrutta!.praathamikSakriyaCount == null ? '' : shaakhaaVrutta!.praathamikSakriyaCount.toString());
//         _prathamGeneralCountCtrl.text = (shaakhaaVrutta!.prathamGeneralCount == null ? '' : shaakhaaVrutta!.prathamGeneralCount.toString());
//         _prathamGeneralSakriyaCountCtrl.text =
//             (shaakhaaVrutta!.prathamGeneralSakriyaCount == null ? '' : shaakhaaVrutta!.prathamGeneralSakriyaCount.toString());
//         _prathamSpecialCountCtrl.text = (shaakhaaVrutta!.prathamSpecialCount == null ? '' : shaakhaaVrutta!.prathamSpecialCount.toString());
//         _prathamSpecialSakriyaCountCtrl.text =
//             (shaakhaaVrutta!.prathamSpecialSakriyaCount == null ? '' : shaakhaaVrutta!.prathamSpecialSakriyaCount.toString());
//         _dwitiyaGeneralCountCtrl.text = (shaakhaaVrutta!.dwitiyaGeneralCount == null ? '' : shaakhaaVrutta!.dwitiyaGeneralCount.toString());
//         _dwitiyaGeneralSakriyaCountCtrl.text =
//             (shaakhaaVrutta!.dwitiyaGeneralSakriyaCount == null ? '' : shaakhaaVrutta!.dwitiyaGeneralSakriyaCount.toString());
//         _dwitiyaSpecialCountCtrl.text = (shaakhaaVrutta!.dwitiyaSpecialCount == null ? '' : shaakhaaVrutta!.dwitiyaSpecialCount.toString());
//         _dwitiyaSpecialSakriyaCountCtrl.text =
//             (shaakhaaVrutta!.dwitiyaSpecialSakriyaCount == null ? '' : shaakhaaVrutta!.dwitiyaSpecialSakriyaCount.toString());
//         _trutiyaGeneralCountCtrl.text = (shaakhaaVrutta!.trutiyaGeneralCount == null ? '' : shaakhaaVrutta!.trutiyaGeneralCount.toString());
//         _trutiyaGeneralSakriyaCountCtrl.text =
//             (shaakhaaVrutta!.trutiyaGeneralSakriyaCount == null ? '' : shaakhaaVrutta!.trutiyaGeneralSakriyaCount.toString());
//         _trutiyaSpecialCountCtrl.text = (shaakhaaVrutta!.trutiyaSpecialCount == null ? '' : shaakhaaVrutta!.trutiyaSpecialCount.toString());
//         _trutiyaSpecialSakriyaCountCtrl.text =
//             (shaakhaaVrutta!.trutiyaSpecialSakriyaCount == null ? '' : shaakhaaVrutta!.trutiyaSpecialSakriyaCount.toString());
//
//         _patSankhyaaCtrl.text = (shaakhaaVrutta!.patSankhyaa == null ? '' : shaakhaaVrutta!.patSankhyaa.toString());
//         _sanghaDaayitvawaanSwCountCtrl.text =
//             (shaakhaaVrutta!.sanghaDaayitvawaanSwCount == null ? '' : shaakhaaVrutta!.sanghaDaayitvawaanSwCount.toString());
//         _preritSansthaaSangathanDaayitvawaanSwCountCtrl.text = (shaakhaaVrutta!.preritSansthaaSangathanDaayitvawaanSwCount == null
//             ? ''
//             : shaakhaaVrutta!.preritSansthaaSangathanDaayitvawaanSwCount.toString());
//         _gatividhiDaayitvawaanSwCountCtrl.text =
//             (shaakhaaVrutta!.gatividhiDaayitvawaanSwCount == null ? '' : shaakhaaVrutta!.gatividhiDaayitvawaanSwCount.toString());
//         _aayaamDaayitvawaanSwCountCtrl.text =
//             (shaakhaaVrutta!.aayaamDaayitvawaanSwCount == null ? '' : shaakhaaVrutta!.aayaamDaayitvawaanSwCount.toString());
//         _sociallyActiveSwCountCtrl.text = (shaakhaaVrutta!.sociallyActiveSwCount == null ? '' : shaakhaaVrutta!.sociallyActiveSwCount.toString());
//         _shishuAverageCtrl.text = (shaakhaaVrutta!.shishuAverage == null ? '' : shaakhaaVrutta!.shishuAverage.toString());
//         _shaakhaaToliBaithakCountCtrl.text =
//             (shaakhaaVrutta!.shaakhaaToliBaithakCount == null ? '' : shaakhaaVrutta!.shaakhaaToliBaithakCount.toString());
//         _vaartaapatraCountCtrl.text = (shaakhaaVrutta!.vaartaapatraCount == null ? '' : shaakhaaVrutta!.vaartaapatraCount.toString());
//
//         _isShaakhaaToli = shaakhaaVrutta!.isShaakhaaToli == true ? true : false;
//         _isShaakhaaPaalak = shaakhaaVrutta!.isShaakhaaPaalak == true ? true : false;
//         _isVaarshikNiyojanDone = shaakhaaVrutta!.isVaarshikNiyojanDone == true ? true : false;
//
//         _isFetchingData = false;
//       });
//     } else {
//       Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
//       //return null;
//     }
//   }
//
//   Future<void> _submit(BuildContext context) async {
//     if (!_formKey.currentState!.validate()) {
//       // Invalid!
//       return;
//     }
//     _formKey.currentState!.save();
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       bool isConnected = await Statics.isInternetConnected();
//       if (!isConnected) {
//         Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
//       } else {
//         await saveAnnualBaithakShaakhaaVrutta(context);
//       }
//     } on Exception catch (error) {
//       Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
//     } catch (error) {
//       Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   saveAnnualBaithakShaakhaaVrutta(BuildContext context) async {
//     var inputData = json.encode({
//       "AppUserID": Statics.userDetails["userID"],
//       "IsSadhyaSuruAahe": _isActive,
//       "AnnualBaithakShaakhaaVruttaID":
//           (widget.annualBaithakShaakhaaVruttaID == null ? 0 : int.parse(widget.annualBaithakShaakhaaVruttaID.toString())),
//       "GeoUnitID": (widget.geoUnitID == null ? 0 : int.parse(widget.geoUnitID.toString())),
//       "AnnualBaithakTypeID": (widget.annualBaithakTypeID == null ? 0 : int.parse(widget.annualBaithakTypeID.toString())),
//       "ConductingDayCount": _conductingDaysCtrl.text.trim() == '' ? null : int.parse(_conductingDaysCtrl.text),
//       "BaalAverage": _baalAvgCntrl.text.trim() == '' ? null : int.parse(_baalAvgCntrl.text),
//       "TarunVidyaarthiAverage": _vidyaarthiAvgCtrl.text.trim() == '' ? null : int.parse(_vidyaarthiAvgCtrl.text),
//       "TarunVyavasaayeeAverage": _vyavasaayeeAvgCtrl.text.trim() == '' ? null : int.parse(_vyavasaayeeAvgCtrl.text),
//       "ProudhaVyavasaayeeAverage": _proudhAvgCtrl.text.trim() == '' ? null : int.parse(_proudhAvgCtrl.text),
//       "VaarshikotsavMonth": shaakhaaVrutta!.vaarshikotsavMonth,
//       "IsSewaVastiDefined": _isSewaVastiDefined,
//       "SewaVastiSamparkCount": _sewaVastiSamparkCountCtrl.text.trim() == '' ? null : int.parse(_sewaVastiSamparkCountCtrl.text),
//       "IsSewaKaaryakartaaDefined": _isSewaKaaryakartaaDefined,
//       "SewaUpakramCount": _sewaUpakramCountCtrl.text.trim() == '' ? null : int.parse(_sewaUpakramCountCtrl.text),
//       "AnyaUpakramCount": _anyaUpakramCountCtrl.text.trim() == '' ? null : int.parse(_anyaUpakramCountCtrl.text),
//       "PraathamikCount": _praathamikCountCtrl.text.trim() == '' ? null : int.parse(_praathamikCountCtrl.text),
//       "PraathamikSakriyaCount": _praathamikSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_praathamikSakriyaCountCtrl.text),
//       "PrathamGeneralCount": _prathamGeneralCountCtrl.text.trim() == '' ? null : int.parse(_prathamGeneralCountCtrl.text),
//       "PrathamGeneralSakriyaCount": _prathamGeneralSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_prathamGeneralSakriyaCountCtrl.text),
//       "PrathamSpecialCount": _prathamSpecialCountCtrl.text.trim() == '' ? null : int.parse(_prathamSpecialCountCtrl.text),
//       "PrathamSpecialSakriyaCount": _prathamSpecialSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_prathamSpecialSakriyaCountCtrl.text),
//       "DwitiyaGeneralCount": _dwitiyaGeneralCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaGeneralCountCtrl.text),
//       "DwitiyaGeneralSakriyaCount": _dwitiyaGeneralSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaGeneralSakriyaCountCtrl.text),
//       "DwitiyaSpecialCount": _dwitiyaSpecialCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaSpecialCountCtrl.text),
//       "DwitiyaSpecialSakriyaCount": _dwitiyaSpecialSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaSpecialSakriyaCountCtrl.text),
//       "TrutiyaGeneralCount": _trutiyaGeneralCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaGeneralCountCtrl.text),
//       "TrutiyaGeneralSakriyaCount": _trutiyaGeneralSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaGeneralSakriyaCountCtrl.text),
//       "TrutiyaSpecialCount": _trutiyaSpecialCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaSpecialCountCtrl.text),
//       "TrutiyaSpecialSakriyaCount": _trutiyaSpecialSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaSpecialSakriyaCountCtrl.text),
//       "PatSankhyaa": _patSankhyaaCtrl.text.trim() == '' ? null : int.parse(_patSankhyaaCtrl.text),
//       "SanghaDaayitvawaanSwCount": _sanghaDaayitvawaanSwCountCtrl.text.trim() == '' ? null : int.parse(_sanghaDaayitvawaanSwCountCtrl.text),
//       "PreritSansthaaSangathanDaayitvawaanSwCount":
//           _preritSansthaaSangathanDaayitvawaanSwCountCtrl.text.trim() == '' ? null : int.parse(_preritSansthaaSangathanDaayitvawaanSwCountCtrl.text),
//       "GatividhiDaayitvawaanSwCount": _gatividhiDaayitvawaanSwCountCtrl.text.trim() == '' ? null : int.parse(_gatividhiDaayitvawaanSwCountCtrl.text),
//       "AayaamDaayitvawaanSwCount": _aayaamDaayitvawaanSwCountCtrl.text.trim() == '' ? null : int.parse(_aayaamDaayitvawaanSwCountCtrl.text),
//       "SociallyActiveSwCount": _sociallyActiveSwCountCtrl.text.trim() == '' ? null : int.parse(_sociallyActiveSwCountCtrl.text),
//       "ShishuAverage": _shishuAverageCtrl.text.trim() == '' ? null : int.parse(_shishuAverageCtrl.text),
//       "ShaakhaaToliBaithakCount": _shaakhaaToliBaithakCountCtrl.text.trim() == '' ? null : int.parse(_shaakhaaToliBaithakCountCtrl.text),
//       "VaartaapatraCount": _vaartaapatraCountCtrl.text.trim() == '' ? null : int.parse(_vaartaapatraCountCtrl.text),
//       "IsShaakhaaToli": _isShaakhaaToli,
//       "IsShaakhaaPaalak": _isShaakhaaPaalak,
//       "IsVaarshikNiyojanDone": _isVaarshikNiyojanDone,
//       "ModifiedBy": Statics.userDetails["userID"]
//     });
//     log("saveAnnualBaithakShaakhaaVrutta :--${inputData}");
//     var oID = await Statics.saveAnnualBaithakShaakhaaVruttaForApp(inputData);
//     setState(() {
//       widget.annualBaithakShaakhaaVruttaID = oID;
//       widget.onSaveDetails();
//       Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
//       Navigator.of(context).pop();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           Statics.getLabel('annualBaithakShaakhaaVruttaTitle'),
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: _isFetchingData,
//         child: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(20),
//             width: Statics.getDeviceSize(context).width,
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: <Widget>[
//                   Text(shaakhaaVrutta == null
//                       ? ''
//                       : (shaakhaaVrutta!.geoUnitName! + ', (' + shaakhaaVrutta!.vayogatCode! + ', ' + shaakhaaVrutta!.frequencyCode! + ')')),
//                   Text(shaakhaaVrutta == null ? '' : shaakhaaVrutta!.annualBaithakTypeCode!),
//                   // SizedBox(
//                   //   width: Statics.getDeviceSize(context).width * 0.8,
//                   //   child: CheckboxListTile(
//                   //     contentPadding: EdgeInsets.symmetric(horizontal: 0),
//                   //     controlAffinity: ListTileControlAffinity.trailing,
//                   //     title: Text(Statics.getLabel('Currentlyrunning'), style: TextStyle(fontSize: 15)),
//                   //     checkColor: Colors.white,
//                   //     activeColor: Colors.purple,
//                   //     value: _isActive,
//                   //     onChanged: (value) {
//                   //       setState(() {
//                   //         _isActive = value!;
//                   //       });
//                   //     },
//                   //   ),
//                   // ),
//                   SizedBox(height: 20,),
//                   // DropdownButtonFormField<bool>(
//                   //     decoration: InputDecoration(
//                   //       labelText: Statics.getLabel('Currentlyrunning'),
//                   //       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   //     ),
//                   //     value: _isActive,
//                   //     items: [
//                   //       DropdownMenuItem(
//                   //         value: true,
//                   //         child: Text(Statics.getLabel('ConfirmationYes')),
//                   //       ),
//                   //       DropdownMenuItem(
//                   //         value: false,
//                   //         child: Text(Statics.getLabel('ConfirmationNo')),
//                   //       ),
//                   //     ],
//                   //     onChanged: (value) {
//                   //       setState(() {
//                   //         _isActive = value!;
//                   //       });
//                   //     },
//                   //   ),
//                   DropdownButtonFormField<int>(
//                     decoration: InputDecoration(
//                       labelText: Statics.getLabel('Currentlyrunning'),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     ),
//                     value: _isActive,
//                     items: [
//                       DropdownMenuItem(
//                         value: 1,
//                         child: Text(Statics.getLabel('ConfirmationYes')),
//                       ),
//                       DropdownMenuItem(
//                         value: 0,
//                         child: Text(Statics.getLabel('ConfirmationNo')),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         _isActive = value!;
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 20,),
//                   TextFormField(
//                     textInputAction: TextInputAction.next,
//                     controller: _conductingDaysCtrl,
//                     decoration: InputDecoration(labelText: Statics.getLabel('conductingDayCount')),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return Statics.getLabel('mandatoryInformation');
//                       }
//                       final int? conductingDays = int.tryParse(value);
//                       if (conductingDays == null || conductingDays < 0 || conductingDays > 30) {
//                         return Statics.getLabel('fillNumber');
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       shaakhaaVrutta!.conductingDayCount = value == "" ? null : int.parse(value!);
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     textInputAction: TextInputAction.next,
//                     controller: _shishuAverageCtrl,
//                     decoration: InputDecoration(labelText: Statics.getLabel('shishuAvg')),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
//                       return null;
//                     },
//                     onSaved: (value) {
//                       shaakhaaVrutta!.shishuAverage = value == "" ? 0 : int.parse(value!);
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     textInputAction: TextInputAction.next,
//                     controller: _baalAvgCntrl,
//                     decoration: InputDecoration(labelText: Statics.getLabel('baalAvg')),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
//                       return null;
//                     },
//                     onSaved: (value) {
//                       shaakhaaVrutta!.baalAverage = value == "" ? null : int.parse(value!);
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     textInputAction: TextInputAction.next,
//                     controller: _vidyaarthiAvgCtrl,
//                     decoration: InputDecoration(labelText: Statics.getLabel('tarunVidyaarthiAvg')),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
//                       return null;
//                     },
//                     onSaved: (value) {
//                       shaakhaaVrutta!.tarunVidyaarthiAverage = value == "" ? null : int.parse(value!);
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     textInputAction: TextInputAction.next,
//                     controller: _vyavasaayeeAvgCtrl,
//                     decoration: InputDecoration(labelText: Statics.getLabel('tarunVyavasaayeeAvg')),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
//                       return null;
//                     },
//                     onSaved: (value) {
//                       shaakhaaVrutta!.tarunVyavasaayeeAverage = value == "" ? null : int.parse(value!);
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     textInputAction: TextInputAction.next,
//                     controller: _proudhAvgCtrl,
//                     decoration: InputDecoration(labelText: Statics.getLabel('proudhAvg')),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
//                       return null;
//                     },
//                     onSaved: (value) {
//                       shaakhaaVrutta!.proudhVyavasaayeeAverage = value == "" ? null : int.parse(value!);
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   DropdownButtonFormField(
//                     decoration: InputDecoration(
//                         labelText: (_baithakTypeID == Statics.abPratinidhiSabhaa
//                             ? Statics.getLabel('vaarshikotsavMonth')
//                             : (_baithakTypeID == Statics.praantikBaithak1
//                                 ? Statics.getLabel('vaarshikotsavMonthFebMar')
//                                 : Statics.getLabel('vaarshikotsavMonthMarJun')))),
//                     isExpanded: true,
//                     value: _vaarshikotsavMonthValue == '' ? null : _vaarshikotsavMonthValue,
//                     items: Statics.vaarshikotsavMonths.entries
//                         .map((entry) => DropdownMenuItem(value: entry.key, child: Text(Statics.getLabel(entry.value))))
//                         .toList(),
//                     onChanged: (value) {
//                       print(value);
//                       setState(() {
//                         _vaarshikotsavMonthValue = value;
//                       });
//                     },
//                     validator: (value) {
//                       if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
//                       return null;
//                     },
//                     onSaved: (value) {
//                       if (value != null && value.isNotEmpty)
//                         shaakhaaVrutta!.vaarshikotsavMonth = int.parse(value);
//                       else
//                         shaakhaaVrutta!.vaarshikotsavMonth = null;
//                     },
//                   ),
//
//                   SizedBox(height: 10,),
//                   // if(_isSewaVastiDefined == true )
//                   if( shaakhaaVrutta?.frequencyID.toString() == '35'|| shaakhaaVrutta?.frequencyID.toString() == '34')
//                     if(shaakhaaVrutta?.vayogatID.toString() == '39'||shaakhaaVrutta?.vayogatID.toString() == '40' )
//                         SizedBox(
//                       width: Statics.getDeviceSize(context).width * 0.8,
//                       child: CheckboxListTile(
//                         contentPadding: EdgeInsets.symmetric(horizontal: 0),
//                         controlAffinity: ListTileControlAffinity.trailing,
//                         title: Text(Statics.getLabel("isSewaVastiDefined"), style: TextStyle(fontSize: 15)),
//                         checkColor: Colors.white,
//                         activeColor: Colors.purple,
//                         value: _isSewaVastiDefined,
//                         onChanged: (value) {
//                           setState(() {
//                             print("_isSewaVastiDefined $_isSewaVastiDefined");
//                             _isSewaVastiDefined = value!;
//                           });
//                         },
//                       ),
//                     ),
//
//                   SizedBox(
//                     height: 10,
//                   ),
//                   // Text("shaakhaaVrutta?.frequencyID ==> ${shaakhaaVrutta?.frequencyID}\n shaakhaaVrutta?.vayogatID ${shaakhaaVrutta?.vayogatID} "),
//
//                   // if(_isSewaVastiDefined == true )
//                   if( shaakhaaVrutta?.frequencyID.toString() == '35'|| shaakhaaVrutta?.frequencyID.toString() == '34')
//                     if(shaakhaaVrutta?.vayogatID.toString() == '39'||shaakhaaVrutta?.vayogatID.toString() == '40' )
//                       TextFormField(
//                       textInputAction: TextInputAction.next,
//                       controller: _sewaVastiSamparkCountCtrl,
//                       decoration: InputDecoration(
//                           labelText: (_baithakTypeID == Statics.abPratinidhiSabhaa
//                               ? Statics.getLabel('sewaVastiSamparkCount')
//                               : (_baithakTypeID == Statics.praantikBaithak1
//                                   ? Statics.getLabel('sewaVastiSamparkCountFebMar')
//                                   : Statics.getLabel('sewaVastiSamparkCount')))),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return Statics.getLabel('mandatoryInformation');
//                         }
//                         final int? conductingDays = int.tryParse(value);
//                         if (conductingDays == null || conductingDays < 0 || conductingDays > 30) {
//                           return Statics.getLabel('fillNumber');
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         shaakhaaVrutta!.sewaVastiSamparkCount = value == "" ? null : int.parse(value!);
//                       },
//                     ),
//                   SizedBox(height: 10,),
//                   // if(shaakhaaVrutta != null)
//                   if( shaakhaaVrutta?.frequencyID.toString() == '35'|| shaakhaaVrutta?.frequencyID.toString() == '34')
//                     if(shaakhaaVrutta?.vayogatID.toString() == '39'||shaakhaaVrutta?.vayogatID.toString() == '40' )
//                  SizedBox(
//                       width: Statics.getDeviceSize(context).width * 0.8,
//                       child: CheckboxListTile(
//                         contentPadding: EdgeInsets.symmetric(horizontal: 0),
//                         controlAffinity: ListTileControlAffinity.trailing,
//                         title: Text(Statics.getLabel("isSewaKaaryakartaaDefined"), style: TextStyle(fontSize: 15)),
//                         checkColor: Colors.white,
//                         activeColor: Colors.purple,
//                         value: _isSewaKaaryakartaaDefined,
//                         onChanged: (value) {
//                           setState(() {
//                             _isSewaKaaryakartaaDefined = value!;
//                           });
//                         },
//                       ),
//                     ),
//
//                   SizedBox(
//                     height: 10,
//                   ),
//                TextFormField(
//                     textInputAction: TextInputAction.next,
//                     controller: _sewaUpakramCountCtrl,
//                     decoration: InputDecoration(
//                         labelText: (_baithakTypeID == Statics.abPratinidhiSabhaa
//                             ? Statics.getLabel('sewaUpakramCount')
//                             : (_baithakTypeID == Statics.praantikBaithak1
//                                 ? Statics.getLabel('sewaUpakramCountFebMar')
//                                 : Statics.getLabel('sewaUpakramCountMarJun')))),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
//                       return null;
//                     },
//                     onSaved: (value) {
//                       shaakhaaVrutta!.sewaUpakramCount = value == "" ? null : int.parse(value!);
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     textInputAction: TextInputAction.next,
//                     controller: _anyaUpakramCountCtrl,
//                     decoration: InputDecoration(
//                         labelText: (_baithakTypeID == Statics.abPratinidhiSabhaa
//                             ? Statics.getLabel('anyaUpakramCount')
//                             : (_baithakTypeID == Statics.praantikBaithak1
//                                 ? Statics.getLabel('anyaUpakramCountFebMar')
//                                 : Statics.getLabel('anyaUpakramCountMarJun')))),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
//                       return null;
//                     },
//                     onSaved: (value) {
//                       shaakhaaVrutta!.anyaUpakramCount = value == "" ? null : int.parse(value!);
//                     },
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   SizedBox(
//                     width: Statics.getDeviceSize(context).width * 0.8,
//                     child: CheckboxListTile(
//                       contentPadding: EdgeInsets.symmetric(horizontal: 0),
//                       controlAffinity: ListTileControlAffinity.trailing,
//                       title: Text(Statics.getLabel("HasToli"), style: TextStyle(fontSize: 15)),
//                       checkColor: Colors.white,
//                       activeColor: Colors.purple,
//                       value: _isShaakhaaToli,
//                       onChanged: (value) {
//                         setState(() {
//                           _isShaakhaaToli = value!;
//                         });
//                       },
//                     ),
//                   ),
//                   //SizedBox(height: 10,),
//                   if (_isShaakhaaToli == true)
//                     TextFormField(
//                       textInputAction: TextInputAction.next,
//                       controller: _shaakhaaToliBaithakCountCtrl,
//                       decoration: InputDecoration(labelText: Statics.getLabel('shaakhaaToliBaithakCount')),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
//                         return null;
//                       },
//                       onSaved: (value) {
//                         shaakhaaVrutta!.shaakhaaToliBaithakCount = value == "" ? null : int.parse(value!);
//                       },
//                     ),
//                   if (shaakhaaVrutta != null && shaakhaaVrutta!.vayogatID == Statics.baalSanyuktaVayogatID)
//                     Column(
//                       children: <Widget>[
//                         SizedBox(
//                           height: 10,
//                         ),
//                         SizedBox(
//                           width: Statics.getDeviceSize(context).width * 0.8,
//                           child: CheckboxListTile(
//                             contentPadding: EdgeInsets.symmetric(horizontal: 0),
//                             controlAffinity: ListTileControlAffinity.trailing,
//                             title: Text(Statics.getLabel("HasPaalak"), style: TextStyle(fontSize: 15)),
//                             checkColor: Colors.white,
//                             activeColor: Colors.purple,
//                             value: _isShaakhaaPaalak,
//                             onChanged: (value) {
//                               setState(() {
//                                 _isShaakhaaPaalak = value!;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//
//                   SizedBox(
//                     height: 10,
//                   ),
//
//                   if (_isLoading)
//                     CircularProgressIndicator()
//                   else if (widget.viewType == "ViewOnly")
//                     Text(Statics.getLabel('canNotMakeChanges'))
//                   else
//                     MaterialButton(
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 8,
//                       ),
//                       color: Theme.of(context).primaryColor,
//                       textColor: Theme.of(context).primaryTextTheme.button!.color,
//                       onPressed: () {
//                         _submit(context);
//                       },
//                       child: Text(
//                         Statics.getLabel('Submit'),
//                         style: TextStyle(fontSize: 25),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
// // SizedBox(
// //   height: 10,
// // ),
// // TextFormField(
// //   textInputAction: TextInputAction.next,
// //   controller: _vaartaapatraCountCtrl,
// //   decoration: InputDecoration(
// //       labelText: Statics.getLabel('getVaartaapatraCount')),
// //   keyboardType: TextInputType.number,
// //   validator: (value) {
// //     if (value == null || value == '')
// //       return (Statics.getLabel('mandatoryInformation'));
// //     return null;
// //   },
// //   onSaved: (value) {
// //     shaakhaaVrutta!.vaartaapatraCount =
// //         value == "" ? null : int.parse(value);
// //   },
// // ),
// // if (shaakhaaVrutta != null &&
// //     (shaakhaaVrutta!.vayogatID == Statics.tarunVyavasaayeeVayogatID ||
// //         shaakhaaVrutta!.vayogatID == Statics.proudhaVyavasaayeeVayogatID))
// //   Column(
// //     children: <Widget>[
// //       SizedBox(
// //         height: 10,
// //       ),
// //       TextFormField(
// //         textInputAction: TextInputAction.next,
// //         controller: _patSankhyaaCtrl,
// //         decoration: InputDecoration(labelText: Statics.getLabel('patSankhyaa')),
// //         keyboardType: TextInputType.number,
// //         validator: (value) {
// //           if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
// //           return null;
// //         },
// //         onSaved: (value) {
// //           shaakhaaVrutta!.patSankhyaa = value == "" ? null : int.parse(value!);
// //         },
// //       ),
// //       SizedBox(
// //         height: 10,
// //       ),
// //       TextFormField(
// //         textInputAction: TextInputAction.next,
// //         controller: _sanghaDaayitvawaanSwCountCtrl,
// //         decoration: InputDecoration(labelText: Statics.getLabel('sanghaDaayitvawaanSwCount')),
// //         keyboardType: TextInputType.number,
// //         validator: (value) {
// //           if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
// //           return null;
// //         },
// //         onSaved: (value) {
// //           shaakhaaVrutta!.sanghaDaayitvawaanSwCount = value == "" ? null : int.parse(value!);
// //         },
// //       ),
// //       SizedBox(
// //         height: 10,
// //       ),
// //       TextFormField(
// //         textInputAction: TextInputAction.next,
// //         controller: _preritSansthaaSangathanDaayitvawaanSwCountCtrl,
// //         decoration: InputDecoration(labelText: Statics.getLabel('preritSansthaaSangathanDaayitvawaanSwCount')),
// //         keyboardType: TextInputType.number,
// //         validator: (value) {
// //           if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
// //           return null;
// //         },
// //         onSaved: (value) {
// //           shaakhaaVrutta!.preritSansthaaSangathanDaayitvawaanSwCount = value == "" ? null : int.parse(value!);
// //         },
// //       ),
// //       SizedBox(
// //         height: 10,
// //       ),
// //       TextFormField(
// //         textInputAction: TextInputAction.next,
// //         controller: _gatividhiDaayitvawaanSwCountCtrl,
// //         decoration: InputDecoration(labelText: Statics.getLabel('gatividhiDaayitvawaanSwCount')),
// //         keyboardType: TextInputType.number,
// //         validator: (value) {
// //           if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
// //           return null;
// //         },
// //         onSaved: (value) {
// //           shaakhaaVrutta!.gatividhiDaayitvawaanSwCount = value == "" ? null : int.parse(value!);
// //         },
// //       ),
// //       SizedBox(
// //         height: 10,
// //       ),
// //       TextFormField(
// //         textInputAction: TextInputAction.next,
// //         controller: _aayaamDaayitvawaanSwCountCtrl,
// //         decoration: InputDecoration(labelText: Statics.getLabel('aayaamDaayitvawaanSwCount')),
// //         keyboardType: TextInputType.number,
// //         validator: (value) {
// //           if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
// //           return null;
// //         },
// //         onSaved: (value) {
// //           shaakhaaVrutta!.aayaamDaayitvawaanSwCount = value == "" ? null : int.parse(value!);
// //         },
// //       ),
// //       SizedBox(
// //         height: 10,
// //       ),
// //       TextFormField(
// //         textInputAction: TextInputAction.next,
// //         controller: _sociallyActiveSwCountCtrl,
// //         decoration: InputDecoration(labelText: Statics.getLabel('sociallyActiveSwCount')),
// //         keyboardType: TextInputType.number,
// //         validator: (value) {
// //           if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
// //           return null;
// //         },
// //         onSaved: (value) {
// //           shaakhaaVrutta!.sociallyActiveSwCount = value == "" ? null : int.parse(value!);
// //         },
// //       ),
// //       // SizedBox(height: 10,),
// //       // SizedBox(
// //       //   width: Statics.getDeviceSize(context).width * 0.8,
// //       //   child: CheckboxListTile(
// //       //     contentPadding:
// //       //         EdgeInsets.symmetric(horizontal: 0),
// //       //     controlAffinity: ListTileControlAffinity.trailing,
// //       //     title: Text(
// //       //         Statics.getLabel(
// //       //             "isVaarshikNiyojanDone"),
// //       //         style: TextStyle(fontSize: 15)),
// //       //     checkColor: Colors.white,
// //       //     activeColor: Colors.purple,
// //       //     value: _isVaarshikNiyojanDone == null
// //       //         ? false
// //       //         : _isVaarshikNiyojanDone,
// //       //     onChanged: (value) {
// //       //       setState(() {
// //       //         _isVaarshikNiyojanDone = value;
// //       //       });
// //       //     },
// //       //   ),
// //       // ),
// //     ],
// //   ),
// // if (shaakhaaVrutta != null &&
// //   (shaakhaaVrutta!.annualBaithakTypeID == Statics.abPratinidhiSabhaa ||
// //     shaakhaaVrutta!.annualBaithakTypeID == Statics.prachaarakBaithak))
// // Column(children: <Widget>[
// //   SizedBox(height: 20,),
// //   Table(columnWidths: {
// //       0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.3),
// //       1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.3),
// //       2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.04),
// //       3: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.3)},
// //     children: [
// //       TableRow(children: [
// //         Container(height: 40, child: Text(Statics.getLabel('sanghShikshaVarg'), style: TextStyle(fontWeight: FontWeight.bold),)),
// //         Container(height: 40, child: Text((_baithakTypeID == Statics.abPratinidhiSabhaa
// //           ? Statics.getLabel('shikshaarthiCount')
// //           : (_baithakTypeID == Statics.praantikBaithak1
// //               ? Statics.getLabel('shikshaarthiCountFebMar')
// //               : Statics.getLabel('shikshaarthiCountMarJun'))), style: TextStyle(fontWeight: FontWeight.bold))),
// //         Container(height: 40, child: Text('', style: TextStyle(fontWeight: FontWeight.bold))),
// //         Container(height: 40, child: Text((_baithakTypeID == Statics.abPratinidhiSabhaa
// //           ? Statics.getLabel('sakriyaCount')
// //           : (_baithakTypeID == Statics.praantikBaithak1
// //               ? Statics.getLabel('sakriyaCountFebMar')
// //               :Statics.getLabel('sakriyaCountMarJun'))), style: TextStyle(fontWeight: FontWeight.bold))),
// //       ],
// //       ),
// //       TableRow(children: [
// //         Text(Statics.getLabel('praathamikVarsh')),
// //         TextFormField(
// //           textInputAction: TextInputAction.next,
// //           controller: _praathamikCountCtrl,
// //           keyboardType: TextInputType.number,
// //           validator: (value) {
// //             if (value == null || value == '')
// //               return (Statics.getLabel('mandatoryInformation'));
// //             return null;
// //           },
// //           onSaved: (value) {
// //             shaakhaaVrutta!.praathamikCount =
// //                 value == "" ? null : int.parse(value);
// //           },
// //         ),
// //         Text(''),
// //         TextFormField(
// //           textInputAction: TextInputAction.next,
// //           controller: _praathamikSakriyaCountCtrl,
// //           keyboardType: TextInputType.number,
// //           validator: (value) {
// //             if (value == null || value == '')
// //               return (Statics.getLabel('mandatoryInformation'));
// //             return null;
// //           },
// //           onSaved: (value) {
// //             shaakhaaVrutta!.praathamikSakriyaCount =
// //                 value == "" ? null : int.parse(value);
// //           },
// //         ),
// //       ]),
// //       // TableRow(children: [
// //       //   Text(Statics.getLabel('prathamGeneral')),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _prathamGeneralCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.prathamGeneralCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       //   Text(''),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _prathamGeneralSakriyaCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.prathamGeneralSakriyaCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       // ]),
// //       // TableRow(children: [
// //       //   Text(Statics.getLabel('prathamSpecial')),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _prathamSpecialCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.prathamSpecialCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       //   Text(''),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _prathamSpecialSakriyaCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.prathamSpecialSakriyaCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       // ]),
// //       // TableRow(children: [
// //       //   Text(Statics.getLabel('dwitiyaGeneral')),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _dwitiyaGeneralCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.dwitiyaGeneralCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       //   Text(''),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _dwitiyaGeneralSakriyaCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.dwitiyaGeneralSakriyaCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       // ]),
// //       // TableRow(children: [
// //       //   Text(Statics.getLabel('dwitiyaSpecial')),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _dwitiyaSpecialCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.dwitiyaSpecialCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       //   Text(''),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _dwitiyaSpecialSakriyaCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.dwitiyaSpecialSakriyaCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       // ]),
// //       // TableRow(children: [
// //       //   Text(Statics.getLabel('trutiyaGeneral')),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _trutiyaGeneralCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.trutiyaGeneralCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       //   Text(''),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _trutiyaGeneralSakriyaCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.trutiyaGeneralSakriyaCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       // ]),
// //       // TableRow(children: [
// //       //   Text(Statics.getLabel('trutiyaSpecial')),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _trutiyaSpecialCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.trutiyaSpecialCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       //   Text(''),
// //       //   TextFormField(
// //       //     textInputAction: TextInputAction.next,
// //       //     controller: _trutiyaSpecialSakriyaCountCtrl,
// //       //     keyboardType: TextInputType.number,
// //       //     onSaved: (value) {
// //       //       shaakhaaVrutta!.trutiyaSpecialSakriyaCount =
// //       //           value == "" ? null : int.parse(value);
// //       //     },
// //       //   ),
// //       // ]),
// //     ],
// //   ),
// // ],),
//
//
//



///////      NEW PAGE  ////////


import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../providers/bals.dart';

import '../helpers/static_data.dart' as Statics;

class EditAnnualBaithakShaakhaaVrutta extends StatefulWidget {
  static const String routeName = '/edit-annual-baithak-shaakhaa-vrutta';
  var annualBaithakShaakhaaVruttaID;
  var geoUnitID;
  var geoUnitName;
  var annualBaithakTypeID;
  var annualBaithakTypeCode;
  var onSaveDetails;
  var viewType;
  var locId;
  var loctype;
  EditAnnualBaithakShaakhaaVrutta(
      {Key? key,
        this.annualBaithakShaakhaaVruttaID,
        this.geoUnitID,
        this.geoUnitName,
        this.annualBaithakTypeID,
        this.annualBaithakTypeCode,
        this.onSaveDetails,
        this.viewType,
        this.locId,
        this.loctype,
      })
      : super(key: key);
  @override
  _EditAnnualBaithakShaakhaaVruttaState createState() => _EditAnnualBaithakShaakhaaVruttaState();
}

class _EditAnnualBaithakShaakhaaVruttaState extends State<EditAnnualBaithakShaakhaaVrutta> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isLoading = false;

  bool _isFetchingData = false;

  AnnualBaithakShaakhaaVruttaBAL? shaakhaaVrutta;

  var _conductingDaysCtrl = TextEditingController();
  var _conductingDaysCtrlGetfromAPI = TextEditingController();
  var _conductingSewaDaysCtrl = TextEditingController();
  var _conductingSewaDaysCtrlGetfromAPI = TextEditingController();
  var _baalAvgCntrl = TextEditingController();
  var _vidyaarthiAvgCtrl = TextEditingController();
  var _vyavasaayeeAvgCtrl = TextEditingController();
  var _proudhAvgCtrl = TextEditingController();
  var _sewaVastiSamparkCountCtrl = TextEditingController();
  var _sewaUpakramCountCtrl = TextEditingController();
  var _anyaUpakramCountCtrl = TextEditingController();
  var _praathamikCountCtrl = TextEditingController();
  var _praathamikSakriyaCountCtrl = TextEditingController();
  var _prathamGeneralCountCtrl = TextEditingController();
  var _prathamGeneralSakriyaCountCtrl = TextEditingController();
  var _prathamSpecialCountCtrl = TextEditingController();
  var _prathamSpecialSakriyaCountCtrl = TextEditingController();
  var _dwitiyaGeneralCountCtrl = TextEditingController();
  var _dwitiyaGeneralSakriyaCountCtrl = TextEditingController();
  var _dwitiyaSpecialCountCtrl = TextEditingController();
  var _dwitiyaSpecialSakriyaCountCtrl = TextEditingController();
  var _trutiyaGeneralCountCtrl = TextEditingController();
  var _trutiyaGeneralSakriyaCountCtrl = TextEditingController();
  var _trutiyaSpecialCountCtrl = TextEditingController();
  var _trutiyaSpecialSakriyaCountCtrl = TextEditingController();
  var _patSankhyaaCtrl = TextEditingController();
  var _sanghaDaayitvawaanSwCountCtrl = TextEditingController();
  var _preritSansthaaSangathanDaayitvawaanSwCountCtrl = TextEditingController();
  var _gatividhiDaayitvawaanSwCountCtrl = TextEditingController();
  var _aayaamDaayitvawaanSwCountCtrl = TextEditingController();
  var _sociallyActiveSwCountCtrl = TextEditingController();
  var _shishuAverageCtrl = TextEditingController();
  var _shaakhaaToliBaithakCountCtrl = TextEditingController();
  var _vaartaapatraCountCtrl = TextEditingController();
  int? _baithakTypeID;
  String? _vaarshikotsavMonthValue;
  int? _isActive ;
  bool _isSewaVastiDefined = false;
  bool _isSewaKaaryakartaaDefined = false;
  bool _isShaakhaaToli = false;
  bool _isShaakhaaPaalak = false;
  bool _isVaarshikNiyojanDone = false;
  int? abShaakhaaVruttaID;
  @override
  void initState() {
    super.initState();
     abShaakhaaVruttaID = (widget.annualBaithakShaakhaaVruttaID == null ? 0 : (widget.annualBaithakShaakhaaVruttaID as int));
    int geoUnitID = (widget.geoUnitID as int);
    String geoUnitName = widget.geoUnitName.toString();
    int baithakTypeID = (widget.annualBaithakTypeID as int);
    String baithakTypeCode = widget.annualBaithakTypeCode.toString();
    populateAnnualBaithakShaakhaaVrutta(baithakTypeID, geoUnitID);
    print("typeeeeeeeeee   -=-=-> ${widget.viewType}");
  }

  @override
  void dispose() {
    super.dispose();
    _conductingDaysCtrl.dispose();
    _conductingDaysCtrlGetfromAPI.dispose();
    _conductingSewaDaysCtrl.dispose();
    _conductingSewaDaysCtrlGetfromAPI.dispose();
    _baalAvgCntrl.dispose();
    _vidyaarthiAvgCtrl.dispose();
    _vyavasaayeeAvgCtrl.dispose();
    _proudhAvgCtrl.dispose();
    _sewaVastiSamparkCountCtrl.dispose();
    _sewaUpakramCountCtrl.dispose();
    _anyaUpakramCountCtrl.dispose();
    _praathamikCountCtrl.dispose();
    _praathamikSakriyaCountCtrl.dispose();
    _prathamGeneralCountCtrl.dispose();
    _prathamGeneralSakriyaCountCtrl.dispose();
    _prathamSpecialCountCtrl.dispose();
    _prathamSpecialSakriyaCountCtrl.dispose();
    _dwitiyaGeneralCountCtrl.dispose();
    _dwitiyaGeneralSakriyaCountCtrl.dispose();
    _dwitiyaSpecialCountCtrl.dispose();
    _dwitiyaSpecialSakriyaCountCtrl.dispose();
    _trutiyaGeneralCountCtrl.dispose();
    _trutiyaGeneralSakriyaCountCtrl.dispose();
    _trutiyaSpecialCountCtrl.dispose();
    _trutiyaSpecialSakriyaCountCtrl.dispose();
    _patSankhyaaCtrl.dispose();
    _sanghaDaayitvawaanSwCountCtrl.dispose();
    _preritSansthaaSangathanDaayitvawaanSwCountCtrl.dispose();
    _gatividhiDaayitvawaanSwCountCtrl.dispose();
    _aayaamDaayitvawaanSwCountCtrl.dispose();
    _sociallyActiveSwCountCtrl.dispose();
    _shishuAverageCtrl.dispose();
    _shaakhaaToliBaithakCountCtrl.dispose();
    _vaartaapatraCountCtrl.dispose();
  }

  void populateAnnualBaithakShaakhaaVrutta(int btID, int guID) async {
    setState(() {
      _isFetchingData = true;
    });
    dynamic retVal;
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "AnnualBaithakTypeID": btID,
        "GeoUnitID": guID,
        "AnnualBaithakShaakhaaVruttaID": abShaakhaaVruttaID
      });
      print("strInput --> $strInput   ");
      // retVal = (await Statics.getAnnualBaithakShaakhaaVruttaForApp(strInput)).firstWhere(  (item) => item["AnnualBaithakShaakhaaVruttaID"] == widget.annualBaithakShaakhaaVruttaID &&
      //     item["GeoUnitID"] == widget.geoUnitID,orElse: () => null, );
      retVal = (await Statics.getAnnualBaithakShaakhaaVruttaForAppById(strInput));
      //return retVal['ListShaakhaaVrutta'];

      log("retVal ---- >  ${retVal}");
      setState(() {
        shaakhaaVrutta = AnnualBaithakShaakhaaVruttaBAL.fromMap(retVal.first);
        _baithakTypeID = btID;
        _isActive = shaakhaaVrutta?.isSadhyaSuruAahe;
        _conductingDaysCtrl.text = (shaakhaaVrutta!.conductingDayCount == null ? '' : shaakhaaVrutta!.conductingDayCount.toString());
        _conductingSewaDaysCtrl.text = (shaakhaaVrutta!.conductingSewaDayCount == null ? '' : shaakhaaVrutta!.conductingSewaDayCount.toString());
        _conductingDaysCtrlGetfromAPI.text = (shaakhaaVrutta!.conductingDaysCtrlGetfromAPI == null ? '' : shaakhaaVrutta!.conductingDaysCtrlGetfromAPI.toString());
        _conductingSewaDaysCtrlGetfromAPI.text = (shaakhaaVrutta!.conductingSewaDaysCtrlGetfromAPI == null ? '' : shaakhaaVrutta!.conductingSewaDaysCtrlGetfromAPI.toString());
        _baalAvgCntrl.text = (shaakhaaVrutta!.baalAverage == null ? '' : shaakhaaVrutta!.baalAverage.toString());
        _vidyaarthiAvgCtrl.text = (shaakhaaVrutta!.tarunVidyaarthiAverage == null ? '' : shaakhaaVrutta!.tarunVidyaarthiAverage.toString());
        _vyavasaayeeAvgCtrl.text = (shaakhaaVrutta!.tarunVyavasaayeeAverage == null ? '' : shaakhaaVrutta!.tarunVyavasaayeeAverage.toString());
        _proudhAvgCtrl.text = (shaakhaaVrutta!.proudhVyavasaayeeAverage == null ? '' : shaakhaaVrutta!.proudhVyavasaayeeAverage.toString());
        _vaarshikotsavMonthValue = (shaakhaaVrutta!.vaarshikotsavMonth == null ? '' : shaakhaaVrutta!.vaarshikotsavMonth.toString());
        _isSewaVastiDefined = shaakhaaVrutta!.isSewaVastiDefined == true ? true : false;
        _sewaVastiSamparkCountCtrl.text = (shaakhaaVrutta!.sewaVastiSamparkCount == null ? '' : shaakhaaVrutta!.sewaVastiSamparkCount.toString());
        _isSewaKaaryakartaaDefined = shaakhaaVrutta!.isSewaKaaryakartaaDefined == true ? true : false;
        _sewaUpakramCountCtrl.text = (shaakhaaVrutta!.sewaUpakramCount == null ? '' : shaakhaaVrutta!.sewaUpakramCount.toString());
        _anyaUpakramCountCtrl.text = (shaakhaaVrutta!.anyaUpakramCount == null ? '' : shaakhaaVrutta!.anyaUpakramCount.toString());
        _praathamikCountCtrl.text = (shaakhaaVrutta!.praathamikCount == null ? '' : shaakhaaVrutta!.praathamikCount.toString());
        _praathamikSakriyaCountCtrl.text = (shaakhaaVrutta!.praathamikSakriyaCount == null ? '' : shaakhaaVrutta!.praathamikSakriyaCount.toString());
        _prathamGeneralCountCtrl.text = (shaakhaaVrutta!.prathamGeneralCount == null ? '' : shaakhaaVrutta!.prathamGeneralCount.toString());
        _prathamGeneralSakriyaCountCtrl.text =
        (shaakhaaVrutta!.prathamGeneralSakriyaCount == null ? '' : shaakhaaVrutta!.prathamGeneralSakriyaCount.toString());
        _prathamSpecialCountCtrl.text = (shaakhaaVrutta!.prathamSpecialCount == null ? '' : shaakhaaVrutta!.prathamSpecialCount.toString());
        _prathamSpecialSakriyaCountCtrl.text =
        (shaakhaaVrutta!.prathamSpecialSakriyaCount == null ? '' : shaakhaaVrutta!.prathamSpecialSakriyaCount.toString());
        _dwitiyaGeneralCountCtrl.text = (shaakhaaVrutta!.dwitiyaGeneralCount == null ? '' : shaakhaaVrutta!.dwitiyaGeneralCount.toString());
        _dwitiyaGeneralSakriyaCountCtrl.text =
        (shaakhaaVrutta!.dwitiyaGeneralSakriyaCount == null ? '' : shaakhaaVrutta!.dwitiyaGeneralSakriyaCount.toString());
        _dwitiyaSpecialCountCtrl.text = (shaakhaaVrutta!.dwitiyaSpecialCount == null ? '' : shaakhaaVrutta!.dwitiyaSpecialCount.toString());
        _dwitiyaSpecialSakriyaCountCtrl.text =
        (shaakhaaVrutta!.dwitiyaSpecialSakriyaCount == null ? '' : shaakhaaVrutta!.dwitiyaSpecialSakriyaCount.toString());
        _trutiyaGeneralCountCtrl.text = (shaakhaaVrutta!.trutiyaGeneralCount == null ? '' : shaakhaaVrutta!.trutiyaGeneralCount.toString());
        _trutiyaGeneralSakriyaCountCtrl.text =
        (shaakhaaVrutta!.trutiyaGeneralSakriyaCount == null ? '' : shaakhaaVrutta!.trutiyaGeneralSakriyaCount.toString());
        _trutiyaSpecialCountCtrl.text = (shaakhaaVrutta!.trutiyaSpecialCount == null ? '' : shaakhaaVrutta!.trutiyaSpecialCount.toString());
        _trutiyaSpecialSakriyaCountCtrl.text =
        (shaakhaaVrutta!.trutiyaSpecialSakriyaCount == null ? '' : shaakhaaVrutta!.trutiyaSpecialSakriyaCount.toString());

        _patSankhyaaCtrl.text = (shaakhaaVrutta!.patSankhyaa == null ? '' : shaakhaaVrutta!.patSankhyaa.toString());
        _sanghaDaayitvawaanSwCountCtrl.text =
        (shaakhaaVrutta!.sanghaDaayitvawaanSwCount == null ? '' : shaakhaaVrutta!.sanghaDaayitvawaanSwCount.toString());
        _preritSansthaaSangathanDaayitvawaanSwCountCtrl.text = (shaakhaaVrutta!.preritSansthaaSangathanDaayitvawaanSwCount == null
            ? ''
            : shaakhaaVrutta!.preritSansthaaSangathanDaayitvawaanSwCount.toString());
        _gatividhiDaayitvawaanSwCountCtrl.text =
        (shaakhaaVrutta!.gatividhiDaayitvawaanSwCount == null ? '' : shaakhaaVrutta!.gatividhiDaayitvawaanSwCount.toString());
        _aayaamDaayitvawaanSwCountCtrl.text =
        (shaakhaaVrutta!.aayaamDaayitvawaanSwCount == null ? '' : shaakhaaVrutta!.aayaamDaayitvawaanSwCount.toString());
        _sociallyActiveSwCountCtrl.text = (shaakhaaVrutta!.sociallyActiveSwCount == null ? '' : shaakhaaVrutta!.sociallyActiveSwCount.toString());
        _shishuAverageCtrl.text = (shaakhaaVrutta!.shishuAverage == null ? '' : shaakhaaVrutta!.shishuAverage.toString());
        _shaakhaaToliBaithakCountCtrl.text =
        (shaakhaaVrutta!.shaakhaaToliBaithakCount == null ? '' : shaakhaaVrutta!.shaakhaaToliBaithakCount.toString());
        _vaartaapatraCountCtrl.text = (shaakhaaVrutta!.vaartaapatraCount == null ? '' : shaakhaaVrutta!.vaartaapatraCount.toString());

        _isShaakhaaToli = shaakhaaVrutta!.isShaakhaaToli == true ? true : false;
        _isShaakhaaPaalak = shaakhaaVrutta!.isShaakhaaPaalak == true ? true : false;
        _isVaarshikNiyojanDone = shaakhaaVrutta!.isVaarshikNiyojanDone == true ? true : false;

        _isFetchingData = false;
      });
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      //return null;
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        await saveAnnualBaithakShaakhaaVrutta(context);
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  saveAnnualBaithakShaakhaaVrutta(BuildContext context) async {
    var inputData = json.encode({
      "AppUserID": Statics.userDetails["userID"],
      "IsSadhyaSuruAahe": _isActive,
      "AnnualBaithakShaakhaaVruttaID":
      (widget.annualBaithakShaakhaaVruttaID == null ? 0 : int.parse(widget.annualBaithakShaakhaaVruttaID.toString())),
      "GeoUnitID": (widget.geoUnitID == null ? 0 : int.parse(widget.geoUnitID.toString())),
      "AnnualBaithakTypeID": (widget.annualBaithakTypeID == null ? 0 : int.parse(widget.annualBaithakTypeID.toString())),
      "ConductingDayCount": _conductingDaysCtrl.text.trim() == '' ? null : int.parse(_conductingDaysCtrl.text),
      "SewaDivasKitiVela": _conductingSewaDaysCtrl.text.trim() == '' ? null : int.parse(_conductingSewaDaysCtrl.text),
      "BaalAverage": _baalAvgCntrl.text.trim() == '' ? null : int.parse(_baalAvgCntrl.text),
      "TarunVidyaarthiAverage": _vidyaarthiAvgCtrl.text.trim() == '' ? null : int.parse(_vidyaarthiAvgCtrl.text),
      "TarunVyavasaayeeAverage": _vyavasaayeeAvgCtrl.text.trim() == '' ? null : int.parse(_vyavasaayeeAvgCtrl.text),
      "ProudhaVyavasaayeeAverage": _proudhAvgCtrl.text.trim() == '' ? null : int.parse(_proudhAvgCtrl.text),
      "VaarshikotsavMonth": shaakhaaVrutta!.vaarshikotsavMonth,
      "IsSewaVastiDefined": _isSewaVastiDefined,
      "SewaVastiSamparkCount": _sewaVastiSamparkCountCtrl.text.trim() == '' ? null : int.parse(_sewaVastiSamparkCountCtrl.text),
      "IsSewaKaaryakartaaDefined": _isSewaKaaryakartaaDefined,
      "SewaUpakramCount": _sewaUpakramCountCtrl.text.trim() == '' ? null : int.parse(_sewaUpakramCountCtrl.text),
      "AnyaUpakramCount": _anyaUpakramCountCtrl.text.trim() == '' ? null : int.parse(_anyaUpakramCountCtrl.text),
      "PraathamikCount": _praathamikCountCtrl.text.trim() == '' ? null : int.parse(_praathamikCountCtrl.text),
      "PraathamikSakriyaCount": _praathamikSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_praathamikSakriyaCountCtrl.text),
      "PrathamGeneralCount": _prathamGeneralCountCtrl.text.trim() == '' ? null : int.parse(_prathamGeneralCountCtrl.text),
      "PrathamGeneralSakriyaCount": _prathamGeneralSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_prathamGeneralSakriyaCountCtrl.text),
      "PrathamSpecialCount": _prathamSpecialCountCtrl.text.trim() == '' ? null : int.parse(_prathamSpecialCountCtrl.text),
      "PrathamSpecialSakriyaCount": _prathamSpecialSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_prathamSpecialSakriyaCountCtrl.text),
      "DwitiyaGeneralCount": _dwitiyaGeneralCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaGeneralCountCtrl.text),
      "DwitiyaGeneralSakriyaCount": _dwitiyaGeneralSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaGeneralSakriyaCountCtrl.text),
      "DwitiyaSpecialCount": _dwitiyaSpecialCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaSpecialCountCtrl.text),
      "DwitiyaSpecialSakriyaCount": _dwitiyaSpecialSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_dwitiyaSpecialSakriyaCountCtrl.text),
      "TrutiyaGeneralCount": _trutiyaGeneralCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaGeneralCountCtrl.text),
      "TrutiyaGeneralSakriyaCount": _trutiyaGeneralSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaGeneralSakriyaCountCtrl.text),
      "TrutiyaSpecialCount": _trutiyaSpecialCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaSpecialCountCtrl.text),
      "TrutiyaSpecialSakriyaCount": _trutiyaSpecialSakriyaCountCtrl.text.trim() == '' ? null : int.parse(_trutiyaSpecialSakriyaCountCtrl.text),
      "PatSankhyaa": _patSankhyaaCtrl.text.trim() == '' ? null : int.parse(_patSankhyaaCtrl.text),
      "SanghaDaayitvawaanSwCount": _sanghaDaayitvawaanSwCountCtrl.text.trim() == '' ? null : int.parse(_sanghaDaayitvawaanSwCountCtrl.text),
      "PreritSansthaaSangathanDaayitvawaanSwCount":
      _preritSansthaaSangathanDaayitvawaanSwCountCtrl.text.trim() == '' ? null : int.parse(_preritSansthaaSangathanDaayitvawaanSwCountCtrl.text),
      "GatividhiDaayitvawaanSwCount": _gatividhiDaayitvawaanSwCountCtrl.text.trim() == '' ? null : int.parse(_gatividhiDaayitvawaanSwCountCtrl.text),
      "AayaamDaayitvawaanSwCount": _aayaamDaayitvawaanSwCountCtrl.text.trim() == '' ? null : int.parse(_aayaamDaayitvawaanSwCountCtrl.text),
      "SociallyActiveSwCount": _sociallyActiveSwCountCtrl.text.trim() == '' ? null : int.parse(_sociallyActiveSwCountCtrl.text),
      "ShishuAverage": _shishuAverageCtrl.text.trim() == '' ? null : int.parse(_shishuAverageCtrl.text),
      "ShaakhaaToliBaithakCount": _shaakhaaToliBaithakCountCtrl.text.trim() == '' ? null : int.parse(_shaakhaaToliBaithakCountCtrl.text),
      "VaartaapatraCount": _vaartaapatraCountCtrl.text.trim() == '' ? null : int.parse(_vaartaapatraCountCtrl.text),
      "IsShaakhaaToli": _isShaakhaaToli,
      "IsShaakhaaPaalak": _isShaakhaaPaalak,
      "IsVaarshikNiyojanDone": _isVaarshikNiyojanDone,
      "ModifiedBy": Statics.userDetails["userID"]
    });
    log("saveAnnualBaithakShaakhaaVrutta :--${inputData}");
    var oID = await Statics.saveAnnualBaithakShaakhaaVruttaForApp(inputData);
    setState(() {
      widget.annualBaithakShaakhaaVruttaID = oID;
      widget.onSaveDetails();
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel('annualBaithakShaakhaaVruttaTitle'),
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isFetchingData,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(shaakhaaVrutta == null
                      ? ''
                      : (shaakhaaVrutta!.geoUnitName! + ', (' + shaakhaaVrutta!.vayogatCode! + ', ' + shaakhaaVrutta!.frequencyCode! + ')')),
                  Text(shaakhaaVrutta == null ? '' : shaakhaaVrutta!.annualBaithakTypeCode!),
                  // SizedBox(
                  //   width: Statics.getDeviceSize(context).width * 0.8,
                  //   child: CheckboxListTile(
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  //     controlAffinity: ListTileControlAffinity.trailing,
                  //     title: Text(Statics.getLabel('Currentlyrunning'), style: TextStyle(fontSize: 15)),
                  //     checkColor: Colors.white,
                  //     activeColor: Colors.purple,
                  //     value: _isActive,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         _isActive = value!;
                  //       });
                  //     },
                  //   ),
                  // ),
                  SizedBox(height: 20,),
                  // DropdownButtonFormField<bool>(
                  //     decoration: InputDecoration(
                  //       labelText: Statics.getLabel('Currentlyrunning'),
                  //       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  //     ),
                  //     value: _isActive,
                  //     items: [
                  //       DropdownMenuItem(
                  //         value: true,
                  //         child: Text(Statics.getLabel('ConfirmationYes')),
                  //       ),
                  //       DropdownMenuItem(
                  //         value: false,
                  //         child: Text(Statics.getLabel('ConfirmationNo')),
                  //       ),
                  //     ],
                  //     onChanged: (value) {
                  //       setState(() {
                  //         _isActive = value!;
                  //       });
                  //     },
                  //   ),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: Statics.getLabel('Currentlyrunning'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    value: _isActive,
                    items: [
                      DropdownMenuItem(
                        value: 1,
                        child: Text(Statics.getLabel('ConfirmationYes')),
                      ),
                      DropdownMenuItem(
                        value: 0,
                        child: Text(Statics.getLabel('ConfirmationNo')),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _isActive = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _conductingDaysCtrl,
                    decoration: InputDecoration(labelText: "${Statics.getLabel('conductingDayCount')} - (${_conductingDaysCtrlGetfromAPI.text})"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Statics.getLabel('mandatoryInformation');
                      }
                      final int? conductingDays = int.tryParse(value);
                      if (conductingDays == null || conductingDays < 0 || conductingDays > 30) {
                        return Statics.getLabel('fillNumber');
                      }
                      return null;
                    },
                    onSaved: (value) {
                      shaakhaaVrutta!.conductingDayCount = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _conductingSewaDaysCtrl,
                    decoration: InputDecoration(labelText: "${Statics.getLabel('conductingSewaDayCount')}"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Statics.getLabel('mandatoryInformation');
                      }
                      final int? conductingDays = int.tryParse(value);
                      if (conductingDays == null || conductingDays < 0 || conductingDays > 30) {
                        return Statics.getLabel('fillNumber');
                      }
                      return null;
                    },
                    onSaved: (value) {
                      shaakhaaVrutta!.conductingSewaDayCount = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _shishuAverageCtrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('shishuAvg')),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      shaakhaaVrutta!.shishuAverage = value == "" ? 0 : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _baalAvgCntrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('baalAvg')),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      shaakhaaVrutta!.baalAverage = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _vidyaarthiAvgCtrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('tarunVidyaarthiAvg')),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      shaakhaaVrutta!.tarunVidyaarthiAverage = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _vyavasaayeeAvgCtrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('tarunVyavasaayeeAvg')),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      shaakhaaVrutta!.tarunVyavasaayeeAverage = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _proudhAvgCtrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('proudhAvg')),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      shaakhaaVrutta!.proudhVyavasaayeeAverage = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: (_baithakTypeID == Statics.abPratinidhiSabhaa
                            ? Statics.getLabel('vaarshikotsavMonth')
                            : (_baithakTypeID == Statics.praantikBaithak1
                            ? Statics.getLabel('vaarshikotsavMonthFebMar')
                            : Statics.getLabel('vaarshikotsavMonthMarJun')))),
                    isExpanded: true,
                    value: _vaarshikotsavMonthValue == '' ? null : _vaarshikotsavMonthValue,
                    items: Statics.vaarshikotsavMonths.entries
                        .map((entry) => DropdownMenuItem(value: entry.key, child: Text(Statics.getLabel(entry.value))))
                        .toList(),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _vaarshikotsavMonthValue = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null && value.isNotEmpty)
                        shaakhaaVrutta!.vaarshikotsavMonth = int.parse(value);
                      else
                        shaakhaaVrutta!.vaarshikotsavMonth = null;
                    },
                  ),

                  SizedBox(height: 10,),
                  // if(_isSewaVastiDefined == true )
                  if( shaakhaaVrutta?.frequencyID.toString() == '35'|| shaakhaaVrutta?.frequencyID.toString() == '34')
                    if(shaakhaaVrutta?.vayogatID.toString() == '39'||shaakhaaVrutta?.vayogatID.toString() == '40' )
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(Statics.getLabel("isSewaVastiDefined"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isSewaVastiDefined,
                          onChanged: (value) {
                            setState(() {
                              print("_isSewaVastiDefined $_isSewaVastiDefined");
                              _isSewaVastiDefined = value!;
                            });
                          },
                        ),
                      ),

                  SizedBox(
                    height: 10,
                  ),
                  // Text("shaakhaaVrutta?.frequencyID ==> ${shaakhaaVrutta?.frequencyID}\n shaakhaaVrutta?.vayogatID ${shaakhaaVrutta?.vayogatID} "),

                  // if(_isSewaVastiDefined == true )
                  if( shaakhaaVrutta?.frequencyID.toString() == '35'|| shaakhaaVrutta?.frequencyID.toString() == '34')
                    if(shaakhaaVrutta?.vayogatID.toString() == '39'||shaakhaaVrutta?.vayogatID.toString() == '40' )
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _sewaVastiSamparkCountCtrl,
                        decoration: InputDecoration(
                            labelText: (_baithakTypeID == Statics.abPratinidhiSabhaa
                                ? Statics.getLabel('sewaVastiSamparkCount')
                                : (_baithakTypeID == Statics.praantikBaithak1
                                ? Statics.getLabel('sewaVastiSamparkCountFebMar')
                                : Statics.getLabel('sewaVastiSamparkCount')))),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return Statics.getLabel('mandatoryInformation');
                          }
                          final int? conductingDays = int.tryParse(value);
                          if (conductingDays == null || conductingDays < 0 || conductingDays > 30) {
                            return Statics.getLabel('fillNumber');
                          }
                          return null;
                        },
                        onSaved: (value) {
                          shaakhaaVrutta!.sewaVastiSamparkCount = value == "" ? null : int.parse(value!);
                        },
                      ),
                  SizedBox(height: 10,),
                  // if(shaakhaaVrutta != null)
                  if( shaakhaaVrutta?.frequencyID.toString() == '35'|| shaakhaaVrutta?.frequencyID.toString() == '34')
                    if(shaakhaaVrutta?.vayogatID.toString() == '39'||shaakhaaVrutta?.vayogatID.toString() == '40' )
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.8,
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(Statics.getLabel("isSewaKaaryakartaaDefined"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _isSewaKaaryakartaaDefined,
                          onChanged: (value) {
                            setState(() {
                              _isSewaKaaryakartaaDefined = value!;
                            });
                          },
                        ),
                      ),

                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _sewaUpakramCountCtrl,
                    decoration: InputDecoration(
                        labelText: (_baithakTypeID == Statics.abPratinidhiSabhaa
                            ? Statics.getLabel('sewaUpakramCount')
                            : (_baithakTypeID == Statics.praantikBaithak1
                            ? Statics.getLabel('sewaUpakramCountFebMar')
                            : Statics.getLabel('sewaUpakramCountMarJun')))),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      shaakhaaVrutta!.sewaUpakramCount = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _anyaUpakramCountCtrl,
                    decoration: InputDecoration(
                        labelText: (_baithakTypeID == Statics.abPratinidhiSabhaa
                            ? Statics.getLabel('anyaUpakramCount')
                            : (_baithakTypeID == Statics.praantikBaithak1
                            ? Statics.getLabel('anyaUpakramCountFebMar')
                            : Statics.getLabel('anyaUpakramCountMarJun')))),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                      return null;
                    },
                    onSaved: (value) {
                      shaakhaaVrutta!.anyaUpakramCount = value == "" ? null : int.parse(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: Statics.getDeviceSize(context).width * 0.8,
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text(Statics.getLabel("HasToli"), style: TextStyle(fontSize: 15)),
                      checkColor: Colors.white,
                      activeColor: Colors.purple,
                      value: _isShaakhaaToli,
                      onChanged: (value) {
                        setState(() {
                          _isShaakhaaToli = value!;
                        });
                      },
                    ),
                  ),
                  //SizedBox(height: 10,),
                  if (_isShaakhaaToli == true)
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _shaakhaaToliBaithakCountCtrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('shaakhaaToliBaithakCount')),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value == '') return (Statics.getLabel('mandatoryInformation'));
                        return null;
                      },
                      onSaved: (value) {
                        shaakhaaVrutta!.shaakhaaToliBaithakCount = value == "" ? null : int.parse(value!);
                      },
                    ),
                  if (shaakhaaVrutta != null && shaakhaaVrutta!.vayogatID == Statics.baalSanyuktaVayogatID)
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.8,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            controlAffinity: ListTileControlAffinity.trailing,
                            title: Text(Statics.getLabel("HasPaalak"), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _isShaakhaaPaalak,
                            onChanged: (value) {
                              setState(() {
                                _isShaakhaaPaalak = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                  SizedBox(
                    height: 10,
                  ),

                  if (_isLoading)
                    CircularProgressIndicator()
                  else if (widget.viewType == "ViewOnly")
                    Text(Statics.getLabel('canNotMakeChanges'))
                  else
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button!.color,
                      onPressed: () {
                        _submit(context);
                      },
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

