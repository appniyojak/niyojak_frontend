class VastiSarvekshanRespModel {
  String? status;
  String? message;
  List<VasahatList>? vasahatList;
  List<SajjanList>? sajjanList;
  List<AnyaList>? anyaList;
  List<MahatvaCesanaList>? mahatvaCesanaList;
  List<SamajikKaryakramList>? samajikKaryakramList;
  List<MotheVyavasayiList>? motheVyavasayiList;
  List<MotherUgnalayaList>? motherUgnalayaList;
  List<SchoolList>? schoolList;
  List<MaidanList>? maidanList;
  List<KaryakramList>? karyakramList;
  List<DharmikList>? dharmikList;
  List<DurjanList>? durjanList;
  List<HinduVirayadiList>? hinduVirayadiList;

  VastiSarvekshanRespModel({this.status,
    this.message,
    this.vasahatList,
    this.sajjanList,
    this.anyaList,
    this.mahatvaCesanaList,
    this.samajikKaryakramList,
    this.motheVyavasayiList,
    this.motherUgnalayaList,
    this.schoolList,
    this.maidanList,
    this.karyakramList,
    this.dharmikList,
    this.durjanList,
    this.hinduVirayadiList});

  VastiSarvekshanRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['VasahatList'] != null) {
      vasahatList = <VasahatList>[];
      json['VasahatList'].forEach((v) {
        vasahatList!.add(new VasahatList.fromJson(v));
      });
    }
    if (json['SajjanList'] != null) {
      sajjanList = <SajjanList>[];
      json['SajjanList'].forEach((v) {
        sajjanList!.add(new SajjanList.fromJson(v));
      });
    }
    if (json['AnyaList'] != null) {
      anyaList = <AnyaList>[];
      json['AnyaList'].forEach((v) {
        anyaList!.add(new AnyaList.fromJson(v));
      });
    }
    if (json['MahatvaCesanaList'] != null) {
      mahatvaCesanaList = <MahatvaCesanaList>[];
      json['MahatvaCesanaList'].forEach((v) {
        mahatvaCesanaList!.add(new MahatvaCesanaList.fromJson(v));
      });
    }
    if (json['SamajikKaryakramList'] != null) {
      samajikKaryakramList = <SamajikKaryakramList>[];
      json['SamajikKaryakramList'].forEach((v) {
        samajikKaryakramList!.add(new SamajikKaryakramList.fromJson(v));
      });
    }
    if (json['MotheVyavasayiList'] != null) {
      motheVyavasayiList = <MotheVyavasayiList>[];
      json['MotheVyavasayiList'].forEach((v) {
        motheVyavasayiList!.add(new MotheVyavasayiList.fromJson(v));
      });
    }
    if (json['MotherUgnalayaList'] != null) {
      motherUgnalayaList = <MotherUgnalayaList>[];
      json['MotherUgnalayaList'].forEach((v) {
        motherUgnalayaList!.add(new MotherUgnalayaList.fromJson(v));
      });
    }
    if (json['SchoolList'] != null) {
      schoolList = <SchoolList>[];
      json['SchoolList'].forEach((v) {
        schoolList!.add(new SchoolList.fromJson(v));
      });
    }
    if (json['MaidanList'] != null) {
      maidanList = <MaidanList>[];
      json['MaidanList'].forEach((v) {
        maidanList!.add(new MaidanList.fromJson(v));
      });
    }
    if (json['KaryakramList'] != null) {
      karyakramList = <KaryakramList>[];
      json['KaryakramList'].forEach((v) {
        karyakramList!.add(new KaryakramList.fromJson(v));
      });
    }
    if (json['DharmikList'] != null) {
      dharmikList = <DharmikList>[];
      json['DharmikList'].forEach((v) {
        dharmikList!.add(new DharmikList.fromJson(v));
      });
    }
    if (json['DurjanList'] != null) {
      durjanList = <DurjanList>[];
      json['DurjanList'].forEach((v) {
        durjanList!.add(new DurjanList.fromJson(v));
      });
    }
    if (json['HinduVirayadiList'] != null) {
      hinduVirayadiList = <HinduVirayadiList>[];
      json['HinduVirayadiList'].forEach((v) {
        hinduVirayadiList!.add(new HinduVirayadiList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.vasahatList != null) {
      data['VasahatList'] = this.vasahatList!.map((v) => v.toJson()).toList();
    }
    if (this.sajjanList != null) {
      data['SajjanList'] = this.sajjanList!.map((v) => v.toJson()).toList();
    }
    if (this.anyaList != null) {
      data['AnyaList'] = this.anyaList!.map((v) => v.toJson()).toList();
    }
    if (this.mahatvaCesanaList != null) {
      data['MahatvaCesanaList'] = this.mahatvaCesanaList!.map((v) => v.toJson()).toList();
    }
    if (this.samajikKaryakramList != null) {
      data['SamajikKaryakramList'] = this.samajikKaryakramList!.map((v) => v.toJson()).toList();
    }
    if (this.motheVyavasayiList != null) {
      data['MotheVyavasayiList'] = this.motheVyavasayiList!.map((v) => v.toJson()).toList();
    }
    if (this.motherUgnalayaList != null) {
      data['MotherUgnalayaList'] = this.motherUgnalayaList!.map((v) => v.toJson()).toList();
    }
    if (this.schoolList != null) {
      data['SchoolList'] = this.schoolList!.map((v) => v.toJson()).toList();
    }
    if (this.maidanList != null) {
      data['MaidanList'] = this.maidanList!.map((v) => v.toJson()).toList();
    }
    if (this.karyakramList != null) {
      data['KaryakramList'] = this.karyakramList!.map((v) => v.toJson()).toList();
    }
    if (this.dharmikList != null) {
      data['DharmikList'] = this.dharmikList!.map((v) => v.toJson()).toList();
    }
    if (this.durjanList != null) {
      data['DurjanList'] = this.durjanList!.map((v) => v.toJson()).toList();
    }
    if (this.hinduVirayadiList != null) {
      data['HinduVirayadiList'] = this.hinduVirayadiList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VasahatList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? prakar;
  String? bhavanacheNav;
  String? samparkSthiti;
  String? samparkSootr;
  String? doorabhaash;

  VasahatList(
      {this.vibhagName, this.bhaagJilhaName, this.nagarTalukaName, this.mandalName, this.vastigramName, this.prakar, this.bhavanacheNav, this.samparkSthiti, this.samparkSootr, this.doorabhaash});

  VasahatList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    prakar = json['Prakar'];
    bhavanacheNav = json['BhavanacheNav'];
    samparkSthiti = json['SamparkSthiti'];
    samparkSootr = json['SamparkSootr'];
    doorabhaash = json['Doorabhaash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Prakar'] = this.prakar;
    data['BhavanacheNav'] = this.bhavanacheNav;
    data['SamparkSthiti'] = this.samparkSthiti;
    data['SamparkSootr'] = this.samparkSootr;
    data['Doorabhaash'] = this.doorabhaash;
    return data;
  }
}

class SajjanList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? name;
  String? address;
  String? doorabhaash;
  String? shrenee;
  String? samparkSthiti;
  String? prabhaavkshetr;
  String? gender;

  SajjanList({this.vibhagName,
    this.bhaagJilhaName,
    this.nagarTalukaName,
    this.mandalName,
    this.vastigramName,
    this.name,
    this.address,
    this.doorabhaash,
    this.shrenee,
    this.samparkSthiti,
    this.prabhaavkshetr,
    this.gender});

  SajjanList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    name = json['Name'];
    address = json['Address'];
    doorabhaash = json['Doorabhaash'];
    shrenee = json['Shrenee'];
    samparkSthiti = json['SamparkSthiti'];
    prabhaavkshetr = json['Prabhaavkshetr'];
    gender = json['Gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Name'] = this.name;
    data['Address'] = this.address;
    data['Doorabhaash'] = this.doorabhaash;
    data['Shrenee'] = this.shrenee;
    data['SamparkSthiti'] = this.samparkSthiti;
    data['Prabhaavkshetr'] = this.prabhaavkshetr;
    data['Gender'] = this.gender;
    return data;
  }
}

