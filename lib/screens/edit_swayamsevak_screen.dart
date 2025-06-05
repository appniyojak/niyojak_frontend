import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niyojak_prod/providers/bals.dart';
import 'package:niyojak_prod/screens/profile_settings.dart';
import 'package:niyojak_prod/screens/soochi_members.dart';
import 'package:niyojak_prod/screens/soochi_sharing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/login.dart';
import '../screens/swayamsevak_daayitva_list.dart';
import '../screens/swayamsevak_linked_soochi.dart';

import '../helpers/static_data.dart' as Statics;
import 'edit_soochi.dart';
import 'swayamsevak_daayitva.dart';
import 'swayamsevak_occupation.dart';
import 'swayamsevak_other_info.dart';
import 'swayamsevak_sangha_shikshan.dart';
import 'swayamsevak_shaaririk_vishay.dart';
import 'swayamsevak_basic_info.dart';

class EditSwayamsevakScreen extends StatefulWidget {
  static const String routeName = '/edit-swayamsevak-screen';
  State<StatefulWidget> createState() {
    return new EditSwayamsevakScreenState();
  }
}

class EditSwayamsevakScreenState extends State<EditSwayamsevakScreen> {
  Statics.ScreenArgumentsNew? args;
  var theId;
  var viewType;
  bool isSoochiAvailable = false;

  String _otpUser = "";

  String? preFilledName ;
  String ?preFilledMobile ;
  String ? preFilledEmail ;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    _otpUser =  pref.getString("otpuser") ?? '';
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArgumentsNew;
  //   theId = args!.itemID;
  //   viewType = args!.viewType;
  //   checkIfSoochiExits(theId);
  // }
//27-1-25
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArgumentsNew;
  //   theId = args!.itemID;
  //   viewType = args!.viewType;
  //   String? name = args!.name;
  //   String? mobile = args!.mobile;
  //   String? email = args!.email;
  //
  //   checkIfSoochiExits(theId);
  //
  //   if (name != null && mobile != null && email != null) {
  //     setState(() {
  //       preFilledName = name;
  //       preFilledMobile = mobile;
  //       preFilledEmail = email;
  //     });
  //   }
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Statics.ScreenArgumentsNew;
    theId = args!.itemID;
    viewType = args!.viewType;

    String? name = args?.name ?? "";
    String? mobile = args?.mobile ?? "";
    String? email = args?.email ?? "";

    checkIfSoochiExits(theId);

