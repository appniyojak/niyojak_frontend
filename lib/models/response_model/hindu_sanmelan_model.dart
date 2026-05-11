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
  String? imgDesc;
  String? advDesc;
  List<Vastisarsajjanshakti>? vastisarsajjanshakti;
  List<Vastisanyaprabhavi>? vastisanyaprabhavi;
  List<AbhiyaanPeopleModel>? vaktaList;
  List<UpnagarmandallistVijayaDashami>? gramlist;
  List<TypeValueData>? urldata; //type : url
  List<TypeValueData>? imgdata; //type: img
  List<TypeValueData>? advimgdata; //type: advimg
  Geodata? geodata;

  HinduSanmelanModel({
    this.message,
    this.status,
    this.sanmelandesc,
    this.geounitid,
    this.selectedgramcount,
    this.malecount,
    this.femalecount,
    this.imgDesc,
    this.advDesc,
    this.vastisarsajjanshakti,
    this.vastisanyaprabhavi,
    this.vaktaList,
    this.gramlist,
    this.urldata,
    this.imgdata,
    this.advimgdata,
    this.geodata,
  });

  HinduSanmelanModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    sanmelandesc = json['sanmelandesc'];
    geounitid = json['geounitid'];
    selectedgramcount = json['selectedgramcount'];
    malecount = json['malecount'];
    femalecount = json['femalecount'];
    imgDesc = json['imgDesc'];
    advDesc = json['advDesc'];
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
    if (json['hindusammalen'] != null) {
      vaktaList = <AbhiyaanPeopleModel>[];
      json['hindusammalen'].forEach((v) {
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
    geodata = json['geodata'] != null ? new Geodata.fromJson(json['geodata']) : null;
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
    data['imgDesc'] = this.imgDesc;
    data['advDesc'] = this.advDesc;
    if (this.vastisarsajjanshakti != null) {
      data['Vastisarsajjanshakti'] = this.vastisarsajjanshakti!.map((v) => v.toJson()).toList();
    }
    if (this.vastisanyaprabhavi != null) {
      data['Vastisanyaprabhavi'] = this.vastisanyaprabhavi!.map((v) => v.toJson()).toList();
    }
    if (this.vaktaList != null) {
      data['hindusammalen'] = this.vaktaList!.map((v) => v.toJson()).toList();
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
    if (this.geodata != null) {
      data['geodata'] = this.geodata!.toJson();
    }
    return data;
  }
}

class Geodata {
  String? geounitid;
  int? levelID;
  int? parentBhaagID;
  int? parentMahaanagarID;
  int? parentUpnagarID;
  int? parentNagarID;
  int? parentVibhaagID;

  Geodata({this.geounitid, this.levelID, this.parentBhaagID, this.parentMahaanagarID, this.parentUpnagarID, this.parentNagarID, this.parentVibhaagID});

  Geodata.fromJson(Map<String, dynamic> json) {
    geounitid = json['GeoUnitID'];
    levelID = json['LevelID'];
    parentBhaagID = json['ParentBhaagID'];
    parentMahaanagarID = json['ParentMahaanagarID'];
    parentUpnagarID = json['ParentUpnagarID'];
    parentNagarID = json['ParentNagarID'];
    parentVibhaagID = json['ParentVibhaagID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geounitid;
    data['LevelID'] = this.levelID;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ParentMahaanagarID'] = this.parentMahaanagarID;
    data['ParentUpnagarID'] = this.parentUpnagarID;
    data['ParentNagarID'] = this.parentNagarID;
    data['ParentVibhaagID'] = this.parentVibhaagID;
    return data;
  }
}
