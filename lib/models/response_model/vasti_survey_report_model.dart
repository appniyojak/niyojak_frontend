class VastiSurveyReportModel {
  String? message;
  String? status;
  Vastisarvekshan? vastisarvekshan;

  VastiSurveyReportModel({this.message, this.status, this.vastisarvekshan});

  VastiSurveyReportModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    vastisarvekshan = json['Vastisarvekshan'] != null
        ? new Vastisarvekshan.fromJson(json['Vastisarvekshan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.vastisarvekshan != null) {
      data['Vastisarvekshan'] = this.vastisarvekshan!.toJson();
    }
    return data;
  }
}

class Vastisarvekshan {
  int? sanghaPreritSansthaaKaaryakartaaCount;
  int? aayaamKaaryakartaaCount;
  int? socialOrganizationKaaryakartaaCount;
  int? gatividhiKaaryakartaaCount;
  int? akhilBhaaratiyaKaaryakartaaCount;
  int? baalCount;
  int? bhaagKaaryakartaaCount;
  int? dailyShaakhaaKaaryakartaaCount;
  int? dwitiyaVarshaShikshitCount;
  int? graamKaaryakartaaCount;
  int? kshetraKaaryakartaaCount;
  int? maasikMilanKaaryakartaaCount;
  int? mahaanagarKaaryakartaaCount;
  int? mandalKaaryakartaaCount;
  int? nagarKaaryakartaaCount;
  int? noShikshanCount;
  int? praantKaaryakartaaCount;
  int? praathamikShikshitCount;
  int? prarambhikShikshitCount;
  int? prathamVarshaShikshitCount;
  int? pratidnyitCount;
  int? pravaaseeKaaryakartaaCount;
  int? proudhaVyavasaayeeCount;
  int? saaptaahikMilanKaaryakartaaCount;
  int? shaharKaaryakartaaCount;
  int? shishuCount;
  int? tarunVidyaarthiCount;
  int? tarunVyavasaayeeCount;
  int? totalKaaryakartaaCount;
  int? totalSwayamsevakCount;
  int? trutiyaVarshaShikshitCount;
  int? unknownAgeCount;
  int? vastiKaaryakartaaCount;
  int? vibhaagKaaryakartaaCount;
  List<SanghaKaryaStithiData>? sanghaKaryaStithiData;
  List<VastiAnyaPrabhaviLok>? vastiAnyaPrabhaviLok;
  List<VastiBalopasanaCenterInfo>? vastiBalopasanaCenterInfo;
  String? vastiBhougolikSima;
  List<VastiDharmiknetData>? vastiDharmiknetData;
  List<VastiDurjanShaktiData>? vastiDurjanShaktiData;
  int? vastiFireBrigade;
  List<VastiGatividhiUpkram>? vastiGatividhiUpkram;
  List<VastiHinduVeerListData>? vastiHinduVeerListData;
  List<VastiJagranshreniInfo>? vastiJagranshreniInfo;
  List<VastiKaryakramcheThikanData>? vastiKaryakramcheThikanData;
  List<VastiKontyaPraantache>? vastiKontyaPraantache;
  List<VastiKontyaReligion>? vastiKontyaReligion;
  List<VastiMaidanListData>? vastiMaidanListData;
  List<VastiMotheHospitalInfo>? vastiMotheHospitalInfo;
  List<VastiMotheVyasayikCenterInfo>? vastiMotheVyasayikCenterInfo;
  int? vastiPoliceStation;
  String? vastiPramukhName;
  List<VastiSajjanShaktiData>? vastiSajjanShaktiData;
  List<VastiSamajikGarajaData>? vastiSamajikGarajaData;
  List<VastiSamajikKaryakram>? vastiSamajikKaryakram;
  int? vastiSamitiSadhyasyaCount;
  int? vastiSewaVastiCount;
  List<VastiShaikshanikSansthaData>? vastiShaikshanikSansthaData;
  List<VastiUpasanaSthalInfo>? vastiUpasanaSthalInfo;
  List<VastiVasahatPrakar>? vastiVasahatPrakar;
  List<VastiVividhBhashaBolnare>? vastiVividhBhashaBolnare;
  String? vastichaNakasha;
  String? vastichiLoksankhyaCount;
  List<VastitSajareHonareSan>? vastitSajareHonareSan;
  List<ListKaaryakartaaCountByGatividhi>? listKaaryakartaaCountByGatividhi;
  List<ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation>? listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation;
  List<ListKaaryakartaaCountByAayaam>? listKaaryakartaaCountByAayaam;
  List<ListSwayamsevakCountByStudentCategory>?
  listSwayamsevakCountByStudentCategory;
  List<ListSwayamsevakCountByVyavasaayeeCategory>?
  listSwayamsevakCountByVyavasaayeeCategory;
  List<VastisarvadiGharLoksankhya>? vastisarvadiGharLoksankhya;
  List<VastisarSewaPrakalpa>? vastisarSewaPrakalpa;
  List<VastisarvividhKshetaCheKam>? vastisarvividhKshetaCheKam;
  List<VastisarvividhSampradhaySatsangKendra>?
  vastisarvividhSampradhaySatsangKendra;
  List<VastisargavatilMumbaikar>? vastisargavatilMumbaikar;
  List<Religion>? religion;


  Vastisarvekshan(
      {
        this.gatividhiKaaryakartaaCount,
        this.aayaamKaaryakartaaCount,
        this.socialOrganizationKaaryakartaaCount,
        this.sanghaPreritSansthaaKaaryakartaaCount,
        this.akhilBhaaratiyaKaaryakartaaCount,
        this.baalCount,
        this.bhaagKaaryakartaaCount,
        this.dailyShaakhaaKaaryakartaaCount,
        this.dwitiyaVarshaShikshitCount,
        this.graamKaaryakartaaCount,
        this.kshetraKaaryakartaaCount,
        this.maasikMilanKaaryakartaaCount,
        this.mahaanagarKaaryakartaaCount,
        this.mandalKaaryakartaaCount,
        this.nagarKaaryakartaaCount,
        this.noShikshanCount,
        this.praantKaaryakartaaCount,
        this.praathamikShikshitCount,
        this.prarambhikShikshitCount,
        this.prathamVarshaShikshitCount,
        this.pratidnyitCount,
        this.pravaaseeKaaryakartaaCount,
        this.proudhaVyavasaayeeCount,
        this.saaptaahikMilanKaaryakartaaCount,
        this.shaharKaaryakartaaCount,
        this.shishuCount,
        this.tarunVidyaarthiCount,
        this.tarunVyavasaayeeCount,
        this.totalKaaryakartaaCount,
        this.totalSwayamsevakCount,
        this.trutiyaVarshaShikshitCount,
        this.unknownAgeCount,
        this.vastiKaaryakartaaCount,
        this.vibhaagKaaryakartaaCount,
        this.sanghaKaryaStithiData,
        this.vastiAnyaPrabhaviLok,
        this.vastiBalopasanaCenterInfo,
        this.vastiBhougolikSima,
        this.vastiDharmiknetData,
        this.vastiDurjanShaktiData,
        this.vastiFireBrigade,
        this.vastiGatividhiUpkram,
        this.vastiHinduVeerListData,
        this.vastiJagranshreniInfo,
        this.vastiKaryakramcheThikanData,
        this.vastiKontyaPraantache,
        this.vastiKontyaReligion,
        this.vastiMaidanListData,
        this.vastiMotheHospitalInfo,
        this.vastiMotheVyasayikCenterInfo,
        this.vastiPoliceStation,
        this.vastiPramukhName,
        this.vastiSajjanShaktiData,
        this.vastiSamajikGarajaData,
        this.vastiSamajikKaryakram,
        this.vastiSamitiSadhyasyaCount,
        this.vastiSewaVastiCount,
        this.vastiShaikshanikSansthaData,
        this.vastiUpasanaSthalInfo,
        this.vastiVasahatPrakar,
        this.vastiVividhBhashaBolnare,
        this.vastichaNakasha,
        this.vastichiLoksankhyaCount,
        this.vastitSajareHonareSan,
        this.listKaaryakartaaCountByGatividhi,
        this.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation,
        this.listKaaryakartaaCountByAayaam,
        this.listSwayamsevakCountByStudentCategory,
        this.listSwayamsevakCountByVyavasaayeeCategory,
        this.vastisarvadiGharLoksankhya,
        this.vastisarSewaPrakalpa,
        this.vastisarvividhKshetaCheKam,
        this.vastisarvividhSampradhaySatsangKendra,
        this.vastisargavatilMumbaikar,
        this.religion,
      });

