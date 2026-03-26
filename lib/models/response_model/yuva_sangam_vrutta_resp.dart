class YuvaSangamVruttaRespModel {
  String? status;
  String? message;
  YuvaVruttadata? vruttadata;

  YuvaSangamVruttaRespModel({this.status, this.message, this.vruttadata});

  YuvaSangamVruttaRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    vruttadata = json['vruttadata'] != null ? new YuvaVruttadata.fromJson(json['vruttadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.vruttadata != null) {
      data['vruttadata'] = this.vruttadata!.toJson();
    }
    return data;
  }
}

class YuvaVruttadata {
  int? pkid;
  int? cuserid;
  int? fkmasterid;
  int? yuvaexpectmaha;
  int? yuvapresentmaha;
  int? yuvaexpecttarun;
  int? yuvapresenttarun;
  int? yuvaexpectmandal;
  int? yuvapresentmandal;
  int? yuvaexpectpradhyapak;
  int? yuvapresentpradhyapak;
  int? mahaexpectmaha;
  int? mahapresentmaha;
  int? mahaexpectvasti;
  int? mahapresentvasti;
  String? yuvadesc;
  List<YuvaShakkhaaList>? presentmahalist;
  List<YuvaShakkhaaList>? sankalpitmahalist;
  List<YuvaShakkhaaList>? presenttarunlist;
  List<YuvaShakkhaaList>? sankalpittarunlist;
  List<YuvaaSpeaker>? yuvaaspeaker;

  String? yuvasangampresentmahashaakha;
  String? yuvasangampresentmahashaakhasankalpit;
  String? yuvasangampresentvartmantarun;
  String? yuvasangampresentvartmantarunsankalpit;

  YuvaVruttadata(
      {this.pkid,
      this.cuserid,
      this.fkmasterid,
      this.yuvaexpectmaha,
      this.yuvapresentmaha,
      this.yuvaexpecttarun,
      this.yuvapresenttarun,
      this.yuvaexpectmandal,
      this.yuvapresentmandal,
      this.yuvaexpectpradhyapak,
      this.yuvapresentpradhyapak,
      this.mahaexpectmaha,
      this.mahapresentmaha,
      this.mahaexpectvasti,
      this.mahapresentvasti,
      this.yuvadesc,
      this.presentmahalist,
      this.sankalpitmahalist,
      this.presenttarunlist,
      this.sankalpittarunlist,
      this.yuvaaspeaker,
      this.yuvasangampresentmahashaakha,
      this.yuvasangampresentmahashaakhasankalpit,
      this.yuvasangampresentvartmantarun,
      this.yuvasangampresentvartmantarunsankalpit});

