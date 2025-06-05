class VisheshVyaktiListResponse {
  List<GruhasamparkVisheshVyaktiData>? gruhasamparkVisheshVyaktiData;
  String? message;
  String? status;

  VisheshVyaktiListResponse({this.gruhasamparkVisheshVyaktiData, this.message, this.status});

  VisheshVyaktiListResponse.fromJson(Map<String, dynamic> json) {
    if (json['GruhasamparkVisheshVyaktiData'] != null) {
      gruhasamparkVisheshVyaktiData = <GruhasamparkVisheshVyaktiData>[];
      json['GruhasamparkVisheshVyaktiData'].forEach((v) {
        gruhasamparkVisheshVyaktiData!.add(new GruhasamparkVisheshVyaktiData.fromJson(v));
      });
    }
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gruhasamparkVisheshVyaktiData != null) {
      data['GruhasamparkVisheshVyaktiData'] = this.gruhasamparkVisheshVyaktiData!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}

class GruhasamparkVisheshVyaktiData {
  String? anyaVishesh;
  String? address;
  int? gruhasamparkID;
  int? gruhasamparkVisheshID;
  String? mobileNumber;
  String? sansthaName;
  String? sansthaPadh;
  String? sansthaType;
  String? visheshNote;
  String? visheshVyaktiName;
  int? parentPraantID;
  int? parentMahaanagarID;
  int? parentVibhaagID;
  int? parentBhaagID;
  int? parentNagarID;
  int? parentShaharID;
  int? parentMandalID;
  int? parentGraamID;
  int? parentVastiID;

  GruhasamparkVisheshVyaktiData(
      {this.anyaVishesh,
      this.address,
      this.gruhasamparkID,
      this.gruhasamparkVisheshID,
      this.mobileNumber,
      this.sansthaName,
      this.sansthaPadh,
      this.sansthaType,
      this.visheshNote,
      this.visheshVyaktiName,
      this.parentMahaanagarID,
        this.parentBhaagID,
        this.parentGraamID,
        this.parentMandalID,
        this.parentNagarID,
        this.parentPraantID,
        this.parentShaharID,
        this.parentVastiID,
        this.parentVibhaagID,
      });

  GruhasamparkVisheshVyaktiData.fromJson(Map<String, dynamic> json) {
    anyaVishesh = json['AnyaVishesh'];
    address = json['Email'];
    gruhasamparkID = json['GruhasamparkID'];
    gruhasamparkVisheshID = json['GruhasamparkVisheshID'];
    mobileNumber = json['MobileNumber'];
    sansthaName = json['SansthaName'];
    sansthaPadh = json['SansthaPadh'];
    sansthaType = json['SansthaType'];
    visheshNote = json['VisheshNote'];
    visheshVyaktiName = json['VisheshVyaktiName'];
    parentPraantID = json['ParentPraantID'];
    parentMahaanagarID = json['ParentMahaanagarID'];
    parentVibhaagID = json['ParentVibhaagID'];
    parentBhaagID = json['ParentBhaagID'];
    parentNagarID = json['ParentNagarID'];
    parentShaharID = json['ParentShaharID'];
    parentMandalID = json['ParentMandalID'];
    parentGraamID = json['ParentGraamID'];
    parentVastiID = json['ParentVastiID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AnyaVishesh'] = this.anyaVishesh;
    data['Email'] = this.address;
    data['GruhasamparkID'] = this.gruhasamparkID;
    data['GruhasamparkVisheshID'] = this.gruhasamparkVisheshID;
    data['MobileNumber'] = this.mobileNumber;
    data['SansthaName'] = this.sansthaName;
    data['SansthaPadh'] = this.sansthaPadh;
    data['SansthaType'] = this.sansthaType;
    data['VisheshNote'] = this.visheshNote;
    data['VisheshVyaktiName'] = this.visheshVyaktiName;
    data['ParentPraantID'] = this.parentPraantID;
    data['ParentMahaanagarID'] =this.parentMahaanagarID;
    data['ParentVibhaagID'] = this.parentVibhaagID;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ParentNagarID'] =  this.parentNagarID;
    data['ParentShaharID'] =  this.parentShaharID;
    data['ParentMandalID'] =  this.parentMandalID;
    data['ParentGraamID'] = this.parentGraamID;
    data['ParentVastiID'] = this.parentVastiID;
    return data;
  }
}
