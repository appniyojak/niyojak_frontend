class GruhAbhiyaanVruttaDataModel {
  List<AbhiyaanPeopleModel>? abhiyaanList;
  Abhiyaandata? abhiyaandata;
  List<AbhiyaanPeopleModel>? abhiyanGruhToliList;
  String? message;
  String? status;
  List<AbhiyaanPeopleModel>? swayamsevakList;

  GruhAbhiyaanVruttaDataModel({this.abhiyaanList, this.abhiyaandata, this.abhiyanGruhToliList, this.message, this.status, this.swayamsevakList});

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
  int? pustakvikrisankhya;
  int? samparkhetusahbhagisankhya;
  int? samparkhetutolisankhya;
  int? samparkitghar;
  String? visititAtithiAnyaprabhaViLokamids;
  String? visititAtithiSajjanShaktiids;
  int? vitaritkarpatra;

  Abhiyaandata(
      {this.abhiyaanDate,
      this.pustakvikrisankhya,
      this.samparkhetusahbhagisankhya,
      this.samparkhetutolisankhya,
      this.samparkitghar,
      this.visititAtithiAnyaprabhaViLokamids,
      this.visititAtithiSajjanShaktiids,
      this.vitaritkarpatra});

  Abhiyaandata.fromJson(Map<String, dynamic> json) {
    abhiyaanDate = json['AbhiyaanDate'];
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