class AnyaList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? name;
  String? address;
  String? doorabhaash;
  String? shrenee;
  String? upshrenee;
  String? upshrenee2;
  String? vishesh;
  String? prabhaavkshetr;
  String? anyavisesaMahiti;
  String? samparkSthiti;
  String? samparkSutraNav;
  String? otherUpshrenee;
  String? otherUpshrenee2;
  String? otherVishesh;
  String? samparkaSutraDoorbhash;
  String? gender;

  AnyaList({this.vibhagName,
    this.bhaagJilhaName,
    this.nagarTalukaName,
    this.mandalName,
    this.vastigramName,
    this.name,
    this.address,
    this.doorabhaash,
    this.shrenee,
    this.upshrenee,
    this.upshrenee2,
    this.vishesh,
    this.prabhaavkshetr,
    this.anyavisesaMahiti,
    this.samparkSthiti,
    this.samparkSutraNav,
    this.otherUpshrenee,
    this.otherUpshrenee2,
    this.otherVishesh,
    this.samparkaSutraDoorbhash,
    this.gender});

  AnyaList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    name = json['Name'];
    address = json['Address'];
    doorabhaash = json['Doorabhaash'];
    shrenee = json['Shrenee'];
    upshrenee = json['Upshrenee'];
    upshrenee2 = json['Upshrenee2'];
    vishesh = json['Vishesh'];
    prabhaavkshetr = json['Prabhaavkshetr'];
    anyavisesaMahiti = json['AnyavisesaMahiti'];
    samparkSthiti = json['SamparkSthiti'];
    samparkSutraNav = json['SamparkSutraNav'];
    otherUpshrenee = json['OtherUpshrenee'];
    otherUpshrenee2 = json['OtherUpshrenee2'];
    otherVishesh = json['OtherVishesh'];
    samparkaSutraDoorbhash = json['SamparkaSutraDoorbhash'];
    gender = json['Gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Name'] = this.name;
    data['Address'] = this.address;
    data['Doorabhaash'] = this.doorabhaash;
    data['Shrenee'] = this.shrenee;
    data['Upshrenee'] = this.upshrenee;
    data['Upshrenee2'] = this.upshrenee2;
    data['Vishesh'] = this.vishesh;
    data['Prabhaavkshetr'] = this.prabhaavkshetr;
    data['AnyavisesaMahiti'] = this.anyavisesaMahiti;
    data['SamparkSthiti'] = this.samparkSthiti;
    data['SamparkSutraNav'] = this.samparkSutraNav;
    data['OtherUpshrenee'] = this.otherUpshrenee;
    data['OtherUpshrenee2'] = this.otherUpshrenee2;
    data['OtherVishesh'] = this.otherVishesh;
    data['SamparkaSutraDoorbhash'] = this.samparkaSutraDoorbhash;
    data['Gender'] = this.gender;
    return data;
  }
}

