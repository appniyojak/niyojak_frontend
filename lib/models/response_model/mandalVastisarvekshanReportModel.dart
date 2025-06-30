import 'package:niyojak_prod/models/response_model/nagar_vasti_model.dart';

class MandalVastisarvekshanReportModel {
  List<Hinduvirayadi>? hinduvirayadi;
  String? message;
  String? status;
  List<Anyaprabhavilok>? anyaprabhavilok;
  List<Durjanshakti>? durjanshakti;
  Loksankhyaformandal? loksankhyaformandal;
  List<Durjanshakti>? mahatvacesana;
  MandalVastisarvekshanReportwithname? mandalVastisarvekshanReportwithname;
  Mandaldata? mandaldata;
  List<Sajjanshakkati>? sajjanshakkati;
  List<Durjanshakti>? samajikkaryakram;
  List<Durjanshakti>? religion;
  List<SewaPrakalpa>? sewaPrakalpa;
  List<Upaasana>? upaasana;
  List<Durjanshakti>? vividhKshetaCheKam;
  List<VividhSampradhaySatsang>? vividhSampradhaySatsang;
  List<ListSwayamsevakCountByVyavasaayeeCategory>?
      listSwayamsevakCountByVyavasaayeeCategory;
  List<KaaryakartaaCountByAayaam>? kaaryakartaaCountByAayaam;
  List<SwayamsevakCountByStudentCategory>? swayamsevakCountByStudentCategory;
  List<SocialOrganizationKaaryakartaaCountByAreaOfOperation>?
      socialOrganizationKaaryakartaaCountByAreaOfOperation;
  List<SanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation>?
      sanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation;
  List<KaaryakartaaCountByGatividhi>? kaaryakartaaCountByGatividhi;

  MandalVastisarvekshanReportModel({
    this.hinduvirayadi,
    this.message,
    this.status,
    this.anyaprabhavilok,
    this.durjanshakti,
    this.loksankhyaformandal,
    this.mahatvacesana,
    this.mandalVastisarvekshanReportwithname,
    this.mandaldata,
    this.sajjanshakkati,
    this.samajikkaryakram,
    this.religion,
    this.sewaPrakalpa,
    this.upaasana,
    this.vividhKshetaCheKam,
    this.vividhSampradhaySatsang,
    this.listSwayamsevakCountByVyavasaayeeCategory,
    this.kaaryakartaaCountByAayaam,
    this.swayamsevakCountByStudentCategory,
    this.socialOrganizationKaaryakartaaCountByAreaOfOperation,
    this.sanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation,
    this.kaaryakartaaCountByGatividhi,
  });

