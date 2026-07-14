// ─── Shaakhaa Level — Daily & Weekly ─────────────────────────────────────────

class ShakhaaDailyWeeklyResponse {
  final String status;
  final String message;
  final int totalpresent;
  final int totalnewpresent;
  final int shaakhaacount;
  final int milancount;
  final int mansikcount;
  final int sangacount;
  final List<ActivityData> data;

  const ShakhaaDailyWeeklyResponse({
    required this.status,
    required this.message,
    required this.totalpresent,
    required this.totalnewpresent,
    required this.shaakhaacount,
    required this.milancount,
    required this.mansikcount,
    required this.sangacount,
    required this.data,
  });

  factory ShakhaaDailyWeeklyResponse.fromJson(Map<String, dynamic> json) {
    return ShakhaaDailyWeeklyResponse(
      status: json['Status'] ?? '',
      message: json['Message'] ?? '',
      totalpresent: json['totalpresent'] ?? 0,
      totalnewpresent: json['totalnewpresent'] ?? 0,
      shaakhaacount: json['shaakhaacount'] ?? 0,
      milancount: json['milancount'] ?? 0,
      mansikcount: json['mansikcount'] ?? 0,
      sangacount: json['sangacount'] ?? 0,
      data: (json['Data'] as List<dynamic>? ?? []).map((e) => ActivityData.fromJson(e)).toList(),
    );
  }
}

class ActivityData {
  final String activity;
  final String parentactivity;
  final String percentage; // ignored for daily
  final int value;

  const ActivityData({
    required this.activity,
    required this.parentactivity,
    required this.percentage,
    required this.value,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      activity: json['Activity'] ?? '',
      parentactivity: json['parentActivity'] ?? json['ParentActivity'] ?? '',
      percentage: (json['Percentage'] ?? '0').toString().replaceAll("%", ""),
      value: json['Value'] ?? 0,
    );
  }
}

// ─── Shaakhaa Level — Monthly ─────────────────────────────────────────────────

class ShaakhaaMonthlyResponse {
  final String status;
  final String message;
  final int totalpresent;
  final int totalnewpresent;
  final int shaakhaacount;
  final int milancount;
  final int mansikcount;
  final int sangacount;
  final List<ActivityDataMonthly> mData;

  const ShaakhaaMonthlyResponse({
    required this.status,
    required this.message,
    required this.totalpresent,
    required this.totalnewpresent,
    required this.shaakhaacount,
    required this.milancount,
    required this.mansikcount,
    required this.sangacount,
    required this.mData,
  });

  factory ShaakhaaMonthlyResponse.fromJson(Map<String, dynamic> json) {
    return ShaakhaaMonthlyResponse(
      status: json['Status'] ?? '',
      message: json['Message'] ?? '',
      totalpresent: json['totalpresent'] ?? 0,
      totalnewpresent: json['totalnewpresent'] ?? 0,
      shaakhaacount: json['shaakhaacount'] ?? 0,
      milancount: json['milancount'] ?? 0,
      mansikcount: json['mansikcount'] ?? 0,
      sangacount: json['sangacount'] ?? 0,
      mData: (json['MData'] as List<dynamic>? ?? []).map((e) => ActivityDataMonthly.fromJson(e)).toList(),
    );
  }
}

class ActivityDataMonthly {
  final String activity;
  final String parentactivity;
  final int week1;
  final String week1Percent;
  final String week1Range;
  final int week2;
  final String week2Percent;
  final String week2Range;
  final int week3;
  final String week3Percent;
  final String week3Range;
  final int week4;
  final String week4Percent;
  final String week4Range;
  final int total28Days;
  final String percentage28Days;

  const ActivityDataMonthly({
    required this.activity,
    required this.parentactivity,
    required this.week1,
    required this.week1Percent,
    required this.week1Range,
    required this.week2,
    required this.week2Percent,
    required this.week2Range,
    required this.week3,
    required this.week3Percent,
    required this.week3Range,
    required this.week4,
    required this.week4Percent,
    required this.week4Range,
    required this.total28Days,
    required this.percentage28Days,
  });