class MahatvaCesanaList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? saan;
  String? ayojakaSansthaChiNaav;
  String? ayojakanchiNaav;
  String? ayojakSamparkSootr;
  String? otherSajareSan;

  MahatvaCesanaList({this.vibhagName,
    this.bhaagJilhaName,
    this.nagarTalukaName,
    this.mandalName,
    this.vastigramName,
    this.saan,
    this.ayojakaSansthaChiNaav,
    this.ayojakanchiNaav,
    this.ayojakSamparkSootr,
    this.otherSajareSan});

  MahatvaCesanaList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    saan = json['Saan'];
    ayojakaSansthaChiNaav = json['AyojakaSansthaChiNaav'];
    ayojakanchiNaav = json['AyojakanchiNaav'];
    ayojakSamparkSootr = json['AyojakSamparkSootr'];
    otherSajareSan = json['OtherSajareSan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Saan'] = this.saan;
    data['AyojakaSansthaChiNaav'] = this.ayojakaSansthaChiNaav;
    data['AyojakanchiNaav'] = this.ayojakanchiNaav;
    data['AyojakSamparkSootr'] = this.ayojakSamparkSootr;
    data['OtherSajareSan'] = this.otherSajareSan;
    return data;
  }
}

class SamajikKaryakramList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? saan;
  String? ayojakaSansthaChiNaav;
  String? ayojakanchiNaav;
  String? ayojakSamparkSootr;
  String? otherKaryakram;

  SamajikKaryakramList({this.vibhagName,
    this.bhaagJilhaName,
    this.nagarTalukaName,
    this.mandalName,
    this.vastigramName,
    this.saan,
    this.ayojakaSansthaChiNaav,
    this.ayojakanchiNaav,
    this.ayojakSamparkSootr,
    this.otherKaryakram});

  SamajikKaryakramList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    saan = json['Saan'];
    ayojakaSansthaChiNaav = json['AyojakaSansthaChiNaav'];
    ayojakanchiNaav = json['AyojakanchiNaav'];
    ayojakSamparkSootr = json['AyojakSamparkSootr'];
    otherKaryakram = json['OtherKaryakram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Saan'] = this.saan;
    data['AyojakaSansthaChiNaav'] = this.ayojakaSansthaChiNaav;
    data['AyojakanchiNaav'] = this.ayojakanchiNaav;
    data['AyojakSamparkSootr'] = this.ayojakSamparkSootr;
    data['OtherKaryakram'] = this.otherKaryakram;
    return data;
  }
}

class MotheVyavasayiList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? kendra;
  String? name;

  MotheVyavasayiList({this.vibhagName, this.bhaagJilhaName, this.nagarTalukaName, this.mandalName, this.vastigramName, this.kendra, this.name});

  MotheVyavasayiList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    kendra = json['Kendra'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Kendra'] = this.kendra;
    data['Name'] = this.name;
    return data;
  }
}

