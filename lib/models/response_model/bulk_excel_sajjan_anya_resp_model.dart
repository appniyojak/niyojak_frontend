class BulkExcelSajjanAnyaRespModel {
  String? status;
  String? message;
  List<SajjanAnyaData>? valid;
  List<SajjanAnyaData>? invalid;
  List<SajjanAnyaData>? duplicate;

  BulkExcelSajjanAnyaRespModel({this.status, this.message, this.valid, this.invalid, this.duplicate});

  BulkExcelSajjanAnyaRespModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['valid'] != null) {
      valid = <SajjanAnyaData>[];
      json['valid'].forEach((v) {
        valid!.add(new SajjanAnyaData.fromJson(v));
      });
    }
    if (json['invalid'] != null) {
      invalid = <SajjanAnyaData>[];
      json['invalid'].forEach((v) {
        invalid!.add(new SajjanAnyaData.fromJson(v));
      });
    }
    if (json['duplicate'] != null) {
      duplicate = <SajjanAnyaData>[];
      json['duplicate'].forEach((v) {
        duplicate!.add(new SajjanAnyaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.valid != null) {
      data['valid'] = this.valid!.map((v) => v.toJson()).toList();
    }
    if (this.invalid != null) {
      data['invalid'] = this.invalid!.map((v) => v.toJson()).toList();
    }
    if (this.duplicate != null) {
      data['duplicate'] = this.duplicate!.map((v) => v.toJson()).toList();
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
  String? shreni;
  int? shreniid;
  String? upshreni;
  String? upshreniid;
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
      this.shreni,
      this.shreniid,
      this.upshreni,
      this.upshreniid,
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
    excelRowNumber = json['excelRowNumber'];
    naav = json['naav'];
    patta = json['patta'];
    doorbhash = json['doorbhash'];
    ling = json['ling'];
    shreni = json['shreni'];
    shreniid = json['shreniid'];
    upshreni = json['upshreni'];
    upshreniid = json['upshreniid'];
    anyaVishesh = json['anyaVishesh'];
    anyaVisheshid = json['anyaVisheshid'];
    anyaPrabhavKshetra = json['anyaPrabhavKshetra'];
    anyaPrabhavKshetraid = json['anyaPrabhavKshetraid'];
    anyaVisheshMahiti = json['anyaVisheshMahiti'];
    anyaSamparkSthiti = json['anyaSamparkSthiti'];
    anyaSamparkSthitiid = json['anyaSamparkSthitiid'];
    sansthaNaav = json['sansthaNaav'];
    sansthaPadavi = json['sansthaPadavi'];
    sajjanSamparkSthiti = json['sajjanSamparkSthiti'];
    sajjanSamparkSthitiid = json['sajjanSamparkSthitiid'];
    sajjanVishesh = json['sajjanVishesh'];
    sajjanVisheshid = json['sajjanVisheshid'];
    sajjanPrabhavKshetra = json['sajjanPrabhavKshetra'];
    sajjanPrabhavKshetraid = json['sajjanPrabhavKshetraid'];
    samparkSutraNaav = json['samparkSutraNaav'];
    samparkSutraDoorbhash = json['samparkSutraDoorbhash'];
    rowStatus = json['rowStatus'];
    errorMessages = json['errorMessages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['excelRowNumber'] = this.excelRowNumber;
    data['naav'] = this.naav;
    data['patta'] = this.patta;
    data['doorbhash'] = this.doorbhash;
    data['ling'] = this.ling;
    data['shreni'] = this.shreni;
    data['shreniid'] = this.shreniid;
    data['upshreni'] = this.upshreni;
    data['upshreniid'] = this.upshreniid;
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
