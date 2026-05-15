class DropDownModel {
  int? levelID;
  int? geoUnitID;
  int? parentMahaanagarID;
  int? parentVibhaagID;
  int? parentBhaagID;
  int? parentNagarID;
  int? parentUpaNagarID;
  int? parentMandalID;
  int? parentGraamID;
  int? parentVastiID;
  int? isvasti;
  int? ismandal;

  DropDownModel(
      {this.levelID,
      this.geoUnitID,
      this.parentMahaanagarID,
      this.parentVibhaagID,
      this.parentBhaagID,
      this.parentNagarID,
      this.parentUpaNagarID,
      this.parentMandalID,
      this.parentGraamID,
      this.parentVastiID,
      this.isvasti,
      this.ismandal});

  DropDownModel.fromJson(Map<String, dynamic> json) {
    levelID = json['LevelID'];
    geoUnitID = json['GeoUnitID'];
    parentMahaanagarID = json['ParentMahaanagarID'];
    parentVibhaagID = json['ParentVibhaagID'];
    parentBhaagID = json['ParentBhaagID'];
    parentNagarID = json['ParentNagarID'];
    parentUpaNagarID = json['ParentUpaNagarID'];
    parentMandalID = json['ParentMandalID'];
    parentGraamID = json['ParentGraamID'];
    parentVastiID = json['ParentVastiID'];
    isvasti = json['isvasti'];
    ismandal = json['ismandal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LevelID'] = this.levelID;
    data['GeoUnitID'] = this.geoUnitID;
    data['ParentMahaanagarID'] = this.parentMahaanagarID;
    data['ParentVibhaagID'] = this.parentVibhaagID;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ParentNagarID'] = this.parentNagarID;
    data['ParentUpaNagarID'] = this.parentUpaNagarID;
    data['ParentMandalID'] = this.parentMandalID;
    data['ParentGraamID'] = this.parentGraamID;
    data['ParentVastiID'] = this.parentVastiID;
    data['isvasti'] = this.isvasti;
    data['ismandal'] = this.ismandal;
    return data;
  }
}

class GeoSelection {
  String? mahaanagar;
  String? vibhaag;
  String? bhaag;
  String? nagar;
  String? upnagar;
  String? mandal;
  String? graam;
  String? vasti;

  GeoSelection({
    this.mahaanagar,
    this.vibhaag,
    this.bhaag,
    this.nagar,
    this.upnagar,
    this.mandal,
    this.graam,
    this.vasti,
  });
}
