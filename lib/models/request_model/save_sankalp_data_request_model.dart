class SaveSankalpDataRequestModel {
  UpdateSankalpInfo? sankalpInfo;
  int? modifiedBy;

  SaveSankalpDataRequestModel({this.sankalpInfo, this.modifiedBy});

  SaveSankalpDataRequestModel.fromJson(Map<String, dynamic> json) {
    sankalpInfo = json['SankalpInfo'] != null ? new UpdateSankalpInfo.fromJson(json['SankalpInfo']) : null;
    modifiedBy = json['ModifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sankalpInfo != null) {
      data['SankalpInfo'] = this.sankalpInfo!.toJson();
    }
    data['ModifiedBy'] = this.modifiedBy;
    return data;
  }
}

class UpdateSankalpInfo {
  int? sankalpID;
  int? geoUnitID;
  int? sankalpYear;
  int? vastiHasShaakhaaS;
  int? vastiHasSaaptaahikS;
  int? vastiHasMaasik;
  int? vastiHasGatividhiS;
  int? graamHasShaakhaaS;
  int? graamHasSaaptaahikS;
  int? graamHasMaasikS;
  int? graamHasGatividhiS;
  int? mandalHasShaakhaaS;
  int? mandalHasSaaptaahikS;
  int? mandalHasMaasikS;
  int? mandalHasGatividhiS;
  int? sVShaakhaaCountS;
  int? mVShaakhaaCountS;
  int? tVShaakhaaCountS;
  int? pVShaakhaaCountS;
  int? sVSaaptaahikCountS;
  int? mVSaaptaahikCountS;
  int? tVSaaptaahikCountS;
  int? pVSaaptaahikCountS;
  int? maasikCountS;
  int? mandaliCountS;
  int? pKAShaakhaaCountS;
  int? sKAShaakhaaCountS;
  int? sWAShaakhaaCountS;
  int? pKASaaptaahikCountS;
  int? sKASaaptaahikCountS;
  int? sWASaaptaahikCountS;
  int? pKAMaasikCountS;
  int? sKAMaasikCountS;
  int? sWAMaasikCountS;
  int? pKAGatividhiCountS;
  int? sKAGatividhiCountS;
  int? sWAGatividhiCountS;
  int? modifiedBy;

  UpdateSankalpInfo(
      {this.sankalpID,
      this.geoUnitID,
      this.sankalpYear,
      this.vastiHasShaakhaaS,
      this.vastiHasSaaptaahikS,
      this.vastiHasMaasik,
      this.vastiHasGatividhiS,
      this.graamHasShaakhaaS,
      this.graamHasSaaptaahikS,
      this.graamHasMaasikS,
      this.graamHasGatividhiS,
      this.mandalHasShaakhaaS,
      this.mandalHasSaaptaahikS,
      this.mandalHasMaasikS,
      this.mandalHasGatividhiS,
      this.sVShaakhaaCountS,
      this.mVShaakhaaCountS,
      this.tVShaakhaaCountS,
      this.pVShaakhaaCountS,
      this.sVSaaptaahikCountS,
      this.mVSaaptaahikCountS,
      this.tVSaaptaahikCountS,
      this.pVSaaptaahikCountS,
      this.maasikCountS,
      this.mandaliCountS,
      this.pKAShaakhaaCountS,
      this.sKAShaakhaaCountS,
      this.sWAShaakhaaCountS,
      this.pKASaaptaahikCountS,
      this.sKASaaptaahikCountS,
      this.sWASaaptaahikCountS,
      this.pKAMaasikCountS,
      this.sKAMaasikCountS,
      this.sWAMaasikCountS,
      this.pKAGatividhiCountS,
      this.sKAGatividhiCountS,
      this.sWAGatividhiCountS,
      this.modifiedBy});

