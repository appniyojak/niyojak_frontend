class TalukaMandalSampurnaModel {
  String? message;
  String? status;
  TalukamandalHinduvirayadi? talukamandalHinduvirayadi;
  TalukamandalMumbaikar? talukamandalMumbaikar;
  List<TalukamandalReligion>? talukamandalReligion;
  List<TalukamandalSamajikkaryakram>? talukamandalSamajikkaryakram;
  List<Talukamandalmahatvacesana>? talukamandalmahatvacesana;
  List<TalukamandalsarvekshanReportwithname>?
  talukamandalsarvekshanReportwithname;
  TalukamandalsarvekshanReportwithselectedlevel?
  talukamandalsarvekshanReportwithselectedlevel;
  List<Talukamandalupaasana>? talukamandalupaasana;
  List<TalukamandalListSwayamsevakCountByVyavasaayeeCategory>?
  talukamandalListSwayamsevakCountByVyavasaayeeCategory;
  List<TalukamandalListSwayamsevakCountByStudentCategory>?
  talukamandalListSwayamsevakCountByStudentCategory;
  List<TalukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation>?
  talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation;
  List<TalukamandalListKaaryakartaaCountByAayaam>?
  talukamandalListKaaryakartaaCountByAayaam;
  List<TalukamandalListKaaryakartaaCountByGatividhi>?
  talukamandalListKaaryakartaaCountByGatividhi;
  Loksankhyaformandal? loksankhyaformandal;

  TalukaMandalSampurnaModel(
      {this.message,
        this.status,
        this.talukamandalHinduvirayadi,
        this.talukamandalMumbaikar,
        this.talukamandalReligion,
        this.talukamandalSamajikkaryakram,
        this.talukamandalmahatvacesana,
        this.talukamandalsarvekshanReportwithname,
        this.talukamandalsarvekshanReportwithselectedlevel,
        this.talukamandalupaasana,
        this.talukamandalListSwayamsevakCountByVyavasaayeeCategory,
        this.talukamandalListSwayamsevakCountByStudentCategory,
        this.talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation,
        this.talukamandalListKaaryakartaaCountByAayaam,
        this.talukamandalListKaaryakartaaCountByGatividhi,
        this.loksankhyaformandal
      });

  TalukaMandalSampurnaModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    talukamandalHinduvirayadi = json['talukamandalHinduvirayadi'] != null
        ? new TalukamandalHinduvirayadi.fromJson(
        json['talukamandalHinduvirayadi'])
        : null;
    talukamandalMumbaikar = json['talukamandalMumbaikar'] != null
        ? new TalukamandalMumbaikar.fromJson(json['talukamandalMumbaikar'])
        : null;
    if (json['talukamandalReligion'] != null) {
      talukamandalReligion = <TalukamandalReligion>[];
      json['talukamandalReligion'].forEach((v) {
        talukamandalReligion!.add(new TalukamandalReligion.fromJson(v));
      });
    }
    if (json['talukamandalSamajikkaryakram'] != null) {
      talukamandalSamajikkaryakram = <TalukamandalSamajikkaryakram>[];
      json['talukamandalSamajikkaryakram'].forEach((v) {
        talukamandalSamajikkaryakram!
            .add(new TalukamandalSamajikkaryakram.fromJson(v));
      });
    }
    if (json['talukamandalmahatvacesana'] != null) {
      talukamandalmahatvacesana = <Talukamandalmahatvacesana>[];
      json['talukamandalmahatvacesana'].forEach((v) {
        talukamandalmahatvacesana!
            .add(new Talukamandalmahatvacesana.fromJson(v));
      });
    }
    if (json['talukamandalsarvekshanReportwithname'] != null) {
      talukamandalsarvekshanReportwithname =
      <TalukamandalsarvekshanReportwithname>[];
      json['talukamandalsarvekshanReportwithname'].forEach((v) {
        talukamandalsarvekshanReportwithname!
            .add(new TalukamandalsarvekshanReportwithname.fromJson(v));
      });
    }
    talukamandalsarvekshanReportwithselectedlevel =
    json['talukamandalsarvekshanReportwithselectedlevel'] != null
        ? new TalukamandalsarvekshanReportwithselectedlevel.fromJson(
        json['talukamandalsarvekshanReportwithselectedlevel'])
        : null;
    if (json['talukamandalupaasana'] != null) {
      talukamandalupaasana = <Talukamandalupaasana>[];
      json['talukamandalupaasana'].forEach((v) {
        talukamandalupaasana!.add(new Talukamandalupaasana.fromJson(v));
      });
    }
    if (json['talukamandalListSwayamsevakCountByVyavasaayeeCategory'] != null) {
      talukamandalListSwayamsevakCountByVyavasaayeeCategory =
      <TalukamandalListSwayamsevakCountByVyavasaayeeCategory>[];
      json['talukamandalListSwayamsevakCountByVyavasaayeeCategory']
          .forEach((v) {
        talukamandalListSwayamsevakCountByVyavasaayeeCategory!.add(
            new TalukamandalListSwayamsevakCountByVyavasaayeeCategory.fromJson(
                v));
      });
    }
    if (json['talukamandalListSwayamsevakCountByStudentCategory'] != null) {
      talukamandalListSwayamsevakCountByStudentCategory =
      <TalukamandalListSwayamsevakCountByStudentCategory>[];
      json['talukamandalListSwayamsevakCountByStudentCategory'].forEach((v) {
        talukamandalListSwayamsevakCountByStudentCategory!.add(
            new TalukamandalListSwayamsevakCountByStudentCategory.fromJson(v));
      });
    }
    if (json['talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'] !=null) {
      talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation = <
          TalukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation>[];
      json['talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation']
          .forEach((v) {
        talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!.add(
            new TalukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation
                .fromJson(v));
      });
    }
    if (json['talukamandalListKaaryakartaaCountByAayaam'] != null) {
      talukamandalListKaaryakartaaCountByAayaam =
      <TalukamandalListKaaryakartaaCountByAayaam>[];
      json['talukamandalListKaaryakartaaCountByAayaam'].forEach((v) {
        talukamandalListKaaryakartaaCountByAayaam!
            .add(new TalukamandalListKaaryakartaaCountByAayaam.fromJson(v));
      });
    }
    if (json['talukamandalListKaaryakartaaCountByGatividhi'] != null) {
      talukamandalListKaaryakartaaCountByGatividhi =
      <TalukamandalListKaaryakartaaCountByGatividhi>[];
      json['talukamandalListKaaryakartaaCountByGatividhi'].forEach((v) {
        talukamandalListKaaryakartaaCountByGatividhi!
            .add(new TalukamandalListKaaryakartaaCountByGatividhi.fromJson(v));
      });
    }
    loksankhyaformandal = json['loksankhyaformandal'] != null
        ? new Loksankhyaformandal.fromJson(json['loksankhyaformandal'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.talukamandalHinduvirayadi != null) {
      data['talukamandalHinduvirayadi'] =
          this.talukamandalHinduvirayadi!.toJson();
    }
    if (this.talukamandalMumbaikar != null) {
      data['talukamandalMumbaikar'] = this.talukamandalMumbaikar!.toJson();
    }
    if (this.talukamandalReligion != null) {
      data['talukamandalReligion'] =
          this.talukamandalReligion!.map((v) => v.toJson()).toList();
    }
    if (this.talukamandalSamajikkaryakram != null) {
      data['talukamandalSamajikkaryakram'] =
          this.talukamandalSamajikkaryakram!.map((v) => v.toJson()).toList();
    }
    if (this.talukamandalmahatvacesana != null) {
      data['talukamandalmahatvacesana'] =
          this.talukamandalmahatvacesana!.map((v) => v.toJson()).toList();
    }
    if (this.talukamandalsarvekshanReportwithname != null) {
      data['talukamandalsarvekshanReportwithname'] = this
          .talukamandalsarvekshanReportwithname!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.talukamandalsarvekshanReportwithselectedlevel != null) {
      data['talukamandalsarvekshanReportwithselectedlevel'] =
          this.talukamandalsarvekshanReportwithselectedlevel!.toJson();
    }
    if (this.talukamandalupaasana != null) {
      data['talukamandalupaasana'] =
          this.talukamandalupaasana!.map((v) => v.toJson()).toList();
    }
    if (this.talukamandalListSwayamsevakCountByVyavasaayeeCategory != null) {
      data['talukamandalListSwayamsevakCountByVyavasaayeeCategory'] = this
          .talukamandalListSwayamsevakCountByVyavasaayeeCategory!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.talukamandalListSwayamsevakCountByStudentCategory != null) {
      data['talukamandalListSwayamsevakCountByStudentCategory'] = this
          .talukamandalListSwayamsevakCountByStudentCategory!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation !=null) {
      data['talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'] =
          this
              .talukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation!
              .map((v) => v.toJson())
              .toList();
    }
    if (this.talukamandalListKaaryakartaaCountByAayaam != null) {
      data['talukamandalListKaaryakartaaCountByAayaam'] = this
          .talukamandalListKaaryakartaaCountByAayaam!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.talukamandalListKaaryakartaaCountByGatividhi != null) {
      data['talukamandalListKaaryakartaaCountByGatividhi'] = this
          .talukamandalListKaaryakartaaCountByGatividhi!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.loksankhyaformandal != null) {
      data['loksankhyaformandal'] = this.loksankhyaformandal!.toJson();
    }
    return data;
  }
}
class TalukamandalHinduvirayadi {
  int? gramCount;
  int? mandalCount;
  int? sankhya;
  String? value;

