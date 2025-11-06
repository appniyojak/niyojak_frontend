class VijayadashamiExcelRespModel {
  String? status;
  String? message;
  List<NagarReportData>? data;
  List<PratinidhitvaReport>? data2;
  List<VastiShakhaNamesReport>? data3;

  VijayadashamiExcelRespModel({this.status, this.message, this.data, this.data2, this.data3});

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
    if (json['data3'] != null) {
      data3 = <VastiShakhaNamesReport>[];
      json['data3'].forEach((v) {
        data3!.add(new VastiShakhaNamesReport.fromJson(v));
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
    if (this.data3 != null) {
      data['data3'] = this.data3!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NagarReportData {
  int? nagarId;
  String? vibhagname;
  String? bhagname;
  String? stharname;
  String? nagarName;
  String? datafillname;
  ReportCategory? baal;
  ReportCategory? mahavidya;
  ReportCategory? tarunVyav;
  ReportCategory? proudhVyav;
  Totals? totals;

  NagarReportData({this.nagarId, this.vibhagname, this.bhagname, this.stharname, this.nagarName, this.datafillname, this.baal, this.mahavidya, this.tarunVyav, this.proudhVyav, this.totals});

  NagarReportData.fromJson(Map<String, dynamic> json) {
    nagarId = json['nagarId'];
    vibhagname = json['vibhagname'];
    bhagname = json['bhagname'];
    stharname = json['stharname'];
    nagarName = json['nagarName'];
    datafillname = json['datafillname'];
    baal = json['baal'] != null ? new ReportCategory.fromJson(json['baal']) : null;
    mahavidya = json['mahavidya'] != null ? new ReportCategory.fromJson(json['mahavidya']) : null;
    tarunVyav = json['tarunVyav'] != null ? new ReportCategory.fromJson(json['tarunVyav']) : null;
    proudhVyav = json['proudhVyav'] != null ? new ReportCategory.fromJson(json['proudhVyav']) : null;
    totals = json['totals'] != null ? new Totals.fromJson(json['totals']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nagarId'] = this.nagarId;
    data['vibhagname'] = this.vibhagname;
    data['bhagname'] = this.bhagname;
    data['stharname'] = this.stharname;
    data['nagarName'] = this.nagarName;
    data['datafillname'] = this.datafillname;
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
  String? vibhagname;
  String? bhagname;
  String? stharname;
  String? geoUnitName;
  String? datafillname;
  Bhougolik? bhougolik;
  Shakhaapthahikmilanprathi? shakhaapthahikmilanprathi;
  Anya? anya;

  PratinidhitvaReport({this.geoUnitID, this.vibhagname, this.bhagname, this.stharname, this.geoUnitName, this.datafillname, this.bhougolik, this.shakhaapthahikmilanprathi, this.anya});

  PratinidhitvaReport.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    vibhagname = json['vibhagname'];
    bhagname = json['bhagname'];
    stharname = json['stharname'];
    geoUnitName = json['GeoUnitName'];
    datafillname = json['datafillname'];
    bhougolik = json['bhougolik'] != null ? new Bhougolik.fromJson(json['bhougolik']) : null;
    shakhaapthahikmilanprathi = json['shakhaapthahikmilanprathi'] != null ? new Shakhaapthahikmilanprathi.fromJson(json['shakhaapthahikmilanprathi']) : null;
    anya = json['anyadetail'] != null ? new Anya.fromJson(json['anyadetail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['vibhagname'] = this.vibhagname;
    data['bhagname'] = this.bhagname;
    data['stharname'] = this.stharname;
    data['GeoUnitName'] = this.geoUnitName;
    data['datafillname'] = this.datafillname;
    if (this.bhougolik != null) {
      data['bhougolik'] = this.bhougolik!.toJson();
    }
    if (this.shakhaapthahikmilanprathi != null) {
      data['shakhaapthahikmilanprathi'] = this.shakhaapthahikmilanprathi!.toJson();
    }
    if (this.anya != null) {
      data['anyadetail'] = this.anya!.toJson();
    }
    return data;
  }
}

class Anya {
  int? totalgan;
  int? totalanya;
  int? anyaUpastitiMale;
  int? anyaUpastitiMatrushakti;
  int? ekunupastiti;
  int? totalanyaUpastiti;

  Anya({this.totalgan, this.totalanya, this.anyaUpastitiMale, this.anyaUpastitiMatrushakti, this.ekunupastiti, this.totalanyaUpastiti});

  Anya.fromJson(Map<String, dynamic> json) {
    totalgan = json['totalgan'];
    totalanya = json['totalanya'];
    anyaUpastitiMale = json['anya_upastiti_male'];
    anyaUpastitiMatrushakti = json['anya_upastiti_matrushakti'];
    ekunupastiti = json['ekunupastiti'];
    totalanyaUpastiti = json['totalanya_upastiti'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalgan'] = this.totalgan;
    data['totalanya'] = this.totalanya;
    data['anya_upastiti_male'] = this.anyaUpastitiMale;
    data['anya_upastiti_matrushakti'] = this.anyaUpastitiMatrushakti;
    data['ekunupastiti'] = this.ekunupastiti;
    data['totalanya_upastiti'] = this.totalanyaUpastiti;
    return data;
  }
}

class Bhougolik {
  int? distinctParentMandalCount;
  int? pratinidhatvavastigram;
  int? totvastigram;

  Bhougolik({
    this.distinctParentMandalCount,
    this.pratinidhatvavastigram,
    this.totvastigram,
  });

  Bhougolik.fromJson(Map<String, dynamic> json) {
    distinctParentMandalCount = json['DistinctParentMandalCount'];
    pratinidhatvavastigram = json['pratinidhatvavastigram'];
    totvastigram = json['totvastigram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DistinctParentMandalCount'] = this.distinctParentMandalCount;
    data['pratinidhatvavastigram'] = this.pratinidhatvavastigram;
    data['totvastigram'] = this.totvastigram;
    return data;
  }
}

class Shakhaapthahikmilanprathi {
  int? pratinidhatvashaakhaa;
  int? totshaakhaa;
  int? pratinidhatvamilan;
  int? totmilan;
  int? pratinidhatvamanasik;
  int? totmanasik;

  Shakhaapthahikmilanprathi({this.pratinidhatvashaakhaa, this.totshaakhaa, this.pratinidhatvamilan, this.totmilan, this.pratinidhatvamanasik, this.totmanasik});

  Shakhaapthahikmilanprathi.fromJson(Map<String, dynamic> json) {
    pratinidhatvashaakhaa = json['pratinidhatvashaakhaa'];
    totshaakhaa = json['totshaakhaa'];
    pratinidhatvamilan = json['pratinidhatvamilan'];
    totmilan = json['totmilan'];
    pratinidhatvamanasik = json['pratinidhatvamanasik'];
    totmanasik = json['totmanasik'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pratinidhatvashaakhaa'] = this.pratinidhatvashaakhaa;
    data['totshaakhaa'] = this.totshaakhaa;
    data['pratinidhatvamilan'] = this.pratinidhatvamilan;
    data['totmilan'] = this.totmilan;
    data['pratinidhatvamanasik'] = this.pratinidhatvamanasik;
    data['totmanasik'] = this.totmanasik;
    return data;
  }
}

class VastiShakhaNamesReport {
  String? vibhagname;
  String? bhagname;
  String? nagarname;
  String? stharname;
  String? datafillname;
  String? bhougolikPratinidhatvaNames;
  String? shakhaPratinidhatvaNames;
  String? milanPratinidhatvaNames;
  String? manasikSanghMandaliPratinidhatvaNames;

  VastiShakhaNamesReport({
    this.vibhagname,
    this.bhagname,
    this.nagarname,
    this.stharname,
    this.datafillname,
    this.bhougolikPratinidhatvaNames,
    this.shakhaPratinidhatvaNames,
    this.milanPratinidhatvaNames,
    this.manasikSanghMandaliPratinidhatvaNames,
  });

  VastiShakhaNamesReport.fromJson(Map<String, dynamic> json) {
    vibhagname = json['vibhagname'];
    bhagname = json['bhagname'];
    nagarname = json['nagarname'];
    stharname = json['stharname'];
    datafillname = json['datafillname'];
    bhougolikPratinidhatvaNames = json['bhougolik_pratinidhatva_names'];
    shakhaPratinidhatvaNames = json['shakha_pratinidhatva_names'];
    milanPratinidhatvaNames = json['milan_pratinidhatva_names'];
    manasikSanghMandaliPratinidhatvaNames = json['manasik_sangh_mandali_pratinidhatva_names'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vibhagname'] = this.vibhagname;
    data['bhagname'] = this.bhagname;
    data['nagarname'] = this.nagarname;
    data['stharname'] = this.stharname;
    data['datafillname'] = this.datafillname;
    data['bhougolik_pratinidhatva_names'] = this.bhougolikPratinidhatvaNames;
    data['shakha_pratinidhatva_names'] = this.shakhaPratinidhatvaNames;
    data['milan_pratinidhatva_names'] = this.milanPratinidhatvaNames;
    data['manasik_sangh_mandali_pratinidhatva_names'] = this.manasikSanghMandaliPratinidhatvaNames;
    return data;
  }
}
