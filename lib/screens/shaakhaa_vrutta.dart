import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../screens/edit_shaakhaa_vrutta.dart';
import '../widgets/legend.dart';

class ShaakhaaVrutta extends StatefulWidget {
  static const String routeName = '/shaakhaa-vrutta-screen';

  @override
  _ShaakhaaVruttaState createState() => _ShaakhaaVruttaState();
}

class _ShaakhaaVruttaState extends State<ShaakhaaVrutta> {
  Statics.ScreenArguments? args;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var shaakhaaID;
  var viewType;
  List<Widget>? _headerRow;
  List<ShaakhaaVruttaBAL> lstShaakhaaVrutta = [];

  var vayogatCode = '', shaakhaaName = '';

  // List<String> lst1 = ['Bhaag', 'भाग/जिल्हा', 'Nagar', 'नगर/तालुका'];
  List<String> lst2 = [
    'Kaaryavaah',
    'कार्यवाह',
    'Saha-Kaaryavaah',
    'सह कार्यवाह',
    'Kaaryaalay Pramukh',
    'कार्यालय प्रमुख',
    'Mandal Samiti Sadasya',
    'मंडल समिती सदस्य',
    'App Sanyojak',
    'एप संयोजक',
    'सह कार्यालय प्रमुख',
    'शाखा कार्यवाह',
    'साप्ताहिक मिलन प्रमुख',
    'साप्ताहिक मिलन सह प्रमुख',
    'मासिक मिलन प्रमुख',
    'मासिक मिलन सह प्रमुख',
    'Baal Vidyaarthi Pramukh',
    'बाल विद्यार्थी प्रमुख',
    'बाल विद्यार्थी प्रमुख',
    'Mahaavidyaalayeen Vidyaarthi Pramukh',
    'महाविद्यालयीन प्रमुख',
    'महाविद्यालयीन प्रमुख',
    'Vyavasaayee Pramukh',
    'व्यवसायी प्रमुख',
    'व्यवसायी प्रमुख',
    'Vyavasaayee Saha-Pramukh',
    'व्यवसायी सह प्रमुख',
    'व्यवसायी सह प्रमुख'
  ];
  List<String> lst3 = [
    'Mukhya Shikshak',
    'मुख्य शिक्षक',
    'Kaaryavaah',
    'कार्यवाह',
    'Milan Pramukh',
    'मिलन प्रमुख',
    'Milan Saha-Pramukh',
    'मिलन सह प्रमुख',
    'सह कार्यालय प्रमुख',
    'शाखा कार्यवाह',
    'साप्ताहिक मिलन प्रमुख',
    'साप्ताहिक मिलन सह प्रमुख',
    'मासिक मिलन प्रमुख',
    'मासिक मिलन सह प्रमुख',
    'Baal Vidyaarthi Pramukh',
    'बाल विद्यार्थी प्रमुख',
    'बाल विद्यार्थी प्रमुख',
    'Mahaavidyaalayeen Vidyaarthi Pramukh',
    'महाविद्यालयीन प्रमुख',
    'महाविद्यालयीन प्रमुख',
    'Vyavasaayee Pramukh',
    'व्यवसायी प्रमुख',
    'व्यवसायी प्रमुख',
    'Vyavasaayee Saha-Pramukh',
    'व्यवसायी सह प्रमुख',
    'व्यवसायी सह प्रमुख'
  ];
  List<String> lst4 = [
    'Prachaarak',
    'प्रचारक',
    'Saha-Prachaarak',
    'सह प्रचारक',
    'सह कार्यालय प्रमुख',
    'शाखा कार्यवाह',
    'साप्ताहिक मिलन प्रमुख',
    'साप्ताहिक मिलन सह प्रमुख',
    'मासिक मिलन प्रमुख',
    'मासिक मिलन सह प्रमुख' 'Baal Vidyaarthi Pramukh',
    'बाल विद्यार्थी प्रमुख',
    'बाल विद्यार्थी प्रमुख',
    'Mahaavidyaalayeen Vidyaarthi Pramukh',
    'महाविद्यालयीन प्रमुख',
    'महाविद्यालयीन प्रमुख',
    'Vyavasaayee Pramukh',
    'व्यवसायी प्रमुख',
    'व्यवसायी प्रमुख',
    'Vyavasaayee Saha-Pramukh',
    'व्यवसायी सह प्रमुख',
    'व्यवसायी सह प्रमुख'
  ];

