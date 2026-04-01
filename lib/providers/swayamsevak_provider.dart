import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:niyojak_prod/models/response_model/AbhiyaanListResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanSwayamsevakListResponse.dart';
import 'package:niyojak_prod/models/response_model/AbhiyanGruhasamparkResponse.dart';
import 'package:niyojak_prod/models/response_model/VisheshVyaktiListResponse.dart';

import '../helpers/static_data.dart' as Statics;
import './bals.dart';

class SwayamsevakProvider {
  String _searchCriteria = '';

  String get searchCriteria {
    return _searchCriteria;
  }

  List<SwayamsevakBAL> swList = [];

  Future<dynamic> getSwayamSevakByID(String swayamsevakID, String tab) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
    print('$tab =====> tab');
    print('$swayamsevakID =====> swayamsevakID');

    if (tab == "BasicInfo") {
      var response = await http.post(Uri.parse(Statics.urlGetSwayamsevakBasicInfoForApp),
          headers: jHeaders,
          body: json.encode({
            "SwayamsevakID": swayamsevakID,
          }));

      var body = json.decode(response.body);
      var data = body['SwayamsevakBasicInfo'];
      log("datadatadata -=> $body");
      return SwayamsevakBAL(
        data['SwayamsevakID'],
        data['PraantID'],
        data['FullName'],
        data['MobileNumber'],
        data['Email'],
        data['BirthDate'],
        data['LinkedGeoUnitID'],
        data['LinkedGeoUnitName'],
        data['LinkedShaakhaaID'],
        data['LinkedShaakhaaName'],
        data['PreferredLanguageID'],
        data['PreferredLanguageCode'],
        data['CanUseApp'] == true ? true : false,
        data['can_edit'],
      );
    } else if (tab == 'OtherInfo') {
      // var response = await http.post(
      //     Uri.parse(Statics.urlGetSwayamsevakOtherInfoForApp),
      //     headers: jHeaders,
      //     body: json.encode({
      //       "SwayamsevakID": swayamSevakID,
      //     }));

      // var body = json.decode(response.body);
      // var data = body['SwayamsevakOtherInfo'];
      var data = await Statics.getSwayamsevakOtherInfoForApp(swayamsevakID);

      return SwayamsevakOtherInfoBAL(
          data['SwayamsevakID'],
          data['SwayamsevakOtherInfoID'],
          data['PraantID'],
          data['CurrentAddressLine1'],
          data['CurrentAddressLine2'],
          data['CurrentGraamName'],
          data['CurrentPostOffice'],
          data['CurrentDistrictID'],
          data['CurrentPinCode'],
          data['CurrentStateID'],
          data['PermanentAddressLine1'],
          data['PermanentAddressLine2'],
          data['PermanentGraamName'],
          data['PermanentPostOffice'],
          data['PermanentDistrictID'],
          data['PermanentPinCode'],
          data['PermanentStateID'],
          data['IsPratidnyit'],
          data['PratidnyaYear'],
          data['IsGanaveshComplete'],
          data['HasCap'],
          data['HasShirt'],
          data['HasPant'],
          data['HasBelt'],
          data['HasShoes'],
          data['HasSocks'],
          data['HasDanda'],
          data['Has2WVehicle'],
          data['Has3WVehicle'],
          data['Has4WVehicle'],
          data['HasVehicleDriver'],
          data['BloodGroupID'],
          data['BloodGroupCode'],
          data['MotherTongueID'],
          data['MotherTongueCode'],
          data['BirthDateStr'],
          data['SanghaPraveshYear'],
          data['FacebookUsage'],
          data['TwitterUsage'],
          data['InstagramUsage'],
          data['kooUsage'],
          data['HasShaakhaaSanchaalanExperience'],
          data['HasBaalShaakhaaExperience'],
          data['HasTarunVidyaarthiShaakhaaExperience'],
          data['HasTarunVyavasaayeeShaakhaaExperience'],
          data['HasProudhaVyavasaayeeShaakhaaExperience'],
          data['ShaakhaaExperienceYearID'],
          data['HasShaakhaaOpeningExperience'],
          data['HasBaalShaakhaaOpeningExperience'],
          data['HasTarunVidyaarthiShaakhaaOpeningExperience'],
          data['HasTarunVyavasaayeeShaakhaaOpeningExperience'],
          data['HasProudhaVyavasaayeeShaakhaaOpeningExperience'],
          data['AreaOfInterestIDs'],
          data['AreaOfExpertiseIDs'],
          data['SecondaryMobileNumber'],
          data['OfficePhoneNumber'],
          data['HomePhoneNumber'],
          data['WhatsAppNumber'],
          data['SecondaryEmail'],
          data['TwitterHandle'],
          data['InstagramHandle'],
          data['KooHandle'] ?? "",
          data['MaxDaayitva'],
          data['HasBeenVistaarak'],
          data['HasBeenPrachaarak'],
          data['VistaarakWeekCount'],
          data['VistaarakMonthCount'],
          data['VistaarakYearCount'],
          data['PrachaarakYearCount'],
          data['FacebookPage']);
    } else if (tab == 'SanghaShikshanSharirikVishay') {
      var response = await http.post(Uri.parse(Statics.urlGetSwayamsevakSanghaShikshanShaaririkVishayForApp),
          headers: jHeaders,
          body: json.encode({
            "SwayamsevakID": swayamsevakID,
          }));

      var body = json.decode(response.body);
      var data = body['SanghaShikshanShaaririk'];

      var sanghaShikshan = data["SwayamsevakSanghaShikshan"];
      SwayamsevakSanghaShikshanBAL swSansghaShikshan = new SwayamsevakSanghaShikshanBAL(
          sanghaShikshan['SwayamsevakID'],
          sanghaShikshan['SwayamsevakSanghaShikshanID'],
          sanghaShikshan['PraantID'],
          sanghaShikshan['PrarambhikYear'],
          sanghaShikshan['PraathamikYear'],
          sanghaShikshan['PrathamVarshaYear'],
          sanghaShikshan['DwitiyaVarshaYear'],
          sanghaShikshan['TrutiyaVarshaYear'],
          sanghaShikshan['YearsAsPraathamikShikshak'],
          sanghaShikshan['YearsAsPrathamVarshaShikshak'],
          sanghaShikshan['YearsAsDwitiyaVarshaShikshak'],
          sanghaShikshan['YearsAsTrutiyaVarshaShikshak']);
      var shaaririkVishay = data['ListShaaririkVishay'];
      List<ShaaririkVishayBAL> sharirikVishayList = [];
      if (shaaririkVishay.length > 0) {
        for (var data in shaaririkVishay) {
          sharirikVishayList.add(
              new ShaaririkVishayBAL(data['SwayamsevakShaaririkVishayID'], data['ShaaririkVishayID'], data['PraantID'], data['ShaaririkVishayCode'], data['VishayFamiliarity'], data['SwayamsevakID']));
        }
        print("shaaririkVishay :-- $shaaririkVishay");
      }

      return SwayamsevakSanghaShikshanSharirikVishayBAL(swSansghaShikshan, sharirikVishayList);
    } else if (tab == 'GhoshVishayInfo') {
      var response = await http.post(Uri.parse(Statics.urlGetSwayamsevakGhoshForApp),
          headers: jHeaders,
          body: json.encode({
            "SwayamsevakID": swayamsevakID,
          }));

      var body = json.decode(response.body);

      log("GhoshVishayInfo response Body :====>   $body");
      log("GhoshVishayInfo response API :====>   ${response.request}");

      var ghoshVishay = body['ListSwayamsevakGhosh'];
      List<GhoshVishayBAL> ghoshVishayList = [];
      if (ghoshVishay.length > 0) {
        for (var data in ghoshVishay) {
          ghoshVishayList.add(new GhoshVishayBAL(data['SwayamsevakGhoshVishayID'], data['VaadyaID'], data['PraantID'], data['VaadyaCode'], data['VaadyaFamiliarity'], data['RachanaaCount'],
              data['SwayamsevakID'], data['IsUnderstandLipi'] == true ? true : false));
        }
      }

      return new SwayamsevakSharirikGhoshVishayBAL(ghoshVishayList, null);
    } else if (tab == 'LinkedGeoUnits') {
      var response = await http.post(Uri.parse(Statics.urlGetSwayamsevakBasicInfoForApp),
          headers: jHeaders,
          body: json.encode({
            "SwayamsevakID": swayamsevakID,
          }));

      var body = json.decode(response.body);
      var data = body['SwayamsevakBasicInfo'];

      return SwayamsevakLinkedGeoUnitBAL(data['SwayamsevakID'], data['PraantID'], data['LinkedVastiID'], data['LinkedVastiName'], data['LinkedGraamID'], data['LinkedGraamName'],
          data['LinkedShaakhaaID'], data['LinkedShaakhaaName']);
    } else if (tab == 'OccupationDetails') {
      var response = await http.post(Uri.parse(Statics.urlGetSwayamsevakOccupationForApp),
          headers: jHeaders,
          body: json.encode({
            "SwayamsevakID": swayamsevakID,
          }));

      var body = json.decode(response.body);
      var data = body['SwayamsevakOccupation'];

      return SwayamsevakOccupationBAL(
          data['SwayamsevakID'],
          data['SwayamsevakOccupationID'],
          data['PraantID'],
          data['OccupationCategoryID'],
          data['EducationUniversityID'],
          data['EducationUniversityName'],
          data['EducationInstitutionID'],
          data['EducationInstitutionName'],
          data['EducationStandardID'],
          data['EducationStandardName'],
          data['EducationProgramID'],
          data['EducationProgramName'],
          data['EducationCourseID'],
          data['EducationCourseName'],
          data['EducationExpectedCompletionYear'],
          data['GovernmentDepartment'],
          data['Designation'],
          data['OfficeLocation'],
          data['WeeklyOffDayIDs'],
          data['OfficeTimingFrom'],
          data['OfficeTimingTo'],
          data['IndustryVertical'],
          data['OrganizationName'],
          data['OrganizationAtRetirement'],
          data['DesignationAtRetirement'],
          data['DepartmentAtRetirement'],
          data['Education'],
          data['WeeklyOffCycleID'],
          data['IsShiftDuty'],
          data["SchoolJuniorCollegeName"],
          data["JuniorCollegeProgramName"]);
    } else if (tab == 'Daayitva') {
      var response = await http.post(Uri.parse(Statics.urlGetSwayamsevakDaayitvaForApp),
          headers: jHeaders,
          body: json.encode({
            "SwayamsevakID": swayamsevakID,
          }));

      var body = json.decode(response.body);
      var data = body['SwayamsevakDaayitvaList'];

      return data;
      // return SwayamsevakDaayitvaBAL(
      //     data['SwayamsevakID'],
      //     data['PraantID'],
      //     data['DaayitvaForID'],
      //     data['DaayitvaName'],
      //     data['DaayitvaID'],
      //     data['LevelID'],
      //     data['DaayitvaGeoUnitID'],
      //     data['GatividhiID'],
      //     data['AayaamID'],
      //     data['DaayitvaStartYear'],
      //     data['DaayitvaEndYear']);
    } else if (tab == 'DaayitvaPage' || tab == 'DaayitvaList') {
      var response = await http.post(Uri.parse(Statics.urlGetSwayamsevakDaayitvaPageData),
          headers: jHeaders,
          body: json.encode({
            "AppUserID": Statics.userDetails["userID"],
            "SwayamsevakID": swayamsevakID,
          }));
      print("Statics.userDetails[" 'userID' "] -=-=-=->  ${Statics.userDetails["userID"]}");
      print("swayamsevakID-=-=-=->  $swayamsevakID");

      var body = json.decode(response.body);
      var data = body['PageData'];
      print("data-=-=-=->  $data");
      if (tab == 'DaayitvaPage') {
        return SwayamsevakDaayitvaPageBAL(data["SwayamsevakID"], data["MaxPastDaayitva"], data["MaxPastDaayitvaFromYear"], data["MaxPastDaayitvaToYear"], data["HasBeenVistaarak"],
            data["VistaarakWeekCount"], data["VistaarakMonthCount"], data["VistaarakYearCount"], data["HasBeenPrachaarak"], data["PrachaarakYearCount"], data["MaxDaayitvaWhenPrachaarak"]);
      } else if (tab == "DaayitvaList") {
        return body['PageData']['DaayitvaDataList'];
      }
    } else {
      return null;
    }
  }

  Future<dynamic> getSwayamSevakDaayitva(String swayamSevakID, String daayitvaForID, String daayitvaForCode, String dataID) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    var response = await http.post(Uri.parse(Statics.urlGetSwayamsevakDaayitvaDetailForApp),
        headers: jHeaders,
        body: json.encode({
          "AppUserID": Statics.userDetails["userID"],
          "SwayamsevakID": swayamSevakID,
          "DaayitvaForID": daayitvaForID,
          "DaayitvaForCode": daayitvaForCode,
          "SwayamsevakDaayitvaID": daayitvaForCode != "SanghaPreritSansthaa" && daayitvaForCode != "OtherSocialOrganization" ? dataID : null,
          "SwayamsevakOtherDaayitvaID": daayitvaForCode == "SanghaPreritSansthaa" || daayitvaForCode == "OtherSocialOrganization" ? dataID : null,
        }));

    var body = json.decode(response.body);
    if (daayitvaForCode == "SanghaPreritSansthaa" || daayitvaForCode == "OtherSocialOrganization") {
      var data = body["SwayamsevakOtherDaayitva"];
      return SwayamsevakDaayitvaBAL(
          data["swayamsevakID"],
          1,
          null,
          data["SwayamsevakOtherDaayitvaID"],
          "",
          null,
          null,
          null,
          null,
          data["StartYear"],
          data["EndYear"],
          data["SanghaPreritSansthaaID"],
          data["Designation"],
          data["Remark"],
          data["SocialOrganizationName"],
          data["Designation"],
          data["Remark"],
          data["IsCurrent"],
          daayitvaForCode == "OtherSocialOrganization" ? (data["AreaOfOperationIDs"] == null ? "" : data["AreaOfOperationIDs"]) : "");
    } else {
      // var data = body["SwayamsevakDaayitva"];
      // return SwayamsevakDaayitvaBAL(
      //     data["SwayamsevakID"],
      //     data["PraantID"],
      //     null,
      //     data["DaayitvaID"],
      //     data["DaayitvaName"],
      //     data["LevelID"],
      //     data["DaayitvaGeoUnitID"],
      //     data["GatividhiID"],
      //     data["AayaamID"],
      //     data["StartYear"],
      //     data["EndYear"],
      //     null,
      //     "",
      //     "",
      //     "",
      //     "",
      //     "",
      //     data["IsCurrent"],
      //     "");
      var data = body["SwayamsevakDaayitva"] ?? {};
      return SwayamsevakDaayitvaBAL(data["SwayamsevakID"] ?? 0, data["PraantID"] ?? 0, null, data["DaayitvaID"] ?? 0, data["DaayitvaName"] ?? "", data["LevelID"] ?? 0, data["DaayitvaGeoUnitID"] ?? 0,
          data["GatividhiID"] ?? 0, data["AayaamID"] ?? 0, data["StartYear"] ?? 0, data["EndYear"] ?? 0, null, "", "", "", "", "", data["IsCurrent"] ?? false, "");
    }
  }

  Future<List<dynamic>> getSwayamsevaks(String inputJson) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
    print(Uri.parse(Statics.urlGetSwayamsevaksForAppGrid));
    log(inputJson);
    var response = await http.post(Uri.parse(Statics.urlGetSwayamsevaksForAppGrid), headers: jHeaders, body: inputJson);
    var body = json.decode(response.body);

    if (body['SwayamsevakList'] == null) {
      print('No data found');
      return [];
    } else {
      log('getSwayamsevaks() Swayamsevaks - ' + body['SwayamsevakList'].toString());
      return body['SwayamsevakList'];
    }
  }

  Future<List> getAbhiyanSwayamsevaks(String inputJson) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    print(Uri.parse(Statics.urlGetSwayamsevaksForAppGrid));
    log(inputJson);

    var response = await http.post(Uri.parse(Statics.urlGetSwayamsevaksForAppGrid), headers: jHeaders, body: inputJson);

    var body = json.decode(response.body);

    if (body['SwayamsevakList'].toString() == "[]") {
      Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    }
    print('getAbhiyanSwayamsevaks() Swayamsevaks - ' + body['SwayamsevakList'].toString());
    return body['SwayamsevakList'];
  }

  Future<AbhiyaanListResponse> saveAbhiyanSwayamsevak(String jsonEncode) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    print(Uri.parse(Statics.urlSaveAbhiyaanSwayamsevak));
    print(jsonEncode);

    var response = await http.post(Uri.parse(Statics.urlSaveAbhiyaanSwayamsevak), headers: jHeaders, body: jsonEncode);

    var body = json.decode(response.body);
    AbhiyaanListResponse res = AbhiyaanListResponse.fromJson(body);
    print('saveAbhiyanSwayamsevak() Swayamsevaks - ' + res.toString());
    return res;
  }

  Future<AbhiyaanListResponse> saveAbhiyanGruhaSampark(String jsonEncode) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    print(Uri.parse(Statics.urlSaveAbhiyaanGruhaSampark));
    print(jsonEncode);

    var response = await http.post(Uri.parse(Statics.urlSaveAbhiyaanGruhaSampark), headers: jHeaders, body: jsonEncode);

    var body = json.decode(response.body);
    AbhiyaanListResponse res = AbhiyaanListResponse.fromJson(body);
    print('saveAbhiyanGruhaSampark() Swayamsevaks - ' + res.toString());
    return res;
  }

  Future updateAbhiyanGruhaSampark(String jsonEncode) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    print(Uri.parse(Statics.updatevayktivishesh));
    print(jsonEncode);

    var response = await http.post(Uri.parse(Statics.updatevayktivishesh), headers: jHeaders, body: jsonEncode);

    var body = json.decode(response.body);

    print('updateAbhiyanGruhaSampark - ' + body.toString());
    return body;
  }

  Future<AbhiyaanListResponse> getAbhiyanList() async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    print(Uri.parse(Statics.urlGetAbhiyaanList));

    var response = await http.get(Uri.parse(Statics.urlGetAbhiyaanList), headers: jHeaders);

    var body = json.decode(response.body);
    AbhiyaanListResponse res = AbhiyaanListResponse.fromJson(body);
    print('getAbhiyanList() Swayamsevaks - ' + jsonEncode(body).toString());
    return res;
  }

  Future<AbhiyanGruhasamparkResponse> getAbhiyaGruhaSamparkList(String jsonEncode) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    print(Uri.parse(Statics.urlGetAbhiyaanGruhaSamparkList));
    print(jsonEncode);

    var response = await http.post(
      Uri.parse(Statics.urlGetAbhiyaanGruhaSamparkList),
      headers: jHeaders,
      body: jsonEncode,
    );

    var body = json.decode(response.body);
    AbhiyanGruhasamparkResponse res = AbhiyanGruhasamparkResponse.fromJson(body);
    log('getAbhiyaGruhaSamparkList() Swayamsevaks - ' + response.body.toString());
    return res;
  }

  Future<VisheshVyaktiListResponse> getVisheshVyaktikList(String jsonEncode) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
    print(Uri.parse(Statics.urlGetVisheshVyaktiList));
    print(jsonEncode);
    var response = await http.post(
      Uri.parse(Statics.urlGetVisheshVyaktiList),
      headers: jHeaders,
      body: jsonEncode,
    );
    var body = json.decode(response.body);
    VisheshVyaktiListResponse res = VisheshVyaktiListResponse.fromJson(body);
    print('getVisheshVyaktikList() Swayamsevaks - ' + res.toString());
    return res;
  }

  Future<AbhiyaanSwayamsevakListResponse> getAbhiyanSwayamsevakList(String jsonEncode) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    print(Uri.parse(Statics.urlGetAbhiyaanSwayamsevakList));
    print(jsonEncode);

    var response = await http.post(Uri.parse(Statics.urlGetAbhiyaanSwayamsevakList), body: jsonEncode, headers: jHeaders);

    var body = json.decode(response.body);
    AbhiyaanSwayamsevakListResponse res = AbhiyaanSwayamsevakListResponse.fromJson(body);
    log('getAbhiyanSwayamsevakList() Swayamsevaks - ' + json.encode(res).toString());
    return res;
  }

  // Future<List<dynamic>> getSwayamsevaksForExport(String inputJson) async {
  //   Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  //   var response = await http.post(Uri.parse(Statics.urlSwayamsevakExportForApp),headers: jHeaders,body: inputJson);
  //   var body = json.decode(response.body);
  //   print("response body :-- $body");
  //   print("response body noofpage:-- ${body["noofpage"]}");
  //   return body['SwayamsevakList'];
  // }
  Future<List<dynamic>> getSwayamsevaksForExport(String inputJson) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    List<dynamic> allSwayamsevaks = [];
    int currentPage = 1;
    int totalPages = 1;

    do {
      Map<String, dynamic> inputMap = json.decode(inputJson);
      inputMap['pageno'] = currentPage;
      String modifiedInputJson = json.encode(inputMap);

      print("getSwayamsevaksForExport() inputJson :-  $modifiedInputJson");

      var response = await http.post(
        Uri.parse(Statics.urlSwayamsevakExportForApp),
        headers: jHeaders,
        body: modifiedInputJson,
      );

      var body = json.decode(response.body);
      print("response body :-- $body");

      if (currentPage == 1) {
        totalPages = int.parse(body["noofpage"]);
        print("response body noofpage:-- $totalPages");
      }

      if (body['SwayamsevakList'] != null) {
        allSwayamsevaks.addAll(body['SwayamsevakList']);
      } else {
        print("Warning: SwayamsevakList is null for page $currentPage");
      }
      currentPage++;
    } while (currentPage <= totalPages);

    return allSwayamsevaks;
  }

  Future<String> saveSwayamsevakDetails(String inputJson) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
    print("Save Swayamsevak - " + inputJson);
    print(Uri.parse(Statics.urlSaveSwayamsevakBasicInfoForApp));
    //var client = http.Client();
    //var response;
    // try {
    // response = await client.post(
    //     Uri.parse(Statics.urlSaveSwayamsevakBasicInfoForApp),
    //     headers: jHeaders,
    //     body: inputJson);
    // } finally {client.close();}
    var response = await http.post(Uri.parse(Statics.urlSaveSwayamsevakBasicInfoForApp), headers: jHeaders, body: inputJson);

    print(response.body);
    var body = json.decode(response.body);
    var message = body["Message"];
    String retValue = '';
    if (message == 'Operation failed - One Geo-Unit Can Have only One Sanyojak')
      retValue = '-11';
    else
      retValue = body['OutputSwayamsevakID'].toString();

    return retValue;
  }

  Future<String> saveSwayamsevakOtherInfoForApp(String inputJson) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    print(Statics.urlSaveSwayamsevakOtherInfoForApp);
    log(jsonDecode(inputJson));

    var response = await http.post(Uri.parse(Statics.urlSaveSwayamsevakOtherInfoForApp), headers: jHeaders, body: inputJson);

    var body = json.decode(response.body);
    //var message = body["Message"];
    String retValue = '';

    retValue = body['OutputSwayamsevakID'].toString();

    return retValue;
  }

  Future<String> swayamsevakSanghaShikshanSHaaririkVishayForApp(String inputJson) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    var response = await http.post(Uri.parse(Statics.urlSaveSwayamsevakSanghaShikshanShaaririkVishayForApp), headers: jHeaders, body: inputJson);

    var body = json.decode(response.body);
    //var message = body["Message"];
    String retValue = '';

    retValue = body['OutputSwayamsevakID'].toString();

    return retValue;
  }

  Future<String> saveSwayamsevakOccupationForApp(String inputJson) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    var response = await http.post(Uri.parse(Statics.urlSaveSaveSwayamsevakOccupationForApp), headers: jHeaders, body: inputJson);

    var body = json.decode(response.body);
    //var message = body["Message"];
    String retValue = '';

    retValue = body['OutputSwayamsevakID'].toString();

    return retValue;
  }

  Future<String> saveSwayamsevakDaayitvaPageData(String inputJson) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    var response = await http.post(Uri.parse(Statics.urlSaveSwayamsevakDaayitvaPageData), headers: jHeaders, body: inputJson);

    var body = json.decode(response.body);
    //var message = body["Message"];
    String retValue = '';

    retValue = body['OutputSwayamsevakID'].toString();

    return retValue;
  }

  Future<String> saveSwayamsevakDaayitvaForApp(String inputJson) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    var response = await http.post(Uri.parse(Statics.urlSaveSwayamsevakDaayitvaForApp), headers: jHeaders, body: inputJson);

    var body = json.decode(response.body);
    //var message = body["Message"];
    String retValue = '';

    retValue = body['OutputSwayamsevakID'].toString();

    return retValue;
  }

  Future<String> saveSwayamsevakGhoshForApp(String inputJson) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    var response = await http.post(Uri.parse(Statics.urlSaveSwayamsevakGhoshForApp), headers: jHeaders, body: inputJson);

    var body = json.decode(response.body);
    //var message = body["Message"];
    String retValue = '';

    retValue = body['OutputSwayamsevakID'].toString();
    return retValue;
  }

  Future<AbhiyanGruhasamparkResponse> sendMailCall(String jsonEncode) async {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    print(Uri.parse(Statics.urlSendMail));
    print(jsonEncode);

    var response = await http.post(
      Uri.parse(Statics.urlSendMail),
      headers: jHeaders,
      body: jsonEncode,
    );

    var body = json.decode(response.body);
    AbhiyanGruhasamparkResponse res = AbhiyanGruhasamparkResponse.fromJson(body);
    print('sendMailCall() Swayamsevaks - ' + response.body.toString());
    return res;
  }

  Future<void> changeSwayamsewakCanEditStatus(String inputJson) async {
    print(inputJson);
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
    var response = await http.post(Uri.parse(Statics.changesavamsevakcanedit), headers: jHeaders, body: inputJson);
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      String message = responseBody["Message"];
      // Statics.showToast(message);
    } else {
      Statics.showToast("Failed to update status");
    }
  }
}
