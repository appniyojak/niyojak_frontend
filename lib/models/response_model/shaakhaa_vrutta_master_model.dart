class ShaakhaaVruttaMaster {
  int? pkid;
  int? shaakhaaID;
  String? vruttaDate;
  int? shishuCount;
  int? newShishuCount;
  int? baalVidyaarthiCount;
  int? newBaalVidyaarthiCount;
  int? tarunVidyaarthiCount;
  int? newTarunVidyaarthiCount;
  int? tarunVyavasaayeeCount;
  int? newTarunVyavasaayeeCount;
  int? proudhaVyavasaayeeCount;
  int? newProudhaVyavasaayeeCount;
  int? matruskatiCount;
  int? newmatruskatiCount;
  int? totalCount;
  int? newtotalCount;
  int? abhyaagatCount;
  bool? isOptionalShaaririk;
  bool? isOptionalOther;
  String? remark;
  bool? isDoneDeepBreathing;
  bool? isDoneDandaPrahaar;
  bool? isDoneSooryaNamaskaar;
  bool? isDoneSanchalanAbhyaas;
  bool? isDoneSaanghikGeet;
  bool? isDoneAmrutaVachan;
  bool? isDoneSubhaashit;
  int? boudhikDaysId;
  String? sewaDaysId;
  bool? isDoneUrdhvapad;
  bool? isDoneBoodhKatha;
  bool? isDoneBoudhikDays;
  bool? isDoneSewaDays;
  String? anyaBoudhikDays;
  int? pravasiKaryakartaCount;
  int? anyaPravasiKaryakartaCount;

  ShaakhaaVruttaMaster(
      {this.pkid,
      this.shaakhaaID,
      this.vruttaDate,
      this.shishuCount,
      this.newShishuCount,
      this.baalVidyaarthiCount,
      this.newBaalVidyaarthiCount,
      this.tarunVidyaarthiCount,
      this.newTarunVidyaarthiCount,
      this.tarunVyavasaayeeCount,
      this.newTarunVyavasaayeeCount,
      this.proudhaVyavasaayeeCount,
      this.newProudhaVyavasaayeeCount,
      this.matruskatiCount,
      this.newmatruskatiCount,
      this.totalCount,
      this.newtotalCount,
      this.abhyaagatCount,
      this.isOptionalShaaririk,
      this.isOptionalOther,
      this.remark,
      this.isDoneDeepBreathing,
      this.isDoneDandaPrahaar,
      this.isDoneSooryaNamaskaar,
      this.isDoneSanchalanAbhyaas,
      this.isDoneSaanghikGeet,
      this.isDoneAmrutaVachan,
      this.isDoneSubhaashit,
      this.boudhikDaysId,
      this.sewaDaysId,
      this.isDoneUrdhvapad,
      this.isDoneBoodhKatha,
      this.isDoneBoudhikDays,
      this.isDoneSewaDays,
      this.anyaBoudhikDays,
      this.pravasiKaryakartaCount,
      this.anyaPravasiKaryakartaCount});

  ShaakhaaVruttaMaster.fromJson(Map<String, dynamic> json) {
    pkid = json['pkid'];
    shaakhaaID = json['ShaakhaaID'];
    vruttaDate = json['VruttaDate'];
    shishuCount = json['ShishuCount'];
    newShishuCount = json['NewShishuCount'];
    baalVidyaarthiCount = json['BaalVidyaarthiCount'];
    newBaalVidyaarthiCount = json['NewBaalVidyaarthiCount'];
    tarunVidyaarthiCount = json['TarunVidyaarthiCount'];
    newTarunVidyaarthiCount = json['NewTarunVidyaarthiCount'];
    tarunVyavasaayeeCount = json['TarunVyavasaayeeCount'];
    newTarunVyavasaayeeCount = json['NewTarunVyavasaayeeCount'];
    proudhaVyavasaayeeCount = json['ProudhaVyavasaayeeCount'];
    newProudhaVyavasaayeeCount = json['NewProudhaVyavasaayeeCount'];
    matruskatiCount = json['matruskatiCount'];
    newmatruskatiCount = json['newmatruskatiCount'];
    totalCount = json['totalCount'];
    newtotalCount = json['newtotalCount'];
    abhyaagatCount = json['AbhyaagatCount'];
    isOptionalShaaririk = json['IsOptionalShaaririk'];
    isOptionalOther = json['IsOptionalOther'];
    remark = json['Remark'];
    isDoneDeepBreathing = json['IsDoneDeepBreathing'];
    isDoneDandaPrahaar = json['IsDoneDandaPrahaar'];
    isDoneSooryaNamaskaar = json['IsDoneSooryaNamaskaar'];
    isDoneSanchalanAbhyaas = json['IsDoneSanchalanAbhyaas'];
    isDoneSaanghikGeet = json['IsDoneSaanghikGeet'];
    isDoneAmrutaVachan = json['IsDoneAmrutaVachan'];
    isDoneSubhaashit = json['IsDoneSubhaashit'];
    boudhikDaysId = json['BoudhikDaysId'];
    sewaDaysId = json['SewaDaysId'];
    isDoneUrdhvapad = json['IsDoneUrdhvapad'];
    isDoneBoodhKatha = json['IsDoneBoodhKatha'];
    isDoneBoudhikDays = json['IsDoneBoudhikDays'];
    isDoneSewaDays = json['IsDoneSewaDays'];
    anyaBoudhikDays = json['AnyaBoudhikDays'];
    pravasiKaryakartaCount = json['PravasiKaryakartaCount'];
    anyaPravasiKaryakartaCount = json['AnyaPravasiKaryakartaCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['ShaakhaaID'] = this.shaakhaaID;
    data['VruttaDate'] = this.vruttaDate;
    data['ShishuCount'] = this.shishuCount;
    data['NewShishuCount'] = this.newShishuCount;
    data['BaalVidyaarthiCount'] = this.baalVidyaarthiCount;
    data['NewBaalVidyaarthiCount'] = this.newBaalVidyaarthiCount;
    data['TarunVidyaarthiCount'] = this.tarunVidyaarthiCount;
    data['NewTarunVidyaarthiCount'] = this.newTarunVidyaarthiCount;
    data['TarunVyavasaayeeCount'] = this.tarunVyavasaayeeCount;
    data['NewTarunVyavasaayeeCount'] = this.newTarunVyavasaayeeCount;
    data['ProudhaVyavasaayeeCount'] = this.proudhaVyavasaayeeCount;
    data['NewProudhaVyavasaayeeCount'] = this.newProudhaVyavasaayeeCount;
    data['matruskatiCount'] = this.matruskatiCount;
    data['newmatruskatiCount'] = this.newmatruskatiCount;
    data['totalCount'] = this.totalCount;
    data['newtotalCount'] = this.newtotalCount;
    data['AbhyaagatCount'] = this.abhyaagatCount;
    data['IsOptionalShaaririk'] = this.isOptionalShaaririk;
    data['IsOptionalOther'] = this.isOptionalOther;
    data['Remark'] = this.remark;
    data['IsDoneDeepBreathing'] = this.isDoneDeepBreathing;
    data['IsDoneDandaPrahaar'] = this.isDoneDandaPrahaar;
    data['IsDoneSooryaNamaskaar'] = this.isDoneSooryaNamaskaar;
    data['IsDoneSanchalanAbhyaas'] = this.isDoneSanchalanAbhyaas;
    data['IsDoneSaanghikGeet'] = this.isDoneSaanghikGeet;
    data['IsDoneAmrutaVachan'] = this.isDoneAmrutaVachan;
    data['IsDoneSubhaashit'] = this.isDoneSubhaashit;
    data['BoudhikDaysId'] = this.boudhikDaysId;
    data['SewaDaysId'] = this.sewaDaysId;
    data['IsDoneUrdhvapad'] = this.isDoneUrdhvapad;
    data['IsDoneBoodhKatha'] = this.isDoneBoodhKatha;
    data['IsDoneBoudhikDays'] = this.isDoneBoudhikDays;
    data['IsDoneSewaDays'] = this.isDoneSewaDays;
    data['AnyaBoudhikDays'] = this.anyaBoudhikDays;
    data['PravasiKaryakartaCount'] = this.pravasiKaryakartaCount;
    data['AnyaPravasiKaryakartaCount'] = this.anyaPravasiKaryakartaCount;
    return data;
  }
}
