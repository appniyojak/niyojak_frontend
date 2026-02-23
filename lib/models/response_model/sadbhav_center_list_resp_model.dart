class SadbhavCenterListRespModel {
  String? status;
  String? message;
  SadbhavCenter? data;

  SadbhavCenterListRespModel({this.status, this.message, this.data});

  SadbhavCenterListRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data = json['data'] != null ? new SadbhavCenter.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SadbhavCenter {
  String? sthartype;
  String? centername;
  String? geounitname;

  SadbhavCenter({this.sthartype, this.centername, this.geounitname});

  SadbhavCenter.fromJson(Map<String, dynamic> json) {
    sthartype = json['sthartype'];
    centername = json['centername'];
    geounitname = json['geounitname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sthartype'] = this.sthartype;
    data['centername'] = this.centername;
    data['geounitname'] = this.geounitname;
    return data;
  }
}
