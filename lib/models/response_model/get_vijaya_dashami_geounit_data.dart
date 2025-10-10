import 'package:niyojak_prod/models/response_model/vijayaDashamiInitModel.dart';

// import 'get_vasti_data_by_id_model.dart';

class GetVijayadashamiDataByGeoUnitModel {
  String? message;
  String? status;
  List<TypeValueData>? adddata;
  List<TypeValueData>? eventdata;
  List<TypeValueData>? urldata;
  VijayadashamiUtsav? vijayadashamiUtsav;

  List<Vastisanyaprabhavi>? mukhyaAtithiVastisarAnyaprabhavilokam;
  List<Vastisarsajjanshakti>? mukhyaAtithiVastisarsajjanshakti;
  List<Vastisanyaprabhavi>? visititAtithiVastisarAnyaprabhavilokam;
  List<Vastisarsajjanshakti>? visititAtithiVastisarsajjanshakti;

  GetVijayadashamiDataByGeoUnitModel({
    this.message,
    this.status,
    this.adddata,
    this.eventdata,
    this.urldata,
    this.vijayadashamiUtsav,
    this.mukhyaAtithiVastisarAnyaprabhavilokam,
    this.mukhyaAtithiVastisarsajjanshakti,
    this.visititAtithiVastisarAnyaprabhavilokam,
    this.visititAtithiVastisarsajjanshakti,
  });

  GetVijayadashamiDataByGeoUnitModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['Adddata'] != null) {
      adddata = <TypeValueData>[];
      json['Adddata'].forEach((v) {
        adddata!.add(new TypeValueData.fromJson(v));
      });
    }
    if (json['eventdata'] != null) {
      eventdata = <TypeValueData>[];
      json['eventdata'].forEach((v) {
        eventdata!.add(new TypeValueData.fromJson(v));
      });
    }
    if (json['urldata'] != null) {
      urldata = <TypeValueData>[];
      json['urldata'].forEach((v) {
        urldata!.add(new TypeValueData.fromJson(v));
      });
    }
    vijayadashamiUtsav = json['VijayadashamiUtsav'] != null ? new VijayadashamiUtsav.fromJson(json['VijayadashamiUtsav']) : null;

    if (json['mukhya_atithi_VastisarAnyaprabhavilokam'] != null) {
      mukhyaAtithiVastisarAnyaprabhavilokam = <Vastisanyaprabhavi>[];
      if (json['mukhya_atithi_VastisarAnyaprabhavilokam'] != []) {
        json['mukhya_atithi_VastisarAnyaprabhavilokam'].forEach((v) {
          mukhyaAtithiVastisarAnyaprabhavilokam!.add(new Vastisanyaprabhavi.fromJson(v));
        });
      }
    }
    if (json['mukhya_atithi_Vastisarsajjanshakti'] != null) {
      mukhyaAtithiVastisarsajjanshakti = <Vastisarsajjanshakti>[];
      if (json['mukhya_atithi_Vastisarsajjanshakti'] != []) {
        json['mukhya_atithi_Vastisarsajjanshakti'].forEach((v) {
          mukhyaAtithiVastisarsajjanshakti!.add(new Vastisarsajjanshakti.fromJson(v));
        });
      }
    }
    if (json['visitit_atithi_VastisarAnyaprabhavilokam'] != null) {
      visititAtithiVastisarAnyaprabhavilokam = <Vastisanyaprabhavi>[];
      if (json['visitit_atithi_VastisarAnyaprabhavilokam'] != []) {
        json['visitit_atithi_VastisarAnyaprabhavilokam'].forEach((v) {
          visititAtithiVastisarAnyaprabhavilokam!.add(new Vastisanyaprabhavi.fromJson(v));
        });
      }
    }
    if (json['visitit_atithi_Vastisarsajjanshakti'] != null) {
      visititAtithiVastisarsajjanshakti = <Vastisarsajjanshakti>[];
      if (json['visitit_atithi_Vastisarsajjanshakti'] != []) {
        json['visitit_atithi_Vastisarsajjanshakti'].forEach((v) {
          visititAtithiVastisarsajjanshakti!.add(new Vastisarsajjanshakti.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.adddata != null) {
      data['Adddata'] = this.adddata!.map((v) => v.toJson()).toList();
    }
    if (this.eventdata != null) {
      data['eventdata'] = this.eventdata!.map((v) => v.toJson()).toList();
    }
    if (this.urldata != null) {
      data['urldata'] = this.urldata!.map((v) => v.toJson()).toList();
    }
    if (this.vijayadashamiUtsav != null) {
      data['VijayadashamiUtsav'] = this.vijayadashamiUtsav!.toJson();
    }
    if (this.mukhyaAtithiVastisarAnyaprabhavilokam != null) {
      data['mukhya_atithi_VastisarAnyaprabhavilokam'] = this.mukhyaAtithiVastisarAnyaprabhavilokam!.map((v) => v.toJson()).toList();
    }
    if (this.mukhyaAtithiVastisarsajjanshakti != null) {
      data['mukhya_atithi_Vastisarsajjanshakti'] = this.mukhyaAtithiVastisarsajjanshakti!.map((v) => v.toJson()).toList();
    }
    if (this.visititAtithiVastisarAnyaprabhavilokam != null) {
      data['visitit_atithi_VastisarAnyaprabhavilokam'] = this.visititAtithiVastisarAnyaprabhavilokam!.map((v) => v.toJson()).toList();
    }
    if (this.visititAtithiVastisarsajjanshakti != null) {
      data['visitit_atithi_Vastisarsajjanshakti'] = this.visititAtithiVastisarsajjanshakti!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VijayadashamiUtsav {
  String? geoUnitID;
  int? mahavidyaAnya;
  int? mahavidyaGan;
  int? mahavidyaPat;
  int? proudhVyavAnya;
  int? proudhVyavGan;
  int? proudhVyavPat;
  int? tarunVyavAnya;
  int? tarunVyavGan;
  int? tarunVyavPat;
  int? anyaUpastitiMale;
  int? anyaUpastitiMatrushakti;
  int? baalAnya;
  int? baalGan;
  int? baalPat;
  int? bhougolikEkunvasti;
  int? bhougolikPratinidhatvaCount;
  String? bhougolikPratinidhatvaIds;
  int? bhougolikSahasari;
  int? ekunCount;
  int? ekunPercentage;
  int? ekunSelected;
  int? isNagar;
  int? karaykramHisob24TasaPurnaZaleka;
  int? karyakramNirdharitVedhvarZaleka;
  int? manasikSanghMandaliPratinidhatvaCount;
  int? manasikSanghMandaliPratinidhatvaEkun;
  String? manasikSanghMandaliPratinidhatvaIds;
  int? manasikSanghMandaliPratinidhatvaSahasari;
  int? milanPratinidhatvaCount;
  int? milanPratinidhatvaEkun;
  String? milanPratinidhatvaIds;
  int? milanPratinidhatvaSahasari;
  int? mukhyaAtithiId;
  int? mukhyaAtithiIsSajjanShakti;
  int? pkid;
  int? shakhaPratinidhatvaCount;
  int? shakhaPratinidhatvaEkun;
  String? shakhaPratinidhatvaIds;
  int? shakhaPratinidhatvaSahasari;
  int? shanchalanGhosvandanZaleka;
  int? shanchalanSadanZaleka;
  int? shanchalanZaleka;
  String? visititAtithiAnyaprabhaViLokamids;
  String? visititAtithiSajjanShaktiids;
  int? vyaktiGeetKhantastaKhoteka;
  String? karyakramVaktaName;
  String? karyakramVaktaTask;
  String? utsavPhotoDesc;
  String? utsavAddPhotoDesc;

  VijayadashamiUtsav({
    this.geoUnitID,
    this.mahavidyaAnya,
    this.mahavidyaGan,
    this.mahavidyaPat,
    this.proudhVyavAnya,
    this.proudhVyavGan,
    this.proudhVyavPat,
    this.tarunVyavAnya,
    this.tarunVyavGan,
    this.tarunVyavPat,
    this.anyaUpastitiMale,
    this.anyaUpastitiMatrushakti,
    this.baalAnya,
    this.baalGan,
    this.baalPat,
    this.bhougolikEkunvasti,
    this.bhougolikPratinidhatvaCount,
    this.bhougolikPratinidhatvaIds,
    this.bhougolikSahasari,
    this.ekunCount,
    this.ekunPercentage,
    this.ekunSelected,
    this.isNagar,
    this.karaykramHisob24TasaPurnaZaleka,
    this.karyakramNirdharitVedhvarZaleka,
    this.manasikSanghMandaliPratinidhatvaCount,
    this.manasikSanghMandaliPratinidhatvaEkun,
    this.manasikSanghMandaliPratinidhatvaIds,
    this.manasikSanghMandaliPratinidhatvaSahasari,
    this.milanPratinidhatvaCount,
    this.milanPratinidhatvaEkun,
    this.milanPratinidhatvaIds,
    this.milanPratinidhatvaSahasari,
    this.mukhyaAtithiId,
    this.mukhyaAtithiIsSajjanShakti,
    this.pkid,
    this.shakhaPratinidhatvaCount,
    this.shakhaPratinidhatvaEkun,
    this.shakhaPratinidhatvaIds,
    this.shakhaPratinidhatvaSahasari,
    this.shanchalanGhosvandanZaleka,
    this.shanchalanSadanZaleka,
    this.shanchalanZaleka,
    this.visititAtithiAnyaprabhaViLokamids,
    this.visititAtithiSajjanShaktiids,
    this.vyaktiGeetKhantastaKhoteka,
    this.karyakramVaktaName,
    this.karyakramVaktaTask,
    this.utsavPhotoDesc,
    this.utsavAddPhotoDesc,
  });

  VijayadashamiUtsav.fromJson(Map<String, dynamic> json) {
    geoUnitID = json['GeoUnitID'];
    mahavidyaAnya = json['Mahavidya_anya'];
    mahavidyaGan = json['Mahavidya_gan'];
    mahavidyaPat = json['Mahavidya_pat'];
    proudhVyavAnya = json['ProudhVyav_anya'];
    proudhVyavGan = json['ProudhVyav_gan'];
    proudhVyavPat = json['ProudhVyav_pat'];
    tarunVyavAnya = json['TarunVyav_anya'];
    tarunVyavGan = json['TarunVyav_gan'];
    tarunVyavPat = json['TarunVyav_pat'];
    anyaUpastitiMale = json['anya_upastiti_male'];
    anyaUpastitiMatrushakti = json['anya_upastiti_matrushakti'];
    baalAnya = json['baal_anya'];
    baalGan = json['baal_gan'];
    baalPat = json['baal_pat'];
    bhougolikEkunvasti = json['bhougolik_ekunvasti'];
    bhougolikPratinidhatvaCount = json['bhougolik_pratinidhatva_count'];
    bhougolikPratinidhatvaIds = json['bhougolik_pratinidhatva_ids'];
    bhougolikSahasari = json['bhougolik_sahasari'];
    ekunCount = json['ekun_count'];
    ekunPercentage = json['ekun_percentage'];
    ekunSelected = json['ekun_selected'];
    isNagar = json['is_nagar'];
    karaykramHisob24TasaPurnaZaleka = json['karaykram_hisob_24_tasa_purna_zaleka'];
    karyakramNirdharitVedhvarZaleka = json['karyakram_nirdharit_vedhvar_zaleka'];
    manasikSanghMandaliPratinidhatvaCount = json['manasik_sangh_mandali_pratinidhatva_count'];
    manasikSanghMandaliPratinidhatvaEkun = json['manasik_sangh_mandali_pratinidhatva_ekun'];
    manasikSanghMandaliPratinidhatvaIds = json['manasik_sangh_mandali_pratinidhatva_ids'];
    manasikSanghMandaliPratinidhatvaSahasari = json['manasik_sangh_mandali_pratinidhatva_sahasari'];
    milanPratinidhatvaCount = json['milan_pratinidhatva_count'];
    milanPratinidhatvaEkun = json['milan_pratinidhatva_ekun'];
    milanPratinidhatvaIds = json['milan_pratinidhatva_ids'];
    milanPratinidhatvaSahasari = json['milan_pratinidhatva_sahasari'];
    mukhyaAtithiId = json['mukhya_atithi_id'];
    mukhyaAtithiIsSajjanShakti = json['mukhya_atithi_is_sajjan_shakti'];
    pkid = json['pkid'];
    shakhaPratinidhatvaCount = json['shakha_pratinidhatva_count'];
    shakhaPratinidhatvaEkun = json['shakha_pratinidhatva_ekun'];
    shakhaPratinidhatvaIds = json['shakha_pratinidhatva_ids'];
    shakhaPratinidhatvaSahasari = json['shakha_pratinidhatva_sahasari'];
    shanchalanGhosvandanZaleka = json['shanchalan_ghosvandan_zaleka'];
    shanchalanSadanZaleka = json['shanchalan_sadan_zaleka'];
    shanchalanZaleka = json['shanchalan_zaleka'];
    visititAtithiAnyaprabhaViLokamids = json['visitit_atithi_anyaprabha_vi_lokamids'];
    visititAtithiSajjanShaktiids = json['visitit_atithi_sajjan_shaktiids'];
    vyaktiGeetKhantastaKhoteka = json['vyakti_geet_khantasta_khoteka'];
    karyakramVaktaName = json['karyakramVaktaName'];
    karyakramVaktaTask = json['karyakramVaktaTask'];
    utsavPhotoDesc = json['utsavPhotoDesc'];
    utsavAddPhotoDesc = json['utsavAddPhotoDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitID;
    data['Mahavidya_anya'] = this.mahavidyaAnya;
    data['Mahavidya_gan'] = this.mahavidyaGan;
    data['Mahavidya_pat'] = this.mahavidyaPat;
    data['ProudhVyav_anya'] = this.proudhVyavAnya;
    data['ProudhVyav_gan'] = this.proudhVyavGan;
    data['ProudhVyav_pat'] = this.proudhVyavPat;
    data['TarunVyav_anya'] = this.tarunVyavAnya;
    data['TarunVyav_gan'] = this.tarunVyavGan;
    data['TarunVyav_pat'] = this.tarunVyavPat;
    data['anya_upastiti_male'] = this.anyaUpastitiMale;
    data['anya_upastiti_matrushakti'] = this.anyaUpastitiMatrushakti;
    data['baal_anya'] = this.baalAnya;
    data['baal_gan'] = this.baalGan;
    data['baal_pat'] = this.baalPat;
    data['bhougolik_ekunvasti'] = this.bhougolikEkunvasti;
    data['bhougolik_pratinidhatva_count'] = this.bhougolikPratinidhatvaCount;
    data['bhougolik_pratinidhatva_ids'] = this.bhougolikPratinidhatvaIds;
    data['bhougolik_sahasari'] = this.bhougolikSahasari;
    data['ekun_count'] = this.ekunCount;
    data['ekun_percentage'] = this.ekunPercentage;
    data['ekun_selected'] = this.ekunSelected;
    data['is_nagar'] = this.isNagar;
    data['karaykram_hisob_24_tasa_purna_zaleka'] = this.karaykramHisob24TasaPurnaZaleka;
    data['karyakram_nirdharit_vedhvar_zaleka'] = this.karyakramNirdharitVedhvarZaleka;
    data['manasik_sangh_mandali_pratinidhatva_count'] = this.manasikSanghMandaliPratinidhatvaCount;
    data['manasik_sangh_mandali_pratinidhatva_ekun'] = this.manasikSanghMandaliPratinidhatvaEkun;
    data['manasik_sangh_mandali_pratinidhatva_ids'] = this.manasikSanghMandaliPratinidhatvaIds;
    data['manasik_sangh_mandali_pratinidhatva_sahasari'] = this.manasikSanghMandaliPratinidhatvaSahasari;
    data['milan_pratinidhatva_count'] = this.milanPratinidhatvaCount;
    data['milan_pratinidhatva_ekun'] = this.milanPratinidhatvaEkun;
    data['milan_pratinidhatva_ids'] = this.milanPratinidhatvaIds;
    data['milan_pratinidhatva_sahasari'] = this.milanPratinidhatvaSahasari;
    data['mukhya_atithi_id'] = this.mukhyaAtithiId;
    data['mukhya_atithi_is_sajjan_shakti'] = this.mukhyaAtithiIsSajjanShakti;
    data['pkid'] = this.pkid;
    data['shakha_pratinidhatva_count'] = this.shakhaPratinidhatvaCount;
    data['shakha_pratinidhatva_ekun'] = this.shakhaPratinidhatvaEkun;
    data['shakha_pratinidhatva_ids'] = this.shakhaPratinidhatvaIds;
    data['shakha_pratinidhatva_sahasari'] = this.shakhaPratinidhatvaSahasari;
    data['shanchalan_ghosvandan_zaleka'] = this.shanchalanGhosvandanZaleka;
    data['shanchalan_sadan_zaleka'] = this.shanchalanSadanZaleka;
    data['shanchalan_zaleka'] = this.shanchalanZaleka;
    data['visitit_atithi_anyaprabha_vi_lokamids'] = this.visititAtithiAnyaprabhaViLokamids;
    data['visitit_atithi_sajjan_shaktiids'] = this.visititAtithiSajjanShaktiids;
    data['vyakti_geet_khantasta_khoteka'] = this.vyaktiGeetKhantastaKhoteka;
    data['karyakramVaktaName'] = this.karyakramVaktaName;
    data['karyakramVaktaTask'] = this.karyakramVaktaTask;
    data['utsavPhotoDesc'] = this.utsavPhotoDesc;
    data['utsavAddPhotoDesc'] = this.utsavAddPhotoDesc;
    return data;
  }
}

class TypeValueData {
  String? type;
  String? value;
  String? description;

  TypeValueData({this.type, this.value, this.description});

  TypeValueData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    data['description'] = this.description;
    return data;
  }
}
