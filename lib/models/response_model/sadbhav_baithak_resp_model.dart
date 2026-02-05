class SadbhavBaithakRespModel {
  String? status;
  String? message;
  List<SadbhavMasterdata>? masterdata;
  List<Nagardata>? nagardata;

  SadbhavBaithakRespModel({this.status, this.message, this.masterdata, this.nagardata});

  SadbhavBaithakRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Masterdata'] != null) {
      masterdata = <SadbhavMasterdata>[];
      json['Masterdata'].forEach((v) {
        masterdata!.add(new SadbhavMasterdata.fromJson(v));
      });
    }
    if (json['nagardata'] != null) {
      nagardata = <Nagardata>[];
      json['nagardata'].forEach((v) {
        nagardata!.add(new Nagardata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.masterdata != null) {
      data['Masterdata'] = this.masterdata!.map((v) => v.toJson()).toList();
    }
    if (this.nagardata != null) {
      data['nagardata'] = this.nagardata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SadbhavMasterdata {
  String? geoname;
  int? pkid;
  String? programdate;
  int? shatapdistharlevelid;
  int? geounitid;
  String? name;
  int? parentMahaanagarID;
  int? parentVibhaagID;
  int? parentBhaagID;
  int? parentNagarID;
  int? parentUpaNagarID;
  int? parentGraamID;
  int? parentMandalID;
  int? parentVastiID;
  int? geolevelid;

  SadbhavMasterdata(
      {this.geoname,
      this.pkid,
      this.programdate,
      this.shatapdistharlevelid,
      this.geounitid,
      this.name,
      this.parentMahaanagarID,
      this.parentVibhaagID,
      this.parentBhaagID,
      this.parentNagarID,
      this.parentUpaNagarID,
      this.parentGraamID,
      this.parentMandalID,
      this.parentVastiID,
      this.geolevelid});

  SadbhavMasterdata.fromJson(Map<String, dynamic> json) {
    geoname = json['geoname'];
    pkid = json['pkid'];
    programdate = json['programdate'];
    shatapdistharlevelid = json['shatapdistharlevelid'];
    geounitid = json['geounitid'];
    name = json['name'];
    parentMahaanagarID = json['ParentMahaanagarID'];
    parentVibhaagID = json['ParentVibhaagID'];
    parentBhaagID = json['ParentBhaagID'];
    parentNagarID = json['ParentNagarID'];
    parentUpaNagarID = json['ParentUpaNagarID'];
    parentGraamID = json['ParentGraamID'];
    parentMandalID = json['ParentMandalID'];
    parentVastiID = json['ParentVastiID'];
    geolevelid = json['geolevelid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geoname'] = this.geoname;
    data['pkid'] = this.pkid;
    data['programdate'] = this.programdate;
    data['shatapdistharlevelid'] = this.shatapdistharlevelid;
    data['geounitid'] = this.geounitid;
    data['name'] = this.name;
    data['ParentMahaanagarID'] = this.parentMahaanagarID;
    data['ParentVibhaagID'] = this.parentVibhaagID;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ParentNagarID'] = this.parentNagarID;
    data['ParentUpaNagarID'] = this.parentUpaNagarID;
    data['ParentGraamID'] = this.parentGraamID;
    data['ParentMandalID'] = this.parentMandalID;
    data['ParentVastiID'] = this.parentVastiID;
    data['geolevelid'] = this.geolevelid;
    return data;
  }
}

class Nagardata {
  int? geoUnitID;
  int? chkstatus;
  String? geoname;

  Nagardata({this.geoUnitID, this.chkstatus, this.geoname});

  Nagardata.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    chkstatus = json['chkstatus'];
    geoname = json['geoname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['chkstatus'] = this.chkstatus;
    data['geoname'] = this.geoname;
    return data;
  }
}
