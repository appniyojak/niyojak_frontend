import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/event_card.dart';
import '../widgets/legend.dart';
import '../screens/edit_event.dart';
import '../screens/home_screen.dart';

import '../helpers/static_data.dart' as Statics;
import '../widgets/app_drawer.dart';

class SearchEvent extends StatefulWidget {
  static const routeName = '/search-event-screen';

  @override
  _SearchEventState createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent> with SingleTickerProviderStateMixin {
  Future<List<dynamic>>? _eventList;
  TabController? _tabController;
  bool _isSearching = false;

  final _searchController = TextEditingController();
  DateTime? _fromDate;
  var _fromDateCntrl = TextEditingController();

  DateTime? _toDate;
  var _toDateCntrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _fromDateCntrl.dispose();
    _toDateCntrl.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   _eventList = _getEventList(-1, "get Nothing", null, null);
  // }

  Future<List<dynamic>> _getEventList(int? eventId, String? searchString, String? fromDate, String? toDate) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      return Statics.getEventList(eventId, _searchController.text, fromDate, toDate);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  _pickFromDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _fromDate == null ? DateTime.now() : _fromDate!,
        firstDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) - 80),
        lastDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) + 80));

    if (_toDate != null) {
      if (_toDate!.year < date!.year || _toDate!.month < date.month || _toDate!.day < date.day) {
        Statics.showToast("From date should be less than To Date");
        return;
      }
    }
    setState(() {
      _fromDate = date;
      _fromDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date!);
    });
  }

  _pickToDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _toDate == null ? DateTime.now() : _toDate!,
        firstDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) - 80),
        lastDate: DateTime((_toDate == null ? DateTime.now().year : _toDate!.year) + 80));

    if (_fromDate != null) {
      if (date!.year < _fromDate!.year || date!.month < _fromDate!.month || date!.day < _fromDate!.day) {
        Statics.showToast("From date should be less than To Date");
        return;
      }
    }
    setState(() {
      _toDate = date;
      _toDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date!);
    });
  }

  Future<void> _search() async {
    setState(() {
      _isSearching = true;
    });

    var searchString = _searchController.text;
    var frmDate = _fromDate == null ? null : DateFormat('dd-MM-yyyy').format(_fromDate!);
    var toDate = _toDate == null ? null : DateFormat('dd-MM-yyyy').format(_toDate!);

    setState(() {
      _eventList = _getEventList(null, searchString, frmDate, toDate);
    });
    var data = await _getEventList(null, searchString, frmDate, toDate);
    _tabController!.animateTo(1);

    setState(() {
      _isSearching = false;
    });
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
            Statics.getLabel('searchEventsScreenLabel'),
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
          bottom: new TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                child: Wrap(
                  children: [
                    Icon(FontAwesomeIcons.globe),
                    SizedBox(width: 20),
                    Text(
                      Statics.getLabel("Filters"),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Wrap(
                  children: [
                    Icon(Icons.event),
                    SizedBox(width: 20),
                    Text(
                      Statics.getLabel("searchEventsScreenLabel"),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: AppDrawer(),
        body: ModalProgressHUD(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(children: <Widget>[
                      TextFormField(
                        controller: _searchController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: Statics.getLabel('EventName')),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.7,
                            child: TextField(
                              enabled: false,
                              controller: _fromDateCntrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('FromDate')),
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          IconButton(
                            color: Colors.purple,
                            icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                            onPressed: _pickFromDate,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Statics.getDeviceSize(context).width * 0.7,
                            child: TextField(
                              enabled: false,
                              controller: _toDateCntrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('ToDate')),
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          IconButton(
                            color: Colors.purple,
                            icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                            onPressed: _pickToDate,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Wrap(
                              children: [
                                MaterialButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                  onPressed: _search,
                                  child: Text(
                                    Statics.getLabel('Search'),
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _searchController.text = "";
                                        _fromDateCntrl.text = "";
                                        _toDateCntrl.text = "";
                                        _fromDate = null;
                                        _toDate = null;
                                      });
                                    },
                                    child: Text(Statics.getLabel('clear'))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Legend(legendString: 'EventList', fontsize: 20),
                        FutureBuilder<List<dynamic>>(
                          future: _eventList,
                          builder: (ctx, dataSnapshot) {
                            if (dataSnapshot.hasError) {
                              return Center(
                                  child: Text(
                                'Server Error, Please Try Again Later',
                                style: TextStyle(color: Colors.red),
                              ));
                            }
                            return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                                ? Column(
                                    children: dataSnapshot.data!.map((swItem) => EventCard(swItem, _search)).toList(),
                                  )
                                : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            inAsyncCall: _isSearching),
      ),
    );
  }
}
