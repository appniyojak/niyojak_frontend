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
  String? geoUnitId;
  String? goUnitName;
  int? nagarCount;
  int? upKhandCount;
  int? upNagarCount;
  int? gramCount;
  int? vastiCount;
  int? mapUpKhandCount;
  int? mapUpNagarCount;

  UpkhandaDataList({
    this.geoUnitId,
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
    geoUnitId = json['GeoUnitID'].toString();
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
    data['GeoUnitID'] = this.geoUnitId;
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
  String? vastiNames;
  String? gramNames;
  String? upNagarNames;
  String? mapUpNagarNames;
  String? upKhandNames;
  String? mapUpKhandNames;

  UpkhandaExcelDataList({this.goUnitName, this.nagarNames, this.vastiNames, this.gramNames, this.upNagarNames, this.mapUpNagarNames, this.upKhandNames, this.mapUpKhandNames});

  UpkhandaExcelDataList.fromJson(Map<String, dynamic> json) {
    goUnitName = json['GoUnitName'];
    nagarNames = json['NagarNames'];
    vastiNames = json['VastiNames'];
    gramNames = json['GramNames'];
    upNagarNames = json['UpNagarNames'];
    mapUpNagarNames = json['MapUpNagarNames'];
    upKhandNames = json['UpKhandNames'];
    mapUpKhandNames = json['MapUpKhandNames'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GoUnitName'] = this.goUnitName;
    data['NagarNames'] = this.nagarNames;
    data['VastiNames'] = this.vastiNames;
    data['GramNames'] = this.gramNames;
    data['UpNagarNames'] = this.upNagarNames;
    data['MapUpNagarNames'] = this.mapUpNagarNames;
    data['UpKhandNames'] = this.upKhandNames;
    data['MapUpKhandNames'] = this.mapUpKhandNames;
    return data;
  }
}
