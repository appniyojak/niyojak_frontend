class HinduSanmelanReportModel {
  String? status;
  String? message;
  List<Table1>? table1;
  Otherinfo? otherinfo;
  Bhougolikprati? bhougolikprati;
  Samaj? samaj;

  HinduSanmelanReportModel({this.status, this.message, this.table1, this.otherinfo, this.bhougolikprati, this.samaj});

  HinduSanmelanReportModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['table1'] != null) {
      table1 = <Table1>[];
      json['table1'].forEach((v) {
        table1!.add(new Table1.fromJson(v));
      });
    }
    otherinfo = json['otherinfo'] != null ? new Otherinfo.fromJson(json['otherinfo']) : null;
    bhougolikprati = json['bhougolikprati'] != null ? new Bhougolikprati.fromJson(json['bhougolikprati']) : null;
    samaj = json['samaj'] != null ? new Samaj.fromJson(json['samaj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.table1 != null) {
      data['table1'] = this.table1!.map((v) => v.toJson()).toList();
    }
    if (this.otherinfo != null) {
      data['otherinfo'] = this.otherinfo!.toJson();
    }
    if (this.bhougolikprati != null) {
      data['bhougolikprati'] = this.bhougolikprati!.toJson();
    }
    if (this.samaj != null) {
      data['samaj'] = this.samaj!.toJson();
    }
    return data;
  }
}

class Table1 {
  String? levelMarathi;
  int? sanmelancount;
  String? sanmelancountnames;
  int? totalcount;
  String? totalcountnames;
  int? grammprati;
  String? grammpratinames;
  int? totalmale;
  String? totalmalenames;
  int? totalfemale;
  String? totalfemalenames;
  int? specialpersontotalcount;
  String? specialpersontotalcountnames;
  int? ekunfinalcount;
  String? ekunfinalcountnames;

  Table1(
      {this.levelMarathi,
      this.sanmelancount,
      this.sanmelancountnames,
      this.totalcount,
      this.totalcountnames,
      this.grammprati,
      this.grammpratinames,
      this.totalmale,
      this.totalmalenames,
      this.totalfemale,
      this.totalfemalenames,
      this.specialpersontotalcount,
      this.specialpersontotalcountnames,
      this.ekunfinalcount,
      this.ekunfinalcountnames});

  Table1.fromJson(Map<String, dynamic> json) {
    levelMarathi = json['LevelMarathi'];
    sanmelancount = json['sanmelancount'];
    sanmelancountnames = json['sanmelancountnames'];
    totalcount = json['totalcount'];
    totalcountnames = json['totalcountnames'];
    grammprati = json['grammprati'];
    grammpratinames = json['grammpratinames'];
    totalmale = json['totalmale'];
    totalmalenames = json['totalmalenames'];
    totalfemale = json['totalfemale'];
    totalfemalenames = json['totalfemalenames'];
    specialpersontotalcount = json['specialpersontotalcount'];
    specialpersontotalcountnames = json['specialpersontotalcountnames'];
    ekunfinalcount = json['ekunfinalcount'];
    ekunfinalcountnames = json['ekunfinalcountnames'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LevelMarathi'] = this.levelMarathi;
    data['sanmelancount'] = this.sanmelancount;
    data['sanmelancountnames'] = this.sanmelancountnames;
    data['totalcount'] = this.totalcount;
    data['totalcountnames'] = this.totalcountnames;
    data['grammprati'] = this.grammprati;
    data['grammpratinames'] = this.grammpratinames;
    data['totalmale'] = this.totalmale;
    data['totalmalenames'] = this.totalmalenames;
    data['totalfemale'] = this.totalfemale;
    data['totalfemalenames'] = this.totalfemalenames;
    data['specialpersontotalcount'] = this.specialpersontotalcount;
    data['specialpersontotalcountnames'] = this.specialpersontotalcountnames;
    data['ekunfinalcount'] = this.ekunfinalcount;
    data['ekunfinalcountnames'] = this.ekunfinalcountnames;
    return data;
  }
}

class Otherinfo {
  int? urlCount;
  String? urlCountnames;
  int? imgCount;
  String? imgCountnames;
  int? advCount;
  String? advCountnames;

  Otherinfo({this.urlCount, this.urlCountnames, this.imgCount, this.imgCountnames, this.advCount, this.advCountnames});