  factory ActivityDataMonthly.fromJson(Map<String, dynamic> json) {
    return ActivityDataMonthly(
      activity: json['Activity'] ?? '',
      parentactivity: json['parentActivity'] ?? json['ParentActivity'] ?? '',
      week1: json['Week1'] ?? 0,
      week1Percent: (json['Week1Percent'] ?? '0').toString().replaceAll("%", ""),
      week1Range: json['Week1Range'] ?? '',
      week2: json['Week2'] ?? 0,
      week2Percent: (json['Week2Percent'] ?? '0').toString().replaceAll("%", ""),
      week2Range: json['Week2Range'] ?? '',
      week3: json['Week3'] ?? 0,
      week3Percent: (json['Week3Percent'] ?? '0').toString().replaceAll("%", ""),
      week3Range: json['Week3Range'] ?? '',
      week4: json['Week4'] ?? 0,
      week4Percent: (json['Week4Percent'] ?? '0').toString().replaceAll("%", ""),
      week4Range: json['Week4Range'] ?? '',
      total28Days: json['Total28Days'] ?? 0,
      percentage28Days: (json['Percentage28Days'] ?? '0').toString().replaceAll("%", ""),
    );
  }
}

// ─── Shaakhaa Level — Quarterly / Half-Yearly / Yearly ───────────────────────

class ShaakhaaMultiMonthlyResponse {
  final String status;
  final String message;
  final int totalpresent;
  final int totalnewpresent;
  final int shaakhaacount;
  final int milancount;
  final int mansikcount;
  final int sangacount;
  final List<ActivityMonthlyData> data;

  const ShaakhaaMultiMonthlyResponse({
    required this.status,
    required this.message,
    required this.totalpresent,
    required this.totalnewpresent,
    required this.shaakhaacount,
    required this.milancount,
    required this.mansikcount,
    required this.sangacount,
    required this.data,
  });

  factory ShaakhaaMultiMonthlyResponse.fromJson(Map<String, dynamic> json) {
    return ShaakhaaMultiMonthlyResponse(
      status: json['Status'] ?? '',
      message: json['Message'] ?? '',
      totalpresent: json['totalpresent'] ?? 0,
      totalnewpresent: json['totalnewpresent'] ?? 0,
      shaakhaacount: json['shaakhaacount'] ?? 0,
      milancount: json['milancount'] ?? 0,
      mansikcount: json['mansikcount'] ?? 0,
      sangacount: json['sangacount'] ?? 0,
      data: (json['Data'] as List<dynamic>? ?? []).map((e) => ActivityMonthlyData.fromJson(e)).toList(),
    );
  }
}

class ActivityMonthlyData {
  final String activity;
  final String parentactivity;
  final List<MonthData> months;

  const ActivityMonthlyData({
    required this.activity,
    required this.parentactivity,
    required this.months,
  });

  factory ActivityMonthlyData.fromJson(Map<String, dynamic> json) {
    return ActivityMonthlyData(
      activity: json['Activity'] ?? '',
      parentactivity: json['parentActivity'] ?? json['ParentActivity'] ?? '',
      months: (json['Months'] as List<dynamic>? ?? []).map((e) => MonthData.fromJson(e)).toList(),
    );
  }
}

class MonthData {
  final int monthNo;
  final int value;
  final double percentage;
  final String range;

  const MonthData({
    required this.monthNo,
    required this.value,
    required this.percentage,
    required this.range,
  });

  factory MonthData.fromJson(Map<String, dynamic> json) {
    return MonthData(
      monthNo: json['MonthNo'] ?? 0,
      value: json['Value'] ?? 0,
      percentage: (json['Percentage'] ?? 0).toDouble(),
      range: json['Range'] ?? '',
    );
  }
}

// ─── All Levels (levelId != 1) — Daily ───────────────────────────────────────

class AllDailyResponse {
  final String status;
  final String message;
  final int shaakhaacount;
  final int milancount;
  final int mansikcount;
  final int sangacount;
  final int pravasiKaryakartaCount;
  final int shaakhaPravasiCount;
  final int kittedin;
  final List<PresentList> pData;
  final List<ActivityData> aData; // reuses existing ActivityData
  final List<Sdetail> sdetail;

  const AllDailyResponse({
    required this.status,
    required this.message,
    required this.shaakhaacount,
    required this.milancount,
    required this.mansikcount,
    required this.sangacount,
    required this.pravasiKaryakartaCount,
    required this.shaakhaPravasiCount,
    required this.kittedin,
    required this.pData,
    required this.aData,
    required this.sdetail,
  });

