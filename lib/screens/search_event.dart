import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/event_master_list_resp_model.dart';
import '../screens/edit_event.dart';
import '../widgets/app_drawer.dart';
import '../widgets/event_card.dart';

class SearchEvent extends StatefulWidget {
  static const routeName = '/search-event-screen';

  @override
  _SearchEventState createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent> with TickerProviderStateMixin {
  List<EventMaster> _eventList = [];
  late TabController _tabController;
  late TabController _tabController2;
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
    _tabController2 = new TabController(length: 2, vsync: this);
    _tabController?.addListener(_handleTabChange);
    _tabController2?.addListener(_handleTabChange);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  initData() async {
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null && args != "0") {
      await _search(eventId: int.tryParse(args) ?? 0);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabChange);
    _tabController2?.removeListener(_handleTabChange);
    _searchController.dispose();
    _fromDateCntrl.dispose();
    _toDateCntrl.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   _eventList = _getEventList(-1, "get Nothing", null, null);
  // }

  _pickFromDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _fromDate == null ? DateTime.now() : _fromDate!,
        firstDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) - 80),
        lastDate: DateTime((_fromDate == null ? DateTime.now().year : _fromDate!.year) + 80));

    if (_toDate != null) {
      if (_toDate!.isBefore(date!)) {
        Statics.showToast(Statics.getLabel("fromDateValidation"));
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
      if (date!.isBefore(_fromDate!)) {
        Statics.showToast(Statics.getLabel("toDateValidation"));
        return;
      }
    }
    setState(() {
      _toDate = date;
      _toDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date!);
    });
  }

  Future<void> _search({int? eventId, int? isfuture}) async {
    _eventList = [];
    setState(() {
      _isSearching = true;
    });

    var searchString = _searchController.text;
    var frmDate = _fromDate == null ? null : DateFormat('dd-MM-yyyy').format(_fromDate!);
    var toDate = _toDate == null ? null : DateFormat('dd-MM-yyyy').format(_toDate!);

    final _isFutureByDate = (_fromDate?.isAfter(DateTime.now()) ?? false) || (_toDate?.isAfter(DateTime.now()) ?? false);

    final _isFuture = isfuture ?? (_fromDate == null && _toDate == null ? 1 : (_isFutureByDate ? 1 : 0));

    final _list = await Statics.getEventList(
      eventID: eventId == 0 ? null : eventId,
      searchPattern: searchString,
      fromDate: frmDate,
      toDate: toDate,
      isfuture: _isFuture,
    );

    setState(() {
      _eventList!.addAll(_list);
    });
    _tabController!.animateTo(1);
    if (_isFuture != 1) _tabController2!.animateTo(1);

    setState(() {
      _isSearching = false;
    });
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {}); // Rebuilds to update the PopScope's allowed status
    }
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
                              readOnly: true,
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
                              readOnly: true,
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
                Column(
                  spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 24),
                    TabBar(
                      controller: _tabController2,
                      indicatorColor: Colors.purple,
                      dividerColor: Colors.transparent,
                      // indicator: BoxDecoration(color: Colors.purple),
                      // indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.purple,
                      onTap: (value) => _search(isfuture: value == 0 ? 1 : 0),
                      tabs: <Widget>[
                        Tab(
                          text: Statics.getLabel("upcomingEventLabel"),
                        ),
                        Tab(
                          text: Statics.getLabel("completedEventLabel"),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(controller: _tabController2, physics: NeverScrollableScrollPhysics(), children: [
                        _eventList == null
                            ? Center(
                                child: Text(
                                'Server Error, Please Try Again Later',
                                style: TextStyle(color: Colors.red),
                              ))
                            : _eventList!.isNotEmpty
                                ? SingleChildScrollView(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      spacing: 12,
                                      children: _eventList!
                                          .map((swItem) => EventCard(
                                                swItem,
                                                _search,
                                                // key: ValueKey("${swItem.eventID}_${swItem.ownerSwayamsevakID}"),
                                              ))
                                          .toList(),
                                    ),
                                  )
                                : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch'))),

                        //2
                        _eventList == null
                            ? Center(
                                child: Text(
                                'Server Error, Please Try Again Later',
                                style: TextStyle(color: Colors.red),
                              ))
                            : _eventList!.isNotEmpty
                                ? SingleChildScrollView(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      spacing: 12,
                                      children: _eventList!.map((swItem) => EventCard(swItem, () => _search(isfuture: 0))).toList(),
                                    ),
                                  )
                                : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')))
                      ]),
                    )
                  ],
                ),
              ],
            ),
            inAsyncCall: _isSearching),
      ),
    );
  }
}
