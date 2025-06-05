class AbhiyanGruhasamparkResponse {
  AbhiyanGruhasamparkData? abhiyanGruhasamparkData;
  String? message;
  String? status;

  AbhiyanGruhasamparkResponse(
      {this.abhiyanGruhasamparkData, this.message, this.status});

  AbhiyanGruhasamparkResponse.fromJson(Map<String, dynamic> json) {
    abhiyanGruhasamparkData = json['AbhiyanGruhasamparkData'] != null
        ? new AbhiyanGruhasamparkData.fromJson(json['AbhiyanGruhasamparkData'])
        : null;
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.abhiyanGruhasamparkData != null) {
      data['AbhiyanGruhasamparkData'] = this.abhiyanGruhasamparkData!.toJson();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}

class AbhiyanGruhasamparkData {
  int? abhiyanGramCount;
  int? abhiyanMandalCount;
  int? abhiyanNagarCount;
  int? abhiyanTalukaCount;
  int? abhiyanVastiCount;
  int? anayaEkunCount;
  int? anukulDharmik;
  int? anya;
  int? anyaKalchaCount;
  int? dharmik;
  int? ekunGram;
  int? ekunMandal;
  int? ekunNagar;
  int? ekunTaluka;
  int? ekunVasti;
  int? jSSanskrutik;
  int? jSewa;
  int? pEkunCount;
  int? pKalchaCount;
  int? pMyAajCount;
  int? sMyAajCount;
  int? pratikulSamajik;
  int? sMyKalchaCount;
  int? sTotalCount;
  int? samajik;
  int? sanskrutik;
  int? sewa;
  int? shaishanik;
  int? tShaishanik;
  List<Abhiyaancount>? abhiyaancount;

  AbhiyanGruhasamparkData(
      {this.abhiyanGramCount,
        this.abhiyanMandalCount,
        this.abhiyanNagarCount,
        this.abhiyanTalukaCount,
        this.abhiyanVastiCount,
        this.anayaEkunCount,
        this.anukulDharmik,
        this.anya,
        this.anyaKalchaCount,
        this.dharmik,
        this.ekunGram,
        this.ekunMandal,
        this.ekunNagar,
        this.ekunTaluka,
        this.ekunVasti,
        this.jSSanskrutik,
        this.jSewa,
        this.pEkunCount,
        this.pKalchaCount,
        this.pMyAajCount,
        this.sMyAajCount,
        this.pratikulSamajik,
        this.sMyKalchaCount,
        this.sTotalCount,
        this.samajik,
        this.sanskrutik,
        this.sewa,
        this.shaishanik,
        this.tShaishanik,
        this.abhiyaancount});

  AbhiyanGruhasamparkData.fromJson(Map<String, dynamic> json) {
    abhiyanGramCount = json['AbhiyanGramCount'];
    abhiyanMandalCount = json['AbhiyanMandalCount'];
    abhiyanNagarCount = json['AbhiyanNagarCount'];
    abhiyanTalukaCount = json['AbhiyanTalukaCount'];
    abhiyanVastiCount = json['AbhiyanVastiCount'];
    anayaEkunCount = json['AnayaEkunCount'];
    anukulDharmik = json['AnukulDharmik'];
    anya = json['Anya'];
    anyaKalchaCount = json['AnyaKalchaCount'];
    dharmik = json['Dharmik'];
    ekunGram = json['EkunGram'];
    ekunMandal = json['EkunMandal'];
    ekunNagar = json['EkunNagar'];
    ekunTaluka = json['EkunTaluka'];
    ekunVasti = json['EkunVasti'];
    jSSanskrutik = json['JSSanskrutik'];
    jSewa = json['JSewa'];
    pEkunCount = json['PEkunCount'];
    pKalchaCount = json['PKalchaCount'];
    pMyAajCount = json['PAajCount'];
    sMyAajCount = json['SMyaajchaCount'];
    pratikulSamajik = json['PratikulSamajik'];
    sMyKalchaCount = json['SMyKalchaCount'];
    sTotalCount = json['STotalCount'];
    samajik = json['Samajik'];
    sanskrutik = json['Sanskrutik'];
    sewa = json['Sewa'];
    shaishanik = json['Shaishanik'];
    tShaishanik = json['TShaishanik'];
    if (json['abhiyaancount'] != null) {
      abhiyaancount = <Abhiyaancount>[];
      json['abhiyaancount'].forEach((v) {
        abhiyaancount!.add(new Abhiyaancount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbhiyanGramCount'] = this.abhiyanGramCount;
    data['AbhiyanMandalCount'] = this.abhiyanMandalCount;
    data['AbhiyanNagarCount'] = this.abhiyanNagarCount;
    data['AbhiyanTalukaCount'] = this.abhiyanTalukaCount;
    data['AbhiyanVastiCount'] = this.abhiyanVastiCount;
    data['AnayaEkunCount'] = this.anayaEkunCount;
    data['AnukulDharmik'] = this.anukulDharmik;
    data['Anya'] = this.anya;
    data['AnyaKalchaCount'] = this.anyaKalchaCount;
    data['Dharmik'] = this.dharmik;
    data['EkunGram'] = this.ekunGram;
    data['EkunMandal'] = this.ekunMandal;
    data['EkunNagar'] = this.ekunNagar;
    data['EkunTaluka'] = this.ekunTaluka;
    data['EkunVasti'] = this.ekunVasti;
    data['JSSanskrutik'] = this.jSSanskrutik;
    data['JSewa'] = this.jSewa;
    data['PEkunCount'] = this.pEkunCount;
    data['PKalchaCount'] = this.pKalchaCount;
    data['PAajCount'] = this.pMyAajCount;
    data['SMyaajchaCount'] = this.sMyAajCount;
    data['PratikulSamajik'] = this.pratikulSamajik;
    data['SMyKalchaCount'] = this.sMyKalchaCount;
    data['STotalCount'] = this.sTotalCount;
    data['Samajik'] = this.samajik;
    data['Sanskrutik'] = this.sanskrutik;
    data['Sewa'] = this.sewa;
    data['Shaishanik'] = this.shaishanik;
    data['TShaishanik'] = this.tShaishanik;
    if (this.abhiyaancount != null) {
      data['abhiyaancount'] =
          this.abhiyaancount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Abhiyaancount {
  int? aajchacountMale;
  int? aajchacountFemale;
  int? aajchacount;

  int? isaajchaChotaBaithak;
  int? aajchaChotaBaithakcountMale;
  int? aajchaChotaBaithakcountFemale;
  int? totalaajchaChotaBaithakcount;

  int? isKalchaChotaBaithak;
  int? kalchaChotaBaithakcountMale;
  int? kalchaChotaBaithakcountFemale;
  int? totalkalchaChotaBaithakcount;

  int? isTotalChotaBaithak;
  int? totalChotaBaithakMale;
  int? totalChotaBaithakFemale;
  int? totalChotaBaithak;

  int? kalchacountMale;
  int? kalchacountFemale;
  int? kalchacount;

  int? totalMale;
  int? totalFemale;
  int? total;

  String? naav;


  Abhiyaancount({
    this.aajchacountMale,
    this.aajchacountFemale,
    this.aajchacount,

    this.isaajchaChotaBaithak,
    this.aajchaChotaBaithakcountMale,
    this.aajchaChotaBaithakcountFemale,
    this.totalaajchaChotaBaithakcount,

    this.isKalchaChotaBaithak,
    this.kalchaChotaBaithakcountMale,
    this.kalchaChotaBaithakcountFemale,
    this.totalkalchaChotaBaithakcount,

    this.isTotalChotaBaithak,
    this.totalChotaBaithakMale,
    this.totalChotaBaithakFemale,
    this.totalChotaBaithak,

    this.kalchacountMale,
    this.kalchacountFemale,
    this.kalchacount,


    this.totalMale,
    this.totalFemale,
    this.total,

    this.naav,
  });

  Abhiyaancount.fromJson(Map<String, dynamic> json) {
    aajchacountMale = json['aajchacountMale'];
    aajchacountFemale = json['aajchacountFemale'];
    aajchacount = json['aajchacount'];

    isaajchaChotaBaithak = json['isaajchaChotaBaithak'];
    aajchaChotaBaithakcountMale = json['aajchaChotaBaithakcountMale'];
    aajchaChotaBaithakcountFemale = json['aajchaChotaBaithakcountFemale'];
    totalaajchaChotaBaithakcount = json['aajchaChotaBaithakcount'];

    isKalchaChotaBaithak = json['isKalchaChotaBaithak'];
    kalchaChotaBaithakcountMale = json['kalchaChotaBaithakcountMale'];
    kalchaChotaBaithakcountFemale = json['kalchaChotaBaithakcountFemale'];
    totalkalchaChotaBaithakcount = json['kalchaChotaBaithakcount'];

    isTotalChotaBaithak = json['isTotalChotaBaithak'];
    totalChotaBaithakMale = json['totalChotaBaithakMale'];
    totalChotaBaithakFemale = json['totalChotaBaithakFemale'];
    totalChotaBaithak = json['totalChotaBaithak'];

    kalchacountMale = json['kalchacountMale'];
    kalchacountFemale = json['kalchacountFemale'];
    kalchacount = json['kalchacount'];
    naav = json['naav'];
    totalMale = json['totalMale'];
    totalFemale = json['totalFemale'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aajchacountMale'] = this.aajchacountMale;
    data['aajchacountFemale'] = this.aajchacountFemale;
    data['aajchacount'] = this.aajchacount;

     data['isaajchaChotaBaithak'] = this.isaajchaChotaBaithak;
     data['aajchaChotaBaithakcountMale'] = this.aajchaChotaBaithakcountMale;
     data['aajchaChotaBaithakcountFemale'] = this.aajchaChotaBaithakcountFemale;
     data['aajchaChotaBaithakcount'] = this.totalaajchaChotaBaithakcount;

     data['isKalchaChotaBaithak'] = this.isKalchaChotaBaithak;
     data['kalchaChotaBaithakcountMale'] = this.kalchaChotaBaithakcountMale;
     data['kalchaChotaBaithakcountFemale'] = this.kalchaChotaBaithakcountFemale;
     data['kalchaChotaBaithakcount'] = this.totalkalchaChotaBaithakcount;

     data['isTotalChotaBaithak'] = this.isTotalChotaBaithak;
     data['totalChotaBaithakMale'] = this.totalChotaBaithakMale;
     data['totalChotaBaithakFemale'] = this.totalChotaBaithakFemale;
     data['totalChotaBaithak'] = this.totalChotaBaithak;

    data['kalchacountMale'] = this.kalchacountMale;
    data['kalchacountFemale'] = this.kalchacountFemale;
    data['kalchacount'] = this.kalchacount;

    data['naav'] = this.naav;
    data['totalMale'] = this.totalMale;
    data['totalFemale'] = this.totalFemale;
    data['total'] = this.total;
    return data;
  }
}

// class AbhiyanGruhasamparkResponse {
//   AbhiyanGruhasamparkData? abhiyanGruhasamparkData;
//   String? message;
//   String? status;
//
//   AbhiyanGruhasamparkResponse({this.abhiyanGruhasamparkData, this.message, this.status});
//
//   AbhiyanGruhasamparkResponse.fromJson(Map<String, dynamic> json) {
//     abhiyanGruhasamparkData = json['AbhiyanGruhasamparkData'] != null ? new AbhiyanGruhasamparkData.fromJson(json['AbhiyanGruhasamparkData']) : null;
//     message = json['Message'];
//     status = json['Status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.abhiyanGruhasamparkData != null) {
//       data['AbhiyanGruhasamparkData'] = this.abhiyanGruhasamparkData!.toJson();
//     }
//     data['Message'] = this.message;
//     data['Status'] = this.status;
//     return data;
//   }
// }
//
// class AbhiyanGruhasamparkData {
//   int? abhiyanGramCount;
//   int? abhiyanMandalCount;
//   int? abhiyanNagarCount;
//   int? abhiyanVastiCount;
//   int? abhiyanTalukaCount;
//   int? anayaEkunCount;
//   int? anukulDharmik;
//   int? anya;
//   int? anyaKalchaCount;
//   int? dharmik;
//   int? ekunGram;
//   int? ekunMandal;
//   int? ekunNagar;
//   int? ekunVasti;
//   int? ekunTaluka;
//   int? jSSanskrutik;
//   int? jSewa;
//   int? pEkunCount;
//   int? pKalchaCount;
//   int? pratikulSamajik;
//   int? sMyKalchaCount;
//   int? sTotalCount;
//   int? samajik;
//   int? sanskrutik;
//   int? sewa;
//   int? shaishanik;
//   int? tShaishanik;
//
//   AbhiyanGruhasamparkData(
//       {this.abhiyanGramCount,
//       this.abhiyanMandalCount,
//       this.abhiyanNagarCount,
//       this.abhiyanVastiCount,
//       this.abhiyanTalukaCount,
//       this.anayaEkunCount,
//       this.anukulDharmik,
//       this.anya,
//       this.anyaKalchaCount,
//       this.dharmik,
//       this.ekunGram,
//       this.ekunMandal,
//       this.ekunNagar,
//       this.ekunVasti,
//       this.jSSanskrutik,
//       this.jSewa,
//       this.pEkunCount,
//       this.pKalchaCount,
//       this.pratikulSamajik,
//       this.sMyKalchaCount,
//       this.sTotalCount,
//       this.samajik,
//       this.sanskrutik,
//       this.sewa,
//       this.shaishanik,
//       this.tShaishanik,
//       this.ekunTaluka});
//
//   AbhiyanGruhasamparkData.fromJson(Map<String, dynamic> json) {
//     abhiyanGramCount = json['AbhiyanGramCount'];
//     abhiyanMandalCount = json['AbhiyanMandalCount'];
//     abhiyanNagarCount = json['AbhiyanNagarCount'];
//     abhiyanVastiCount = json['AbhiyanVastiCount'];
//     abhiyanTalukaCount = json['AbhiyanTalukaCount'];
//     anayaEkunCount = json['AnayaEkunCount'];
//     anukulDharmik = json['AnukulDharmik'];
//     anya = json['Anya'];
//     anyaKalchaCount = json['AnyaKalchaCount'];
//     dharmik = json['Dharmik'];
//     ekunGram = json['EkunGram'];
//     ekunMandal = json['EkunMandal'];
//     ekunNagar = json['EkunNagar'];
//     ekunVasti = json['EkunVasti'];
//     ekunTaluka = json['EkunTaluka'];
//     jSSanskrutik = json['JSSanskrutik'];
//     jSewa = json['JSewa'];
//     pEkunCount = json['PEkunCount'];
//     pKalchaCount = json['PKalchaCount'];
//     pratikulSamajik = json['PratikulSamajik'];
//     sMyKalchaCount = json['SMyKalchaCount'];
//     sTotalCount = json['STotalCount'];
//     samajik = json['Samajik'];
//     sanskrutik = json['Sanskrutik'];
//     sewa = json['Sewa'];
//     shaishanik = json['Shaishanik'];
//     tShaishanik = json['TShaishanik'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['AbhiyanGramCount'] = this.abhiyanGramCount;
//     data['AbhiyanMandalCount'] = this.abhiyanMandalCount;
//     data['AbhiyanNagarCount'] = this.abhiyanNagarCount;
//     data['AbhiyanVastiCount'] = this.abhiyanVastiCount;
//     data['AbhiyanTalukaCount'] = this.abhiyanTalukaCount;
//     data['AnayaEkunCount'] = this.anayaEkunCount;
//     data['AnukulDharmik'] = this.anukulDharmik;
//     data['Anya'] = this.anya;
//     data['AnyaKalchaCount'] = this.anyaKalchaCount;
//     data['Dharmik'] = this.dharmik;
//     data['EkunGram'] = this.ekunGram;
//     data['EkunMandal'] = this.ekunMandal;
//     data['EkunNagar'] = this.ekunNagar;
//     data['EkunVasti'] = this.ekunVasti;
//     data['EkunTaluka'] = this.ekunTaluka;
//     data['JSSanskrutik'] = this.jSSanskrutik;
//     data['JSewa'] = this.jSewa;
//     data['PEkunCount'] = this.pEkunCount;
//     data['PKalchaCount'] = this.pKalchaCount;
//     data['PratikulSamajik'] = this.pratikulSamajik;
//     data['SMyKalchaCount'] = this.sMyKalchaCount;
//     data['STotalCount'] = this.sTotalCount;
//     data['Samajik'] = this.samajik;
//     data['Sanskrutik'] = this.sanskrutik;
//     data['Sewa'] = this.sewa;
//     data['Shaishanik'] = this.shaishanik;
//     data['TShaishanik'] = this.tShaishanik;
//     return data;
//   }
// }

class VisheshVyakti {
  String? anyaVishesh;
  String? email;
  int? gruhasamparkID;
  int? gruhasamparkVisheshID;
  String? mobileNumber;
  String? sansthaName;
  String? sansthaPadh;
  String? sansthaType;
  String? visheshNote;
  String? visheshVyaktiName;

  VisheshVyakti(
      {this.anyaVishesh,
      this.email,
      this.gruhasamparkID,
      this.gruhasamparkVisheshID,
      this.mobileNumber,
      this.sansthaName,
      this.sansthaPadh,
      this.sansthaType,
      this.visheshNote,
      this.visheshVyaktiName});

  VisheshVyakti.fromJson(Map<String, dynamic> json) {
    anyaVishesh = json['AnyaVishesh'];
    email = json['Email'];
    gruhasamparkID = json['GruhasamparkID'];
    gruhasamparkVisheshID = json['GruhasamparkVisheshID'];
    mobileNumber = json['MobileNumber'];
    sansthaName = json['SansthaName'];
    sansthaPadh = json['SansthaPadh'];
    sansthaType = json['SansthaType'];
    visheshNote = json['VisheshNote'];
    visheshVyaktiName = json['VisheshVyaktiName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AnyaVishesh'] = this.anyaVishesh;
    data['Email'] = this.email;
    data['GruhasamparkID'] = this.gruhasamparkID;
    data['GruhasamparkVisheshID'] = this.gruhasamparkVisheshID;
    data['MobileNumber'] = this.mobileNumber;
    data['SansthaName'] = this.sansthaName;
    data['SansthaPadh'] = this.sansthaPadh;
    data['SansthaType'] = this.sansthaType;
    data['VisheshNote'] = this.visheshNote;
    data['VisheshVyaktiName'] = this.visheshVyaktiName;
    return data;
  }
}
