class ShaakhaaVistarDetailRespModel {
  String? status;
  String? message;
  ShakhaaVistarDetail? obj;

  ShaakhaaVistarDetailRespModel({this.status, this.message, this.obj});

  ShaakhaaVistarDetailRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    obj = json['obj'] != null ? new ShakhaaVistarDetail.fromJson(json['obj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.obj != null) {
      data['obj'] = this.obj!.toJson();
    }
    return data;
  }
}

class ShakhaaVistarDetail {
  int? praantID;
  int? parentBhaagID;
  int? parentShaharID;
  int? pkId;
  int? parentNagarID;
  int? parentMandalID;
  int? parentGraamID;
  int? parentVastiID;
  int? shaakhaaID;
  String? shaakhaaName;
  String? shaakhaaNameDevNaagari;
  String? aadhar1;
  String? aadhar2;
  String? aadhar3;
  String? aadhar4;
  String? aadhar5;
  int? frequencyID;
  String? daysOfWeek;
  String? dayOfMonth;
  int? vayogatID;
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
  String? otherOptionalVishay;
  int? optionalShaaririkVishayID;
  int? modifiedBy;

  ShakhaaVistarDetail(
      {this.praantID,
      this.parentBhaagID,
      this.parentShaharID,
      this.pkId,
      this.parentNagarID,
      this.parentMandalID,
      this.parentGraamID,
      this.parentVastiID,
      this.shaakhaaID,
      this.shaakhaaName,
      this.shaakhaaNameDevNaagari,
      this.aadhar1,
      this.aadhar2,
      this.aadhar3,
      this.aadhar4,
      this.aadhar5,
      this.frequencyID,
      this.daysOfWeek,
      this.dayOfMonth,
      this.vayogatID,
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
      this.otherOptionalVishay,
      this.optionalShaaririkVishayID,
      this.modifiedBy});

  ShakhaaVistarDetail.fromJson(Map<String, dynamic> json) {
    praantID = json['PraantID'];
    parentBhaagID = json['ParentBhaagID'];
    parentShaharID = json['ParentShaharID'];
    pkId = json['PkId'];
    parentNagarID = json['ParentNagarID'];
    parentMandalID = json['ParentMandalID'];
    parentGraamID = json['ParentGraamID'];
    parentVastiID = json['ParentVastiID'];
    shaakhaaID = json['ShaakhaaID'];
    shaakhaaName = json['ShaakhaaName'] ?? json['GeoUnitName'];
    shaakhaaNameDevNaagari = json['ShaakhaaNameDevNaagari'];
    aadhar1 = json['aadhar1'];
    aadhar2 = json['aadhar2'];
    aadhar3 = json['aadhar3'];
    aadhar4 = json['aadhar4'];
    aadhar5 = json['aadhar5'];
    frequencyID = json['FrequencyID'];
    daysOfWeek = json['DaysOfWeek'];
    dayOfMonth = json['DayOfMonth'];
    vayogatID = json['VayogatID'];
    location = json['Location'];
    startTimeStr = json['StartTimeStr'];
    endTimeStr = json['EndTimeStr'];
    remark = json['Remark'];
    isSankalpit = json['IsSankalpit'];
    sankalpAadhaar = json['SankalpAadhaar'];
    sankalpAadhaarSwayamsevakID = json['SankalpAadhaarSwayamsevakID'];
    sankalpAadhaarSwayamsevakName = json['SankalpSwayamsevakname'];
    sankalpAadhaarShaakhaaID = json['SankalpAadhaarShaakhaaID'];
    sankalpAadhaarShaakhaaName = json['SankalpAadhaarShaakhaaName'];
    sankalpCompletionMonth = json['SankalpCompletionMonth'];
    sankalpCompletionYear = json['SankalpCompletionYear'];
    hasToli = json['HasToli'];
    hasPaalak = json['HasPaalak'];
    otherOptionalVishay = json['OtherOptionalVishay'];
    optionalShaaririkVishayID = json['OptionalShaaririkVishayID'];
    modifiedBy = json['ModifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PraantID'] = this.praantID;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ParentShaharID'] = this.parentShaharID;
    data['PkId'] = this.pkId;
    data['ParentNagarID'] = this.parentNagarID;
    data['ParentMandalID'] = this.parentMandalID;
    data['ParentGraamID'] = this.parentGraamID;
    data['ParentVastiID'] = this.parentVastiID;
    data['ShaakhaaID'] = this.shaakhaaID;
    data['ShaakhaaName'] = this.shaakhaaName;
    data['ShaakhaaNameDevNaagari'] = this.shaakhaaNameDevNaagari;
    data['aadhar1'] = this.aadhar1;
    data['aadhar2'] = this.aadhar2;
    data['aadhar3'] = this.aadhar3;
    data['aadhar4'] = this.aadhar4;
    data['aadhar5'] = this.aadhar5;
    data['FrequencyID'] = this.frequencyID;
    data['DaysOfWeek'] = this.daysOfWeek;
    data['DayOfMonth'] = this.dayOfMonth;
    data['VayogatID'] = this.vayogatID;
    data['Location'] = this.location;
    data['StartTimeStr'] = this.startTimeStr;
    data['EndTimeStr'] = this.endTimeStr;
    data['Remark'] = this.remark;
    data['IsSankalpit'] = this.isSankalpit;
    data['SankalpAadhaar'] = this.sankalpAadhaar;
    data['SankalpAadhaarSwayamsevakID'] = this.sankalpAadhaarSwayamsevakID;
    data['SankalpSwayamsevakname'] = this.sankalpAadhaarSwayamsevakName;
    data['SankalpAadhaarShaakhaaID'] = this.sankalpAadhaarShaakhaaID;
    data['SankalpAadhaarShaakhaaName'] = this.sankalpAadhaarShaakhaaName;
    data['SankalpCompletionMonth'] = this.sankalpCompletionMonth;
    data['SankalpCompletionYear'] = this.sankalpCompletionYear;
    data['HasToli'] = this.hasToli;
    data['HasPaalak'] = this.hasPaalak;
    data['OtherOptionalVishay'] = this.otherOptionalVishay;
    data['OptionalShaaririkVishayID'] = this.optionalShaaririkVishayID;
    data['ModifiedBy'] = this.modifiedBy;
    return data;
  }
}
