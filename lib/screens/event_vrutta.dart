import 'dart:convert';

import 'package:flutter/material.dart';
import '../widgets/legend.dart';

import '../helpers/static_data.dart' as Statics;

class EventVrutta extends StatefulWidget {
  static const String routeName = '/event-vrutta-screen';
  @override
  _EventVruttaState createState() => _EventVruttaState();
}

class _EventVruttaState extends State<EventVrutta> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Statics.ScreenArguments? args;
  var eventID;
  var viewType;

  var _isFirstCall = true;

  bool _isfetingData = false;

  List<DataColumn>? _detailscolumns;
  List<DataRow>? _detailsrows;

  var _titleCntrl = TextEditingController();
  var _vruttaDetailsCntrl = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstCall == true) {
      args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments;
      eventID = args!.itemID;
      viewType = args!.viewType;
    print("viewType ==> $viewType");
      _getVruttaList();
    }
    _isFirstCall = false;
  }

  @override
  void dispose() {
    super.dispose();
    _titleCntrl.dispose();
    _vruttaDetailsCntrl.dispose();
  }

  Future<void> _getVruttaList() async {
    setState(() {
      _isfetingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await Statics.getEventVruttaList(eventID, null);
      if (data.length > 0) {
        await getDetailsColumnsandRows(data);
        //await getCsv(details);
      } else {
        if (!mounted) return;
        setState(() {
          _detailscolumns = null;
        });
      }
      if (!mounted) return;
      setState(() {
        _isfetingData = false;
      });
    }
  }

  getDetailsColumnsandRows(List<dynamic> dataList) async {
    List<DataColumn> cols = [];

    cols.add(new DataColumn(label: Text(Statics.getLabel('Title'))));
    cols.add(new DataColumn(label: Text(Statics.getLabel('VruttaDetails'))));
    if (viewType == "EditVrutta") {
      cols.add(new DataColumn(label: Text(Statics.getLabel('Edit') + "/" + Statics.getLabel('Delete'))));
      //cols.add(new DataColumn(label: Text(Statics.getLabel('Delete'))));
    }

    List<DataRow> row = [];
    for (var data in dataList) {
      List<DataCell> cells = [];
      cells.add(new DataCell(Container(
          width: Statics.getDeviceSize(context).width * (viewType == "EditVrutta" ? 0.20 : 0.45), child: Text(data["BinduTitle"].toString()))));

      cells.add(new DataCell(
          Container(
              margin: EdgeInsets.all(5),
              width: Statics.getDeviceSize(context).width * (viewType == "EditVrutta" ? 0.30 : 0.45),
              child: Text(data["VruttaDetail"].toString().length > 25
                  ? (data["VruttaDetail"].toString().substring(0, 25) + "...")
                  : data["VruttaDetail"].toString())), onTap: () {
        Statics.showMessageDialog(context, data["VruttaDetail"].toString(), title: Statics.getLabel('VruttaDetails'));
      }));
      if (viewType == "EditVrutta") {
        cells.add(new DataCell(Container(
            width: Statics.getDeviceSize(context).width * 0.28,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  iconSize: 20,
                  color: Colors.purple,
                  onPressed: () {
                    _onEditVrutta(data["EventVruttaID"].toString(), data["EventID"].toString());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 20,
                  color: Colors.purple,
                  onPressed: () {
                    _onDeleteVrutta(data["EventVruttaID"].toString(), data["EventID"].toString());
                  },
                ),
              ],
            ))));
      }
      row.add(new DataRow(cells: cells));
    }
    if (!mounted) return;
    setState(() {
      _detailscolumns = cols;
      _detailsrows = row;
    });
  }

  void _onEditVrutta(vruttaID, eventid) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        if (vruttaID != "0") {
          _getVruttalDetails(eventid, vruttaID);
        } else {
          _titleCntrl.text = "";
          _vruttaDetailsCntrl.text = "";
        }
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(Statics.getLabel('Vrutta')),
                  content: Container(
                    height: Statics.getDeviceSize(context).height * 0.40,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _titleCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('Title')),
                            keyboardType: TextInputType.text,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            minLines: 3,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            controller: _vruttaDetailsCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('VruttaDetails')),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text('Submit'),
                      onPressed: () async {
                        if (_titleCntrl.text.trim() == "") {
                          return Statics.showToast(Statics.getLabel('TitleValidationMessage'));
                        }
                        if (_vruttaDetailsCntrl.text.trim() == "") {
                          return Statics.showToast(Statics.getLabel('VruttaDetailsValidationMessage'));
                        }
                        var inputData = json.encode({
                          "EventVruttaID": vruttaID,
                          "PraantID": 1,
                          "EventID": eventid,
                          "BinduTitle": _titleCntrl.text,
                          "VruttaDetail": _vruttaDetailsCntrl.text
                        });

                        var data = await Statics.saveEventVruttaForApp(
                            '{"ListEventVrutta": [' + inputData + '],"ModifiedBy": ' + Statics.userDetails["userID"] + '}');
                        if (data == "Event Vrutta Saved Successfully ") {
                          Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
                        } else
                          Statics.showToast(Statics.getLabel('unableToCompleteProcess'));

                        _titleCntrl.text = "";
                        _vruttaDetailsCntrl.text = "";
                        _getVruttaList();
                        Navigator.of(ctx).pop();
                      },
                    ),
                    MaterialButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        _titleCntrl.text = "";
                        _vruttaDetailsCntrl.text = "";
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
  }

  void _onDeleteVrutta(vruttaID, eventID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({"EventVruttaID": vruttaID, "ModifiedBy": Statics.userDetails["userID"]});
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteVrutta')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteEventVrutta(inputData);
                  if (data == "Event Vrutta Deleted Successfully ") {
                    Statics.showToast(Statics.getLabel('EventVruttaDeletedSuccessfully'));

                    _getVruttaList();
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteVrutta'));

                  Navigator.of(ctx).pop();
                },
              ),
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationNo')),
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

  void _getVruttalDetails(eventid, vruttaID) async {
    var data = await Statics.getEventVruttaList(eventid, vruttaID);
    if (data.length > 0) {
      _titleCntrl.text = data[0]["BinduTitle"].toString();
      _vruttaDetailsCntrl.text = data[0]["VruttaDetail"].toString();
    } else {
      _titleCntrl.text = "";
      _vruttaDetailsCntrl.text = "";
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
          if (viewType == "EditVrutta")
            IconButton(
              padding: EdgeInsets.all(8),
              icon: const Icon(Icons.add),
              onPressed: () {
                _onEditVrutta(0, eventID);
              },
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
                Legend(legendString: 'VruttaDetails', fontsize: 18),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: Statics.getDeviceSize(context).height,
                  width: Statics.getDeviceSize(context).width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [if(_detailscolumns!= null)
                          DataTable(
                            columnSpacing: 20,
                            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                            columns: _detailscolumns!,
                            rows: _detailsrows!,
                          ),
                        ],
                      ),
                    ),
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
