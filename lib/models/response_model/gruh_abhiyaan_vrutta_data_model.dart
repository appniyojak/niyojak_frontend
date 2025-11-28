class GruhAbhiyaanVruttaDataModel {
  List<AbhiyaanPeopleModel>? abhiyaanList;
  Abhiyaandata? abhiyaandata;
  List<AbhiyaanPeopleModel>? abhiyanGruhToliList;
  String? message;
  String? status;
  List<AbhiyaanPeopleModel>? swayamsevakList;
  List<AbhiyaanPeopleModel>? pramukhList;
  List<PreviousDay>? previousDay;

  GruhAbhiyaanVruttaDataModel({
    this.abhiyaanList,
    this.abhiyaandata,
    this.abhiyanGruhToliList,
    this.message,
    this.status,
    this.swayamsevakList,
    this.previousDay,
    this.pramukhList,
  });

  GruhAbhiyaanVruttaDataModel.fromJson(Map<String, dynamic> json) {
    if (json['AbhiyaanList'] != null) {
      abhiyaanList = <AbhiyaanPeopleModel>[];
      json['AbhiyaanList'].forEach((v) {
        abhiyaanList!.add(new AbhiyaanPeopleModel.fromJson(v));
      });
    }
    abhiyaandata = json['Abhiyaandata'] != null ? new Abhiyaandata.fromJson(json['Abhiyaandata']) : null;
    if (json['AbhiyanGruhToliList'] != null) {
      abhiyanGruhToliList = <AbhiyaanPeopleModel>[];
      json['AbhiyanGruhToliList'].forEach((v) {
        abhiyanGruhToliList!.add(new AbhiyaanPeopleModel.fromJson(v));
      });
    }
    message = json['Message'];
    status = json['Status'];
    if (json['SwayamsevakList'] != null) {
      swayamsevakList = <AbhiyaanPeopleModel>[];
      json['SwayamsevakList'].forEach((v) {
        swayamsevakList!.add(new AbhiyaanPeopleModel.fromJson(v));
      });
    }
    if (json['PreviousDay'] != null) {
      previousDay = <PreviousDay>[];
      json['PreviousDay'].forEach((v) {
        previousDay!.add(new PreviousDay.fromJson(v));
      });
    }
    if (json['pramukh'] != null) {
      pramukhList = <AbhiyaanPeopleModel>[];
      json['pramukh'].forEach((v) {
        pramukhList!.add(new AbhiyaanPeopleModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.abhiyaanList != null) {
      data['AbhiyaanList'] = this.abhiyaanList!.map((v) => v.toJson()).toList();
    }
    if (this.abhiyaandata != null) {
      data['Abhiyaandata'] = this.abhiyaandata!.toJson();
    }
    if (this.abhiyanGruhToliList != null) {
      data['AbhiyanGruhToliList'] = this.abhiyanGruhToliList!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.swayamsevakList != null) {
      data['SwayamsevakList'] = this.swayamsevakList!.map((v) => v.toJson()).toList();
    }
    if (this.previousDay != null) {
      data['PreviousDay'] = this.previousDay!.map((v) => v.toJson()).toList();
    }
    if (this.pramukhList != null) {
      data['pramukh'] = this.pramukhList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AbhiyaanPeopleModel {
  String? fullName;
  int? swayamsevakID;
  String? daayitva;
  int? isdefault;
  String? mobileno;
  bool isSelected = false;

  AbhiyaanPeopleModel({this.fullName, this.swayamsevakID, this.daayitva, this.isdefault, this.mobileno, this.isSelected = false});

  AbhiyaanPeopleModel.fromJson(Map<String, dynamic> json) {
    fullName = json['FullName'];
    swayamsevakID = json['SwayamsevakID'];
    daayitva = json['daayitva'];
    isdefault = json['isdefault'];
    mobileno = json['mobileno'];
    isSelected = json['isSelected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FullName'] = this.fullName;
    data['SwayamsevakID'] = this.swayamsevakID;
    data['daayitva'] = this.daayitva;
    data['isdefault'] = this.isdefault;
    data['mobileno'] = this.mobileno;
    data['isSelected'] = this.isSelected;
    return data;
  }
}

class Abhiyaandata {
  String? abhiyaanDate;
  bool ishide = false;
  int? pustakvikrisankhya;
  int? samparkhetusahbhagisankhya;
  int? samparkhetutolisankhya;
  int? samparkitghar;
  String? visititAtithiAnyaprabhaViLokamids;
  String? visititAtithiSajjanShaktiids;
  int? vitaritkarpatra;

  Abhiyaandata(
      {this.abhiyaanDate,
      this.ishide = false,
      this.pustakvikrisankhya,
      this.samparkhetusahbhagisankhya,
      this.samparkhetutolisankhya,
      this.samparkitghar,
      this.visititAtithiAnyaprabhaViLokamids,
      this.visititAtithiSajjanShaktiids,
      this.vitaritkarpatra});

  Abhiyaandata.fromJson(Map<String, dynamic> json) {
    abhiyaanDate = json['AbhiyaanDate'];
    ishide = json['ishide'] == 1;
    pustakvikrisankhya = json['pustakvikrisankhya'];
    samparkhetusahbhagisankhya = json['samparkhetusahbhagisankhya'];
    samparkhetutolisankhya = json['samparkhetutolisankhya'];
    samparkitghar = json['samparkitghar'];
    visititAtithiAnyaprabhaViLokamids = json['visitit_atithi_anyaprabha_vi_lokamids'];
    visititAtithiSajjanShaktiids = json['visitit_atithi_sajjan_shaktiids'];
    vitaritkarpatra = json['vitaritkarpatra'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbhiyaanDate'] = this.abhiyaanDate;
    data['ishide'] = this.ishide ? 1 : 0;
    data['pustakvikrisankhya'] = this.pustakvikrisankhya;
    data['samparkhetusahbhagisankhya'] = this.samparkhetusahbhagisankhya;
    data['samparkhetutolisankhya'] = this.samparkhetutolisankhya;
    data['samparkitghar'] = this.samparkitghar;
    data['visitit_atithi_anyaprabha_vi_lokamids'] = this.visititAtithiAnyaprabhaViLokamids;
    data['visitit_atithi_sajjan_shaktiids'] = this.visititAtithiSajjanShaktiids;
    data['vitaritkarpatra'] = this.vitaritkarpatra;
    return data;
  }
}

class PreviousDay {
  String? abhiyaanDate;
  int? createdUserID;
  int? geoUnitID;
  String? geoUnitName;
  int? levelID;
  int? parentBhaagID;
  int? parentMahaanagarID;
  int? parentMandalID;
  int? parentNagarID;
  int? parentVibhaagID;
  String? participantName;
  int? totalAtithiCount;
  int? pustakvikrisankhya;
  int? samparkitghar;
  String? visititAtithiAnyaprabhaViLokamids;
  String? visititAtithiSajjanShaktiids;
  int? vitaritkarpatra;
  int? samparkhetusahbhagisankhya;
  int? samparkhetutolisankhya;

  PreviousDay({
    this.abhiyaanDate,
    this.createdUserID,
    this.geoUnitID,
    this.geoUnitName,
    this.levelID,
    this.parentBhaagID,
    this.parentMahaanagarID,
    this.parentMandalID,
    this.parentNagarID,
    this.parentVibhaagID,
    this.participantName,
    this.totalAtithiCount,
    this.pustakvikrisankhya,
    this.samparkitghar,
    this.visititAtithiAnyaprabhaViLokamids,
    this.visititAtithiSajjanShaktiids,
    this.vitaritkarpatra,
    this.samparkhetusahbhagisankhya,
    this.samparkhetutolisankhya,
  });

  PreviousDay.fromJson(Map<String, dynamic> json) {
    abhiyaanDate = json['AbhiyaanDate'];
    createdUserID = json['CreatedUserID'];
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    levelID = json['LevelID'];
    parentBhaagID = json['ParentBhaagID'];
    parentMahaanagarID = json['ParentMahaanagarID'];
    parentMandalID = json['ParentMandalID'];
    parentNagarID = json['ParentNagarID'];
    parentVibhaagID = json['ParentVibhaagID'];
    participantName = json['ParticipantName'];
    totalAtithiCount = json['TotalAtithiCount'];
    pustakvikrisankhya = json['pustakvikrisankhya'];
    samparkitghar = json['samparkitghar'];
    visititAtithiAnyaprabhaViLokamids = json['visitit_atithi_anyaprabha_vi_lokamids'];
    visititAtithiSajjanShaktiids = json['visitit_atithi_sajjan_shaktiids'];
    vitaritkarpatra = json['vitaritkarpatra'];
    samparkhetusahbhagisankhya = json['samparkhetusahbhagisankhya'];
    samparkhetutolisankhya = json['samparkhetutolisankhya'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbhiyaanDate'] = this.abhiyaanDate;
    data['CreatedUserID'] = this.createdUserID;
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['LevelID'] = this.levelID;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ParentMahaanagarID'] = this.parentMahaanagarID;
    data['ParentMandalID'] = this.parentMandalID;
    data['ParentNagarID'] = this.parentNagarID;
    data['ParentVibhaagID'] = this.parentVibhaagID;
    data['ParticipantName'] = this.participantName;
    data['TotalAtithiCount'] = this.totalAtithiCount;
    data['pustakvikrisankhya'] = this.pustakvikrisankhya;
    data['samparkitghar'] = this.samparkitghar;
    data['visitit_atithi_anyaprabha_vi_lokamids'] = this.visititAtithiAnyaprabhaViLokamids;
    data['visitit_atithi_sajjan_shaktiids'] = this.visititAtithiSajjanShaktiids;
    data['vitaritkarpatra'] = this.vitaritkarpatra;
    data['samparkhetusahbhagisankhya'] = this.samparkhetusahbhagisankhya;
    data['samparkhetutolisankhya'] = this.samparkhetutolisankhya;
    return data;
  }
}