  TalukamandalHinduvirayadi(
      {this.gramCount, this.mandalCount, this.sankhya, this.value});

  TalukamandalHinduvirayadi.fromJson(Map<String, dynamic> json) {
    gramCount = json['GramCount'];
    mandalCount = json['MandalCount'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GramCount'] = this.gramCount;
    data['MandalCount'] = this.mandalCount;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}
class TalukamandalMumbaikar {
  int? gramCount;
  int? mandalCount;
  Null? sankhya;
  Null? value;

  TalukamandalMumbaikar(
      {this.gramCount, this.mandalCount, this.sankhya, this.value});

  TalukamandalMumbaikar.fromJson(Map<String, dynamic> json) {
    gramCount = json['GramCount'];
    mandalCount = json['MandalCount'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GramCount'] = this.gramCount;
    data['MandalCount'] = this.mandalCount;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}
class TalukamandalReligion {
  int? gramCount;
  int? mandalCount;
  int? sankhya;
  String? value;

  TalukamandalReligion(
      {this.gramCount, this.mandalCount, this.sankhya, this.value});

  TalukamandalReligion.fromJson(Map<String, dynamic> json) {
    gramCount = json['GramCount'];
    mandalCount = json['MandalCount'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GramCount'] = this.gramCount;
    data['MandalCount'] = this.mandalCount;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}
class TalukamandalsarvekshanReportwithname {
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
  Null? vastiAllStepsCompleteNames;
  int? vastiStep1CompleteCount;
  Null? vastiStep1CompleteNames;
  int? vastiStep2CompleteCount;
  Null? vastiStep2CompleteNames;
  int? vastiStep3CompleteCount;
  Null? vastiStep3CompleteNames;
  int? vastiStepStartedCount;
  Null? vastiStepStartedNames;
  int? vastiStepsNotstartedCount;
  Null? vastiStepsNotstartedNames;
  int? vasticount;

  TalukamandalsarvekshanReportwithname(
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

  TalukamandalsarvekshanReportwithname.fromJson(Map<String, dynamic> json) {
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
class TalukamandalsarvekshanReportwithselectedlevel {
  Null? geounitid;
  int? nagarAllStepsCompleteCount;
  int? nagarStep1CompleteCount;
  int? nagarStep2CompleteCount;
  int? nagarStep3CompleteCount;
  int? nagarStepStartedCount;
  int? nagarStepsNotstartedCount;
  int? nagarcount;
  Null? name;
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

  TalukamandalsarvekshanReportwithselectedlevel(
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

  TalukamandalsarvekshanReportwithselectedlevel.fromJson(
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
class TalukamandalSamajikkaryakram {
  int? gramCount;
  int? mandalCount;
  int? sankhya;
  String? value;

  TalukamandalSamajikkaryakram(
      {this.gramCount, this.mandalCount, this.sankhya, this.value});

  TalukamandalSamajikkaryakram.fromJson(Map<String, dynamic> json) {
    gramCount = json['GramCount'];
    mandalCount = json['MandalCount'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GramCount'] = this.gramCount;
    data['MandalCount'] = this.mandalCount;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}
class Talukamandalmahatvacesana {
  int? gramCount;
  int? mandalCount;
  int? sankhya;
  String? value;

  Talukamandalmahatvacesana(
      {this.gramCount, this.mandalCount, this.sankhya, this.value});

  Talukamandalmahatvacesana.fromJson(Map<String, dynamic> json) {
    gramCount = json['GramCount'];
    mandalCount = json['MandalCount'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GramCount'] = this.gramCount;
    data['MandalCount'] = this.mandalCount;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}
class Talukamandalupaasana {
  int? gramCount;
  int? mandalCount;
  int? sankhya;
  String? value;

  Talukamandalupaasana(
      {this.gramCount, this.mandalCount, this.sankhya, this.value});

  Talukamandalupaasana.fromJson(Map<String, dynamic> json) {
    gramCount = json['GramCount'];
    mandalCount = json['MandalCount'];
    sankhya = json['sankhya'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GramCount'] = this.gramCount;
    data['MandalCount'] = this.mandalCount;
    data['sankhya'] = this.sankhya;
    data['value'] = this.value;
    return data;
  }
}
class TalukamandalListSwayamsevakCountByVyavasaayeeCategory {
  int? countByVyavasaayeeCategory;
  int? vyavasaayeeCategoryID;
  String? vyavasaayeeCategoryName;

  TalukamandalListSwayamsevakCountByVyavasaayeeCategory(
      {this.countByVyavasaayeeCategory,
        this.vyavasaayeeCategoryID,
        this.vyavasaayeeCategoryName});

  TalukamandalListSwayamsevakCountByVyavasaayeeCategory.fromJson(
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
class TalukamandalListSwayamsevakCountByStudentCategory {
  int? countByStudentCategory;
  int? studentCategoryID;
  String? studentCategoryName;

  TalukamandalListSwayamsevakCountByStudentCategory(
      {this.countByStudentCategory,
        this.studentCategoryID,
        this.studentCategoryName});

  TalukamandalListSwayamsevakCountByStudentCategory.fromJson(
      Map<String, dynamic> json) {
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
class TalukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation {
  String? areaOfOperation;
  int? areaOfOperationID;
  int? kaaryakartaaCount;

  TalukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation(
      {this.areaOfOperation, this.areaOfOperationID, this.kaaryakartaaCount});

  TalukamandalListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation.fromJson(
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
class TalukamandalListKaaryakartaaCountByAayaam {
  int? aayaamID;
  String? aayaamName;
  int? kaaryakartaaCount;

  TalukamandalListKaaryakartaaCountByAayaam(
      {this.aayaamID, this.aayaamName, this.kaaryakartaaCount});

  TalukamandalListKaaryakartaaCountByAayaam.fromJson(
      Map<String, dynamic> json) {
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
class TalukamandalListKaaryakartaaCountByGatividhi {
  int? gatividhiID;
  String? gatividhiName;
  int? kaaryakartaaCount;

  TalukamandalListKaaryakartaaCountByGatividhi(
      {this.gatividhiID, this.gatividhiName, this.kaaryakartaaCount});

  TalukamandalListKaaryakartaaCountByGatividhi.fromJson(
      Map<String, dynamic> json) {
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
        this.vibhaagKaaryakartaaCount});

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
    return data;
  }
}
