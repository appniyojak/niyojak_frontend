class GetSankalpRequestModel {
  int? appUserID;
  int? geoUnitID;
  int? sankalpYear;
  int? kaaryaSthitiMonth;

  GetSankalpRequestModel({this.appUserID, this.geoUnitID, this.sankalpYear, this.kaaryaSthitiMonth});

  GetSankalpRequestModel.fromJson(Map<String, dynamic> json) {
    appUserID = json['AppUserID'];
    geoUnitID = json['GeoUnitID'];
    sankalpYear = json['SankalpYear'];
    kaaryaSthitiMonth = json['KaaryaSthitiMonth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AppUserID'] = this.appUserID;
    data['GeoUnitID'] = this.geoUnitID;
    data['SankalpYear'] = this.sankalpYear;
    data['KaaryaSthitiMonth'] = this.kaaryaSthitiMonth;
    return data;
  }
}
