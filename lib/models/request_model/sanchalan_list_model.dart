class SanchalanDataListModel {
  List<SanchalanDataList>? sanchalanDataList;

  SanchalanDataListModel({this.sanchalanDataList});

  SanchalanDataListModel.fromJson(Map<String, dynamic> json) {
    if (json['sanchalanDataList'] != null) {
      sanchalanDataList = <SanchalanDataList>[];
      json['sanchalanDataList'].forEach((v) {
        sanchalanDataList!.add(new SanchalanDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sanchalanDataList != null) {
      data['sanchalanDataList'] =
          this.sanchalanDataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SanchalanDataList {
  String? selectedSanchalanVastiName;
  int? selectedSanchalanVastiId;
  int? sanchalanSadandaYesNo;
  int? sanchalanGhoshVadanYesNo;

  SanchalanDataList(
      {this.selectedSanchalanVastiName,
      this.selectedSanchalanVastiId,
      this.sanchalanSadandaYesNo,
      this.sanchalanGhoshVadanYesNo});

  SanchalanDataList.fromJson(Map<String, dynamic> json) {
    selectedSanchalanVastiName = json['selectedSanchalanVastiName'];
    selectedSanchalanVastiId = json['selectedSanchalanVastiId'];
    sanchalanSadandaYesNo = json['sanchalanSadandaYesNo'];
    sanchalanGhoshVadanYesNo = json['sanchalanGhoshVadanYesNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectedSanchalanVastiName'] = this.selectedSanchalanVastiName;
    data['selectedSanchalanVastiId'] = this.selectedSanchalanVastiId;
    data['sanchalanSadandaYesNo'] = this.sanchalanSadandaYesNo;
    data['sanchalanGhoshVadanYesNo'] = this.sanchalanGhoshVadanYesNo;
    return data;
  }
}
