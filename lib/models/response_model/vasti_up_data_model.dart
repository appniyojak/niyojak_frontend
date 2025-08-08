class VastiUpDataListModel {
  String? message;
  String? status;
  List<Upnagarmandallist>? upnagarmandallist;
  List<Upnagarmandallist>? vastimandallist;

  VastiUpDataListModel(
      {this.message,
      this.status,
      this.upnagarmandallist,
      this.vastimandallist});

  VastiUpDataListModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['upnagarmandallist'] != null) {
      upnagarmandallist = <Upnagarmandallist>[];
      json['upnagarmandallist'].forEach((v) {
        upnagarmandallist!.add(new Upnagarmandallist.fromJson(v));
      });
    }
    if (json['vastimandallist'] != null) {
      vastimandallist = <Upnagarmandallist>[];
      json['vastimandallist'].forEach((v) {
        vastimandallist!.add(new Upnagarmandallist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.upnagarmandallist != null) {
      data['upnagarmandallist'] =
          this.upnagarmandallist!.map((v) => v.toJson()).toList();
    }
    if (this.vastimandallist != null) {
      data['vastimandallist'] =
          this.vastimandallist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Upnagarmandallist {
  int? geoUnitID;
  String? preferedname;
  String? geoUnitName;
  String? geoUnitNameHindi;
  String? geoUnitNameMarathi;
  int? linkedUpaNagarID;

  Upnagarmandallist(
      {this.geoUnitID,
      this.preferedname,
      this.geoUnitName,
      this.geoUnitNameHindi,
      this.geoUnitNameMarathi,
      this.linkedUpaNagarID});

  Upnagarmandallist.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    preferedname = json['Preferedname'];
    geoUnitName = json['GeoUnitName'];
    geoUnitNameHindi = json['GeoUnitNameHindi'];
    geoUnitNameMarathi = json['GeoUnitNameMarathi'];
    linkedUpaNagarID = json['linkedUpaNagarID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['Preferedname'] = this.preferedname;
    data['GeoUnitName'] = this.geoUnitName;
    data['GeoUnitNameHindi'] = this.geoUnitNameHindi;
    data['GeoUnitNameMarathi'] = this.geoUnitNameMarathi;
    data['linkedUpaNagarID'] = this.linkedUpaNagarID;
    return data;
  }
}
