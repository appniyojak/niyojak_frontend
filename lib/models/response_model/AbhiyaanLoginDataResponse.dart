class AbhiyanSwayamsevakResponse {
  List<AbhiyanSwayamsevakdata>? abhiyanSwayamsevakData;

  AbhiyanSwayamsevakResponse({this.abhiyanSwayamsevakData});

  AbhiyanSwayamsevakResponse.fromJson(Map<String, dynamic> json) {
    if (json['AbhiyanSwayamsevakData'] != null) {
      abhiyanSwayamsevakData = <AbhiyanSwayamsevakdata>[];
      json['AbhiyanSwayamsevakData'].forEach((v) {
        abhiyanSwayamsevakData!.add(new AbhiyanSwayamsevakdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.abhiyanSwayamsevakData != null) {
      data['AbhiyanSwayamsevakData'] = this.abhiyanSwayamsevakData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AbhiyanSwayamsevakdata {
  int? abhiyaDaayitvaID;
  int? abhiyanSwayamsevakID;
  String? daayityaName;
  String? email;
  String? fullName;
  int? geoUnitID;
  String? geoUnitName;
  String? levelName;
  String? mobileNumber;
  int? parentVibhaagID;
  int? parentMahaanagarID;
  int? parentBhaagID;
  int? parentMandalID;
  int? parentNagarID;
  String? preferredLanguageCode;
  int? preferredLanguageID;

  AbhiyanSwayamsevakdata(
      {this.abhiyaDaayitvaID,
      this.abhiyanSwayamsevakID,
      this.daayityaName,
      this.email,
      this.fullName,
      this.geoUnitID,
      this.geoUnitName,
      this.levelName,
      this.mobileNumber,
      this.parentVibhaagID,
      this.parentMahaanagarID,
      this.parentBhaagID,
      this.parentMandalID,
      this.parentNagarID,
      this.preferredLanguageCode,
      this.preferredLanguageID});

  AbhiyanSwayamsevakdata.fromJson(Map<String, dynamic> json) {
    abhiyaDaayitvaID = json['AbhiyaDaayitvaID'];
    abhiyanSwayamsevakID = json['AbhiyanSwayamsevakID'];
    daayityaName = json['DaayityaName'];
    email = json['Email'];
    fullName = json['FullName'];
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    levelName = json['LevelName'];
    mobileNumber = json['MobileNumber'];
    parentVibhaagID = json['ParentVibhaagID'];
    parentMahaanagarID = json['ParentMahaanagarID'];
    parentBhaagID = json['ParentBhaagID'];
    parentMandalID = json['ParentMandalID'];
    parentNagarID = json['ParentNagarID'];
    preferredLanguageCode = json['PreferredLanguageCode'];
    preferredLanguageID = json['PreferredLanguageID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbhiyaDaayitvaID'] = this.abhiyaDaayitvaID;
    data['AbhiyanSwayamsevakID'] = this.abhiyanSwayamsevakID;
    data['DaayityaName'] = this.daayityaName;
    data['Email'] = this.email;
    data['FullName'] = this.fullName;
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['LevelName'] = this.levelName;
    data['MobileNumber'] = this.mobileNumber;
    data['ParentVibhaagID'] = this.parentVibhaagID;
    data['ParentMahaanagarID'] = this.parentMahaanagarID;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ParentMandalID'] = this.parentMandalID;
    data['ParentNagarID'] = this.parentNagarID;
    data['PreferredLanguageCode'] = this.preferredLanguageCode;
    data['PreferredLanguageID'] = this.preferredLanguageID;
    return data;
  }
}
