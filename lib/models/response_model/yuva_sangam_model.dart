class YuvaSangamRespModel {
  String? status;
  String? message;
  List<YuvaSangamData>? dataa;

  YuvaSangamRespModel({this.status, this.message, this.dataa});

  YuvaSangamRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Dataa'] != null) {
      dataa = <YuvaSangamData>[];
      json['Dataa'].forEach((v) {
        dataa!.add(new YuvaSangamData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.dataa != null) {
      data['Dataa'] = this.dataa!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class YuvaSangamData {
  int? pkid;
  String? yuvadate;
  int? shatapdistharlevelid;
  int? geounitid;
  String? trailids;
  String? name;
  int? isstarted;
  String? trailNames;

  YuvaSangamData({this.pkid, this.yuvadate, this.shatapdistharlevelid, this.geounitid, this.trailids, this.name, this.isstarted, this.trailNames});

  YuvaSangamData.fromJson(Map<String, dynamic> json) {
    pkid = json['pkid'];
    yuvadate = json['yuvadate'];
    shatapdistharlevelid = json['shatapdistharlevelid'];
    geounitid = json['geounitid'];
    trailids = json['trailids'];
    name = json['name'];
    isstarted = json['isstarted'];
    trailNames = json['TrailNames'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['yuvadate'] = this.yuvadate;
    data['shatapdistharlevelid'] = this.shatapdistharlevelid;
    data['geounitid'] = this.geounitid;
    data['trailids'] = this.trailids;
    data['name'] = this.name;
    data['isstarted'] = this.isstarted;
    data['TrailNames'] = this.trailNames;
    return data;
  }
}