  factory AllDailyResponse.fromJson(Map<String, dynamic> json) {
    return AllDailyResponse(
      status: json['Status'] ?? '',
      message: json['Message'] ?? '',
      shaakhaacount: json['shaakhaacount'] ?? 0,
      milancount: json['milancount'] ?? 0,
      mansikcount: json['mansikcount'] ?? 0,
      sangacount: json['sangacount'] ?? 0,
      pravasiKaryakartaCount: json['PravasiKaryakartaCount'] ?? 0,
      shaakhaPravasiCount: json['ShaakhaPravasiCount'] ?? 0,
      kittedin: json['kittedin'] ?? 0,
      pData: (json['pData'] as List<dynamic>? ?? []).map((e) => PresentList.fromJson(e)).toList(),
      aData: (json['aData'] as List<dynamic>? ?? []).map((e) => ActivityData.fromJson(e)).toList(),
      sdetail: (json['sdetail'] as List<dynamic>? ?? []).map((e) => Sdetail.fromJson(e)).toList(),
    );
  }
}

class PresentList {
  final int totalpresent;
  final int totalnewpresent;
  final String vagogatname;
  final String code;

  const PresentList({
    required this.totalpresent,
    required this.totalnewpresent,
    required this.vagogatname,
    required this.code,
  });

  factory PresentList.fromJson(Map<String, dynamic> json) {
    return PresentList(
      totalpresent: json['totalpresent'] ?? 0,
      totalnewpresent: json['totalnewpresent'] ?? 0,
      vagogatname: json['vagogatname'] ?? '',
      code: json['code'] ?? '',
    );
  }
}
// ─── Shared: TotalCountShaakhaa ───────────────────────────────────────────────

class TotalCountShaakhaa {
  final int geoUnitID;
  final String shaakhaname;
  final String vagogatname;
  final String trailname;
  final int totalpresent;

  const TotalCountShaakhaa({
    required this.geoUnitID,
    required this.shaakhaname,
    required this.vagogatname,
    required this.trailname,
    required this.totalpresent,
  });

  factory TotalCountShaakhaa.fromJson(Map<String, dynamic> json) => TotalCountShaakhaa(
        geoUnitID: json['GeoUnitID'] ?? 0,
        shaakhaname: json['shaakhaname'] ?? '',
        vagogatname: json['vagogatname'] ?? '',
        trailname: json['trailname'] ?? '',
        totalpresent: json['totalpresent'] ?? 0,
      );
}

// ─── All Levels (levelId != 1) — Weekly ──────────────────────────────────────

class AllWeeklyResponse {
  final String status;
  final String message;
  final int shaakhaacount;
  final int milancount;
  final int mansikcount;
  final int sangacount;
  final int pravasiKaryakartaCount;
  final int shaakhaPravasiCount;
  final int kittedin;
  final List<PresentList> pData;
  final List<AllWeeklyActivity> aData;
  final List<TotalCountShaakhaa> shaakhatotalcount;
  final List<TotalCountShaakhaa> shaakhanewcount;
  final List<TotalCountShaakhaa> sapthahiktotalcount;
  final List<TotalCountShaakhaa> sapthahiknewcount;
  final List<Sdetail> sdetail;

  const AllWeeklyResponse({
    required this.status,
    required this.message,
    required this.shaakhaacount,
    required this.milancount,
    required this.mansikcount,
    required this.sangacount,
    required this.pravasiKaryakartaCount,
    required this.shaakhaPravasiCount,
    required this.kittedin,
    required this.pData,
    required this.aData,
    required this.shaakhatotalcount,
    required this.shaakhanewcount,
    required this.sapthahiktotalcount,
    required this.sapthahiknewcount,
    required this.sdetail,
  });

