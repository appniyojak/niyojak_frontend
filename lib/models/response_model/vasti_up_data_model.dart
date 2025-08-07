class VastiUpDataListModel {
  String? message;
  String? status;
  // List<Null>? upnagarmandallist;
  List<Vastimandallist>? vastimandallist;

  VastiUpDataListModel(
      {this.message,
      this.status,
      // this.upnagarmandallist,
      this.vastimandallist});

  VastiUpDataListModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    // if (json['upnagarmandallist'] != null) {
    //   upnagarmandallist = <Null>[];
    //   json['upnagarmandallist'].forEach((v) {
    //     upnagarmandallist!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['vastimandallist'] != null) {
      vastimandallist = <Vastimandallist>[];
      json['vastimandallist'].forEach((v) {
        vastimandallist!.add(new Vastimandallist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    // if (this.upnagarmandallist != null) {
    //   data['upnagarmandallist'] =
    //       this.upnagarmandallist!.map((v) => v.toJson()).toList();
    // }
    if (this.vastimandallist != null) {
      data['vastimandallist'] =
          this.vastimandallist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vastimandallist {
  int? geoUnitID;
  String? geoUnitName;
  String? geoUnitNameHindi;
  String? geoUnitNameMarathi;
  int? linkedUpaNagarID;

  Vastimandallist(
      {this.geoUnitID,
      this.geoUnitName,
      this.geoUnitNameHindi,
      this.geoUnitNameMarathi,
      this.linkedUpaNagarID});

  Vastimandallist.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    geoUnitNameHindi = json['GeoUnitNameHindi'];
    geoUnitNameMarathi = json['GeoUnitNameMarathi'];
    linkedUpaNagarID = json['linkedUpaNagarID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['GeoUnitNameHindi'] = this.geoUnitNameHindi;
    data['GeoUnitNameMarathi'] = this.geoUnitNameMarathi;
    data['linkedUpaNagarID'] = this.linkedUpaNagarID;
    return data;
  }
}
