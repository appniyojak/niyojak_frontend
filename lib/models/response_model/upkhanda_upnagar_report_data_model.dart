class UpnagarUpkhandaReportModel {
  String? message;
  String? status;
  List<UpkhandaDataList>? dataList;
  List<UpkhandaExcelDataList>? datanameList;

  UpnagarUpkhandaReportModel({this.message, this.status, this.dataList, this.datanameList});

  UpnagarUpkhandaReportModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['dataList'] != null) {
      dataList = <UpkhandaDataList>[];
      json['dataList'].forEach((v) {
        dataList!.add(new UpkhandaDataList.fromJson(v));
      });
    }
    if (json['dataname'] != null) {
      datanameList = <UpkhandaExcelDataList>[];
      json['dataname'].forEach((v) {
        datanameList!.add(new UpkhandaExcelDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.dataList != null) {
      data['dataList'] = this.dataList!.map((v) => v.toJson()).toList();
    }
    if (this.datanameList != null) {
      data['dataname'] = this.datanameList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpkhandaDataList {
  String? goUnitName;
  int? nagarCount;
  int? upKhandCount;
  int? upNagarCount;
  int? gramCount;
  int? vastiCount;
  int? mapUpKhandCount;
  int? mapUpNagarCount;

  UpkhandaDataList({
    this.goUnitName,
    this.nagarCount,
    this.upKhandCount,
    this.upNagarCount,
    this.gramCount,
    this.vastiCount,
    this.mapUpKhandCount,
    this.mapUpNagarCount,
  });

  UpkhandaDataList.fromJson(Map<String, dynamic> json) {
    goUnitName = json['GoUnitName'];
    nagarCount = json['NagarCount'];
    upKhandCount = json['UpKhandCount'];
    upNagarCount = json['UpNagarCount'];
    gramCount = json['gramCount'];
    vastiCount = json['vastiCount'];
    mapUpKhandCount = json['mapUpKhandCount'];
    mapUpNagarCount = json['mapUpNagarCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GoUnitName'] = this.goUnitName;
    data['NagarCount'] = this.nagarCount;
    data['UpKhandCount'] = this.upKhandCount;
    data['UpNagarCount'] = this.upNagarCount;
    data['gramCount'] = this.gramCount;
    data['vastiCount'] = this.vastiCount;
    data['mapUpKhandCount'] = this.mapUpKhandCount;
    data['mapUpNagarCount'] = this.mapUpNagarCount;
    return data;
  }
}

class UpkhandaExcelDataList {
  String? goUnitName;
  String? nagarNames;
  String? upKhandNames;
  String? upNagarNames;
  String? vastiNames;
  String? gramNames;
  String? mapUpNagarNames;
  String? mapUpKhandNames;

  UpkhandaExcelDataList({this.goUnitName, this.nagarNames, this.upKhandNames, this.upNagarNames, this.vastiNames, this.gramNames, this.mapUpNagarNames, this.mapUpKhandNames});

  UpkhandaExcelDataList.fromJson(Map<String, dynamic> json) {
    goUnitName = json['GoUnitName'];
    nagarNames = json['NagarNames'];
    upKhandNames = json['UpKhandNames'];
    upNagarNames = json['UpNagarNames'];
    vastiNames = json['VastiNames'];
    gramNames = json['GramNames'];
    mapUpNagarNames = json['MapUpNagarNames'];
    mapUpKhandNames = json['MapUpKhandNames'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GoUnitName'] = this.goUnitName;
    data['NagarNames'] = this.nagarNames;
    data['UpKhandNames'] = this.upKhandNames;
    data['UpNagarNames'] = this.upNagarNames;
    data['VastiNames'] = this.vastiNames;
    data['GramNames'] = this.gramNames;
    data['MapUpNagarNames'] = this.mapUpNagarNames;
    data['MapUpKhandNames'] = this.mapUpKhandNames;
    return data;
  }
}
