import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/calender_card.dart';
import '../widgets/legend.dart';
import '../screens/edit_event.dart';
import '../screens/home_screen.dart';
import '../widgets/app_drawer.dart';

import '../helpers/static_data.dart' as Statics;

class EventCalender extends StatefulWidget {
  static const routeName = '/event-calender';
  @override
  _EventCalenderState createState() => _EventCalenderState();
}

class _EventCalenderState extends State<EventCalender> {
  bool _isSearching = false;

  DateTime? _mnthAndYear;
  var _mnthYearCntrl = TextEditingController();

  Future<List<dynamic>>? _eventList;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    setState(() {
      _mnthAndYear = DateTime.now();
      _mnthYearCntrl.text = DateFormat('MMM-yyyy').format(_mnthAndYear!);
      getEventList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mnthYearCntrl.dispose();
  }

  _pickMnthAndYear() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _mnthAndYear == null ? DateTime.now() : _mnthAndYear!,
        firstDate: DateTime((_mnthAndYear == null ? DateTime.now().year : _mnthAndYear!.year) - 80),
        lastDate: DateTime((_mnthAndYear == null ? DateTime.now().year : _mnthAndYear!.year) + 80));

    if (date != null) {
      setState(() {
        _mnthAndYear = date;
        _mnthYearCntrl.text = DateFormat('MMM-yyyy').format(date);
        getEventList();
      });
    }
  }

  void getEventList() async {
    setState(() {
      _isSearching = true;
    });

    var _month = _mnthAndYear == null ? null : DateFormat('MM').format(_mnthAndYear!);
    var _year = _mnthAndYear == null ? null : DateFormat('yyyy').format(_mnthAndYear!);

    setState(() {
      _eventList = _getEventList(_month!, _year!);
    });
    var data = await _getEventList(_month!, _year!);

    setState(() {
      _isSearching = false;
    });
  }

  Future<List<dynamic>> _getEventList(String _month, String _year) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      return Statics.getCalenderEventsList(null, _month, _year);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('EventCalender'),
            style: TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.all(8),
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditEvent.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: ModalProgressHUD(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  Legend(legendString: "MonthAndYear", fontsize: 18),
                  Row(
                    children: [
                      SizedBox(
                        width: Statics.getDeviceSize(context).width * 0.7,
                        child: TextField(
                          enabled: false,
                          controller: _mnthYearCntrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('MonthAndYear')),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      IconButton(
                        iconSize: 30,
                        color: Colors.purple,
                        icon: FaIcon(FontAwesomeIcons.calendarWeek),
                        onPressed: _pickMnthAndYear,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Legend(legendString: "EventList", fontsize: 18),
                  FutureBuilder<List<dynamic>>(
                    future: _eventList,
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.hasError) {
                        return Center(
                            child: Text(
                          'Server Error, Please Try Again Later',
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ));
                      }
                      return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                          ? Column(
                              children: dataSnapshot.data!.map((swItem) => CalenderCard(swItem, getEventList)).toList(),
                            )
                          : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                    },
                  ),
                ]),
              ),
            ),
            inAsyncCall: _isSearching),
      ),
    );
  }
}
