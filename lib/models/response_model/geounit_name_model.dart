class GetgeounitNameModel {
  int? geoUnitID;
  String? geoUnitName;
  String? geoUnitNameHindi;
  String? geoUnitNameMarathi;
  String? message;
  String? status;

  GetgeounitNameModel(
      {this.geoUnitID,
        this.geoUnitName,
        this.geoUnitNameHindi,
        this.geoUnitNameMarathi,
        this.message,
        this.status});

  GetgeounitNameModel.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    geoUnitNameHindi = json['GeoUnitNameHindi'];
    geoUnitNameMarathi = json['GeoUnitNameMarathi'];
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['GeoUnitNameHindi'] = this.geoUnitNameHindi;
    data['GeoUnitNameMarathi'] = this.geoUnitNameMarathi;
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}
