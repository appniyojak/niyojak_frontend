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
  int? previousWeekShakhaa;
  int? thisWeekShakhaa;
  int? todayShakhaa;
  int? totalshakhaa;
  int? yesterdayShakhaa;

  ShaakhaaVistaarReport(
      {this.todayTotalCnt,
      this.todayNewTotalCnt,
      this.yesterdayTotalCnt,
      this.yesterdayNewTotalCnt,
      this.thisWeekTotalCnt,
      this.thisWeekNewTotalCnt,
      this.lastWeekTotalCnt,
      this.lastWeekNewTotalCnt,
      this.mid,
      this.previousWeekShakhaa,
      this.thisWeekShakhaa,
      this.todayShakhaa,
      this.totalshakhaa,
      this.yesterdayShakhaa});

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
    previousWeekShakhaa = json['PreviousWeekShakhaa'];
    thisWeekShakhaa = json['ThisWeekShakhaa'];
    todayShakhaa = json['TodayShakhaa'];
    totalshakhaa = json['Totalshakhaa'];
    yesterdayShakhaa = json['YesterdayShakhaa'];
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
    data['PreviousWeekShakhaa'] = this.previousWeekShakhaa;
    data['ThisWeekShakhaa'] = this.thisWeekShakhaa;
    data['TodayShakhaa'] = this.todayShakhaa;
    data['Totalshakhaa'] = this.totalshakhaa;
    data['YesterdayShakhaa'] = this.yesterdayShakhaa;
    return data;
  }
}