class MotherUgnalayaList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? prakalpa;
  String? name;

  MotherUgnalayaList({this.vibhagName, this.bhaagJilhaName, this.nagarTalukaName, this.mandalName, this.vastigramName, this.prakalpa, this.name});

  MotherUgnalayaList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    prakalpa = json['Prakalpa'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Prakalpa'] = this.prakalpa;
    data['Name'] = this.name;
    return data;
  }
}

class SchoolList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? shaikshanikSansthaan;
  String? prakaar;
  String? maadhyam;
  String? chaalakPrakaar;
  String? name;
  String? milkat;

  SchoolList({this.vibhagName,
    this.bhaagJilhaName,
    this.nagarTalukaName,
    this.mandalName,
    this.vastigramName,
    this.shaikshanikSansthaan,
    this.prakaar,
    this.maadhyam,
    this.chaalakPrakaar,
    this.name,
    this.milkat});

  SchoolList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    shaikshanikSansthaan = json['ShaikshanikSansthaan'];
    prakaar = json['Prakaar'];
    maadhyam = json['Maadhyam'];
    chaalakPrakaar = json['ChaalakPrakaar'];
    name = json['Name'];
    milkat = json['Milkat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['ShaikshanikSansthaan'] = this.shaikshanikSansthaan;
    data['Prakaar'] = this.prakaar;
    data['Maadhyam'] = this.maadhyam;
    data['ChaalakPrakaar'] = this.chaalakPrakaar;
    data['Name'] = this.name;
    data['Milkat'] = this.milkat;
    return data;
  }
}

class MaidanList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? name;

  MaidanList({this.vibhagName, this.bhaagJilhaName, this.nagarTalukaName, this.mandalName, this.vastigramName, this.name});

  MaidanList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Name'] = this.name;
    return data;
  }
}

class KaryakramList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? prakaar;
  String? name;
  String? shamta;
  String? nivasaSathiUpalabdha;
  String? nivaasKshamata;

  KaryakramList(
      {this.vibhagName, this.bhaagJilhaName, this.nagarTalukaName, this.mandalName, this.vastigramName, this.prakaar, this.name, this.shamta, this.nivasaSathiUpalabdha, this.nivaasKshamata});

  KaryakramList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    prakaar = json['Prakaar'];
    name = json['Name'];
    shamta = json['Shamta'];
    nivasaSathiUpalabdha = json['NivasaSathiUpalabdha'];
    nivaasKshamata = json['NivaasKshamata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Prakaar'] = this.prakaar;
    data['Name'] = this.name;
    data['Shamta'] = this.shamta;
    data['NivasaSathiUpalabdha'] = this.nivasaSathiUpalabdha;
    data['NivaasKshamata'] = this.nivaasKshamata;
    return data;
  }
}

class DharmikList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? dhaarmikNetritva;
  String? name;

  DharmikList({this.vibhagName, this.bhaagJilhaName, this.nagarTalukaName, this.mandalName, this.vastigramName, this.dhaarmikNetritva, this.name});

  DharmikList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    dhaarmikNetritva = json['DhaarmikNetritva'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['DhaarmikNetritva'] = this.dhaarmikNetritva;
    data['Name'] = this.name;
    return data;
  }
}

class DurjanList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? name;
  String? prakar;
  String? shiksha;
  String? gunha;

  DurjanList({this.vibhagName, this.bhaagJilhaName, this.nagarTalukaName, this.mandalName, this.vastigramName, this.name, this.prakar, this.shiksha, this.gunha});

  DurjanList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    name = json['Name'];
    prakar = json['Prakar'];
    shiksha = json['Shiksha'];
    gunha = json['Gunha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Name'] = this.name;
    data['Prakar'] = this.prakar;
    data['Shiksha'] = this.shiksha;
    data['Gunha'] = this.gunha;
    return data;
  }
}

class HinduVirayadiList {
  String? vibhagName;
  String? bhaagJilhaName;
  String? nagarTalukaName;
  String? mandalName;
  String? vastigramName;
  String? name;

  HinduVirayadiList({this.vibhagName,
    this.bhaagJilhaName,
    this.nagarTalukaName,
    this.mandalName,
    this.vastigramName,
    this.name});

  HinduVirayadiList.fromJson(Map<String, dynamic> json) {
    vibhagName = json['VibhagName'];
    bhaagJilhaName = json['BhaagJilhaName'];
    nagarTalukaName = json['NagarTalukaName'];
    mandalName = json['MandalName'];
    vastigramName = json['VastigramName'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VibhagName'] = this.vibhagName;
    data['BhaagJilhaName'] = this.bhaagJilhaName;
    data['NagarTalukaName'] = this.nagarTalukaName;
    data['MandalName'] = this.mandalName;
    data['VastigramName'] = this.vastigramName;
    data['Name'] = this.name;
    return data;
  }
}