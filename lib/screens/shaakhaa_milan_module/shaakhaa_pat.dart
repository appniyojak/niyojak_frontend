import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../helpers/static_data.dart' as Statics;
import '../../providers/bals.dart';
import '../../widgets/shaakha_swayamsevak_card.dart';
import '../../widgets/titlebar.dart';

class ShaakhaaPat extends StatefulWidget {
  static const routeName = '/shaakhaa-pat-screen';

  @override
  _ShaakhaaPatState createState() => _ShaakhaaPatState();
}

class _ShaakhaaPatState extends State<ShaakhaaPat> {
  Statics.ScreenArguments? args;
  var theId;
  var viewType;

  Future<List<dynamic>>? _swList;
  bool _isSearching = false;

  List<String> strEmail = [];
  List<String> strMobile = [];
  List<MenuChoices> choices = [];
  bool _isSelectAll = false;

  @override
  void initState() {
    super.initState();
    populateChoice();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments;
    theId = args!.itemID;
    viewType = args!.viewType;

    _swList = _getSwList(theId.toString()) ?? Future.value([]);
  }

  void populateChoice() {
    setState(() {
      choices = [
        new MenuChoices("SendMail", Icons.mail, Statics.getLabel('SendMail')),
        new MenuChoices("SendSMS", Icons.sms, Statics.getLabel('SendSMS')),
      ];
    });
  }

  Future<List<dynamic>>? _getSwList(String shaakhaaID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      return Statics.getShaakhaaPatForApp(shaakhaaID);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  void onCheckCard(var emailID, var mobileNum) {
    if (!strEmail.contains(emailID)) {
      strEmail.add(emailID);
    }
    if (!strMobile.contains(mobileNum)) {
      strMobile.add(mobileNum);
    }
  }

  void onUnCheckCard(var emailID, var mobileNum) {
    if (strEmail.contains(emailID)) {
      strEmail.remove(emailID);
    }
    if (strMobile.contains(mobileNum)) {
      strMobile.remove(mobileNum);
    }
  }

  void onSelectAll(value) {
    _swList!.then((dataList) {
      for (var data in dataList) {
        if (value == true)
          onCheckCard(data["Email"], data["MobileNumber"]);
        else
          onUnCheckCard(data["Email"], data["MobileNumber"]);
      }
    });
    setState(() {
      _isSelectAll = value;
    });
  }

  void onMenuSelected(MenuChoices choice) async {
    if (choice.menuType == "SendMail") {
      if (strEmail.length == 0) {
        Statics.showToast("Please select atleast one Member");
        return;
      }
      UrlLauncher.launch("mailto:" + strEmail.join(','));
    } else if (choice.menuType == "SendSMS") {
      if (strMobile.length == 0) {
        Statics.showToast("Please select atleast one Member");
        return;
      }
      UrlLauncher.launch("sms:" + strMobile.join(','));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              print("theId--->   ${theId} ==== viewType--->   ${viewType} ");
            },
            child: Text(
              Statics.getLabel('ShaakhaaPat'),
              style: TextStyle(fontSize: 24),
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<MenuChoices>(
              onSelected: onMenuSelected,
              icon: Icon(FontAwesomeIcons.ellipsisV),
              itemBuilder: (BuildContext context) {
                return choices.map((MenuChoices choice) {
                  return PopupMenuItem<MenuChoices>(
                    value: choice,
                    child: ListTile(leading: Icon(choice.icon), title: Text(choice.menuText!)),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              TitleBar(legendString: 'ShaakhaaPat', fontsize: 18),
              SizedBox(height: 10),
              CheckboxListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Text(Statics.getLabel('SelectAll'), style: TextStyle(fontSize: 15)),
                checkColor: Colors.white,
                activeColor: Colors.purple,
                value: _isSelectAll,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _isSelectAll = value!;
                    onSelectAll(value);
                  });
                },
              ),
              SizedBox(height: 10),
              FutureBuilder<List<dynamic>>(
                future: _swList,
                builder: (ctx, dataSnapshot) {
                  print(dataSnapshot.connectionState.toString());
                  print(dataSnapshot.hasData.toString());
                  print(_isSearching.toString());
                  if (dataSnapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (dataSnapshot.hasError) {
                    print("dataSnapshot $dataSnapshot");
                    return Center(
                        child: Text(
                      'Server Error, Please Try Again Later',
                      style: TextStyle(color: Colors.red),
                    ));
                  }
                  return dataSnapshot.hasData && dataSnapshot.data!.length > 0
                      ? Column(
                          children: dataSnapshot.data!.map((swItem) => ShaakhaaSwayamSevakCard(swItem, onCheckCard, onUnCheckCard, _isSelectAll)).toList(),
                        )
                      : _isSearching
                          ? Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')))
                          : Text('');
                },
              ),
            ],
          ),
        ),
        floatingActionButton:
            // tulnatmakBaithakResponse != null ?
            FloatingActionButton(
          mini: true,
          tooltip: Statics.getLabel("ExportToExcel"),
          onPressed: () async {
            _getCsv();
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV file saved successfully')));
          },
          child: Icon(Icons.download_sharp),
          backgroundColor: Colors.green,
        )
        // :Container(),
        );
  }

