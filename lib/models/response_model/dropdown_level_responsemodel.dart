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
      this.parentVastiID});

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
    return data;
  }
}