    setState(() {
      preFilledName = name;
      preFilledMobile = mobile;
      preFilledEmail = email;
    });
  }


  void onSaveSwDetails(outputID) {
    setState(() {
      theId = outputID;
    });
    checkIfSoochiExits(theId);
  }

  void checkIfSoochiExits(swId) async {
    var membersData = await Statics.getSwayamSevakMembersInSoochi(swId.toString());

    var data = membersData == null ? null : membersData["TaggedSoochi"];
    var data1 = membersData == null ? null : membersData["SharedSoochi"];
    if ((data != null && data.length > 0) || (data1 != null && data1.length > 0)) {
      if (!mounted) return;
      setState(() {
        isSoochiAvailable = true;
      });
    } else {
      if (!mounted) return;
      setState(() {
        isSoochiAvailable = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    //theId = ModalRoute.of(context).settings.arguments as String;

    return DefaultTabController(

      length: _otpUser == "true" ? 4 : isSoochiAvailable == true ? 7 : 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Statics.getLabel('EditSwayamsevak')),
          actions: [
            // IconButton(onPressed: (){
            //     Navigator.of(context).pushNamed(ProfileSettings.routeName).then((value) => setState((){}));
            // },
            //     icon: Icon(Icons.settings))
            _otpUser == "true" ?
            PopupMenuButton(
              onSelected: (value) async {
                String otpUser='';
                SharedPreferences pref = await SharedPreferences.getInstance();
                otpUser =  pref.getString("otpuser")?? '';
             if (value == "Logout") {

               print("otpUser => $otpUser");
               if(otpUser != null && otpUser == "true"){
                 print("Logout");
                 await LogIn().logOut();
                 BackgroundFetch.stop().then((int status) {
                   print('[BackgroundFetch] stop success: $status');
                 });
                 Navigator.of(context).pushReplacementNamed('/');
               }
             } else if (value == "ProfileSettings") {
               Navigator.of(context).pushNamed(ProfileSettings.routeName).then((value) => setState((){}));
                }
                 },
              icon: Icon(
                FontAwesomeIcons.ellipsisV,
                color: Colors.white,
              ),
              itemBuilder: (BuildContext context) {
                return [
                 Statics.MenuItem(Statics.getLabel('ProfileSettings'), Icons.settings, 'ProfileSettings'),
                 Statics.MenuItem(Statics.getLabel('logOutLabel'), Icons.power_settings_new, 'Logout'),
                ].map((Statics.MenuItem menuItem) {
                  return PopupMenuItem(
                    //value: menuItem.menuVal,
                    value: menuItem.menuKey,
                    child: ListTile(
                      leading: Icon(
                        menuItem.iconVal,
                        color: Colors.purple,
                      ),
                      title: Text(menuItem.menuVal),
                    ),
                  );
                }).toList();
              },
            ):Container(),

          ],
          bottom: new TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              if( _otpUser != "true")
              new Tab(
                child: Row(
                  children: [
                    Text(Statics.getLabel('BasicInfo')),
                  ],
                ),
              ),
              if( _otpUser != "true")
              new Tab(
                child: Row(
                  children: [
                    Text(Statics.getLabel('Daayitva')),
                  ],
                ),
              ),
              new Tab(
                child: Row(
                  children: [
                    Text(Statics.getLabel('OtherInfo')),
                  ],
                ),
              ),
              new Tab(
                child: Row(
                  children: [
                    Text(Statics.getLabel('SanghaShikshan') + "/" + Statics.getLabel('ShaaririkVishay')),
                  ],
                ),
              ),
              new Tab(
                child: Row(
                  children: [
                    Text(Statics.getLabel('GhoshVishay')),
                  ],
                ),
              ),
              new Tab(
                child: Row(
                  children: [
                    Text(Statics.getLabel('Occupation')),
                  ],
                ),
              ),
              // new Tab(
              //   child: Text(Statics.getLabel('LinkedGeoUnit')),
              // ),
              if (isSoochiAvailable == true)
                new Tab(
                  child: Row(
                    children: [
                      Text(Statics.getLabel('searchSoochiScreenLabel')),
                    ],
                  ),
                )
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            if( _otpUser != "true")
            // SwayamsevakBasicInfo(
            //   swId: theId,
            //   onSaveSwDetails: onSaveSwDetails,
            //   viewType: viewType,
            // ),
              SwayamsevakBasicInfo(
                swId: theId,
                onSaveSwDetails: onSaveSwDetails,
                viewType: viewType,
                preFilledName: args!.name,
                preFilledMobile: args!.mobile,
                preFilledEmail: args!.email,
              ),
            if( _otpUser != "true")
            DaayitvaList(
              swId: theId.toString(),
              onSaveSwDetails: onSaveSwDetails,
              viewType: viewType,
            ),

            SwayamsevakOtherInfo(
              swId: theId.toString(),
              onSaveSwDetails: onSaveSwDetails,
              viewType: viewType,
            ),
            SwayamsevakSanghaShikshan(
              swId: theId.toString(),
              onSaveSwDetails: onSaveSwDetails,
              viewType: viewType,
            ),
            SwayamsevakShaaririkVishay(
              swId: theId.toString(),
              onSaveSwDetails: onSaveSwDetails,
              viewType: viewType,
            ),
            SwayamsevakOcuupation(
              swId: theId.toString(),
              onSaveSwDetails: onSaveSwDetails,
              viewType: viewType,
            ),
            // SwayamsevakLinkedGeoUnit(
            //   swId: theId.toString(),
            //   onSaveSwDetails: onSaveSwDetails,
            //   viewType: viewType,
            // ),
            if (isSoochiAvailable == true)
              SwayamSevakLinkedSooochi(
                swId: theId.toString(),
                onSaveSwDetails: onSaveSwDetails,
                viewType: viewType,
              ),
          ],
        ),
      ),
    );
  }
}