  void _getCsv() async {
    List<dynamic> dataList = await _swList!;

    List<List<dynamic>> rows = [];
    List<dynamic> header = [];
    header.add("Full Name");
    header.add("Mobile Number");
    header.add("Email");
    header.add("HomeGeo Unit Name");
    header.add("Linked Shaakhaa Name");
    header.add("Preferred Language Code");
    header.add("Can Use App");
    header.add("Daayitva Geo Unit Name");
    header.add("Level Name");
    header.add("Daayitva Name");
    header.add("Daayitva Start Year");
    header.add("Aayaam Name");
    header.add("Gatividhi Name");
    header.add("Current Address Line1");
    header.add("Current Address Line2");
    header.add("Current Graam Name");
    header.add("Current Post Office");
    header.add("Current City");
    header.add("Current District");
    header.add("Current Pin Code");
    header.add("Permanent Address Line1");
    header.add("Permanent Address Line2");
    header.add("Permanent Graam Name");
    header.add("Permanent Post Office");
    header.add("Permanent City");
    header.add("permantt District");
    header.add("Permanent PinCode");
    header.add("Permanent State");
    header.add("Secondary Mobile Number");
    header.add("Office phone Number");
    header.add("Home Phone Number");
    header.add("Whats App Number");
    header.add("Secondary Email");
    header.add("Twitter Handle");
    header.add("Instagram Handle");
    header.add("Koo Handle");
    header.add("Is Pratidnyit");
    header.add("Pratidnya Year");
    header.add("Ganavesh Complete");
    header.add("Has Cap");
    header.add("Has Shirt");
    header.add("Has Pant");
    header.add("Has Belt");
    header.add("Has Shoes");
    header.add("Has Socks");
    header.add("Has Danda");
    header.add("Has 2 WVehicle");
    header.add("Has 3 WVehicle");
    header.add("Has 4 WVehicle");
    header.add("Has Vehicle Driver");
    header.add("Blood Group");
    header.add("Mother Tongue");
    header.add("Birth Date");
    header.add("Sangha Pravesh Year");
    header.add("Facebook Usage");
    header.add("Koo Usage");
    header.add("Instagram Usage");
    header.add("Education");
    header.add("Shaakhaa Sanchaalan Experience");
    header.add("Sangha Prerit Sansthaa Name");
    header.add("Sangha Prerit Sansthaa Designation");
    header.add("Sangha Prerit Sansthaa Remark");
    header.add("Other Social Organization Name");
    header.add("Other Social Organization Designation");
    header.add("Other Social Organization Name");
    header.add("Other Social Organization Remark");
    header.add("Praathamik Year");
    header.add("Pratham Varsha Year");
    header.add("Dwitiya Varsha Year");
    header.add("Trutiya Varsha Year");
    header.add("Years As Praathamik Shikshak");
    header.add("Years As Dwitiya Shikshak");
    header.add("Years As Trutiya Shikshak");
    header.add("Danda");
    header.add("Niyuddha");
    header.add("Yogaasan");
    header.add("Yogachaap");
    header.add("Padavinyas");
    header.add("DandaYuddha");
    header.add("vanshi");
    header.add("vanshi Rachanaa Count");
    header.add("vanshi Lipi");
    header.add("venu");
    header.add("venu Rachanaa Count");
    header.add("venu Lipi");
    header.add("aanak");
    header.add("aanak Rachanaa Count");
    header.add("aanak Lipi");
    header.add("shanka");
    header.add("shanka Rachanaa Count");
    header.add("shanka   Lipi");
    header.add("nagganga");
    header.add("nagganga Rachanaa Count");
    header.add("nagganga Lipi");
    header.add("turya");
    header.add("turya Vaadya Rachanaa Count");
    header.add("turya Lipi");
    header.add("swarada");
    header.add("swarada Rachanaa Count");
    header.add("swarada Lipi");
    header.add("nagganga Rachanaa Count");
    header.add("occupation");
    header.add("permantt District");
    header.add("sanghashikshan");
    header.add("shanka");
    header.add("shanka Lipi");
    header.add("shanka Rachanaa Count");
    header.add("swarada");
    header.add("swarada Lipi");
    header.add("swarada Rachanaa Count");
    header.add("gomukha");
    header.add("gomukha Rachanaa Count");
    header.add("gomukha Lipi");
    header.add("Category");
    header.add("Education University Name");
    header.add("Education Institution Name");
    header.add("Education Standard Name");
    header.add("Education Program Name");
    header.add("Education Course Name");
    header.add("Education Expected Completion Year");
    header.add("Government Department");
    header.add("Organization Name");
    header.add("Industry Vertical");
    header.add("Designation");
    header.add("Office Location");
    header.add("Weekly Off Day IDs");
    header.add("Office Timing From");
    header.add("Office Timing To");
    header.add("Organization At Retirement");
    header.add("Designation At Retirement");
    header.add("Designation At Retirement");
    header.add("Department At Retirement");
    rows.add(header);

    for (var data in dataList) {
      List<dynamic> row = [];
      row.add(data["FullName"]);
      row.add(data["MobileNumber"]);
      row.add(data["Email"]);
      row.add(data["HomeGeoUnitName"]);
      row.add(data["LinkedShaakhaaName"]);
      row.add(data["PreferredLanguageCode"]);
      row.add(data["CanUseApp"]);
      row.add(data["DaayitvaGeoUnitName"]);
      row.add(data["LevelName"]);
      row.add(data["DaayitvaName"]);
      row.add(data["DaayitvaStartYear"]);
      row.add(data["AayaamName"]);
      row.add(data["GatividhiName"]);
      row.add(data["CurrentAddressLine1"]);
      row.add(data["CurrentAddressLine2"]);
      row.add(data["CurrentGraamName"]);
      row.add(data["CurrentPostOffice"]);
      row.add(data["CurrentCity"]);
      row.add(data["CurrentDistrict"]);
      row.add(data["CurrentPinCode"]);
      row.add(data["PermanentAddressLine1"]);
      row.add(data["PermanentAddressLine2"]);
      row.add(data["PermanentGraamName"]);
      row.add(data["PermanentPostOffice"]);
      row.add(data["PermanentCity"]);
      row.add(data["permanttDistrict"]);
      row.add(data["PermanentPinCode"]);
      row.add(data["PermanentState"]);
      row.add(data["SecondaryMobileNumber"]);
      row.add(data["OfficephoneNumber"]);
      row.add(data["HomePhoneNumber"]);
      row.add(data["WhatsAppNumber"]);
      row.add(data["SecondaryEmail"]);
      row.add(data["TwitterHandle"]);
      row.add(data["InstagramHandle"]);
      row.add(data["KooHandle"] ?? "");
      row.add(data["IsPratidnyit"]);
      row.add(data["PratidnyaYear"]);
      row.add(data["GanaveshComplete"]);
      row.add(data["HasCap"]);
      row.add(data["HasShirt"]);
      row.add(data["HasPant"]);
      row.add(data["HasBelt"]);
      row.add(data["HasShoes"]);
      row.add(data["HasSocks"]);
      row.add(data["HasDanda"]);
      row.add(data["Has2WVehicle"]);
      row.add(data["Has3WVehicle"]);
      row.add(data["Has4WVehicle"]);
      row.add(data["HasVehicleDriver"]);
      row.add(data["BloodGroup"]);
      row.add(data["MotherTongue"]);
      row.add(data["BirthDate"]);
      row.add(data["SanghaPraveshYear"]);
      row.add(data["FacebookUsage"]);
      row.add(data["KooUsage"]);
      row.add(data["InstagramUsage"]);
      row.add(data["Education"]);
      row.add(data["ShaakhaaSanchaalanExperience"]);
      row.add(data["SanghaPreritSansthaaName"]);
      row.add(data["SanghaPreritSansthaaDesignation"]);
      row.add(data["SanghaPreritSansthaaRemark"]);
      row.add(data["OtherSocialOrganizationName"]);
      row.add(data["OtherSocialOrganizationDesignation"]);
      row.add(data["OtherSocialOrganizationName"]);
      row.add(data["OtherSocialOrganizationRemark"]);
      row.add(data["PraathamikYear"]);
      row.add(data["PrathamVarshaYear"]);
      row.add(data["DwitiyaVarshaYear"]);
      row.add(data["TrutiyaVarshaYear"]);
      row.add(data["YearsAsPraathamikShikshak"]);
      row.add(data["YearsAsDwitiyaShikshak"]);
      row.add(data["YearsAsTrutiyaShikshak"]);
      row.add(data["Danda"]);
      row.add(data["Niyuddha"]);
      row.add(data["Yogaasan"]);
      row.add(data["Yogachaap"]);
      row.add(data["Padavinyas"]);
      row.add(data["DandaYuddha"]);
      row.add(data["vanshi"]);
      row.add(data["vanshiRachanaaCount"]);
      row.add(data["vanshiLipi"]);
      row.add(data["venu"]);
      row.add(data["venuRachanaaCount"]);
      row.add(data["venuLipi"]);
      row.add(data["aanak"]);
      row.add(data["aanakRachanaaCount"]);
      row.add(data["aanakLipi"]);
      row.add(data["shanka"]);
      row.add(data["shankaRachanaaCount"]);
      row.add(data["shankaLipi"]);
      row.add(data["nagganga"]);
      row.add(data["naggangaRachanaaCount"]);
      row.add(data["naggangaLipi"]);
      row.add(data["turya"]);
      row.add(data["turyaVaadyaRachanaaCount"]);
      row.add(data["turyaLipi"]);
      row.add(data["swarada"]);
      row.add(data["swaradaRachanaaCount"]);
      row.add(data["swaradaLipi"]);
      row.add(data["naggangaRachanaaCount"]);
      row.add(data["occupation"]);
      row.add(data["permanttDistrict"]);
      row.add(data["sanghashikshan"]);
      row.add(data["shanka"]);
      row.add(data["shankaLipi"]);
      row.add(data["shankaRachanaaCount"]);
      row.add(data["swarada"]);
      row.add(data["swaradaLipi"]);
      row.add(data["swaradaRachanaaCount"]);
      row.add(data["gomukha"]);
      row.add(data["gomukhaRachanaaCount"]);
      row.add(data["gomukhaLipi"]);
      row.add(data["Category"]);
      row.add(data["EducationUniversityName"]);
      row.add(data["EducationInstitutionName"]);
      row.add(data["EducationStandardName"]);
      row.add(data["EducationProgramName"]);
      row.add(data["EducationCourseName"]);
      row.add(data["EducationExpectedCompletionYear"]);
      row.add(data["GovernmentDepartment"]);
      row.add(data["OrganizationName"]);
      row.add(data["IndustryVertical"]);
      row.add(data["Designation"]);
      row.add(data["OfficeLocation"]);
      row.add(data["WeeklyOffDayIDs"]);
      row.add(data["OfficeTimingFrom"]);
      row.add(data["OfficeTimingTo"]);
      row.add(data["OrganizationAtRetirement"]);
      row.add(data["DesignationAtRetirement"]);
      row.add(data["DesignationAtRetirement"]);
      row.add(data["DepartmentAtRetirement"]);

      rows.add(row);
    }
    if (rows.length > 1) {
      Statics.convertToCsv(rows, "SoochiMembersList" + "_" + DateFormat('ddMMyyyyHHmmss').format(DateTime.now()), context);
    }
    setState(() {});
  }
}
