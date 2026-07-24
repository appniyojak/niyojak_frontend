class SearchSwyamsevakNewModel {
  String? status;
  String? message;
  List<SwayamsevakNewData>? data;

  SearchSwyamsevakNewModel({this.status, this.message, this.data});

  SearchSwyamsevakNewModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <SwayamsevakNewData>[];
      json['data'].forEach((v) {
        data!.add(new SwayamsevakNewData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SwayamsevakNewData {
  int? swayamSevakID;
  int? levelID;
  int? isanya;
  String? fullName;
  String? mobileNumber;
  String? daayitvaName;
  String? levelName;

  SwayamsevakNewData({this.swayamSevakID, this.levelID, this.isanya, this.fullName, this.mobileNumber, this.daayitvaName, this.levelName});

  SwayamsevakNewData.fromJson(Map<String, dynamic> json) {
    swayamSevakID = json['swayamSevakID'];
    levelID = json['levelID'];
    isanya = json['isanya'];
    fullName = json['fullName'];
    mobileNumber = json['mobileNumber'];
    daayitvaName = json['daayitvaName'];
    levelName = json['levelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SwayamsevakID'] = this.swayamSevakID;
    data['levelID'] = this.levelID;
    data['IsAnya'] = this.isanya;
    data['fullName'] = this.fullName;
    data['mobileNumber'] = this.mobileNumber;
    data['daayitvaName'] = this.daayitvaName;
    data['levelName'] = this.levelName;
    return data;
  }
}
