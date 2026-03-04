class SadbhavKendraRespModel {
  String? status;
  String? message;
  List<SadbhavKendraMasterdata>? masterdata;
  List<Nagardata>? nagardata;
  List<Bhaitakdata>? bhaitakdata;

  SadbhavKendraRespModel({this.status, this.message, this.masterdata, this.nagardata, this.bhaitakdata});

  SadbhavKendraRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Masterdata'] != null) {
      masterdata = <SadbhavKendraMasterdata>[];
      json['Masterdata'].forEach((v) {
        masterdata!.add(new SadbhavKendraMasterdata.fromJson(v));
      });
    }
    if (json['nagardata'] != null) {
      nagardata = <Nagardata>[];
      json['nagardata'].forEach((v) {
        nagardata!.add(new Nagardata.fromJson(v));
      });
    }
    if (json['bhaitakdata'] != null) {
      bhaitakdata = <Bhaitakdata>[];
      json['bhaitakdata'].forEach((v) {
        bhaitakdata!.add(new Bhaitakdata.fromJson(v));
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
    if (this.bhaitakdata != null) {
      data['bhaitakdata'] = this.bhaitakdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SadbhavKendraMasterdata {
  int? pkid;
  int? shatapdistharlevelid;
  String? stharname;
  int? geounitid;
  String? kendraname;
  String? geoname;
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

  SadbhavKendraMasterdata(
      {this.pkid,
      this.shatapdistharlevelid,
      this.stharname,
      this.geounitid,
      this.kendraname,
      this.geoname,
      this.name,
      this.parentMahaanagarID,
      this.parentVibhaagID,
      this.parentBhaagID,
      this.parentNagarID,
      this.parentGraamID,
      this.parentMandalID,
      this.parentVastiID,
      this.geolevelid,
      this.parentUpaNagarID});

  SadbhavKendraMasterdata.fromJson(Map<String, dynamic> json) {
    pkid = json['pkid'];
    shatapdistharlevelid = json['shatapdistharlevelid'];
    stharname = json['stharname'];
    geounitid = json['geounitid'];
    kendraname = json['kendraname'];
    geoname = json['geoname'];
    name = json['name'];
    parentMahaanagarID = json['ParentMahaanagarID'];
    parentVibhaagID = json['ParentVibhaagID'];
    parentBhaagID = json['ParentBhaagID'];
    parentNagarID = json['ParentNagarID'];
    parentGraamID = json['ParentGraamID'];
    parentMandalID = json['ParentMandalID'];
    parentVastiID = json['ParentVastiID'];
    geolevelid = json['geolevelid'];
    parentUpaNagarID = json['ParentUpaNagarID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['shatapdistharlevelid'] = this.shatapdistharlevelid;
    data['stharname'] = this.stharname;
    data['geounitid'] = this.geounitid;
    data['kendraname'] = this.kendraname;
    data['geoname'] = this.geoname;
    data['name'] = this.name;
    data['ParentMahaanagarID'] = this.parentMahaanagarID;
    data['ParentVibhaagID'] = this.parentVibhaagID;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ParentNagarID'] = this.parentNagarID;
    data['ParentGraamID'] = this.parentGraamID;
    data['ParentMandalID'] = this.parentMandalID;
    data['ParentVastiID'] = this.parentVastiID;
    data['geolevelid'] = this.geolevelid;
    data['ParentUpaNagarID'] = this.parentUpaNagarID;
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

class Bhaitakdata {
  String? programdate;
  int? male;
  int? pkid;
  int? female;
  int? totmalefemale;
  int? peoplecount;

  Bhaitakdata({this.programdate, this.male, this.pkid, this.female, this.totmalefemale, this.peoplecount});

  Bhaitakdata.fromJson(Map<String, dynamic> json) {
    programdate = json['programdate'];
    male = json['male'];
    pkid = json['pkid'];
    female = json['female'];
    totmalefemale = json['totmalefemale'];
    peoplecount = json['peoplecount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['programdate'] = this.programdate;
    data['male'] = this.male;
    data['pkid'] = this.pkid;
    data['female'] = this.female;
    data['totmalefemale'] = this.totmalefemale;
    data['peoplecount'] = this.peoplecount;
    return data;
  }
}

// class SadbhavBaithakRespModel {
//   String? status;
//   String? message;
//   List<SadbhavMasterdata>? masterdata;
//   List<Nagardata>? nagardata;
//
//   SadbhavBaithakRespModel({this.status, this.message, this.masterdata, this.nagardata});
//
//   SadbhavBaithakRespModel.fromJson(Map<String, dynamic> json) {
//     status = json['Status'];
//     message = json['Message'];
//     if (json['Masterdata'] != null) {
//       masterdata = <SadbhavMasterdata>[];
//       json['Masterdata'].forEach((v) {
//         masterdata!.add(new SadbhavMasterdata.fromJson(v));
//       });
//     }
//     if (json['nagardata'] != null) {
//       nagardata = <Nagardata>[];
//       json['nagardata'].forEach((v) {
//         nagardata!.add(new Nagardata.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Status'] = this.status;
//     data['Message'] = this.message;
//     if (this.masterdata != null) {
//       data['Masterdata'] = this.masterdata!.map((v) => v.toJson()).toList();
//     }
//     if (this.nagardata != null) {
//       data['nagardata'] = this.nagardata!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class SadbhavMasterdata {
//   String? geoname;
//   int? pkid;
//   String? programdate;
//   int? shatapdistharlevelid;
//   int? geounitid;
//   String? name;
//   int? parentMahaanagarID;
//   int? parentVibhaagID;
//   int? parentBhaagID;
//   int? parentNagarID;
//   int? parentUpaNagarID;
//   int? parentGraamID;
//   int? parentMandalID;
//   int? parentVastiID;
//   int? geolevelid;
//
//   SadbhavMasterdata(
//       {this.geoname,
//       this.pkid,
//       this.programdate,
//       this.shatapdistharlevelid,
//       this.geounitid,
//       this.name,
//       this.parentMahaanagarID,
//       this.parentVibhaagID,
//       this.parentBhaagID,
//       this.parentNagarID,
//       this.parentUpaNagarID,
//       this.parentGraamID,
//       this.parentMandalID,
//       this.parentVastiID,
//       this.geolevelid});
//
//   SadbhavMasterdata.fromJson(Map<String, dynamic> json) {
//     geoname = json['geoname'];
//     pkid = json['pkid'];
//     programdate = json['programdate'];
//     shatapdistharlevelid = json['shatapdistharlevelid'];
//     geounitid = json['geounitid'];
//     name = json['name'];
//     parentMahaanagarID = json['ParentMahaanagarID'];
//     parentVibhaagID = json['ParentVibhaagID'];
//     parentBhaagID = json['ParentBhaagID'];
//     parentNagarID = json['ParentNagarID'];
//     parentUpaNagarID = json['ParentUpaNagarID'];
//     parentGraamID = json['ParentGraamID'];
//     parentMandalID = json['ParentMandalID'];
//     parentVastiID = json['ParentVastiID'];
//     geolevelid = json['geolevelid'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['geoname'] = this.geoname;
//     data['pkid'] = this.pkid;
//     data['programdate'] = this.programdate;
//     data['shatapdistharlevelid'] = this.shatapdistharlevelid;
//     data['geounitid'] = this.geounitid;
//     data['name'] = this.name;
//     data['ParentMahaanagarID'] = this.parentMahaanagarID;
//     data['ParentVibhaagID'] = this.parentVibhaagID;
//     data['ParentBhaagID'] = this.parentBhaagID;
//     data['ParentNagarID'] = this.parentNagarID;
//     data['ParentUpaNagarID'] = this.parentUpaNagarID;
//     data['ParentGraamID'] = this.parentGraamID;
//     data['ParentMandalID'] = this.parentMandalID;
//     data['ParentVastiID'] = this.parentVastiID;
//     data['geolevelid'] = this.geolevelid;
//     return data;
//   }
// }
