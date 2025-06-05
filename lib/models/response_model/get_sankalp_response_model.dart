class GetSankalpResponseModel {
  KaaryaSthitiInfo? kaaryaSthitiInfo;
  String? message;
  SankalpInfo? sankalpInfo;
  String? status;

  GetSankalpResponseModel({this.kaaryaSthitiInfo, this.message, this.sankalpInfo, this.status});

  GetSankalpResponseModel.fromJson(Map<String, dynamic> json) {
    kaaryaSthitiInfo = json['KaaryaSthitiInfo'] != null ? new KaaryaSthitiInfo.fromJson(json['KaaryaSthitiInfo']) : null;
    message = json['Message'];
    sankalpInfo = json['SankalpInfo'] != null ? new SankalpInfo.fromJson(json['SankalpInfo']) : null;
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.kaaryaSthitiInfo != null) {
      data['KaaryaSthitiInfo'] = this.kaaryaSthitiInfo!.toJson();
    }
    data['Message'] = this.message;
    if (this.sankalpInfo != null) {
      data['SankalpInfo'] = this.sankalpInfo!.toJson();
    }
    data['Status'] = this.status;
    return data;
  }
}

class KaaryaSthitiInfo {
  int? geoUnitID;
  String? geoUnitName;
  int? graamHasGatividhiA;
  int? graamHasMaasikA;
  int? graamHasSaaptaahikA;
  int? graamHasShaakhaaA;
  int? kaaryaSthitiID;
  int? kaaryaSthitiMonth;
  int? kaaryaSthitiYear;
  int? mVSaaptaahikCountA;
  int? mVShaakhaaCountA;
  int? maasikCountA;
  int? mandalHasGatividhiA;
  int? mandalHasMaasikA;
  int? mandalHasSaaptaahikA;
  int? mandalHasShaakhaaA;
  int? mandaliCountA;
  int? modifiedBy;
  String? modifiedDate;
  int? pVSaaptaahikCountA;
  int? pVShaakhaaCountA;
  int? sVSaaptaahikCountA;
  int? sVShaakhaaCountA;
  int? tVSaaptaahikCountA;
  int? tVShaakhaaCountA;
  int? vastiHasGatividhiA;
  int? vastiHasMaasikA;
  int? vastiHasSaaptaahikA;
  int? vastiHasShaakhaaA;

  KaaryaSthitiInfo(
      {this.geoUnitID,
      this.geoUnitName,
      this.graamHasGatividhiA,
      this.graamHasMaasikA,
      this.graamHasSaaptaahikA,
      this.graamHasShaakhaaA,
      this.kaaryaSthitiID,
      this.kaaryaSthitiMonth,
      this.kaaryaSthitiYear,
      this.mVSaaptaahikCountA,
      this.mVShaakhaaCountA,
      this.maasikCountA,
      this.mandalHasGatividhiA,
      this.mandalHasMaasikA,
      this.mandalHasSaaptaahikA,
      this.mandalHasShaakhaaA,
      this.mandaliCountA,
      this.modifiedBy,
      this.modifiedDate,
      this.pVSaaptaahikCountA,
      this.pVShaakhaaCountA,
      this.sVSaaptaahikCountA,
      this.sVShaakhaaCountA,
      this.tVSaaptaahikCountA,
      this.tVShaakhaaCountA,
      this.vastiHasGatividhiA,
      this.vastiHasMaasikA,
      this.vastiHasSaaptaahikA,
      this.vastiHasShaakhaaA});

