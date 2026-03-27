class YuvaSangamReportRespModel {
  String? status;
  String? message;
  List<Yuvrpt>? yuvrpt;

  YuvaSangamReportRespModel({this.status, this.message, this.yuvrpt});

  YuvaSangamReportRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['yuvrpt'] != null) {
      yuvrpt = <Yuvrpt>[];
      json['yuvrpt'].forEach((v) {
        yuvrpt!.add(new Yuvrpt.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.yuvrpt != null) {
      data['yuvrpt'] = this.yuvrpt!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Yuvrpt {
  String? levelname;
  int? ekunyuva;
  int? pendingyuva;
  int? completeyuva;

  int? yuvaexpectmaha;
  int? yuvaexpecttarun;
  int? yuvaexpectmandal;
  int? yuvaexpectpradhyapak;
  int? mahaexpectmaha;
  int? mahaexpectvasti;
  int? ekunexcept;
  int? yuvapresentmaha;
  int? yuvapresenttarun;
  int? yuvapresentmandal;
  int? yuvapresentpradhyapak;
  int? mahapresentmaha;
  int? mahapresentvasti;
  int? ekunpresent;

  int? yuvasangampresentmahashaakha;
  int? yuvasangampresentmahashaakhasankalpit;
  int? yuvasangampresentvartmantarun;
  int? yuvasangampresentvartmantarunsankalpit;
  int? yuvasangamexceptmahashaakha;
  int? yuvasangamexceptmahashaakhasankalpit;
  int? yuvasangamexceptvartmantarun;
  int? yuvasangamexceptvartmantarunsankalpit;

  int? yuvasangampresentshaakha;
  int? yuvasangampresentsankalpitshaakha;
  int? yuvasangamexceptshaakha;
  int? yuvasangamexceptvartmansankalpit;
  int? totalyuvasangampresentshaakha;
  int? totalyuvasangamexceptshaakha;

  String? ekunyuvaname;
  String? pendingyuvaname;
  String? completeyuvaname;

  Yuvrpt({this.levelname,
    this.ekunyuva,
    this.pendingyuva,
    this.completeyuva,
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
    this.ekunexcept,
    this.ekunpresent,
    this.yuvasangampresentmahashaakha,
    this.yuvasangampresentmahashaakhasankalpit,
    this.yuvasangampresentvartmantarun,
    this.yuvasangampresentvartmantarunsankalpit,
    this.yuvasangamexceptmahashaakha,
    this.yuvasangamexceptmahashaakhasankalpit,
    this.yuvasangamexceptvartmantarun,
    this.yuvasangamexceptvartmantarunsankalpit,
    this.yuvasangampresentshaakha,
    this.yuvasangampresentsankalpitshaakha,
    this.yuvasangamexceptshaakha,
    this.yuvasangamexceptvartmansankalpit,
    this.totalyuvasangampresentshaakha,
    this.totalyuvasangamexceptshaakha,
    this.ekunyuvaname,
    this.pendingyuvaname,
    this.completeyuvaname});

  Yuvrpt.fromJson(Map<String, dynamic> json) {
    levelname = json['levelname'];
    ekunyuva = json['ekunyuva'];
    pendingyuva = json['pendingyuva'];
    completeyuva = json['completeyuva'];
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
    ekunexcept = json['ekunexcept'];
    ekunpresent = json['ekunpresent'];
    yuvasangampresentmahashaakha = json['yuvasangampresentmahashaakha'];
    yuvasangampresentmahashaakhasankalpit = json['yuvasangampresentmahashaakhasankalpit'];
    yuvasangampresentvartmantarun = json['yuvasangampresentvartmantarun'];
    yuvasangampresentvartmantarunsankalpit = json['yuvasangampresentvartmantarunsankalpit'];
    yuvasangamexceptmahashaakha = json['yuvasangamexceptmahashaakha'];
    yuvasangamexceptmahashaakhasankalpit = json['yuvasangamexceptmahashaakhasankalpit'];
    yuvasangamexceptvartmantarun = json['yuvasangamexceptvartmantarun'];
    yuvasangamexceptvartmantarunsankalpit = json['yuvasangamexceptvartmantarunsankalpit'];
    yuvasangampresentshaakha = json['yuvasangampresentshaakha'];
    yuvasangampresentsankalpitshaakha = json['yuvasangampresentsankalpitshaakha'];
    yuvasangamexceptshaakha = json['yuvasangamexceptshaakha'];
    yuvasangamexceptvartmansankalpit = json['yuvasangamexceptvartmansankalpit'];
    totalyuvasangampresentshaakha = json['totalyuvasangampresentshaakha'];
    totalyuvasangamexceptshaakha = json['totalyuvasangamexceptshaakha'];
    ekunyuvaname = json['ekunyuvaname'];
    pendingyuvaname = json['pendingyuvaname'];
    completeyuvaname = json['completeyuvaname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['levelname'] = this.levelname;
    data['ekunyuva'] = this.ekunyuva;
    data['pendingyuva'] = this.pendingyuva;
    data['completeyuva'] = this.completeyuva;
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
    data['ekunexcept'] = this.ekunexcept;
    data['ekunpresent'] = this.ekunpresent;
    data['yuvasangampresentmahashaakha'] = this.yuvasangampresentmahashaakha;
    data['yuvasangampresentmahashaakhasankalpit'] = this.yuvasangampresentmahashaakhasankalpit;
    data['yuvasangampresentvartmantarun'] = this.yuvasangampresentvartmantarun;
    data['yuvasangampresentvartmantarunsankalpit'] = this.yuvasangampresentvartmantarunsankalpit;
    data['yuvasangamexceptmahashaakha'] = this.yuvasangamexceptmahashaakha;
    data['yuvasangamexceptmahashaakhasankalpit'] = this.yuvasangamexceptmahashaakhasankalpit;
    data['yuvasangamexceptvartmantarun'] = this.yuvasangamexceptvartmantarun;
    data['yuvasangamexceptvartmantarunsankalpit'] = this.yuvasangamexceptvartmantarunsankalpit;
    data['yuvasangampresentshaakha'] = this.yuvasangampresentshaakha;
    data['yuvasangampresentsankalpitshaakha'] = this.yuvasangampresentsankalpitshaakha;
    data['yuvasangamexceptshaakha'] = this.yuvasangamexceptshaakha;
    data['yuvasangamexceptvartmansankalpit'] = this.yuvasangamexceptvartmansankalpit;
    data['totalyuvasangampresentshaakha'] = this.totalyuvasangampresentshaakha;
    data['totalyuvasangamexceptshaakha'] = this.totalyuvasangamexceptshaakha;
    data['ekunyuvaname'] = this.ekunyuvaname;
    data['pendingyuvaname'] = this.pendingyuvaname;
    data['completeyuvaname'] = this.completeyuvaname;
    return data;
  }
}
