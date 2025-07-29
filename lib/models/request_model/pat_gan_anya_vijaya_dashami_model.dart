class SwayamSewakPatGanAnyaModel {
  List<PatGanAnyaDataList>? patGanAnyaDataList;

  SwayamSewakPatGanAnyaModel({this.patGanAnyaDataList});

  SwayamSewakPatGanAnyaModel.fromJson(Map<String, dynamic> json) {
    if (json['PatGanAnyaDataList'] != null) {
      patGanAnyaDataList = <PatGanAnyaDataList>[];
      json['PatGanAnyaDataList'].forEach((v) {
        patGanAnyaDataList!.add(new PatGanAnyaDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patGanAnyaDataList != null) {
      data['PatGanAnyaDataList'] =
          this.patGanAnyaDataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PatGanAnyaDataList {
  int? selectedLevelId;
  String? selectedLevelName;
  int? shishupatSankhya;
  int? baalpatSankhya;
  int? mahaidyalayinpatSankhya;
  int? tarunpatSankhya;
  int? proudhpatSankhya;
  int? totalpatSankhya;
  int? shishuGanvesh;
  int? baalGanvesh;
  int? mahaidyalayinGanvesh;
  int? tarunGanvesh;
  int? proudhGanvesh;
  int? totalGanvesh;
  int? shishuAnyaUpastith;
  int? baalAnyaUpastith;
  int? mahaidyalayinAnyaUpastith;
  int? tarunAnyaUpastith;
  int? proudhAnyaUpastith;
  int? totalAnyaUpastith;

  PatGanAnyaDataList(
      {this.selectedLevelId,
      this.selectedLevelName,
      this.shishupatSankhya,
      this.baalpatSankhya,
      this.mahaidyalayinpatSankhya,
      this.tarunpatSankhya,
      this.proudhpatSankhya,
      this.totalpatSankhya,
      this.shishuGanvesh,
      this.baalGanvesh,
      this.mahaidyalayinGanvesh,
      this.tarunGanvesh,
      this.proudhGanvesh,
      this.totalGanvesh,
      this.shishuAnyaUpastith,
      this.baalAnyaUpastith,
      this.mahaidyalayinAnyaUpastith,
      this.tarunAnyaUpastith,
      this.proudhAnyaUpastith,
      this.totalAnyaUpastith});

  PatGanAnyaDataList.fromJson(Map<String, dynamic> json) {
    selectedLevelId = json['selectedLevelId'];
    selectedLevelName = json['selectedLevelName'];
    shishupatSankhya = json['shishupatSankhya'];
    baalpatSankhya = json['baalpatSankhya'];
    mahaidyalayinpatSankhya = json['mahaidyalayinpatSankhya'];
    tarunpatSankhya = json['tarunpatSankhya'];
    proudhpatSankhya = json['proudhpatSankhya'];
    totalpatSankhya = json['totalpatSankhya'];
    shishuGanvesh = json['shishuGanvesh'];
    baalGanvesh = json['baalGanvesh'];
    mahaidyalayinGanvesh = json['mahaidyalayinGanvesh'];
    tarunGanvesh = json['tarunGanvesh'];
    proudhGanvesh = json['proudhGanvesh'];
    totalGanvesh = json['totalGanvesh'];
    shishuAnyaUpastith = json['shishuAnyaUpastith'];
    baalAnyaUpastith = json['baalAnyaUpastith'];
    mahaidyalayinAnyaUpastith = json['mahaidyalayinAnyaUpastith'];
    tarunAnyaUpastith = json['tarunAnyaUpastith'];
    proudhAnyaUpastith = json['proudhAnyaUpastith'];
    totalAnyaUpastith = json['totalAnyaUpastith'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['selectedLevelId'] = this.selectedLevelId;
    data['selectedLevelName'] = this.selectedLevelName;
    data['shishupatSankhya'] = this.shishupatSankhya;
    data['baalpatSankhya'] = this.baalpatSankhya;
    data['mahaidyalayinpatSankhya'] = this.mahaidyalayinpatSankhya;
    data['tarunpatSankhya'] = this.tarunpatSankhya;
    data['proudhpatSankhya'] = this.proudhpatSankhya;
    data['totalpatSankhya'] = this.totalpatSankhya;
    data['shishuGanvesh'] = this.shishuGanvesh;
    data['baalGanvesh'] = this.baalGanvesh;
    data['mahaidyalayinGanvesh'] = this.mahaidyalayinGanvesh;
    data['tarunGanvesh'] = this.tarunGanvesh;
    data['proudhGanvesh'] = this.proudhGanvesh;
    data['totalGanvesh'] = this.totalGanvesh;
    data['shishuAnyaUpastith'] = this.shishuAnyaUpastith;
    data['baalAnyaUpastith'] = this.baalAnyaUpastith;
    data['mahaidyalayinAnyaUpastith'] = this.mahaidyalayinAnyaUpastith;
    data['tarunAnyaUpastith'] = this.tarunAnyaUpastith;
    data['proudhAnyaUpastith'] = this.proudhAnyaUpastith;
    data['totalAnyaUpastith'] = this.totalAnyaUpastith;
    return data;
  }
}
