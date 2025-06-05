class TalukaMandalSampurnaModel {
  String? message;
  List<TalukaMandalsarvekshanReportwithname>? nagarVastisarvekshanReportwithname;
  String? status;

  TalukaMandalSampurnaModel(
      {this.message, this.nagarVastisarvekshanReportwithname, this.status});

  TalukaMandalSampurnaModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    if (json['NagarVastisarvekshanReportwithname'] != null) {
      nagarVastisarvekshanReportwithname =
      <TalukaMandalsarvekshanReportwithname>[];
      json['NagarVastisarvekshanReportwithname'].forEach((v) {
        nagarVastisarvekshanReportwithname!
            .add(new TalukaMandalsarvekshanReportwithname.fromJson(v));
      });
    }
    status = json['Status'];
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
    return data;
  }
}

class TalukaMandalsarvekshanReportwithname {
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

  TalukaMandalsarvekshanReportwithname(
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

  TalukaMandalsarvekshanReportwithname.fromJson(Map<String, dynamic> json) {
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