  KaaryaSthitiInfo.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    graamHasGatividhiA = json['GraamHasGatividhiA'];
    graamHasMaasikA = json['GraamHasMaasikA'];
    graamHasSaaptaahikA = json['GraamHasSaaptaahikA'];
    graamHasShaakhaaA = json['GraamHasShaakhaaA'];
    kaaryaSthitiID = json['KaaryaSthitiID'];
    kaaryaSthitiMonth = json['KaaryaSthitiMonth'];
    kaaryaSthitiYear = json['KaaryaSthitiYear'];
    mVSaaptaahikCountA = json['MVSaaptaahikCountA'];
    mVShaakhaaCountA = json['MVShaakhaaCountA'];
    maasikCountA = json['MaasikCountA'];
    mandalHasGatividhiA = json['MandalHasGatividhiA'];
    mandalHasMaasikA = json['MandalHasMaasikA'];
    mandalHasSaaptaahikA = json['MandalHasSaaptaahikA'];
    mandalHasShaakhaaA = json['MandalHasShaakhaaA'];
    mandaliCountA = json['MandaliCountA'];
    modifiedBy = json['ModifiedBy'];
    modifiedDate = json['ModifiedDate'];
    pVSaaptaahikCountA = json['PVSaaptaahikCountA'];
    pVShaakhaaCountA = json['PVShaakhaaCountA'];
    sVSaaptaahikCountA = json['SVSaaptaahikCountA'];
    sVShaakhaaCountA = json['SVShaakhaaCountA'];
    tVSaaptaahikCountA = json['TVSaaptaahikCountA'];
    tVShaakhaaCountA = json['TVShaakhaaCountA'];
    vastiHasGatividhiA = json['VastiHasGatividhiA'];
    vastiHasMaasikA = json['VastiHasMaasikA'];
    vastiHasSaaptaahikA = json['VastiHasSaaptaahikA'];
    vastiHasShaakhaaA = json['VastiHasShaakhaaA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['GraamHasGatividhiA'] = this.graamHasGatividhiA;
    data['GraamHasMaasikA'] = this.graamHasMaasikA;
    data['GraamHasSaaptaahikA'] = this.graamHasSaaptaahikA;
    data['GraamHasShaakhaaA'] = this.graamHasShaakhaaA;
    data['KaaryaSthitiID'] = this.kaaryaSthitiID;
    data['KaaryaSthitiMonth'] = this.kaaryaSthitiMonth;
    data['KaaryaSthitiYear'] = this.kaaryaSthitiYear;
    data['MVSaaptaahikCountA'] = this.mVSaaptaahikCountA;
    data['MVShaakhaaCountA'] = this.mVShaakhaaCountA;
    data['MaasikCountA'] = this.maasikCountA;
    data['MandalHasGatividhiA'] = this.mandalHasGatividhiA;
    data['MandalHasMaasikA'] = this.mandalHasMaasikA;
    data['MandalHasSaaptaahikA'] = this.mandalHasSaaptaahikA;
    data['MandalHasShaakhaaA'] = this.mandalHasShaakhaaA;
    data['MandaliCountA'] = this.mandaliCountA;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDate'] = this.modifiedDate;
    data['PVSaaptaahikCountA'] = this.pVSaaptaahikCountA;
    data['PVShaakhaaCountA'] = this.pVShaakhaaCountA;
    data['SVSaaptaahikCountA'] = this.sVSaaptaahikCountA;
    data['SVShaakhaaCountA'] = this.sVShaakhaaCountA;
    data['TVSaaptaahikCountA'] = this.tVSaaptaahikCountA;
    data['TVShaakhaaCountA'] = this.tVShaakhaaCountA;
    data['VastiHasGatividhiA'] = this.vastiHasGatividhiA;
    data['VastiHasMaasikA'] = this.vastiHasMaasikA;
    data['VastiHasSaaptaahikA'] = this.vastiHasSaaptaahikA;
    data['VastiHasShaakhaaA'] = this.vastiHasShaakhaaA;
    return data;
  }
}