  factory AllWeeklyResponse.fromJson(Map<String, dynamic> json) => AllWeeklyResponse(
        status: json['Status'] ?? '',
        message: json['Message'] ?? '',
        shaakhaacount: json['shaakhaacount'] ?? 0,
        milancount: json['milancount'] ?? 0,
        mansikcount: json['mansikcount'] ?? 0,
        sangacount: json['sangacount'] ?? 0,
        pravasiKaryakartaCount: json['PravasiKaryakartaCount'] ?? 0,
        shaakhaPravasiCount: json['ShaakhaPravasiCount'] ?? 0,
        kittedin: json['kittedin'] ?? 0,
        pData: (json['pData'] as List<dynamic>? ?? []).map((e) => PresentList.fromJson(e)).toList(),
        aData: (json['aData'] as List<dynamic>? ?? []).map((e) => AllWeeklyActivity.fromJson(e)).toList(),
        shaakhatotalcount: (json['shaakhatotalcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        shaakhanewcount: (json['shaakhanewcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        sapthahiktotalcount: (json['sapthahiktotalcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        sapthahiknewcount: (json['sapthahiknewcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        sdetail: (json['sdetail'] as List<dynamic>? ?? []).map((e) => Sdetail.fromJson(e)).toList(),
      );
}

class AllWeeklyActivity {
  final String activity;
  final String parentactivity;
  final int timesDone; // TODO: confirm if this is day index (1–7) or cumulative count
  final int shaakhaCount;

  const AllWeeklyActivity({required this.activity, required this.parentactivity, required this.timesDone, required this.shaakhaCount});

  factory AllWeeklyActivity.fromJson(Map<String, dynamic> json) => AllWeeklyActivity(
        activity: json['Activity'] ?? '',
        parentactivity: json['parentActivity'] ?? json['ParentActivity'] ?? '',
        timesDone: json['TimesDone'] ?? 0,
        shaakhaCount: json['ShaakhaCount'] ?? 0,
      );
}

// ─── All Levels — Monthly ────────────────────────────────────────────────────

class AllMonthlyResponse {
  final String status;
  final String message;
  final int shaakhaacount;
  final int milancount;
  final int mansikcount;
  final int sangacount;
  final int pravasiKaryakartaCount;
  final int shaakhaPravasiCount;
  final int kittedin;
  final List<PresentList> pData;
  final List<AllMonthlyActivity> aData;
  final List<TotalCountShaakhaa> shaakhatotalcount;
  final List<TotalCountShaakhaa> shaakhanewcount;
  final List<TotalCountShaakhaa> sapthahiktotalcount;
  final List<TotalCountShaakhaa> sapthahiknewcount;
  final List<Sdetail> sdetail;

  const AllMonthlyResponse({
    required this.status,
    required this.message,
    required this.shaakhaacount,
    required this.milancount,
    required this.mansikcount,
    required this.sangacount,
    required this.pravasiKaryakartaCount,
    required this.shaakhaPravasiCount,
    required this.kittedin,
    required this.pData,
    required this.aData,
    required this.shaakhatotalcount,
    required this.shaakhanewcount,
    required this.sapthahiktotalcount,
    required this.sapthahiknewcount,
    required this.sdetail,
  });

  factory AllMonthlyResponse.fromJson(Map<String, dynamic> json) => AllMonthlyResponse(
        status: json['Status'] ?? '',
        message: json['Message'] ?? '',
        shaakhaacount: json['shaakhaacount'] ?? 0,
        milancount: json['milancount'] ?? 0,
        mansikcount: json['mansikcount'] ?? 0,
        sangacount: json['sangacount'] ?? 0,
        pravasiKaryakartaCount: json['PravasiKaryakartaCount'] ?? 0,
        shaakhaPravasiCount: json['ShaakhaPravasiCount'] ?? 0,
        kittedin: json['kittedin'] ?? 0,
        pData: (json['pData'] as List<dynamic>? ?? []).map((e) => PresentList.fromJson(e)).toList(),
        aData: (json['aData'] as List<dynamic>? ?? []).map((e) => AllMonthlyActivity.fromJson(e)).toList(),
        shaakhatotalcount: (json['shaakhatotalcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        shaakhanewcount: (json['shaakhanewcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        sapthahiktotalcount: (json['sapthahiktotalcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        sapthahiknewcount: (json['sapthahiknewcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        sdetail: (json['sdetail'] as List<dynamic>? ?? []).map((e) => Sdetail.fromJson(e)).toList(),
      );
}

class AllMonthlyActivity {
  final String activity;
  final String parentactivity;
  final String weekcolumn; // "Week1", "Week2", etc.
  final String weekRange; // "सप्ताह १", etc.
  final int shaakhaCount;

  const AllMonthlyActivity({
    required this.activity,
    required this.parentactivity,
    required this.weekcolumn,
    required this.weekRange,
    required this.shaakhaCount,
  });

  factory AllMonthlyActivity.fromJson(Map<String, dynamic> json) => AllMonthlyActivity(
        activity: json['Activity'] ?? '',
        parentactivity: json['parentActivity'] ?? json['ParentActivity'] ?? '',
        weekcolumn: json['weekcolumn'] ?? '',
        weekRange: json['WeekRange'] ?? '',
        shaakhaCount: json['ShaakhaCount'] ?? 0,
      );
}

// ─── All Levels — MultiMonthly (Quarterly / Half-Yearly / Yearly) ─────────────
// aData reuses existing ActivityMonthlyData model.

class AllMultiMonthlyResponse {
  final String status;
  final String message;
  final int shaakhaacount;
  final int milancount;
  final int mansikcount;
  final int sangacount;
  final int pravasiKaryakartaCount;
  final int shaakhaPravasiCount;
  final int kittedin;
  final List<PresentList> pData;
  final List<ActivityMonthlyData> aData; // reuses existing model
  final List<TotalCountShaakhaa> shaakhatotalcount;
  final List<TotalCountShaakhaa> shaakhanewcount;
  final List<TotalCountShaakhaa> sapthahiktotalcount;
  final List<TotalCountShaakhaa> sapthahiknewcount;
  final List<Sdetail> sdetail;

  const AllMultiMonthlyResponse({
    required this.status,
    required this.message,
    required this.shaakhaacount,
    required this.milancount,
    required this.mansikcount,
    required this.sangacount,
    required this.pravasiKaryakartaCount,
    required this.shaakhaPravasiCount,
    required this.kittedin,
    required this.pData,
    required this.aData,
    required this.shaakhatotalcount,
    required this.shaakhanewcount,
    required this.sapthahiktotalcount,
    required this.sapthahiknewcount,
    required this.sdetail,
  });

  factory AllMultiMonthlyResponse.fromJson(Map<String, dynamic> json) => AllMultiMonthlyResponse(
        status: json['Status'] ?? '',
        message: json['Message'] ?? '',
        shaakhaacount: json['shaakhaacount'] ?? 0,
        milancount: json['milancount'] ?? 0,
        mansikcount: json['mansikcount'] ?? 0,
        sangacount: json['sangacount'] ?? 0,
        pravasiKaryakartaCount: json['PravasiKaryakartaCount'] ?? 0,
        shaakhaPravasiCount: json['ShaakhaPravasiCount'] ?? 0,
        kittedin: json['kittedin'] ?? 0,
        pData: (json['pData'] as List<dynamic>? ?? []).map((e) => PresentList.fromJson(e)).toList(),
        aData: (json['aData'] as List<dynamic>? ?? []).map((e) => ActivityMonthlyData.fromJson(e)).toList(),
        shaakhatotalcount: (json['shaakhatotalcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        shaakhanewcount: (json['shaakhanewcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        sapthahiktotalcount: (json['sapthahiktotalcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        sapthahiknewcount: (json['sapthahiknewcount'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
        sdetail: (json['sdetail'] as List<dynamic>? ?? []).map((e) => Sdetail.fromJson(e)).toList(),
      );
}

// ─── Karyakram Top 10 ─────────────────────────────────────────────────────────

class KaryakramResponse {
  final String status;
  final String message;
  final List<TotalCountShaakhaa> mdata;

  const KaryakramResponse({
    required this.status,
    required this.message,
    required this.mdata,
  });

  factory KaryakramResponse.fromJson(Map<String, dynamic> json) => KaryakramResponse(
        status: json['Status'] ?? '',
        message: json['Message'] ?? '',
        mdata: (json['mdata'] as List<dynamic>? ?? []).map((e) => TotalCountShaakhaa.fromJson(e)).toList(),
      );
}

class Sdetail {
  String? sname;
  int? value;
  int? kittedin;

  Sdetail({this.sname, this.value, this.kittedin});

  Sdetail.fromJson(Map<String, dynamic> json) {
    sname = json['sname'];
    value = json['value'];
    kittedin = json['kittedin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sname'] = this.sname;
    data['value'] = this.value;
    data['kittedin'] = this.kittedin;
    return data;
  }
}
