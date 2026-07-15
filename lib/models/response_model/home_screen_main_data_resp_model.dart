class HomeScreenDataRespModel {
  HomeScreenData? homeScreenData;
  String? message;
  String? status;

  HomeScreenDataRespModel({this.homeScreenData, this.message, this.status});

  HomeScreenDataRespModel.fromJson(Map<String, dynamic> json) {
    homeScreenData = json['HomeScreenData'] != null ? new HomeScreenData.fromJson(json['HomeScreenData']) : null;
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.homeScreenData != null) {
      data['HomeScreenData'] = this.homeScreenData!.toJson();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}

class HomeScreenData {
  int? aayaamKaaryakartaaCount;
  int? akhilBhaaratiyaKaaryakartaaCount;
  List<AppVersion>? appVersion;
  List<KeyValModel>? areaOfExpertise;
  List<KeyValModel>? areaOfInterest;
  int? baalCount;
  int? bhaagKaaryakartaaCount;
  BhaugolikVistaarData? bhaugolikVistaarData;
  List<KeyValModel>? bloodGroup;
  int? dailyShaakhaaKaaryakartaaCount;
  int? dwitiyaVarshaShikshitCount;
  GanaveshData? ganaveshData;
  int? gatividhiKaaryakartaaCount;
  int? graamKaaryakartaaCount;
  int? kshetraKaaryakartaaCount;
  List<ListKaaryakartaaCountByAayaam>? listKaaryakartaaCountByAayaam;
  List<ListKaaryakartaaCountByGatividhi>? listKaaryakartaaCountByGatividhi;
  List<ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation>? listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation;
  List<ListSankalpByAadhaar>? listSankalpByAadhaar;
  List<ListShaakhaaCountByVayogat>? listShaakhaaCountByVayogat;
  List<ListShaakhaaVruttaDetail>? listShaakhaaVruttaDetail;
  List<ListSocialOrganizationKaaryakartaaCountByAreaOfOperation>? listSocialOrganizationKaaryakartaaCountByAreaOfOperation;
  List<ListSwayamsevakCountByStudentCategory>? listSwayamsevakCountByStudentCategory;
  List<ListSwayamsevakCountByVyavasaayeeCategory>? listSwayamsevakCountByVyavasaayeeCategory;
  List<ListYesterdayPraantShaakhaaCountByVayogat>? listYesterdayPraantShaakhaaCountByVayogat;
  List<ListYesterdayVrutta>? listYesterdayVrutta;
  List<ListYesterdayVruttaSummary>? listYesterdayVruttaSummary;
  int? maasikMilanCount;
  int? maasikMilanKaaryakartaaCount;
  int? mahaanagarKaaryakartaaCount;
  int? mandalKaaryakartaaCount;
  List<KeyValModel>? motherTongue;
  int? nagarKaaryakartaaCount;
  int? noShikshanCount;
  int? notificationcount;
  int? praantKaaryakartaaCount;
  int? praathamikShikshitCount;
  int? prarambhikShikshitCount;
  int? prathamVarshaShikshitCount;
  int? pratidnyitCount;
  int? pravaaseeKaaryakartaaCount;
  int? proudhaVyavasaayeeCount;
  int? saaptaahikMilanKaaryakartaaCount;
  int? sanghaMandaliCount;
  int? sanghaPreritSansthaaKaaryakartaaCount;
  int? shaakhaaKaaryakartaaCount;
  ShaakhaaVruttaSummaryData? shaakhaaVruttaSummaryData;
  int? shaharKaaryakartaaCount;
  int? shishuCount;
  int? socialOrganizationKaaryakartaaCount;
  int? tarunVidyaarthiCount;
  int? tarunVyavasaayeeCount;
  int? totalKaaryakartaaCount;
  int? totalStudentCount;
  int? totalSwayamsevakCount;
  int? totalVyavasaayeeCount;
  int? trutiyaVarshaShikshitCount;
  int? unknownAgeCount;
  int? vastiKaaryakartaaCount;
  VehicleData? vehicleData;
  int? vibhaagKaaryakartaaCount;
  List<KeyValModel>? goshwad;
  List<KeyValModel>? sangaayu;

  HomeScreenData(
      {this.aayaamKaaryakartaaCount,
      this.akhilBhaaratiyaKaaryakartaaCount,
      this.appVersion,
      this.areaOfExpertise,
      this.areaOfInterest,
      this.baalCount,
      this.bhaagKaaryakartaaCount,
      this.bhaugolikVistaarData,
      this.bloodGroup,
      this.dailyShaakhaaKaaryakartaaCount,
      this.dwitiyaVarshaShikshitCount,
      this.ganaveshData,
      this.gatividhiKaaryakartaaCount,
      this.graamKaaryakartaaCount,
      this.kshetraKaaryakartaaCount,
      this.listKaaryakartaaCountByAayaam,
      this.listKaaryakartaaCountByGatividhi,
      this.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation,
      this.listSankalpByAadhaar,
      this.listShaakhaaCountByVayogat,
      this.listShaakhaaVruttaDetail,
      this.listSocialOrganizationKaaryakartaaCountByAreaOfOperation,
      this.listSwayamsevakCountByStudentCategory,
      this.listSwayamsevakCountByVyavasaayeeCategory,
      this.listYesterdayPraantShaakhaaCountByVayogat,
      this.listYesterdayVrutta,
      this.listYesterdayVruttaSummary,
      this.maasikMilanCount,
      this.maasikMilanKaaryakartaaCount,
      this.mahaanagarKaaryakartaaCount,
      this.mandalKaaryakartaaCount,
      this.motherTongue,
      this.nagarKaaryakartaaCount,
      this.noShikshanCount,
      this.notificationcount,
      this.praantKaaryakartaaCount,
      this.praathamikShikshitCount,
      this.prarambhikShikshitCount,
      this.prathamVarshaShikshitCount,
      this.pratidnyitCount,
      this.pravaaseeKaaryakartaaCount,
      this.proudhaVyavasaayeeCount,
      this.saaptaahikMilanKaaryakartaaCount,
      this.sanghaMandaliCount,
      this.sanghaPreritSansthaaKaaryakartaaCount,
      this.shaakhaaKaaryakartaaCount,
      this.shaakhaaVruttaSummaryData,
      this.shaharKaaryakartaaCount,
      this.shishuCount,
      this.socialOrganizationKaaryakartaaCount,
      this.tarunVidyaarthiCount,
      this.tarunVyavasaayeeCount,
      this.totalKaaryakartaaCount,
      this.totalStudentCount,
      this.totalSwayamsevakCount,
      this.totalVyavasaayeeCount,
      this.trutiyaVarshaShikshitCount,
      this.unknownAgeCount,
      this.vastiKaaryakartaaCount,
      this.vehicleData,
      this.vibhaagKaaryakartaaCount,
      this.goshwad,
      this.sangaayu});

  HomeScreenData.fromJson(Map<String, dynamic> json) {
    aayaamKaaryakartaaCount = json['AayaamKaaryakartaaCount'];
    akhilBhaaratiyaKaaryakartaaCount = json['AkhilBhaaratiyaKaaryakartaaCount'];
    if (json['AppVersion'] != null) {
      appVersion = <AppVersion>[];
      json['AppVersion'].forEach((v) {
        appVersion!.add(new AppVersion.fromJson(v));
      });
    }
    if (json['AreaOfExpertise'] != null) {
      areaOfExpertise = <KeyValModel>[];
      json['AreaOfExpertise'].forEach((v) {
        areaOfExpertise!.add(new KeyValModel.fromJson(v));
      });
    }
    if (json['AreaOfInterest'] != null) {
      areaOfInterest = <KeyValModel>[];
      json['AreaOfInterest'].forEach((v) {
        areaOfInterest!.add(new KeyValModel.fromJson(v));
      });
    }
    baalCount = json['BaalCount'];
    bhaagKaaryakartaaCount = json['BhaagKaaryakartaaCount'];
    bhaugolikVistaarData = json['BhaugolikVistaarData'] != null ? new BhaugolikVistaarData.fromJson(json['BhaugolikVistaarData']) : null;
    if (json['BloodGroup'] != null) {
      bloodGroup = <KeyValModel>[];
      json['BloodGroup'].forEach((v) {
        bloodGroup!.add(new KeyValModel.fromJson(v));
      });
    }
    dailyShaakhaaKaaryakartaaCount = json['DailyShaakhaaKaaryakartaaCount'];
    dwitiyaVarshaShikshitCount = json['DwitiyaVarshaShikshitCount'];
    ganaveshData = json['GanaveshData'] != null ? new GanaveshData.fromJson(json['GanaveshData']) : null;
    gatividhiKaaryakartaaCount = json['GatividhiKaaryakartaaCount'];
    graamKaaryakartaaCount = json['GraamKaaryakartaaCount'];
    kshetraKaaryakartaaCount = json['KshetraKaaryakartaaCount'];
    if (json['ListKaaryakartaaCountByAayaam'] != null) {
      listKaaryakartaaCountByAayaam = <ListKaaryakartaaCountByAayaam>[];
      json['ListKaaryakartaaCountByAayaam'].forEach((v) {
        listKaaryakartaaCountByAayaam!.add(new ListKaaryakartaaCountByAayaam.fromJson(v));
      });
    }
    if (json['ListKaaryakartaaCountByGatividhi'] != null) {
      listKaaryakartaaCountByGatividhi = <ListKaaryakartaaCountByGatividhi>[];
      json['ListKaaryakartaaCountByGatividhi'].forEach((v) {
        listKaaryakartaaCountByGatividhi!.add(new ListKaaryakartaaCountByGatividhi.fromJson(v));
      });
    }
    if (json['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'] != null) {
      listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation = <ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation>[];
      json['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'].forEach((v) {
        listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.add(new ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation.fromJson(v));
      });
    }
    if (json['ListSankalpByAadhaar'] != null) {
      listSankalpByAadhaar = <ListSankalpByAadhaar>[];
      json['ListSankalpByAadhaar'].forEach((v) {
        listSankalpByAadhaar!.add(new ListSankalpByAadhaar.fromJson(v));
      });
    }
    if (json['ListShaakhaaCountByVayogat'] != null) {
      listShaakhaaCountByVayogat = <ListShaakhaaCountByVayogat>[];
      json['ListShaakhaaCountByVayogat'].forEach((v) {
        listShaakhaaCountByVayogat!.add(new ListShaakhaaCountByVayogat.fromJson(v));
      });
    }
    if (json['ListShaakhaaVruttaDetail'] != null) {
      listShaakhaaVruttaDetail = <ListShaakhaaVruttaDetail>[];
      json['ListShaakhaaVruttaDetail'].forEach((v) {
        listShaakhaaVruttaDetail!.add(new ListShaakhaaVruttaDetail.fromJson(v));
      });
    }
    if (json['ListSocialOrganizationKaaryakartaaCountByAreaOfOperation'] != null) {
      listSocialOrganizationKaaryakartaaCountByAreaOfOperation = <ListSocialOrganizationKaaryakartaaCountByAreaOfOperation>[];
      json['ListSocialOrganizationKaaryakartaaCountByAreaOfOperation'].forEach((v) {
        listSocialOrganizationKaaryakartaaCountByAreaOfOperation!.add(new ListSocialOrganizationKaaryakartaaCountByAreaOfOperation.fromJson(v));
      });
    }
    if (json['ListSwayamsevakCountByStudentCategory'] != null) {
      listSwayamsevakCountByStudentCategory = <ListSwayamsevakCountByStudentCategory>[];
      json['ListSwayamsevakCountByStudentCategory'].forEach((v) {
        listSwayamsevakCountByStudentCategory!.add(new ListSwayamsevakCountByStudentCategory.fromJson(v));
      });
    }
    if (json['ListSwayamsevakCountByVyavasaayeeCategory'] != null) {
      listSwayamsevakCountByVyavasaayeeCategory = <ListSwayamsevakCountByVyavasaayeeCategory>[];
      json['ListSwayamsevakCountByVyavasaayeeCategory'].forEach((v) {
        listSwayamsevakCountByVyavasaayeeCategory!.add(new ListSwayamsevakCountByVyavasaayeeCategory.fromJson(v));
      });
    }
    if (json['ListYesterdayPraantShaakhaaCountByVayogat'] != null) {
      listYesterdayPraantShaakhaaCountByVayogat = <ListYesterdayPraantShaakhaaCountByVayogat>[];
      json['ListYesterdayPraantShaakhaaCountByVayogat'].forEach((v) {
        listYesterdayPraantShaakhaaCountByVayogat!.add(new ListYesterdayPraantShaakhaaCountByVayogat.fromJson(v));
      });
    }
    if (json['ListYesterdayVrutta'] != null) {
      listYesterdayVrutta = <ListYesterdayVrutta>[];
      json['ListYesterdayVrutta'].forEach((v) {
        listYesterdayVrutta!.add(new ListYesterdayVrutta.fromJson(v));
      });
    }
    if (json['ListYesterdayVruttaSummary'] != null) {
      listYesterdayVruttaSummary = <ListYesterdayVruttaSummary>[];
      json['ListYesterdayVruttaSummary'].forEach((v) {
        listYesterdayVruttaSummary!.add(new ListYesterdayVruttaSummary.fromJson(v));
      });
    }
    maasikMilanCount = json['MaasikMilanCount'];
    maasikMilanKaaryakartaaCount = json['MaasikMilanKaaryakartaaCount'];
    mahaanagarKaaryakartaaCount = json['MahaanagarKaaryakartaaCount'];
    mandalKaaryakartaaCount = json['MandalKaaryakartaaCount'];
    if (json['MotherTongue'] != null) {
      motherTongue = <KeyValModel>[];
      json['MotherTongue'].forEach((v) {
        motherTongue!.add(new KeyValModel.fromJson(v));
      });
    }
    nagarKaaryakartaaCount = json['NagarKaaryakartaaCount'];
    noShikshanCount = json['NoShikshanCount'];
    notificationcount = json['Notificationcount'];
    praantKaaryakartaaCount = json['PraantKaaryakartaaCount'];
    praathamikShikshitCount = json['PraathamikShikshitCount'];
    prarambhikShikshitCount = json['PrarambhikShikshitCount'];
    prathamVarshaShikshitCount = json['PrathamVarshaShikshitCount'];
    pratidnyitCount = json['PratidnyitCount'];
    pravaaseeKaaryakartaaCount = json['PravaaseeKaaryakartaaCount'];
    proudhaVyavasaayeeCount = json['ProudhaVyavasaayeeCount'];
    saaptaahikMilanKaaryakartaaCount = json['SaaptaahikMilanKaaryakartaaCount'];
    sanghaMandaliCount = json['SanghaMandaliCount'];
    sanghaPreritSansthaaKaaryakartaaCount = json['SanghaPreritSansthaaKaaryakartaaCount'];
    shaakhaaKaaryakartaaCount = json['ShaakhaaKaaryakartaaCount'];
    shaakhaaVruttaSummaryData = json['ShaakhaaVruttaSummaryData'] != null ? new ShaakhaaVruttaSummaryData.fromJson(json['ShaakhaaVruttaSummaryData']) : null;
    shaharKaaryakartaaCount = json['ShaharKaaryakartaaCount'];
    shishuCount = json['ShishuCount'];
    socialOrganizationKaaryakartaaCount = json['SocialOrganizationKaaryakartaaCount'];
    tarunVidyaarthiCount = json['TarunVidyaarthiCount'];
    tarunVyavasaayeeCount = json['TarunVyavasaayeeCount'];
    totalKaaryakartaaCount = json['TotalKaaryakartaaCount'];
    totalStudentCount = json['TotalStudentCount'];
    totalSwayamsevakCount = json['TotalSwayamsevakCount'];
    totalVyavasaayeeCount = json['TotalVyavasaayeeCount'];
    trutiyaVarshaShikshitCount = json['TrutiyaVarshaShikshitCount'];
    unknownAgeCount = json['UnknownAgeCount'];
    vastiKaaryakartaaCount = json['VastiKaaryakartaaCount'];
    vehicleData = json['VehicleData'] != null ? new VehicleData.fromJson(json['VehicleData']) : null;
    vibhaagKaaryakartaaCount = json['VibhaagKaaryakartaaCount'];
    if (json['goshwad'] != null) {
      goshwad = <KeyValModel>[];
      json['goshwad'].forEach((v) {
        goshwad!.add(new KeyValModel.fromJson(v));
      });
    }
    if (json['sangaayu'] != null) {
      sangaayu = <KeyValModel>[];
      json['sangaayu'].forEach((v) {
        sangaayu!.add(new KeyValModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AayaamKaaryakartaaCount'] = this.aayaamKaaryakartaaCount;
    data['AkhilBhaaratiyaKaaryakartaaCount'] = this.akhilBhaaratiyaKaaryakartaaCount;
    if (this.appVersion != null) {
      data['AppVersion'] = this.appVersion!.map((v) => v.toJson()).toList();
    }
    if (this.areaOfExpertise != null) {
      data['AreaOfExpertise'] = this.areaOfExpertise!.map((v) => v.toJson()).toList();
    }
    if (this.areaOfInterest != null) {
      data['AreaOfInterest'] = this.areaOfInterest!.map((v) => v.toJson()).toList();
    }
    data['BaalCount'] = this.baalCount;
    data['BhaagKaaryakartaaCount'] = this.bhaagKaaryakartaaCount;
    if (this.bhaugolikVistaarData != null) {
      data['BhaugolikVistaarData'] = this.bhaugolikVistaarData!.toJson();
    }
    if (this.bloodGroup != null) {
      data['BloodGroup'] = this.bloodGroup!.map((v) => v.toJson()).toList();
    }
    data['DailyShaakhaaKaaryakartaaCount'] = this.dailyShaakhaaKaaryakartaaCount;
    data['DwitiyaVarshaShikshitCount'] = this.dwitiyaVarshaShikshitCount;
    if (this.ganaveshData != null) {
      data['GanaveshData'] = this.ganaveshData!.toJson();
    }
    data['GatividhiKaaryakartaaCount'] = this.gatividhiKaaryakartaaCount;
    data['GraamKaaryakartaaCount'] = this.graamKaaryakartaaCount;
    data['KshetraKaaryakartaaCount'] = this.kshetraKaaryakartaaCount;
    if (this.listKaaryakartaaCountByAayaam != null) {
      data['ListKaaryakartaaCountByAayaam'] = this.listKaaryakartaaCountByAayaam!.map((v) => v.toJson()).toList();
    }
    if (this.listKaaryakartaaCountByGatividhi != null) {
      data['ListKaaryakartaaCountByGatividhi'] = this.listKaaryakartaaCountByGatividhi!.map((v) => v.toJson()).toList();
    }
    if (this.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation != null) {
      data['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'] = this.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.map((v) => v.toJson()).toList();
    }
    if (this.listSankalpByAadhaar != null) {
      data['ListSankalpByAadhaar'] = this.listSankalpByAadhaar!.map((v) => v.toJson()).toList();
    }
    if (this.listShaakhaaCountByVayogat != null) {
      data['ListShaakhaaCountByVayogat'] = this.listShaakhaaCountByVayogat!.map((v) => v.toJson()).toList();
    }
    if (this.listShaakhaaVruttaDetail != null) {
      data['ListShaakhaaVruttaDetail'] = this.listShaakhaaVruttaDetail!.map((v) => v.toJson()).toList();
    }
    if (this.listSocialOrganizationKaaryakartaaCountByAreaOfOperation != null) {
      data['ListSocialOrganizationKaaryakartaaCountByAreaOfOperation'] = this.listSocialOrganizationKaaryakartaaCountByAreaOfOperation!.map((v) => v.toJson()).toList();
    }
    if (this.listSwayamsevakCountByStudentCategory != null) {
      data['ListSwayamsevakCountByStudentCategory'] = this.listSwayamsevakCountByStudentCategory!.map((v) => v.toJson()).toList();
    }
    if (this.listSwayamsevakCountByVyavasaayeeCategory != null) {
      data['ListSwayamsevakCountByVyavasaayeeCategory'] = this.listSwayamsevakCountByVyavasaayeeCategory!.map((v) => v.toJson()).toList();
    }
    if (this.listYesterdayPraantShaakhaaCountByVayogat != null) {
      data['ListYesterdayPraantShaakhaaCountByVayogat'] = this.listYesterdayPraantShaakhaaCountByVayogat!.map((v) => v.toJson()).toList();
    }
    if (this.listYesterdayVrutta != null) {
      data['ListYesterdayVrutta'] = this.listYesterdayVrutta!.map((v) => v.toJson()).toList();
    }
    if (this.listYesterdayVruttaSummary != null) {
      data['ListYesterdayVruttaSummary'] = this.listYesterdayVruttaSummary!.map((v) => v.toJson()).toList();
    }
    data['MaasikMilanCount'] = this.maasikMilanCount;
    data['MaasikMilanKaaryakartaaCount'] = this.maasikMilanKaaryakartaaCount;
    data['MahaanagarKaaryakartaaCount'] = this.mahaanagarKaaryakartaaCount;
    data['MandalKaaryakartaaCount'] = this.mandalKaaryakartaaCount;
    if (this.motherTongue != null) {
      data['MotherTongue'] = this.motherTongue!.map((v) => v.toJson()).toList();
    }
    data['NagarKaaryakartaaCount'] = this.nagarKaaryakartaaCount;
    data['NoShikshanCount'] = this.noShikshanCount;
    data['Notificationcount'] = this.notificationcount;
    data['PraantKaaryakartaaCount'] = this.praantKaaryakartaaCount;
    data['PraathamikShikshitCount'] = this.praathamikShikshitCount;
    data['PrarambhikShikshitCount'] = this.prarambhikShikshitCount;
    data['PrathamVarshaShikshitCount'] = this.prathamVarshaShikshitCount;
    data['PratidnyitCount'] = this.pratidnyitCount;
    data['PravaaseeKaaryakartaaCount'] = this.pravaaseeKaaryakartaaCount;
    data['ProudhaVyavasaayeeCount'] = this.proudhaVyavasaayeeCount;
    data['SaaptaahikMilanKaaryakartaaCount'] = this.saaptaahikMilanKaaryakartaaCount;
    data['SanghaMandaliCount'] = this.sanghaMandaliCount;
    data['SanghaPreritSansthaaKaaryakartaaCount'] = this.sanghaPreritSansthaaKaaryakartaaCount;
    data['ShaakhaaKaaryakartaaCount'] = this.shaakhaaKaaryakartaaCount;
    if (this.shaakhaaVruttaSummaryData != null) {
      data['ShaakhaaVruttaSummaryData'] = this.shaakhaaVruttaSummaryData!.toJson();
    }
    data['ShaharKaaryakartaaCount'] = this.shaharKaaryakartaaCount;
    data['ShishuCount'] = this.shishuCount;
    data['SocialOrganizationKaaryakartaaCount'] = this.socialOrganizationKaaryakartaaCount;
    data['TarunVidyaarthiCount'] = this.tarunVidyaarthiCount;
    data['TarunVyavasaayeeCount'] = this.tarunVyavasaayeeCount;
    data['TotalKaaryakartaaCount'] = this.totalKaaryakartaaCount;
    data['TotalStudentCount'] = this.totalStudentCount;
    data['TotalSwayamsevakCount'] = this.totalSwayamsevakCount;
    data['TotalVyavasaayeeCount'] = this.totalVyavasaayeeCount;
    data['TrutiyaVarshaShikshitCount'] = this.trutiyaVarshaShikshitCount;
    data['UnknownAgeCount'] = this.unknownAgeCount;
    data['VastiKaaryakartaaCount'] = this.vastiKaaryakartaaCount;
    if (this.vehicleData != null) {
      data['VehicleData'] = this.vehicleData!.toJson();
    }
    data['VibhaagKaaryakartaaCount'] = this.vibhaagKaaryakartaaCount;
    if (this.goshwad != null) {
      data['goshwad'] = this.goshwad!.map((v) => v.toJson()).toList();
    }
    if (this.sangaayu != null) {
      data['sangaayu'] = this.sangaayu!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppVersion {
  String? buildNumber;
  String? versionNumber;

  AppVersion({this.buildNumber, this.versionNumber});

  AppVersion.fromJson(Map<String, dynamic> json) {
    buildNumber = json['BuildNumber'];
    versionNumber = json['VersionNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BuildNumber'] = this.buildNumber;
    data['VersionNumber'] = this.versionNumber;
    return data;
  }
}

class KeyValModel {
  String? codeForDisplay;
  int? cnt;

  KeyValModel({this.codeForDisplay, this.cnt});

  KeyValModel.fromJson(Map<String, dynamic> json) {
    codeForDisplay = json['CodeForDisplay'];
    cnt = json['cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CodeForDisplay'] = this.codeForDisplay;
    data['cnt'] = this.cnt;
    return data;
  }
}

class BhaugolikVistaarData {
  int? gatividhiYuktaGraamCount;
  int? gatividhiYuktaMandalCount;
  int? gatividhiYuktaNagarCount;
  int? gatividhiYuktaNagarCountGraamin;
  int? gatividhiYuktaNagarCountShahari;
  int? gatividhiYuktaShaharCount;
  int? gatividhiYuktaVastiCount;
  int? mandaliYuktaGraamCount;
  int? mandaliYuktaMandalCount;
  int? mandaliYuktaNagarCount;
  int? mandaliYuktaNagarCountGraamin;
  int? mandaliYuktaNagarCountShahari;
  int? mandaliYuktaShaharCount;
  int? mandaliYuktaVastiCount;
  int? saaptaahikYuktaGraamCount;
  int? saaptaahikYuktaMandalCount;
  int? saaptaahikYuktaNagarCount;
  int? saaptaahikYuktaNagarCountGraamin;
  int? saaptaahikYuktaNagarCountShahari;
  int? saaptaahikYuktaShaharCount;
  int? saaptaahikYuktaVastiCount;
  int? shaakhaaYuktaGraamCount;
  int? shaakhaaYuktaMandalCount;
  int? shaakhaaYuktaNagarCount;
  int? shaakhaaYuktaNagarCountGraamin;
  int? shaakhaaYuktaNagarCountShahari;
  int? shaakhaaYuktaShaharCount;
  int? shaakhaaYuktaVastiCount;
  int? totalGraamCount;
  int? totalMandalCount;
  int? totalNagarCount;
  int? totalNagarCountGraamin;
  int? totalNagarCountShahari;
  int? totalShaakhaaCount;
  int? totalShaharCount;
  int? totalVastiCount;

  BhaugolikVistaarData(
      {this.gatividhiYuktaGraamCount,
      this.gatividhiYuktaMandalCount,
      this.gatividhiYuktaNagarCount,
      this.gatividhiYuktaNagarCountGraamin,
      this.gatividhiYuktaNagarCountShahari,
      this.gatividhiYuktaShaharCount,
      this.gatividhiYuktaVastiCount,
      this.mandaliYuktaGraamCount,
      this.mandaliYuktaMandalCount,
      this.mandaliYuktaNagarCount,
      this.mandaliYuktaNagarCountGraamin,
      this.mandaliYuktaNagarCountShahari,
      this.mandaliYuktaShaharCount,
      this.mandaliYuktaVastiCount,
      this.saaptaahikYuktaGraamCount,
      this.saaptaahikYuktaMandalCount,
      this.saaptaahikYuktaNagarCount,
      this.saaptaahikYuktaNagarCountGraamin,
      this.saaptaahikYuktaNagarCountShahari,
      this.saaptaahikYuktaShaharCount,
      this.saaptaahikYuktaVastiCount,
      this.shaakhaaYuktaGraamCount,
      this.shaakhaaYuktaMandalCount,
      this.shaakhaaYuktaNagarCount,
      this.shaakhaaYuktaNagarCountGraamin,
      this.shaakhaaYuktaNagarCountShahari,
      this.shaakhaaYuktaShaharCount,
      this.shaakhaaYuktaVastiCount,
      this.totalGraamCount,
      this.totalMandalCount,
      this.totalNagarCount,
      this.totalNagarCountGraamin,
      this.totalNagarCountShahari,
      this.totalShaakhaaCount,
      this.totalShaharCount,
      this.totalVastiCount});

  BhaugolikVistaarData.fromJson(Map<String, dynamic> json) {
    gatividhiYuktaGraamCount = json['GatividhiYuktaGraamCount'];
    gatividhiYuktaMandalCount = json['GatividhiYuktaMandalCount'];
    gatividhiYuktaNagarCount = json['GatividhiYuktaNagarCount'];
    gatividhiYuktaNagarCountGraamin = json['GatividhiYuktaNagarCountGraamin'];
    gatividhiYuktaNagarCountShahari = json['GatividhiYuktaNagarCountShahari'];
    gatividhiYuktaShaharCount = json['GatividhiYuktaShaharCount'];
    gatividhiYuktaVastiCount = json['GatividhiYuktaVastiCount'];
    mandaliYuktaGraamCount = json['MandaliYuktaGraamCount'];
    mandaliYuktaMandalCount = json['MandaliYuktaMandalCount'];
    mandaliYuktaNagarCount = json['MandaliYuktaNagarCount'];
    mandaliYuktaNagarCountGraamin = json['MandaliYuktaNagarCountGraamin'];
    mandaliYuktaNagarCountShahari = json['MandaliYuktaNagarCountShahari'];
    mandaliYuktaShaharCount = json['MandaliYuktaShaharCount'];
    mandaliYuktaVastiCount = json['MandaliYuktaVastiCount'];
    saaptaahikYuktaGraamCount = json['SaaptaahikYuktaGraamCount'];
    saaptaahikYuktaMandalCount = json['SaaptaahikYuktaMandalCount'];
    saaptaahikYuktaNagarCount = json['SaaptaahikYuktaNagarCount'];
    saaptaahikYuktaNagarCountGraamin = json['SaaptaahikYuktaNagarCountGraamin'];
    saaptaahikYuktaNagarCountShahari = json['SaaptaahikYuktaNagarCountShahari'];
    saaptaahikYuktaShaharCount = json['SaaptaahikYuktaShaharCount'];
    saaptaahikYuktaVastiCount = json['SaaptaahikYuktaVastiCount'];
    shaakhaaYuktaGraamCount = json['ShaakhaaYuktaGraamCount'];
    shaakhaaYuktaMandalCount = json['ShaakhaaYuktaMandalCount'];
    shaakhaaYuktaNagarCount = json['ShaakhaaYuktaNagarCount'];
    shaakhaaYuktaNagarCountGraamin = json['ShaakhaaYuktaNagarCountGraamin'];
    shaakhaaYuktaNagarCountShahari = json['ShaakhaaYuktaNagarCountShahari'];
    shaakhaaYuktaShaharCount = json['ShaakhaaYuktaShaharCount'];
    shaakhaaYuktaVastiCount = json['ShaakhaaYuktaVastiCount'];
    totalGraamCount = json['TotalGraamCount'];
    totalMandalCount = json['TotalMandalCount'];
    totalNagarCount = json['TotalNagarCount'];
    totalNagarCountGraamin = json['TotalNagarCountGraamin'];
    totalNagarCountShahari = json['TotalNagarCountShahari'];
    totalShaakhaaCount = json['TotalShaakhaaCount'];
    totalShaharCount = json['TotalShaharCount'];
    totalVastiCount = json['TotalVastiCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GatividhiYuktaGraamCount'] = this.gatividhiYuktaGraamCount;
    data['GatividhiYuktaMandalCount'] = this.gatividhiYuktaMandalCount;
    data['GatividhiYuktaNagarCount'] = this.gatividhiYuktaNagarCount;
    data['GatividhiYuktaNagarCountGraamin'] = this.gatividhiYuktaNagarCountGraamin;
    data['GatividhiYuktaNagarCountShahari'] = this.gatividhiYuktaNagarCountShahari;
    data['GatividhiYuktaShaharCount'] = this.gatividhiYuktaShaharCount;
    data['GatividhiYuktaVastiCount'] = this.gatividhiYuktaVastiCount;
    data['MandaliYuktaGraamCount'] = this.mandaliYuktaGraamCount;
    data['MandaliYuktaMandalCount'] = this.mandaliYuktaMandalCount;
    data['MandaliYuktaNagarCount'] = this.mandaliYuktaNagarCount;
    data['MandaliYuktaNagarCountGraamin'] = this.mandaliYuktaNagarCountGraamin;
    data['MandaliYuktaNagarCountShahari'] = this.mandaliYuktaNagarCountShahari;
    data['MandaliYuktaShaharCount'] = this.mandaliYuktaShaharCount;
    data['MandaliYuktaVastiCount'] = this.mandaliYuktaVastiCount;
    data['SaaptaahikYuktaGraamCount'] = this.saaptaahikYuktaGraamCount;
    data['SaaptaahikYuktaMandalCount'] = this.saaptaahikYuktaMandalCount;
    data['SaaptaahikYuktaNagarCount'] = this.saaptaahikYuktaNagarCount;
    data['SaaptaahikYuktaNagarCountGraamin'] = this.saaptaahikYuktaNagarCountGraamin;
    data['SaaptaahikYuktaNagarCountShahari'] = this.saaptaahikYuktaNagarCountShahari;
    data['SaaptaahikYuktaShaharCount'] = this.saaptaahikYuktaShaharCount;
    data['SaaptaahikYuktaVastiCount'] = this.saaptaahikYuktaVastiCount;
    data['ShaakhaaYuktaGraamCount'] = this.shaakhaaYuktaGraamCount;
    data['ShaakhaaYuktaMandalCount'] = this.shaakhaaYuktaMandalCount;
    data['ShaakhaaYuktaNagarCount'] = this.shaakhaaYuktaNagarCount;
    data['ShaakhaaYuktaNagarCountGraamin'] = this.shaakhaaYuktaNagarCountGraamin;
    data['ShaakhaaYuktaNagarCountShahari'] = this.shaakhaaYuktaNagarCountShahari;
    data['ShaakhaaYuktaShaharCount'] = this.shaakhaaYuktaShaharCount;
    data['ShaakhaaYuktaVastiCount'] = this.shaakhaaYuktaVastiCount;
    data['TotalGraamCount'] = this.totalGraamCount;
    data['TotalMandalCount'] = this.totalMandalCount;
    data['TotalNagarCount'] = this.totalNagarCount;
    data['TotalNagarCountGraamin'] = this.totalNagarCountGraamin;
    data['TotalNagarCountShahari'] = this.totalNagarCountShahari;
    data['TotalShaakhaaCount'] = this.totalShaakhaaCount;
    data['TotalShaharCount'] = this.totalShaharCount;
    data['TotalVastiCount'] = this.totalVastiCount;
    return data;
  }
}

class GanaveshData {
  int? hasBelt;
  int? hasCap;
  int? hasDanda;
  int? hasPant;
  int? hasShirt;
  int? hasShoes;
  int? hasSocks;
  int? isGanaveshComplete;
  int? isYearNotFilled;

  GanaveshData({this.hasBelt, this.hasCap, this.hasDanda, this.hasPant, this.hasShirt, this.hasShoes, this.hasSocks, this.isGanaveshComplete, this.isYearNotFilled});

  GanaveshData.fromJson(Map<String, dynamic> json) {
    hasBelt = json['HasBelt'];
    hasCap = json['HasCap'];
    hasDanda = json['HasDanda'];
    hasPant = json['HasPant'];
    hasShirt = json['HasShirt'];
    hasShoes = json['HasShoes'];
    hasSocks = json['HasSocks'];
    isGanaveshComplete = json['IsGanaveshComplete'];
    isYearNotFilled = json['IsYearNotFilled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HasBelt'] = this.hasBelt;
    data['HasCap'] = this.hasCap;
    data['HasDanda'] = this.hasDanda;
    data['HasPant'] = this.hasPant;
    data['HasShirt'] = this.hasShirt;
    data['HasShoes'] = this.hasShoes;
    data['HasSocks'] = this.hasSocks;
    data['IsGanaveshComplete'] = this.isGanaveshComplete;
    data['IsYearNotFilled'] = this.isYearNotFilled;
    return data;
  }
}

class ListKaaryakartaaCountByAayaam {
  int? aayaamID;
  String? aayaamName;
  int? kaaryakartaaCount;

  ListKaaryakartaaCountByAayaam({this.aayaamID, this.aayaamName, this.kaaryakartaaCount});

  ListKaaryakartaaCountByAayaam.fromJson(Map<String, dynamic> json) {
    aayaamID = json['AayaamID'];
    aayaamName = json['AayaamName'];
    kaaryakartaaCount = json['KaaryakartaaCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AayaamID'] = this.aayaamID;
    data['AayaamName'] = this.aayaamName;
    data['KaaryakartaaCount'] = this.kaaryakartaaCount;
    return data;
  }
}

class ListKaaryakartaaCountByGatividhi {
  int? gatividhiID;
  String? gatividhiName;
  int? kaaryakartaaCount;

  ListKaaryakartaaCountByGatividhi({this.gatividhiID, this.gatividhiName, this.kaaryakartaaCount});

  ListKaaryakartaaCountByGatividhi.fromJson(Map<String, dynamic> json) {
    gatividhiID = json['GatividhiID'];
    gatividhiName = json['GatividhiName'];
    kaaryakartaaCount = json['KaaryakartaaCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GatividhiID'] = this.gatividhiID;
    data['GatividhiName'] = this.gatividhiName;
    data['KaaryakartaaCount'] = this.kaaryakartaaCount;
    return data;
  }
}

class ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation {
  String? areaOfOperation;
  int? areaOfOperationID;
  int? kaaryakartaaCount;

  ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation({this.areaOfOperation, this.areaOfOperationID, this.kaaryakartaaCount});

  ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation.fromJson(Map<String, dynamic> json) {
    areaOfOperation = json['AreaOfOperation'];
    areaOfOperationID = json['AreaOfOperationID'];
    kaaryakartaaCount = json['KaaryakartaaCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AreaOfOperation'] = this.areaOfOperation;
    data['AreaOfOperationID'] = this.areaOfOperationID;
    data['KaaryakartaaCount'] = this.kaaryakartaaCount;
    return data;
  }
}

class ListSankalpByAadhaar {
  String? sankalpAadhaar;
  int? sankalpitMasikMilankCount;
  int? sankalpitSaaptaahikCount;
  int? sankalpitSanghaMandalikCount;
  int? sankalpitShaakhaaCount;
  String? vayogatCode;
  int? vayogatID;

  ListSankalpByAadhaar(
      {this.sankalpAadhaar, this.sankalpitMasikMilankCount, this.sankalpitSaaptaahikCount, this.sankalpitSanghaMandalikCount, this.sankalpitShaakhaaCount, this.vayogatCode, this.vayogatID});

  ListSankalpByAadhaar.fromJson(Map<String, dynamic> json) {
    sankalpAadhaar = json['SankalpAadhaar'];
    sankalpitMasikMilankCount = json['SankalpitMasikMilankCount'];
    sankalpitSaaptaahikCount = json['SankalpitSaaptaahikCount'];
    sankalpitSanghaMandalikCount = json['SankalpitSanghaMandalikCount'];
    sankalpitShaakhaaCount = json['SankalpitShaakhaaCount'];
    vayogatCode = json['VayogatCode'];
    vayogatID = json['VayogatID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SankalpAadhaar'] = this.sankalpAadhaar;
    data['SankalpitMasikMilankCount'] = this.sankalpitMasikMilankCount;
    data['SankalpitSaaptaahikCount'] = this.sankalpitSaaptaahikCount;
    data['SankalpitSanghaMandalikCount'] = this.sankalpitSanghaMandalikCount;
    data['SankalpitShaakhaaCount'] = this.sankalpitShaakhaaCount;
    data['VayogatCode'] = this.vayogatCode;
    data['VayogatID'] = this.vayogatID;
    return data;
  }
}

class ListShaakhaaCountByVayogat {
  int? maasikMilanCount;
  int? saaptaahikCount;
  int? sanghaMandaliCount;
  int? sankalpitMaasikMilanCount;
  int? sankalpitSaaptaahikCount;
  int? sankalpitSanghaMandaliCount;
  int? sankalpitShaakhaaCount;
  int? shaakhaaCount;
  String? vayogatCode;
  int? vayogatID;

  ListShaakhaaCountByVayogat(
      {this.maasikMilanCount,
      this.saaptaahikCount,
      this.sanghaMandaliCount,
      this.sankalpitMaasikMilanCount,
      this.sankalpitSaaptaahikCount,
      this.sankalpitSanghaMandaliCount,
      this.sankalpitShaakhaaCount,
      this.shaakhaaCount,
      this.vayogatCode,
      this.vayogatID});

  ListShaakhaaCountByVayogat.fromJson(Map<String, dynamic> json) {
    maasikMilanCount = json['MaasikMilanCount'];
    saaptaahikCount = json['SaaptaahikCount'];
    sanghaMandaliCount = json['SanghaMandaliCount'];
    sankalpitMaasikMilanCount = json['SankalpitMaasikMilanCount'];
    sankalpitSaaptaahikCount = json['SankalpitSaaptaahikCount'];
    sankalpitSanghaMandaliCount = json['SankalpitSanghaMandaliCount'];
    sankalpitShaakhaaCount = json['SankalpitShaakhaaCount'];
    shaakhaaCount = json['ShaakhaaCount'];
    vayogatCode = json['VayogatCode'];
    vayogatID = json['VayogatID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MaasikMilanCount'] = this.maasikMilanCount;
    data['SaaptaahikCount'] = this.saaptaahikCount;
    data['SanghaMandaliCount'] = this.sanghaMandaliCount;
    data['SankalpitMaasikMilanCount'] = this.sankalpitMaasikMilanCount;
    data['SankalpitSaaptaahikCount'] = this.sankalpitSaaptaahikCount;
    data['SankalpitSanghaMandaliCount'] = this.sankalpitSanghaMandaliCount;
    data['SankalpitShaakhaaCount'] = this.sankalpitShaakhaaCount;
    data['ShaakhaaCount'] = this.shaakhaaCount;
    data['VayogatCode'] = this.vayogatCode;
    data['VayogatID'] = this.vayogatID;
    return data;
  }
}

class ListShaakhaaVruttaDetail {
  int? conductingDaysCount;
  String? frequencyCode;
  int? frequencyID;
  String? geoUnitName;
  int? shaakhaaID;

  ListShaakhaaVruttaDetail({this.conductingDaysCount, this.frequencyCode, this.frequencyID, this.geoUnitName, this.shaakhaaID});

  ListShaakhaaVruttaDetail.fromJson(Map<String, dynamic> json) {
    conductingDaysCount = json['ConductingDaysCount'];
    frequencyCode = json['FrequencyCode'];
    frequencyID = json['FrequencyID'];
    geoUnitName = json['GeoUnitName'];
    shaakhaaID = json['ShaakhaaID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ConductingDaysCount'] = this.conductingDaysCount;
    data['FrequencyCode'] = this.frequencyCode;
    data['FrequencyID'] = this.frequencyID;
    data['GeoUnitName'] = this.geoUnitName;
    data['ShaakhaaID'] = this.shaakhaaID;
    return data;
  }
}

class ListSocialOrganizationKaaryakartaaCountByAreaOfOperation {
  int? kaaryakartaaCount;
  int? mainAreaOfOperationID;
  String? areaOfOperation;

  ListSocialOrganizationKaaryakartaaCountByAreaOfOperation({this.kaaryakartaaCount, this.mainAreaOfOperationID, this.areaOfOperation});

  ListSocialOrganizationKaaryakartaaCountByAreaOfOperation.fromJson(Map<String, dynamic> json) {
    kaaryakartaaCount = json['KaaryakartaaCount'];
    mainAreaOfOperationID = json['MainAreaOfOperationID'];
    areaOfOperation = json['AreaOfOperation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['KaaryakartaaCount'] = this.kaaryakartaaCount;
    data['MainAreaOfOperationID'] = this.mainAreaOfOperationID;
    data['AreaOfOperation'] = this.areaOfOperation;
    return data;
  }
}

class ListSwayamsevakCountByStudentCategory {
  int? countByStudentCategory;
  int? studentCategoryID;
  String? studentCategoryName;

  ListSwayamsevakCountByStudentCategory({this.countByStudentCategory, this.studentCategoryID, this.studentCategoryName});

  ListSwayamsevakCountByStudentCategory.fromJson(Map<String, dynamic> json) {
    countByStudentCategory = json['CountByStudentCategory'];
    studentCategoryID = json['StudentCategoryID'];
    studentCategoryName = json['StudentCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CountByStudentCategory'] = this.countByStudentCategory;
    data['StudentCategoryID'] = this.studentCategoryID;
    data['StudentCategoryName'] = this.studentCategoryName;
    return data;
  }
}

class ListSwayamsevakCountByVyavasaayeeCategory {
  int? countByVyavasaayeeCategory;
  int? vyavasaayeeCategoryID;
  String? vyavasaayeeCategoryName;

  ListSwayamsevakCountByVyavasaayeeCategory({this.countByVyavasaayeeCategory, this.vyavasaayeeCategoryID, this.vyavasaayeeCategoryName});

  ListSwayamsevakCountByVyavasaayeeCategory.fromJson(Map<String, dynamic> json) {
    countByVyavasaayeeCategory = json['CountByVyavasaayeeCategory'];
    vyavasaayeeCategoryID = json['VyavasaayeeCategoryID'];
    vyavasaayeeCategoryName = json['VyavasaayeeCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CountByVyavasaayeeCategory'] = this.countByVyavasaayeeCategory;
    data['VyavasaayeeCategoryID'] = this.vyavasaayeeCategoryID;
    data['VyavasaayeeCategoryName'] = this.vyavasaayeeCategoryName;
    return data;
  }
}

class ListYesterdayPraantShaakhaaCountByVayogat {
  Null? maasikMilanCount;
  int? saaptaahikCount;
  Null? sanghaMandaliCount;
  Null? sankalpitMaasikMilanCount;
  Null? sankalpitSaaptaahikCount;
  Null? sankalpitSanghaMandaliCount;
  Null? sankalpitShaakhaaCount;
  int? shaakhaaCount;
  String? vayogatCode;
  int? vayogatID;

  ListYesterdayPraantShaakhaaCountByVayogat(
      {this.maasikMilanCount,
      this.saaptaahikCount,
      this.sanghaMandaliCount,
      this.sankalpitMaasikMilanCount,
      this.sankalpitSaaptaahikCount,
      this.sankalpitSanghaMandaliCount,
      this.sankalpitShaakhaaCount,
      this.shaakhaaCount,
      this.vayogatCode,
      this.vayogatID});

  ListYesterdayPraantShaakhaaCountByVayogat.fromJson(Map<String, dynamic> json) {
    maasikMilanCount = json['MaasikMilanCount'];
    saaptaahikCount = json['SaaptaahikCount'];
    sanghaMandaliCount = json['SanghaMandaliCount'];
    sankalpitMaasikMilanCount = json['SankalpitMaasikMilanCount'];
    sankalpitSaaptaahikCount = json['SankalpitSaaptaahikCount'];
    sankalpitSanghaMandaliCount = json['SankalpitSanghaMandaliCount'];
    sankalpitShaakhaaCount = json['SankalpitShaakhaaCount'];
    shaakhaaCount = json['ShaakhaaCount'];
    vayogatCode = json['VayogatCode'];
    vayogatID = json['VayogatID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MaasikMilanCount'] = this.maasikMilanCount;
    data['SaaptaahikCount'] = this.saaptaahikCount;
    data['SanghaMandaliCount'] = this.sanghaMandaliCount;
    data['SankalpitMaasikMilanCount'] = this.sankalpitMaasikMilanCount;
    data['SankalpitSaaptaahikCount'] = this.sankalpitSaaptaahikCount;
    data['SankalpitSanghaMandaliCount'] = this.sankalpitSanghaMandaliCount;
    data['SankalpitShaakhaaCount'] = this.sankalpitShaakhaaCount;
    data['ShaakhaaCount'] = this.shaakhaaCount;
    data['VayogatCode'] = this.vayogatCode;
    data['VayogatID'] = this.vayogatID;
    return data;
  }
}

class ListYesterdayVrutta {
  int? abhyaagatCount;
  int? baalVidyaarthiCount;
  String? frequencyCode;
  int? frequencyID;
  int? geoUnitID;
  String? geoUnitName;
  int? proudhaVyavasaayeeCount;
  int? shaakhaaID;
  int? shishuCount;
  int? tarunVidyaarthiCount;
  int? tarunVyavasaayeeCount;
  String? vayogatCode;
  int? vayogatID;

  ListYesterdayVrutta(
      {this.abhyaagatCount,
      this.baalVidyaarthiCount,
      this.frequencyCode,
      this.frequencyID,
      this.geoUnitID,
      this.geoUnitName,
      this.proudhaVyavasaayeeCount,
      this.shaakhaaID,
      this.shishuCount,
      this.tarunVidyaarthiCount,
      this.tarunVyavasaayeeCount,
      this.vayogatCode,
      this.vayogatID});

  ListYesterdayVrutta.fromJson(Map<String, dynamic> json) {
    abhyaagatCount = json['AbhyaagatCount'];
    baalVidyaarthiCount = json['BaalVidyaarthiCount'];
    frequencyCode = json['FrequencyCode'];
    frequencyID = json['FrequencyID'];
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    proudhaVyavasaayeeCount = json['ProudhaVyavasaayeeCount'];
    shaakhaaID = json['ShaakhaaID'];
    shishuCount = json['ShishuCount'];
    tarunVidyaarthiCount = json['TarunVidyaarthiCount'];
    tarunVyavasaayeeCount = json['TarunVyavasaayeeCount'];
    vayogatCode = json['VayogatCode'];
    vayogatID = json['VayogatID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbhyaagatCount'] = this.abhyaagatCount;
    data['BaalVidyaarthiCount'] = this.baalVidyaarthiCount;
    data['FrequencyCode'] = this.frequencyCode;
    data['FrequencyID'] = this.frequencyID;
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['ProudhaVyavasaayeeCount'] = this.proudhaVyavasaayeeCount;
    data['ShaakhaaID'] = this.shaakhaaID;
    data['ShishuCount'] = this.shishuCount;
    data['TarunVidyaarthiCount'] = this.tarunVidyaarthiCount;
    data['TarunVyavasaayeeCount'] = this.tarunVyavasaayeeCount;
    data['VayogatCode'] = this.vayogatCode;
    data['VayogatID'] = this.vayogatID;
    return data;
  }
}

class ListYesterdayVruttaSummary {
  int? geoUnitID;
  String? geoUnitName;
  int? milanMandaliCount;
  int? saaptaahikCount;
  int? shaakhaaCount;
  String? vayogatCode;
  int? vayogatID;

  ListYesterdayVruttaSummary({this.geoUnitID, this.geoUnitName, this.milanMandaliCount, this.saaptaahikCount, this.shaakhaaCount, this.vayogatCode, this.vayogatID});

  ListYesterdayVruttaSummary.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    milanMandaliCount = json['MilanMandaliCount'];
    saaptaahikCount = json['SaaptaahikCount'];
    shaakhaaCount = json['ShaakhaaCount'];
    vayogatCode = json['VayogatCode'];
    vayogatID = json['VayogatID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['MilanMandaliCount'] = this.milanMandaliCount;
    data['SaaptaahikCount'] = this.saaptaahikCount;
    data['ShaakhaaCount'] = this.shaakhaaCount;
    data['VayogatCode'] = this.vayogatCode;
    data['VayogatID'] = this.vayogatID;
    return data;
  }
}

class ShaakhaaVruttaSummaryData {
  int? maasikEQ0;
  int? maasikEQ1;
  int? saaptaahik1To3;
  int? saaptaahikEQ0;
  int? saaptaahikGTE4;
  int? shaakhaa1To24;
  int? shaakhaaEQ0;
  int? shaakhaaEQ30;
  int? shaakhaaGTE25;

  ShaakhaaVruttaSummaryData(
      {this.maasikEQ0, this.maasikEQ1, this.saaptaahik1To3, this.saaptaahikEQ0, this.saaptaahikGTE4, this.shaakhaa1To24, this.shaakhaaEQ0, this.shaakhaaEQ30, this.shaakhaaGTE25});

  ShaakhaaVruttaSummaryData.fromJson(Map<String, dynamic> json) {
    maasikEQ0 = json['MaasikEQ0'];
    maasikEQ1 = json['MaasikEQ1'];
    saaptaahik1To3 = json['Saaptaahik1To3'];
    saaptaahikEQ0 = json['SaaptaahikEQ0'];
    saaptaahikGTE4 = json['SaaptaahikGTE4'];
    shaakhaa1To24 = json['Shaakhaa1To24'];
    shaakhaaEQ0 = json['ShaakhaaEQ0'];
    shaakhaaEQ30 = json['ShaakhaaEQ30'];
    shaakhaaGTE25 = json['ShaakhaaGTE25'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MaasikEQ0'] = this.maasikEQ0;
    data['MaasikEQ1'] = this.maasikEQ1;
    data['Saaptaahik1To3'] = this.saaptaahik1To3;
    data['SaaptaahikEQ0'] = this.saaptaahikEQ0;
    data['SaaptaahikGTE4'] = this.saaptaahikGTE4;
    data['Shaakhaa1To24'] = this.shaakhaa1To24;
    data['ShaakhaaEQ0'] = this.shaakhaaEQ0;
    data['ShaakhaaEQ30'] = this.shaakhaaEQ30;
    data['ShaakhaaGTE25'] = this.shaakhaaGTE25;
    return data;
  }
}

class VehicleData {
  int? has2WVehicle;
  int? has3WVehicle;
  int? has4WVehicle;
  int? hasVehicleDriver;

  VehicleData({this.has2WVehicle, this.has3WVehicle, this.has4WVehicle, this.hasVehicleDriver});

  VehicleData.fromJson(Map<String, dynamic> json) {
    has2WVehicle = json['Has2WVehicle'];
    has3WVehicle = json['Has3WVehicle'];
    has4WVehicle = json['Has4WVehicle'];
    hasVehicleDriver = json['HasVehicleDriver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Has2WVehicle'] = this.has2WVehicle;
    data['Has3WVehicle'] = this.has3WVehicle;
    data['Has4WVehicle'] = this.has4WVehicle;
    data['HasVehicleDriver'] = this.hasVehicleDriver;
    return data;
  }
}

class BhaugolikVistaarRow {
  final String label;
  final int total;
  final int? shaakhaaYukta;
  final int? saaptaahikYukta;
  final int? mandaliYukta;
  final int? gatividhiYukta;

  const BhaugolikVistaarRow({
    required this.label,
    required this.total,
    this.shaakhaaYukta,
    this.saaptaahikYukta,
    this.mandaliYukta,
    this.gatividhiYukta,
  });
}
