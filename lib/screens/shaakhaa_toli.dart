import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:niyojak_prod/widgets/legend.dart';
import '../widgets/shaakhaaToli_card.dart';
import '../helpers/static_data.dart' as Statics;

class ShaakhaaToli extends StatefulWidget {
  static const routeName = '/shaakhaa-toli-screen';

  @override
  _ShaakhaaToliState createState() => _ShaakhaaToliState();
}

class _ShaakhaaToliState extends State<ShaakhaaToli> {
  bool _isSearching = false;
  String strShaakhaaName = "";

  Future<List<dynamic>>? _shaakhaaToliList;
  Statics.ScreenArguments? args;
  var theId;
  var viewType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments;
    theId = args!.itemID;
    viewType = args!.viewType;

    _shaakhaaToliList = _getShaakhaaToliSadasyaForApp(theId.toString(), viewType);
  }

  void getShaakhaaToli(theId) async {
    _shaakhaaToliList = null;
    setState(() {
      _isSearching = true;
    });
    setState(() {
      _shaakhaaToliList = _getShaakhaaToliSadasyaForApp(theId, "");
      _isSearching = false;
    });
  }

  Future<List<dynamic>> _getShaakhaaToliSadasyaForApp(String shaakhaaID, String strShaakhaName) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({"ShaakhaaID": shaakhaaID});
      setState(() {
        strShaakhaaName = strShaakhaName;
      });
      return Statics.getShaakhaaToliSadasyaForApp(strInput);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Statics.getLabel('ShaakhaaToli')),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Legend(legendString: 'ShaakhaaToli', fontsize: 18),
              SizedBox(
                height: 10,
              ),
              Text(
                "ShaakhaaName:" + strShaakhaaName,
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder<List<dynamic>>(
                future: _shaakhaaToliList,
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
                      style: TextStyle(color: Colors.red),
                    ));
                  }
                  return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                      ? Column(
                          children: dataSnapshot.data!.map((toli) => ShaakhaaToliCard(toli)).toList(),
                        )
                      : Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