  YuvaVruttadata.fromJson(Map<String, dynamic> json) {
    pkid = json['pkid'];
    cuserid = json['cuserid'];
    fkmasterid = json['fkmasterid'];
    yuvaexpectmaha = json['yuvaexpectmaha'];
    yuvapresentmaha = json['yuvapresentmaha'];
    yuvaexpecttarun = json['yuvaexpecttarun'];
    yuvapresenttarun = json['yuvapresenttarun'];
    yuvaexpectmandal = json['yuvaexpectmandal'];
    yuvapresentmandal = json['yuvapresentmandal'];
    yuvaexpectpradhyapak = json['yuvaexpectpradhyapak'];
    yuvapresentpradhyapak = json['yuvapresentpradhyapak'];
    mahaexpectmaha = json['mahaexpectmaha'];
    mahapresentmaha = json['mahapresentmaha'];
    mahaexpectvasti = json['mahaexpectvasti'];
    mahapresentvasti = json['mahapresentvasti'];
    yuvadesc = json['yuvadesc'];
    if (json['presentmahalist'] != null) {
      presentmahalist = <YuvaShakkhaaList>[];
      json['presentmahalist'].forEach((v) {
        presentmahalist!.add(new YuvaShakkhaaList.fromJson(v));
      });
    }
    if (json['sankalpitmahalist'] != null) {
      sankalpitmahalist = <YuvaShakkhaaList>[];
      json['sankalpitmahalist'].forEach((v) {
        sankalpitmahalist!.add(new YuvaShakkhaaList.fromJson(v));
      });
    }
    if (json['presenttarunlist'] != null) {
      presenttarunlist = <YuvaShakkhaaList>[];
      json['presenttarunlist'].forEach((v) {
        presenttarunlist!.add(new YuvaShakkhaaList.fromJson(v));
      });
    }
    if (json['sankalpittarunlist'] != null) {
      sankalpittarunlist = <YuvaShakkhaaList>[];
      json['sankalpittarunlist'].forEach((v) {
        sankalpittarunlist!.add(new YuvaShakkhaaList.fromJson(v));
      });
    }
    if (json['yuvaaspeaker'] != null) {
      yuvaaspeaker = <YuvaaSpeaker>[];
      json['yuvaaspeaker'].forEach((v) {
        yuvaaspeaker!.add(new YuvaaSpeaker.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['cuserid'] = this.cuserid;
    data['fkmasterid'] = this.fkmasterid;
    data['yuvaexpectmaha'] = this.yuvaexpectmaha;
    data['yuvapresentmaha'] = this.yuvapresentmaha;
    data['yuvaexpecttarun'] = this.yuvaexpecttarun;
    data['yuvapresenttarun'] = this.yuvapresenttarun;
    data['yuvaexpectmandal'] = this.yuvaexpectmandal;
    data['yuvapresentmandal'] = this.yuvapresentmandal;
    data['yuvaexpectpradhyapak'] = this.yuvaexpectpradhyapak;
    data['yuvapresentpradhyapak'] = this.yuvapresentpradhyapak;
    data['mahaexpectmaha'] = this.mahaexpectmaha;
    data['mahapresentmaha'] = this.mahapresentmaha;
    data['mahaexpectvasti'] = this.mahaexpectvasti;
    data['mahapresentvasti'] = this.mahapresentvasti;
    data['yuvadesc'] = this.yuvadesc;
    if (this.presentmahalist != null) {
      data['presentmahalist'] = this.presentmahalist!.map((v) => v.toJson()).toList();
    }
    if (this.sankalpitmahalist != null) {
      data['sankalpitmahalist'] = this.sankalpitmahalist!.map((v) => v.toJson()).toList();
    }
    if (this.presenttarunlist != null) {
      data['presenttarunlist'] = this.presenttarunlist!.map((v) => v.toJson()).toList();
    }
    if (this.sankalpittarunlist != null) {
      data['sankalpittarunlist'] = this.sankalpittarunlist!.map((v) => v.toJson()).toList();
    }
    if (this.yuvaaspeaker != null) {
      data['yuvaspeakerList'] = this.yuvaaspeaker!.map((v) => v.toJson()).toList();
    }
    data['yuvasangampresentmahashaakha'] = this.yuvasangampresentmahashaakha;
    data['yuvasangampresentmahashaakhasankalpit'] = this.yuvasangampresentmahashaakhasankalpit;
    data['yuvasangampresentvartmantarun'] = this.yuvasangampresentvartmantarun;
    data['yuvasangampresentvartmantarunsankalpit'] = this.yuvasangampresentvartmantarunsankalpit;
    return data;
  }
}

class YuvaShakkhaaList {
  int? geoUnitID;
  int? iselected;
  String? freqname;
  String? shaakhaaname;

  YuvaShakkhaaList({this.geoUnitID, this.iselected, this.freqname, this.shaakhaaname});

  YuvaShakkhaaList.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    iselected = json['iselected'];
    freqname = json['freqname'];
    shaakhaaname = json['Shaakhaaname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['iselected'] = this.iselected;
    data['freqname'] = this.freqname;
    data['Shaakhaaname'] = this.shaakhaaname;
    return data;
  }
}

class YuvaaSpeaker {
  String? name;
  String? daaitva;
  int? prakarid;
  int? gatividhid;
  int? pkid;
  int? isannya;
  String? annyaname;

  YuvaaSpeaker({this.name, this.daaitva, this.prakarid, this.gatividhid, this.pkid, this.isannya, this.annyaname});

  YuvaaSpeaker.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    daaitva = json['daaitva'];
    prakarid = json['prakarid'];
    gatividhid = json['gatividhid'];
    pkid = json['pkid'];
    isannya = json['isannya'];
    annyaname = json['annyaname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['daaitva'] = this.daaitva;
    data['prakarid'] = this.prakarid ?? 0;
    data['gatividhid'] = this.gatividhid ?? 0;
    data['pkid'] = this.pkid;
    data['isannya'] = this.isannya;
    data['annyaname'] = this.annyaname;
    return data;
  }
}
