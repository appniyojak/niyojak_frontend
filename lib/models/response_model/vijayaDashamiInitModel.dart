class GetVijayadashamiInitModel {
  String? message;
  String? status;
  List<Vastisarsajjanshakti>? vastisarsajjanshakti;
  List<Shakhaalist>? shakhaalist;
  List<UpnagarmandallistVijayaDashami>? upnagarmandallist;
  List<UpnagarmandallistVijayaDashami>? vastimandallist;

  GetVijayadashamiInitModel(
      {this.message,
      this.status,
      this.vastisarsajjanshakti,
      this.shakhaalist,
      this.upnagarmandallist,
      this.vastimandallist});

  GetVijayadashamiInitModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['Vastisarsajjanshakti'] != null) {
      vastisarsajjanshakti = <Vastisarsajjanshakti>[];
      json['Vastisarsajjanshakti'].forEach((v) {
        vastisarsajjanshakti!.add(new Vastisarsajjanshakti.fromJson(v));
      });
    }
    if (json['shakhaalist'] != null) {
      shakhaalist = <Shakhaalist>[];
      json['shakhaalist'].forEach((v) {
        shakhaalist!.add(new Shakhaalist.fromJson(v));
      });
    }
    if (json['upnagarmandallist'] != null) {
      upnagarmandallist = <UpnagarmandallistVijayaDashami>[];
      json['upnagarmandallist'].forEach((v) {
        upnagarmandallist!.add(new UpnagarmandallistVijayaDashami.fromJson(v));
      });
    }
    if (json['vastimandallist'] != null) {
      vastimandallist = <UpnagarmandallistVijayaDashami>[];
      json['vastimandallist'].forEach((v) {
        vastimandallist!.add(new UpnagarmandallistVijayaDashami.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.vastisarsajjanshakti != null) {
      data['Vastisarsajjanshakti'] =
          this.vastisarsajjanshakti!.map((v) => v.toJson()).toList();
    }
    if (this.shakhaalist != null) {
      data['shakhaalist'] = this.shakhaalist!.map((v) => v.toJson()).toList();
    }
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

class Vastisarsajjanshakti {
  String? samparkasutranava;
  String? address;
  String? doorabhaash;
  int? isactive;
  String? name;
  int? pkid;
  String? prabhaavkshetrName;
  int? prabhaavkshetrid;
  String? samparkasutraMobileNumber;
  String? samparksthitiName;
  int? samparksthitiid;
  String? sanstheCheNaav;
  String? sansthechaKuthalaPadavar;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  String? shreneedhiName;
  int? shreneeid;
  int? vastiid;
  String? vastiname;
  int? visheshId;
  String? visheshname;

  Vastisarsajjanshakti(
      {this.samparkasutranava,
      this.address,
      this.doorabhaash,
      this.isactive,
      this.name,
      this.pkid,
      this.prabhaavkshetrName,
      this.prabhaavkshetrid,
      this.samparkasutraMobileNumber,
      this.samparksthitiName,
      this.samparksthitiid,
      this.sanstheCheNaav,
      this.sansthechaKuthalaPadavar,
      this.selectedDropdownValueName,
      this.selectedDropdownValueName1,
      this.selectedDropdownValueName2,
      this.shreneedhiName,
      this.shreneeid,
      this.vastiid,
      this.vastiname,
      this.visheshId,
      this.visheshname});

  Vastisarsajjanshakti.fromJson(Map<String, dynamic> json) {
    samparkasutranava = json['Samparkasutranava'];
    address = json['address'];
    doorabhaash = json['doorabhaash'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    prabhaavkshetrName = json['prabhaavkshetrName'];
    prabhaavkshetrid = json['prabhaavkshetrid'];
    samparkasutraMobileNumber = json['samparkasutraMobileNumber'];
    samparksthitiName = json['samparksthitiName'];
    samparksthitiid = json['samparksthitiid'];
    sanstheCheNaav = json['sanstheCheNaav'];
    sansthechaKuthalaPadavar = json['sansthechaKuthalaPadavar'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    selectedDropdownValueName2 = json['selectedDropdownValueName2'];
    shreneedhiName = json['shreneedhiName'];
    shreneeid = json['shreneeid'];
    vastiid = json['vastiid'];
    vastiname = json['vastiname'];
    visheshId = json['visheshId'];
    visheshname = json['visheshname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Samparkasutranava'] = this.samparkasutranava;
    data['address'] = this.address;
    data['doorabhaash'] = this.doorabhaash;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['prabhaavkshetrName'] = this.prabhaavkshetrName;
    data['prabhaavkshetrid'] = this.prabhaavkshetrid;
    data['samparkasutraMobileNumber'] = this.samparkasutraMobileNumber;
    data['samparksthitiName'] = this.samparksthitiName;
    data['samparksthitiid'] = this.samparksthitiid;
    data['sanstheCheNaav'] = this.sanstheCheNaav;
    data['sansthechaKuthalaPadavar'] = this.sansthechaKuthalaPadavar;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['selectedDropdownValueName2'] = this.selectedDropdownValueName2;
    data['shreneedhiName'] = this.shreneedhiName;
    data['shreneeid'] = this.shreneeid;
    data['vastiid'] = this.vastiid;
    data['vastiname'] = this.vastiname;
    data['visheshId'] = this.visheshId;
    data['visheshname'] = this.visheshname;
    return data;
  }
}

class Shakhaalist {
  String? frequencyName;
  int? geoUnitID;
  String? geoUnitName;
  String? geoUnitNameHindi;
  String? geoUnitNameMarathi;
  String? preferedname;
  String? vayogatname;
  int? linkedUpaNagarID;
  int? isSankalpit;

  Shakhaalist({
    this.frequencyName,
    this.geoUnitID,
    this.geoUnitName,
    this.geoUnitNameHindi,
    this.geoUnitNameMarathi,
    this.preferedname,
    this.vayogatname,
    this.isSankalpit,
    this.linkedUpaNagarID,
  });

  Shakhaalist.fromJson(Map<String, dynamic> json) {
    frequencyName = json['FrequencyName'];
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    geoUnitNameHindi = json['GeoUnitNameHindi'];
    geoUnitNameMarathi = json['GeoUnitNameMarathi'];
    preferedname = json['Preferedname'];
    vayogatname = json['Vayogatname'];
    linkedUpaNagarID = json['linkedUpaNagarID'];
    isSankalpit = json['IsSankalpit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FrequencyName'] = this.frequencyName;
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['GeoUnitNameHindi'] = this.geoUnitNameHindi;
    data['GeoUnitNameMarathi'] = this.geoUnitNameMarathi;
    data['Preferedname'] = this.preferedname;
    data['Vayogatname'] = this.vayogatname;
    data['linkedUpaNagarID'] = this.linkedUpaNagarID;
    data['IsSankalpit'] = this.isSankalpit;
    return data;
  }
}

class UpnagarmandallistVijayaDashami {
  String? frequencyName;
  int? geoUnitID;
  String? geoUnitName;
  String? geoUnitNameHindi;
  String? geoUnitNameMarathi;
  String? preferedname;
  String? vayogatname;
  int? linkedUpaNagarID;

  UpnagarmandallistVijayaDashami(
      {this.frequencyName,
      this.geoUnitID,
      this.geoUnitName,
      this.geoUnitNameHindi,
      this.geoUnitNameMarathi,
      this.preferedname,
      this.vayogatname,
      this.linkedUpaNagarID});

  UpnagarmandallistVijayaDashami.fromJson(Map<String, dynamic> json) {
    frequencyName = json['FrequencyName'];
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    geoUnitNameHindi = json['GeoUnitNameHindi'];
    geoUnitNameMarathi = json['GeoUnitNameMarathi'];
    preferedname = json['Preferedname'];
    vayogatname = json['Vayogatname'];
    linkedUpaNagarID = json['linkedUpaNagarID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FrequencyName'] = this.frequencyName;
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['GeoUnitNameHindi'] = this.geoUnitNameHindi;
    data['GeoUnitNameMarathi'] = this.geoUnitNameMarathi;
    data['Preferedname'] = this.preferedname;
    data['Vayogatname'] = this.vayogatname;
    data['linkedUpaNagarID'] = this.linkedUpaNagarID;
    return data;
  }
}
