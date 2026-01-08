class HinduSanmelanReportModel {
  String? status;
  String? message;
  int? totalmandalCount;
  int? totalmandalStartedcount;
  int? totalgramCount;
  int? pratigramcount;
  int? totalvasti;
  int? vastiStartedcount;
  int? mandalStartedcount;
  int? gramcountpratinidhatva;
  int? urlCount;
  int? imgCount;
  int? advCount;
  int? mukhyaatithifemale;
  int? mukhyaatithimale;
  int? sadbavkaryafemale;
  int? sadbavkaryamale;
  int? sajjanskhatiuppasstitifemale;
  int? sajjanskhatiuppasstitimale;
  int? pramukhjhanuppasstitifemale;
  int? pramukhjhanuppasstitimale;
  List<List1>? list1;

  HinduSanmelanReportModel(
      {this.status,
      this.message,
      this.totalmandalCount,
      this.totalmandalStartedcount,
      this.totalgramCount,
      this.pratigramcount,
      this.totalvasti,
      this.vastiStartedcount,
      this.mandalStartedcount,
      this.gramcountpratinidhatva,
      this.urlCount,
      this.imgCount,
      this.advCount,
      this.mukhyaatithifemale,
      this.mukhyaatithimale,
      this.sadbavkaryafemale,
      this.sadbavkaryamale,
      this.sajjanskhatiuppasstitifemale,
      this.sajjanskhatiuppasstitimale,
      this.pramukhjhanuppasstitifemale,
      this.pramukhjhanuppasstitimale,
      this.list1});

  HinduSanmelanReportModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    totalmandalCount = json['totalmandalCount'];
    totalmandalStartedcount = json['totalmandalStartedcount'];
    totalgramCount = json['totalgramCount'];
    pratigramcount = json['pratigramcount'];
    totalvasti = json['totalvasti'];
    vastiStartedcount = json['vastiStartedcount'];
    mandalStartedcount = json['mandalStartedcount'];
    gramcountpratinidhatva = json['gramcountpratinidhatva'];
    urlCount = json['urlCount'];
    imgCount = json['ImgCount'];
    advCount = json['AdvCount'];
    mukhyaatithifemale = json['mukhyaatithifemale'];
    mukhyaatithimale = json['mukhyaatithimale'];
    sadbavkaryafemale = json['sadbavkaryafemale'];
    sadbavkaryamale = json['sadbavkaryamale'];
    sajjanskhatiuppasstitifemale = json['sajjanskhatiuppasstitifemale'];
    sajjanskhatiuppasstitimale = json['sajjanskhatiuppasstitimale'];
    pramukhjhanuppasstitifemale = json['pramukhjhanuppasstitifemale'];
    pramukhjhanuppasstitimale = json['pramukhjhanuppasstitimale'];
    if (json['List1'] != null) {
      list1 = <List1>[];
      json['List1'].forEach((v) {
        list1!.add(new List1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['totalmandalCount'] = this.totalmandalCount;
    data['totalmandalStartedcount'] = this.totalmandalStartedcount;
    data['totalgramCount'] = this.totalgramCount;
    data['pratigramcount'] = this.pratigramcount;
    data['totalvasti'] = this.totalvasti;
    data['vastiStartedcount'] = this.vastiStartedcount;
    data['mandalStartedcount'] = this.mandalStartedcount;
    data['gramcountpratinidhatva'] = this.gramcountpratinidhatva;
    data['urlCount'] = this.urlCount;
    data['ImgCount'] = this.imgCount;
    data['AdvCount'] = this.advCount;
    data['mukhyaatithifemale'] = this.mukhyaatithifemale;
    data['mukhyaatithimale'] = this.mukhyaatithimale;
    data['sadbavkaryafemale'] = this.sadbavkaryafemale;
    data['sadbavkaryamale'] = this.sadbavkaryamale;
    data['sajjanskhatiuppasstitifemale'] = this.sajjanskhatiuppasstitifemale;
    data['sajjanskhatiuppasstitimale'] = this.sajjanskhatiuppasstitimale;
    data['pramukhjhanuppasstitifemale'] = this.pramukhjhanuppasstitifemale;
    data['pramukhjhanuppasstitimale'] = this.pramukhjhanuppasstitimale;
    if (this.list1 != null) {
      data['List1'] = this.list1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class List1 {
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

  List1({
    this.levelMarathi,
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
    this.ekunfinalcountnames,
  });

  List1.fromJson(Map<String, dynamic> json) {
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
