class AbhiyaanSwayamsevakListResponse {
  List<AbhiyanSwayamsevakList>? abhiyanSwayamsevakList;
  List<AbhiyanSwayamsevakList> abhiyaanSwayamsevakDataList = [];
  String? message;
  String? status;

  AbhiyaanSwayamsevakListResponse({this.abhiyanSwayamsevakList, this.message, this.status});

  AbhiyaanSwayamsevakListResponse.fromJson(Map<String, dynamic> json) {
    if (json['AbhiyanSwayamsevakList'] != null) {
      abhiyanSwayamsevakList = <AbhiyanSwayamsevakList>[];
      json['AbhiyanSwayamsevakList'].forEach((v) {
        abhiyanSwayamsevakList!.add(new AbhiyanSwayamsevakList.fromJson(v));
      });
    }
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.abhiyanSwayamsevakList != null) {
      data['AbhiyanSwayamsevakList'] = this.abhiyanSwayamsevakList!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}

// class AbhiyanSwayamsevakList {
//   int? abhiyaDaayitvaID;
//   int? abhiyanID;
//   int? abhiyanSwayamsevakID;
//   String? daayityaName;
//   String? email;
//   int? levelID;
//   String? levelName;
//   String? participantName;
//   String? participantNumber;
//   String? sansthaName;
//   String? sansthaPadh;
//   String? sansthaType;
//   int? swayamsevakID;
//   int? bhaagId;
//   int? nagarId;
//   int? vastiId;
//   int? gramId;
//   int? mandalId;
//
//   int? mahanagarName;
//   int? vibhagName;
//   int? nagarName;
//   int? vastiName;
//   int? gramName;
//   int? mandalName;
//
//   AbhiyanSwayamsevakList({
//     this.abhiyaDaayitvaID,
//     this.abhiyanID,
//     this.abhiyanSwayamsevakID,
//     this.daayityaName,
//     this.email,
//     this.levelID,
//     this.levelName,
//     this.participantName,
//     this.participantNumber,
//     this.sansthaName,
//     this.sansthaPadh,
//     this.sansthaType,
//     this.swayamsevakID,
//     this.bhaagId,
//     this.nagarId,
//     this.vastiId,
//     this.gramId,
//     this.mandalId,
//     this.mahanagarName,
//     this.vibhagName,
//     this.nagarName,
//     this.vastiName,
//     this.gramName,
//     this.mandalName,
//   });
//
//   AbhiyanSwayamsevakList.fromJson(Map<String, dynamic> json) {
//     abhiyaDaayitvaID = json['AbhiyaDaayitvaID'];
//     abhiyanID = json['AbhiyanID'];
//     abhiyanSwayamsevakID = json['AbhiyanSwayamsevakID'];
//     daayityaName = json['DaayityaName'];
//     email = json['Email'];
//     levelID = json['LevelID'];
//     levelName = json['GeoUnitID'];
//     participantName = json['ParticipantName'];
//     participantNumber = json['ParticipantNumber'];
//     sansthaName = json['SansthaName'];
//     sansthaPadh = json['SansthaPadh'];
//     sansthaType = json['SansthaType'];
//     swayamsevakID = json['SwayamsevakID'];
//     bhaagId = json['bhaag_id'];
//     nagarId = json['nagar_id'];
//     vastiId = json['vasti_id'];
//     gramId = json['gram_id'];
//
//
//     mahanagarName = json['maha'];
//     vibhagName = json['vibha'];
//     mandalId = json['mandal'];
//     nagarName = json['nagar'];
//     vastiName = json['vasti'];
//     gramName = json['gram_id'];
//     mandalName = json['mandal_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['AbhiyaDaayitvaID'] = this.abhiyaDaayitvaID;
//     data['AbhiyanID'] = this.abhiyanID;
//     data['AbhiyanSwayamsevakID'] = this.abhiyanSwayamsevakID;
//     data['DaayityaName'] = this.daayityaName;
//     data['Email'] = this.email;
//     data['LevelID'] = this.levelID;
//     data['GeoUnitID'] = this.levelName;
//     data['ParticipantName'] = this.participantName;
//     data['ParticipantNumber'] = this.participantNumber;
//     data['SansthaName'] = this.sansthaName;
//     data['SansthaPadh'] = this.sansthaPadh;
//     data['SansthaType'] = this.sansthaType;
//     data['SwayamsevakID'] = this.swayamsevakID;
//     data['bhaag_id'] = this.bhaagId;
//     data['nagar_id'] = this.nagarId;
//     data['vasti_id'] = this.vastiId;
//     data['gram_id'] = this.gramId;
//     data['mandal_id'] = this.mandalId;
//     return data;
//   }
// }
class AbhiyanSwayamsevakList {
  int? abhiyaDaayitvaID;
  int? abhiyanID;
  int? abhiyanSwayamsevakID;
  String? appPassword; // Added parameter
  String? daayityaName;
  String? email;
  int? geoUnitID; // Updated parameter name
  int? isActive; // Added parameter
  int? levelID;
  int? mahanagarId; // Added parameter
  int? praantID; // Added parameter
  int? preferredLanguageID; // Added parameter
  String? participantName;
  String? participantNumber;
  String? sansthaName;
  String? sansthaPadh;
  String? sansthaType;
  int? swayamsevakID;
  int? bhaagId;
  String? bhag; // Added parameter
  String? vibha; // Added parameter
  String? maha; // Added parameter
  int? nagarId;
  String? nagar; // Added parameter
  int? vastiId;
  String? vasti; // Added parameter
  int? gramId;
  String? gram; // Added parameter
  int? mandalId;
  String? mandal; // Added parameter
  String? levelName;
  int? parentPraantID;
  int? parentMahaanagarID;
  int? parentVibhaagID;
  int? parentBhaagID;
  int? parentNagarID;
  int? parentShaharID;
  int? parentMandalID;
  int? parentGraamID;
  int? parentVastiID;


