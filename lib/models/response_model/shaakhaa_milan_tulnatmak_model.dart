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
  final List<FGraph> fData;

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
    required this.fData,
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
        fData: (json["fData"] as List<dynamic>? ?? []).map((e) => FGraph.fromJson(e as Map<String, dynamic>)).toList(),
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

class FGraph {
  final int frequencyID;
  final int month;
  final int year;
  final String freqname;
  final int shakhaCount114;
  final int shakhaCount1529;
  final int shakhaCountGreaterThan29;

  FGraph({
    required this.frequencyID,
    required this.month,
    required this.year,
    required this.freqname,
    required this.shakhaCount114,
    required this.shakhaCount1529,
    required this.shakhaCountGreaterThan29,
  });

  factory FGraph.fromJson(Map<String, dynamic> json) => FGraph(
        frequencyID: json["FrequencyID"] is int ? json["FrequencyID"] as int : int.tryParse(json["FrequencyID"]?.toString() ?? "") ?? 0,
        month: json["Month"] is int ? json["Month"] as int : int.tryParse(json["Month"]?.toString() ?? "") ?? 0,
        year: json["Year"] is int ? json["Year"] as int : int.tryParse(json["Year"]?.toString() ?? "") ?? 0,
        freqname: json["freqname"] as String? ?? "",
        shakhaCount114: json["ShakhaCount1_14"] is int ? json["ShakhaCount1_14"] as int : int.tryParse(json["ShakhaCount1_14"]?.toString() ?? "") ?? 0,
        shakhaCount1529: json["ShakhaCount15_29"] is int ? json["ShakhaCount15_29"] as int : int.tryParse(json["ShakhaCount15_29"]?.toString() ?? "") ?? 0,
        shakhaCountGreaterThan29: json["ShakhaCountGreaterThan29"] is int ? json["ShakhaCountGreaterThan29"] as int : int.tryParse(json["ShakhaCountGreaterThan29"]?.toString() ?? "") ?? 0,
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
        sCount: json["SCount"] is int ? json["SCount"] as int : int.tryParse(json["SCount"]?.toString() ?? "") ?? 0,
      );
}