  Otherinfo.fromJson(Map<String, dynamic> json) {
    urlCount = json['urlCount'];
    urlCountnames = json['urlCountnames'];
    imgCount = json['imgCount'];
    imgCountnames = json['imgCountnames'];
    advCount = json['advCount'];
    advCountnames = json['advCountnames'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['urlCount'] = this.urlCount;
    data['urlCountnames'] = this.urlCountnames;
    data['imgCount'] = this.imgCount;
    data['imgCountnames'] = this.imgCountnames;
    data['advCount'] = this.advCount;
    data['advCountnames'] = this.advCountnames;
    return data;
  }
}

class Bhougolikprati {
  int? totalmandalCount;
  int? totalmandalStartedcount;
  int? totalgramCount;
  int? pratigramcount;
  int? totalvasti;
  int? vastiStartedcount;

  Bhougolikprati({this.totalmandalCount, this.totalmandalStartedcount, this.totalgramCount, this.pratigramcount, this.totalvasti, this.vastiStartedcount});

  Bhougolikprati.fromJson(Map<String, dynamic> json) {
    totalmandalCount = json['totalmandalCount'];
    totalmandalStartedcount = json['totalmandalStartedcount'];
    totalgramCount = json['totalgramCount'];
    pratigramcount = json['pratigramcount'];
    totalvasti = json['totalvasti'];
    vastiStartedcount = json['vastiStartedcount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalmandalCount'] = this.totalmandalCount;
    data['totalmandalStartedcount'] = this.totalmandalStartedcount;
    data['totalgramCount'] = this.totalgramCount;
    data['pratigramcount'] = this.pratigramcount;
    data['totalvasti'] = this.totalvasti;
    data['vastiStartedcount'] = this.vastiStartedcount;
    return data;
  }
}

class Samaj {
  int? mukhyaatithifemale;
  int? mukhyaatithimale;
  int? sadbavkaryafemale;
  int? sadbavkaryamale;
  int? sajjanskhatiuppasstitifemale;
  int? sajjanskhatiuppasstitimale;
  int? pramukhjhanuppasstitifemale;
  int? pramukhjhanuppasstitimale;
  int? ekuntotalmale;
  int? ekuntotalfemale;

  Samaj(
      {this.mukhyaatithifemale,
      this.mukhyaatithimale,
      this.sadbavkaryafemale,
      this.sadbavkaryamale,
      this.sajjanskhatiuppasstitifemale,
      this.sajjanskhatiuppasstitimale,
      this.pramukhjhanuppasstitifemale,
      this.pramukhjhanuppasstitimale,
      this.ekuntotalmale,
      this.ekuntotalfemale});

  Samaj.fromJson(Map<String, dynamic> json) {
    mukhyaatithifemale = json['mukhyaatithifemale'];
    mukhyaatithimale = json['mukhyaatithimale'];
    sadbavkaryafemale = json['sadbavkaryafemale'];
    sadbavkaryamale = json['sadbavkaryamale'];
    sajjanskhatiuppasstitifemale = json['sajjanskhatiuppasstitifemale'];
    sajjanskhatiuppasstitimale = json['sajjanskhatiuppasstitimale'];
    pramukhjhanuppasstitifemale = json['pramukhjhanuppasstitifemale'];
    pramukhjhanuppasstitimale = json['pramukhjhanuppasstitimale'];
    ekuntotalmale = json['ekuntotalmale'];
    ekuntotalfemale = json['ekuntotalfemale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mukhyaatithifemale'] = this.mukhyaatithifemale;
    data['mukhyaatithimale'] = this.mukhyaatithimale;
    data['sadbavkaryafemale'] = this.sadbavkaryafemale;
    data['sadbavkaryamale'] = this.sadbavkaryamale;
    data['sajjanskhatiuppasstitifemale'] = this.sajjanskhatiuppasstitifemale;
    data['sajjanskhatiuppasstitimale'] = this.sajjanskhatiuppasstitimale;
    data['pramukhjhanuppasstitifemale'] = this.pramukhjhanuppasstitifemale;
    data['pramukhjhanuppasstitimale'] = this.pramukhjhanuppasstitimale;
    data['ekuntotalmale'] = this.ekuntotalmale;
    data['ekuntotalfemale'] = this.ekuntotalfemale;
    return data;
  }
}
