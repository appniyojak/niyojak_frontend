import 'package:flutter/material.dart';
import '../screens/edit_soochi.dart';
import '../widgets/sooochi_card.dart';

import '../helpers/static_data.dart' as Statics;
import '../widgets/app_drawer.dart';

class SearchSoochiScreen extends StatefulWidget {
  static const routeName = '/search-soochi-screen';

  @override
  _SearchSoochiScreenState createState() => _SearchSoochiScreenState();
}

class _SearchSoochiScreenState extends State<SearchSoochiScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isExpanded = false;
  bool _includeOwnedSoochi = true;
  bool _includeSharedSoochi = true;

  Future<List<dynamic>>? _soochiList;

  Future<List<dynamic>> _getSoochiList(String searchString, bool includeOwnedSoochi, bool includeSharedSoochi) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      return Statics.getSoochiList(searchString, includeOwnedSoochi, includeSharedSoochi);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _soochiList = _getSoochiList(" ", _includeOwnedSoochi, _includeSharedSoochi);
    // _soochiList = _getSoochiList("Get Nothing", _includeOwnedSoochi, _includeSharedSoochi);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _isSearching = true;
    });

    var searchString = _searchController.text;

    setState(() {
      _soochiList = _getSoochiList(searchString, _includeOwnedSoochi, _includeSharedSoochi);
      _isSearching = false;
      _isExpanded = false;
    });
    print(_soochiList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('searchSoochiScreenLabel'),
            style: TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.all(8),
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditSoochiScreen.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                Statics.getLabel('searchSoochiScreenBanner'),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isExpanded = isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(Statics.getLabel('Filters')),
                      );
                    },
                    body: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 10,
                            ),
                            width: Statics.getDeviceSize(context).width * 0.85, //300,
                            child: TextFormField(
                              controller: _searchController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(labelText: Statics.getLabel('SoochiName') + '/' + Statics.getLabel('MemberName')),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(Statics.getLabel('IncludeOwnedSoochi'), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _includeOwnedSoochi == null ? false : _includeOwnedSoochi,
                            onChanged: (value) {
                              setState(() {
                                _includeOwnedSoochi = value!;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(Statics.getLabel('IncludeSharedSoochi'), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _includeSharedSoochi == null ? false : _includeSharedSoochi,
                            onChanged: (value) {
                              setState(() {
                                _includeSharedSoochi = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    isExpanded: _isExpanded,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (_isSearching)
                      CircularProgressIndicator()
                    else
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
                                });
                              },
                              child: Text(Statics.getLabel('clear'))),
                        ],
                      ),
                  ],
                ),
              ),
              FutureBuilder<List<dynamic>>(
                future: _soochiList,
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (dataSnapshot.hasError) {
                    return Center(
                        child: Text(
                      'Server Error, Please Try Again Later',
                      style: TextStyle(color: Colors.red),
                    ));
                  }
                  return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                      ? Column(
                          children: dataSnapshot.data!.map((soochi) => SocchiCard(soochi, _search)).toList(),
                        )
                      : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                },
              ),
            ],
          ),
        ));
  }
}
