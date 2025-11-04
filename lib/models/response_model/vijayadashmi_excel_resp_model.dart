class VijayadashamiExcelRespModel {
  String? status;
  String? message;
  List<NagarReportData>? data;
  List<PratinidhitvaReport>? data2;

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
    if (json['data2'] != null) {
      data2 = <PratinidhitvaReport>[];
      json['data2'].forEach((v) {
        data2!.add(new PratinidhitvaReport.fromJson(v));
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
    if (this.data2 != null) {
      data['data2'] = this.data2!.map((v) => v.toJson()).toList();
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

class PratinidhitvaReport {
  int? geoUnitID;
  String? geoUnitName;
  Bhougolik? bhougolik;
  Anya? anya;

  PratinidhitvaReport({this.geoUnitID, this.geoUnitName, this.bhougolik, this.anya});

  PratinidhitvaReport.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    bhougolik = json['bhougolik'] != null ? new Bhougolik.fromJson(json['bhougolik']) : null;
    anya = json['anyadetail'] != null ? new Anya.fromJson(json['anyadetail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    if (this.bhougolik != null) {
      data['bhougolik'] = this.bhougolik!.toJson();
    }
    if (this.anya != null) {
      data['anyadetail'] = this.anya!.toJson();
    }
    return data;
  }
}

class Anya {
  int? anyaUpastitiMale;
  int? anyaUpastitiMatrushakti;
  int? ekunupastiti;
  int? totalgan;
  int? totalanya;
  int? totalanyaUpastiti;

  Anya({this.anyaUpastitiMale, this.anyaUpastitiMatrushakti, this.ekunupastiti, this.totalanya, this.totalanyaUpastiti, this.totalgan});

  Anya.fromJson(Map<String, dynamic> json) {
    anyaUpastitiMale = json['anya_upastiti_male'];
    anyaUpastitiMatrushakti = json['anya_upastiti_matrushakti'];
    ekunupastiti = json['ekunupastiti'];
    totalanya = json['totalanya'];
    totalanyaUpastiti = json['totalanya_upastiti'];
    totalgan = json['totalgan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['anya_upastiti_male'] = this.anyaUpastitiMale;
    data['anya_upastiti_matrushakti'] = this.anyaUpastitiMatrushakti;
    data['ekunupastiti'] = this.ekunupastiti;
    data['totalanya'] = this.totalanya;
    data['totalanya_upastiti'] = this.totalanyaUpastiti;
    data['totalgan'] = this.totalgan;
    return data;
  }
}

class Bhougolik {
  int? pratinidhatvavastigram;
  int? totvastigram;
  int? pratinidhatvashaakhaa;
  int? totshaakhaa;
  int? pratinidhatvamilan;
  int? totmilan;
  int? pratinidhatvamanasik;
  int? totmanasik;

  Bhougolik({this.pratinidhatvavastigram, this.totvastigram, this.pratinidhatvashaakhaa, this.totshaakhaa, this.pratinidhatvamilan, this.totmilan, this.pratinidhatvamanasik, this.totmanasik});

  Bhougolik.fromJson(Map<String, dynamic> json) {
    pratinidhatvavastigram = json['pratinidhatvavastigram'];
    totvastigram = json['totvastigram'];
    pratinidhatvashaakhaa = json['pratinidhatvashaakhaa'];
    totshaakhaa = json['totshaakhaa'];
    pratinidhatvamilan = json['pratinidhatvamilan'];
    totmilan = json['totmilan'];
    pratinidhatvamanasik = json['pratinidhatvamanasik'];
    totmanasik = json['totmanasik'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pratinidhatvavastigram'] = this.pratinidhatvavastigram;
    data['totvastigram'] = this.totvastigram;
    data['pratinidhatvashaakhaa'] = this.pratinidhatvashaakhaa;
    data['totshaakhaa'] = this.totshaakhaa;
    data['pratinidhatvamilan'] = this.pratinidhatvamilan;
    data['totmilan'] = this.totmilan;
    data['pratinidhatvamanasik'] = this.pratinidhatvamanasik;
    data['totmanasik'] = this.totmanasik;
    return data;
  }
}
