class GetVastiDataByIdModel {
  String? message;
  String? status;
  Vastisarvekshan? vastisarvekshan;

  GetVastiDataByIdModel({this.message, this.status, this.vastisarvekshan});

  GetVastiDataByIdModel.fromJson(Map<String, dynamic> json) {
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
  String? lokasankhya;
  int? maleSankhya;
  int? femaleSankhya;
  String? vadicheNave;
  String? andajeGhare;
  int? policethane;
  String? vasticyacatuSima;
  List<VastisarAnyaprabhavilokam>? vastisarAnyaprabhavilokam;
  List<VastisarGatividhikaryasthiti>? vastisarGatividhikaryasthiti;
  List<VastisarHinduvirayadi>? vastisarHinduvirayadi;
  List<VastisarJaagaranshreneesthiti>? vastisarJaagaranshreneesthiti;
  List<VastisarSewaPrakalpa>? vastisarSewaPrakalpa;
  List<VastisarVividhKshetracheKam>? vastisarVividhKshetracheKam;
  List<VastisarGavatilMumbaikar>? vastisarGavatilMumbaikar;
  List<VastisarVadiGharLoksankhya>? vastisarVadiGharLoksankhya;
  List<VastisarVividhAdhyatmikKendra>? vastisarVividhAdhyatmikKendra;
  List<VastisarJahirakaryakramasambandhi>? vastisarJahirakaryakramasambandhi;
  List<VastisarKonatyaprantache>? vastisarKonatyaprantache;
  List<VastisarKuthalyavarsi>? vastisarKuthalyavarsi;
  List<VastisarMotherugnalaya>? vastisarMotherugnalaya;
  List<VastisarMothevyavasayikakendra>? vastisarMothevyavasayikakendra;
  List<VastisarNirmanadhinamothe>? vastisarNirmanadhinamothe;
  List<VastisarReligion>? vastisarReligion;
  List<VastisarVasahatprakara>? vastisarVasahatprakara;
  List<VastisarVastitamahatvacesana>? vastisarVastitamahatvacesana;
  List<VastisarVastitasajaraSamajikkaryakram>?
      vastisarVastitasajaraSamajikkaryakram;
  List<VastisarVastitilabalopasanakendra>? vastisarVastitilabalopasanakendra;
  List<VastisarVastitilasamajika>? vastisarVastitilasamajika;
  List<VastisarVividhaprakara>? vastisarVividhaprakara;
  List<Vastisardhaarmiknetrtav>? vastisardhaarmiknetrtav;
  List<Vastisardurjanshakti>? vastisardurjanshakti;
  List<Vastisarmaidan>? vastisarmaidan;
  List<Vastisarsajjanshakti>? vastisarsajjanshakti;
  List<Vastisarschooltapasila>? vastisarschooltapasila;
  List<Vastisarupaasana>? vastisarupaasana;
  String? vastitasajaraanyakaryakaram;
  String? vastitilasamajikaque;
  int? agnishamandal;
  String? anyadhaarmik;
  String? balopaasanakendr;
  int? beforeShakhaSaptahikIsOnNowOff;
  int? anyaVividhKshetracheKame;
  int? isGavatilMumbaikar;
  int? cuserid;
  String? googlemap;
  int? pkid;
  String? vastiShakhaPramukhName;
  String? vastiShakhaSamiti;
  int? durjanShaktiYesNo;
  String? vastiShakhaType;
  String? vastiShakhaTypevalue;
  int? vastiid;
  int? step1completepercentage;
  int? step2completepercentage;
  int? step3completepercentage;
  bool? stepOneComplete;
  bool? stepTwoComplete;
  String? sarpanchacheNaav;
  String? sarpanchacheDoorbhash;

  Vastisarvekshan({
    this.lokasankhya,
    this.femaleSankhya,
    this.maleSankhya,
    this.vadicheNave,
    this.andajeGhare,
    this.policethane,
    this.vasticyacatuSima,
    this.vastisarAnyaprabhavilokam,
    this.vastisarGatividhikaryasthiti,
    this.vastisarHinduvirayadi,
    this.vastisarJaagaranshreneesthiti,
    this.vastisarJahirakaryakramasambandhi,
    this.vastisarKonatyaprantache,
    this.vastisarKuthalyavarsi,
    this.vastisarMotherugnalaya,
    this.vastisarMothevyavasayikakendra,
    this.vastisarNirmanadhinamothe,
    this.vastisarReligion,
    this.vastisarVasahatprakara,
    this.vastisarVastitamahatvacesana,
    this.vastisarVastitasajaraSamajikkaryakram,
    this.vastisarVastitilabalopasanakendra,
    this.vastisarVastitilasamajika,
    this.vastisarVividhaprakara,
    this.vastisardhaarmiknetrtav,
    this.vastisardurjanshakti,
    this.vastisarmaidan,
    this.vastisarsajjanshakti,
    this.vastisarschooltapasila,
    this.vastisarupaasana,
    this.vastitasajaraanyakaryakaram,
    this.vastitilasamajikaque,
    this.agnishamandal,
    this.anyadhaarmik,
    this.balopaasanakendr,
    this.beforeShakhaSaptahikIsOnNowOff,
    this.anyaVividhKshetracheKame,
    this.isGavatilMumbaikar,
    this.cuserid,
    this.googlemap,
    this.pkid,
    this.vastiShakhaPramukhName,
    this.vastiShakhaSamiti,
    this.durjanShaktiYesNo,
    this.vastiShakhaType,
    this.vastiShakhaTypevalue,
    this.vastiid,
    this.step1completepercentage,
    this.step2completepercentage,
    this.step3completepercentage,
    this.stepOneComplete,
    this.stepTwoComplete,
    this.sarpanchacheNaav,
    this.sarpanchacheDoorbhash,
  });

  Vastisarvekshan.fromJson(Map<String, dynamic> json) {
    lokasankhya = json['Lokasankhya'];
    femaleSankhya = json['femaleCount'];
    maleSankhya = json['maleCount'];
    vadicheNave = json['vadicheNave'];
    andajeGhare = json['andajeGhare'];
    policethane = json['Policethane'];
    vasticyacatuSima = json['VasticyacatuSima'];
    if (json['VastisarAnyaprabhavilokam'] != null) {
      vastisarAnyaprabhavilokam = <VastisarAnyaprabhavilokam>[];
      json['VastisarAnyaprabhavilokam'].forEach((v) {
        vastisarAnyaprabhavilokam!
            .add(new VastisarAnyaprabhavilokam.fromJson(v));
      });
    }
    if (json['VastisarGatividhikaryasthiti'] != null) {
      vastisarGatividhikaryasthiti = <VastisarGatividhikaryasthiti>[];
      json['VastisarGatividhikaryasthiti'].forEach((v) {
        vastisarGatividhikaryasthiti!
            .add(new VastisarGatividhikaryasthiti.fromJson(v));
      });
    }
    if (json['VastisarHinduvirayadi'] != null) {
      vastisarHinduvirayadi = <VastisarHinduvirayadi>[];
      json['VastisarHinduvirayadi'].forEach((v) {
        vastisarHinduvirayadi!.add(new VastisarHinduvirayadi.fromJson(v));
      });
    }
    if (json['VastisarJaagaranshreneesthiti'] != null) {
      vastisarJaagaranshreneesthiti = <VastisarJaagaranshreneesthiti>[];
      json['VastisarJaagaranshreneesthiti'].forEach((v) {
        vastisarJaagaranshreneesthiti!
            .add(new VastisarJaagaranshreneesthiti.fromJson(v));
      });
    }
    if (json['VastisarSewaPrakalpa'] != null) {
      vastisarSewaPrakalpa = <VastisarSewaPrakalpa>[];
      json['VastisarSewaPrakalpa'].forEach((v) {
        vastisarSewaPrakalpa!.add(new VastisarSewaPrakalpa.fromJson(v));
      });
    }
    if (json['VastisarvividhKshetaCheKam'] != null) {
      vastisarVividhKshetracheKam = <VastisarVividhKshetracheKam>[];
      json['VastisarvividhKshetaCheKam'].forEach((v) {
        vastisarVividhKshetracheKam!
            .add(new VastisarVividhKshetracheKam.fromJson(v));
      });
    }
    if (json['VastisargavatilMumbaikar'] != null) {
      vastisarGavatilMumbaikar = <VastisarGavatilMumbaikar>[];
      json['VastisargavatilMumbaikar'].forEach((v) {
        vastisarGavatilMumbaikar!.add(new VastisarGavatilMumbaikar.fromJson(v));
      });
    }

    if (json['VastisarvadiGharLoksankhya'] != null) {
      vastisarVadiGharLoksankhya = <VastisarVadiGharLoksankhya>[];
      json['VastisarvadiGharLoksankhya'].forEach((v) {
        vastisarVadiGharLoksankhya!
            .add(new VastisarVadiGharLoksankhya.fromJson(v));
      });
    }
    if (json['VastisarvividhSampradhaySatsangKendra'] != null) {
      vastisarVividhAdhyatmikKendra = <VastisarVividhAdhyatmikKendra>[];
      json['VastisarvividhSampradhaySatsangKendra'].forEach((v) {
        vastisarVividhAdhyatmikKendra!
            .add(new VastisarVividhAdhyatmikKendra.fromJson(v));
      });
    }
    if (json['VastisarJahirakaryakramasambandhi'] != null) {
      vastisarJahirakaryakramasambandhi = <VastisarJahirakaryakramasambandhi>[];
      json['VastisarJahirakaryakramasambandhi'].forEach((v) {
        vastisarJahirakaryakramasambandhi!
            .add(new VastisarJahirakaryakramasambandhi.fromJson(v));
      });
    }
    if (json['VastisarKonatyaprantache'] != null) {
      vastisarKonatyaprantache = <VastisarKonatyaprantache>[];
      json['VastisarKonatyaprantache'].forEach((v) {
        vastisarKonatyaprantache!.add(new VastisarKonatyaprantache.fromJson(v));
      });
    }
    if (json['VastisarKuthalyavarsi'] != null) {
      vastisarKuthalyavarsi = <VastisarKuthalyavarsi>[];
      json['VastisarKuthalyavarsi'].forEach((v) {
        vastisarKuthalyavarsi!.add(new VastisarKuthalyavarsi.fromJson(v));
      });
    }
    if (json['VastisarMotherugnalaya'] != null) {
      vastisarMotherugnalaya = <VastisarMotherugnalaya>[];
      json['VastisarMotherugnalaya'].forEach((v) {
        vastisarMotherugnalaya!.add(new VastisarMotherugnalaya.fromJson(v));
      });
    }
    if (json['VastisarMothevyavasayikakendra'] != null) {
      vastisarMothevyavasayikakendra = <VastisarMothevyavasayikakendra>[];
      json['VastisarMothevyavasayikakendra'].forEach((v) {
        vastisarMothevyavasayikakendra!
            .add(new VastisarMothevyavasayikakendra.fromJson(v));
      });
    }
    if (json['VastisarNirmanadhinamothe'] != null) {
      vastisarNirmanadhinamothe = <VastisarNirmanadhinamothe>[];
      json['VastisarNirmanadhinamothe'].forEach((v) {
        vastisarNirmanadhinamothe!
            .add(new VastisarNirmanadhinamothe.fromJson(v));
      });
    }
    if (json['VastisarReligion'] != null) {
      vastisarReligion = <VastisarReligion>[];
      json['VastisarReligion'].forEach((v) {
        vastisarReligion!.add(new VastisarReligion.fromJson(v));
      });
    }
    if (json['VastisarVasahatprakara'] != null) {
      vastisarVasahatprakara = <VastisarVasahatprakara>[];
      json['VastisarVasahatprakara'].forEach((v) {
        vastisarVasahatprakara!.add(new VastisarVasahatprakara.fromJson(v));
      });
    }
    if (json['VastisarVastitamahatvacesana'] != null) {
      vastisarVastitamahatvacesana = <VastisarVastitamahatvacesana>[];
      json['VastisarVastitamahatvacesana'].forEach((v) {
        vastisarVastitamahatvacesana!
            .add(new VastisarVastitamahatvacesana.fromJson(v));
      });
    }
    if (json['VastisarVastitasajaraSamajikkaryakram'] != null) {
      vastisarVastitasajaraSamajikkaryakram =
          <VastisarVastitasajaraSamajikkaryakram>[];
      json['VastisarVastitasajaraSamajikkaryakram'].forEach((v) {
        vastisarVastitasajaraSamajikkaryakram!
            .add(new VastisarVastitasajaraSamajikkaryakram.fromJson(v));
      });
    }
    if (json['VastisarVastitilabalopasanakendra'] != null) {
      vastisarVastitilabalopasanakendra = <VastisarVastitilabalopasanakendra>[];
      json['VastisarVastitilabalopasanakendra'].forEach((v) {
        vastisarVastitilabalopasanakendra!
            .add(new VastisarVastitilabalopasanakendra.fromJson(v));
      });
    }
    if (json['VastisarVastitilasamajika'] != null) {
      vastisarVastitilasamajika = <VastisarVastitilasamajika>[];
      json['VastisarVastitilasamajika'].forEach((v) {
        vastisarVastitilasamajika!
            .add(new VastisarVastitilasamajika.fromJson(v));
      });
    }
    if (json['VastisarVividhaprakara'] != null) {
      vastisarVividhaprakara = <VastisarVividhaprakara>[];
      json['VastisarVividhaprakara'].forEach((v) {
        vastisarVividhaprakara!.add(new VastisarVividhaprakara.fromJson(v));
      });
    }
    if (json['Vastisardhaarmiknetrtav'] != null) {
      vastisardhaarmiknetrtav = <Vastisardhaarmiknetrtav>[];
      json['Vastisardhaarmiknetrtav'].forEach((v) {
        vastisardhaarmiknetrtav!.add(new Vastisardhaarmiknetrtav.fromJson(v));
      });
    }
    if (json['Vastisardurjanshakti'] != null) {
      vastisardurjanshakti = <Vastisardurjanshakti>[];
      json['Vastisardurjanshakti'].forEach((v) {
        vastisardurjanshakti!.add(new Vastisardurjanshakti.fromJson(v));
      });
    }
    if (json['Vastisarmaidan'] != null) {
      vastisarmaidan = <Vastisarmaidan>[];
      json['Vastisarmaidan'].forEach((v) {
        vastisarmaidan!.add(new Vastisarmaidan.fromJson(v));
      });
    }
    if (json['Vastisarsajjanshakti'] != null) {
      vastisarsajjanshakti = <Vastisarsajjanshakti>[];
      json['Vastisarsajjanshakti'].forEach((v) {
        vastisarsajjanshakti!.add(new Vastisarsajjanshakti.fromJson(v));
      });
    }
    if (json['Vastisarschooltapasila'] != null) {
      vastisarschooltapasila = <Vastisarschooltapasila>[];
      json['Vastisarschooltapasila'].forEach((v) {
        vastisarschooltapasila!.add(new Vastisarschooltapasila.fromJson(v));
      });
    }
    if (json['Vastisarupaasana'] != null) {
      vastisarupaasana = <Vastisarupaasana>[];
      json['Vastisarupaasana'].forEach((v) {
        vastisarupaasana!.add(new Vastisarupaasana.fromJson(v));
      });
    }
    vastitasajaraanyakaryakaram = json['Vastitasajaraanyakaryakaram'];
    vastitilasamajikaque = json['Vastitilasamajikaque'];
    agnishamandal = json['agnishamandal'];
    anyadhaarmik = json['anyadhaarmik'];
    balopaasanakendr = json['balopaasanakendr'];
    beforeShakhaSaptahikIsOnNowOff = json['beforeShakhaSaptahikIsOnNowOff'];
    anyaVividhKshetracheKame = json['anyaVividhKshetracheKame'];
    isGavatilMumbaikar = json['isGavatilMumbaikar'];
    cuserid = json['cuserid'];
    googlemap = json['googlemap'];
    pkid = json['pkid'];
    vastiShakhaPramukhName = json['vastiShakhaPramukhName'];
    vastiShakhaSamiti = json['vastiShakhaSamiti'];
    durjanShaktiYesNo = json['isdurjanskhatti'];
    vastiShakhaType = json['vastiShakhaType'];
    vastiShakhaTypevalue = json['vastiShakhaTypevalue'];
    vastiid = json['vastiid'];
    step1completepercentage = json['step1completepercentage'];
    step2completepercentage = json['step2completepercentage'];
    step3completepercentage = json['step3completepercentage'];
    stepOneComplete = json['stepOneComplete'];
    stepTwoComplete = json['stepTwoComplete'];
    sarpanchacheNaav = json['sarpanchaName'];
    sarpanchacheDoorbhash = json['sarpanchDoorbhash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Lokasankhya'] = this.lokasankhya;
    data['maleSankhya'] = this.maleSankhya;
    data['femaleSankhya'] = this.femaleSankhya;
    data['vadicheNave'] = this.vadicheNave;
    data['andajeGharev'] = this.andajeGhare;
    data['Policethane'] = this.policethane;
    data['VasticyacatuSima'] = this.vasticyacatuSima;
    if (this.vastisarAnyaprabhavilokam != null) {
      data['VastisarAnyaprabhavilokam'] =
          this.vastisarAnyaprabhavilokam!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarGatividhikaryasthiti != null) {
      data['VastisarGatividhikaryasthiti'] =
          this.vastisarGatividhikaryasthiti!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarHinduvirayadi != null) {
      data['VastisarHinduvirayadi'] =
          this.vastisarHinduvirayadi!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarJaagaranshreneesthiti != null) {
      data['VastisarJaagaranshreneesthiti'] =
          this.vastisarJaagaranshreneesthiti!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarSewaPrakalpa != null) {
      data['VastisarSewaPrakalpa'] =
          this.vastisarSewaPrakalpa!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarVividhKshetracheKam != null) {
      data['VastisarvividhKshetaCheKam'] =
          this.vastisarVividhKshetracheKam!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarGavatilMumbaikar != null) {
      data['VastisargavatilMumbaikar'] =
          this.vastisarGavatilMumbaikar!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarVadiGharLoksankhya != null) {
      data['VastisarvadiGharLoksankhya'] =
          this.vastisarVadiGharLoksankhya!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarVividhAdhyatmikKendra != null) {
      data['VastisarvividhSampradhaySatsangKendra'] =
          this.vastisarVividhAdhyatmikKendra!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarJahirakaryakramasambandhi != null) {
      data['VastisarJahirakaryakramasambandhi'] = this
          .vastisarJahirakaryakramasambandhi!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.vastisarKonatyaprantache != null) {
      data['VastisarKonatyaprantache'] =
          this.vastisarKonatyaprantache!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarKuthalyavarsi != null) {
      data['VastisarKuthalyavarsi'] =
          this.vastisarKuthalyavarsi!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarMotherugnalaya != null) {
      data['VastisarMotherugnalaya'] =
          this.vastisarMotherugnalaya!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarMothevyavasayikakendra != null) {
      data['VastisarMothevyavasayikakendra'] =
          this.vastisarMothevyavasayikakendra!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarNirmanadhinamothe != null) {
      data['VastisarNirmanadhinamothe'] =
          this.vastisarNirmanadhinamothe!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarReligion != null) {
      data['VastisarReligion'] =
          this.vastisarReligion!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarVasahatprakara != null) {
      data['VastisarVasahatprakara'] =
          this.vastisarVasahatprakara!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarVastitamahatvacesana != null) {
      data['VastisarVastitamahatvacesana'] =
          this.vastisarVastitamahatvacesana!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarVastitasajaraSamajikkaryakram != null) {
      data['VastisarVastitasajaraSamajikkaryakram'] = this
          .vastisarVastitasajaraSamajikkaryakram!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.vastisarVastitilabalopasanakendra != null) {
      data['VastisarVastitilabalopasanakendra'] = this
          .vastisarVastitilabalopasanakendra!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.vastisarVastitilasamajika != null) {
      data['VastisarVastitilasamajika'] =
          this.vastisarVastitilasamajika!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarVividhaprakara != null) {
      data['VastisarVividhaprakara'] =
          this.vastisarVividhaprakara!.map((v) => v.toJson()).toList();
    }
    if (this.vastisardhaarmiknetrtav != null) {
      data['Vastisardhaarmiknetrtav'] =
          this.vastisardhaarmiknetrtav!.map((v) => v.toJson()).toList();
    }
    if (this.vastisardurjanshakti != null) {
      data['Vastisardurjanshakti'] =
          this.vastisardurjanshakti!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarmaidan != null) {
      data['Vastisarmaidan'] =
          this.vastisarmaidan!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarsajjanshakti != null) {
      data['Vastisarsajjanshakti'] =
          this.vastisarsajjanshakti!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarschooltapasila != null) {
      data['Vastisarschooltapasila'] =
          this.vastisarschooltapasila!.map((v) => v.toJson()).toList();
    }
    if (this.vastisarupaasana != null) {
      data['Vastisarupaasana'] =
          this.vastisarupaasana!.map((v) => v.toJson()).toList();
    }
    data['Vastitasajaraanyakaryakaram'] = this.vastitasajaraanyakaryakaram;
    data['Vastitilasamajikaque'] = this.vastitilasamajikaque;
    data['agnishamandal'] = this.agnishamandal;
    data['anyadhaarmik'] = this.anyadhaarmik;
    data['balopaasanakendr'] = this.balopaasanakendr;
    data['beforeShakhaSaptahikIsOnNowOff'] =
        this.beforeShakhaSaptahikIsOnNowOff;
    data['anyaVividhKshetracheKame'] = this.anyaVividhKshetracheKame;
    data['isGavatilMumbaikar'] = this.isGavatilMumbaikar;
    data['cuserid'] = this.cuserid;
    data['googlemap'] = this.googlemap;
    data['pkid'] = this.pkid;
    data['vastiShakhaPramukhName'] = this.vastiShakhaPramukhName;
    data['vastiShakhaSamiti'] = this.vastiShakhaSamiti;
    data['isdurjanskhatti'] = this.durjanShaktiYesNo;
    data['vastiShakhaType'] = this.vastiShakhaType;
    data['vastiShakhaTypevalue'] = this.vastiShakhaTypevalue;
    data['vastiid'] = this.vastiid;
    data['step1completepercentage'] = this.step1completepercentage;
    data['step2completepercentage'] = this.step2completepercentage;
    data['step3completepercentage'] = this.step3completepercentage;
    data['stepOneComplete'] = this.stepOneComplete;
    data['stepTwoComplete'] = this.stepTwoComplete;
    data['sarpanchaName'] = this.sarpanchacheNaav;
    data['sarpanchDoorbhash'] = this.sarpanchacheDoorbhash;
    return data;
  }
}

class VastisarAnyaprabhavilokam {
  String? address;
  String? doorabhaash;
  int? isactive;
  String? name;
  int? pkid;
  int? prabhaavkshetrid;
  int? samparksthitiid;
  int? shreneeid;
  int? upshreneeid;
  int? upshreneeid2;
  int? vastiid;
  int? visheshid;
  String? anyavisesamahiti;
  String? samparkasutranav;
  String? samparkaSutraDoorbhash;
  String? otherupshrenee;
  String? otherupshrenee2;
  String? othervishesh;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  String? selectedDropdownValueName3;
  String? selectedDropdownValueName4;
  String? selectedDropdownValueName5;

