class UpnagarUpkhandaReportModel {
  String? message;
  String? status;
  List<UpkhandaDataList>? dataList;

  UpnagarUpkhandaReportModel({this.message, this.status, this.dataList});

  UpnagarUpkhandaReportModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['dataList'] != null) {
      dataList = <UpkhandaDataList>[];
      json['dataList'].forEach((v) {
        dataList!.add(new UpkhandaDataList.fromJson(v));
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
    return data;
  }
}

class UpkhandaDataList {
  String? goUnitName;
  int? nagarCount;
  int? upKhandCount;
  int? upNagarCount;

  UpkhandaDataList({this.goUnitName, this.nagarCount, this.upKhandCount, this.upNagarCount});

  UpkhandaDataList.fromJson(Map<String, dynamic> json) {
    goUnitName = json['GoUnitName'];
    nagarCount = json['NagarCount'];
    upKhandCount = json['UpKhandCount'];
    upNagarCount = json['UpNagarCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GoUnitName'] = this.goUnitName;
    data['NagarCount'] = this.nagarCount;
    data['UpKhandCount'] = this.upKhandCount;
    data['UpNagarCount'] = this.upNagarCount;
    return data;
  }
}