  AbhiyanSwayamsevakList({
    this.abhiyaDaayitvaID,
    this.abhiyanID,
    this.abhiyanSwayamsevakID,
    this.appPassword, // Initialized parameter
    this.daayityaName,
    this.email,
    this.geoUnitID, // Initialized parameter
    this.isActive, // Initialized parameter
    this.levelID,
    this.mahanagarId, // Initialized parameter
    this.praantID, // Initialized parameter
    this.preferredLanguageID, // Initialized parameter
    this.participantName,
    this.participantNumber,
    this.sansthaName,
    this.sansthaPadh,
    this.sansthaType,
    this.swayamsevakID,
    this.bhaagId,
    this.bhag, // Initialized parameter
    this.vibha, // Initialized parameter
    this.maha, // Initialized parameter
    this.nagarId,
    this.nagar, // Initialized parameter
    this.vastiId,
    this.vasti, // Initialized parameter
    this.gramId,
    this.gram, // Initialized parameter
    this.mandalId,
    this.mandal, // Initialized parameter
    this.levelName,
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

  AbhiyanSwayamsevakList.fromJson(Map<String, dynamic> json) {
    abhiyaDaayitvaID = json['AbhiyaDaayitvaID'];
    abhiyanID = json['AbhiyanID'];
    abhiyanSwayamsevakID = json['AbhiyanSwayamsevakID'];
    appPassword = json['AppPassword']; // Added parameter
    daayityaName = json['DaayityaName'];
    email = json['Email'];
    levelName = json['GeoUnitID']; // Updated parameter name
    isActive = json['IsActive']; // Added parameter
    levelID = json['LevelID'];
    mahanagarId = json['ParentMahaanagarID']; // Added parameter
    praantID = json['ParentPraantID']; // Added parameter
    preferredLanguageID = json['PreferredLanguageID']; // Added parameter
    participantName = json['ParticipantName'];
    participantNumber = json['ParticipantNumber'];
    sansthaName = json['SansthaName'];
    sansthaPadh = json['SansthaPadh'];
    sansthaType = json['SansthaType'];
    swayamsevakID = json['SwayamsevakID'];
    bhaagId = json['bhaag_id'];
    bhag = json['bhag']; // Added parameter
    vibha = json['vibha']; // Added parameter
    maha = json['maha']; // Added parameter
    nagarId = json['nagar_id'];
    nagar = json['nagar']; // Added parameter
    vastiId = json['vasti_id'];
    vasti = json['vasti']; // Added parameter
    gramId = json['gram_id'];
    gram = json['gram']; // Added parameter
    mandalId = json['mandal_id'];
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
    data['AbhiyaDaayitvaID'] = this.abhiyaDaayitvaID;
    data['AbhiyanID'] = this.abhiyanID;
    data['AbhiyanSwayamsevakID'] = this.abhiyanSwayamsevakID;
    data['AppPassword'] = this.appPassword; // Added parameter
    data['DaayityaName'] = this.daayityaName;
    data['Email'] = this.email;
    data['GeoUnitID'] = this.levelName; // Updated parameter name
    data['IsActive'] = this.isActive; // Added parameter
    data['LevelID'] = this.levelID;
    data['ParentMahaanagarID'] = this.mahanagarId; // Added parameter
    data['ParentPraantID'] = this.praantID; // Added parameter
    data['PreferredLanguageID'] = this.preferredLanguageID; // Added parameter
    data['ParticipantName'] = this.participantName;
    data['ParticipantNumber'] = this.participantNumber;
    data['SansthaName'] = this.sansthaName;
    data['SansthaPadh'] = this.sansthaPadh;
    data['SansthaType'] = this.sansthaType;
    data['SwayamsevakID'] = this.swayamsevakID;
    data['bhaag_id'] = this.bhaagId;
    data['bhag'] = this.bhag; // Added parameter
    data['vibha'] = this.vibha; // Added parameter
    data['maha'] = this.maha; // Added parameter
    data['nagar_id'] = this.nagarId;
    data['nagar'] = this.nagar; // Added parameter
    data['vasti_id'] = this.vastiId;
    data['vasti'] = this.vasti; // Added parameter
    data['gram_id'] = this.gramId;
    data['gram'] = this.gram; // Added parameter
    data['mandal_id'] = this.mandalId;
    data['mandal'] = this.mandal; // Added parameter
    data['mandal_id'] = this.mandalId;
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
