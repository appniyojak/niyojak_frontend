class AbhiyaanListResponse {
  List<AbhiyaanList>? abhiyaanList;
  String? message;
  String? status;

  AbhiyaanListResponse({this.abhiyaanList, this.message, this.status});

  AbhiyaanListResponse.fromJson(Map<String, dynamic> json) {
    if (json['AbhiyaanList'] != null) {
      abhiyaanList = <AbhiyaanList>[];
      json['AbhiyaanList'].forEach((v) {
        abhiyaanList!.add(new AbhiyaanList.fromJson(v));
      });
    }
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.abhiyaanList != null) {
      data['AbhiyaanList'] = this.abhiyaanList!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}

class AbhiyaanList {
  int? abhiyaanID;
  String? abhiyaanName;
  int? praantID;
  String? remark;

  AbhiyaanList({this.abhiyaanID, this.abhiyaanName, this.praantID, this.remark});

  AbhiyaanList.fromJson(Map<String, dynamic> json) {
    abhiyaanID = json['AbhiyaanID'];
    abhiyaanName = json['AbhiyaanName'];
    praantID = json['PraantID'];
    remark = json['Remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbhiyaanID'] = this.abhiyaanID;
    data['AbhiyaanName'] = this.abhiyaanName;
    data['PraantID'] = this.praantID;
    data['Remark'] = this.remark;
    return data;
  }
}
