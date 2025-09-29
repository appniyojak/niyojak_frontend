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
  String? karyakramnirdharitvedhvarcountNames;
  int? karykakramcount;
  String? karykakramcountNames;
  String? levelname;
  int? shanchalancount;
  String? shanchalancountNames;
  int? shanchalanghosvandancount;
  String? shanchalanghosvandancountNames;
  int? skaraykramhisob24tasapurnacount;
  String? skaraykramhisob24tasapurnacountNames;
  int? vyaktigeetkhantastakcount;
  String? vyaktigeetkhantastakcountNames;

  Vijayadashaminagarlist({
    this.karyakramnirdharitvedhvarcount,
    this.karyakramnirdharitvedhvarcountNames,
    this.karykakramcount,
    this.karykakramcountNames,
    this.levelname,
    this.shanchalancount,
    this.shanchalancountNames,
    this.shanchalanghosvandancount,
    this.shanchalanghosvandancountNames,
    this.skaraykramhisob24tasapurnacount,
    this.skaraykramhisob24tasapurnacountNames,
    this.vyaktigeetkhantastakcount,
    this.vyaktigeetkhantastakcountNames,
  });

  Vijayadashaminagarlist.fromJson(Map<String, dynamic> json) {
    karyakramnirdharitvedhvarcount = json['karyakramnirdharitvedhvarcount'];
    karyakramnirdharitvedhvarcountNames = json['karyakramnirdharitvedhvarcount_names'];
    karykakramcount = json['karykakramcount'];
    karykakramcountNames = json['karykakramcount_names'];
    levelname = json['levelname'];
    shanchalancount = json['shanchalancount'];
    shanchalancountNames = json['shanchalancount_names'];
    shanchalanghosvandancount = json['shanchalanghosvandancount'];
    shanchalanghosvandancountNames = json['shanchalanghosvandancount_names'];
    skaraykramhisob24tasapurnacount = json['skaraykramhisob24tasapurnacount'];
    skaraykramhisob24tasapurnacountNames = json['skaraykramhisob24tasapurnacount_names'];
    vyaktigeetkhantastakcount = json['vyaktigeetkhantastakcount'];
    vyaktigeetkhantastakcountNames = json['vyaktigeetkhantastakcount_names'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['karyakramnirdharitvedhvarcount'] = this.karyakramnirdharitvedhvarcount;
    data['karyakramnirdharitvedhvarcount_names'] = this.karyakramnirdharitvedhvarcountNames;
    data['karykakramcount'] = this.karykakramcount;
    data['karykakramcount_names'] = this.karykakramcountNames;
    data['levelname'] = this.levelname;
    data['shanchalancount'] = this.shanchalancount;
    data['shanchalancount_names'] = this.shanchalancountNames;
    data['shanchalanghosvandancount'] = this.shanchalanghosvandancount;
    data['shanchalanghosvandancount_names'] = this.shanchalanghosvandancountNames;
    data['skaraykramhisob24tasapurnacount'] = this.skaraykramhisob24tasapurnacount;
    data['skaraykramhisob24tasapurnacount_names'] = this.skaraykramhisob24tasapurnacountNames;
    data['vyaktigeetkhantastakcount'] = this.vyaktigeetkhantastakcount;
    data['vyaktigeetkhantastakcount_names'] = this.vyaktigeetkhantastakcountNames;
    return data;
  }
}
