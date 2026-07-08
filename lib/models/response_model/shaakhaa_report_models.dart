// ─── My Shaakhaa Ranking ──────────────────────────────────────────────────────

class MylvlResponse {
  final String status;
  final String message;
  final MyPerformance? myperformancedata;
  final List<MyNearby> myData;
  final List<MylvlGraph> gData;

  const MylvlResponse({
    required this.status,
    required this.message,
    required this.myperformancedata,
    required this.myData,
    required this.gData,
  });

  factory MylvlResponse.fromJson(Map<String, dynamic> json) => MylvlResponse(
        status: json['Status'] ?? '',
        message: json['Message'] ?? '',
        myperformancedata: json['myperformancedata'] != null ? MyPerformance.fromJson(json['myperformancedata']) : null,
        myData: (json['myData'] as List<dynamic>? ?? []).map((e) => MyNearby.fromJson(e)).toList(),
        gData: (json['GData'] as List<dynamic>? ?? []).map((e) => MylvlGraph.fromJson(e)).toList(),
      );
}

class MyPerformance {
  final String movement; // "Up" | "Down" | "Same"
  final int rankStayedDays;
  final int currentRank;
  final int previousRank;
  final int rankMovement; // +ve = improved, -ve = dropped
  final int totalshaakha;

  const MyPerformance({
    required this.movement,
    required this.rankStayedDays,
    required this.currentRank,
    required this.previousRank,
    required this.rankMovement,
    required this.totalshaakha,
  });

  factory MyPerformance.fromJson(Map<String, dynamic> json) => MyPerformance(
        movement: json['Movement'] ?? 'Same',
        rankStayedDays: json['RankStayedDays'] ?? 0,
        currentRank: json['CurrentRank'] ?? 0,
        previousRank: json['PreviousRank'] ?? 0,
        rankMovement: json['RankMovement'] ?? 0,
        totalshaakha: json['totalshaakha'] ?? 0,
      );
}

class MyNearby {
  final String geoUnitName;
  final int presentcnt;
  final int rankNo;
  final int ismyshaakha; // 1 = this user's shaakhaa

  const MyNearby({
    required this.geoUnitName,
    required this.presentcnt,
    required this.rankNo,
    required this.ismyshaakha,
  });

  factory MyNearby.fromJson(Map<String, dynamic> json) => MyNearby(
        geoUnitName: json['GeoUnitName'] ?? '',
        presentcnt: json['Presentcnt'] ?? 0,
        rankNo: json['RankNo'] ?? 0,
        ismyshaakha: json['ismyshaakha'] ?? 0,
      );
}

class MylvlGraph {
  final String periodType;
  final String dateRange;
  final int periodNo;
  final int rankNo;
  final int presentCnt;

  const MylvlGraph({
    required this.periodType,
    required this.dateRange,
    required this.periodNo,
    required this.rankNo,
    required this.presentCnt,
  });

  factory MylvlGraph.fromJson(Map<String, dynamic> json) => MylvlGraph(
        periodType: json['PeriodType'] ?? '',
        dateRange: json['DateRange'] ?? '',
        periodNo: json['PeriodNo'] ?? 0,
        rankNo: json['RankNo'] ?? 0,
        presentCnt: json['PresentCnt'] ?? 0,
      );
}
