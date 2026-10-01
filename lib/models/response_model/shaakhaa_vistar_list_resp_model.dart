import '../value_converter.dart';

class ShaakhaaVistarListRespModel {
  String? status;
  String? message;
  List<ShaakhaaList>? shaakhaaList;

  ShaakhaaVistarListRespModel({this.status, this.message, this.shaakhaaList});

  ShaakhaaVistarListRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['ShaakhaaList'] != null) {
      shaakhaaList = <ShaakhaaList>[];
      json['ShaakhaaList'].forEach((v) {
        shaakhaaList!.add(new ShaakhaaList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.shaakhaaList != null) {
      data['ShaakhaaList'] = this.shaakhaaList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShaakhaaList {
  int? shaakhaaID;
  int? mapShaakhaaID;
  int? praantID;
  int? isnew;
  int? isanya;
  int? pkid;
  int? geoUnitID;
  String? geoUnitName;
  String? trail;
  String? geoUnitNameDevNaagari;
  int? frequencyID;
  String? frequencyCode;
  String? daysOfWeek;
  String? dayNamesOfWeek;
  String? dayOfMonth;
  int? vayogatID;
  String? vayogatCode;
  String? location;
  String? startTimeStr;
  String? endTimeStr;
  String? remark;
  bool? isSankalpit;
  String? sankalpAadhaar;
  int? sankalpAadhaarSwayamsevakID;
  String? sankalpAadhaarSwayamsevakName;
  int? sankalpAadhaarShaakhaaID;
  String? sankalpAadhaarShaakhaaName;
  int? sankalpCompletionMonth;
  int? sankalpCompletionYear;
  bool? hasToli;
  bool? hasPaalak;
  int? optionalShaaririkVishayID;
  String? optionalShaaririkVishayCode;
  String? otherOptionalVishay;
  double? shaakhaaLatitude;
  double? shaakhaaLongitude;
  String? kaaryavaahName;
  String? kaaryavaahMobileNumber;
  String? sahaKaaryavaahName;
  String? sahaKaaryavaahMobileNumber;
  int? parentVastiID;
  int? parentGraamID;
  int? parentMandalID;
  int? parentUpaNagarID;
  int? parentNagarID;
  int? parentBhaagID;
  String? modifiedDate;

  ShaakhaaList(
      {this.shaakhaaID,
      this.mapShaakhaaID,
      this.praantID,
      this.isnew,
      this.isanya,
      this.pkid,
      this.geoUnitID,
      this.geoUnitName,
      this.trail,
      this.geoUnitNameDevNaagari,
      this.frequencyID,
      this.frequencyCode,
      this.daysOfWeek,
      this.dayNamesOfWeek,
      this.dayOfMonth,
      this.vayogatID,
      this.vayogatCode,
      this.location,
      this.startTimeStr,
      this.endTimeStr,
      this.remark,
      this.isSankalpit,
      this.sankalpAadhaar,
      this.sankalpAadhaarSwayamsevakID,
      this.sankalpAadhaarSwayamsevakName,
      this.sankalpAadhaarShaakhaaID,
      this.sankalpAadhaarShaakhaaName,
      this.sankalpCompletionMonth,
      this.sankalpCompletionYear,
      this.hasToli,
      this.hasPaalak,
      this.optionalShaaririkVishayID,
      this.optionalShaaririkVishayCode,
      this.otherOptionalVishay,
      this.shaakhaaLatitude,
      this.shaakhaaLongitude,
      this.kaaryavaahName,
      this.kaaryavaahMobileNumber,
      this.sahaKaaryavaahName,
      this.sahaKaaryavaahMobileNumber,
      this.parentVastiID,
      this.parentGraamID,
      this.parentMandalID,
      this.parentUpaNagarID,
      this.parentNagarID,
      this.parentBhaagID,
      this.modifiedDate});

  ShaakhaaList.fromJson(Map<String, dynamic> json) {
    shaakhaaID = json['ShaakhaaID'];
    mapShaakhaaID = json['mapShaakhaaID'];
    praantID = json['PraantID'];
    isnew = json['isnew'];
    isanya = json['isanya'] ?? json['IsAnya'];
    pkid = json['pkid'];
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    trail = json['trail'];
    geoUnitNameDevNaagari = json['GeoUnitNameDevNaagari'];
    frequencyID = json['FrequencyID'];
    frequencyCode = json['FrequencyCode'];
    daysOfWeek = json['DaysOfWeek'];
    dayNamesOfWeek = json['DayNamesOfWeek'];
    dayOfMonth = json['DayOfMonth'];
    vayogatID = json['VayogatID'];
    vayogatCode = json['VayogatCode'];
    location = json['Location'];
    startTimeStr = json['StartTimeStr'];
    endTimeStr = json['EndTimeStr'];
    remark = json['Remark'];
    isSankalpit = toBool(json['IsSankalpit']);
    sankalpAadhaar = json['SankalpAadhaar'];
    sankalpAadhaarSwayamsevakID = json['SankalpAadhaarSwayamsevakID'];
    sankalpAadhaarSwayamsevakName = json['SankalpAadhaarSwayamsevakName'];
    sankalpAadhaarShaakhaaID = json['SankalpAadhaarShaakhaaID'];
    sankalpAadhaarShaakhaaName = json['SankalpAadhaarShaakhaaName'];
    sankalpCompletionMonth = json['SankalpCompletionMonth'];
    sankalpCompletionYear = json['SankalpCompletionYear'];
    hasToli = toBool(json['HasToli']);
    hasPaalak = toBool(json['HasPaalak']);
    optionalShaaririkVishayID = json['OptionalShaaririkVishayID'];
    optionalShaaririkVishayCode = json['OptionalShaaririkVishayCode'];
    otherOptionalVishay = json['OtherOptionalVishay'];
    shaakhaaLatitude = json['ShaakhaaLatitude'];
    shaakhaaLongitude = json['ShaakhaaLongitude'];
    kaaryavaahName = json['KaaryavaahName'];
    kaaryavaahMobileNumber = json['KaaryavaahMobileNumber'];
    sahaKaaryavaahName = json['SahaKaaryavaahName'];
    sahaKaaryavaahMobileNumber = json['SahaKaaryavaahMobileNumber'];
    parentVastiID = json['ParentVastiID'];
    parentGraamID = json['ParentGraamID'];
    parentMandalID = json['ParentMandalID'];
    parentUpaNagarID = json['ParentUpaNagarID'];
    parentNagarID = json['ParentNagarID'];
    parentBhaagID = json['ParentBhaagID'];
    modifiedDate = json['ModifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShaakhaaID'] = this.shaakhaaID;
    data['mapShaakhaaID'] = this.mapShaakhaaID;
    data['PraantID'] = this.praantID;
    data['isnew'] = this.isnew;
    data['IsAnya'] = this.isanya;
    data['pkid'] = this.pkid;
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['trail'] = this.trail;
    data['GeoUnitNameDevNaagari'] = this.geoUnitNameDevNaagari;
    data['FrequencyID'] = this.frequencyID;
    data['FrequencyCode'] = this.frequencyCode;
    data['DaysOfWeek'] = this.daysOfWeek;
    data['DayNamesOfWeek'] = this.dayNamesOfWeek;
    data['DayOfMonth'] = this.dayOfMonth;
    data['VayogatID'] = this.vayogatID;
    data['VayogatCode'] = this.vayogatCode;
    data['Location'] = this.location;
    data['StartTimeStr'] = this.startTimeStr;
    data['EndTimeStr'] = this.endTimeStr;
    data['Remark'] = this.remark;
    data['IsSankalpit'] = this.isSankalpit == true ? 1 : 0;
    data['SankalpAadhaar'] = this.sankalpAadhaar;
    data['SankalpAadhaarSwayamsevakID'] = this.sankalpAadhaarSwayamsevakID;
    data['SankalpAadhaarSwayamsevakName'] = this.sankalpAadhaarSwayamsevakName;
    data['SankalpAadhaarShaakhaaID'] = this.sankalpAadhaarShaakhaaID;
    data['SankalpAadhaarShaakhaaName'] = this.sankalpAadhaarShaakhaaName;
    data['SankalpCompletionMonth'] = this.sankalpCompletionMonth;
    data['SankalpCompletionYear'] = this.sankalpCompletionYear;
    data['HasToli'] = this.hasToli == true ? 1 : 0;
    data['HasPaalak'] = this.hasPaalak == true ? 1 : 0;
    data['OptionalShaaririkVishayID'] = this.optionalShaaririkVishayID;
    data['OptionalShaaririkVishayCode'] = this.optionalShaaririkVishayCode;
    data['OtherOptionalVishay'] = this.otherOptionalVishay;
    data['ShaakhaaLatitude'] = this.shaakhaaLatitude;
    data['ShaakhaaLongitude'] = this.shaakhaaLongitude;
    data['KaaryavaahName'] = this.kaaryavaahName;
    data['KaaryavaahMobileNumber'] = this.kaaryavaahMobileNumber;
    data['SahaKaaryavaahName'] = this.sahaKaaryavaahName;
    data['SahaKaaryavaahMobileNumber'] = this.sahaKaaryavaahMobileNumber;
    data['ParentVastiID'] = this.parentVastiID;
    data['ParentGraamID'] = this.parentGraamID;
    data['ParentMandalID'] = this.parentMandalID;
    data['ParentUpaNagarID'] = this.parentUpaNagarID;
    data['ParentNagarID'] = this.parentNagarID;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ModifiedDate'] = this.modifiedDate;
    return data;
  }
}
