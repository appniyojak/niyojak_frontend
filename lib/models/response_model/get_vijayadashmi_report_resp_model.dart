class GetVijayadashamiReportModel {
  String? message;
  String? status;
  VijayadashamiReport? vijayadashamiReport;
  List<Vijayadashaminagarlist>? vijayadashaminagarlist;

  GetVijayadashamiReportModel({this.message, this.status, this.vijayadashamiReport, this.vijayadashaminagarlist});

  GetVijayadashamiReportModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    vijayadashamiReport = json['VijayadashamiReport'] != null ? new VijayadashamiReport.fromJson(json['VijayadashamiReport']) : null;
    if (json['Vijayadashaminagarlist'] != null) {
      vijayadashaminagarlist = <Vijayadashaminagarlist>[];
      json['Vijayadashaminagarlist'].forEach((v) {
        vijayadashaminagarlist!.add(new Vijayadashaminagarlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.vijayadashamiReport != null) {
      data['VijayadashamiReport'] = this.vijayadashamiReport!.toJson();
    }
    if (this.vijayadashaminagarlist != null) {
      data['Vijayadashaminagarlist'] = this.vijayadashaminagarlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VijayadashamiReport {
  int? anyanuppasstitifemale;
  int? anyauppasstitimale;
  int? ekungan;
  int? ekunpat;
  int? ekunsanchalan;
  int? ekunupastiti;
  int? gramcountpratinidhatva;
  int? mandalcountpratinidhatva;
  int? mukhyaatithifemale;
  int? mukhyaatithimale;
  int? pramukhjhanuppasstitifemale;
  int? pramukhjhanuppasstitimale;
  int? sadbavkaryafemale;
  int? sadbavkaryamale;
  int? sajjanskhatiuppasstitifemale;
  int? sajjanskhatiuppasstitimale;
  int? vartamansaakhapratinidhatva;
  int? vartamansanghmandalipratinidhatva;
  int? vartamansapthahikpratinidhatva;
  int? vasticountpratinidhatva;

  VijayadashamiReport(
      {this.anyanuppasstitifemale,
      this.anyauppasstitimale,
      this.ekungan,
      this.ekunpat,
      this.ekunsanchalan,
      this.ekunupastiti,
      this.gramcountpratinidhatva,
      this.mandalcountpratinidhatva,
      this.mukhyaatithifemale,
      this.mukhyaatithimale,
      this.pramukhjhanuppasstitifemale,
      this.pramukhjhanuppasstitimale,
      this.sadbavkaryafemale,
      this.sadbavkaryamale,
      this.sajjanskhatiuppasstitifemale,
      this.sajjanskhatiuppasstitimale,
      this.vartamansaakhapratinidhatva,
      this.vartamansanghmandalipratinidhatva,
      this.vartamansapthahikpratinidhatva,
      this.vasticountpratinidhatva});

  VijayadashamiReport.fromJson(Map<String, dynamic> json) {
    anyanuppasstitifemale = json['anyanuppasstitifemale'];
    anyauppasstitimale = json['anyauppasstitimale'];
    ekungan = json['ekungan'];
    ekunpat = json['ekunpat'];
    ekunsanchalan = json['ekunsanchalan'];
    ekunupastiti = json['ekunupastiti'];
    gramcountpratinidhatva = json['gramcountpratinidhatva'];
    mandalcountpratinidhatva = json['mandalcountpratinidhatva'];
    mukhyaatithifemale = json['mukhyaatithifemale'];
    mukhyaatithimale = json['mukhyaatithimale'];
    pramukhjhanuppasstitifemale = json['pramukhjhanuppasstitifemale'];
    pramukhjhanuppasstitimale = json['pramukhjhanuppasstitimale'];
    sadbavkaryafemale = json['sadbavkaryafemale'];
    sadbavkaryamale = json['sadbavkaryamale'];
    sajjanskhatiuppasstitifemale = json['sajjanskhatiuppasstitifemale'];
    sajjanskhatiuppasstitimale = json['sajjanskhatiuppasstitimale'];
    vartamansaakhapratinidhatva = json['vartamansaakhapratinidhatva'];
    vartamansanghmandalipratinidhatva = json['vartamansanghmandalipratinidhatva'];
    vartamansapthahikpratinidhatva = json['vartamansapthahikpratinidhatva'];
    vasticountpratinidhatva = json['vasticountpratinidhatva'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['anyanuppasstitifemale'] = this.anyanuppasstitifemale;
    data['anyauppasstitimale'] = this.anyauppasstitimale;
    data['ekungan'] = this.ekungan;
    data['ekunpat'] = this.ekunpat;
    data['ekunsanchalan'] = this.ekunsanchalan;
    data['ekunupastiti'] = this.ekunupastiti;
    data['gramcountpratinidhatva'] = this.gramcountpratinidhatva;
    data['mandalcountpratinidhatva'] = this.mandalcountpratinidhatva;
    data['mukhyaatithifemale'] = this.mukhyaatithifemale;
    data['mukhyaatithimale'] = this.mukhyaatithimale;
    data['pramukhjhanuppasstitifemale'] = this.pramukhjhanuppasstitifemale;
    data['pramukhjhanuppasstitimale'] = this.pramukhjhanuppasstitimale;
    data['sadbavkaryafemale'] = this.sadbavkaryafemale;
    data['sadbavkaryamale'] = this.sadbavkaryamale;
    data['sajjanskhatiuppasstitifemale'] = this.sajjanskhatiuppasstitifemale;
    data['sajjanskhatiuppasstitimale'] = this.sajjanskhatiuppasstitimale;
    data['vartamansaakhapratinidhatva'] = this.vartamansaakhapratinidhatva;
    data['vartamansanghmandalipratinidhatva'] = this.vartamansanghmandalipratinidhatva;
    data['vartamansapthahikpratinidhatva'] = this.vartamansapthahikpratinidhatva;
    data['vasticountpratinidhatva'] = this.vasticountpratinidhatva;
    return data;
  }
}

class Vijayadashaminagarlist {
  int? karyakramnirdharitvedhvarcount;
  int? karykakramcount;
  String? levelname;
  int? shanchalancount;
  int? shanchalanghosvandancount;
  int? skaraykramhisob24tasapurnacount;
  int? vyaktigeetkhantastakcount;

  Vijayadashaminagarlist(
      {this.karyakramnirdharitvedhvarcount,
      this.karykakramcount,
      this.levelname,
      this.shanchalancount,
      this.shanchalanghosvandancount,
      this.skaraykramhisob24tasapurnacount,
      this.vyaktigeetkhantastakcount});

  Vijayadashaminagarlist.fromJson(Map<String, dynamic> json) {
    karyakramnirdharitvedhvarcount = json['karyakramnirdharitvedhvarcount'];
    karykakramcount = json['karykakramcount'];
    levelname = json['levelname'];
    shanchalancount = json['shanchalancount'];
    shanchalanghosvandancount = json['shanchalanghosvandancount'];
    skaraykramhisob24tasapurnacount = json['skaraykramhisob24tasapurnacount'];
    vyaktigeetkhantastakcount = json['vyaktigeetkhantastakcount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['karyakramnirdharitvedhvarcount'] = this.karyakramnirdharitvedhvarcount;
    data['karykakramcount'] = this.karykakramcount;
    data['levelname'] = this.levelname;
    data['shanchalancount'] = this.shanchalancount;
    data['shanchalanghosvandancount'] = this.shanchalanghosvandancount;
    data['skaraykramhisob24tasapurnacount'] = this.skaraykramhisob24tasapurnacount;
    data['vyaktigeetkhantastakcount'] = this.vyaktigeetkhantastakcount;
    return data;
  }
}
