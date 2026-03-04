import 'vijayaDashamiInitModel.dart';

class SadbhavBaithakVruttaRespModel {
  String? status;
  String? message;
  String? programdate;
  int? peoplecount;
  String? name;
  String? geoname;
  String? stharname;
  int? pkid;
  int? shatapdistharlevelid;
  int? geounitid;
  List<Vastisarsajjanshakti>? vastisarsajjanshakti;
  List<Vastisanyaprabhavi>? vastisanyaprabhavi;
  List<NamesList>? namesList;

  SadbhavBaithakVruttaRespModel({
    this.status,
    this.message,
    this.programdate,
    this.peoplecount,
    this.name,
    this.geoname,
    this.stharname,
    this.pkid,
    this.shatapdistharlevelid,
    this.geounitid,
    this.vastisarsajjanshakti,
    this.vastisanyaprabhavi,
    this.namesList,
  });

  SadbhavBaithakVruttaRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    programdate = json['programdate'];
    peoplecount = json['peoplecount'];
    name = json['name'];
    geoname = json['geoname'];
    stharname = json['stharname'];
    pkid = json['pkid'];
    shatapdistharlevelid = json['shatapdistharlevelid'];
    geounitid = json['geounitid'];
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
    if (json['names'] != null) {
      namesList = <NamesList>[];
      json['names'].forEach((v) {
        namesList!.add(new NamesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['programdate'] = this.programdate;
    data['peoplecount'] = this.peoplecount;
    data['name'] = this.name;
    data['geoname'] = this.geoname;
    data['stharname'] = this.stharname;
    data['pkid'] = this.pkid;
    data['shatapdistharlevelid'] = this.shatapdistharlevelid;
    data['geounitid'] = this.geounitid;
    if (this.vastisarsajjanshakti != null) {
      data['Vastisarsajjanshakti'] = this.vastisarsajjanshakti!.map((v) => v.toJson()).toList();
    }
    if (this.vastisanyaprabhavi != null) {
      data['Vastisanyaprabhavi'] = this.vastisanyaprabhavi!.map((v) => v.toJson()).toList();
    }
    if (this.namesList != null) {
      data['names'] = this.namesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NamesList {
  int? pkid;
  String? name;
  int? fksadbhavbaithakmasterid;
  int? isactive;

  NamesList({this.pkid, this.name, this.fksadbhavbaithakmasterid, this.isactive});

  NamesList.fromJson(Map<String, dynamic> json) {
    pkid = json['pkid'];
    name = json['name'];
    fksadbhavbaithakmasterid = json['fksadbhavbaithakmasterid'];
    isactive = json['isactive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['name'] = this.name;
    data['fksadbhavbaithakmasterid'] = this.fksadbhavbaithakmasterid;
    data['isactive'] = this.isactive;
    return data;
  }
}
