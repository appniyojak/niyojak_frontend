import 'get_vijaya_dashami_geounit_data.dart';
import 'gruh_abhiyaan_vrutta_data_model.dart';
import 'vijayaDashamiInitModel.dart';

class HinduSanmelanModel {
  String? message;
  String? status;
  String? sanmelandesc;
  int? geounitid;
  int? selectedgramcount;
  int? malecount;
  int? femalecount;
  List<Vastisarsajjanshakti>? vastisarsajjanshakti;
  List<Vastisanyaprabhavi>? vastisanyaprabhavi;
  List<AbhiyaanPeopleModel>? vaktaList;
  List<UpnagarmandallistVijayaDashami>? gramlist;
  List<TypeValueData>? urldata;
  List<TypeValueData>? imgdata;
  List<TypeValueData>? advimgdata;

  HinduSanmelanModel({
    this.message,
    this.status,
    this.sanmelandesc,
    this.geounitid,
    this.selectedgramcount,
    this.malecount,
    this.femalecount,
    this.vastisarsajjanshakti,
    this.vastisanyaprabhavi,
    this.vaktaList,
    this.gramlist,
    this.urldata,
    this.imgdata,
    this.advimgdata,
  });

  HinduSanmelanModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    sanmelandesc = json['sanmelandesc'];
    geounitid = json['geounitid'];
    selectedgramcount = json['selectedgramcount'];
    malecount = json['malecount'];
    femalecount = json['femalecount'];
    if (json['Vastisarsajjanshakti'] != null) {
      vastisarsajjanshakti = <Vastisarsajjanshakti>[];
      json['Vastisarsajjanshakti'].forEach((v) {
        vastisarsajjanshakti!.add(new Vastisarsajjanshakti.fromJson(v));
      });
    }
    if (json['Vastisanyaprabhavi'] != null) {
      vastisanyaprabhavi = <Vastisanyaprabhavi>[];
      json['Vastisanyaprabhavi'].forEach((v) {
        vastisanyaprabhavi!.add(new Vastisanyaprabhavi.fromJson(v));
      });
    }
    if (json['vaktaList'] != null) {
      vaktaList = <AbhiyaanPeopleModel>[];
      json['vaktaList'].forEach((v) {
        vaktaList!.add(new AbhiyaanPeopleModel.fromJson(v));
      });
    }
    if (json['gramlist'] != null) {
      gramlist = <UpnagarmandallistVijayaDashami>[];
      json['gramlist'].forEach((v) {
        gramlist!.add(new UpnagarmandallistVijayaDashami.fromJson(v));
      });
    }
    if (json['urldata'] != null) {
      urldata = <TypeValueData>[];
      json['urldata'].forEach((v) {
        urldata!.add(new TypeValueData.fromJson(v));
      });
    }
    if (json['imgdata'] != null) {
      imgdata = <TypeValueData>[];
      json['imgdata'].forEach((v) {
        imgdata!.add(new TypeValueData.fromJson(v));
      });
    }
    if (json['advimgdata'] != null) {
      advimgdata = <TypeValueData>[];
      json['advimgdata'].forEach((v) {
        advimgdata!.add(new TypeValueData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    data['sanmelandesc'] = this.sanmelandesc;
    data['geounitid'] = this.geounitid;
    data['selectedgramcount'] = this.selectedgramcount;
    data['malecount'] = this.malecount;
    data['femalecount'] = this.femalecount;
    if (this.vastisarsajjanshakti != null) {
      data['Vastisarsajjanshakti'] = this.vastisarsajjanshakti!.map((v) => v.toJson()).toList();
    }
    if (this.vastisanyaprabhavi != null) {
      data['Vastisanyaprabhavi'] = this.vastisanyaprabhavi!.map((v) => v.toJson()).toList();
    }
    if (this.vaktaList != null) {
      data['vaktaList'] = this.vaktaList!.map((v) => v.toJson()).toList();
    }
    if (this.gramlist != null) {
      data['gramlist'] = this.gramlist!.map((v) => v.toJson()).toList();
    }
    if (this.urldata != null) {
      data['urldata'] = this.urldata!.map((v) => v.toJson()).toList();
    }
    if (this.imgdata != null) {
      data['imgdata'] = this.imgdata!.map((v) => v.toJson()).toList();
    }
    if (this.advimgdata != null) {
      data['advimgdata'] = this.advimgdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
