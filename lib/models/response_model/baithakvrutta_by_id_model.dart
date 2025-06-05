class JoinRssDetailByIDModel {
  List<ListJoinRSS>? listJoinRSS;
  String? message;
  String? status;

  JoinRssDetailByIDModel({this.listJoinRSS, this.message, this.status});

  JoinRssDetailByIDModel.fromJson(Map<String, dynamic> json) {
    if (json['ListJoinRSS'] != null) {
      listJoinRSS = <ListJoinRSS>[];
      json['ListJoinRSS'].forEach((v) {
        listJoinRSS!.add(new ListJoinRSS.fromJson(v));
      });
    }
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listJoinRSS != null) {
      data['ListJoinRSS'] = this.listJoinRSS!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}

class ListJoinRSS {
  String? address;
  String? age;
  Null? bhaagID;
  String? bhaagName;
  String? cityName;
  String? country;
  String? districtName;
  String? email;
  String? genderCode;
  int? genderID;
  String? jRSRemark;
  int? joinRSSID;
  String? joiningDate;
  String? joiningDateStr;
  Null? listStatusHistory;
  String? mobileNumber;
  Null? nagarID;
  String? nagarName;
  String? name;
  String? occupation;
  int? praantID;
  String? remark;
  Null? shaharID;
  String? shaharName;
  String? stateName;
  String? statusCode;
  String? statusDate;
  String? statusDateStr;
  int? statusID;
  String? statusRemark;

  ListJoinRSS(
      {this.address,
        this.age,
        this.bhaagID,
        this.bhaagName,
        this.cityName,
        this.country,
        this.districtName,
        this.email,
        this.genderCode,
        this.genderID,
        this.jRSRemark,
        this.joinRSSID,
        this.joiningDate,
        this.joiningDateStr,
        this.listStatusHistory,
        this.mobileNumber,
        this.nagarID,
        this.nagarName,
        this.name,
        this.occupation,
        this.praantID,
        this.remark,
        this.shaharID,
        this.shaharName,
        this.stateName,
        this.statusCode,
        this.statusDate,
        this.statusDateStr,
        this.statusID,
        this.statusRemark});

  ListJoinRSS.fromJson(Map<String, dynamic> json) {
    address = json['Address'];
    age = json['Age'];
    bhaagID = json['BhaagID'];
    bhaagName = json['BhaagName'];
    cityName = json['CityName'];
    country = json['Country'];
    districtName = json['DistrictName'];
    email = json['Email'];
    genderCode = json['GenderCode'];
    genderID = json['GenderID'];
    jRSRemark = json['JRSRemark'];
    joinRSSID = json['JoinRSSID'];
    joiningDate = json['JoiningDate'];
    joiningDateStr = json['JoiningDateStr'];
    listStatusHistory = json['ListStatusHistory'];
    mobileNumber = json['MobileNumber'];
    nagarID = json['NagarID'];
    nagarName = json['NagarName'];
    name = json['Name'];
    occupation = json['Occupation'];
    praantID = json['PraantID'];
    remark = json['Remark'];
    shaharID = json['ShaharID'];
    shaharName = json['ShaharName'];
    stateName = json['StateName'];
    statusCode = json['StatusCode'];
    statusDate = json['StatusDate'];
    statusDateStr = json['StatusDateStr'];
    statusID = json['StatusID'];
    statusRemark = json['StatusRemark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Address'] = this.address;
    data['Age'] = this.age;
    data['BhaagID'] = this.bhaagID;
    data['BhaagName'] = this.bhaagName;
    data['CityName'] = this.cityName;
    data['Country'] = this.country;
    data['DistrictName'] = this.districtName;
    data['Email'] = this.email;
    data['GenderCode'] = this.genderCode;
    data['GenderID'] = this.genderID;
    data['JRSRemark'] = this.jRSRemark;
    data['JoinRSSID'] = this.joinRSSID;
    data['JoiningDate'] = this.joiningDate;
    data['JoiningDateStr'] = this.joiningDateStr;
    data['ListStatusHistory'] = this.listStatusHistory;
    data['MobileNumber'] = this.mobileNumber;
    data['NagarID'] = this.nagarID;
    data['NagarName'] = this.nagarName;
    data['Name'] = this.name;
    data['Occupation'] = this.occupation;
    data['PraantID'] = this.praantID;
    data['Remark'] = this.remark;
    data['ShaharID'] = this.shaharID;
    data['ShaharName'] = this.shaharName;
    data['StateName'] = this.stateName;
    data['StatusCode'] = this.statusCode;
    data['StatusDate'] = this.statusDate;
    data['StatusDateStr'] = this.statusDateStr;
    data['StatusID'] = this.statusID;
    data['StatusRemark'] = this.statusRemark;
    return data;
  }
}
