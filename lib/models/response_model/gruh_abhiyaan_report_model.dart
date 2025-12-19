class GruhAbhiyaanReportModel {
  String? message;
  String? status;
  List<Table1List>? table1List;
  List<Table1List>? table2List;
  List<Table3List>? table3List;
  List<Table4List>? table4List;
  List<Table5List>? table5List;

  GruhAbhiyaanReportModel({this.message, this.status, this.table1List, this.table2List, this.table3List, this.table4List, this.table5List});

  GruhAbhiyaanReportModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['table1List'] != null) {
      table1List = <Table1List>[];
      json['table1List'].forEach((v) {
        table1List!.add(new Table1List.fromJson(v));
      });
    }
    if (json['table2List'] != null) {
      table2List = <Table1List>[];
      json['table2List'].forEach((v) {
        table2List!.add(new Table1List.fromJson(v));
      });
    }
    if (json['table3List'] != null) {
      table3List = <Table3List>[];
      json['table3List'].forEach((v) {
        table3List!.add(new Table3List.fromJson(v));
      });
    }
    if (json['table4List'] != null) {
      table4List = <Table4List>[];
      json['table4List'].forEach((v) {
        table4List!.add(new Table4List.fromJson(v));
      });
    }
    if (json['table5List'] != null) {
      table5List = <Table5List>[];
      json['table5List'].forEach((v) {
        table5List!.add(new Table5List.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.table1List != null) {
      data['table1List'] = this.table1List!.map((v) => v.toJson()).toList();
    }
    if (this.table2List != null) {
      data['table2List'] = this.table2List!.map((v) => v.toJson()).toList();
    }
    if (this.table3List != null) {
      data['table3List'] = this.table3List!.map((v) => v.toJson()).toList();
    }
    if (this.table4List != null) {
      data['table4List'] = this.table4List!.map((v) => v.toJson()).toList();
    }
    if (this.table5List != null) {
      data['table5List'] = this.table5List!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Table1List {
  String? abhiyaanDate;
  String? levelName;
  int? levelid;
  int? totalAtithiCount;
  int? attcount;
  int? samparkhetusahbhagisankhya;
  int? samparkhetutolisankhya;
  int? pustakvikrisankhya;
  int? samparkitghar;
  int? vitaritkarpatra;
  int? ekunswayamsevak;
  int? ekunsamparkhetukaryakarta;
  int? femalecount;
  int? malecount;

  Table1List({
    this.abhiyaanDate,
    this.levelName,
    this.levelid,
    this.totalAtithiCount,
    this.attcount,
    this.samparkhetusahbhagisankhya,
    this.samparkhetutolisankhya,
    this.pustakvikrisankhya,
    this.samparkitghar,
    this.vitaritkarpatra,
    this.ekunswayamsevak,
    this.ekunsamparkhetukaryakarta,
    this.femalecount,
    this.malecount,
  });

  Table1List.fromJson(Map<String, dynamic> json) {
    abhiyaanDate = json['AbhiyaanDate'];
    levelName = json['LevelName'];
    levelid = json['Levelid'];
    totalAtithiCount = json['TotalAtithiCount'];
    attcount = json['attcount'];
    samparkhetusahbhagisankhya = json['samparkhetusahbhagisankhya'];
    samparkhetutolisankhya = json['samparkhetutolisankhya'];
    pustakvikrisankhya = json['pustakvikrisankhya'];
    samparkitghar = json['samparkitghar'];
    vitaritkarpatra = json['vitaritkarpatra'];
    ekunswayamsevak = json['ekunswayamsevak'];
    ekunsamparkhetukaryakarta = json['ekunsamparkhetukaryakarta'];
    femalecount = json['femalecount'];
    malecount = json['malecount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbhiyaanDate'] = this.abhiyaanDate;
    data['LevelName'] = this.levelName;
    data['Levelid'] = this.levelid;
    data['TotalAtithiCount'] = this.totalAtithiCount;
    data['attcount'] = this.attcount;
    data['samparkhetusahbhagisankhya'] = this.samparkhetusahbhagisankhya;
    data['samparkhetutolisankhya'] = this.samparkhetutolisankhya;
    data['pustakvikrisankhya'] = this.pustakvikrisankhya;
    data['samparkitghar'] = this.samparkitghar;
    data['vitaritkarpatra'] = this.vitaritkarpatra;
    data['ekunswayamsevak'] = this.ekunswayamsevak;
    data['ekunsamparkhetukaryakarta'] = this.ekunsamparkhetukaryakarta;
    data['femalecount'] = this.femalecount;
    data['malecount'] = this.malecount;
    return data;
  }
}

class Table3List {
  int? startedcount;
  int? startednagarcount;
  int? startedmandalcount;
  String? typeName;
  String? vastiname;
  int? gramcount;
  String? gramname;
  int? mandalcount;
  int? nagarcount;
  int? vasticount;

  Table3List({this.startedcount, this.startednagarcount, this.startedmandalcount, this.typeName, this.vastiname, this.gramcount, this.gramname, this.mandalcount, this.nagarcount, this.vasticount});

  Table3List.fromJson(Map<String, dynamic> json) {
    startedcount = json['Startedcount'];
    startednagarcount = json['StartedNagarCount'];
    startedmandalcount = json['StartedMandalCount'];
    typeName = json['TypeName'];
    vastiname = json['Vastiname'];
    gramcount = json['gramcount'];
    gramname = json['gramname'];
    mandalcount = json['mandalcount'];
    nagarcount = json['nagarcount'];
    vasticount = json['vasticount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Startedcount'] = this.startedcount;
    data['StartedNagarCount'] = this.startednagarcount;
    data['StartedMandalCount'] = this.startedmandalcount;
    data['TypeName'] = this.typeName;
    data['Vastiname'] = this.vastiname;
    data['gramcount'] = this.gramcount;
    data['gramname'] = this.gramname;
    data['mandalcount'] = this.mandalcount;
    data['nagarcount'] = this.nagarcount;
    data['vasticount'] = this.vasticount;
    return data;
  }
}

class Table4List {
  int? order;
  String? type;
  int? totalcount;
  int? startedcount;
  String? namelist;

  Table4List({this.order, this.type, this.totalcount, this.startedcount, this.namelist});

  Table4List.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    type = json['type'];
    totalcount = json['totalcount'];
    startedcount = json['startedcount'];
    namelist = json['namelist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = this.order;
    data['type'] = this.type;
    data['totalcount'] = this.totalcount;
    data['startedcount'] = this.startedcount;
    data['namelist'] = this.namelist;
    return data;
  }
}

class Table5List {
  int? cnt;
  String? shreneename;
  String? typename;

  Table5List({this.cnt, this.shreneename, this.typename});

  Table5List.fromJson(Map<String, dynamic> json) {
    cnt = json['cnt'];
    shreneename = json['shreneename'];
    typename = json['typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cnt'] = this.cnt;
    data['shreneename'] = this.shreneename;
    data['typename'] = this.typename;
    return data;
  }
}