  MandalVastisarvekshanReportModel.fromJson(Map<String, dynamic> json) {
    if (json['Hinduvirayadi'] != null) {
      hinduvirayadi = <Hinduvirayadi>[];
      json['Hinduvirayadi'].forEach((v) {
        hinduvirayadi!.add(new Hinduvirayadi.fromJson(v));
      });
    }
    message = json['Message'];
    status = json['Status'];
    if (json['anyaprabhavilok'] != null) {
      anyaprabhavilok = <Anyaprabhavilok>[];
      json['anyaprabhavilok'].forEach((v) {
        anyaprabhavilok!.add(new Anyaprabhavilok.fromJson(v));
      });
    }
    if (json['durjanshakti'] != null) {
      durjanshakti = <Durjanshakti>[];
      json['durjanshakti'].forEach((v) {
        durjanshakti!.add(new Durjanshakti.fromJson(v));
      });
    }
    loksankhyaformandal = json['loksankhyaformandal'] != null
        ? new Loksankhyaformandal.fromJson(json['loksankhyaformandal'])
        : null;
    if (json['mahatvacesana'] != null) {
      mahatvacesana = <Durjanshakti>[];
      json['mahatvacesana'].forEach((v) {
        mahatvacesana!.add(new Durjanshakti.fromJson(v));
      });
    }
    mandalVastisarvekshanReportwithname =
        json['mandalVastisarvekshanReportwithname'] != null
            ? new MandalVastisarvekshanReportwithname.fromJson(
                json['mandalVastisarvekshanReportwithname'])
            : null;
    mandaldata = json['mandaldata'] != null
        ? new Mandaldata.fromJson(json['mandaldata'])
        : null;
    if (json['sajjanshakkati'] != null) {
      sajjanshakkati = <Sajjanshakkati>[];
      json['sajjanshakkati'].forEach((v) {
        sajjanshakkati!.add(new Sajjanshakkati.fromJson(v));
      });
    }
    if (json['samajikkaryakram'] != null) {
      samajikkaryakram = <Durjanshakti>[];
      json['samajikkaryakram'].forEach((v) {
        samajikkaryakram!.add(new Durjanshakti.fromJson(v));
      });
    }
    if (json['Religion'] != null) {
      religion = <Durjanshakti>[];
      json['Religion'].forEach((v) {
        religion!.add(new Durjanshakti.fromJson(v));
      });
    }
    if (json['sewaPrakalpa'] != null) {
      sewaPrakalpa = <SewaPrakalpa>[];
      json['sewaPrakalpa'].forEach((v) {
        sewaPrakalpa!.add(new SewaPrakalpa.fromJson(v));
      });
    }
    if (json['upaasana'] != null) {
      upaasana = <Upaasana>[];
      json['upaasana'].forEach((v) {
        upaasana!.add(new Upaasana.fromJson(v));
      });
    }
    if (json['vividhKshetaCheKam'] != null) {
      vividhKshetaCheKam = <Durjanshakti>[];
      json['vividhKshetaCheKam'].forEach((v) {
        vividhKshetaCheKam!.add(new Durjanshakti.fromJson(v));
      });
    }
    if (json['vividhSampradhaySatsang'] != null) {
      vividhSampradhaySatsang = <VividhSampradhaySatsang>[];
      json['vividhSampradhaySatsang'].forEach((v) {
        vividhSampradhaySatsang!.add(new VividhSampradhaySatsang.fromJson(v));
      });
    }
    if (json['SwayamsevakCountByVyavasaayeeCategory'] != null) {
      listSwayamsevakCountByVyavasaayeeCategory =
          <ListSwayamsevakCountByVyavasaayeeCategory>[];
      json['SwayamsevakCountByVyavasaayeeCategory'].forEach((v) {
        listSwayamsevakCountByVyavasaayeeCategory!
            .add(new ListSwayamsevakCountByVyavasaayeeCategory.fromJson(v));
      });
    }
    if (json['KaaryakartaaCountByAayaam'] != null) {
      kaaryakartaaCountByAayaam = <KaaryakartaaCountByAayaam>[];
      json['KaaryakartaaCountByAayaam'].forEach((v) {
        kaaryakartaaCountByAayaam!
            .add(new KaaryakartaaCountByAayaam.fromJson(v));
      });
    }
    if (json['SwayamsevakCountByStudentCategory'] != null) {
      swayamsevakCountByStudentCategory = <SwayamsevakCountByStudentCategory>[];
      json['SwayamsevakCountByStudentCategory'].forEach((v) {
        swayamsevakCountByStudentCategory!
            .add(new SwayamsevakCountByStudentCategory.fromJson(v));
      });
    }
    if (json['SocialOrganizationKaaryakartaaCountByAreaOfOperation'] != null) {
      socialOrganizationKaaryakartaaCountByAreaOfOperation =
          <SocialOrganizationKaaryakartaaCountByAreaOfOperation>[];
      json['SocialOrganizationKaaryakartaaCountByAreaOfOperation'].forEach((v) {
        socialOrganizationKaaryakartaaCountByAreaOfOperation!.add(
            new SocialOrganizationKaaryakartaaCountByAreaOfOperation.fromJson(
                v));
      });
    }
    if (json['SanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'] !=
        null) {
      sanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation =
          <SanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation>[];
      json['SanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation']
          .forEach((v) {
        sanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.add(
            new SanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation.fromJson(
                v));
      });
    }
    if (json['KaaryakartaaCountByGatividhi'] != null) {
      kaaryakartaaCountByGatividhi = <KaaryakartaaCountByGatividhi>[];
      json['KaaryakartaaCountByGatividhi'].forEach((v) {
        kaaryakartaaCountByGatividhi!
            .add(new KaaryakartaaCountByGatividhi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hinduvirayadi != null) {
      data['Hinduvirayadi'] =
          this.hinduvirayadi!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.anyaprabhavilok != null) {
      data['anyaprabhavilok'] =
          this.anyaprabhavilok!.map((v) => v.toJson()).toList();
    }
    if (this.durjanshakti != null) {
      data['durjanshakti'] = this.durjanshakti!.map((v) => v.toJson()).toList();
    }
    if (this.loksankhyaformandal != null) {
      data['loksankhyaformandal'] = this.loksankhyaformandal!.toJson();
    }
    if (this.mahatvacesana != null) {
      data['mahatvacesana'] =
          this.mahatvacesana!.map((v) => v.toJson()).toList();
    }
    if (this.mandalVastisarvekshanReportwithname != null) {
      data['mandalVastisarvekshanReportwithname'] =
          this.mandalVastisarvekshanReportwithname!.toJson();
    }
    if (this.mandaldata != null) {
      data['mandaldata'] = this.mandaldata!.toJson();
    }
    if (this.sajjanshakkati != null) {
      data['sajjanshakkati'] =
          this.sajjanshakkati!.map((v) => v.toJson()).toList();
    }
    if (this.samajikkaryakram != null) {
      data['samajikkaryakram'] =
          this.samajikkaryakram!.map((v) => v.toJson()).toList();
    }
    if (this.religion != null) {
      data['Religion'] = this.religion!.map((v) => v.toJson()).toList();
    }
    if (this.sewaPrakalpa != null) {
      data['sewaPrakalpa'] = this.sewaPrakalpa!.map((v) => v.toJson()).toList();
    }
    if (this.upaasana != null) {
      data['upaasana'] = this.upaasana!.map((v) => v.toJson()).toList();
    }
    if (this.vividhKshetaCheKam != null) {
      data['vividhKshetaCheKam'] =
          this.vividhKshetaCheKam!.map((v) => v.toJson()).toList();
    }
    if (this.vividhSampradhaySatsang != null) {
      data['vividhSampradhaySatsang'] =
          this.vividhSampradhaySatsang!.map((v) => v.toJson()).toList();
    }
    if (this.listSwayamsevakCountByVyavasaayeeCategory != null) {
      data['SwayamsevakCountByVyavasaayeeCategory'] = this
          .listSwayamsevakCountByVyavasaayeeCategory!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.kaaryakartaaCountByAayaam != null) {
      data['KaaryakartaaCountByAayaam'] =
          this.kaaryakartaaCountByAayaam!.map((v) => v.toJson()).toList();
    }
    if (this.swayamsevakCountByStudentCategory != null) {
      data['SwayamsevakCountByStudentCategory'] = this
          .swayamsevakCountByStudentCategory!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.socialOrganizationKaaryakartaaCountByAreaOfOperation != null) {
      data['SocialOrganizationKaaryakartaaCountByAreaOfOperation'] = this
          .socialOrganizationKaaryakartaaCountByAreaOfOperation!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.sanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation != null) {
      data['SanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'] = this
          .sanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.kaaryakartaaCountByGatividhi != null) {
      data['KaaryakartaaCountByGatividhi'] =
          this.kaaryakartaaCountByGatividhi!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hinduvirayadi {
  int? gramCount;
  int? sankhya;
  String? subvalue;
  String? value;

  Hinduvirayadi({this.gramCount, this.sankhya, this.subvalue, this.value});

  Hinduvirayadi.fromJson(Map<String, dynamic> json) {
    gramCount = json['gramCount'];
    sankhya = json['sankhya'];
    subvalue = json['subvalue'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gramCount'] = this.gramCount;
    data['sankhya'] = this.sankhya;
    data['subvalue'] = this.subvalue;
    data['value'] = this.value;
    return data;
  }
}

class Anyaprabhavilok {
  String? prabhavishetra;
  String? sajjanshakkati;
  String? samparkashiti;
  int? vasticnt;

  Anyaprabhavilok(
      {this.prabhavishetra,
      this.sajjanshakkati,
      this.samparkashiti,
      this.vasticnt});

  Anyaprabhavilok.fromJson(Map<String, dynamic> json) {
    prabhavishetra = json['prabhavishetra'];
    sajjanshakkati = json['sajjanshakkati'];
    samparkashiti = json['samparkashiti'];
    vasticnt = json['vasticnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prabhavishetra'] = this.prabhavishetra;
    data['sajjanshakkati'] = this.sajjanshakkati;
    data['samparkashiti'] = this.samparkashiti;
    data['vasticnt'] = this.vasticnt;
    return data;
  }
}

class Durjanshakti {
  int? gramCount;
  int? sankhya;
  String? subvalue;
  String? value;

  Durjanshakti({this.gramCount, this.sankhya, this.subvalue, this.value});

  Durjanshakti.fromJson(Map<String, dynamic> json) {
    gramCount = json['gramCount'];
    sankhya = json['sankhya'];
    subvalue = json['subvalue'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gramCount'] = this.gramCount;
    data['sankhya'] = this.sankhya;
    data['subvalue'] = this.subvalue;
    data['value'] = this.value;
    return data;
  }
}

class Loksankhyaformandal {
  int? aayaamKaaryakartaaCount;
  int? akhilBhaaratiyaKaaryakartaaCount;
  int? baalCount;
  int? bhaagKaaryakartaaCount;
  int? dailyShaakhaaKaaryakartaaCount;
  int? dwitiyaVarshaShikshitCount;
  int? gatividhiKaaryakartaaCount;
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
  int? sanghaPreritSansthaaKaaryakartaaCount;
  int? shaharKaaryakartaaCount;
  int? shishuCount;
  int? socialOrganizationKaaryakartaaCount;
  int? tarunVidyaarthiCount;
  int? tarunVyavasaayeeCount;
  int? totalKaaryakartaaCount;
  int? trutiyaVarshaShikshitCount;
  int? unknownAgeCount;
  int? vastiKaaryakartaaCount;
  int? vibhaagKaaryakartaaCount;
  int? gramCount;
  int? mandalCount;
  int? totalSwayamsevakCount;

  Loksankhyaformandal(
      {this.aayaamKaaryakartaaCount,
      this.akhilBhaaratiyaKaaryakartaaCount,
      this.baalCount,
      this.bhaagKaaryakartaaCount,
      this.dailyShaakhaaKaaryakartaaCount,
      this.dwitiyaVarshaShikshitCount,
      this.gatividhiKaaryakartaaCount,
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
      this.sanghaPreritSansthaaKaaryakartaaCount,
      this.shaharKaaryakartaaCount,
      this.shishuCount,
      this.socialOrganizationKaaryakartaaCount,
      this.tarunVidyaarthiCount,
      this.tarunVyavasaayeeCount,
      this.totalKaaryakartaaCount,
      this.trutiyaVarshaShikshitCount,
      this.unknownAgeCount,
      this.vastiKaaryakartaaCount,
      this.vibhaagKaaryakartaaCount,
      this.gramCount,
      this.mandalCount,
      this.totalSwayamsevakCount});

  Loksankhyaformandal.fromJson(Map<String, dynamic> json) {
    aayaamKaaryakartaaCount = json['AayaamKaaryakartaaCount'];
    akhilBhaaratiyaKaaryakartaaCount = json['AkhilBhaaratiyaKaaryakartaaCount'];
    baalCount = json['BaalCount'];
    bhaagKaaryakartaaCount = json['BhaagKaaryakartaaCount'];
    dailyShaakhaaKaaryakartaaCount = json['DailyShaakhaaKaaryakartaaCount'];
    dwitiyaVarshaShikshitCount = json['DwitiyaVarshaShikshitCount'];
    gatividhiKaaryakartaaCount = json['GatividhiKaaryakartaaCount'];
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
    sanghaPreritSansthaaKaaryakartaaCount =
        json['SanghaPreritSansthaaKaaryakartaaCount'];
    shaharKaaryakartaaCount = json['ShaharKaaryakartaaCount'];
    shishuCount = json['ShishuCount'];
    socialOrganizationKaaryakartaaCount =
        json['SocialOrganizationKaaryakartaaCount'];
    tarunVidyaarthiCount = json['TarunVidyaarthiCount'];
    tarunVyavasaayeeCount = json['TarunVyavasaayeeCount'];
    totalKaaryakartaaCount = json['TotalKaaryakartaaCount'];
    trutiyaVarshaShikshitCount = json['TrutiyaVarshaShikshitCount'];
    unknownAgeCount = json['UnknownAgeCount'];
    vastiKaaryakartaaCount = json['VastiKaaryakartaaCount'];
    vibhaagKaaryakartaaCount = json['VibhaagKaaryakartaaCount'];
    gramCount = json['gramCount'];
    mandalCount = json['mandalCount'];
    totalSwayamsevakCount = json['totalSwayamsevakCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AayaamKaaryakartaaCount'] = this.aayaamKaaryakartaaCount;
    data['AkhilBhaaratiyaKaaryakartaaCount'] =
        this.akhilBhaaratiyaKaaryakartaaCount;
    data['BaalCount'] = this.baalCount;
    data['BhaagKaaryakartaaCount'] = this.bhaagKaaryakartaaCount;
    data['DailyShaakhaaKaaryakartaaCount'] =
        this.dailyShaakhaaKaaryakartaaCount;
    data['DwitiyaVarshaShikshitCount'] = this.dwitiyaVarshaShikshitCount;
    data['GatividhiKaaryakartaaCount'] = this.gatividhiKaaryakartaaCount;
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
    data['SanghaPreritSansthaaKaaryakartaaCount'] =
        this.sanghaPreritSansthaaKaaryakartaaCount;
    data['ShaharKaaryakartaaCount'] = this.shaharKaaryakartaaCount;
    data['ShishuCount'] = this.shishuCount;
    data['SocialOrganizationKaaryakartaaCount'] =
        this.socialOrganizationKaaryakartaaCount;
    data['TarunVidyaarthiCount'] = this.tarunVidyaarthiCount;
    data['TarunVyavasaayeeCount'] = this.tarunVyavasaayeeCount;
    data['TotalKaaryakartaaCount'] = this.totalKaaryakartaaCount;
    data['TrutiyaVarshaShikshitCount'] = this.trutiyaVarshaShikshitCount;
    data['UnknownAgeCount'] = this.unknownAgeCount;
    data['VastiKaaryakartaaCount'] = this.vastiKaaryakartaaCount;
    data['VibhaagKaaryakartaaCount'] = this.vibhaagKaaryakartaaCount;
    data['gramCount'] = this.gramCount;
    data['mandalCount'] = this.mandalCount;
    data['totalSwayamsevakCount'] = this.totalSwayamsevakCount;
    return data;
  }
}

class MandalVastisarvekshanReportwithname {
  int? geounitid;
  int? gramAllStepsCompleteCount;
  String? gramAllStepsCompleteNames;
  int? gramStep1CompleteCount;
  String? gramStep1CompleteNames;
  int? gramStep2CompleteCount;
  String? gramStep2CompleteNames;
  int? gramStep3CompleteCount;
  String? gramStep3CompleteNames;
  int? gramStepStartedCount;
  String? gramStepStartedNames;
  int? gramStepTotal;
  int? gramStepsNotstartedCount;
  String? gramStepsNotstartedNames;
  int? gramcount;
  int? mandalAllStepsCompleteCount;
  int? mandalStep1CompleteCount;
  int? mandalStep2CompleteCount;
  int? mandalStep3CompleteCount;
  int? mandalStepStartedCount;
  int? mandalStepTotal;
  int? mandalStepsNotstartedCount;
  int? mandalcount;
  String? name;

  MandalVastisarvekshanReportwithname(
      {this.geounitid,
      this.gramAllStepsCompleteCount,
      this.gramAllStepsCompleteNames,
      this.gramStep1CompleteCount,
      this.gramStep1CompleteNames,
      this.gramStep2CompleteCount,
      this.gramStep2CompleteNames,
      this.gramStep3CompleteCount,
      this.gramStep3CompleteNames,
      this.gramStepStartedCount,
      this.gramStepStartedNames,
      this.gramStepTotal,
      this.gramStepsNotstartedCount,
      this.gramStepsNotstartedNames,
      this.gramcount,
      this.mandalAllStepsCompleteCount,
      this.mandalStep1CompleteCount,
      this.mandalStep2CompleteCount,
      this.mandalStep3CompleteCount,
      this.mandalStepStartedCount,
      this.mandalStepTotal,
      this.mandalStepsNotstartedCount,
      this.mandalcount,
      this.name});

  MandalVastisarvekshanReportwithname.fromJson(Map<String, dynamic> json) {
    geounitid = json['geounitid'];
    gramAllStepsCompleteCount = json['gram_all_steps_complete_count'];
    gramAllStepsCompleteNames = json['gram_all_steps_complete_names'];
    gramStep1CompleteCount = json['gram_step1_complete_count'];
    gramStep1CompleteNames = json['gram_step1_complete_names'];
    gramStep2CompleteCount = json['gram_step2_complete_count'];
    gramStep2CompleteNames = json['gram_step2_complete_names'];
    gramStep3CompleteCount = json['gram_step3_complete_count'];
    gramStep3CompleteNames = json['gram_step3_complete_names'];
    gramStepStartedCount = json['gram_step_started_count'];
    gramStepStartedNames = json['gram_step_started_names'];
    gramStepTotal = json['gram_step_total'];
    gramStepsNotstartedCount = json['gram_steps_notstarted_count'];
    gramStepsNotstartedNames = json['gram_steps_notstarted_names'];
    gramcount = json['gramcount'];
    mandalAllStepsCompleteCount = json['mandal_all_steps_complete_count'];
    mandalStep1CompleteCount = json['mandal_step1_complete_count'];
    mandalStep2CompleteCount = json['mandal_step2_complete_count'];
    mandalStep3CompleteCount = json['mandal_step3_complete_count'];
    mandalStepStartedCount = json['mandal_step_started_count'];
    mandalStepTotal = json['mandal_step_total'];
    mandalStepsNotstartedCount = json['mandal_steps_notstarted_count'];
    mandalcount = json['mandalcount'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geounitid'] = this.geounitid;
    data['gram_all_steps_complete_count'] = this.gramAllStepsCompleteCount;
    data['gram_all_steps_complete_names'] = this.gramAllStepsCompleteNames;
    data['gram_step1_complete_count'] = this.gramStep1CompleteCount;
    data['gram_step1_complete_names'] = this.gramStep1CompleteNames;
    data['gram_step2_complete_count'] = this.gramStep2CompleteCount;
    data['gram_step2_complete_names'] = this.gramStep2CompleteNames;
    data['gram_step3_complete_count'] = this.gramStep3CompleteCount;
    data['gram_step3_complete_names'] = this.gramStep3CompleteNames;
    data['gram_step_started_count'] = this.gramStepStartedCount;
    data['gram_step_started_names'] = this.gramStepStartedNames;
    data['gram_step_total'] = this.gramStepTotal;
    data['gram_steps_notstarted_count'] = this.gramStepsNotstartedCount;
    data['gram_steps_notstarted_names'] = this.gramStepsNotstartedNames;
    data['gramcount'] = this.gramcount;
    data['mandal_all_steps_complete_count'] = this.mandalAllStepsCompleteCount;
    data['mandal_step1_complete_count'] = this.mandalStep1CompleteCount;
    data['mandal_step2_complete_count'] = this.mandalStep2CompleteCount;
    data['mandal_step3_complete_count'] = this.mandalStep3CompleteCount;
    data['mandal_step_started_count'] = this.mandalStepStartedCount;
    data['mandal_step_total'] = this.mandalStepTotal;
    data['mandal_steps_notstarted_count'] = this.mandalStepsNotstartedCount;
    data['mandalcount'] = this.mandalcount;
    data['name'] = this.name;
    return data;
  }
}

class Mandaldata {
  int? between1000And2000;
  int? between1000And3000;
  int? between2000And4000;
  int? between3000And5000;
  int? between5000And10000;
  int? lessThan1000;
  String? bhagname;
  int? greaterthen4000;
  int? maleCountBetween1000And2000;
  int? maleCountBetween1000And3000;
  int? maleCountBetween2000And4000;
  int? maleCountBetween3000And5000;
  int? maleCountBetween5000And10000;
  int? maleCountLessThan1000;
  int? maleCountgreaterthen4000;
  String? mandalname;
  int? mumbaikarCount;
  int? gavachiSankhya;
  String? nagarname;
  String? vibhagname;
  String? mandalPramukhName;

  Mandaldata({
    this.between1000And2000,
    this.between1000And3000,
    this.between2000And4000,
    this.between3000And5000,
    this.between5000And10000,
    this.lessThan1000,
    this.bhagname,
    this.greaterthen4000,
    this.maleCountBetween1000And2000,
    this.maleCountBetween1000And3000,
    this.maleCountBetween2000And4000,
    this.maleCountBetween3000And5000,
    this.maleCountBetween5000And10000,
    this.maleCountLessThan1000,
    this.maleCountgreaterthen4000,
    this.mandalname,
    this.mumbaikarCount,
    this.gavachiSankhya,
    this.nagarname,
    this.vibhagname,
    this.mandalPramukhName,
  });

  Mandaldata.fromJson(Map<String, dynamic> json) {
    between1000And2000 = json['Between1000And2000'];
    between1000And3000 = json['Between1000And3000'];
    between2000And4000 = json['Between2000And4000'];
    between3000And5000 = json['Between3000And5000'];
    between5000And10000 = json['Between5000And10000'];
    lessThan1000 = json['LessThan1000'];
    bhagname = json['bhagname'];
    greaterthen4000 = json['greaterthen4000'];
    maleCountBetween1000And2000 = json['maleCountBetween1000And2000'];
    maleCountBetween1000And3000 = json['maleCountBetween1000And3000'];
    maleCountBetween2000And4000 = json['maleCountBetween2000And4000'];
    maleCountBetween3000And5000 = json['maleCountBetween3000And5000'];
    maleCountBetween5000And10000 = json['maleCountBetween5000And10000'];
    maleCountLessThan1000 = json['maleCountLessThan1000'];
    maleCountgreaterthen4000 = json['maleCountgreaterthen4000'];
    mandalname = json['mandalname'];
    mumbaikarCount = json['mumbaikarCount'];
    gavachiSankhya = json['gavachiSankhya'];
    nagarname = json['nagarname'];
    vibhagname = json['vibhagname'];
    mandalPramukhName = json['mandalPramukhName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Between1000And2000'] = this.between1000And2000;
    data['Between1000And3000'] = this.between1000And3000;
    data['Between2000And4000'] = this.between2000And4000;
    data['Between3000And5000'] = this.between3000And5000;
    data['Between5000And10000'] = this.between5000And10000;
    data['LessThan1000'] = this.lessThan1000;
    data['bhagname'] = this.bhagname;
    data['greaterthen4000'] = this.greaterthen4000;
    data['maleCountBetween1000And2000'] = this.maleCountBetween1000And2000;
    data['maleCountBetween1000And3000'] = this.maleCountBetween1000And3000;
    data['maleCountBetween2000And4000'] = this.maleCountBetween2000And4000;
    data['maleCountBetween3000And5000'] = this.maleCountBetween3000And5000;
    data['maleCountBetween5000And10000'] = this.maleCountBetween5000And10000;
    data['maleCountLessThan1000'] = this.maleCountLessThan1000;
    data['maleCountgreaterthen4000'] = this.maleCountgreaterthen4000;
    data['mandalname'] = this.mandalname;
    data['mumbaikarCount'] = this.mumbaikarCount;
    data['gavachiSankhya'] = this.gavachiSankhya;
    data['nagarname'] = this.nagarname;
    data['vibhagname'] = this.vibhagname;
    data['mandalPramukhName'] = this.mandalPramukhName;
    return data;
  }
}

class SewaPrakalpa {
  int? gramCount;
  int? sankhya;
  String? subvalue;
  String? value;

  SewaPrakalpa({this.gramCount, this.sankhya, this.subvalue, this.value});

  SewaPrakalpa.fromJson(Map<String, dynamic> json) {
    gramCount = json['gramCount'];
    sankhya = json['sankhya'];
    subvalue = json['subvalue'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gramCount'] = this.gramCount;
    data['sankhya'] = this.sankhya;
    data['subvalue'] = this.subvalue;
    data['value'] = this.value;
    return data;
  }
}

class Upaasana {
  int? gramCount;
  int? sankhya;
  String? subvalue;
  String? value;

  Upaasana({this.gramCount, this.sankhya, this.subvalue, this.value});

  Upaasana.fromJson(Map<String, dynamic> json) {
    gramCount = json['gramCount'];
    sankhya = json['sankhya'];
    subvalue = json['subvalue'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gramCount'] = this.gramCount;
    data['sankhya'] = this.sankhya;
    data['subvalue'] = this.subvalue;
    data['value'] = this.value;
    return data;
  }
}

class VividhSampradhaySatsang {
  int? gramCount;
  int? sankhya;
  String? subvalue;
  String? value;

  VividhSampradhaySatsang(
      {this.gramCount, this.sankhya, this.subvalue, this.value});

  VividhSampradhaySatsang.fromJson(Map<String, dynamic> json) {
    gramCount = json['gramCount'];
    sankhya = json['sankhya'];
    subvalue = json['subvalue'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gramCount'] = this.gramCount;
    data['sankhya'] = this.sankhya;
    data['subvalue'] = this.subvalue;
    data['value'] = this.value;
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

class KaaryakartaaCountByAayaam {
  int? aayaamID;
  String? aayaamName;
  int? kaaryakartaaCount;

  KaaryakartaaCountByAayaam(
      {this.aayaamID, this.aayaamName, this.kaaryakartaaCount});

  KaaryakartaaCountByAayaam.fromJson(Map<String, dynamic> json) {
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

class SwayamsevakCountByStudentCategory {
  int? studentCategoryID;
  String? studentCategoryName;
  int? countByStudentCategory;

  SwayamsevakCountByStudentCategory(
      {this.studentCategoryID,
      this.studentCategoryName,
      this.countByStudentCategory});

  SwayamsevakCountByStudentCategory.fromJson(Map<String, dynamic> json) {
    studentCategoryID = json['StudentCategoryID'];
    studentCategoryName = json['StudentCategoryName'];
    studentCategoryID = json['CountByStudentCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StudentCategoryID'] = this.studentCategoryID;
    data['StudentCategoryName'] = this.studentCategoryName;
    data['CountByStudentCategory'] = this.countByStudentCategory;
    return data;
  }
}

class SocialOrganizationKaaryakartaaCountByAreaOfOperation {
  int? studentCategoryID;
  String? studentCategoryName;
  int? countByStudentCategory;

  SocialOrganizationKaaryakartaaCountByAreaOfOperation(
      {this.studentCategoryID,
      this.studentCategoryName,
      this.countByStudentCategory});

  SocialOrganizationKaaryakartaaCountByAreaOfOperation.fromJson(
      Map<String, dynamic> json) {
    studentCategoryID = json['MainAreaOfOperationID'];
    studentCategoryName = json['AreaOfOperation'];
    studentCategoryID = json['KaaryakartaaCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MainAreaOfOperationID'] = this.studentCategoryID;
    data['AreaOfOperation'] = this.studentCategoryName;
    data['KaaryakartaaCount'] = this.countByStudentCategory;
    return data;
  }
}

class SanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation {
  int? areaOfOperationID;
  String? areaOfOperation;
  int? kaaryakartaaCount;

  SanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation(
      {this.areaOfOperationID, this.areaOfOperation, this.kaaryakartaaCount});

  SanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation.fromJson(
      Map<String, dynamic> json) {
    areaOfOperationID = json['AreaOfOperationID'];
    areaOfOperation = json['AreaOfOperation'];
    kaaryakartaaCount = json['KaaryakartaaCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AreaOfOperationID'] = this.areaOfOperationID;
    data['AreaOfOperation'] = this.areaOfOperation;
    data['KaaryakartaaCount'] = this.kaaryakartaaCount;
    return data;
  }
}

class KaaryakartaaCountByGatividhi {
  int? gatividhiID;
  String? gatividhiName;
  int? kaaryakartaaCount;

  KaaryakartaaCountByGatividhi(
      {this.gatividhiID, this.gatividhiName, this.kaaryakartaaCount});

  KaaryakartaaCountByGatividhi.fromJson(Map<String, dynamic> json) {
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
