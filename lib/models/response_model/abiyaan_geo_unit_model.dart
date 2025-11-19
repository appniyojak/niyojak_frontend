import '../../providers/bals.dart';

class AbhiyaanGeoUnitListModel {
  List<GeoUnitMasterBAL>? geoUnitListforAbhiyaan;

  AbhiyaanGeoUnitListModel({this.geoUnitListforAbhiyaan});

  AbhiyaanGeoUnitListModel.fromJson(Map<String, dynamic> json) {
    if (json['GeoUnitListforAbhiyaan'] != null) {
      geoUnitListforAbhiyaan = <GeoUnitMasterBAL>[];
      json['GeoUnitListforAbhiyaan'].forEach((v) {
        geoUnitListforAbhiyaan!.add(new GeoUnitMasterBAL.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geoUnitListforAbhiyaan != null) {
      data['GeoUnitListforAbhiyaan'] = this.geoUnitListforAbhiyaan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class GeoUnitListforAbhiyaan {
//   int? displaySequence;
//   int? geoUnitID;
//   String? geoUnitName;
//   bool? hasGraaminKshetra;
//   int? levelID;
//   String? levelName;
//   int? parentBhaagID;
//   int? parentGraamID;
//   int? parentKshetraID;
//   int? parentMahaanagarID;
//   int? parentMandalID;
//   int? parentNagarID;
//   int? parentPraantID;
//   int? parentShaharID;
//   int? parentVastiID;
//   int? parentVibhaagID;
//   int? praantID;
//   bool? canEdit;
//
//   GeoUnitListforAbhiyaan(
//       {this.displaySequence,
//       this.geoUnitID,
//       this.geoUnitName,
//       this.hasGraaminKshetra,
//       this.levelID,
//       this.levelName,
//       this.parentBhaagID,
//       this.parentGraamID,
//       this.parentKshetraID,
//       this.parentMahaanagarID,
//       this.parentMandalID,
//       this.parentNagarID,
//       this.parentPraantID,
//       this.parentShaharID,
//       this.parentVastiID,
//       this.parentVibhaagID,
//       this.praantID,
//       this.canEdit});
//
//   GeoUnitListforAbhiyaan.fromJson(Map<String, dynamic> json) {
//     displaySequence = json['DisplaySequence'];
//     geoUnitID = json['GeoUnitID'];
//     geoUnitName = json['GeoUnitName'];
//     hasGraaminKshetra = json['HasGraaminKshetra'];
//     levelID = json['LevelID'];
//     levelName = json['LevelName'];
//     parentBhaagID = json['ParentBhaagID'];
//     parentGraamID = json['ParentGraamID'];
//     parentKshetraID = json['ParentKshetraID'];
//     parentMahaanagarID = json['ParentMahaanagarID'];
//     parentMandalID = json['ParentMandalID'];
//     parentNagarID = json['ParentNagarID'];
//     parentPraantID = json['ParentPraantID'];
//     parentShaharID = json['ParentShaharID'];
//     parentVastiID = json['ParentVastiID'];
//     parentVibhaagID = json['ParentVibhaagID'];
//     praantID = json['PraantID'];
//     canEdit = json['canEdit'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['DisplaySequence'] = this.displaySequence;
//     data['GeoUnitID'] = this.geoUnitID;
//     data['GeoUnitName'] = this.geoUnitName;
//     data['HasGraaminKshetra'] = this.hasGraaminKshetra;
//     data['LevelID'] = this.levelID;
//     data['LevelName'] = this.levelName;
//     data['ParentBhaagID'] = this.parentBhaagID;
//     data['ParentGraamID'] = this.parentGraamID;
//     data['ParentKshetraID'] = this.parentKshetraID;
//     data['ParentMahaanagarID'] = this.parentMahaanagarID;
//     data['ParentMandalID'] = this.parentMandalID;
//     data['ParentNagarID'] = this.parentNagarID;
//     data['ParentPraantID'] = this.parentPraantID;
//     data['ParentShaharID'] = this.parentShaharID;
//     data['ParentVastiID'] = this.parentVastiID;
//     data['ParentVibhaagID'] = this.parentVibhaagID;
//     data['PraantID'] = this.praantID;
//     data['canEdit'] = this.canEdit;
//     return data;
//   }
// }