  Vastisarvekshan.fromJson(Map<String, dynamic> json) {
    gatividhiKaaryakartaaCount = json['GatividhiKaaryakartaaCount'];
    akhilBhaaratiyaKaaryakartaaCount = json['AkhilBhaaratiyaKaaryakartaaCount'];
    aayaamKaaryakartaaCount = json['AayaamKaaryakartaaCount'];
    socialOrganizationKaaryakartaaCount = json['SocialOrganizationKaaryakartaaCount'];
    sanghaPreritSansthaaKaaryakartaaCount = json['SanghaPreritSansthaaKaaryakartaaCount'];
    baalCount = json['BaalCount'];
    bhaagKaaryakartaaCount = json['BhaagKaaryakartaaCount'];
    dailyShaakhaaKaaryakartaaCount = json['DailyShaakhaaKaaryakartaaCount'];
    dwitiyaVarshaShikshitCount = json['DwitiyaVarshaShikshitCount'];
    graamKaaryakartaaCount = json['GraamKaaryakartaaCount'];
    kshetraKaaryakartaaCount = json['KshetraKaaryakartaaCount'];
    maasikMilanKaaryakartaaCount = json['MaasikMilanKaaryakartaaCount'];
    mahaanagarKaaryakartaaCount = json['MahaanagarKaaryakartaaCount'];
    mandalKaaryakartaaCount = json['MandalKaaryakartaaCount'];
    nagarKaaryakartaaCount = json['NagarKaaryakartaaCount'];
    noShikshanCount = json['NoShikshanCount'];
    praantKaaryakartaaCount = json['PraantKaaryakartaaCount'];
    praathamikShikshitCount = json['PraathamikShikshitCount'];
    prarambhikShikshitCount = json['PrarambhikShikshitCount'];
    prathamVarshaShikshitCount = json['PrathamVarshaShikshitCount'];
    pratidnyitCount = json['PratidnyitCount'];
    pravaaseeKaaryakartaaCount = json['PravaaseeKaaryakartaaCount'];
    proudhaVyavasaayeeCount = json['ProudhaVyavasaayeeCount'];
    saaptaahikMilanKaaryakartaaCount = json['SaaptaahikMilanKaaryakartaaCount'];
    shaharKaaryakartaaCount = json['ShaharKaaryakartaaCount'];
    shishuCount = json['ShishuCount'];
    tarunVidyaarthiCount = json['TarunVidyaarthiCount'];
    tarunVyavasaayeeCount = json['TarunVyavasaayeeCount'];
    totalKaaryakartaaCount = json['TotalKaaryakartaaCount'];
    totalSwayamsevakCount = json['TotalSwayamsevakCount'];
    trutiyaVarshaShikshitCount = json['TrutiyaVarshaShikshitCount'];
    unknownAgeCount = json['UnknownAgeCount'];
    vastiKaaryakartaaCount = json['VastiKaaryakartaaCount'];
    vibhaagKaaryakartaaCount = json['VibhaagKaaryakartaaCount'];
    religion = json['Religion'];
    if (json['sanghaKaryaStithiData'] != null) {
      sanghaKaryaStithiData = <SanghaKaryaStithiData>[];
      json['sanghaKaryaStithiData'].forEach((v) {
        sanghaKaryaStithiData!.add(new SanghaKaryaStithiData.fromJson(v));
      });
    }
    if (json['vastiAnyaPrabhaviLok'] != null) {
      vastiAnyaPrabhaviLok = <VastiAnyaPrabhaviLok>[];
      json['vastiAnyaPrabhaviLok'].forEach((v) {
        vastiAnyaPrabhaviLok!.add(new VastiAnyaPrabhaviLok.fromJson(v));
      });
    }
    if (json['vastiBalopasanaCenterInfo'] != null) {
      vastiBalopasanaCenterInfo = <VastiBalopasanaCenterInfo>[];
      json['vastiBalopasanaCenterInfo'].forEach((v) {
        vastiBalopasanaCenterInfo!
            .add(new VastiBalopasanaCenterInfo.fromJson(v));
      });
    }
    vastiBhougolikSima = json['vastiBhougolikSima'];
    if (json['vastiDharmiknetData'] != null) {
      vastiDharmiknetData = <VastiDharmiknetData>[];
      json['vastiDharmiknetData'].forEach((v) {
        vastiDharmiknetData!.add(new VastiDharmiknetData.fromJson(v));
      });
    }
    if (json['vastiDurjanShaktiData'] != null) {
      vastiDurjanShaktiData = <VastiDurjanShaktiData>[];
      json['vastiDurjanShaktiData'].forEach((v) {
        vastiDurjanShaktiData!.add(new VastiDurjanShaktiData.fromJson(v));
      });
    }
    vastiFireBrigade = json['vastiFireBrigade'];
    if (json['vastiGatividhiUpkram'] != null) {
      vastiGatividhiUpkram = <VastiGatividhiUpkram>[];
      json['vastiGatividhiUpkram'].forEach((v) {
        vastiGatividhiUpkram!.add(new VastiGatividhiUpkram.fromJson(v));
      });
    }
    if (json['vastiHinduVeerListData'] != null) {
      vastiHinduVeerListData = <VastiHinduVeerListData>[];
      json['vastiHinduVeerListData'].forEach((v) {
        vastiHinduVeerListData!.add(new VastiHinduVeerListData.fromJson(v));
      });
    }
    if (json['vastiJagranshreniInfo'] != null) {
      vastiJagranshreniInfo = <VastiJagranshreniInfo>[];
      json['vastiJagranshreniInfo'].forEach((v) {
        vastiJagranshreniInfo!.add(new VastiJagranshreniInfo.fromJson(v));
      });
    }
    if (json['vastiKaryakramcheThikanData'] != null) {
      vastiKaryakramcheThikanData = <VastiKaryakramcheThikanData>[];
      json['vastiKaryakramcheThikanData'].forEach((v) {
        vastiKaryakramcheThikanData!
            .add(new VastiKaryakramcheThikanData.fromJson(v));
      });
    }
    if (json['vastiKontyaPraantache'] != null) {
      vastiKontyaPraantache = <VastiKontyaPraantache>[];
      json['vastiKontyaPraantache'].forEach((v) {
        vastiKontyaPraantache!.add(new VastiKontyaPraantache.fromJson(v));
      });
    }
    if (json['vastiKontyaReligion'] != null) {
      vastiKontyaReligion = <VastiKontyaReligion>[];
      json['vastiKontyaReligion'].forEach((v) {
        vastiKontyaReligion!.add(new VastiKontyaReligion.fromJson(v));
      });
    }
    if (json['vastiMaidanListData'] != null) {
      vastiMaidanListData = <VastiMaidanListData>[];
      json['vastiMaidanListData'].forEach((v) {
        vastiMaidanListData!.add(new VastiMaidanListData.fromJson(v));
      });
    }
    if (json['vastiMotheHospitalInfo'] != null) {
      vastiMotheHospitalInfo = <VastiMotheHospitalInfo>[];
      json['vastiMotheHospitalInfo'].forEach((v) {
        vastiMotheHospitalInfo!.add(new VastiMotheHospitalInfo.fromJson(v));
      });
    }
    if (json['vastiMotheVyasayikCenterInfo'] != null) {
      vastiMotheVyasayikCenterInfo = <VastiMotheVyasayikCenterInfo>[];
      json['vastiMotheVyasayikCenterInfo'].forEach((v) {
        vastiMotheVyasayikCenterInfo!
            .add(new VastiMotheVyasayikCenterInfo.fromJson(v));
      });
    }
    vastiPoliceStation = json['vastiPoliceStation'];
    vastiPramukhName = json['vastiPramukhName'];
    if (json['vastiSajjanShaktiData'] != null) {
      vastiSajjanShaktiData = <VastiSajjanShaktiData>[];
      json['vastiSajjanShaktiData'].forEach((v) {
        vastiSajjanShaktiData!.add(new VastiSajjanShaktiData.fromJson(v));
      });
    }
    if (json['vastiSamajikGarajaData'] != null) {
      vastiSamajikGarajaData = <VastiSamajikGarajaData>[];
      json['vastiSamajikGarajaData'].forEach((v) {
        vastiSamajikGarajaData!.add(new VastiSamajikGarajaData.fromJson(v));
      });
    }
    if (json['vastiSamajikKaryakram'] != null) {
      vastiSamajikKaryakram = <VastiSamajikKaryakram>[];
      json['vastiSamajikKaryakram'].forEach((v) {
        vastiSamajikKaryakram!.add(new VastiSamajikKaryakram.fromJson(v));
      });
    }
    vastiSamitiSadhyasyaCount = json['vastiSamitiSadhyasyaCount'];
    vastiSewaVastiCount = json['vastiSewaVastiCount'];
    if (json['vastiShaikshanikSansthaData'] != null) {
      vastiShaikshanikSansthaData = <VastiShaikshanikSansthaData>[];
      json['vastiShaikshanikSansthaData'].forEach((v) {
        vastiShaikshanikSansthaData!
            .add(new VastiShaikshanikSansthaData.fromJson(v));
      });
    }
    if (json['vastiUpasanaSthalInfo'] != null) {
      vastiUpasanaSthalInfo = <VastiUpasanaSthalInfo>[];
      json['vastiUpasanaSthalInfo'].forEach((v) {
        vastiUpasanaSthalInfo!.add(new VastiUpasanaSthalInfo.fromJson(v));
      });
    }
    if (json['vastiVasahatPrakar'] != null) {
      vastiVasahatPrakar = <VastiVasahatPrakar>[];
      json['vastiVasahatPrakar'].forEach((v) {
        vastiVasahatPrakar!.add(new VastiVasahatPrakar.fromJson(v));
      });
    }
    if (json['vastiVividhBhashaBolnare'] != null) {
      vastiVividhBhashaBolnare = <VastiVividhBhashaBolnare>[];
      json['vastiVividhBhashaBolnare'].forEach((v) {
        vastiVividhBhashaBolnare!.add(new VastiVividhBhashaBolnare.fromJson(v));
      });
    }
    vastichaNakasha = json['vastichaNakasha'];
    vastichiLoksankhyaCount = json['vastichiLoksankhyaCount'];
    if (json['vastitSajareHonareSan'] != null) {
      vastitSajareHonareSan = <VastitSajareHonareSan>[];
      json['vastitSajareHonareSan'].forEach((v) {
        vastitSajareHonareSan!.add(new VastitSajareHonareSan.fromJson(v));
      });
    }
    if (json['ListKaaryakartaaCountByGatividhi'] != null) {
      listKaaryakartaaCountByGatividhi = <ListKaaryakartaaCountByGatividhi>[];
      json['ListKaaryakartaaCountByGatividhi'].forEach((v) {
        listKaaryakartaaCountByGatividhi!
            .add(new ListKaaryakartaaCountByGatividhi.fromJson(v));
      });
    }
    if (json['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'] != null) {
      listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation = <ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation>[];
      json['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'].forEach((v) {
        listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!
            .add(new ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation.fromJson(v));
      });
    }
    if (json['ListKaaryakartaaCountByAayaam'] != null) {
      listKaaryakartaaCountByAayaam = <ListKaaryakartaaCountByAayaam>[];
      json['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'].forEach((v) {
        listKaaryakartaaCountByAayaam!
            .add(new ListKaaryakartaaCountByAayaam.fromJson(v));
      });
    }
    if (json['ListSwayamsevakCountByStudentCategory'] != null) {
      listSwayamsevakCountByStudentCategory = <ListSwayamsevakCountByStudentCategory>[];
      json['ListSwayamsevakCountByStudentCategory'].forEach((v) {
        listSwayamsevakCountByStudentCategory!
            .add(new ListSwayamsevakCountByStudentCategory.fromJson(v));
      });
    }
    if (json['ListSwayamsevakCountByVyavasaayeeCategory'] != null) {
      listSwayamsevakCountByVyavasaayeeCategory = <ListSwayamsevakCountByVyavasaayeeCategory>[];
      json['ListSwayamsevakCountByVyavasaayeeCategory'].forEach((v) {
        listSwayamsevakCountByVyavasaayeeCategory!
            .add(new ListSwayamsevakCountByVyavasaayeeCategory.fromJson(v));
      });
    }
    if (json['VastisarvadiGharLoksankhya'] != null) {
      vastisarvadiGharLoksankhya = <VastisarvadiGharLoksankhya>[];
      json['VastisarvadiGharLoksankhya'].forEach((v) {
        vastisarvadiGharLoksankhya!
            .add(new VastisarvadiGharLoksankhya.fromJson(v));
      });
    }
    if (json['VastisarSewaPrakalpa'] != null) {
      vastisarSewaPrakalpa = <VastisarSewaPrakalpa>[];
      json['VastisarSewaPrakalpa'].forEach((v) {
        vastisarSewaPrakalpa!
            .add(new VastisarSewaPrakalpa.fromJson(v));
      });
    }
    if (json['VastisarvividhKshetaCheKam'] != null) {
      vastisarvividhKshetaCheKam = <VastisarvividhKshetaCheKam>[];
      json['VastisarvividhKshetaCheKam'].forEach((v) {
        vastisarvividhKshetaCheKam!
            .add(new VastisarvividhKshetaCheKam.fromJson(v));
      });
    }
    if (json['VastisarvividhSampradhaySatsangKendra'] != null) {
      vastisarvividhSampradhaySatsangKendra =
      <VastisarvividhSampradhaySatsangKendra>[];
      json['VastisarvividhSampradhaySatsangKendra'].forEach((v) {
        vastisarvividhSampradhaySatsangKendra!
            .add(new VastisarvividhSampradhaySatsangKendra.fromJson(v));
      });
    }
    if (json['VastisargavatilMumbaikar'] != null) {
      vastisargavatilMumbaikar = <VastisargavatilMumbaikar>[];
      json['VastisargavatilMumbaikar'].forEach((v) {
        vastisargavatilMumbaikar!.add(new VastisargavatilMumbaikar.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AayaamKaaryakartaaCount'] = this.aayaamKaaryakartaaCount;
    data['SocialOrganizationKaaryakartaaCount'] = this.socialOrganizationKaaryakartaaCount;
    data['SanghaPreritSansthaaKaaryakartaaCount'] = this.sanghaPreritSansthaaKaaryakartaaCount;
    data['GatividhiKaaryakartaaCount'] =
        this.gatividhiKaaryakartaaCount;
    data['AkhilBhaaratiyaKaaryakartaaCount'] =
        this.akhilBhaaratiyaKaaryakartaaCount;
    data['BaalCount'] = this.baalCount;
    data['BhaagKaaryakartaaCount'] = this.bhaagKaaryakartaaCount;
    data['DailyShaakhaaKaaryakartaaCount'] =
        this.dailyShaakhaaKaaryakartaaCount;
    data['DwitiyaVarshaShikshitCount'] = this.dwitiyaVarshaShikshitCount;
    data['GraamKaaryakartaaCount'] = this.graamKaaryakartaaCount;
    data['KshetraKaaryakartaaCount'] = this.kshetraKaaryakartaaCount;
    data['MaasikMilanKaaryakartaaCount'] = this.maasikMilanKaaryakartaaCount;
    data['MahaanagarKaaryakartaaCount'] = this.mahaanagarKaaryakartaaCount;
    data['MandalKaaryakartaaCount'] = this.mandalKaaryakartaaCount;
    data['NagarKaaryakartaaCount'] = this.nagarKaaryakartaaCount;
    data['NoShikshanCount'] = this.noShikshanCount;
    data['PraantKaaryakartaaCount'] = this.praantKaaryakartaaCount;
    data['PraathamikShikshitCount'] = this.praathamikShikshitCount;
    data['PrarambhikShikshitCount'] = this.prarambhikShikshitCount;
    data['PrathamVarshaShikshitCount'] = this.prathamVarshaShikshitCount;
    data['PratidnyitCount'] = this.pratidnyitCount;
    data['PravaaseeKaaryakartaaCount'] = this.pravaaseeKaaryakartaaCount;
    data['ProudhaVyavasaayeeCount'] = this.proudhaVyavasaayeeCount;
    data['SaaptaahikMilanKaaryakartaaCount'] =
        this.saaptaahikMilanKaaryakartaaCount;
    data['ShaharKaaryakartaaCount'] = this.shaharKaaryakartaaCount;
    data['ShishuCount'] = this.shishuCount;
    data['TarunVidyaarthiCount'] = this.tarunVidyaarthiCount;
    data['TarunVyavasaayeeCount'] = this.tarunVyavasaayeeCount;
    data['TotalKaaryakartaaCount'] = this.totalKaaryakartaaCount;
    data['TotalSwayamsevakCount'] = this.totalSwayamsevakCount;
    data['TrutiyaVarshaShikshitCount'] = this.trutiyaVarshaShikshitCount;
    data['UnknownAgeCount'] = this.unknownAgeCount;
    data['VastiKaaryakartaaCount'] = this.vastiKaaryakartaaCount;
    data['VibhaagKaaryakartaaCount'] = this.vibhaagKaaryakartaaCount;
    data['Religion'] = this.religion;
    if (this.sanghaKaryaStithiData != null) {
      data['sanghaKaryaStithiData'] =
          this.sanghaKaryaStithiData!.map((v) => v.toJson()).toList();
    }
    if (this.vastiAnyaPrabhaviLok != null) {
      data['vastiAnyaPrabhaviLok'] =
          this.vastiAnyaPrabhaviLok!.map((v) => v.toJson()).toList();
    }
    if (this.vastiBalopasanaCenterInfo != null) {
      data['vastiBalopasanaCenterInfo'] =
          this.vastiBalopasanaCenterInfo!.map((v) => v.toJson()).toList();
    }
    data['vastiBhougolikSima'] = this.vastiBhougolikSima;
    if (this.vastiDharmiknetData != null) {
      data['vastiDharmiknetData'] =
          this.vastiDharmiknetData!.map((v) => v.toJson()).toList();
    }
    if (this.vastiDurjanShaktiData != null) {
      data['vastiDurjanShaktiData'] =
          this.vastiDurjanShaktiData!.map((v) => v.toJson()).toList();
    }
    data['vastiFireBrigade'] = this.vastiFireBrigade;
    if (this.vastiGatividhiUpkram != null) {
      data['vastiGatividhiUpkram'] =
          this.vastiGatividhiUpkram!.map((v) => v.toJson()).toList();
    }
    if (this.vastiHinduVeerListData != null) {
      data['vastiHinduVeerListData'] =
          this.vastiHinduVeerListData!.map((v) => v.toJson()).toList();
    }
    if (this.vastiJagranshreniInfo != null) {
      data['vastiJagranshreniInfo'] =
          this.vastiJagranshreniInfo!.map((v) => v.toJson()).toList();
    }
    if (this.vastiKaryakramcheThikanData != null) {
      data['vastiKaryakramcheThikanData'] =
          this.vastiKaryakramcheThikanData!.map((v) => v.toJson()).toList();
    }
    if (this.vastiKontyaPraantache != null) {
      data['vastiKontyaPraantache'] =
          this.vastiKontyaPraantache!.map((v) => v.toJson()).toList();
    }
    if (this.vastiKontyaReligion != null) {
      data['vastiKontyaReligion'] =
          this.vastiKontyaReligion!.map((v) => v.toJson()).toList();
    }
    if (this.vastiMaidanListData != null) {
      data['vastiMaidanListData'] =
          this.vastiMaidanListData!.map((v) => v.toJson()).toList();
    }
    if (this.vastiMotheHospitalInfo != null) {
      data['vastiMotheHospitalInfo'] =
          this.vastiMotheHospitalInfo!.map((v) => v.toJson()).toList();
    }
    if (this.vastiMotheVyasayikCenterInfo != null) {
      data['vastiMotheVyasayikCenterInfo'] =
          this.vastiMotheVyasayikCenterInfo!.map((v) => v.toJson()).toList();
    }
    data['vastiPoliceStation'] = this.vastiPoliceStation;
    data['vastiPramukhName'] = this.vastiPramukhName;
    if (this.vastiSajjanShaktiData != null) {
      data['vastiSajjanShaktiData'] =
          this.vastiSajjanShaktiData!.map((v) => v.toJson()).toList();
    }
    if (this.vastiSamajikGarajaData != null) {
      data['vastiSamajikGarajaData'] =
          this.vastiSamajikGarajaData!.map((v) => v.toJson()).toList();
    }
    if (this.vastiSamajikKaryakram != null) {
      data['vastiSamajikKaryakram'] =
          this.vastiSamajikKaryakram!.map((v) => v.toJson()).toList();
    }
    data['vastiSamitiSadhyasyaCount'] = this.vastiSamitiSadhyasyaCount;
    data['vastiSewaVastiCount'] = this.vastiSewaVastiCount;
    if (this.vastiShaikshanikSansthaData != null) {
      data['vastiShaikshanikSansthaData'] =
          this.vastiShaikshanikSansthaData!.map((v) => v.toJson()).toList();
    }
    if (this.vastiUpasanaSthalInfo != null) {
      data['vastiUpasanaSthalInfo'] =
          this.vastiUpasanaSthalInfo!.map((v) => v.toJson()).toList();
    }
    if (this.vastiVasahatPrakar != null) {
      data['vastiVasahatPrakar'] =
          this.vastiVasahatPrakar!.map((v) => v.toJson()).toList();
    }
    if (this.vastiVividhBhashaBolnare != null) {
      data['vastiVividhBhashaBolnare'] =
          this.vastiVividhBhashaBolnare!.map((v) => v.toJson()).toList();
    }
    data['vastichaNakasha'] = this.vastichaNakasha;
    data['vastichiLoksankhyaCount'] = this.vastichiLoksankhyaCount;
    if (this.vastitSajareHonareSan != null) {
      data['vastitSajareHonareSan'] =
          this.vastitSajareHonareSan!.map((v) => v.toJson()).toList();
    }
    if (this.listKaaryakartaaCountByGatividhi != null) {
      data['ListKaaryakartaaCountByGatividhi'] =
          this.listKaaryakartaaCountByGatividhi!.map((v) => v.toJson()).toList();
    }
    if (this.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation != null) {
      data['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'] =
          this.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.map((v) => v.toJson()).toList();
    }
    if (this.listKaaryakartaaCountByAayaam != null) {
      data['ListKaaryakartaaCountByAayaam'] =
          this.listKaaryakartaaCountByAayaam!.map((v) => v.toJson()).toList();
    }
    if (this.listSwayamsevakCountByStudentCategory != null) {
      data['ListSwayamsevakCountByStudentCategory'] =
          this.listSwayamsevakCountByStudentCategory!.map((v) => v.toJson()).toList();
    }
    if (this.listSwayamsevakCountByVyavasaayeeCategory != null) {
      data['ListSwayamsevakCountByVyavasaayeeCategory'] =
          this.listSwayamsevakCountByVyavasaayeeCategory!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarvadiGharLoksankhya != null) {
      data['VastisarvadiGharLoksankhya'] =
          this.vastisarvadiGharLoksankhya!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarSewaPrakalpa != null) {
      data['VastisarSewaPrakalpa'] =
          this.vastisarSewaPrakalpa!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarvividhKshetaCheKam != null) {
      data['VastisarvividhKshetaCheKam'] =
          this.vastisarvividhKshetaCheKam!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarvividhSampradhaySatsangKendra != null) {
      data['VastisarvividhSampradhaySatsangKendra'] = this
          .vastisarvividhSampradhaySatsangKendra!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.vastisargavatilMumbaikar != null) {
      data['VastisargavatilMumbaikar'] =
          this.vastisargavatilMumbaikar!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class SanghaKaryaStithiData {
  int? maasikMilanCount;
  String? purviSaptahik;
  String? purviShaakhaa;
  int? saaptaahikCount;
  int? sankalpitMaasikMilanCount;
  int? sankalpitSaaptaahikCount;
  int? sankalpitShaakhaaCount;
  int? shaakhaaCount;
  String? vayogatCode;
  int? vayogatID;

  SanghaKaryaStithiData(
      {this.maasikMilanCount,
        this.purviSaptahik,
        this.purviShaakhaa,
        this.saaptaahikCount,
        this.sankalpitMaasikMilanCount,
        this.sankalpitSaaptaahikCount,
        this.sankalpitShaakhaaCount,
        this.shaakhaaCount,
        this.vayogatCode,
        this.vayogatID});

  SanghaKaryaStithiData.fromJson(Map<String, dynamic> json) {
    maasikMilanCount = json['MaasikMilanCount'];
    purviSaptahik = json['PurviSaptahik'];
    purviShaakhaa = json['PurviShaakhaa'];
    saaptaahikCount = json['SaaptaahikCount'];
    sankalpitMaasikMilanCount = json['SankalpitMaasikMilanCount'];
    sankalpitSaaptaahikCount = json['SankalpitSaaptaahikCount'];
    sankalpitShaakhaaCount = json['SankalpitShaakhaaCount'];
    shaakhaaCount = json['ShaakhaaCount'];
    vayogatCode = json['VayogatCode'];
    vayogatID = json['VayogatID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MaasikMilanCount'] = this.maasikMilanCount;
    data['PurviSaptahik'] = this.purviSaptahik;
    data['PurviShaakhaa'] = this.purviShaakhaa;
    data['SaaptaahikCount'] = this.saaptaahikCount;
    data['SankalpitMaasikMilanCount'] = this.sankalpitMaasikMilanCount;
    data['SankalpitSaaptaahikCount'] = this.sankalpitSaaptaahikCount;
    data['SankalpitShaakhaaCount'] = this.sankalpitShaakhaaCount;
    data['ShaakhaaCount'] = this.shaakhaaCount;
    data['VayogatCode'] = this.vayogatCode;
    data['VayogatID'] = this.vayogatID;
    return data;
  }
}

class VastiAnyaPrabhaviLok {
  String? anyavisesamahiti;
  String? samparkasutranav;
  String? address;
  String? doorabhaash;
  int? isactive;
  String? name;
  String? otherupshrenee;
  String? otherupshrenee2;
  String? othervishesh;
  int? pkid;
  int? prabhaavkshetrid;
  int? samparksthitiid;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  String? selectedDropdownValueName3;
  String? selectedDropdownValueName4;
  String? selectedDropdownValueName5;
  int? shreneeid;
  int? upshreneeid;
  int? upshreneeid2;
  int? vastiid;
  int? visheshid;

  VastiAnyaPrabhaviLok(
      {this.anyavisesamahiti,
        this.samparkasutranav,
        this.address,
        this.doorabhaash,
        this.isactive,
        this.name,
        this.otherupshrenee,
        this.otherupshrenee2,
        this.othervishesh,
        this.pkid,
        this.prabhaavkshetrid,
        this.samparksthitiid,
        this.selectedDropdownValueName,
        this.selectedDropdownValueName1,
        this.selectedDropdownValueName2,
        this.selectedDropdownValueName3,
        this.selectedDropdownValueName4,
        this.selectedDropdownValueName5,
        this.shreneeid,
        this.upshreneeid,
        this.upshreneeid2,
        this.vastiid,
        this.visheshid});

  VastiAnyaPrabhaviLok.fromJson(Map<String, dynamic> json) {
    anyavisesamahiti = json['Anyavisesamahiti'];
    samparkasutranav = json['Samparkasutranav'];
    address = json['address'];
    doorabhaash = json['doorabhaash'];
    isactive = json['isactive'];
    name = json['name'];
    otherupshrenee = json['otherupshrenee'];
    otherupshrenee2 = json['otherupshrenee2'];
    othervishesh = json['othervishesh'];
    pkid = json['pkid'];
    prabhaavkshetrid = json['prabhaavkshetrid'];
    samparksthitiid = json['samparksthitiid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    selectedDropdownValueName2 = json['selectedDropdownValueName2'];
    selectedDropdownValueName3 = json['selectedDropdownValueName3'];
    selectedDropdownValueName4 = json['selectedDropdownValueName4'];
    selectedDropdownValueName5 = json['selectedDropdownValueName5'];
    shreneeid = json['shreneeid'];
    upshreneeid = json['upshreneeid'];
    upshreneeid2 = json['upshreneeid2'];
    vastiid = json['vastiid'];
    visheshid = json['visheshid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Anyavisesamahiti'] = this.anyavisesamahiti;
    data['Samparkasutranav'] = this.samparkasutranav;
    data['address'] = this.address;
    data['doorabhaash'] = this.doorabhaash;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['otherupshrenee'] = this.otherupshrenee;
    data['otherupshrenee2'] = this.otherupshrenee2;
    data['othervishesh'] = this.othervishesh;
    data['pkid'] = this.pkid;
    data['prabhaavkshetrid'] = this.prabhaavkshetrid;
    data['samparksthitiid'] = this.samparksthitiid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['selectedDropdownValueName2'] = this.selectedDropdownValueName2;
    data['selectedDropdownValueName3'] = this.selectedDropdownValueName3;
    data['selectedDropdownValueName4'] = this.selectedDropdownValueName4;
    data['selectedDropdownValueName5'] = this.selectedDropdownValueName5;
    data['shreneeid'] = this.shreneeid;
    data['upshreneeid'] = this.upshreneeid;
    data['upshreneeid2'] = this.upshreneeid2;
    data['vastiid'] = this.vastiid;
    data['visheshid'] = this.visheshid;
    return data;
  }
}

class VastiBalopasanaCenterInfo {
  int? isactive;
  String? konasathi;
  String? name;
  String? otherBalopasanaShreniName;
  int? pkid;
  String? selectedDropdownValueName;
  int? shreneeid;
  int? vastiid;

  VastiBalopasanaCenterInfo(
      {this.isactive,
        this.konasathi,
        this.name,
        this.otherBalopasanaShreniName,
        this.pkid,
        this.selectedDropdownValueName,
        this.shreneeid,
        this.vastiid});

  VastiBalopasanaCenterInfo.fromJson(Map<String, dynamic> json) {
    isactive = json['isactive'];
    konasathi = json['konasathi'];
    name = json['name'];
    otherBalopasanaShreniName = json['otherBalopasanaShreniName'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    shreneeid = json['shreneeid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isactive'] = this.isactive;
    data['konasathi'] = this.konasathi;
    data['name'] = this.name;
    data['otherBalopasanaShreniName'] = this.otherBalopasanaShreniName;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['shreneeid'] = this.shreneeid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiDharmiknetData {
  int? id;
  int? isactive;
  String? name;
  int? pkid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastiDharmiknetData(
      {this.id,
        this.isactive,
        this.name,
        this.pkid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastiDharmiknetData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiHinduVeerListData {
  int? id;
  int? isactive;
  String? name;
  int? pkid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastiHinduVeerListData(
      {this.id,
        this.isactive,
        this.name,
        this.pkid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastiHinduVeerListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiMaidanListData {
  int? id;
  int? isactive;
  String? name;
  int? pkid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastiMaidanListData(
      {this.id,
        this.isactive,
        this.name,
        this.pkid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastiMaidanListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiMotheHospitalInfo {
  int? id;
  int? isactive;
  String? name;
  int? pkid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastiMotheHospitalInfo(
      {this.id,
        this.isactive,
        this.name,
        this.pkid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastiMotheHospitalInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiMotheVyasayikCenterInfo {
  int? id;
  int? isactive;
  String? name;
  int? pkid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastiMotheVyasayikCenterInfo(
      {this.id,
        this.isactive,
        this.name,
        this.pkid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastiMotheVyasayikCenterInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiDurjanShaktiData {
  int? gunha;
  int? isactive;
  String? name;
  int? pkid;
  int? prakar;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  int? shiksha;
  int? vastiid;

  VastiDurjanShaktiData(
      {this.gunha,
        this.isactive,
        this.name,
        this.pkid,
        this.prakar,
        this.selectedDropdownValueName,
        this.selectedDropdownValueName1,
        this.selectedDropdownValueName2,
        this.shiksha,
        this.vastiid});

  VastiDurjanShaktiData.fromJson(Map<String, dynamic> json) {
    gunha = json['Gunha'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    prakar = json['prakar'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    selectedDropdownValueName2 = json['selectedDropdownValueName2'];
    shiksha = json['shiksha'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Gunha'] = this.gunha;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['prakar'] = this.prakar;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['selectedDropdownValueName2'] = this.selectedDropdownValueName2;
    data['shiksha'] = this.shiksha;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiGatividhiUpkram {
  int? varanvaritaid;
  int? gatividhiid;
  int? isactive;
  String? niyamitacalanareupakrama;
  String? otherVaranvarita;
  int? pkid;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  int? vastiid;

  VastiGatividhiUpkram(
      {this.varanvaritaid,
        this.gatividhiid,
        this.isactive,
        this.niyamitacalanareupakrama,
        this.otherVaranvarita,
        this.pkid,
        this.selectedDropdownValueName,
        this.selectedDropdownValueName1,
        this.vastiid});

  VastiGatividhiUpkram.fromJson(Map<String, dynamic> json) {
    varanvaritaid = json['Varanvaritaid'];
    gatividhiid = json['gatividhiid'];
    isactive = json['isactive'];
    niyamitacalanareupakrama = json['niyamitacalanareupakrama'];
    otherVaranvarita = json['otherVaranvarita'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Varanvaritaid'] = this.varanvaritaid;
    data['gatividhiid'] = this.gatividhiid;
    data['isactive'] = this.isactive;
    data['niyamitacalanareupakrama'] = this.niyamitacalanareupakrama;
    data['otherVaranvarita'] = this.otherVaranvarita;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiJagranshreniInfo {
  int? varanvaritaid;
  int? isactive;
  String? niyamitacalanareupakrama;
  String? otherVaranvarita;
  int? pkid;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  int? shreneeid;
  int? vastiid;

  VastiJagranshreniInfo(
      {this.varanvaritaid,
        this.isactive,
        this.niyamitacalanareupakrama,
        this.otherVaranvarita,
        this.pkid,
        this.selectedDropdownValueName,
        this.selectedDropdownValueName1,
        this.shreneeid,
        this.vastiid});

  VastiJagranshreniInfo.fromJson(Map<String, dynamic> json) {
    varanvaritaid = json['Varanvaritaid'];
    isactive = json['isactive'];
    niyamitacalanareupakrama = json['niyamitacalanareupakrama'];
    otherVaranvarita = json['otherVaranvarita'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    shreneeid = json['shreneeid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Varanvaritaid'] = this.varanvaritaid;
    data['isactive'] = this.isactive;
    data['niyamitacalanareupakrama'] = this.niyamitacalanareupakrama;
    data['otherVaranvarita'] = this.otherVaranvarita;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['shreneeid'] = this.shreneeid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiKaryakramcheThikanData {
  int? isactive;
  String? name;
  String? nivaaskshamata;
  int? nivasasathiupalabdha;
  int? pkid;
  int? prakaarid;
  int? prakaarid2;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  String? shamta;
  int? vastiid;

  VastiKaryakramcheThikanData(
      {this.isactive,
        this.name,
        this.nivaaskshamata,
        this.nivasasathiupalabdha,
        this.pkid,
        this.prakaarid,
        this.prakaarid2,
        this.selectedDropdownValueName,
        this.selectedDropdownValueName1,
        this.selectedDropdownValueName2,
        this.shamta,
        this.vastiid});

  VastiKaryakramcheThikanData.fromJson(Map<String, dynamic> json) {
    isactive = json['isactive'];
    name = json['name'];
    nivaaskshamata = json['nivaaskshamata'];
    nivasasathiupalabdha = json['nivasasathiupalabdha'];
    pkid = json['pkid'];
    prakaarid = json['prakaarid'];
    prakaarid2 = json['prakaarid2'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    selectedDropdownValueName2 = json['selectedDropdownValueName2'];
    shamta = json['shamta'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['nivaaskshamata'] = this.nivaaskshamata;
    data['nivasasathiupalabdha'] = this.nivasasathiupalabdha;
    data['pkid'] = this.pkid;
    data['prakaarid'] = this.prakaarid;
    data['prakaarid2'] = this.prakaarid2;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['selectedDropdownValueName2'] = this.selectedDropdownValueName2;
    data['shamta'] = this.shamta;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiKontyaPraantache {
  String? andaje;
  int? isactive;
  int? pkid;
  int? praantid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastiKontyaPraantache(
      {this.andaje,
        this.isactive,
        this.pkid,
        this.praantid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastiKontyaPraantache.fromJson(Map<String, dynamic> json) {
    andaje = json['Andaje'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    praantid = json['praantid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Andaje'] = this.andaje;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['praantid'] = this.praantid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiKontyaReligion {
  String? andaje;
  int? konatyarilijanaceid;
  int? isactive;
  int? pkid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastiKontyaReligion(
      {this.andaje,
        this.konatyarilijanaceid,
        this.isactive,
        this.pkid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastiKontyaReligion.fromJson(Map<String, dynamic> json) {
    andaje = json['Andaje'];
    konatyarilijanaceid = json['Konatyarilijanaceid'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Andaje'] = this.andaje;
    data['Konatyarilijanaceid'] = this.konatyarilijanaceid;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiSajjanShaktiData {
  String? samparkasutranava;
  String? address;
  String? doorabhaash;
  int? isactive;
  String? name;
  int? pkid;
  int? prabhaavkshetrid;
  int? samparksthitiid;
  String? sanstheCheNaav;
  String? sansthechaKuthalaPadavar;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  int? shreneeid;
  int? vastiid;
  int? visheshId;

  VastiSajjanShaktiData(
      {this.samparkasutranava,
        this.address,
        this.doorabhaash,
        this.isactive,
        this.name,
        this.pkid,
        this.prabhaavkshetrid,
        this.samparksthitiid,
        this.sanstheCheNaav,
        this.sansthechaKuthalaPadavar,
        this.selectedDropdownValueName,
        this.selectedDropdownValueName1,
        this.selectedDropdownValueName2,
        this.shreneeid,
        this.vastiid,
        this.visheshId});

  VastiSajjanShaktiData.fromJson(Map<String, dynamic> json) {
    samparkasutranava = json['Samparkasutranava'];
    address = json['address'];
    doorabhaash = json['doorabhaash'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    prabhaavkshetrid = json['prabhaavkshetrid'];
    samparksthitiid = json['samparksthitiid'];
    sanstheCheNaav = json['sanstheCheNaav'];
    sansthechaKuthalaPadavar = json['sansthechaKuthalaPadavar'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    selectedDropdownValueName2 = json['selectedDropdownValueName2'];
    shreneeid = json['shreneeid'];
    vastiid = json['vastiid'];
    visheshId = json['visheshId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Samparkasutranava'] = this.samparkasutranava;
    data['address'] = this.address;
    data['doorabhaash'] = this.doorabhaash;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['prabhaavkshetrid'] = this.prabhaavkshetrid;
    data['samparksthitiid'] = this.samparksthitiid;
    data['sanstheCheNaav'] = this.sanstheCheNaav;
    data['sansthechaKuthalaPadavar'] = this.sansthechaKuthalaPadavar;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['selectedDropdownValueName2'] = this.selectedDropdownValueName2;
    data['shreneeid'] = this.shreneeid;
    data['vastiid'] = this.vastiid;
    data['visheshId'] = this.visheshId;
    return data;
  }
}

class VastiSamajikGarajaData {
  int? id;
  int? isactive;
  String? name;
  String? otherNetrutwa;
  int? pkid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastiSamajikGarajaData(
      {this.id,
        this.isactive,
        this.name,
        this.otherNetrutwa,
        this.pkid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastiSamajikGarajaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    otherNetrutwa = json['otherNetrutwa'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['otherNetrutwa'] = this.otherNetrutwa;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiSamajikKaryakram {
  String? aayojaksamparksootr;
  String? ayojakancinave;
  String? ayojakasansthacinave;
  int? id;
  int? isactive;
  String? otherKaryakram;
  int? pkid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastiSamajikKaryakram(
      {this.aayojaksamparksootr,
        this.ayojakancinave,
        this.ayojakasansthacinave,
        this.id,
        this.isactive,
        this.otherKaryakram,
        this.pkid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastiSamajikKaryakram.fromJson(Map<String, dynamic> json) {
    aayojaksamparksootr = json['aayojaksamparksootr'];
    ayojakancinave = json['ayojakancinave'];
    ayojakasansthacinave = json['ayojakasansthacinave'];
    id = json['id'];
    isactive = json['isactive'];
    otherKaryakram = json['otherKaryakram'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aayojaksamparksootr'] = this.aayojaksamparksootr;
    data['ayojakancinave'] = this.ayojakancinave;
    data['ayojakasansthacinave'] = this.ayojakasansthacinave;
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['otherKaryakram'] = this.otherKaryakram;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiShaikshanikSansthaData {
  int? chaalakprakaar;
  int? isactive;
  int? maadhyam;
  int? milkat;
  String? name;
  int? pkid;
  int? prakaarid;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  String? selectedDropdownValueName3;
  String? selectedDropdownValueName4;
  int? shaikshaniksansthaan;
  int? vastiid;

  VastiShaikshanikSansthaData(
      {this.chaalakprakaar,
        this.isactive,
        this.maadhyam,
        this.milkat,
        this.name,
        this.pkid,
        this.prakaarid,
        this.selectedDropdownValueName,
        this.selectedDropdownValueName1,
        this.selectedDropdownValueName2,
        this.selectedDropdownValueName3,
        this.selectedDropdownValueName4,
        this.shaikshaniksansthaan,
        this.vastiid});

  VastiShaikshanikSansthaData.fromJson(Map<String, dynamic> json) {
    chaalakprakaar = json['chaalakprakaar'];
    isactive = json['isactive'];
    maadhyam = json['maadhyam'];
    milkat = json['milkat'];
    name = json['name'];
    pkid = json['pkid'];
    prakaarid = json['prakaarid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    selectedDropdownValueName2 = json['selectedDropdownValueName2'];
    selectedDropdownValueName3 = json['selectedDropdownValueName3'];
    selectedDropdownValueName4 = json['selectedDropdownValueName4'];
    shaikshaniksansthaan = json['shaikshaniksansthaan'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chaalakprakaar'] = this.chaalakprakaar;
    data['isactive'] = this.isactive;
    data['maadhyam'] = this.maadhyam;
    data['milkat'] = this.milkat;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['prakaarid'] = this.prakaarid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['selectedDropdownValueName2'] = this.selectedDropdownValueName2;
    data['selectedDropdownValueName3'] = this.selectedDropdownValueName3;
    data['selectedDropdownValueName4'] = this.selectedDropdownValueName4;
    data['shaikshaniksansthaan'] = this.shaikshaniksansthaan;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiUpasanaSthalInfo {
  int? isactive;
  String? otherupaasanasthala;
  int? pkid;
  int? prakarid;
  String? sankhya;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  int? upaasanasthalaid;
  int? vastiid;

  VastiUpasanaSthalInfo(
      {this.isactive,
        this.otherupaasanasthala,
        this.pkid,
        this.prakarid,
        this.sankhya,
        this.selectedDropdownValueName,
        this.selectedDropdownValueName1,
        this.upaasanasthalaid,
        this.vastiid});

  VastiUpasanaSthalInfo.fromJson(Map<String, dynamic> json) {
    isactive = json['isactive'];
    otherupaasanasthala = json['otherupaasanasthala'];
    pkid = json['pkid'];
    prakarid = json['prakarid'];
    sankhya = json['sankhya'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    upaasanasthalaid = json['upaasanasthalaid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isactive'] = this.isactive;
    data['otherupaasanasthala'] = this.otherupaasanasthala;
    data['pkid'] = this.pkid;
    data['prakarid'] = this.prakarid;
    data['sankhya'] = this.sankhya;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['upaasanasthalaid'] = this.upaasanasthalaid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiVasahatPrakar {
  String? bhavanachenav;
  String? doorabhaash;
  int? isactive;
  int? pkid;
  int? prakarid;
  String? samparksootr;
  int? samparksthitiid;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  int? vastiid;

  VastiVasahatPrakar(
      {this.bhavanachenav,
        this.doorabhaash,
        this.isactive,
        this.pkid,
        this.prakarid,
        this.samparksootr,
        this.samparksthitiid,
        this.selectedDropdownValueName,
        this.selectedDropdownValueName1,
        this.vastiid});

  VastiVasahatPrakar.fromJson(Map<String, dynamic> json) {
    bhavanachenav = json['bhavanachenav'];
    doorabhaash = json['doorabhaash'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    prakarid = json['prakarid'];
    samparksootr = json['samparksootr'];
    samparksthitiid = json['samparksthitiid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bhavanachenav'] = this.bhavanachenav;
    data['doorabhaash'] = this.doorabhaash;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['prakarid'] = this.prakarid;
    data['samparksootr'] = this.samparksootr;
    data['samparksthitiid'] = this.samparksthitiid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastiVividhBhashaBolnare {
  String? andaje;
  int? bhaashaid;
  int? isactive;
  String? otherbhaasha;
  int? pkid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastiVividhBhashaBolnare(
      {this.andaje,
        this.bhaashaid,
        this.isactive,
        this.otherbhaasha,
        this.pkid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastiVividhBhashaBolnare.fromJson(Map<String, dynamic> json) {
    andaje = json['Andaje'];
    bhaashaid = json['bhaashaid'];
    isactive = json['isactive'];
    otherbhaasha = json['otherbhaasha'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Andaje'] = this.andaje;
    data['bhaashaid'] = this.bhaashaid;
    data['isactive'] = this.isactive;
    data['otherbhaasha'] = this.otherbhaasha;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastitSajareHonareSan {
  String? aayojaksamparksootr;
  String? ayojakancinave;
  String? ayojakasansthacinave;
  int? id;
  int? isactive;
  String? otherSajareSan;
  int? pkid;
  String? selectedDropdownValueName;
  int? vastiid;

  VastitSajareHonareSan(
      {this.aayojaksamparksootr,
        this.ayojakancinave,
        this.ayojakasansthacinave,
        this.id,
        this.isactive,
        this.otherSajareSan,
        this.pkid,
        this.selectedDropdownValueName,
        this.vastiid});

  VastitSajareHonareSan.fromJson(Map<String, dynamic> json) {
    aayojaksamparksootr = json['aayojaksamparksootr'];
    ayojakancinave = json['ayojakancinave'];
    ayojakasansthacinave = json['ayojakasansthacinave'];
    id = json['id'];
    isactive = json['isactive'];
    otherSajareSan = json['otherSajareSan'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aayojaksamparksootr'] = this.aayojaksamparksootr;
    data['ayojakancinave'] = this.ayojakancinave;
    data['ayojakasansthacinave'] = this.ayojakasansthacinave;
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['otherSajareSan'] = this.otherSajareSan;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class ListKaaryakartaaCountByGatividhi {
  int? gatividhiID;
  String? gatividhiName;
  int? kaaryakartaaCount;

  ListKaaryakartaaCountByGatividhi(
      {this.gatividhiID, this.gatividhiName, this.kaaryakartaaCount});

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

  ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation(
      {this.areaOfOperation, this.areaOfOperationID, this.kaaryakartaaCount});

  ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation.fromJson(
      Map<String, dynamic> json) {
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

class ListKaaryakartaaCountByAayaam {
  int? aayaamID;
  String? aayaamName;
  int? kaaryakartaaCount;

  ListKaaryakartaaCountByAayaam(
      {this.aayaamID, this.aayaamName, this.kaaryakartaaCount});

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

class ListSwayamsevakCountByStudentCategory {
  int? countByStudentCategory;
  int? studentCategoryID;
  String? studentCategoryName;

  ListSwayamsevakCountByStudentCategory(
      {this.countByStudentCategory,
        this.studentCategoryID,
        this.studentCategoryName});

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

  ListSwayamsevakCountByVyavasaayeeCategory(
      {this.countByVyavasaayeeCategory,
        this.vyavasaayeeCategoryID,
        this.vyavasaayeeCategoryName});

  ListSwayamsevakCountByVyavasaayeeCategory.fromJson(
      Map<String, dynamic> json) {
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

class VastisarvadiGharLoksankhya {
  String? andajeGhar;
  String? andajeLoksankhya;
  int? isactive;
  int? pkid;
  String? vadiCheNav;
  int? vastiid;

  VastisarvadiGharLoksankhya(
      {this.andajeGhar,
        this.andajeLoksankhya,
        this.isactive,
        this.pkid,
        this.vadiCheNav,
        this.vastiid});

  VastisarvadiGharLoksankhya.fromJson(Map<String, dynamic> json) {
    andajeGhar = json['andajeGhar'];
    andajeLoksankhya = json['andajeLoksankhya'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    vadiCheNav = json['vadiCheNav'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['andajeGhar'] = this.andajeGhar;
    data['andajeLoksankhya'] = this.andajeLoksankhya;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['vadiCheNav'] = this.vadiCheNav;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarSewaPrakalpa {
  int? isactive;
  String? otherSewaPrakalpaChalavinareShanstha;
  String? otherSewaPrakalpaPrakaar;
  int? pkid;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  int? sewaPrakalpaPrakaarId;
  int? sewaprakalpaChalvanariSansthaId;
  int? vastiid;

  VastisarSewaPrakalpa(
      {this.isactive,
        this.otherSewaPrakalpaChalavinareShanstha,
        this.otherSewaPrakalpaPrakaar,
        this.pkid,
        this.selectedDropdownValueName,
        this.selectedDropdownValueName1,
        this.sewaPrakalpaPrakaarId,
        this.sewaprakalpaChalvanariSansthaId,
        this.vastiid});

  VastisarSewaPrakalpa.fromJson(Map<String, dynamic> json) {
    isactive = json['isactive'];
    otherSewaPrakalpaChalavinareShanstha =
    json['otherSewaPrakalpaChalavinareShanstha'];
    otherSewaPrakalpaPrakaar = json['otherSewaPrakalpaPrakaar'];
    pkid = json['pkid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    sewaPrakalpaPrakaarId = json['sewaPrakalpaPrakaarId'];
    sewaprakalpaChalvanariSansthaId = json['sewaprakalpaChalvanariSansthaId'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isactive'] = this.isactive;
    data['otherSewaPrakalpaChalavinareShanstha'] =
        this.otherSewaPrakalpaChalavinareShanstha;
    data['otherSewaPrakalpaPrakaar'] = this.otherSewaPrakalpaPrakaar;
    data['pkid'] = this.pkid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['sewaPrakalpaPrakaarId'] = this.sewaPrakalpaPrakaarId;
    data['sewaprakalpaChalvanariSansthaId'] =
        this.sewaprakalpaChalvanariSansthaId;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarvividhKshetaCheKam {
  String? chalavnariSansthaSanghatamn;
  int? isactive;
  String? kaam;
  int? pkid;
  int? vastiid;

  VastisarvividhKshetaCheKam(
      {this.chalavnariSansthaSanghatamn,
        this.isactive,
        this.kaam,
        this.pkid,
        this.vastiid});

  VastisarvividhKshetaCheKam.fromJson(Map<String, dynamic> json) {
    chalavnariSansthaSanghatamn = json['chalavnariSansthaSanghatamn'];
    isactive = json['isactive'];
    kaam = json['kaam'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chalavnariSansthaSanghatamn'] = this.chalavnariSansthaSanghatamn;
    data['isactive'] = this.isactive;
    data['kaam'] = this.kaam;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarvividhSampradhaySatsangKendra {
  int? aadhyatmikKendraId;
  String? gaavPramukhName;
  String? isOtherAdhyatmitKendra;
  int? isactive;
  int? pkid;
  String? samparkSootra;
  String? selectedDropdownValueName;
  int? vastiid;

  VastisarvividhSampradhaySatsangKendra(
      {this.aadhyatmikKendraId,
        this.gaavPramukhName,
        this.isOtherAdhyatmitKendra,
        this.isactive,
        this.pkid,
        this.samparkSootra,
        this.selectedDropdownValueName,
        this.vastiid});

  VastisarvividhSampradhaySatsangKendra.fromJson(Map<String, dynamic> json) {
    aadhyatmikKendraId = json['aadhyatmikKendraId'];
    gaavPramukhName = json['gaavPramukhName'];
    isOtherAdhyatmitKendra = json['isOtherAdhyatmitKendra'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    samparkSootra = json['samparkSootra'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aadhyatmikKendraId'] = this.aadhyatmikKendraId;
    data['gaavPramukhName'] = this.gaavPramukhName;
    data['isOtherAdhyatmitKendra'] = this.isOtherAdhyatmitKendra;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['samparkSootra'] = this.samparkSootra;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisargavatilMumbaikar {
  String? doorbhash;
  int? isactive;
  int? pkid;
  String? pramukhachrNaav;
  String? sthaan;
  int? vastiid;

  VastisargavatilMumbaikar(
      {this.doorbhash,
        this.isactive,
        this.pkid,
        this.pramukhachrNaav,
        this.sthaan,
        this.vastiid});

  VastisargavatilMumbaikar.fromJson(Map<String, dynamic> json) {
    doorbhash = json['doorbhash'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    pramukhachrNaav = json['pramukhachrNaav'];
    sthaan = json['sthaan'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doorbhash'] = this.doorbhash;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['pramukhachrNaav'] = this.pramukhachrNaav;
    data['sthaan'] = this.sthaan;
    data['vastiid'] = this.vastiid;
    return data;
  }
}
class Religion {
  int? count;
  Null? nivasasathiupalabdha;
  int? sankhya;
  String? value;

  Religion({this.count, this.nivasasathiupalabdha, this.sankhya, this.value});

  Religion.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    nivasasathiupalabdha = json['nivasasathiupalabdha'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['nivasasathiupalabdha'] = this.nivasasathiupalabdha;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}