  VastisarAnyaprabhavilokam({
    this.address,
    this.doorabhaash,
    this.isactive,
    this.name,
    this.pkid,
    this.prabhaavkshetrid,
    this.samparksthitiid,
    this.shreneeid,
    this.upshreneeid,
    this.upshreneeid2,
    this.vastiid,
    this.visheshid,
    this.anyavisesamahiti,
    this.samparkasutranav,
    this.samparkaSutraDoorbhash,
    this.otherupshrenee,
    this.otherupshrenee2,
    this.othervishesh,
    this.selectedDropdownValueName,
    this.selectedDropdownValueName1,
    this.selectedDropdownValueName2,
    this.selectedDropdownValueName3,
    this.selectedDropdownValueName4,
    this.selectedDropdownValueName5,
  });

  VastisarAnyaprabhavilokam.fromJson(Map<String, dynamic> json) {
    anyavisesamahiti = json['Anyavisesamahiti'];
    samparkasutranav = json['Samparkasutranav'];
    samparkaSutraDoorbhash = json['samparkaSutraDoorbhash'];
    address = json['address'];
    doorabhaash = json['doorabhaash'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    prabhaavkshetrid = json['prabhaavkshetrid'];
    samparksthitiid = json['samparksthitiid'];
    shreneeid = json['shreneeid'];
    upshreneeid = json['upshreneeid'];
    upshreneeid2 = json['upshreneeid2'];
    vastiid = json['vastiid'];
    visheshid = json['visheshid'];
    anyavisesamahiti = json['anyavisesamahiti'];
    samparkasutranav = json['Samparkasutranav'];
    otherupshrenee = json['otherupshrenee'];
    otherupshrenee2 = json['otherupshrenee2'];
    othervishesh = json['othervishesh'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    selectedDropdownValueName2 = json['selectedDropdownValueName2'];
    selectedDropdownValueName3 = json['selectedDropdownValueName3'];
    selectedDropdownValueName4 = json['selectedDropdownValueName4'];
    selectedDropdownValueName5 = json['selectedDropdownValueName5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Anyavisesamahiti'] = this.anyavisesamahiti;
    data['Samparkasutranav'] = this.samparkasutranav;
    data['samparkaSutraDoorbhash'] = this.samparkaSutraDoorbhash;
    data['address'] = this.address;
    data['doorabhaash'] = this.doorabhaash;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['prabhaavkshetrid'] = this.prabhaavkshetrid;
    data['samparksthitiid'] = this.samparksthitiid;
    data['shreneeid'] = this.shreneeid;
    data['upshreneeid'] = this.upshreneeid;
    data['upshreneeid2'] = this.upshreneeid2;
    data['vastiid'] = this.vastiid;
    data['visheshid'] = this.visheshid;
    data['otherupshrenee'] = this.otherupshrenee;
    data['otherupshrenee2'] = this.otherupshrenee2;
    data['othervishesh'] = this.othervishesh;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['selectedDropdownValueName2'] = this.selectedDropdownValueName2;
    data['selectedDropdownValueName3'] = this.selectedDropdownValueName3;
    data['selectedDropdownValueName4'] = this.selectedDropdownValueName4;
    data['selectedDropdownValueName5'] = this.selectedDropdownValueName5;
    data['shreneeid'] = this.shreneeid;
    return data;
  }
}

class VastisarGatividhikaryasthiti {
  int pkid;
  int vastiid;
  int gatividhiid;
  String? selectedDropdownValueName;
  String? niyamitacalanareupakrama;
  int? varanvaritaid;
  String? selectedDropdownValueName1;
  int? isactive;
  String? otherVaranvarita;

  VastisarGatividhikaryasthiti({
    required this.pkid,
    required this.vastiid,
    required this.gatividhiid,
    this.selectedDropdownValueName,
    this.niyamitacalanareupakrama,
    this.varanvaritaid,
    this.selectedDropdownValueName1,
    this.isactive,
    this.otherVaranvarita,
  });

  factory VastisarGatividhikaryasthiti.fromJson(Map<String, dynamic> json) {
    return VastisarGatividhikaryasthiti(
      pkid: json['pkid'],
      vastiid: json['vastiid'],
      gatividhiid: json['gatividhiid'],
      selectedDropdownValueName: json['selectedDropdownValueName'],
      niyamitacalanareupakrama: json['niyamitacalanareupakrama'],
      varanvaritaid: json['Varanvaritaid'],
      selectedDropdownValueName1: json['selectedDropdownValueName1'],
      isactive: json['isactive'],
      otherVaranvarita: json['otherVaranvarita'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pkid': pkid,
      'vastiid': vastiid,
      'gatividhiid': gatividhiid,
      'selectedDropdownValueName': selectedDropdownValueName,
      'niyamitacalanareupakrama': niyamitacalanareupakrama,
      'Varanvaritaid': varanvaritaid,
      'selectedDropdownValueName1': selectedDropdownValueName1,
      'isactive': isactive,
      'otherVaranvarita': otherVaranvarita,
    };
  }
}

class VastisarHinduvirayadi {
  int? id;
  int? isactive;
  String? name;
  int? pkid;
  int? vastiid;

  VastisarHinduvirayadi(
      {this.id, this.isactive, this.name, this.pkid, this.vastiid});

  VastisarHinduvirayadi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarJaagaranshreneesthiti {
  int? varanvaritaid;
  int? isactive;
  String? niyamitacalanareupakrama;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? otherVaranvarita;
  int? pkid;
  int? shreneeid;
  int? vastiid;

  VastisarJaagaranshreneesthiti(
      {this.varanvaritaid,
      this.isactive,
      this.niyamitacalanareupakrama,
      this.selectedDropdownValueName,
      this.selectedDropdownValueName1,
      this.otherVaranvarita,
      this.pkid,
      this.shreneeid,
      this.vastiid});

  VastisarJaagaranshreneesthiti.fromJson(Map<String, dynamic> json) {
    varanvaritaid = json['Varanvaritaid'];
    isactive = json['isactive'];
    niyamitacalanareupakrama = json['niyamitacalanareupakrama'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    otherVaranvarita = json['otherVaranvarita'];
    pkid = json['pkid'];
    shreneeid = json['shreneeid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Varanvaritaid'] = this.varanvaritaid;
    data['isactive'] = this.isactive;
    data['niyamitacalanareupakrama'] = this.niyamitacalanareupakrama;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['otherVaranvarita'] = this.otherVaranvarita;
    data['pkid'] = this.pkid;
    data['shreneeid'] = this.shreneeid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarSewaPrakalpa {
  int? sewaPrakalpaPrakaarId;
  int? sewaprakalpaChalvanariSansthaId;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? otherSewaPrakalpaPrakaar;
  String? otherSewaPrakalpaChalavinareShanstha;
  int? pkid;
  int? isactive;
  int? vastiid;

  VastisarSewaPrakalpa({
    this.sewaPrakalpaPrakaarId,
    this.sewaprakalpaChalvanariSansthaId,
    this.selectedDropdownValueName,
    this.selectedDropdownValueName1,
    this.otherSewaPrakalpaPrakaar,
    this.otherSewaPrakalpaChalavinareShanstha,
    this.pkid,
    this.isactive,
    this.vastiid,
  });

  VastisarSewaPrakalpa.fromJson(Map<String, dynamic> json) {
    sewaPrakalpaPrakaarId = json['sewaPrakalpaPrakaarId'];
    sewaprakalpaChalvanariSansthaId = json['sewaprakalpaChalvanariSansthaId'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    otherSewaPrakalpaPrakaar = json['otherSewaPrakalpaPrakaar'];
    otherSewaPrakalpaChalavinareShanstha =
        json['otherSewaPrakalpaChalavinareShanstha'];
    pkid = json['pkid'];
    isactive = json['isactive'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sewaPrakalpaPrakaarId'] = this.sewaPrakalpaPrakaarId;
    data['sewaprakalpaChalvanariSansthaId'] =
        this.sewaprakalpaChalvanariSansthaId;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['otherSewaPrakalpaPrakaar'] = this.otherSewaPrakalpaPrakaar;
    data['otherSewaPrakalpaChalavinareShanstha'] =
        this.otherSewaPrakalpaChalavinareShanstha;
    data['pkid'] = this.pkid;
    data['isactive'] = this.isactive;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarVividhKshetracheKam {
  String? kaam;
  String? chalavnariSansthaSanghatamn;
  int? pkid;
  int? isactive;
  int? vastiid;

  VastisarVividhKshetracheKam({
    this.kaam,
    this.chalavnariSansthaSanghatamn,
    this.pkid,
    this.isactive,
    this.vastiid,
  });

  VastisarVividhKshetracheKam.fromJson(Map<String, dynamic> json) {
    kaam = json['kaam'];
    chalavnariSansthaSanghatamn = json['chalavnariSansthaSanghatamn'];
    pkid = json['pkid'];
    isactive = json['isactive'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kaam'] = this.kaam;
    data['chalavnariSansthaSanghatamn'] = this.chalavnariSansthaSanghatamn;
    data['pkid'] = this.pkid;
    data['isactive'] = this.isactive;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarGavatilMumbaikar {
  String? sthaan;
  String? pramukhachrNaav;
  String? doorbhash;
  int? pkid;
  int? isactive;
  int? vastiid;

  VastisarGavatilMumbaikar({
    this.sthaan,
    this.pramukhachrNaav,
    this.doorbhash,
    this.pkid,
    this.isactive,
    this.vastiid,
  });

  VastisarGavatilMumbaikar.fromJson(Map<String, dynamic> json) {
    sthaan = json['sthaan'];
    pramukhachrNaav = json['pramukhachrNaav'];
    doorbhash = json['doorbhash'];
    pkid = json['pkid'];
    isactive = json['isactive'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sthaan'] = this.sthaan;
    data['pramukhachrNaav'] = this.pramukhachrNaav;
    data['doorbhash'] = this.doorbhash;
    data['pkid'] = this.pkid;
    data['isactive'] = this.isactive;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarVadiGharLoksankhya {
  String? vadiCheNav;
  String? andajeGhar;
  String? andajeLoksankhya;
  int? pkid;
  int? isactive;
  int? vastiid;

  VastisarVadiGharLoksankhya({
    this.vadiCheNav,
    this.andajeGhar,
    this.andajeLoksankhya,
    this.pkid,
    this.isactive,
    this.vastiid,
  });

  VastisarVadiGharLoksankhya.fromJson(Map<String, dynamic> json) {
    vadiCheNav = json['vadiCheNav'];
    andajeGhar = json['andajeGhar'];
    andajeLoksankhya = json['andajeLoksankhya'];
    pkid = json['pkid'];
    isactive = json['isactive'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vadiCheNav'] = this.vadiCheNav;
    data['andajeGhar'] = this.andajeGhar;
    data['andajeLoksankhya'] = this.andajeLoksankhya;
    data['pkid'] = this.pkid;
    data['isactive'] = this.isactive;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarVividhAdhyatmikKendra {
  int? pkid;
  int? isactive;
  int? vastiid;
  int? aadhyatmikKendraId;
  String? selectedDropdownValueName;
  String? isOtherAdhyatmitKendra;
  String? gaavPramukhName;
  String? samparkSootra;
  String? selectedGaavId;
  String? selectedDropdownValueName1;

  VastisarVividhAdhyatmikKendra({
    this.pkid,
    this.isactive,
    this.vastiid,
    this.aadhyatmikKendraId,
    this.selectedDropdownValueName,
    this.isOtherAdhyatmitKendra,
    this.gaavPramukhName,
    this.samparkSootra,
    this.selectedGaavId,
    this.selectedDropdownValueName1,
  });

  VastisarVividhAdhyatmikKendra.fromJson(Map<String, dynamic> json) {
    pkid = json['pkid'];
    isactive = json['isactive'];
    vastiid = json['vastiid'];
    aadhyatmikKendraId = json['aadhyatmikKendraId'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    isOtherAdhyatmitKendra = json['isOtherAdhyatmitKendra'];
    gaavPramukhName = json['gaavPramukhName'];
    samparkSootra = json['samparkSootra'];
    selectedGaavId = json['selectedGaavId'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['isactive'] = this.isactive;
    data['vastiid'] = this.vastiid;
    data['aadhyatmikKendraId'] = this.aadhyatmikKendraId;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['isOtherAdhyatmitKendra'] = this.isOtherAdhyatmitKendra;
    data['gaavPramukhName'] = this.gaavPramukhName;
    data['samparkSootra'] = this.samparkSootra;
    data['selectedGaavId'] = this.selectedGaavId;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    return data;
  }
}

class VastisarJahirakaryakramasambandhi {
  int? isactive;
  String? name;
  String? nivaaskshamata;
  int? nivasasathiupalabdha;
  int? pkid;
  int? prakaarid;
  int? prakaarid2;
  String? shamta;
  int? vastiid;
  String? selectedDropdownValueName;

  VastisarJahirakaryakramasambandhi({
    this.isactive,
    this.name,
    this.nivaaskshamata,
    this.nivasasathiupalabdha,
    this.pkid,
    this.prakaarid,
    this.shamta,
    this.vastiid,
    this.selectedDropdownValueName,
  });

  VastisarJahirakaryakramasambandhi.fromJson(Map<String, dynamic> json) {
    isactive = json['isactive'];
    name = json['name'];
    nivaaskshamata = json['nivaaskshamata'];
    nivasasathiupalabdha = json['nivasasathiupalabdha'];
    pkid = json['pkid'];
    prakaarid = json['prakaarid'];
    shamta = json['shamta'];
    vastiid = json['vastiid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['nivaaskshamata'] = this.nivaaskshamata;
    data['nivasasathiupalabdha'] = this.nivasasathiupalabdha;
    data['pkid'] = this.pkid;
    data['prakaarid'] = this.prakaarid;
    data['shamta'] = this.shamta;
    data['vastiid'] = this.vastiid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    return data;
  }
}

class VastisarKonatyaprantache {
  String? andaje;
  String? selectedDropdownValueName;
  String? anyaPraantName;
  int? isactive;
  int? pkid;
  int? praantid;
  int? vastiid;

  VastisarKonatyaprantache(
      {this.andaje,
      this.isactive,
      this.pkid,
      this.praantid,
      this.selectedDropdownValueName,
      this.vastiid,
      this.anyaPraantName});

  VastisarKonatyaprantache.fromJson(Map<String, dynamic> json) {
    andaje = json['Andaje'];
    isactive = json['isactive'];
    anyaPraantName = json['anyaPraantName'];
    pkid = json['pkid'];
    praantid = json['praantid'];
    vastiid = json['vastiid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Andaje'] = this.andaje;
    data['anyaPraantName'] = this.anyaPraantName;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['praantid'] = this.praantid;
    data['vastiid'] = this.vastiid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    return data;
  }
}

class VastisarKuthalyavarsi {
  String? saptahik;
  String? shaakhaa;
  String? selectedDropdownValueName;
  String? prakarName;
  int? isShaakhaa;
  int? id;
  int? isactive;
  int? pkid;
  int? vastiid;

  VastisarKuthalyavarsi(
      {this.saptahik,
      this.shaakhaa,
      this.selectedDropdownValueName,
      this.prakarName,
      this.isShaakhaa,
      this.id,
      this.isactive,
      this.pkid,
      this.vastiid});

  VastisarKuthalyavarsi.fromJson(Map<String, dynamic> json) {
    saptahik = json['Saptahik'];
    shaakhaa = json['Shaakhaa'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    id = json['id'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
    prakarName = json['Prakar'];
    isShaakhaa = json['isshaakhaa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Saptahik'] = this.saptahik;
    data['Shaakhaa'] = this.shaakhaa;
    data['Prakar'] = this.prakarName;
    data['isshaakhaa'] = this.isShaakhaa;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarReligion {
  String? andaje;
  String? selectedDropdownValueName;
  int? konatyarilijanaceid;
  int? isactive;
  int? pkid;
  int? vastiid;

  VastisarReligion(
      {this.andaje,
      this.konatyarilijanaceid,
      this.isactive,
      this.pkid,
      this.selectedDropdownValueName,
      this.vastiid});

  VastisarReligion.fromJson(Map<String, dynamic> json) {
    andaje = json['Andaje'];
    konatyarilijanaceid = json['Konatyarilijanaceid'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Andaje'] = this.andaje;
    data['Konatyarilijanaceid'] = this.konatyarilijanaceid;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    return data;
  }
}

class VastisarVasahatprakara {
  String? bhavanachenav;
  String? doorabhaash;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  int? isactive;
  int? pkid;
  int? prakarid;
  String? samparksootr;
  int? samparksthitiid;
  int? vastiid;

  VastisarVasahatprakara(
      {this.bhavanachenav,
      this.doorabhaash,
      this.selectedDropdownValueName,
      this.selectedDropdownValueName1,
      this.isactive,
      this.pkid,
      this.prakarid,
      this.samparksootr,
      this.samparksthitiid,
      this.vastiid});

  VastisarVasahatprakara.fromJson(Map<String, dynamic> json) {
    bhavanachenav = json['bhavanachenav'];
    doorabhaash = json['doorabhaash'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    prakarid = json['prakarid'];
    samparksootr = json['samparksootr'];
    samparksthitiid = json['samparksthitiid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bhavanachenav'] = this.bhavanachenav;
    data['doorabhaash'] = this.doorabhaash;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['prakarid'] = this.prakarid;
    data['samparksootr'] = this.samparksootr;
    data['samparksthitiid'] = this.samparksthitiid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarVastitamahatvacesana {
  String? aayojaksamparksootr;
  String? ayojakancinave;
  String? ayojakasansthacinave;
  String? selectedDropdownValueName;
  String? otherSajareSan;
  int? id;
  int? isactive;
  int? pkid;
  int? vastiid;

  VastisarVastitamahatvacesana(
      {this.aayojaksamparksootr,
      this.ayojakancinave,
      this.ayojakasansthacinave,
      this.selectedDropdownValueName,
      this.otherSajareSan,
      this.id,
      this.isactive,
      this.pkid,
      this.vastiid});

  VastisarVastitamahatvacesana.fromJson(Map<String, dynamic> json) {
    aayojaksamparksootr = json['aayojaksamparksootr'];
    ayojakancinave = json['ayojakancinave'];
    ayojakasansthacinave = json['ayojakasansthacinave'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    otherSajareSan = json['otherSajareSan'];
    id = json['id'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aayojaksamparksootr'] = this.aayojaksamparksootr;
    data['ayojakancinave'] = this.ayojakancinave;
    data['ayojakasansthacinave'] = this.ayojakasansthacinave;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['otherSajareSan'] = this.otherSajareSan;
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarVastitilabalopasanakendra {
  int? isactive;
  String? konasathi;
  String? name;
  String? selectedDropdownValueName;
  String? otherBalopasanaShreniName;
  int? pkid;
  int? shreneeid;
  int? vastiid;

  VastisarVastitilabalopasanakendra(
      {this.isactive,
      this.konasathi,
      this.name,
      this.selectedDropdownValueName,
      this.otherBalopasanaShreniName,
      this.pkid,
      this.shreneeid,
      this.vastiid});

  VastisarVastitilabalopasanakendra.fromJson(Map<String, dynamic> json) {
    isactive = json['isactive'];
    konasathi = json['konasathi'];
    name = json['name'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    otherBalopasanaShreniName = json['otherBalopasanaShreniName'];
    pkid = json['pkid'];
    shreneeid = json['shreneeid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isactive'] = this.isactive;
    data['konasathi'] = this.konasathi;
    data['name'] = this.name;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['otherBalopasanaShreniName'] = this.otherBalopasanaShreniName;
    data['pkid'] = this.pkid;
    data['shreneeid'] = this.shreneeid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarVividhaprakara {
  String? andaje;
  String? otherbhaasha;
  String? selectedDropdownValueName;
  int? bhaashaid;
  int? isactive;
  int? pkid;
  int? vastiid;

  VastisarVividhaprakara(
      {this.andaje,
      this.bhaashaid,
      this.otherbhaasha,
      this.selectedDropdownValueName,
      this.isactive,
      this.pkid,
      this.vastiid});

  VastisarVividhaprakara.fromJson(Map<String, dynamic> json) {
    andaje = json['Andaje'];
    bhaashaid = json['bhaashaid'];
    otherbhaasha = json['otherbhaasha'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Andaje'] = this.andaje;
    data['otherbhaasha'] = this.otherbhaasha;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['bhaashaid'] = this.bhaashaid;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class Vastisardurjanshakti {
  int? gunha;
  int? isactive;
  String? name;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  String? otherPrakar;
  int? pkid;
  int? prakar;
  int? shiksha;
  int? vastiid;

  Vastisardurjanshakti(
      {this.gunha,
      this.isactive,
      this.name,
      this.selectedDropdownValueName,
      this.selectedDropdownValueName1,
      this.selectedDropdownValueName2,
      this.otherPrakar,
      this.pkid,
      this.prakar,
      this.shiksha,
      this.vastiid});

  Vastisardurjanshakti.fromJson(Map<String, dynamic> json) {
    gunha = json['Gunha'];
    isactive = json['isactive'];
    name = json['name'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    selectedDropdownValueName2 = json['selectedDropdownValueName2'];
    otherPrakar = json['otherPrakar'];
    pkid = json['pkid'];
    prakar = json['prakar'];
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
    data['otherPrakar'] = this.otherPrakar;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['selectedDropdownValueName2'] = this.selectedDropdownValueName2;
    data['shiksha'] = this.shiksha;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class Vastisarsajjanshakti {
  String? address;
  String? doorabhaash;
  int? isactive;
  String? name;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  String? selectedDropdownValueName3;
  int? pkid;
  int? prabhaavkshetrid;
  int? samparksthitiid;
  int? shreneeid;
  int? vastiid;
  String? otherShreniName;
  String? otherVisheshName;
  String? samparkasutranava;
  String? samparkasutraMobileNumber;
  String? sanstheCheNaav;
  String? sansthechaKuthalaPadavar;
  int? visheshId;

  Vastisarsajjanshakti({
    this.address,
    this.doorabhaash,
    this.isactive,
    this.name,
    this.selectedDropdownValueName,
    this.selectedDropdownValueName1,
    this.selectedDropdownValueName2,
    this.selectedDropdownValueName3,
    this.pkid,
    this.prabhaavkshetrid,
    this.samparksthitiid,
    this.shreneeid,
    this.vastiid,
    this.samparkasutranava,
    this.sanstheCheNaav,
    this.samparkasutraMobileNumber,
    this.sansthechaKuthalaPadavar,
    this.visheshId,
    this.otherShreniName,
    this.otherVisheshName,
  });

  Vastisarsajjanshakti.fromJson(Map<String, dynamic> json) {
    samparkasutranava = json['Samparkasutranava'];
    address = json['address'];
    doorabhaash = json['doorabhaash'];
    isactive = json['isactive'];
    name = json['name'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    selectedDropdownValueName2 = json['selectedDropdownValueName2'];
    selectedDropdownValueName3 = json['selectedDropdownValueName3'];
    pkid = json['pkid'];
    prabhaavkshetrid = json['prabhaavkshetrid'];
    samparksthitiid = json['samparksthitiid'];
    shreneeid = json['shreneeid'];
    vastiid = json['vastiid'];
    samparkasutranava = json['Samparkasutranava'];
    sanstheCheNaav = json['sanstheCheNaav'];
    samparkasutraMobileNumber = json['samparkasutraMobileNumber'];
    sansthechaKuthalaPadavar = json['sansthechaKuthalaPadavar'];
    visheshId = json['visheshId'];
    otherShreniName = json['otherShreniName'];
    otherVisheshName = json['otherVisheshName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Samparkasutranava'] = this.samparkasutranava;
    data['address'] = this.address;
    data['doorabhaash'] = this.doorabhaash;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['selectedDropdownValueName2'] = this.selectedDropdownValueName2;
    data['selectedDropdownValueName3'] = this.selectedDropdownValueName3;
    data['pkid'] = this.pkid;
    data['prabhaavkshetrid'] = this.prabhaavkshetrid;
    data['samparksthitiid'] = this.samparksthitiid;
    data['shreneeid'] = this.shreneeid;
    data['vastiid'] = this.vastiid;
    data['Samparkasutranava'] = this.samparkasutranava;
    data['sanstheCheNaav'] = this.sanstheCheNaav;
    data['samparkasutraMobileNumber'] = this.samparkasutraMobileNumber;
    data['sansthechaKuthalaPadavar'] = this.sansthechaKuthalaPadavar;
    data['visheshId'] = this.visheshId;
    data['otherShreniName'] = this.otherShreniName;
    data['otherVisheshName'] = this.otherVisheshName;
    return data;
  }
}

class Vastisarschooltapasila {
  int? chaalakprakaar;
  int? isactive;
  int? maadhyam;
  int? milkat;
  String? name;
  int? pkid;
  int? prakaarid;
  int? shaikshaniksansthaan;
  int? vastiid;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? selectedDropdownValueName2;
  String? selectedDropdownValueName3;
  String? selectedDropdownValueName4;

  Vastisarschooltapasila({
    this.chaalakprakaar,
    this.isactive,
    this.maadhyam,
    this.milkat,
    this.name,
    this.pkid,
    this.prakaarid,
    this.shaikshaniksansthaan,
    this.vastiid,
    this.selectedDropdownValueName,
    this.selectedDropdownValueName1,
    this.selectedDropdownValueName2,
    this.selectedDropdownValueName3,
    this.selectedDropdownValueName4,
  });

  Vastisarschooltapasila.fromJson(Map<String, dynamic> json) {
    chaalakprakaar = json['chaalakprakaar'];
    isactive = json['isactive'];
    maadhyam = json['maadhyam'];
    milkat = json['milkat'];
    name = json['name'];
    pkid = json['pkid'];
    prakaarid = json['prakaarid'];
    shaikshaniksansthaan = json['shaikshaniksansthaan'];
    vastiid = json['vastiid'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    selectedDropdownValueName2 = json['selectedDropdownValueName2'];
    selectedDropdownValueName3 = json['selectedDropdownValueName3'];
    selectedDropdownValueName4 = json['selectedDropdownValueName4'];
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
    data['shaikshaniksansthaan'] = this.shaikshaniksansthaan;
    data['vastiid'] = this.vastiid;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['selectedDropdownValueName2'] = this.selectedDropdownValueName2;
    data['selectedDropdownValueName3'] = this.selectedDropdownValueName3;
    data['selectedDropdownValueName4'] = this.selectedDropdownValueName4;
    return data;
  }
}

class Vastisarupaasana {
  int? isactive;
  int? pkid;
  int? prakarid;
  String? sankhya;
  String? selectedDropdownValueName;
  String? selectedDropdownValueName1;
  String? otherupaasanasthala;
  int? upaasanasthalaid;
  int? vastiid;

  Vastisarupaasana(
      {this.isactive,
      this.pkid,
      this.prakarid,
      this.sankhya,
      this.selectedDropdownValueName,
      this.selectedDropdownValueName1,
      this.otherupaasanasthala,
      this.upaasanasthalaid,
      this.vastiid});

  Vastisarupaasana.fromJson(Map<String, dynamic> json) {
    isactive = json['isactive'];
    pkid = json['pkid'];
    prakarid = json['prakarid'];
    sankhya = json['sankhya'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    selectedDropdownValueName1 = json['selectedDropdownValueName1'];
    otherupaasanasthala = json['otherupaasanasthala'];
    upaasanasthalaid = json['upaasanasthalaid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['prakarid'] = this.prakarid;
    data['sankhya'] = this.sankhya;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['selectedDropdownValueName1'] = this.selectedDropdownValueName1;
    data['otherupaasanasthala'] = this.otherupaasanasthala;
    data['upaasanasthalaid'] = this.upaasanasthalaid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarMotherugnalaya {
  int? id;
  int? isactive;
  String? name;
  String? selectedDropdownValueName;
  int? pkid;
  int? vastiid;

  VastisarMotherugnalaya(
      {this.id,
      this.isactive,
      this.name,
      this.selectedDropdownValueName,
      this.pkid,
      this.vastiid});

  VastisarMotherugnalaya.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarVastitasajaraSamajikkaryakram {
  String? selectedDropdownValueName;
  String? otherKaryakram;
  String? aayojaksamparksootr;
  String? ayojakancinave;
  String? ayojakasansthacinave;
  int? id;
  int? isactive;
  int? pkid;
  int? vastiid;

  VastisarVastitasajaraSamajikkaryakram(
      {this.aayojaksamparksootr,
      this.selectedDropdownValueName,
      this.ayojakancinave,
      this.otherKaryakram,
      this.ayojakasansthacinave,
      this.id,
      this.isactive,
      this.pkid,
      this.vastiid});

  VastisarVastitasajaraSamajikkaryakram.fromJson(Map<String, dynamic> json) {
    selectedDropdownValueName = json['selectedDropdownValueName'];
    aayojaksamparksootr = json['aayojaksamparksootr'];
    ayojakancinave = json['ayojakancinave'];
    ayojakasansthacinave = json['ayojakasansthacinave'];
    otherKaryakram = json['otherKaryakram'];
    id = json['id'];
    isactive = json['isactive'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otherKaryakram'] = this.otherKaryakram;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['aayojaksamparksootr'] = this.aayojaksamparksootr;
    data['ayojakancinave'] = this.ayojakancinave;
    data['ayojakasansthacinave'] = this.ayojakasansthacinave;
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarMothevyavasayikakendra {
  int? id;
  int? isactive;
  String? name;
  String? selectedDropdownValueName;
  int? pkid;
  int? vastiid;

  VastisarMothevyavasayikakendra(
      {this.id,
      this.isactive,
      this.name,
      this.selectedDropdownValueName,
      this.pkid,
      this.vastiid});

  VastisarMothevyavasayikakendra.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarNirmanadhinamothe {
  int? id;
  int? isactive;
  String? selectedDropdownValueName;
  String? name;
  int? pkid;
  int? vastiid;

  VastisarNirmanadhinamothe(
      {this.id,
      this.isactive,
      this.selectedDropdownValueName,
      this.name,
      this.pkid,
      this.vastiid});

  VastisarNirmanadhinamothe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    name = json['name'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class VastisarVastitilasamajika {
  int? id;
  int? isactive;
  String? name;
  String? selectedDropdownValueName;
  int? pkid;
  int? vastiid;

  VastisarVastitilasamajika(
      {this.id,
      this.isactive,
      this.selectedDropdownValueName,
      this.name,
      this.pkid,
      this.vastiid});

  VastisarVastitilasamajika.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class Vastisardhaarmiknetrtav {
  int? id;
  int? isactive;
  String? name;
  String? selectedDropdownValueName;
  String? otherNetrutwa;
  int? pkid;
  int? vastiid;

  Vastisardhaarmiknetrtav(
      {this.id,
      this.isactive,
      this.name,
      this.selectedDropdownValueName,
      this.pkid,
      this.otherNetrutwa,
      this.vastiid});

  Vastisardhaarmiknetrtav.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    selectedDropdownValueName = json['selectedDropdownValueName'];
    otherNetrutwa = json['otherNetrutwa'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['selectedDropdownValueName'] = this.selectedDropdownValueName;
    data['otherNetrutwa'] = this.otherNetrutwa;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}

class Vastisarmaidan {
  int? id;
  int? isactive;
  String? name;
  int? pkid;
  int? vastiid;

  Vastisarmaidan({this.id, this.isactive, this.name, this.pkid, this.vastiid});

  Vastisarmaidan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isactive = json['isactive'];
    name = json['name'];
    pkid = json['pkid'];
    vastiid = json['vastiid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isactive'] = this.isactive;
    data['name'] = this.name;
    data['pkid'] = this.pkid;
    data['vastiid'] = this.vastiid;
    return data;
  }
}
