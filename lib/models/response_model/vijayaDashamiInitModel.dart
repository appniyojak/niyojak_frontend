import 'gruh_abhiyaan_vrutta_data_model.dart';

class GetVijayadashamiInitModel {
  String? message;
  String? status;
  List<Vastisarsajjanshakti>? vastisarsajjanshakti;
  List<Shakhaalist>? shakhaalist;
  List<UpnagarmandallistVijayaDashami>? upnagarmandallist;
  List<UpnagarmandallistVijayaDashami>? vastimandallist;
  List<Vastisanyaprabhavi>? vastisanyaprabhavi;
  List<AbhiyaanPeopleModel>? swayamsevaklistforgruh;

  GetVijayadashamiInitModel({
    this.message,
    this.status,
    this.vastisarsajjanshakti,
    this.shakhaalist,
    this.upnagarmandallist,
    this.vastimandallist,
    this.vastisanyaprabhavi,
    this.swayamsevaklistforgruh,
  });

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
    if (json['Vastisanyaprabhavi'] != null) {
      vastisanyaprabhavi = <Vastisanyaprabhavi>[];
      json['Vastisanyaprabhavi'].forEach((v) {
        vastisanyaprabhavi!.add(new Vastisanyaprabhavi.fromJson(v));
      });
    }
    if (json['swayamsevaklistforgruh'] != null) {
      swayamsevaklistforgruh = <AbhiyaanPeopleModel>[];
      json['swayamsevaklistforgruh'].forEach((v) {
        swayamsevaklistforgruh!.add(new AbhiyaanPeopleModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.vastisarsajjanshakti != null) {
      data['Vastisarsajjanshakti'] = this.vastisarsajjanshakti!.map((v) => v.toJson()).toList();
    }
    if (this.shakhaalist != null) {
      data['shakhaalist'] = this.shakhaalist!.map((v) => v.toJson()).toList();
    }
    if (this.upnagarmandallist != null) {
      data['upnagarmandallist'] = this.upnagarmandallist!.map((v) => v.toJson()).toList();
    }
    if (this.vastimandallist != null) {
      data['vastimandallist'] = this.vastimandallist!.map((v) => v.toJson()).toList();
    }
    if (this.vastisanyaprabhavi != null) {
      data['Vastisanyaprabhavi'] = this.vastisanyaprabhavi!.map((v) => v.toJson()).toList();
    }
    if (this.swayamsevaklistforgruh != null) {
      data['swayamsevaklistforgruh'] = this.swayamsevaklistforgruh!.map((v) => v.toJson()).toList();
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
  int? nagarid;
  String? vastiname;
  int? visheshId;
  String? visheshname;
  int? isMukhyadefault;
  int? isVisheshdefault;

  Vastisarsajjanshakti({
    this.samparkasutranava,
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
    this.nagarid,
    this.vastiname,
    this.visheshId,
    this.visheshname,
    this.isMukhyadefault,
    this.isVisheshdefault,
  });

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
    nagarid = json['NagarID'];
    vastiname = json['vastiname'];
    visheshId = json['visheshId'];
    visheshname = json['visheshname'];
    isMukhyadefault = json['isMukhyadefault'];
    isVisheshdefault = json['isVisheshdefault'];
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
    data['NagarID'] = this.nagarid;
    data['vastiname'] = this.vastiname;
    data['visheshId'] = this.visheshId;
    data['visheshname'] = this.visheshname;
    data['isMukhyadefault'] = this.isMukhyadefault;
    data['isVisheshdefault'] = this.isVisheshdefault;
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
  int? isdefault;

  UpnagarmandallistVijayaDashami({
    this.frequencyName,
    this.geoUnitID,
    this.geoUnitName,
    this.geoUnitNameHindi,
    this.geoUnitNameMarathi,
    this.preferedname,
    this.vayogatname,
    this.linkedUpaNagarID,
    this.isdefault,
  });

  UpnagarmandallistVijayaDashami.fromJson(Map<String, dynamic> json) {
    frequencyName = json['FrequencyName'];
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    geoUnitNameHindi = json['GeoUnitNameHindi'];
    geoUnitNameMarathi = json['GeoUnitNameMarathi'];
    preferedname = json['Preferedname'];
    vayogatname = json['Vayogatname'];
    linkedUpaNagarID = json['linkedUpaNagarID'];
    isdefault = json['isdefault'];
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
    data['isdefault'] = this.isdefault;
    return data;
  }
}

class Vastisanyaprabhavi {
  String? address;
  String? anyaVishesMahiti;
  String? doorabhaash;
  bool? isActive;
  String? name;
  String? otherUpshrenee;
  String? otherUpshrenee2;
  String? otherVishesh;
  int? pkId;
  String? prabhaavKshetreName;
  int? prabhaavkshetrId;
  String? samparkAsutraNav;
  String? samparkSthit;
  int? samparkSthitiId;
  String? samparkaSutraDoorbhash;
  int? shreneeId;
  String? shreneeName;
  String? upshrenee2Name;
  int? upshreneeId;
  int? upshreneeId2;
  String? upshreneeName;
  int? vastiId;
  int? nagarid;
  String? vastiName;
  int? visheshId;
  String? visheshName;
  int? isMukhyadefault;
  int? isVisheshdefault;

  Vastisanyaprabhavi({
    this.address,
    this.anyaVishesMahiti,
    this.doorabhaash,
    this.isActive,
    this.name,
    this.otherUpshrenee,
    this.otherUpshrenee2,
    this.otherVishesh,
    this.pkId,
    this.prabhaavKshetreName,
    this.prabhaavkshetrId,
    this.samparkAsutraNav,
    this.samparkSthit,
    this.samparkSthitiId,
    this.samparkaSutraDoorbhash,
    this.shreneeId,
    this.shreneeName,
    this.upshrenee2Name,
    this.upshreneeId,
    this.upshreneeId2,
    this.upshreneeName,
    this.vastiId,
    this.nagarid,
    this.vastiName,
    this.visheshId,
    this.visheshName,
    this.isMukhyadefault,
    this.isVisheshdefault,
  });

  Vastisanyaprabhavi.fromJson(Map<String, dynamic> json) {
    address = json['Address'];
    anyaVishesMahiti = json['AnyaVishesMahiti'];
    doorabhaash = json['Doorabhaash'];
    isActive = json['IsActive'];
    name = json['Name'];
    otherUpshrenee = json['OtherUpshrenee'];
    otherUpshrenee2 = json['OtherUpshrenee2'];
    otherVishesh = json['OtherVishesh'];
    pkId = json['PkId'];
    prabhaavKshetreName = json['PrabhaavKshetreName'];
    prabhaavkshetrId = json['PrabhaavkshetrId'];
    samparkAsutraNav = json['SamparkAsutraNav'];
    samparkSthit = json['SamparkSthit'];
    samparkSthitiId = json['SamparkSthitiId'];
    samparkaSutraDoorbhash = json['SamparkaSutraDoorbhash'];
    shreneeId = json['ShreneeId'];
    shreneeName = json['ShreneeName'];
    upshrenee2Name = json['Upshrenee2Name'];
    upshreneeId = json['UpshreneeId'];
    upshreneeId2 = json['UpshreneeId2'];
    upshreneeName = json['UpshreneeName'];
    vastiId = json['VastiId'];
    nagarid = json['NagarID'];
    vastiName = json['VastiName'];
    visheshId = json['VisheshId'];
    visheshName = json['VisheshName'];
    isMukhyadefault = json['isMukhyadefault'];
    isVisheshdefault = json['isVisheshdefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Address'] = this.address;
    data['AnyaVishesMahiti'] = this.anyaVishesMahiti;
    data['Doorabhaash'] = this.doorabhaash;
    data['IsActive'] = this.isActive;
    data['Name'] = this.name;
    data['OtherUpshrenee'] = this.otherUpshrenee;
    data['OtherUpshrenee2'] = this.otherUpshrenee2;
    data['OtherVishesh'] = this.otherVishesh;
    data['PkId'] = this.pkId;
    data['PrabhaavKshetreName'] = this.prabhaavKshetreName;
    data['PrabhaavkshetrId'] = this.prabhaavkshetrId;
    data['SamparkAsutraNav'] = this.samparkAsutraNav;
    data['SamparkSthit'] = this.samparkSthit;
    data['SamparkSthitiId'] = this.samparkSthitiId;
    data['SamparkaSutraDoorbhash'] = this.samparkaSutraDoorbhash;
    data['ShreneeId'] = this.shreneeId;
    data['ShreneeName'] = this.shreneeName;
    data['Upshrenee2Name'] = this.upshrenee2Name;
    data['UpshreneeId'] = this.upshreneeId;
    data['UpshreneeId2'] = this.upshreneeId2;
    data['UpshreneeName'] = this.upshreneeName;
    data['VastiId'] = this.vastiId;
    data['NagarID'] = this.nagarid;
    data['VastiName'] = this.vastiName;
    data['VisheshId'] = this.visheshId;
    data['VisheshName'] = this.visheshName;
    data['isMukhyadefault'] = this.isMukhyadefault;
    data['isVisheshdefault'] = this.isVisheshdefault;
    return data;
  }
}
