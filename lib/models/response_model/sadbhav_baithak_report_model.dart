class SadbhavBaithakReportModel {
  String? status;
  String? message;
  List<ReportData>? data;

  SadbhavBaithakReportModel({this.status, this.message, this.data});

  SadbhavBaithakReportModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <ReportData>[];
      json['data'].forEach((v) {
        data!.add(new ReportData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportData {
  String? levelname;
  int? baithakcount;
  int? namecount;
  int? totalmalecount;
  int? presentmale;
  int? totalfemalecount;
  int? presentfemale;
  int? totalcount;
  int? totalpresentcount;

  ReportData({this.levelname, this.baithakcount, this.namecount, this.totalmalecount, this.presentmale, this.totalfemalecount, this.presentfemale, this.totalcount, this.totalpresentcount});

  ReportData.fromJson(Map<String, dynamic> json) {
    levelname = json['levelname'];
    baithakcount = json['baithakcount'];
    namecount = json['namecount'];
    totalmalecount = json['totalmalecount'];
    presentmale = json['presentmale'];
    totalfemalecount = json['totalfemalecount'];
    presentfemale = json['presentfemale'];
    totalcount = json['totalcount'];
    totalpresentcount = json['totalpresentcount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['levelname'] = this.levelname;
    data['baithakcount'] = this.baithakcount;
    data['namecount'] = this.namecount;
    data['totalmalecount'] = this.totalmalecount;
    data['presentmale'] = this.presentmale;
    data['totalfemalecount'] = this.totalfemalecount;
    data['presentfemale'] = this.presentfemale;
    data['totalcount'] = this.totalcount;
    data['totalpresentcount'] = this.totalpresentcount;
    return data;
  }
}
