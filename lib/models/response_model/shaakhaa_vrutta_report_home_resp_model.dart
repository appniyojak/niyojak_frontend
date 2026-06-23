class ShaakhaaVruttaReportHomeRespModel {
  String? status;
  String? message;
  String? usertype;
  String? prevofPrevMonthName;
  String? prevMonthName;
  String? thisMonthName;
  String? prevYearName;
  String? thisYearName;
  String? laststarttoendname;
  String? thisstartoendname;
  Shaakhadata? shaakhadata;
  Otherdata? otherdata;

  ShaakhaaVruttaReportHomeRespModel(
      {this.status,
      this.message,
      this.usertype,
      this.shaakhadata,
      this.otherdata,
      this.prevofPrevMonthName,
      this.prevMonthName,
      this.thisMonthName,
      this.prevYearName,
      this.thisYearName,
      this.laststarttoendname,
      this.thisstartoendname});

  ShaakhaaVruttaReportHomeRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    usertype = json['usertype'];
    prevofPrevMonthName = json['PrevofPrevMonthName'];
    prevMonthName = json['PrevMonthName'];
    thisMonthName = json['ThisMonthName'];
    prevYearName = json['PrevYearName'];
    thisYearName = json['ThisYearName'];
    laststarttoendname = json['laststarttoendname'];
    thisstartoendname = json['thisstartoendname'];
    shaakhadata = json['shaakhadata'] != null ? new Shaakhadata.fromJson(json['shaakhadata']) : null;
    otherdata = json['otherdata'] != null ? new Otherdata.fromJson(json['otherdata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['usertype'] = this.usertype;
    data['PrevofPrevMonthName'] = this.prevofPrevMonthName;
    data['PrevMonthName'] = this.prevMonthName;
    data['ThisMonthName'] = this.thisMonthName;
    data['PrevYearName'] = this.prevYearName;
    data['ThisYearName'] = this.thisYearName;
    data['laststarttoendname'] = this.laststarttoendname;
    data['thisstartoendname'] = this.thisstartoendname;
    if (this.shaakhadata != null) {
      data['shaakhadata'] = this.shaakhadata!.toJson();
    }
    if (this.otherdata != null) {
      data['otherdata'] = this.otherdata!.toJson();
    }
    return data;
  }
}

class Shaakhadata {
  TotalAndNewModel? daily;
  TotalAndNewModel? weekly;
  TotalAndNewModel? monthly;
  TotalAndNewModel? tmonthly;

  Shaakhadata({this.daily, this.weekly, this.monthly, this.tmonthly});

  Shaakhadata.fromJson(Map<String, dynamic> json) {
    daily = json['daily'] != null ? new TotalAndNewModel.fromJson(json['daily']) : null;
    weekly = json['weekly'] != null ? new TotalAndNewModel.fromJson(json['weekly']) : null;
    monthly = json['monthly'] != null ? new TotalAndNewModel.fromJson(json['monthly']) : null;
    tmonthly = json['tmonthly'] != null ? new TotalAndNewModel.fromJson(json['tmonthly']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.daily != null) {
      data['daily'] = this.daily!.toJson();
    }
    if (this.weekly != null) {
      data['weekly'] = this.weekly!.toJson();
    }
    if (this.monthly != null) {
      data['monthly'] = this.monthly!.toJson();
    }
    if (this.tmonthly != null) {
      data['tmonthly'] = this.tmonthly!.toJson();
    }
    return data;
  }
}

class TotalAndNewModel {
  int? todayCount;
  int? yesterdayCount;
  int? todayNewCount;
  int? yesterdayNewCount;

  TotalAndNewModel({this.todayCount, this.yesterdayCount, this.todayNewCount, this.yesterdayNewCount});

  TotalAndNewModel.fromJson(Map<String, dynamic> json) {
    todayCount = json['TodayCount'];
    yesterdayCount = json['YesterdayCount'];
    todayNewCount = json['TodayNewCount'];
    yesterdayNewCount = json['YesterdayNewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TodayCount'] = this.todayCount;
    data['YesterdayCount'] = this.yesterdayCount;
    data['TodayNewCount'] = this.todayNewCount;
    data['YesterdayNewCount'] = this.yesterdayNewCount;
    return data;
  }
}

class Otherdata {
  Shaobj? shaobj;
  Weekobj? weekobj;
  Monthobj? monthobj;
  Yearobj? yearobj;

  Otherdata({this.shaobj, this.weekobj, this.monthobj, this.yearobj});

  Otherdata.fromJson(Map<String, dynamic> json) {
    shaobj = json['shaobj'] != null ? new Shaobj.fromJson(json['shaobj']) : null;
    weekobj = json['weekobj'] != null ? new Weekobj.fromJson(json['weekobj']) : null;
    monthobj = json['monthobj'] != null ? new Monthobj.fromJson(json['monthobj']) : null;
    yearobj = json['yearobj'] != null ? new Yearobj.fromJson(json['yearobj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shaobj != null) {
      data['shaobj'] = this.shaobj!.toJson();
    }
    if (this.weekobj != null) {
      data['weekobj'] = this.weekobj!.toJson();
    }
    if (this.monthobj != null) {
      data['monthobj'] = this.monthobj!.toJson();
    }
    if (this.yearobj != null) {
      data['yearobj'] = this.yearobj!.toJson();
    }
    return data;
  }
}

class Shaobj {
  int? shaakhaaCount;
  int? todayShaakhaaCount;
  int? yesterdayShaakhaaCount;

  Shaobj({this.shaakhaaCount, this.todayShaakhaaCount, this.yesterdayShaakhaaCount});

  Shaobj.fromJson(Map<String, dynamic> json) {
    shaakhaaCount = json['ShaakhaaCount'];
    todayShaakhaaCount = json['TodayShaakhaaCount'];
    yesterdayShaakhaaCount = json['YesterdayShaakhaaCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShaakhaaCount'] = this.shaakhaaCount;
    data['TodayShaakhaaCount'] = this.todayShaakhaaCount;
    data['YesterdayShaakhaaCount'] = this.yesterdayShaakhaaCount;
    return data;
  }
}

class Weekobj {
  int? shaakhaaCount;
  int? thisWeekShaakhaaCount;
  int? lastWeekShaakhaaCount;
  int? shaapthahikCount;
  int? thisWeekShaapthahikCount;
  int? lastWeekShaapthahikCount;

  Weekobj({this.shaakhaaCount, this.thisWeekShaakhaaCount, this.lastWeekShaakhaaCount, this.shaapthahikCount, this.thisWeekShaapthahikCount, this.lastWeekShaapthahikCount});

  Weekobj.fromJson(Map<String, dynamic> json) {
    shaakhaaCount = json['ShaakhaaCount'];
    thisWeekShaakhaaCount = json['ThisWeekShaakhaaCount'];
    lastWeekShaakhaaCount = json['LastWeekShaakhaaCount'];
    shaapthahikCount = json['ShaapthahikCount'];
    thisWeekShaapthahikCount = json['ThisWeekShaapthahikCount'];
    lastWeekShaapthahikCount = json['LastWeekShaapthahikCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShaakhaaCount'] = this.shaakhaaCount;
    data['ThisWeekShaakhaaCount'] = this.thisWeekShaakhaaCount;
    data['LastWeekShaakhaaCount'] = this.lastWeekShaakhaaCount;
    data['ShaapthahikCount'] = this.shaapthahikCount;
    data['ThisWeekShaapthahikCount'] = this.thisWeekShaapthahikCount;
    data['LastWeekShaapthahikCount'] = this.lastWeekShaapthahikCount;
    return data;
  }
}

class Monthobj {
  int? shaakhaaCount;
  int? thisMonthShaakhaaCount;
  int? lastMonthShaakhaaCount;
  int? shaapthahikCount;
  int? thisMonthShaapthahikCount;
  int? lastMonthShaapthahikCount;
  int? mandaliCount;
  int? thisMonthMandaliCount;
  int? lastMonthMandaliCount;
  int? masikCount;
  int? thisMonthMasikCount;
  int? lastMonthMasikCount;
  int? prevofprevMonthCount;
  int? prevMonthCount;
  int? prevmonthshakha;
  int? prevmonthmilan;
  int? prevmonthsanga;
  int? prevmonthmaansik;
  int? prevofprevmonthshakha;
  int? prevofprevmonthmilan;
  int? prevofprevmonthsanga;
  int? prevofprevmonthmaansik;

  Monthobj({
    this.shaakhaaCount,
    this.thisMonthShaakhaaCount,
    this.lastMonthShaakhaaCount,
    this.shaapthahikCount,
    this.thisMonthShaapthahikCount,
    this.lastMonthShaapthahikCount,
    this.mandaliCount,
    this.thisMonthMandaliCount,
    this.lastMonthMandaliCount,
    this.masikCount,
    this.thisMonthMasikCount,
    this.lastMonthMasikCount,
    this.prevofprevMonthCount,
    this.prevMonthCount,
    this.prevmonthshakha,
    this.prevmonthmilan,
    this.prevmonthsanga,
    this.prevmonthmaansik,
    this.prevofprevmonthshakha,
    this.prevofprevmonthmilan,
    this.prevofprevmonthsanga,
    this.prevofprevmonthmaansik,
  });

  Monthobj.fromJson(Map<String, dynamic> json) {
    shaakhaaCount = json['ShaakhaaCount'];
    thisMonthShaakhaaCount = json['ThisMonthShaakhaaCount'];
    lastMonthShaakhaaCount = json['LastMonthShaakhaaCount'];
    shaapthahikCount = json['ShaapthahikCount'];
    thisMonthShaapthahikCount = json['ThisMonthShaapthahikCount'];
    lastMonthShaapthahikCount = json['LastMonthShaapthahikCount'];
    mandaliCount = json['MandaliCount'];
    thisMonthMandaliCount = json['ThisMonthMandaliCount'];
    lastMonthMandaliCount = json['LastMonthMandaliCount'];
    masikCount = json['MasikCount'];
    thisMonthMasikCount = json['ThisMonthMasikCount'];
    lastMonthMasikCount = json['LastMonthMasikCount'];
    prevofprevMonthCount = json['PrevofprevMonthCount'];
    prevMonthCount = json['prevMonthCount'];
    prevmonthshakha = json['prevmonthshakha'];
    prevmonthmilan = json['prevmonthmilan'];
    prevmonthsanga = json['prevmonthsanga'];
    prevmonthmaansik = json['prevmonthmaansik'];
    prevofprevmonthshakha = json['prevofprevmonthshakha'];
    prevofprevmonthmilan = json['prevofprevmonthmilan'];
    prevofprevmonthsanga = json['prevofprevmonthsanga'];
    prevofprevmonthmaansik = json['prevofprevmonthmaansik'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShaakhaaCount'] = this.shaakhaaCount;
    data['ThisMonthShaakhaaCount'] = this.thisMonthShaakhaaCount;
    data['LastMonthShaakhaaCount'] = this.lastMonthShaakhaaCount;
    data['ShaapthahikCount'] = this.shaapthahikCount;
    data['ThisMonthShaapthahikCount'] = this.thisMonthShaapthahikCount;
    data['LastMonthShaapthahikCount'] = this.lastMonthShaapthahikCount;
    data['MandaliCount'] = this.mandaliCount;
    data['ThisMonthMandaliCount'] = this.thisMonthMandaliCount;
    data['LastMonthMandaliCount'] = this.lastMonthMandaliCount;
    data['MasikCount'] = this.masikCount;
    data['ThisMonthMasikCount'] = this.thisMonthMasikCount;
    data['LastMonthMasikCount'] = this.lastMonthMasikCount;
    data['PrevofprevMonthCount'] = this.prevofprevMonthCount;
    data['prevMonthCount'] = this.prevMonthCount;
    data['prevmonthshakha'] = this.prevmonthshakha;
    data['prevmonthmilan'] = this.prevmonthmilan;
    data['prevmonthsanga'] = this.prevmonthsanga;
    data['prevmonthmaansik'] = this.prevmonthmaansik;
    data['prevofprevmonthshakha'] = this.prevofprevmonthshakha;
    data['prevofprevmonthmilan'] = this.prevofprevmonthmilan;
    data['prevofprevmonthsanga'] = this.prevofprevmonthsanga;
    data['prevofprevmonthmaansik'] = this.prevofprevmonthmaansik;
    return data;
  }
}

class Yearobj {
  int? shaakhaaCount;
  int? thisYearShaakhaaCount;
  int? lastYearShaakhaaCount;
  int? shaapthahikCount;
  int? thisYearShaapthahikCount;
  int? lastYearShaapthahikCount;
  int? mandaliCount;
  int? thisYearMandaliCount;
  int? lastYearMandaliCount;
  int? masikCount;
  int? thisYearMasikCount;
  int? lastYearMasikCount;
  int? prevYearCount;
  int? thisYearCount;
  int? prevyearshakha;
  int? prevyearmilan;
  int? prevyearsanga;
  int? prevyearmaansik;
  int? prevofprevyearshakha;
  int? prevofprevyearmilan;
  int? prevofprevyearsanga;
  int? prevofprevyearmaansik;

  Yearobj({
    this.shaakhaaCount,
    this.thisYearShaakhaaCount,
    this.lastYearShaakhaaCount,
    this.shaapthahikCount,
    this.thisYearShaapthahikCount,
    this.lastYearShaapthahikCount,
    this.mandaliCount,
    this.thisYearMandaliCount,
    this.lastYearMandaliCount,
    this.masikCount,
    this.thisYearMasikCount,
    this.lastYearMasikCount,
    this.prevYearCount,
    this.thisYearCount,
    this.prevyearshakha,
    this.prevyearmilan,
    this.prevyearsanga,
    this.prevyearmaansik,
    this.prevofprevyearshakha,
    this.prevofprevyearmilan,
    this.prevofprevyearsanga,
    this.prevofprevyearmaansik,
  });

  Yearobj.fromJson(Map<String, dynamic> json) {
    shaakhaaCount = json['ShaakhaaCount'];
    thisYearShaakhaaCount = json['ThisYearShaakhaaCount'];
    lastYearShaakhaaCount = json['LastYearShaakhaaCount'];
    shaapthahikCount = json['ShaapthahikCount'];
    thisYearShaapthahikCount = json['ThisYearShaapthahikCount'];
    lastYearShaapthahikCount = json['LastYearShaapthahikCount'];
    mandaliCount = json['MandaliCount'];
    thisYearMandaliCount = json['ThisYearMandaliCount'];
    lastYearMandaliCount = json['LastYearMandaliCount'];
    masikCount = json['MasikCount'];
    thisYearMasikCount = json['ThisYearMasikCount'];
    lastYearMasikCount = json['LastYearMasikCount'];
    prevYearCount = json['PrevYearCount'];
    thisYearCount = json['ThisYearCount'];
    prevyearshakha = json['prevyearshakha'];
    prevyearmilan = json['prevyearmilan'];
    prevyearsanga = json['prevyearsanga'];
    prevyearmaansik = json['prevyearmaansik'];
    prevofprevyearshakha = json['prevofprevyearshakha'];
    prevofprevyearmilan = json['prevofprevyearmilan'];
    prevofprevyearsanga = json['prevofprevyearsanga'];
    prevofprevyearmaansik = json['prevofprevyearmaansik'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShaakhaaCount'] = this.shaakhaaCount;
    data['ThisYearShaakhaaCount'] = this.thisYearShaakhaaCount;
    data['LastYearShaakhaaCount'] = this.lastYearShaakhaaCount;
    data['ShaapthahikCount'] = this.shaapthahikCount;
    data['ThisYearShaapthahikCount'] = this.thisYearShaapthahikCount;
    data['LastYearShaapthahikCount'] = this.lastYearShaapthahikCount;
    data['MandaliCount'] = this.mandaliCount;
    data['ThisYearMandaliCount'] = this.thisYearMandaliCount;
    data['LastYearMandaliCount'] = this.lastYearMandaliCount;
    data['MasikCount'] = this.masikCount;
    data['ThisYearMasikCount'] = this.thisYearMasikCount;
    data['LastYearMasikCount'] = this.lastYearMasikCount;
    data['PrevYearCount'] = this.prevYearCount;
    data['ThisYearCount'] = this.thisYearCount;
    data['prevyearshakha'] = this.prevyearshakha;
    data['prevyearmilan'] = this.prevyearmilan;
    data['prevyearsanga'] = this.prevyearsanga;
    data['prevyearmaansik'] = this.prevyearmaansik;
    data['prevofprevyearshakha'] = this.prevofprevyearshakha;
    data['prevofprevyearmilan'] = this.prevofprevyearmilan;
    data['prevofprevyearsanga'] = this.prevofprevyearsanga;
    data['prevofprevyearmaansik'] = this.prevofprevyearmaansik;
    return data;
  }
}