class SankalpInfo {
  int? geoUnitID;
  String? geoUnitName;
  int? graamHasGatividhiS;
  int? graamHasMaasikS;
  int? graamHasSaaptaahikS;
  int? graamHasShaakhaaS;
  bool? isSankalpOpen;
  int? mVSaaptaahikCountS;
  int? mVShaakhaaCountS;
  int? maasikCountS;
  int? mandalHasGatividhiS;
  int? mandalHasMaasikS;
  int? mandalHasSaaptaahikS;
  int? mandalHasShaakhaaS;
  int? mandaliCountS;
  int? modifiedBy;
  String? modifiedDate;
  int? pKAGatividhiCountS;
  int? pKAMaasikCountS;
  int? pKASaaptaahikCountS;
  int? pKAShaakhaaCountS;
  int? pVSaaptaahikCountS;
  int? pVShaakhaaCountS;
  int? sKAGatividhiCountS;
  int? sKAMaasikCountS;
  int? sKASaaptaahikCountS;
  int? sKAShaakhaaCountS;
  int? sVSaaptaahikCountS;
  int? sVShaakhaaCountS;
  int? sWAGatividhiCountS;
  int? sWAMaasikCountS;
  int? sWASaaptaahikCountS;
  int? sWAShaakhaaCountS;
  int? sankalpID;
  int? sankalpYear;
  int? tVSaaptaahikCountS;
  int? tVShaakhaaCountS;
  int? vastiHasGatividhiS;
  int? vastiHasMaasikS;
  int? vastiHasSaaptaahikS;
  int? vastiHasShaakhaaS;

  SankalpInfo(
      {this.geoUnitID,
      this.geoUnitName,
      this.graamHasGatividhiS,
      this.graamHasMaasikS,
      this.graamHasSaaptaahikS,
      this.graamHasShaakhaaS,
      this.isSankalpOpen,
      this.mVSaaptaahikCountS,
      this.mVShaakhaaCountS,
      this.maasikCountS,
      this.mandalHasGatividhiS,
      this.mandalHasMaasikS,
      this.mandalHasSaaptaahikS,
      this.mandalHasShaakhaaS,
      this.mandaliCountS,
      this.modifiedBy,
      this.modifiedDate,
      this.pKAGatividhiCountS,
      this.pKAMaasikCountS,
      this.pKASaaptaahikCountS,
      this.pKAShaakhaaCountS,
      this.pVSaaptaahikCountS,
      this.pVShaakhaaCountS,
      this.sKAGatividhiCountS,
      this.sKAMaasikCountS,
      this.sKASaaptaahikCountS,
      this.sKAShaakhaaCountS,
      this.sVSaaptaahikCountS,
      this.sVShaakhaaCountS,
      this.sWAGatividhiCountS,
      this.sWAMaasikCountS,
      this.sWASaaptaahikCountS,
      this.sWAShaakhaaCountS,
      this.sankalpID,
      this.sankalpYear,
      this.tVSaaptaahikCountS,
      this.tVShaakhaaCountS,
      this.vastiHasGatividhiS,
      this.vastiHasMaasikS,
      this.vastiHasSaaptaahikS,
      this.vastiHasShaakhaaS});

