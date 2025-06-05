class NagarVastiSampurnaModel {
  String? message;
  List<NagarVastisarvekshanReportwithname>? nagarVastisarvekshanReportwithname;
  String? status;
  List<Bhaasacount>? bhaasacount;
  List<Prantshiti>? prantshiti;
  List<Vasahatprakar>? vasahatprakar;
  Vastiloksankhya? vastiloksankhya;
  List<Mothevyavasayikakendra>? mothevyavasayikakendra;
  List<Motherugnalaya>? motherugnalaya;
  List<Balopasanakendra>? balopasanakendra;
  List<Mahatvacesana>? mahatvacesana;
  List<Sajjanshakkati>? sajjanshakkati;
  List<Samajikkaryakram>? samajikkaryakram;
  List<Schooltapasilaforclg>? schooltapasilaforclg;
  List<Schooltapasilaformedium>? schooltapasilaformedium;
  List<Schooltapasilaforschool>? schooltapasilaforschool;
  List<UpasanaSthal>? upasanaSthal;
  List<Hinduvirayadi>? hinduvirayadi;
  List<Durjanshakti>? durjanshakti;
  List<Vastitilasamajika>? vastitilasamajika;
  List<Dhaarmiknetrtav>? dhaarmiknetrtav;
  List<Jahirakaryakramasambandhi>? jahirakaryakramasambandhi;
  List<Maidan>? maidan;
  List<ListKaaryakartaaCountByGatividhi>? listKaaryakartaaCountByGatividhi;
  List<ListKaaryakartaaCountByAayaam>? listKaaryakartaaCountByAayaam;
  List<ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation>?
  listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation;
  List<ListSwayamsevakCountByStudentCategory>?
  listSwayamsevakCountByStudentCategory;
  List<ListSwayamsevakCountByVyavasaayeeCategory>?
  listSwayamsevakCountByVyavasaayeeCategory;
  List<SanghaKaryaStithiData>? sanghaKaryaStithiData;
  NagarVastisarvekshanReportwithselectedlevel?
  nagarVastisarvekshanReportwithselectedlevel;
  List<Jagran>? jagran;
  List<Gatividhi>? gatividhi;
  List<Religion>? religion;
  List<Vasahatsamparkashiti>? vasahatsamparkashiti;
  List<SocialOrganizationKaaryakartaaCountByAreaOfOperation>? socialOrganizationKaaryakartaaCountByAreaOfOperation;
  List<PurviShakhaHoti>? purviShakhaHoti;
  List<PurviSptahikMilanHote>? purviSptahikMilanHote;

  NagarVastiSampurnaModel(
      {this.message,
        this.nagarVastisarvekshanReportwithname,
        this.status,
        this.bhaasacount,
        this.prantshiti,
        this.vasahatprakar,
        this.vastiloksankhya,
        this.mothevyavasayikakendra,
        this.motherugnalaya,
        this.balopasanakendra,
        this.mahatvacesana,
        this.sajjanshakkati,
        this.samajikkaryakram,
        this.schooltapasilaforclg,
        this.schooltapasilaformedium,
        this.schooltapasilaforschool,
        this.upasanaSthal,
        this.hinduvirayadi,
        this.durjanshakti,
        this.vastitilasamajika,
        this.dhaarmiknetrtav,
        this.jahirakaryakramasambandhi,
        this.maidan,
        this.listKaaryakartaaCountByGatividhi,
        this.listKaaryakartaaCountByAayaam,
        this.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation,
        this.listSwayamsevakCountByStudentCategory,
        this.listSwayamsevakCountByVyavasaayeeCategory,
        this.sanghaKaryaStithiData,
        this.nagarVastisarvekshanReportwithselectedlevel,
        this.jagran,
        this.gatividhi,
        this.religion,
        this.vasahatsamparkashiti,
        this.socialOrganizationKaaryakartaaCountByAreaOfOperation,
        this.purviShakhaHoti,
        this.purviSptahikMilanHote
      });

  NagarVastiSampurnaModel.fromJson(Map<String, dynamic> json) {

    message = json['Message'];
    if (json['NagarVastisarvekshanReportwithname'] != null) {
      nagarVastisarvekshanReportwithname =
      <NagarVastisarvekshanReportwithname>[];
      json['NagarVastisarvekshanReportwithname'].forEach((v) {
        nagarVastisarvekshanReportwithname!
            .add(new NagarVastisarvekshanReportwithname.fromJson(v));
      });
    }
    status = json['Status'];
    if (json['bhaasacount'] != null) {
      bhaasacount = <Bhaasacount>[];
      json['bhaasacount'].forEach((v) {
        bhaasacount!.add(new Bhaasacount.fromJson(v));
      });
    }
    if (json['prantshiti'] != null) {
      prantshiti = <Prantshiti>[];
      json['prantshiti'].forEach((v) {
        prantshiti!.add(new Prantshiti.fromJson(v));
      });
    }
    if (json['vasahatprakar'] != null) {
      vasahatprakar = <Vasahatprakar>[];
      json['vasahatprakar'].forEach((v) {
        vasahatprakar!.add(new Vasahatprakar.fromJson(v));
      });
    }
    vastiloksankhya = json['vastiloksankhya'] != null
        ? new Vastiloksankhya.fromJson(json['vastiloksankhya'])
        : null;
    if (json['Mothevyavasayikakendra'] != null) {
      mothevyavasayikakendra = <Mothevyavasayikakendra>[];
      json['Mothevyavasayikakendra'].forEach((v) {
        mothevyavasayikakendra!.add(new Mothevyavasayikakendra.fromJson(v));
      });
    }
    if (json['Motherugnalaya'] != null) {
      motherugnalaya = <Motherugnalaya>[];
      json['Motherugnalaya'].forEach((v) {
        motherugnalaya!.add(new Motherugnalaya.fromJson(v));
      });
    }
    if (json['balopasanakendra'] != null) {
      balopasanakendra = <Balopasanakendra>[];
      json['balopasanakendra'].forEach((v) {
        balopasanakendra!.add(new Balopasanakendra.fromJson(v));
      });
    }
    if (json['mahatvacesana'] != null) {
      mahatvacesana = <Mahatvacesana>[];
      json['mahatvacesana'].forEach((v) {
        mahatvacesana!.add(new Mahatvacesana.fromJson(v));
      });
    }
    if (json['sajjanshakkati'] != null) {
      sajjanshakkati = <Sajjanshakkati>[];
      json['sajjanshakkati'].forEach((v) {
        sajjanshakkati!.add(new Sajjanshakkati.fromJson(v));
      });
    }
    if (json['samajikkaryakram'] != null) {
      samajikkaryakram = <Samajikkaryakram>[];
      json['samajikkaryakram'].forEach((v) {
        samajikkaryakram!.add(new Samajikkaryakram.fromJson(v));
      });
    }
    if (json['schooltapasilaforclg'] != null) {
      schooltapasilaforclg = <Schooltapasilaforclg>[];
      json['schooltapasilaforclg'].forEach((v) {
        schooltapasilaforclg!.add(new Schooltapasilaforclg.fromJson(v));
      });
    }
    if (json['schooltapasilaformedium'] != null) {
      schooltapasilaformedium = <Schooltapasilaformedium>[];
      json['schooltapasilaformedium'].forEach((v) {
        schooltapasilaformedium!.add(new Schooltapasilaformedium.fromJson(v));
      });
    }
    if (json['schooltapasilaforschool'] != null) {
      schooltapasilaforschool = <Schooltapasilaforschool>[];
      json['schooltapasilaforschool'].forEach((v) {
        schooltapasilaforschool!.add(new Schooltapasilaforschool.fromJson(v));
      });
    }
    if (json['upasanaSthal'] != null) {
      upasanaSthal = <UpasanaSthal>[];
      json['upasanaSthal'].forEach((v) {
        upasanaSthal!.add(new UpasanaSthal.fromJson(v));
      });
    }
    if (json['Hinduvirayadi'] != null) {
      hinduvirayadi = <Hinduvirayadi>[];
      json['Hinduvirayadi'].forEach((v) {
        hinduvirayadi!.add(new Hinduvirayadi.fromJson(v));
      });
    }
    if (json['durjanshakti'] != null) {
      durjanshakti = <Durjanshakti>[];
      json['durjanshakti'].forEach((v) {
        durjanshakti!.add(new Durjanshakti.fromJson(v));
      });
    }
    if (json['Vastitilasamajika'] != null) {
      vastitilasamajika = <Vastitilasamajika>[];
      json['Vastitilasamajika'].forEach((v) {
        vastitilasamajika!.add(new Vastitilasamajika.fromJson(v));
      });
    }
    if (json['dhaarmiknetrtav'] != null) {
      dhaarmiknetrtav = <Dhaarmiknetrtav>[];
      json['dhaarmiknetrtav'].forEach((v) {
        dhaarmiknetrtav!.add(new Dhaarmiknetrtav.fromJson(v));
      });
    }
    if (json['Jahirakaryakramasambandhi'] != null) {
      jahirakaryakramasambandhi = <Jahirakaryakramasambandhi>[];
      json['Jahirakaryakramasambandhi'].forEach((v) {
        jahirakaryakramasambandhi!
            .add(new Jahirakaryakramasambandhi.fromJson(v));
      });
    }
    if (json['maidan'] != null) {
      maidan = <Maidan>[];
      json['maidan'].forEach((v) {
        maidan!.add(new Maidan.fromJson(v));
      });
    }
    if (json['ListKaaryakartaaCountByGatividhi'] != null) {
      listKaaryakartaaCountByGatividhi = <ListKaaryakartaaCountByGatividhi>[];
      json['ListKaaryakartaaCountByGatividhi'].forEach((v) {
        listKaaryakartaaCountByGatividhi!
            .add(new ListKaaryakartaaCountByGatividhi.fromJson(v));
      });
    }
    if (json['ListKaaryakartaaCountByAayaam'] != null) {
      listKaaryakartaaCountByAayaam = <ListKaaryakartaaCountByAayaam>[];
      json['ListKaaryakartaaCountByAayaam'].forEach((v) {
        listKaaryakartaaCountByAayaam!
            .add(new ListKaaryakartaaCountByAayaam.fromJson(v));
      });
    }
    if (json['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'] !=
        null) {
      listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation =
      <ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation>[];
      json['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation']
          .forEach((v) {
        listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.add(
            new ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation
                .fromJson(v));
      });
    }
    if (json['ListSwayamsevakCountByStudentCategory'] != null) {
      listSwayamsevakCountByStudentCategory =
      <ListSwayamsevakCountByStudentCategory>[];
      json['ListSwayamsevakCountByStudentCategory'].forEach((v) {
        listSwayamsevakCountByStudentCategory!
            .add(new ListSwayamsevakCountByStudentCategory.fromJson(v));
      });
    }
    if (json['ListSwayamsevakCountByVyavasaayeeCategory'] != null) {
      listSwayamsevakCountByVyavasaayeeCategory =
      <ListSwayamsevakCountByVyavasaayeeCategory>[];
      json['ListSwayamsevakCountByVyavasaayeeCategory'].forEach((v) {
        listSwayamsevakCountByVyavasaayeeCategory!
            .add(new ListSwayamsevakCountByVyavasaayeeCategory.fromJson(v));
      });
    }
    if (json['sanghaKaryaStithiData'] != null) {
      sanghaKaryaStithiData = <SanghaKaryaStithiData>[];
      json['sanghaKaryaStithiData'].forEach((v) {
        sanghaKaryaStithiData!.add(new SanghaKaryaStithiData.fromJson(v));
      });
    }
    nagarVastisarvekshanReportwithselectedlevel =
    json['NagarVastisarvekshanReportwithselectedlevel'] != null
        ? new NagarVastisarvekshanReportwithselectedlevel.fromJson(
        json['NagarVastisarvekshanReportwithselectedlevel'])
        : null;
    if (json['jagran'] != null) {
      jagran = <Jagran>[];
      json['jagran'].forEach((v) {
        jagran!.add(new Jagran.fromJson(v));
      });
    }
    if (json['Gatividhi'] != null) {
      gatividhi = <Gatividhi>[];
      json['Gatividhi'].forEach((v) {
        gatividhi!.add(new Gatividhi.fromJson(v));
      });
    }
    if (json['religion'] != null) {
      religion = <Religion>[];
      json['religion'].forEach((v) {
        religion!.add(new Religion.fromJson(v));
      });
    }
    if (json['vasahatsamparkashiti'] != null) {
      vasahatsamparkashiti = <Vasahatsamparkashiti>[];
      json['vasahatsamparkashiti'].forEach((v) {
        vasahatsamparkashiti!.add(new Vasahatsamparkashiti.fromJson(v));
      });
    }
    if (json['ListSocialOrganizationKaaryakartaaCountByAreaOfOperation'] != null) {
      socialOrganizationKaaryakartaaCountByAreaOfOperation = <SocialOrganizationKaaryakartaaCountByAreaOfOperation>[];
      json['ListSocialOrganizationKaaryakartaaCountByAreaOfOperation'].forEach((v) {
        socialOrganizationKaaryakartaaCountByAreaOfOperation!.add(new SocialOrganizationKaaryakartaaCountByAreaOfOperation.fromJson(v));
      });
    }
    if (json['purviShakhaHoti'] != null) {
      purviShakhaHoti = <PurviShakhaHoti>[];
      json['purviShakhaHoti'].forEach((v) {
        purviShakhaHoti!.add(new PurviShakhaHoti.fromJson(v));
      });
    }
    if (json['purviSptahikMilanHote'] != null) {
      purviSptahikMilanHote = <PurviSptahikMilanHote>[];
      json['purviSptahikMilanHote'].forEach((v) {
        purviSptahikMilanHote!.add(new PurviSptahikMilanHote.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    if (this.nagarVastisarvekshanReportwithname != null) {
      data['NagarVastisarvekshanReportwithname'] = this
          .nagarVastisarvekshanReportwithname!
          .map((v) => v.toJson())
          .toList();
    }
    data['Status'] = this.status;
    if (this.bhaasacount != null) {
      data['bhaasacount'] = this.bhaasacount!.map((v) => v.toJson()).toList();
    }
    if (this.prantshiti != null) {
      data['prantshiti'] = this.prantshiti!.map((v) => v.toJson()).toList();
    }
    if (this.vasahatprakar != null) {
      data['vasahatprakar'] =
          this.vasahatprakar!.map((v) => v.toJson()).toList();
    }
    if (this.vastiloksankhya != null) {
      data['vastiloksankhya'] = this.vastiloksankhya!.toJson();
    }
    if (this.mothevyavasayikakendra != null) {
      data['Mothevyavasayikakendra'] =
          this.mothevyavasayikakendra!.map((v) => v.toJson()).toList();
    }
    if (this.motherugnalaya != null) {
      data['Motherugnalaya'] =
          this.motherugnalaya!.map((v) => v.toJson()).toList();
    }
    if (this.balopasanakendra != null) {
      data['balopasanakendra'] =
          this.balopasanakendra!.map((v) => v.toJson()).toList();
    }
    if (this.mahatvacesana != null) {
      data['mahatvacesana'] =
          this.mahatvacesana!.map((v) => v.toJson()).toList();
    }
    if (this.sajjanshakkati != null) {
      data['sajjanshakkati'] =
          this.sajjanshakkati!.map((v) => v.toJson()).toList();
    }
    if (this.samajikkaryakram != null) {
      data['samajikkaryakram'] =
          this.samajikkaryakram!.map((v) => v.toJson()).toList();
    }
    if (this.schooltapasilaforclg != null) {
      data['schooltapasilaforclg'] =
          this.schooltapasilaforclg!.map((v) => v.toJson()).toList();
    }
    if (this.schooltapasilaformedium != null) {
      data['schooltapasilaformedium'] =
          this.schooltapasilaformedium!.map((v) => v.toJson()).toList();
    }
    if (this.schooltapasilaforschool != null) {
      data['schooltapasilaforschool'] =
          this.schooltapasilaforschool!.map((v) => v.toJson()).toList();
    }
    if (this.upasanaSthal != null) {
      data['upasanaSthal'] = this.upasanaSthal!.map((v) => v.toJson()).toList();
    }
    if (this.hinduvirayadi != null) {
      data['Hinduvirayadi'] =
          this.hinduvirayadi!.map((v) => v.toJson()).toList();
    }
    if (this.durjanshakti != null) {
      data['durjanshakti'] = this.durjanshakti!.map((v) => v.toJson()).toList();
    }
    if (this.vastitilasamajika != null) {
      data['Vastitilasamajika'] =
          this.vastitilasamajika!.map((v) => v.toJson()).toList();
    }
    if (this.dhaarmiknetrtav != null) {
      data['dhaarmiknetrtav'] =
          this.dhaarmiknetrtav!.map((v) => v.toJson()).toList();
    }
    if (this.jahirakaryakramasambandhi != null) {
      data['Jahirakaryakramasambandhi'] =
          this.jahirakaryakramasambandhi!.map((v) => v.toJson()).toList();
    }
    if (this.listKaaryakartaaCountByGatividhi != null) {
      data['ListKaaryakartaaCountByGatividhi'] = this
          .listKaaryakartaaCountByGatividhi!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.listKaaryakartaaCountByAayaam != null) {
      data['ListKaaryakartaaCountByAayaam'] =
          this.listKaaryakartaaCountByAayaam!.map((v) => v.toJson()).toList();
    }
    if (this.listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation !=
        null) {
      data['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'] = this
          .listSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.listSwayamsevakCountByStudentCategory != null) {
      data['ListSwayamsevakCountByStudentCategory'] = this
          .listSwayamsevakCountByStudentCategory!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.listSwayamsevakCountByVyavasaayeeCategory != null) {
      data['ListSwayamsevakCountByVyavasaayeeCategory'] = this
          .listSwayamsevakCountByVyavasaayeeCategory!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.sanghaKaryaStithiData != null) {
      data['sanghaKaryaStithiData'] =
          this.sanghaKaryaStithiData!.map((v) => v.toJson()).toList();
    }
    if (this.nagarVastisarvekshanReportwithselectedlevel != null) {
      data['NagarVastisarvekshanReportwithselectedlevel'] =
          this.nagarVastisarvekshanReportwithselectedlevel!.toJson();
    }
    if (this.jagran != null) {
      data['jagran'] = this.jagran!.map((v) => v.toJson()).toList();
    }
    if (this.gatividhi != null) {
      data['Gatividhi'] = this.gatividhi!.map((v) => v.toJson()).toList();
    }
    if (this.religion != null) {
      data['religion'] = this.religion!.map((v) => v.toJson()).toList();
    }
    if (this.vasahatsamparkashiti != null) {
      data['vasahatsamparkashiti'] =
          this.vasahatsamparkashiti!.map((v) => v.toJson()).toList();
    }
    if (this.socialOrganizationKaaryakartaaCountByAreaOfOperation != null) {
      data['ListSocialOrganizationKaaryakartaaCountByAreaOfOperation'] =
          this.socialOrganizationKaaryakartaaCountByAreaOfOperation!.map((v) => v.toJson()).toList();
    }
    if (this.purviShakhaHoti != null) {
      data['purviShakhaHoti'] =
          this.purviShakhaHoti!.map((v) => v.toJson()).toList();
    }
    if (this.purviSptahikMilanHote != null) {
      data['purviSptahikMilanHote'] =
          this.purviSptahikMilanHote!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NagarVastisarvekshanReportwithname {
  int? geounitid;
  int? nagarAllStepsCompleteCount;
  int? nagarStep1CompleteCount;
  int? nagarStep2CompleteCount;
  int? nagarStep3CompleteCount;
  int? nagarStepStartedCount;
  int? nagarStepsNotstartedCount;
  int? nagarcount;
  String? name;
  int? vastiAllStepsCompleteCount;
  int? vastiStep1CompleteCount;
  int? vastiStep2CompleteCount;
  int? vastiStep3CompleteCount;
  int? vastiStepStartedCount;
  int? vastiStepsNotstartedCount;
  int? vasticount;

  NagarVastisarvekshanReportwithname(
      {this.geounitid,
        this.nagarAllStepsCompleteCount,
        this.nagarStep1CompleteCount,
        this.nagarStep2CompleteCount,
        this.nagarStep3CompleteCount,
        this.nagarStepStartedCount,
        this.nagarStepsNotstartedCount,
        this.nagarcount,
        this.name,
        this.vastiAllStepsCompleteCount,
        this.vastiStep1CompleteCount,
        this.vastiStep2CompleteCount,
        this.vastiStep3CompleteCount,
        this.vastiStepStartedCount,
        this.vastiStepsNotstartedCount,
        this.vasticount});

  NagarVastisarvekshanReportwithname.fromJson(Map<String, dynamic> json) {
    geounitid = json['geounitid'];
    nagarAllStepsCompleteCount = json['nagar_all_steps_complete_count'];
    nagarStep1CompleteCount = json['nagar_step1_complete_count'];
    nagarStep2CompleteCount = json['nagar_step2_complete_count'];
    nagarStep3CompleteCount = json['nagar_step3_complete_count'];
    nagarStepStartedCount = json['nagar_step_started_count'];
    nagarStepsNotstartedCount = json['nagar_steps_notstarted_count'];
    nagarcount = json['nagarcount'];
    name = json['name'];
    vastiAllStepsCompleteCount = json['vasti_all_steps_complete_count'];
    vastiStep1CompleteCount = json['vasti_step1_complete_count'];
    vastiStep2CompleteCount = json['vasti_step2_complete_count'];
    vastiStep3CompleteCount = json['vasti_step3_complete_count'];
    vastiStepStartedCount = json['vasti_step_started_count'];
    vastiStepsNotstartedCount = json['vasti_steps_notstarted_count'];
    vasticount = json['vasticount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geounitid'] = this.geounitid;
    data['nagar_all_steps_complete_count'] = this.nagarAllStepsCompleteCount;
    data['nagar_step1_complete_count'] = this.nagarStep1CompleteCount;
    data['nagar_step2_complete_count'] = this.nagarStep2CompleteCount;
    data['nagar_step3_complete_count'] = this.nagarStep3CompleteCount;
    data['nagar_step_started_count'] = this.nagarStepStartedCount;
    data['nagar_steps_notstarted_count'] = this.nagarStepsNotstartedCount;
    data['nagarcount'] = this.nagarcount;
    data['name'] = this.name;
    data['vasti_all_steps_complete_count'] = this.vastiAllStepsCompleteCount;
    data['vasti_step1_complete_count'] = this.vastiStep1CompleteCount;
    data['vasti_step2_complete_count'] = this.vastiStep2CompleteCount;
    data['vasti_step3_complete_count'] = this.vastiStep3CompleteCount;
    data['vasti_step_started_count'] = this.vastiStepStartedCount;
    data['vasti_steps_notstarted_count'] = this.vastiStepsNotstartedCount;
    data['vasticount'] = this.vasticount;
    return data;
  }
}

class Bhaasacount {
  int? count;
  String? value;

  Bhaasacount({this.count, this.value});

  Bhaasacount.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['value'] = this.value;
    return data;
  }
}

class Prantshiti {
  int? count;
  String? value;

  Prantshiti({this.count, this.value});

  Prantshiti.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['value'] = this.value;
    return data;
  }
}

class Vasahatprakar {
  int? count;
  String? value;

  Vasahatprakar({this.count, this.value});

  Vasahatprakar.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['value'] = this.value;
    return data;
  }
}

class Vastiloksankhya {
  int? between8000And12000;
  int? lessThan8000;
  int? moreThan12000;
  int? policeThane;
  int? fireBrigade;
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
  int? vastiPramukhCount;
  int? vastiSamitiAheCount;
  int? purviShakhaHotiCount;
  int? purviSptahikMilanHoteCount;

  Vastiloksankhya(
      {this.between8000And12000, this.lessThan8000, this.moreThan12000,this.fireBrigade,this.policeThane,
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
        this.purviShakhaHotiCount,
        this.purviSptahikMilanHoteCount,
        this.vastiPramukhCount,
        this.vastiSamitiAheCount,
      });

  Vastiloksankhya.fromJson(Map<String, dynamic> json) {
    between8000And12000 = json['Between8000And12000'];
    lessThan8000 = json['LessThan8000'];
    moreThan12000 = json['MoreThan12000'];
    policeThane = json['Policethane'];
    fireBrigade = json['agnishamandal'];
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
    purviShakhaHotiCount = json['purviShakhaHotiCount'];
    purviSptahikMilanHoteCount = json['purviSptahikMilanHoteCount'];
    vastiPramukhCount = json['vastiPramukhCount'];
    vastiSamitiAheCount = json['vastiSamitiAheCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Between8000And12000'] = this.between8000And12000;
    data['LessThan8000'] = this.lessThan8000;
    data['MoreThan12000'] = this.moreThan12000;
    data['Policethane'] = this.policeThane;
    data['agnishamandal'] = this.fireBrigade;
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
    data['vastiPramukhCount'] = this.vastiPramukhCount;
    data['vastiSamitiAheCount'] = this.vastiSamitiAheCount;
    data['purviShakhaHotiCount'] = this.purviShakhaHotiCount;
    data['purviSptahikMilanHoteCount'] = this.purviSptahikMilanHoteCount;
    return data;
  }
}

class Mothevyavasayikakendra {
  int? count;
  int? sankhya;
  String? value;

  Mothevyavasayikakendra({this.count, this.sankhya, this.value});

  Mothevyavasayikakendra.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}

class Motherugnalaya {
  int? count;
  int? sankhya;
  String? value;

  Motherugnalaya({this.count, this.sankhya, this.value});

  Motherugnalaya.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}

class Balopasanakendra {
  int? count;
  int? sankhya;
  String? value;

  Balopasanakendra({this.count, this.sankhya, this.value});

  Balopasanakendra.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}

class Mahatvacesana {
  int? count;
  int? sankhya;
  String? value;

  Mahatvacesana({this.count, this.sankhya, this.value});

  Mahatvacesana.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}

class Sajjanshakkati {
  String? prabhavishetra;
  String? sajjanshakkati;
  String? samparkashiti;
  int? vasticnt;

  Sajjanshakkati(
      {this.prabhavishetra,
        this.sajjanshakkati,
        this.samparkashiti,
        this.vasticnt});

  Sajjanshakkati.fromJson(Map<String, dynamic> json) {
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

class Samajikkaryakram {
  int? count;
  int? sankhya;
  String? value;

  Samajikkaryakram({this.count, this.sankhya, this.value});

  Samajikkaryakram.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}

class Schooltapasilaforclg {
  int? count;
  int? sankhya;
  String? value;

  Schooltapasilaforclg({this.count, this.sankhya, this.value});

  Schooltapasilaforclg.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}

class Schooltapasilaforschool {
  int? count;
  int? sankhya;
  String? value;

  Schooltapasilaforschool({this.count, this.sankhya, this.value});

  Schooltapasilaforschool.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}

class Schooltapasilaformedium {
  int? count;
  int? sankhya;
  String? value;

  Schooltapasilaformedium({this.count, this.sankhya, this.value});

  Schooltapasilaformedium.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Count'] = this.count;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}

class UpasanaSthal {
  String? prakar;
  int? tot;
  String? upaasanasthal;
  int? vasticnt;

  UpasanaSthal({this.prakar, this.tot, this.upaasanasthal, this.vasticnt});

  UpasanaSthal.fromJson(Map<String, dynamic> json) {
    prakar = json['prakar'];
    tot = json['tot'];
    upaasanasthal = json['upaasanasthal'];
    vasticnt = json['vasticnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prakar'] = this.prakar;
    data['tot'] = this.tot;
    data['upaasanasthal'] = this.upaasanasthal;
    data['vasticnt'] = this.vasticnt;
    return data;
  }
}

class Hinduvirayadi {
  int? count;
  String? nivasasathiupalabdha;
  int? sankhya;
  int? value;

  Hinduvirayadi(
      {this.count, this.nivasasathiupalabdha, this.sankhya, this.value});

  Hinduvirayadi.fromJson(Map<String, dynamic> json) {
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

class Durjanshakti {
  int? count;
  Null? nivasasathiupalabdha;
  int? sankhya;
  String? value;

  Durjanshakti(
      {this.count, this.nivasasathiupalabdha, this.sankhya, this.value});

  Durjanshakti.fromJson(Map<String, dynamic> json) {
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

class Vastitilasamajika {
  int? count;
  Null? nivasasathiupalabdha;
  int? sankhya;
  String? value;

  Vastitilasamajika(
      {this.count, this.nivasasathiupalabdha, this.sankhya, this.value});

  Vastitilasamajika.fromJson(Map<String, dynamic> json) {
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

class Dhaarmiknetrtav {
  int? count;
  Null? nivasasathiupalabdha;
  int? sankhya;
  String? value;

  Dhaarmiknetrtav(
      {this.count, this.nivasasathiupalabdha, this.sankhya, this.value});

  Dhaarmiknetrtav.fromJson(Map<String, dynamic> json) {
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

class Jahirakaryakramasambandhi {
  int? count;
  int? nivasasathiupalabdha;
  int? sankhya;
  String? value;

  Jahirakaryakramasambandhi(
      {this.count, this.nivasasathiupalabdha, this.sankhya, this.value});

  Jahirakaryakramasambandhi.fromJson(Map<String, dynamic> json) {
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

class Maidan {
  int? count;
  Null? nivasasathiupalabdha;
  int? sankhya;
  Null? value;

  Maidan({this.count, this.nivasasathiupalabdha, this.sankhya, this.value});

  Maidan.fromJson(Map<String, dynamic> json) {
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

class NagarVastisarvekshanReportwithselectedlevel {
  int? geounitid;
  int? nagarAllStepsCompleteCount;
  int? nagarStep1CompleteCount;
  int? nagarStep2CompleteCount;
  int? nagarStep3CompleteCount;
  int? nagarStepStartedCount;
  int? nagarStepsNotstartedCount;
  int? nagarcount;
  String? name;
  int? vastiAllStepsCompleteCount;
  String? vastiAllStepsCompleteNames;
  int? vastiStep1CompleteCount;
  String? vastiStep1CompleteNames;
  int? vastiStep2CompleteCount;
  String? vastiStep2CompleteNames;
  int? vastiStep3CompleteCount;
  String? vastiStep3CompleteNames;
  int? vastiStepStartedCount;
  String? vastiStepStartedNames;
  int? vastiStepsNotstartedCount;
  String? vastiStepsNotstartedNames;
  int? vasticount;

  NagarVastisarvekshanReportwithselectedlevel(
      {this.geounitid,
        this.nagarAllStepsCompleteCount,
        this.nagarStep1CompleteCount,
        this.nagarStep2CompleteCount,
        this.nagarStep3CompleteCount,
        this.nagarStepStartedCount,
        this.nagarStepsNotstartedCount,
        this.nagarcount,
        this.name,
        this.vastiAllStepsCompleteCount,
        this.vastiAllStepsCompleteNames,
        this.vastiStep1CompleteCount,
        this.vastiStep1CompleteNames,
        this.vastiStep2CompleteCount,
        this.vastiStep2CompleteNames,
        this.vastiStep3CompleteCount,
        this.vastiStep3CompleteNames,
        this.vastiStepStartedCount,
        this.vastiStepStartedNames,
        this.vastiStepsNotstartedCount,
        this.vastiStepsNotstartedNames,
        this.vasticount});

  NagarVastisarvekshanReportwithselectedlevel.fromJson(
      Map<String, dynamic> json) {
    geounitid = json['geounitid'];
    nagarAllStepsCompleteCount = json['nagar_all_steps_complete_count'];
    nagarStep1CompleteCount = json['nagar_step1_complete_count'];
    nagarStep2CompleteCount = json['nagar_step2_complete_count'];
    nagarStep3CompleteCount = json['nagar_step3_complete_count'];
    nagarStepStartedCount = json['nagar_step_started_count'];
    nagarStepsNotstartedCount = json['nagar_steps_notstarted_count'];
    nagarcount = json['nagarcount'];
    name = json['name'];
    vastiAllStepsCompleteCount = json['vasti_all_steps_complete_count'];
    vastiAllStepsCompleteNames = json['vasti_all_steps_complete_names'];
    vastiStep1CompleteCount = json['vasti_step1_complete_count'];
    vastiStep1CompleteNames = json['vasti_step1_complete_names'];
    vastiStep2CompleteCount = json['vasti_step2_complete_count'];
    vastiStep2CompleteNames = json['vasti_step2_complete_names'];
    vastiStep3CompleteCount = json['vasti_step3_complete_count'];
    vastiStep3CompleteNames = json['vasti_step3_complete_names'];
    vastiStepStartedCount = json['vasti_step_started_count'];
    vastiStepStartedNames = json['vasti_step_started_names'];
    vastiStepsNotstartedCount = json['vasti_steps_notstarted_count'];
    vastiStepsNotstartedNames = json['vasti_steps_notstarted_names'];
    vasticount = json['vasticount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geounitid'] = this.geounitid;
    data['nagar_all_steps_complete_count'] = this.nagarAllStepsCompleteCount;
    data['nagar_step1_complete_count'] = this.nagarStep1CompleteCount;
    data['nagar_step2_complete_count'] = this.nagarStep2CompleteCount;
    data['nagar_step3_complete_count'] = this.nagarStep3CompleteCount;
    data['nagar_step_started_count'] = this.nagarStepStartedCount;
    data['nagar_steps_notstarted_count'] = this.nagarStepsNotstartedCount;
    data['nagarcount'] = this.nagarcount;
    data['name'] = this.name;
    data['vasti_all_steps_complete_count'] = this.vastiAllStepsCompleteCount;
    data['vasti_all_steps_complete_names'] = this.vastiAllStepsCompleteNames;
    data['vasti_step1_complete_count'] = this.vastiStep1CompleteCount;
    data['vasti_step1_complete_names'] = this.vastiStep1CompleteNames;
    data['vasti_step2_complete_count'] = this.vastiStep2CompleteCount;
    data['vasti_step2_complete_names'] = this.vastiStep2CompleteNames;
    data['vasti_step3_complete_count'] = this.vastiStep3CompleteCount;
    data['vasti_step3_complete_names'] = this.vastiStep3CompleteNames;
    data['vasti_step_started_count'] = this.vastiStepStartedCount;
    data['vasti_step_started_names'] = this.vastiStepStartedNames;
    data['vasti_steps_notstarted_count'] = this.vastiStepsNotstartedCount;
    data['vasti_steps_notstarted_names'] = this.vastiStepsNotstartedNames;
    data['vasticount'] = this.vasticount;
    return data;
  }
}

class Jagran {
  String? maintype;
  String? subtype;
  int? vastiCount;

  Jagran({this.maintype, this.subtype, this.vastiCount});

  Jagran.fromJson(Map<String, dynamic> json) {
    maintype = json['maintype'];
    subtype = json['subtype'];
    vastiCount = json['vastiCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maintype'] = this.maintype;
    data['subtype'] = this.subtype;
    data['vastiCount'] = this.vastiCount;
    return data;
  }
}

class Gatividhi {
  String? maintype;
  String? subtype;
  int? vastiCount;

  Gatividhi({this.maintype, this.subtype, this.vastiCount});

  Gatividhi.fromJson(Map<String, dynamic> json) {
    maintype = json['maintype'];
    subtype = json['subtype'];
    vastiCount = json['vastiCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maintype'] = this.maintype;
    data['subtype'] = this.subtype;
    data['vastiCount'] = this.vastiCount;
    return data;
  }
}

class Vasahatsamparkashiti {
  String? maintype;
  String? subtype;
  int? vastiCount;

  Vasahatsamparkashiti({this.maintype, this.subtype, this.vastiCount});

  Vasahatsamparkashiti.fromJson(Map<String, dynamic> json) {
    maintype = json['maintype'];
    subtype = json['subtype'];
    vastiCount = json['vastiCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maintype'] = this.maintype;
    data['subtype'] = this.subtype;
    data['vastiCount'] = this.vastiCount;
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

class SocialOrganizationKaaryakartaaCountByAreaOfOperation {
  int? mainAreaOfOperationID ;
  int? kaaryakartaaCount;
  String? areaOfOperation ;

  SocialOrganizationKaaryakartaaCountByAreaOfOperation({this.mainAreaOfOperationID, this.kaaryakartaaCount, this.areaOfOperation });

  SocialOrganizationKaaryakartaaCountByAreaOfOperation.fromJson(Map<String, dynamic> json) {
    mainAreaOfOperationID = json['MainAreaOfOperationID'];
    kaaryakartaaCount = json['KaaryakartaaCount'];
    areaOfOperation = json['AreaOfOperation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MainAreaOfOperationID'] = this.mainAreaOfOperationID;
    data['KaaryakartaaCount'] = this.kaaryakartaaCount;
    data['AreaOfOperation'] = this.areaOfOperation;
    return data;
  }
}

class PurviShakhaHoti {
  int? count;
  Null? nivasasathiupalabdha;
  Null? sankhya;
  String? value;

  PurviShakhaHoti(
      {this.count, this.nivasasathiupalabdha, this.sankhya, this.value});

  PurviShakhaHoti.fromJson(Map<String, dynamic> json) {
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

class PurviSptahikMilanHote {
  int? count;
  Null? nivasasathiupalabdha;
  Null? sankhya;
  String? value;

  PurviSptahikMilanHote(
      {this.count, this.nivasasathiupalabdha, this.sankhya, this.value});

  PurviSptahikMilanHote.fromJson(Map<String, dynamic> json) {
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