class BulkExcelSajjanAnyaRespModel {
  String? status;
  String? message;
  List<SajjanAnyaData>? valid;
  List<SajjanAnyaData>? invalid;
  List<SajjanAnyaData>? duplicate;

  BulkExcelSajjanAnyaRespModel({this.status, this.message, this.valid, this.invalid, this.duplicate});

  BulkExcelSajjanAnyaRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'] ?? json['status'];
    message = json['Message'] ?? json['message'];
    if (json['Valid'] != null) {
      valid = <SajjanAnyaData>[];
      json['Valid'].forEach((v) {
        valid!.add(new SajjanAnyaData.fromJson(v));
      });
    }
    if (json['Invalid'] != null) {
      invalid = <SajjanAnyaData>[];
      json['Invalid'].forEach((v) {
        invalid!.add(new SajjanAnyaData.fromJson(v));
      });
    }
    if (json['Duplicate'] != null) {
      duplicate = <SajjanAnyaData>[];
      json['Duplicate'].forEach((v) {
        duplicate!.add(new SajjanAnyaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.valid != null) {
      data['Valid'] = this.valid!.map((v) => v.toJson()).toList();
    }
    if (this.invalid != null) {
      data['Invalid'] = this.invalid!.map((v) => v.toJson()).toList();
    }
    if (this.duplicate != null) {
      data['Duplicate'] = this.duplicate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SajjanAnyaData {
  int? excelRowNumber;
  String? naav;
  String? patta;
  String? doorbhash;
  String? ling;
  int? isfemale;
  String? shreni;
  int? shreniid;
  String? upshreni;
  String? upshreniid;
  String? upshreni2;
  String? upshreni2id;
  String? anyaVishesh;
  int? anyaVisheshid;
  String? anyaPrabhavKshetra;
  int? anyaPrabhavKshetraid;
  String? anyaVisheshMahiti;
  String? anyaSamparkSthiti;
  int? anyaSamparkSthitiid;
  String? sansthaNaav;
  String? sansthaPadavi;
  String? sajjanSamparkSthiti;
  int? sajjanSamparkSthitiid;
  String? sajjanVishesh;
  int? sajjanVisheshid;
  String? sajjanPrabhavKshetra;
  int? sajjanPrabhavKshetraid;
  String? samparkSutraNaav;
  String? samparkSutraDoorbhash;
  String? rowStatus;
  List<String>? errorMessages;

  SajjanAnyaData(
      {this.excelRowNumber,
      this.naav,
      this.patta,
      this.doorbhash,
      this.ling,
      this.isfemale,
      this.shreni,
      this.shreniid,
      this.upshreni,
      this.upshreniid,
      this.upshreni2,
      this.upshreni2id,
      this.anyaVishesh,
      this.anyaVisheshid,
      this.anyaPrabhavKshetra,
      this.anyaPrabhavKshetraid,
      this.anyaVisheshMahiti,
      this.anyaSamparkSthiti,
      this.anyaSamparkSthitiid,
      this.sansthaNaav,
      this.sansthaPadavi,
      this.sajjanSamparkSthiti,
      this.sajjanSamparkSthitiid,
      this.sajjanVishesh,
      this.sajjanVisheshid,
      this.sajjanPrabhavKshetra,
      this.sajjanPrabhavKshetraid,
      this.samparkSutraNaav,
      this.samparkSutraDoorbhash,
      this.rowStatus,
      this.errorMessages});

  SajjanAnyaData.fromJson(Map<String, dynamic> json) {
    excelRowNumber = json['ExcelRowNumber'] ?? json['excelRowNumber'];
    naav = json['Naav'] ?? json['naav'];
    patta = json['Patta'] ?? json['patta'];
    doorbhash = json['Doorbhash'] ?? json['doorbhash'];
    ling = json['Ling'] ?? json['ling'];
    isfemale = json['Isfemale'] ?? json['isfemale'] ?? 0;
    shreni = json['Shreni'] ?? json['shreni'];
    shreniid = json['Shreniid'] ?? json['shreniid'];
    upshreni = json['Upshreni'] ?? json['upshreni'];
    upshreniid = json['Upshreniid'] ?? json['upshreniid'];
    upshreni2 = json['Upshreni2'] ?? json['upshreni2'];
    upshreni2id = json['Upshreni2id'] ?? json['upshreni2id'];
    anyaVishesh = json['AnyaVishesh'] ?? json['anyaVishesh'];
    anyaVisheshid = json['AnyaVisheshid'] ?? json['anyaVisheshid'];
    anyaPrabhavKshetra = json['AnyaPrabhavKshetra'] ?? json['anyaPrabhavKshetra'];
    anyaPrabhavKshetraid = json['AnyaPrabhavKshetraid'] ?? json['anyaPrabhavKshetraid'];
    anyaVisheshMahiti = json['AnyaVisheshMahiti'] ?? json['anyaVisheshMahiti'];
    anyaSamparkSthiti = json['AnyaSamparkSthiti'] ?? json['anyaSamparkSthiti'];
    anyaSamparkSthitiid = json['AnyaSamparkSthitiid'] ?? json['anyaSamparkSthitiid'];
    sansthaNaav = json['SansthaNaav'] ?? json['sansthaNaav'];
    sansthaPadavi = json['SansthaPadavi'] ?? json['sansthaPadavi'];
    sajjanSamparkSthiti = json['SajjanSamparkSthiti'] ?? json['sajjanSamparkSthiti'];
    sajjanSamparkSthitiid = json['SajjanSamparkSthitiid'] ?? json['sajjanSamparkSthitiid'];
    sajjanVishesh = json['SajjanVishesh'] ?? json['sajjanVishesh'];
    sajjanVisheshid = json['SajjanVisheshid'] ?? json['sajjanVisheshid'];
    sajjanPrabhavKshetra = json['SajjanPrabhavKshetra'] ?? json['sajjanPrabhavKshetra'];
    sajjanPrabhavKshetraid = json['SajjanPrabhavKshetraid'] ?? json['sajjanPrabhavKshetraid'];
    samparkSutraNaav = json['SamparkSutraNaav'] ?? json['samparkSutraNaav'];
    samparkSutraDoorbhash = json['SamparkSutraDoorbhash'] ?? json['samparkSutraDoorbhash'];
    rowStatus = json['RowStatus'] ?? json['rowStatus'];
    errorMessages = (json['ErrorMessages'] ?? json['errorMessages']).cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['excelRowNumber'] = this.excelRowNumber;
    data['naav'] = this.naav;
    data['patta'] = this.patta;
    data['doorbhash'] = this.doorbhash;
    data['ling'] = this.ling;
    data['isfemale'] = this.isfemale;
    data['shreni'] = this.shreni;
    data['shreniid'] = this.shreniid;
    data['upshreni'] = this.upshreni;
    data['upshreniid'] = this.upshreniid;
    data['upshreni2'] = this.upshreni2;
    data['upshreni2id'] = this.upshreni2id;
    data['anyaVishesh'] = this.anyaVishesh;
    data['anyaVisheshid'] = this.anyaVisheshid;
    data['anyaPrabhavKshetra'] = this.anyaPrabhavKshetra;
    data['anyaPrabhavKshetraid'] = this.anyaPrabhavKshetraid;
    data['anyaVisheshMahiti'] = this.anyaVisheshMahiti;
    data['anyaSamparkSthiti'] = this.anyaSamparkSthiti;
    data['anyaSamparkSthitiid'] = this.anyaSamparkSthitiid;
    data['sansthaNaav'] = this.sansthaNaav;
    data['sansthaPadavi'] = this.sansthaPadavi;
    data['sajjanSamparkSthiti'] = this.sajjanSamparkSthiti;
    data['sajjanSamparkSthitiid'] = this.sajjanSamparkSthitiid;
    data['sajjanVishesh'] = this.sajjanVishesh;
    data['sajjanVisheshid'] = this.sajjanVisheshid;
    data['sajjanPrabhavKshetra'] = this.sajjanPrabhavKshetra;
    data['sajjanPrabhavKshetraid'] = this.sajjanPrabhavKshetraid;
    data['samparkSutraNaav'] = this.samparkSutraNaav;
    data['samparkSutraDoorbhash'] = this.samparkSutraDoorbhash;
    data['rowStatus'] = this.rowStatus;
    data['errorMessages'] = this.errorMessages;
    return data;
  }
}