  SankalpInfo.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    graamHasGatividhiS = json['GraamHasGatividhiS'];
    graamHasMaasikS = json['GraamHasMaasikS'];
    graamHasSaaptaahikS = json['GraamHasSaaptaahikS'];
    graamHasShaakhaaS = json['GraamHasShaakhaaS'];
    isSankalpOpen = json['IsSankalpOpen'];
    mVSaaptaahikCountS = json['MVSaaptaahikCountS'];
    mVShaakhaaCountS = json['MVShaakhaaCountS'];
    maasikCountS = json['MaasikCountS'];
    mandalHasGatividhiS = json['MandalHasGatividhiS'];
    mandalHasMaasikS = json['MandalHasMaasikS'];
    mandalHasSaaptaahikS = json['MandalHasSaaptaahikS'];
    mandalHasShaakhaaS = json['MandalHasShaakhaaS'];
    mandaliCountS = json['MandaliCountS'];
    modifiedBy = json['ModifiedBy'];
    modifiedDate = json['ModifiedDate'];
    pKAGatividhiCountS = json['PKAGatividhiCountS'];
    pKAMaasikCountS = json['PKAMaasikCountS'];
    pKASaaptaahikCountS = json['PKASaaptaahikCountS'];
    pKAShaakhaaCountS = json['PKAShaakhaaCountS'];
    pVSaaptaahikCountS = json['PVSaaptaahikCountS'];
    pVShaakhaaCountS = json['PVShaakhaaCountS'];
    sKAGatividhiCountS = json['SKAGatividhiCountS'];
    sKAMaasikCountS = json['SKAMaasikCountS'];
    sKASaaptaahikCountS = json['SKASaaptaahikCountS'];
    sKAShaakhaaCountS = json['SKAShaakhaaCountS'];
    sVSaaptaahikCountS = json['SVSaaptaahikCountS'];
    sVShaakhaaCountS = json['SVShaakhaaCountS'];
    sWAGatividhiCountS = json['SWAGatividhiCountS'];
    sWAMaasikCountS = json['SWAMaasikCountS'];
    sWASaaptaahikCountS = json['SWASaaptaahikCountS'];
    sWAShaakhaaCountS = json['SWAShaakhaaCountS'];
    sankalpID = json['SankalpID'];
    sankalpYear = json['SankalpYear'];
    tVSaaptaahikCountS = json['TVSaaptaahikCountS'];
    tVShaakhaaCountS = json['TVShaakhaaCountS'];
    vastiHasGatividhiS = json['VastiHasGatividhiS'];
    vastiHasMaasikS = json['VastiHasMaasikS'];
    vastiHasSaaptaahikS = json['VastiHasSaaptaahikS'];
    vastiHasShaakhaaS = json['VastiHasShaakhaaS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['GraamHasGatividhiS'] = this.graamHasGatividhiS;
    data['GraamHasMaasikS'] = this.graamHasMaasikS;
    data['GraamHasSaaptaahikS'] = this.graamHasSaaptaahikS;
    data['GraamHasShaakhaaS'] = this.graamHasShaakhaaS;
    data['IsSankalpOpen'] = this.isSankalpOpen;
    data['MVSaaptaahikCountS'] = this.mVSaaptaahikCountS;
    data['MVShaakhaaCountS'] = this.mVShaakhaaCountS;
    data['MaasikCountS'] = this.maasikCountS;
    data['MandalHasGatividhiS'] = this.mandalHasGatividhiS;
    data['MandalHasMaasikS'] = this.mandalHasMaasikS;
    data['MandalHasSaaptaahikS'] = this.mandalHasSaaptaahikS;
    data['MandalHasShaakhaaS'] = this.mandalHasShaakhaaS;
    data['MandaliCountS'] = this.mandaliCountS;
    data['ModifiedBy'] = this.modifiedBy;
    data['ModifiedDate'] = this.modifiedDate;
    data['PKAGatividhiCountS'] = this.pKAGatividhiCountS;
    data['PKAMaasikCountS'] = this.pKAMaasikCountS;
    data['PKASaaptaahikCountS'] = this.pKASaaptaahikCountS;
    data['PKAShaakhaaCountS'] = this.pKAShaakhaaCountS;
    data['PVSaaptaahikCountS'] = this.pVSaaptaahikCountS;
    data['PVShaakhaaCountS'] = this.pVShaakhaaCountS;
    data['SKAGatividhiCountS'] = this.sKAGatividhiCountS;
    data['SKAMaasikCountS'] = this.sKAMaasikCountS;
    data['SKASaaptaahikCountS'] = this.sKASaaptaahikCountS;
    data['SKAShaakhaaCountS'] = this.sKAShaakhaaCountS;
    data['SVSaaptaahikCountS'] = this.sVSaaptaahikCountS;
    data['SVShaakhaaCountS'] = this.sVShaakhaaCountS;
    data['SWAGatividhiCountS'] = this.sWAGatividhiCountS;
    data['SWAMaasikCountS'] = this.sWAMaasikCountS;
    data['SWASaaptaahikCountS'] = this.sWASaaptaahikCountS;
    data['SWAShaakhaaCountS'] = this.sWAShaakhaaCountS;
    data['SankalpID'] = this.sankalpID;
    data['SankalpYear'] = this.sankalpYear;
    data['TVSaaptaahikCountS'] = this.tVSaaptaahikCountS;
    data['TVShaakhaaCountS'] = this.tVShaakhaaCountS;
    data['VastiHasGatividhiS'] = this.vastiHasGatividhiS;
    data['VastiHasMaasikS'] = this.vastiHasMaasikS;
    data['VastiHasSaaptaahikS'] = this.vastiHasSaaptaahikS;
    data['VastiHasShaakhaaS'] = this.vastiHasShaakhaaS;
    return data;
  }
}
