class OfflineShaakhaPustikaRespModel {
  String? status;
  String? message;
  List<OfflineShaakhaPustika>? list;

  OfflineShaakhaPustikaRespModel({this.status, this.message, this.list});

  OfflineShaakhaPustikaRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['list'] != null) {
      list = <OfflineShaakhaPustika>[];
      json['list'].forEach((v) {
        list!.add(new OfflineShaakhaPustika.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfflineShaakhaPustika {
  int? pkid;
  int? yearno;
  int? monthno;
  int? canupdate;
  String? karyakramname;
  String? vayogatname;
  String? subjecttext;
  String? filepath;
  int? karyakramid;
  String? urllink;
  String? vayogatid;
  String? mdate;

  OfflineShaakhaPustika(
      {this.pkid, this.yearno, this.monthno, this.canupdate, this.karyakramname, this.vayogatname, this.subjecttext, this.filepath, this.karyakramid, this.urllink, this.vayogatid, this.mdate});

  OfflineShaakhaPustika.fromJson(Map<String, dynamic> json) {
    pkid = json['pkid'];
    yearno = json['yearno'] ?? 2020;
    monthno = json['monthno'] ?? 1;
    canupdate = json['canupdate'];
    karyakramname = json['karyakramname'];
    vayogatname = json['vayogatname'];
    subjecttext = json['subjecttext'];
    filepath = json['filepath'];
    karyakramid = json['karyakramid'];
    urllink = json['urllink'];
    vayogatid = json['vayogatid'];
    mdate = json['mdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['yearno'] = this.yearno;
    data['monthno'] = this.monthno;
    data['canupdate'] = this.canupdate;
    data['karyakramname'] = '${this.karyakramname.toString()}';
    data['vayogatname'] = '${this.vayogatname.toString()}';
    data['subjecttext'] = '${this.subjecttext.toString()}';
    data['filepath'] = '${this.filepath.toString()}';
    data['karyakramid'] = this.karyakramid;
    data['urllink'] = '${this.urllink.toString()}';
    data['vayogatid'] = '${this.vayogatid.toString()}';
    data['mdate'] = '${this.mdate.toString()}';
    return data;
  }
}
