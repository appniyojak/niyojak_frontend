class TulnatmakResponse {
  final String status;
  final String message;
  final String totalGrowth;
  final String newGrowth;
  final int shaakhaacount;
  final int milancount;
  final int mansikcount;
  final int sangacount;
  final List<VGraph> vData;
  final List<HGraph> hData;
  final List<FGraph> shaakhaData;
  final List<FGraph> saptahikData;
  final List<FGraph> manshikData;
  final List<FGraph> sangaData;

  TulnatmakResponse({
    required this.status,
    required this.message,
    required this.totalGrowth,
    required this.newGrowth,
    required this.shaakhaacount,
    required this.milancount,
    required this.mansikcount,
    required this.sangacount,
    required this.vData,
    required this.hData,
    required this.shaakhaData,
    required this.saptahikData,
    required this.manshikData,
    required this.sangaData,
  });

  factory TulnatmakResponse.fromJson(Map<String, dynamic> json) => TulnatmakResponse(
        status: json["Status"] as String? ?? "",
        message: json["Message"] as String? ?? "",
        totalGrowth: json["TotalGrowth"] as String? ?? "",
        newGrowth: json["NewGrowth"] as String? ?? "",
        shaakhaacount: json["shaakhaacount"] ?? 0,
        milancount: json["milancount"] ?? 0,
        mansikcount: json["mansikcount"] ?? 0,
        sangacount: json["sangacount"] ?? 0,
        vData: (json["vData"] as List<dynamic>? ?? []).map((e) => VGraph.fromJson(e as Map<String, dynamic>)).toList(),
        hData: (json["hData"] as List<dynamic>? ?? []).map((e) => HGraph.fromJson(e as Map<String, dynamic>)).toList(),
        shaakhaData: (json["shaakhaData"] as List<dynamic>? ?? []).map((e) => FGraph.fromJson(e as Map<String, dynamic>)).toList(),
        saptahikData: (json["saptahikData"] as List<dynamic>? ?? []).map((e) => FGraph.fromJson(e as Map<String, dynamic>)).toList(),
        manshikData: (json["manshikData"] as List<dynamic>? ?? []).map((e) => FGraph.fromJson(e as Map<String, dynamic>)).toList(),
        sangaData: (json["sangaData"] as List<dynamic>? ?? []).map((e) => FGraph.fromJson(e as Map<String, dynamic>)).toList(),
      );

  bool get isSuccess => status.trim().toLowerCase() == "success";
}

class VGraph {
  final int year;
  final String code;
  final int totalPresent;

  VGraph({required this.year, required this.code, required this.totalPresent});

  factory VGraph.fromJson(Map<String, dynamic> json) => VGraph(
        year: json["Year"] as int,
        code: json["Code"] as String? ?? "",
        totalPresent: json["TotalPresent"] as int? ?? 0,
      );
}

class HGraph {
  final String year;
  final String activity;
  final int month;
  final int sCount;

  HGraph({required this.year, required this.activity, required this.month, required this.sCount});

  factory HGraph.fromJson(Map<String, dynamic> json) => HGraph(
        year: json["Year"]?.toString() ?? "",
        activity: json["Activity"] as String? ?? "",
        month: json["Month"] ?? 0,
        sCount: json["SCount"] as int? ?? 0,
      );
}

class FGraph {
  final String freqname;
  final int year;
  final int month;
  final int frequencyID;
  final int shakhaCount1plus;
  final int shakhaCount15plus;
  final int saphathikCount1plus;
  final int saphathikCount3plus;
  final int manshikCount1plus;
  final int sangaCount1plus;

  FGraph(
      {required this.freqname,
      required this.year,
      required this.month,
      required this.frequencyID,
      required this.shakhaCount1plus,
      required this.shakhaCount15plus,
      required this.saphathikCount1plus,
      required this.saphathikCount3plus,
      required this.manshikCount1plus,
      required this.sangaCount1plus});

  factory FGraph.fromJson(Map<String, dynamic> json) => FGraph(
        frequencyID: json["FrequencyID"] as int? ?? 0,
        month: json["Month"] as int? ?? 0,
        year: json["Year"] as int? ?? 0,
        freqname: json["freqname"] as String? ?? "",
        shakhaCount1plus: json["ShakhaCount1plus"] as int? ?? 0,
        shakhaCount15plus: json["ShakhaCount15plus"] as int? ?? 0,
        saphathikCount1plus: json["saphathikCount1plus"] as int? ?? 0,
        saphathikCount3plus: json["saphathikCount3plus"] as int? ?? 0,
        manshikCount1plus: json["manshikCount1plus"] as int? ?? 0,
        sangaCount1plus: json["sangaCount1plus"] as int? ?? 0,
      );
}
