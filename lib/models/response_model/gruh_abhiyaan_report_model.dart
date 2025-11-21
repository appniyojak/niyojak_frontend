class GruhAbhiyaanReportModel {
  String? message;
  String? status;
  List<Table1List>? table1List;
  List<Table1List>? table2List;
  List<Table3List>? table3List;

  GruhAbhiyaanReportModel({this.message, this.status, this.table1List, this.table2List, this.table3List});

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
    return data;
  }
}

class Table1List {
  String? abhiyaanDate;
  String? levelName;
  int? levelid;
  int? totalAtithiCount;
  int? attcount;
  int? pustakvikrisankhya;
  int? samparkitghar;
  int? vitaritkarpatra;

  Table1List({this.abhiyaanDate, this.levelName, this.levelid, this.totalAtithiCount, this.attcount, this.pustakvikrisankhya, this.samparkitghar, this.vitaritkarpatra});

  Table1List.fromJson(Map<String, dynamic> json) {
    abhiyaanDate = json['AbhiyaanDate'];
    levelName = json['LevelName'];
    levelid = json['Levelid'];
    totalAtithiCount = json['TotalAtithiCount'];
    attcount = json['attcount'];
    pustakvikrisankhya = json['pustakvikrisankhya'];
    samparkitghar = json['samparkitghar'];
    vitaritkarpatra = json['vitaritkarpatra'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbhiyaanDate'] = this.abhiyaanDate;
    data['LevelName'] = this.levelName;
    data['Levelid'] = this.levelid;
    data['TotalAtithiCount'] = this.totalAtithiCount;
    data['attcount'] = this.attcount;
    data['pustakvikrisankhya'] = this.pustakvikrisankhya;
    data['samparkitghar'] = this.samparkitghar;
    data['vitaritkarpatra'] = this.vitaritkarpatra;
    return data;
  }
}

class Table3List {
  int? startedcount;
  String? typeName;
  String? vastiname;
  int? gramcount;
  String? gramname;
  int? mandalcount;
  int? nagarcount;
  int? vasticount;

  Table3List({this.startedcount, this.typeName, this.vastiname, this.gramcount, this.gramname, this.mandalcount, this.nagarcount, this.vasticount});

  Table3List.fromJson(Map<String, dynamic> json) {
    startedcount = json['Startedcount'];
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
