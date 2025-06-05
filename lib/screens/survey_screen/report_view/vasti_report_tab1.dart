import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/vasti_survey_report_model.dart';
import '../../../providers/bals.dart';
import '../../../widgets/legend.dart';
import '../../../widgets/single_column_row.dart';
import '../../../widgets/two_column_row.dart';


class VastiSurveyReportViewScreen extends StatefulWidget {
  static const String routeName = '/vasti-survey-report';

  const VastiSurveyReportViewScreen({super.key});

  @override
  State<VastiSurveyReportViewScreen> createState() => _VastiSurveyReportViewScreenState();
}

class _VastiSurveyReportViewScreenState extends State<VastiSurveyReportViewScreen> {

  @override
  void initState() {
    super.initState();
    populateDropdown();
    getGeoUnitID();
    // getMyDetailsColumnsAndRows();
  }

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
  String? _linkedvastiValue = '';
  String? mahanagarId = '';
  String? vibhagId = '';
  String? selctedLevel = 'praant';
  String? selctedLevelName = '';
  String? selctedLevelId = '';
  String? selctedLevelNameNew = '';
  String? selctedLevelIdNew = '';
  //=====================================  NEW  ADD ========================================================================================
  final rowTitles = [
    'शाखा',
    'साप्ताहिक मिलन',
    'मासिक मिलन',
    'नवीन संकल्पित\nशाखा आहे',
    'नवीन संकल्पित\n साप्ताहिक मिलन आहे',
    'नवीन संकल्पित\nमासिक मिलन आहे',
    'पूर्वी शाखा होती',
    'पूर्वी साप्ताहिक\nमिलन होते',
  ];
  String getCellValueByRowIndex(SanghaKaryaStithiData e, int index) {
    switch (index) {
      case 0:
        return (e.shaakhaaCount ?? 0).toString();
      case 1:
        return (e.saaptaahikCount ?? 0).toString();
      case 2:
        return (e.maasikMilanCount ?? 0).toString();
      case 3:
        return (e.sankalpitShaakhaaCount ?? 0).toString();
      case 4:
        return (e.sankalpitSaaptaahikCount ?? 0).toString();
      case 5:
        return (e.sankalpitMaasikMilanCount ?? 0).toString();
      case 6:
        return e.purviShaakhaa?.isNotEmpty == true ? e.purviShaakhaa! : '-';
      case 7:
        return e.purviSaptahik?.isNotEmpty == true ? e.purviSaptahik! : '-';
      default:
        return '';
    }
  }
  var geoUnitID;
  var geoUnitName;
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
  Future<List<GeoUnitMasterBAL>>  populatelinkedMahaanagarDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
    setState(() {
      _linkedMahaanagar = data;
    });
    return data;
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedNagarValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
    setState(() {
      _linkedBhaag = data;
    });
    return data;
  }
  Future<List<GeoUnitMasterBAL>>  populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParentForVasti(
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
    var vsDD = await Statics.getGeoUnitsByLevelAndParentForVasti
      (Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
    return vsDD;
  }
  void resetData() async {
    setState(() {
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
      _isExpanded = false;
      populateDropdown();
    });
  }
  void getGeoUnitID() async {
    setState(() {
      geoUnitID = Statics.userDetails["DaayitvaGeoUnitID"];
      geoUnitName = Statics.userDetails["DaayitvaGeoUnitName"] + "-" + Statics.userDetails["LevelName"];
    });
  }
  VastiSurveyReportModel? vastiSurveyReportModel;
  Vastisarvekshan? data;
  void getMyDetailsColumnsAndRows() async {

     vastiSurveyReportModel = await Statics.vastisarvekshanReportData(context,Statics.userDetails["userID"], selctedLevelId);
     setState(() {
       data = vastiSurveyReportModel!.vastisarvekshan;
     });
  }

  @override
  Widget build(BuildContext context) {
    final sanghaData = data?.sanghaKaryaStithiData ?? [];
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
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
                          title: Text("स्थर निवडा",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                          trailing: IconButton(onPressed: (){
                            resetData();
                          }, icon: Icon(Icons.refresh,color: Colors.purpleAccent,)),
                        );
                      },
                      body: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            if(_linkedMahaanagar != null)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: "महानगर"),
                                isExpanded: true,
                                value: _linkedMahaanagarValue == "" ? null : _linkedMahaanagarValue,
                                items: _linkedMahaanagar!.map((bg) => DropdownMenuItem(
                                  value: bg.geoUnitID.toString(),
                                  child: Text(bg.name!),
                                )).toList(),
                                onChanged: (value) {
                                  final selectedItem = _linkedMahaanagar!.firstWhere(
                                          (bg) => bg.geoUnitID.toString() == value);
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
                            SizedBox(height: 10,),
                            if (_linkedNagar != null && _linkedNagar!.length > 0)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: "नगर"),
                                isExpanded: true,
                                value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                                items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                onChanged: (value) {
                                  final selectedItem = _linkedNagar!.firstWhere(
                                          (bg) => bg.geoUnitID.toString() == value);
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
                              SizedBox(height: 10,),
                            if (_linkedvasti != null && _linkedvasti!.length > 0)
                              DropdownButtonFormField(
                                decoration: InputDecoration(labelText: "वस्ती"),
                                isExpanded: true,
                                value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                                items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                onChanged: (value) {
                                  final selectedItem = _linkedvasti!.firstWhere(
                                          (bg) => bg.geoUnitID.toString() == value);
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
                            if(selctedLevel == "Vasti")
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent)),
                                  onPressed: (){
                                    if(selctedLevel == "Vasti" || selctedLevel == "Graam" ){
                                      setState(() {
                                        isVastiSearch = true;
                                        _isExpanded = false;
                                      });
                                      print("selctedLevel $selctedLevel -- selctedLevelId $selctedLevelId -- selctedLevelName $selctedLevelName");
                                      getMyDetailsColumnsAndRows();
                                    }else{
                                      Statics.showToast(Statics.getLabel('vastiGramValidation'));
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
              if(selctedLevel == "Vasti" && selctedLevelName != "" && isVastiSearch == true)
                SizedBox(height: 20,),
              if(selctedLevel == "Vasti" && selctedLevelName != "" && isVastiSearch == true)
                Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all(color: Colors.purpleAccent,width: 1),borderRadius: BorderRadius.all(Radius.circular(15)),),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("वस्ती ->  ",style: TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.bold,fontSize: 16),),
                        Text(" $selctedLevelName",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),),
                      ],
                    )),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10,),
                child: Column(
                  children: [
                    commonExpansionTile(
                      title: 'VastiInfo',
                      children: [
                        SingleColumnRow(txtString: "वस्ती प्रमुखांचे नाव", value: data?.vastiPramukhName, fontsize: 15),
                        SingleColumnRow(txtString: "वस्ती समितीत किती सदस्य आहेत", value: data?.vastiSamitiSadhyasyaCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: "वस्तीत सेवा वस्त्यां (किती ?)", value: data?.vastiSewaVastiCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: "वस्तीची लोकसंख्या", value: data?.vastichiLoksankhyaCount, fontsize: 15),
                        SingleColumnRow(txtString: "वस्ती भौगौलिक सीमा", value: data?.vastiBhougolikSima, fontsize: 15),
                        Column(
                  children: [
                    Center(
                      child: Container(
                        width: Statics.getDeviceSize(context).width * 0.84,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text("वस्ती चा नकाशा", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                            ),
                            data?.vastichaNakasha !=""?
                            IconButton(onPressed: (){
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
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(Icons.close, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child:
                                          Image.network('${Statics.baseUrl}/Files/Vastisarvekshanforms/${data?.vastichaNakasha}',fit: BoxFit.contain,),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }, icon: Icon(FontAwesomeIcons.eye,color: Colors.purpleAccent,size: 20,)):
                            Text("N/A", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: Statics.getDeviceSize(context).width,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                        SingleColumnRow(txtString: "अग्निशमन दल केंद्र संख्या", value: data?.vastiFireBrigade == 1 ? "होय":data?.vastiFireBrigade == 0 ? "नाही":"-", fontsize: 15),
                        SingleColumnRow(txtString: "पोलीस ठाणे / चौकी", value: data?.vastiPoliceStation == 1 ? "होय":data?.vastiPoliceStation == 0 ? "नाही":"-", fontsize: 15),

                      ],
                    ),
//-----------------------------------------------------------------------------------------------------------------------
                    commonExpansionTile(
                      title: 'SwayamsevakCount',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('TotalKaaryakartaaCount'), value: data?.totalSwayamsevakCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('PratidnyitCount'), value: data?.pratidnyitCount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SwayamsevakCountByAge',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('Shishu'), value: data?.shishuCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Baal'), value: data?.baalCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('TarunVidyaarthi'), value: data?.tarunVidyaarthiCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('TarunVyavasaayee'), value: data?.tarunVyavasaayeeCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ProudhVyavasaayee'), value: data?.proudhaVyavasaayeeCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('UnkownAge'), value: data?.unknownAgeCount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'ShikshitSwayamsevakCount',
                      children: [
                        SingleColumnRow(txtString: Statics.getLabel('PrarambhikShikshit'), value: data?.prarambhikShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('PraathamikShikshit'), value: data?.praathamikShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('PrathamVarshShikshit'), value: data?.prathamVarshaShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('DwitiyaVarshShikshit'), value: data?.dwitiyaVarshaShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('TrutiyaVarshShikshit'), value: data?.trutiyaVarshaShikshitCount.toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('NoShikshan'), value: data?.noShikshanCount.toString(), fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'KaaryakartaaCountByLevel',
                      children: [
                        TwoColumnRow(
                          txtString: Statics.getLabel('Shaakhaa'),
                          value: data?.dailyShaakhaaKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('SaaptaahikLabelShort'),
                          value2: data?.saaptaahikMilanKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('MilanMandali'),
                          value: data?.maasikMilanKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('VastiKaaryakartaaCount'),
                          value2: data?.vastiKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('GraamKaaryakartaaCount'),
                          value: data?.graamKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('MandalKaaryakartaaCount'),
                          value2: data?.mandalKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('NagarKaaryakartaaCount'),
                          value: data?.nagarKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('ShaharKaaryakartaaCount'),
                          value2: data?.shaharKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('BhaagKaaryakartaaCount'),
                          value: data?.bhaagKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('VibhaagKaaryakartaaCount'),
                          value2: data?.vibhaagKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('MahaanagarKaaryakartaaCount'),
                          value: data?.mahaanagarKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('PraantKaaryakartaaCount'),
                          value2: data?.praantKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('KshetraKaaryakartaaCount'),
                          value: data?.kshetraKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('AkhilBhaaratiyaKaaryakartaaCount'),
                          value2: data?.akhilBhaaratiyaKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),
                        TwoColumnRow(
                          txtString: Statics.getLabel('PravaaseeKaaryakartaaCount'),
                          value: data?.pravaaseeKaaryakartaaCount.toString(),
                          txtString2: Statics.getLabel('TotalKaaryakartaaCount'),
                          value2: data?.totalKaaryakartaaCount.toString(),
                          fontsize: 15,
                        ),],
                    ),
//--------------------------------------------------------------------------------------------------------------------------
                    commonExpansionTile(
                      title: 'GatividhiAayaamSansthaaKaaryakartaaCount',
                      children: [
                        SingleColumnRow(
                            txtString: Statics.getLabel('GatividhiKaaryakartaaCount'),
                            value: data?.gatividhiKaaryakartaaCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('AayaamKaaryakartaaCount'),
                            value: data?.aayaamKaaryakartaaCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('SanghaPreritSansthaaKaaryakartaaCount'),
                            value: data?.sanghaPreritSansthaaKaaryakartaaCount.toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('SocialOrganizationKaaryakartaaCount'),
                            value: data?.socialOrganizationKaaryakartaaCount.toString(),
                            fontsize: 15),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Gatividhi',
                      children: [
                        if (data != null && data!.listKaaryakartaaCountByGatividhi != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
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
                                columns: const [
                                  DataColumn(label: Text('गतिविधी')),
                                  DataColumn(label: Text('कार्यकर्ता संख्या')),
                                ],
                                rows: data!.listKaaryakartaaCountByGatividhi!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.gatividhiName ?? '')),
                                      DataCell(Center( child: Text(item.kaaryakartaaCount.toString() ?? "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                      ],
                    ),
                    commonExpansionTile(
                      title: 'Aayaam',
                      children: [
                        if (data != null && data!.listKaaryakartaaCountByAayaam != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
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
                                columns: const [
                                  DataColumn(label: Text('आयाम')),
                                  DataColumn(label: Text('कार्यकर्ता संख्या')),
                                ],
                                rows: data!.listKaaryakartaaCountByAayaam!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.aayaamName ?? '')),
                                      DataCell(Center( child: Text(item.kaaryakartaaCount.toString() ?? "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'Sangha-PreritSansthaa',
                      children: [
                        if (data != null && data!.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
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
                                columns: const [
                                  DataColumn(label: Text('संघ प्रेरित संघटना/संस्था')),
                                  DataColumn(label: Text('कार्यकर्ता संख्या')),
                                ],
                                rows: data!.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.areaOfOperation ?? '')),
                                      DataCell(Center( child: Text(item.kaaryakartaaCount.toString() ?? "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'OtherSocialOrganization',
                      children: [

                      ],
                    ),
                    commonExpansionTile(
                      title: 'StudentCategory',
                      children: [
                        if (data != null && data!.listSwayamsevakCountByStudentCategory != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
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
                                columns: const [
                                  DataColumn(label: Text('विद्यार्थी श्रेणी')),
                                  DataColumn(label: Text('संख्या')),
                                ],
                                rows: data!.listSwayamsevakCountByStudentCategory!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.studentCategoryName ?? '')),
                                      DataCell(Center( child: Text(item.countByStudentCategory.toString() ?? "0"))),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'VyavasaayeeCategory',
                      children: [
                      ],
                    ),
//----------------------------------------------------------------------------------------------------------------------
                    commonExpansionTile(
                      title: 'sanghaKaryaStithi',
                      children: [
                        if (data != null && data!.sanghaKaryaStithiData != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fixed First Column
                              DataTable(
                                headingRowColor: MaterialStateProperty.all(Colors.purpleAccent[200]),
                                headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                columns: const [
                                  DataColumn(label: Text('संघ कार्य स्थिती')),
                                ],
                                rows: List<DataRow>.generate(
                                  rowTitles.length,
                                      (index) => DataRow(
                                    cells: [DataCell(Text(rowTitles[index]))],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(Colors.purpleAccent[200]),
                                    headingTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    columns: sanghaData.map((e) => DataColumn(label: Text(e.vayogatCode ?? ''))).toList(),
                                    rows: List<DataRow>.generate(
                                      rowTitles.length,
                                          (index) => DataRow(
                                        cells: sanghaData.map((e) {
                                          final value = getCellValueByRowIndex(e, index);
                                          return DataCell(Text(value));
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                    commonExpansionTile(
                      title: 'vasahatPrakar',
                      children: [
                        if (data != null && data!.vastiVasahatPrakar != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                width: 900, // total width of all columns
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  columnSpacing: 20,
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('प्रकार')),
                                    DataColumn(label: Text('भवनाचे नाव')),
                                    DataColumn(label: Text('संपर्क स्थिती')),
                                    DataColumn(label: Text('संपर्क सूत्र नाव')),
                                    DataColumn(label: Text('दूरभाष')),
                                  ],
                                  rows: data!.vastiVasahatPrakar!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.bhavanachenav ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName1 ?? '')),
                                        DataCell(Text(item.samparksootr ?? '')),
                                        DataCell(Text(item.doorabhaash ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),

                      ],
                    ),
                    commonExpansionTile(
                      title: 'BhashaaBolnare',
                      children: [
                        if (data != null && data!.vastiVividhBhashaBolnare != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
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
                                columns: const [
                                  DataColumn(label: Text('भाषा')),
                                  DataColumn(label: Text('अंदाजे किती %')),
                                ],
                                rows: data!.vastiVividhBhashaBolnare!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      DataCell(Text(item.andaje ?? '')),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'kontyaPraantChe',
                      children: [
                        if (data != null && data!.vastiKontyaPraantache != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
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
                                columns: const [
                                  DataColumn(label: Text('प्रांत')),
                                  DataColumn(label: Text('अंदाजे किती %')),
                                ],
                                rows: data!.vastiKontyaPraantache!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      DataCell(Text(item.andaje ?? '')),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'UpsanaSthal',
                      children: [
                        if (data != null && data!.vastiUpasanaSthalInfo != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('उपासना स्थळ ')),
                                    DataColumn(label: Text('प्रकार')),
                                    DataColumn(label: Text('संख्या')),
                                  ],
                                  rows: data!.vastiUpasanaSthalInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName1 ?? '')),
                                        DataCell(Text(item.sankhya ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'SajjanShakti',
                      children: [
                        if (data != null && data!.vastiSajjanShaktiData != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    DataColumn(label: Text('पत्ता')),
                                    DataColumn(label: Text('दूरभाष')),
                                    DataColumn(label: Text('श्रेणी')),
                                    DataColumn(label: Text('संस्था')),
                                    DataColumn(label: Text('संपर्क स्थिती')),
                                    DataColumn(label: Text('प्रभाव क्षेत्र')),
                                    DataColumn(label: Text('संपर्क सूत्र नाव')),
                                  ],
                                  rows: data!.vastiSajjanShaktiData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name  ?? '')),
                                        DataCell(Text(item.address ?? '')),
                                        DataCell(Text(item.doorabhaash ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.sanstheCheNaav ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName1 ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName2 ?? '')),
                                        DataCell(Text(item.samparkasutranava ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'anyaPrabhaviLok',
                      children: [
                        if (data != null && data!.vastiAnyaPrabhaviLok != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    DataColumn(label: Text('पत्ता')),
                                    DataColumn(label: Text('दूरभाष')),
                                    DataColumn(label: Text('श्रेणी')),
                                    DataColumn(label: Text('उपश्रेणी')),
                                    DataColumn(label: Text('उपश्रेणी २')),
                                    DataColumn(label: Text('संपर्क स्थिती')),
                                    DataColumn(label: Text('प्रभाव क्षेत्र')),
                                    DataColumn(label: Text('संपर्क सूत्र नाव')),
                                  ],
                                  rows: data!.vastiAnyaPrabhaviLok!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name  ?? '')),
                                        DataCell(Text(item.address ?? '')),
                                        DataCell(Text(item.doorabhaash ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text("${item.selectedDropdownValueName1} ${item.otherupshrenee != ""?"- ${item.otherupshrenee}": ""}" )),
                                        DataCell(Text("${item.selectedDropdownValueName2} ${item.otherupshrenee2 != ""?"- ${item.otherupshrenee2}": ""}" )),
                                        DataCell(Text(item.selectedDropdownValueName3 ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName4 ?? '')),
                                        DataCell(Text(item.samparkasutranav ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'sajareHonareSan',
                      children: [
                        if (data != null && data!.vastitSajareHonareSan != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('प्रकार')),
                                    DataColumn(label: Text('आयोजक संस्थांची नावे')),
                                    DataColumn(label: Text('आयोजकांची नावे')),
                                  ],
                                  rows: data!.vastitSajareHonareSan!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text("${item.selectedDropdownValueName} ${item.otherSajareSan != ""?"- ${item.otherSajareSan}": ""}" )),
                                        DataCell(Text(item.ayojakasansthacinave ?? '')),
                                        DataCell(Text(item.ayojakancinave ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'sajareHonareKaryakram',
                      children: [
                        if (data != null && data!.vastiSamajikKaryakram != null)
                          Container(
                            // margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('प्रकार')),
                                    DataColumn(label: Text('आयोजक संस्थांची नावे')),
                                    DataColumn(label: Text('आयोजकांची नावे')),
                                  ],
                                  rows: data!.vastiSamajikKaryakram!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text("${item.selectedDropdownValueName} ${item.otherKaryakram != ""?"- ${item.otherKaryakram}": ""}" )),
                                        DataCell(Text(item.ayojakasansthacinave ?? '')),
                                        DataCell(Text(item.ayojakancinave ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'gatividhiUpakraam',
                      children: [
                        if (data != null && data!.vastiGatividhiUpkram != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('गतिविधी')),
                                    DataColumn(label: Text('उपक्रम')),
                                    DataColumn(label: Text('वारंवारिता')),
                                  ],
                                  rows: data!.vastiGatividhiUpkram!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.niyamitacalanareupakrama ?? '')),
                                        DataCell(Text("${item.selectedDropdownValueName1} ${item.otherVaranvarita != ""?"- ${item.otherVaranvarita}": ""}" )),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'JagranShreniUpkram',
                      children: [
                        if (data != null && data!.vastiJagranshreniInfo != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('कार्यविभाग')),
                                    DataColumn(label: Text('उपक्रम')),
                                    DataColumn(label: Text('वारंवारिता')),
                                  ],
                                  rows: data!.vastiJagranshreniInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.niyamitacalanareupakrama ?? '')),
                                        DataCell(Text("${item.selectedDropdownValueName1} ${item.otherVaranvarita != ""?"- ${item.otherVaranvarita}": ""}" )),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'BalopasanaKendra',
                      children: [
                        if (data != null && data!.vastiBalopasanaCenterInfo != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    DataColumn(label: Text('कोणासाठी')),
                                    DataColumn(label: Text('श्रेणी')),
                                  ],
                                  rows: data!.vastiBalopasanaCenterInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.konasathi ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'MotheVyasaayiKendra',
                      children: [
                        if (data != null && data!.vastiMotheVyasayikCenterInfo != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    DataColumn(label: Text('प्रकार')),
                                  ],
                                  rows: data!.vastiMotheVyasayikCenterInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'MotheRugnalay',
                      children: [
                        if (data != null && data!.vastiMotheHospitalInfo != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    DataColumn(label: Text('प्रकार')),
                                  ],
                                  rows: data!.vastiMotheHospitalInfo!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'shaikshanikSanstha',
                      children: [
                        Text("शाळा",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black,),),
                        Divider(),
                        if (data != null && data!.vastiShaikshanikSansthaData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    DataColumn(label: Text('शाळा')),
                                    // DataColumn(label: Text('शाळा प्रकार')),
                                    DataColumn(label: Text('शिक्षणाचे माध्यम')),
                                    DataColumn(label: Text('संस्था चालक प्रकार')),
                                    DataColumn(label: Text('मिळकत')),
                                  ],
                                  rows: data!.vastiShaikshanikSansthaData!
                                      .asMap()
                                      .entries
                                      .where((item) => item.value.shaikshaniksansthaan == 315)
                                      .map((item) {
                                    var data = item.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(data.name ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName1 ?? '')),
                                        // DataCell(Text(data.selectedDropdownValueName2 ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName2 ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName3 ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName4 ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),

                        SizedBox(height: 10,),
                        Text("महाविद्यालय",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black,),),
                        Divider(),
                        if (data != null && data!.vastiShaikshanikSansthaData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    // DataColumn(label: Text('महाविद्यालय')),
                                    DataColumn(label: Text('महाविद्यालय')),
                                    DataColumn(label: Text('मिळकत')),
                                  ],
                                  rows: data!.vastiShaikshanikSansthaData!
                                      .asMap()
                                      .entries
                                      .where((item) => item.value.shaikshaniksansthaan == 316)
                                      .map((item) {
                                    var data = item.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(data.name ?? '')),
                                        // DataCell(Text(data.selectedDropdownValueName ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName1 ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName4 ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 10,),
                        Text("विशिष्ट संस्थान",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black,),),
                        Divider(),
                        if (data != null && data!.vastiShaikshanikSansthaData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    DataColumn(label: Text('मिळकत')),
                                  ],
                                  rows: data!.vastiShaikshanikSansthaData!
                                      .asMap()
                                      .entries
                                      .where((item) => item.value.shaikshaniksansthaan == 317)
                                      .map((item) {
                                    var data = item.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(data.name ?? '')),
                                        DataCell(Text(data.selectedDropdownValueName4 ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'karyakramKarnyacheThikaan',
                      children: [
                        if (data != null && data!.vastiKaryakramcheThikanData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    DataColumn(label: Text('प्रकार')),
                                    DataColumn(label: Text('क्षमता')),
                                    DataColumn(label: Text('निवासासाठी उपलब्ध')),
                                    DataColumn(label: Text('निवास क्षमता')),
                                  ],
                                  rows: data!.vastiKaryakramcheThikanData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.name ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.shamta ?? '')),
                                        DataCell(Text(item.nivasasathiupalabdha == 1 ?"होय":
                                                        item.nivasasathiupalabdha == 0 ?"नाही":
                                                        "")),
                                        DataCell(Text(item.nivaaskshamata ?? '')),

                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'VastiSamajikGarja',
                      children: [
                        if (data != null && data!.vastiSamajikGarajaData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('वस्तीतील सामाजिक\nप्रश्न/गरजा')),
                                    DataColumn(label: Text('तपशील')),
                                  ],
                                  rows: data!.vastiSamajikGarajaData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(child: Text(item.name ?? ''))),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),

                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'DharmikNetrutwa',
                      children: [
                        if (data != null && data!.vastiDharmiknetData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    DataColumn(label: Text('रिलीजन')),
                                  ],
                                  rows: data!.vastiDharmiknetData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(child: Text(item.name ?? ''))),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),

                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'DurjanShakti',
                      children: [
                        if (data != null && data!.vastiDurjanShaktiData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                // width: 300,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('नाव')),
                                    DataColumn(label: Text('प्रकार')),
                                    DataColumn(label: Text('शिक्षा')),
                                    DataColumn(label: Text('गुन्हा')),
                                  ],
                                  rows: data!.vastiDurjanShaktiData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(child: Text(item.name ?? ''))),
                                        DataCell(Text(item.selectedDropdownValueName ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName1 ?? '')),
                                        DataCell(Text(item.selectedDropdownValueName2 ?? '')),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    commonExpansionTile(
                      title: 'HinduVeerYaadi',
                      children: [
                        if (data != null && data!.vastiHinduVeerListData != null)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: SizedBox(
                                width: 250,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.resolveWith(
                                        (states) => Colors.purpleAccent[200],
                                  ),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  columns: const [
                                    DataColumn(
                                      label: Expanded( // ensures center works properly
                                        child: Center(
                                          child: Text(
                                            'नाव',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                  rows: data!.vastiHinduVeerListData!.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Center(child: Text(item.name ?? ''))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
          dividerColor: Colors.transparent, // removes the expansion line
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
