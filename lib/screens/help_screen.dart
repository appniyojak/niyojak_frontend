import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_drawer.dart';

import '../helpers/static_data.dart' as Statics;

class HelpScreen extends StatefulWidget {
  static const String routeName = '/help-screen';
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  Future<List<dynamic>>? _helpVideoList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _helpVideoList = _getHelpVideoList();
  }

  Future<List<dynamic>> _getHelpVideoList() async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
      });
      return Statics.getHelpVideoList(strInput);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  Widget _createCard(String label, String buttonLabel, String videoLink) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(child: Text(label)),
              TextButton(
                child: Text(buttonLabel),
                onPressed: () {
                  launch(videoLink);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            _getHelpVideoList();
          },
          child: Text(
            Statics.getLabel('helpScreenTitle'),
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(7),
              //height: Statics.getDeviceSize(context).height,
              width: Statics.getDeviceSize(context).width,
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  FutureBuilder<List<dynamic>>(
                    future: _helpVideoList,
                    builder: (ctx, dataSnapshot) {
                      //print(dataSnapshot.connectionState.toString());
                      //print(dataSnapshot.hasData.toString());
                      //print(_isSearching.toString());
                      if (dataSnapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (dataSnapshot.hasError) {
                        return Center(
                            child: Text(
                          'Server Error, Please Try Again Later',
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ));
                      }
                      return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                          ? Column(
                              children: dataSnapshot.data!
                                  .map((videoObj) => _createCard(videoObj['ResourceLabel'], videoObj['ButtonLabel'], videoObj['ResourceLink']))
                                  .toList(),
                            )
                          : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                    },
                  ),
                ],
              )))),
    );
  }
}