  UpdateSankalpInfo.fromJson(Map<String, dynamic> json) {
    sankalpID = json['SankalpID'];
    geoUnitID = json['GeoUnitID'];
    sankalpYear = json['SankalpYear'];
    vastiHasShaakhaaS = json['VastiHasShaakhaaS'];
    vastiHasSaaptaahikS = json['VastiHasSaaptaahikS'];
    vastiHasMaasik = json['VastiHasMaasik'];
    vastiHasGatividhiS = json['VastiHasGatividhiS'];
    graamHasShaakhaaS = json['GraamHasShaakhaaS'];
    graamHasSaaptaahikS = json['GraamHasSaaptaahikS'];
    graamHasMaasikS = json['GraamHasMaasikS'];
    graamHasGatividhiS = json['GraamHasGatividhiS'];
    mandalHasShaakhaaS = json['MandalHasShaakhaaS'];
    mandalHasSaaptaahikS = json['MandalHasSaaptaahikS'];
    mandalHasMaasikS = json['MandalHasMaasikS'];
    mandalHasGatividhiS = json['MandalHasGatividhiS'];
    sVShaakhaaCountS = json['SVShaakhaaCountS'];
    mVShaakhaaCountS = json['MVShaakhaaCountS'];
    tVShaakhaaCountS = json['TVShaakhaaCountS'];
    pVShaakhaaCountS = json['PVShaakhaaCountS'];
    sVSaaptaahikCountS = json['SVSaaptaahikCountS'];
    mVSaaptaahikCountS = json['MVSaaptaahikCountS'];
    tVSaaptaahikCountS = json['TVSaaptaahikCountS'];
    pVSaaptaahikCountS = json['PVSaaptaahikCountS'];
    maasikCountS = json['MaasikCountS'];
    mandaliCountS = json['MandaliCountS'];
    pKAShaakhaaCountS = json['PKAShaakhaaCountS'];
    sKAShaakhaaCountS = json['SKAShaakhaaCountS'];
    sWAShaakhaaCountS = json['SWAShaakhaaCountS'];
    pKASaaptaahikCountS = json['PKASaaptaahikCountS'];
    sKASaaptaahikCountS = json['SKASaaptaahikCountS'];
    sWASaaptaahikCountS = json['SWASaaptaahikCountS'];
    pKAMaasikCountS = json['PKAMaasikCountS'];
    sKAMaasikCountS = json['SKAMaasikCountS'];
    sWAMaasikCountS = json['SWAMaasikCountS'];
    pKAGatividhiCountS = json['PKAGatividhiCountS'];
    sKAGatividhiCountS = json['SKAGatividhiCountS'];
    sWAGatividhiCountS = json['SWAGatividhiCountS'];
    modifiedBy = json['ModifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SankalpID'] = this.sankalpID;
    data['GeoUnitID'] = this.geoUnitID;
    data['SankalpYear'] = this.sankalpYear;
    data['VastiHasShaakhaaS'] = this.vastiHasShaakhaaS;
    data['VastiHasSaaptaahikS'] = this.vastiHasSaaptaahikS;
    data['VastiHasMaasik'] = this.vastiHasMaasik;
    data['VastiHasGatividhiS'] = this.vastiHasGatividhiS;
    data['GraamHasShaakhaaS'] = this.graamHasShaakhaaS;
    data['GraamHasSaaptaahikS'] = this.graamHasSaaptaahikS;
    data['GraamHasMaasikS'] = this.graamHasMaasikS;
    data['GraamHasGatividhiS'] = this.graamHasGatividhiS;
    data['MandalHasShaakhaaS'] = this.mandalHasShaakhaaS;
    data['MandalHasSaaptaahikS'] = this.mandalHasSaaptaahikS;
    data['MandalHasMaasikS'] = this.mandalHasMaasikS;
    data['MandalHasGatividhiS'] = this.mandalHasGatividhiS;
    data['SVShaakhaaCountS'] = this.sVShaakhaaCountS;
    data['MVShaakhaaCountS'] = this.mVShaakhaaCountS;
    data['TVShaakhaaCountS'] = this.tVShaakhaaCountS;
    data['PVShaakhaaCountS'] = this.pVShaakhaaCountS;
    data['SVSaaptaahikCountS'] = this.sVSaaptaahikCountS;
    data['MVSaaptaahikCountS'] = this.mVSaaptaahikCountS;
    data['TVSaaptaahikCountS'] = this.tVSaaptaahikCountS;
    data['PVSaaptaahikCountS'] = this.pVSaaptaahikCountS;
    data['MaasikCountS'] = this.maasikCountS;
    data['MandaliCountS'] = this.mandaliCountS;
    data['PKAShaakhaaCountS'] = this.pKAShaakhaaCountS;
    data['SKAShaakhaaCountS'] = this.sKAShaakhaaCountS;
    data['SWAShaakhaaCountS'] = this.sWAShaakhaaCountS;
    data['PKASaaptaahikCountS'] = this.pKASaaptaahikCountS;
    data['SKASaaptaahikCountS'] = this.sKASaaptaahikCountS;
    data['SWASaaptaahikCountS'] = this.sWASaaptaahikCountS;
    data['PKAMaasikCountS'] = this.pKAMaasikCountS;
    data['SKAMaasikCountS'] = this.sKAMaasikCountS;
    data['SWAMaasikCountS'] = this.sWAMaasikCountS;
    data['PKAGatividhiCountS'] = this.pKAGatividhiCountS;
    data['SKAGatividhiCountS'] = this.sKAGatividhiCountS;
    data['SWAGatividhiCountS'] = this.sWAGatividhiCountS;
    data['ModifiedBy'] = this.modifiedBy;
    return data;
  }
}
