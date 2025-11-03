class VijayadashamiExcelRespModel {
  String? status;
  String? message;
  List<NagarReportData>? data;

  VijayadashamiExcelRespModel({this.status, this.message, this.data});

  VijayadashamiExcelRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <NagarReportData>[];
      json['data'].forEach((v) {
        data!.add(new NagarReportData.fromJson(v));
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

class NagarReportData {
  int? nagarId;
  String? nagarName;
  ReportCategory? baal;
  ReportCategory? mahavidya;
  ReportCategory? tarunVyav;
  ReportCategory? proudhVyav;
  Totals? totals;

  NagarReportData({this.nagarId, this.nagarName, this.baal, this.mahavidya, this.tarunVyav, this.proudhVyav, this.totals});

  NagarReportData.fromJson(Map<String, dynamic> json) {
    nagarId = json['nagarId'];
    nagarName = json['nagarName'];
    baal = json['baal'] != null ? new ReportCategory.fromJson(json['baal']) : null;
    mahavidya = json['mahavidya'] != null ? new ReportCategory.fromJson(json['mahavidya']) : null;
    tarunVyav = json['tarunVyav'] != null ? new ReportCategory.fromJson(json['tarunVyav']) : null;
    proudhVyav = json['proudhVyav'] != null ? new ReportCategory.fromJson(json['proudhVyav']) : null;
    totals = json['totals'] != null ? new Totals.fromJson(json['totals']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nagarId'] = this.nagarId;
    data['nagarName'] = this.nagarName;
    if (this.baal != null) {
      data['baal'] = this.baal!.toJson();
    }
    if (this.mahavidya != null) {
      data['mahavidya'] = this.mahavidya!.toJson();
    }
    if (this.tarunVyav != null) {
      data['tarunVyav'] = this.tarunVyav!.toJson();
    }
    if (this.proudhVyav != null) {
      data['proudhVyav'] = this.proudhVyav!.toJson();
    }
    if (this.totals != null) {
      data['totals'] = this.totals!.toJson();
    }
    return data;
  }
}

class ReportCategory {
  int? pat;
  int? gan;
  int? anya;
  int? ekun;

  ReportCategory({this.pat, this.gan, this.anya, this.ekun});

  ReportCategory.fromJson(Map<String, dynamic> json) {
    pat = json['pat'];
    gan = json['gan'];
    anya = json['anya'];
    ekun = json['ekun'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pat'] = this.pat;
    data['gan'] = this.gan;
    data['anya'] = this.anya;
    data['ekun'] = this.ekun;
    return data;
  }
}

class Totals {
  int? ekunPat;
  int? ekunGan;
  int? ekunAnya;
  int? ekunEkun;

  Totals({this.ekunPat, this.ekunGan, this.ekunAnya, this.ekunEkun});

  Totals.fromJson(Map<String, dynamic> json) {
    ekunPat = json['ekunPat'];
    ekunGan = json['ekunGan'];
    ekunAnya = json['ekunAnya'];
    ekunEkun = json['ekunEkun'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ekunPat'] = this.ekunPat;
    data['ekunGan'] = this.ekunGan;
    data['ekunAnya'] = this.ekunAnya;
    data['ekunEkun'] = this.ekunEkun;
    return data;
  }
}
