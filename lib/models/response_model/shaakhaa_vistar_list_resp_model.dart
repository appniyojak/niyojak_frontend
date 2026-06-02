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
  int? praantID;
  int? isnew;
  int? pkid;
  int? geoUnitID;
  String? geoUnitName;
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
  int? parentShaharID;
  int? parentNagarID;
  int? parentBhaagID;

  ShaakhaaList(
      {this.shaakhaaID,
      this.praantID,
      this.isnew,
      this.pkid,
      this.geoUnitID,
      this.geoUnitName,
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
      this.parentShaharID,
      this.parentNagarID,
      this.parentBhaagID});

  ShaakhaaList.fromJson(Map<String, dynamic> json) {
    shaakhaaID = json['ShaakhaaID'];
    praantID = json['PraantID'];
    isnew = json['isnew'];
    pkid = json['pkid'];
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
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
    isSankalpit = json['IsSankalpit'];
    sankalpAadhaar = json['SankalpAadhaar'];
    sankalpAadhaarSwayamsevakID = json['SankalpAadhaarSwayamsevakID'];
    sankalpAadhaarSwayamsevakName = json['SankalpAadhaarSwayamsevakName'];
    sankalpAadhaarShaakhaaID = json['SankalpAadhaarShaakhaaID'];
    sankalpAadhaarShaakhaaName = json['SankalpAadhaarShaakhaaName'];
    sankalpCompletionMonth = json['SankalpCompletionMonth'];
    sankalpCompletionYear = json['SankalpCompletionYear'];
    hasToli = json['HasToli'];
    hasPaalak = json['HasPaalak'];
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
    parentShaharID = json['ParentShaharID'];
    parentNagarID = json['ParentNagarID'];
    parentBhaagID = json['ParentBhaagID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShaakhaaID'] = this.shaakhaaID;
    data['PraantID'] = this.praantID;
    data['isnew'] = this.isnew;
    data['pkid'] = this.pkid;
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
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
    data['IsSankalpit'] = this.isSankalpit;
    data['SankalpAadhaar'] = this.sankalpAadhaar;
    data['SankalpAadhaarSwayamsevakID'] = this.sankalpAadhaarSwayamsevakID;
    data['SankalpAadhaarSwayamsevakName'] = this.sankalpAadhaarSwayamsevakName;
    data['SankalpAadhaarShaakhaaID'] = this.sankalpAadhaarShaakhaaID;
    data['SankalpAadhaarShaakhaaName'] = this.sankalpAadhaarShaakhaaName;
    data['SankalpCompletionMonth'] = this.sankalpCompletionMonth;
    data['SankalpCompletionYear'] = this.sankalpCompletionYear;
    data['HasToli'] = this.hasToli;
    data['HasPaalak'] = this.hasPaalak;
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
    data['ParentShaharID'] = this.parentShaharID;
    data['ParentNagarID'] = this.parentNagarID;
    data['ParentBhaagID'] = this.parentBhaagID;
    return data;
  }
}
