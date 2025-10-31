import 'AbhiyaanSwayamsevakListResponse.dart';

class GruhAbhiyaanVruttaDataModel {
  Abhiyaandata? abhiyaandata;
  List<AbhiyanSwayamsevakList>? abhiyaanmodels;
  String? message;
  String? status;

  GruhAbhiyaanVruttaDataModel({this.abhiyaandata, this.abhiyaanmodels, this.message, this.status});

  GruhAbhiyaanVruttaDataModel.fromJson(Map<String, dynamic> json) {
    abhiyaandata = json['Abhiyaandata'] != null ? new Abhiyaandata.fromJson(json['Abhiyaandata']) : null;
    if (json['Abhiyaanmodels'] != null) {
      abhiyaanmodels = <AbhiyanSwayamsevakList>[];
      json['Abhiyaanmodels'].forEach((v) {
        abhiyaanmodels!.add(new AbhiyanSwayamsevakList.fromJson(v));
      });
    }
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.abhiyaandata != null) {
      data['Abhiyaandata'] = this.abhiyaandata!.toJson();
    }
    if (this.abhiyaanmodels != null) {
      data['Abhiyaanmodels'] = this.abhiyaanmodels!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
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
