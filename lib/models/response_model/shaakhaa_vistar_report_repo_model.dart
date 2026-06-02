class ShaakhaaVistarReportRespModel {
  String? status;
  String? message;
  ShaakhaaVistaarReport? vruttadata;

  ShaakhaaVistarReportRespModel({this.status, this.message, this.vruttadata});

  ShaakhaaVistarReportRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    vruttadata = json['vruttadata'] != null ? new ShaakhaaVistaarReport.fromJson(json['vruttadata']) : null;
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

class ShaakhaaVistaarReport {
  int? todayTotalCnt;
  int? todayNewTotalCnt;
  int? yesterdayTotalCnt;
  int? yesterdayNewTotalCnt;
  int? thisWeekTotalCnt;
  int? thisWeekNewTotalCnt;
  int? lastWeekTotalCnt;
  int? lastWeekNewTotalCnt;
  int? mid;

  ShaakhaaVistaarReport(
      {this.todayTotalCnt,
      this.todayNewTotalCnt,
      this.yesterdayTotalCnt,
      this.yesterdayNewTotalCnt,
      this.thisWeekTotalCnt,
      this.thisWeekNewTotalCnt,
      this.lastWeekTotalCnt,
      this.lastWeekNewTotalCnt,
      this.mid});

  ShaakhaaVistaarReport.fromJson(Map<String, dynamic> json) {
    todayTotalCnt = json['TodayTotalCnt'];
    todayNewTotalCnt = json['TodayNewTotalCnt'];
    yesterdayTotalCnt = json['YesterdayTotalCnt'];
    yesterdayNewTotalCnt = json['YesterdayNewTotalCnt'];
    thisWeekTotalCnt = json['ThisWeekTotalCnt'];
    thisWeekNewTotalCnt = json['ThisWeekNewTotalCnt'];
    lastWeekTotalCnt = json['LastWeekTotalCnt'];
    lastWeekNewTotalCnt = json['LastWeekNewTotalCnt'];
    mid = json['Mid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TodayTotalCnt'] = this.todayTotalCnt;
    data['TodayNewTotalCnt'] = this.todayNewTotalCnt;
    data['YesterdayTotalCnt'] = this.yesterdayTotalCnt;
    data['YesterdayNewTotalCnt'] = this.yesterdayNewTotalCnt;
    data['ThisWeekTotalCnt'] = this.thisWeekTotalCnt;
    data['ThisWeekNewTotalCnt'] = this.thisWeekNewTotalCnt;
    data['LastWeekTotalCnt'] = this.lastWeekTotalCnt;
    data['LastWeekNewTotalCnt'] = this.lastWeekNewTotalCnt;
    data['Mid'] = this.mid;
    return data;
  }
}