  bool _isFetchingData = false;

  var _isFirstCall = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstCall == true) {
      args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments;
      shaakhaaID = args!.itemID;
      viewType = args!.viewType;

      _getVruttaList();
      print("DaayitvaName -> ${Statics.userDetails['DaayitvaName']} == LevelName -> ${Statics.userDetails['LevelName']}");
    }
    _isFirstCall = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getVruttaList() async {
    if (!mounted) return;
    setState(() {
      _isFetchingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();

    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await Statics.getShaakhaaVruttaListForApp(shaakhaaID, null);

      await populateShaakhaVayogat(shaakhaaID.toString());
      if (data.length > 0) {
        lstShaakhaaVrutta = [];
        for (var dataItem in data) {
          lstShaakhaaVrutta.add(ShaakhaaVruttaBAL.fromMap(dataItem));
        }
        await getDetailsColumnsandRows(data);
      } else {
        if (!mounted) return;
        // setState(() {
        //   _detailscolumns = null;
        // });
      }
      if (!mounted) return;
      setState(() {
        _isFetchingData = false;
      });
    }
  }

  Widget _shaakhaaVruttaFirstColumn(BuildContext context, int index) {
    return Statics.createWidgetFromString(context, DateFormat('dd-MMM-yyyy').format(DateFormat("yyyy/MM/dd").parse(lstShaakhaaVrutta[index].vruttaDate!)), 100, 52, Alignment.centerLeft,
        isTotalRow: false);
  }

  Widget _shaakhaaVruttaOtherColumns(BuildContext context, int index) {
    var widgetArray = <Widget>[
      Statics.createWidgetFromString(context, lstShaakhaaVrutta[index].shishuCount.toString(), 60, 52, Alignment.center, isTotalRow: false),
      Statics.createWidgetFromString(context, lstShaakhaaVrutta[index].baalVidyaarthiCount.toString(), 60, 52, Alignment.center, isTotalRow: false),
      Statics.createWidgetFromString(context, lstShaakhaaVrutta[index].tarunVidyaarthiCount.toString(), 60, 52, Alignment.center, isTotalRow: false),
      Statics.createWidgetFromString(context, lstShaakhaaVrutta[index].tarunVyavasaayeeCount.toString(), 60, 52, Alignment.center, isTotalRow: false),
      Statics.createWidgetFromString(context, lstShaakhaaVrutta[index].proudhaVyavasaayeeCount.toString(), 60, 52, Alignment.center, isTotalRow: false),
    ];
    if (vayogatCode == 'Proudh Vyavasaayee') {
      widgetArray.add(lstShaakhaaVrutta[index].isDoneDeepBreathing == true
          ? Statics.createWidgetFromIcon(context, Icons.check, 80, 52, Alignment.center, isTotalRow: false)
          : Statics.createWidgetFromString(context, '-', 80, 52, Alignment.center, isTotalRow: false));
    } else {
      widgetArray.add(lstShaakhaaVrutta[index].isDoneDandaPrahaar == true
          ? Statics.createWidgetFromIcon(context, Icons.check, 80, 52, Alignment.center, isTotalRow: false)
          : Statics.createWidgetFromString(context, '-', 80, 52, Alignment.center, isTotalRow: false));
      widgetArray.add(lstShaakhaaVrutta[index].isDoneSooryaNamaskaar == true
          ? Statics.createWidgetFromIcon(context, Icons.check, 80, 52, Alignment.center, isTotalRow: false)
          : Statics.createWidgetFromString(context, '-', 80, 52, Alignment.center, isTotalRow: false));
      widgetArray.add(lstShaakhaaVrutta[index].isDoneSanchalanAbhyaas == true
          ? Statics.createWidgetFromIcon(context, Icons.check, 80, 52, Alignment.center, isTotalRow: false)
          : Statics.createWidgetFromString(context, '-', 80, 52, Alignment.center, isTotalRow: false));
    }

    widgetArray.add(lstShaakhaaVrutta[index].isDoneSaanghikGeet == true
        ? Statics.createWidgetFromIcon(context, Icons.check, 80, 52, Alignment.center, isTotalRow: false)
        : Statics.createWidgetFromString(context, '-', 80, 52, Alignment.center, isTotalRow: false));
    widgetArray.add(lstShaakhaaVrutta[index].isDoneAmrutaVachan == true
        ? Statics.createWidgetFromIcon(context, Icons.check, 70, 52, Alignment.center, isTotalRow: false)
        : Statics.createWidgetFromString(context, '-', 70, 52, Alignment.center, isTotalRow: false));
    widgetArray.add(lstShaakhaaVrutta[index].isDoneSubhaashit == true
        ? Statics.createWidgetFromIcon(context, Icons.check, 60, 52, Alignment.center, isTotalRow: false)
        : Statics.createWidgetFromString(context, '-', 60, 52, Alignment.center, isTotalRow: false));
    widgetArray.add(lstShaakhaaVrutta[index].isOptionalShaaririk == true
        ? Statics.createWidgetFromIcon(context, Icons.check, 100, 52, Alignment.center, isTotalRow: false)
        : Statics.createWidgetFromString(context, '-', 100, 52, Alignment.center, isTotalRow: false));
    widgetArray.add(lstShaakhaaVrutta[index].isOptionalOther == true
        ? Statics.createWidgetFromIcon(context, Icons.check, 100, 52, Alignment.center, isTotalRow: false)
        : Statics.createWidgetFromString(context, '-', 100, 52, Alignment.center, isTotalRow: false));
    if ((
            // lst1.contains(Statics.userDetails['LevelName']) &&
            lst2.contains(Statics.userDetails['DaayitvaName'])) ||
        (Statics.userDetails['LevelName'] == 'Shaakhaa' || Statics.userDetails['LevelName'] == 'शाखा' && lst3.contains(Statics.userDetails['DaayitvaName'])) ||
        lst4.contains(Statics.userDetails['DaayitvaName'])) {
      widgetArray.add(Container(
          width: 70,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                iconSize: 20,
                color: Colors.purple,
                onPressed: () => _onEditVrutta(lstShaakhaaVrutta[index].shaakhaaVruttaID.toString(), lstShaakhaaVrutta[index].shaakhaaID.toString()),
              ),
            ],
          )));
      widgetArray.add(Container(
          width: 70,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                iconSize: 20,
                color: Colors.purple,
                onPressed: () => _onDeleteVrutta(lstShaakhaaVrutta[index].shaakhaaVruttaID.toString()),
              ),
            ],
          )));
    }
    return Row(
      children: widgetArray,
    );
  }

  populateShaakhaVayogat(shaakhaaID) async {
    print("populateShaakhaVayogat : -- $shaakhaaID");
    var data = await Statics.getShaakhaaByID(shaakhaaID);
    var vayogatList = await Statics.getStaticLDB('ShaakhaaVayogat');
    if (data != null) {
      ShaakhaaMasterBAL shaakhaa = data;
      var vCode = vayogatList[vayogatList.indexWhere((e) => e.staticID == shaakhaa.vayogatID)].code;
      setState(() {
        vayogatCode = vCode!;
        shaakhaaName = shaakhaa.geoUnitName!;
      });
    }
  }

  getDetailsColumnsandRows(List<dynamic> dataList) async {
    List<Widget> headerRow = [];
    headerRow.add(Statics.createWidgetFromString(context, 'दिनांक', 100, 56, Alignment.centerLeft, isTotalRow: false));
    headerRow.add(Statics.createWidgetFromString(context, 'शिशु', 60, 56, Alignment.center, isTotalRow: false));
    headerRow.add(Statics.createWidgetFromString(context, 'बाल', 60, 56, Alignment.center, isTotalRow: false));
    headerRow.add(Statics.createWidgetFromString(context, 'त.वि.', 60, 56, Alignment.center, isTotalRow: false));
    headerRow.add(Statics.createWidgetFromString(context, 'त.व्य.', 60, 56, Alignment.center, isTotalRow: false));
    headerRow.add(Statics.createWidgetFromString(context, 'प्रौ.', 60, 56, Alignment.center, isTotalRow: false));
    if (vayogatCode == 'Proudh Vyavasaayee') {
      headerRow.add(Statics.createWidgetFromString(context, 'दीर्घश्वसन', 80, 56, Alignment.centerLeft, isTotalRow: false));
    } else {
      headerRow.add(Statics.createWidgetFromString(context, 'दंडप्रहार', 80, 56, Alignment.centerLeft, isTotalRow: false));
      headerRow.add(Statics.createWidgetFromString(context, 'सूर्यनमस्कार', 80, 56, Alignment.centerLeft, isTotalRow: false));
      headerRow.add(Statics.createWidgetFromString(context, 'संचलन अभ्यास', 80, 56, Alignment.centerLeft, isTotalRow: false));
    }
    headerRow.add(Statics.createWidgetFromString(context, 'सांघिक गीत', 80, 56, Alignment.center, isTotalRow: false));
    headerRow.add(Statics.createWidgetFromString(context, 'अमृतवचन', 70, 56, Alignment.center, isTotalRow: false));
    headerRow.add(Statics.createWidgetFromString(context, 'सुभाषित', 60, 56, Alignment.center, isTotalRow: false));
    headerRow.add(Statics.createWidgetFromString(context, 'वैकल्पिक शारीरिक विषय', 100, 56, Alignment.centerLeft, isTotalRow: false));
    headerRow.add(Statics.createWidgetFromString(context, 'अन्य वैकल्पिक कार्यक्रम', 100, 56, Alignment.centerLeft, isTotalRow: false));

    if ((
            // lst1.contains(Statics.userDetails['LevelName']) &&
            lst2.contains(Statics.userDetails['DaayitvaName'])) ||
        (Statics.userDetails['LevelName'] == 'Shaakhaa' || Statics.userDetails['LevelName'] == 'शाखा' && lst3.contains(Statics.userDetails['DaayitvaName'])) ||
        lst4.contains(Statics.userDetails['DaayitvaName'])) {
      headerRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Edit'), 70, 56, Alignment.centerLeft, isTotalRow: false));
      headerRow.add(Statics.createWidgetFromString(context, Statics.getLabel('Delete'), 70, 56, Alignment.centerLeft, isTotalRow: false));
    }

    if (!mounted) return;
    setState(() {
      _headerRow = headerRow;
    });
  }

  void _onEditVrutta(vruttaID, shaakhaaid) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditShaakhaaVrutta(
                  shaakhaaID: shaakhaaid.toString(),
                  vruttaID: vruttaID,
                  onSaveDetails: _getVruttaList,
                  viewType: "EditVrutta",
                )));
  }

  void _onDeleteVrutta(vruttaID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({"ShaakhaaVruttaID": vruttaID});
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteVrutta')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteShaakhaaVrutta(inputData);
                  if (data == "Shaakhaa Vrutta Deleted Successfully ") {
                    Statics.showToast(Statics.getLabel('ShaakhaaVruttaDeletedSuccessfully'));

                    _getVruttaList();
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteVrutta'));

                  Navigator.of(ctx).pop();
                },
              ),
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel('Vrutta'),
          style: TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          if ((
                  // lst1.contains(Statics.userDetails['LevelName']) &&
                  lst2.contains(Statics.userDetails['DaayitvaName'])) ||
              (Statics.userDetails['LevelName'] == 'Shaakhaa' || Statics.userDetails['LevelName'] == 'शाखा' && lst3.contains(Statics.userDetails['DaayitvaName'])) ||
              lst4.contains(Statics.userDetails['DaayitvaName']))
            IconButton(
              padding: EdgeInsets.all(8),
              icon: const Icon(Icons.add),
              onPressed: () => _onEditVrutta("0", shaakhaaID),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: Statics.getDeviceSize(context).width,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Legend(legendString: 'VruttaDetails', extraString: shaakhaaName, fontsize: 18),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: Statics.getDeviceSize(context).height * (_headerRow != null ? 0.80 : 0.07),
                  width: Statics.getDeviceSize(context).width,
                  child: _isFetchingData == true
                      ? Column(
                          children: [CircularProgressIndicator()],
                        )
                      : _headerRow != null
                          ? HorizontalDataTable(
                              leftHandSideColumnWidth: 100,
                              rightHandSideColumnWidth: (vayogatCode == 'Proudh Vyavasaayee' ? 930 : 1090),
                              isFixedHeader: true,
                              headerWidgets: _headerRow,
                              leftSideItemBuilder: _shaakhaaVruttaFirstColumn,
                              rightSideItemBuilder: _shaakhaaVruttaOtherColumns,
                              itemCount: (lstShaakhaaVrutta == null ? 0 : lstShaakhaaVrutta.length),
                              rowSeparatorWidget: const Divider(
                                color: Colors.black54,
                                height: 1.0,
                                thickness: 0.0,
                              ),
                              leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                              rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                            )
                          : Column(
                              children: [
                                Text(
                                  Statics.getLabel('NoDataFound'),
                                  style: TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
