class UpnagarUpkhandaReportModel {
  String? message;
  String? status;
  List<UpkhandaDataList>? dataList;
  List<GeoHierarchyData>? datanameList;

  // List<UpkhandaExcelDataList>? datanameList;

  UpnagarUpkhandaReportModel({this.message, this.status, this.dataList, this.datanameList});

  UpnagarUpkhandaReportModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['dataList'] != null) {
      dataList = <UpkhandaDataList>[];
      json['dataList'].forEach((v) {
        dataList!.add(new UpkhandaDataList.fromJson(v));
      });
    }
    if (json['GeoHierarchyData'] != null) {
      datanameList = <GeoHierarchyData>[];
      json['GeoHierarchyData'].forEach((v) {
        datanameList!.add(new GeoHierarchyData.fromJson(v));
      });
    }
    // if (json['dataname'] != null) {
    //   datanameList = <GeoHierarchyData>[];
    //   json['dataname'].forEach((v) {
    //     datanameList!.add(new GeoHierarchyData.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.dataList != null) {
      data['dataList'] = this.dataList!.map((v) => v.toJson()).toList();
    }
    if (this.datanameList != null) {
      data['GeoHierarchyData'] = this.datanameList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpkhandaDataList {
  String? geoUnitId;
  String? goUnitName;
  int? nagarCount;
  int? upKhandCount;
  int? upNagarCount;
  int? gramCount;
  int? vastiCount;
  int? mapUpKhandCount;
  int? mapUpNagarCount;

  UpkhandaDataList({
    this.geoUnitId,
    this.goUnitName,
    this.nagarCount,
    this.upKhandCount,
    this.upNagarCount,
    this.gramCount,
    this.vastiCount,
    this.mapUpKhandCount,
    this.mapUpNagarCount,
  });

  UpkhandaDataList.fromJson(Map<String, dynamic> json) {
    geoUnitId = json['GeoUnitID'].toString();
    goUnitName = json['GoUnitName'];
    nagarCount = json['NagarCount'];
    upKhandCount = json['UpKhandCount'];
    upNagarCount = json['UpNagarCount'];
    gramCount = json['gramCount'];
    vastiCount = json['vastiCount'];
    mapUpKhandCount = json['mapUpKhandCount'];
    mapUpNagarCount = json['mapUpNagarCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GeoUnitID'] = this.geoUnitId;
    data['GoUnitName'] = this.goUnitName;
    data['NagarCount'] = this.nagarCount;
    data['UpKhandCount'] = this.upKhandCount;
    data['UpNagarCount'] = this.upNagarCount;
    data['gramCount'] = this.gramCount;
    data['vastiCount'] = this.vastiCount;
    data['mapUpKhandCount'] = this.mapUpKhandCount;
    data['mapUpNagarCount'] = this.mapUpNagarCount;
    return data;
  }
}

class GeoHierarchyData {
  List<Mandals>? mandals;
  int? nagarID;
  String? nagarName;
  List<Upkhands>? upkhands;
  List<Upnagars>? upnagars;
  List<String>? vastiNames;

  GeoHierarchyData({this.mandals, this.nagarID, this.nagarName, this.upkhands, this.upnagars, this.vastiNames});

  GeoHierarchyData.fromJson(Map<String, dynamic> json) {
    if (json['Mandals'] != null) {
      mandals = <Mandals>[];
      json['Mandals'].forEach((v) {
        mandals!.add(new Mandals.fromJson(v));
      });
    }
    nagarID = json['NagarID'];
    nagarName = json['NagarName'];
    if (json['Upkhands'] != null) {
      upkhands = <Upkhands>[];
      json['Upkhands'].forEach((v) {
        upkhands!.add(new Upkhands.fromJson(v));
      });
    }
    if (json['Upnagars'] != null) {
      upnagars = <Upnagars>[];
      json['Upnagars'].forEach((v) {
        upnagars!.add(new Upnagars.fromJson(v));
      });
    }
    vastiNames = json['VastiNames'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mandals != null) {
      data['Mandals'] = this.mandals!.map((v) => v.toJson()).toList();
    }
    data['NagarID'] = this.nagarID;
    data['NagarName'] = this.nagarName;
    if (this.upkhands != null) {
      data['Upkhands'] = this.upkhands!.map((v) => v.toJson()).toList();
    }
    if (this.upnagars != null) {
      data['Upnagars'] = this.upnagars!.map((v) => v.toJson()).toList();
    }
    data['VastiNames'] = this.vastiNames;
    return data;
  }
}

class Mandals {
  List<String>? graamNames;
  String? mandalName;

  Mandals({this.graamNames, this.mandalName});

  Mandals.fromJson(Map<String, dynamic> json) {
    graamNames = json['GraamNames'].cast<String>();
    mandalName = json['MandalName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GraamNames'] = this.graamNames;
    data['MandalName'] = this.mandalName;
    return data;
  }
}

class Upkhands {
  List<String>? mappedMandals;
  String? upkhandName;

  Upkhands({this.mappedMandals, this.upkhandName});

  Upkhands.fromJson(Map<String, dynamic> json) {
    mappedMandals = json['MappedMandals'].cast<String>();
    upkhandName = json['UpkhandName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MappedMandals'] = this.mappedMandals;
    data['UpkhandName'] = this.upkhandName;
    return data;
  }
}

class Upnagars {
  List<String>? mappedVastis;
  String? upnagarName;

  Upnagars({this.mappedVastis, this.upnagarName});

  Upnagars.fromJson(Map<String, dynamic> json) {
    mappedVastis = json['MappedVastis'].cast<String>();
    upnagarName = json['UpnagarName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MappedVastis'] = this.mappedVastis;
    data['UpnagarName'] = this.upnagarName;
    return data;
  }
}

// class UpkhandaExcelDataList {
//   String? goUnitName;
//   String? nagarNames;
//   String? vastiNames;
//   String? gramNames;
//   String? upNagarNames;
//   String? mapUpNagarNames;
//   String? upKhandNames;
//   String? mapUpKhandNames;
//
//   UpkhandaExcelDataList({this.goUnitName, this.nagarNames, this.vastiNames, this.gramNames, this.upNagarNames, this.mapUpNagarNames, this.upKhandNames, this.mapUpKhandNames});
//
//   UpkhandaExcelDataList.fromJson(Map<String, dynamic> json) {
//     goUnitName = json['GoUnitName'];
//     nagarNames = json['NagarNames'];
//     vastiNames = json['VastiNames'];
//     gramNames = json['GramNames'];
//     upNagarNames = json['UpNagarNames'];
//     mapUpNagarNames = json['MapUpNagarNames'];
//     upKhandNames = json['UpKhandNames'];
//     mapUpKhandNames = json['MapUpKhandNames'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['GoUnitName'] = this.goUnitName;
//     data['NagarNames'] = this.nagarNames;
//     data['VastiNames'] = this.vastiNames;
//     data['GramNames'] = this.gramNames;
//     data['UpNagarNames'] = this.upNagarNames;
//     data['MapUpNagarNames'] = this.mapUpNagarNames;
//     data['UpKhandNames'] = this.upKhandNames;
//     data['MapUpKhandNames'] = this.mapUpKhandNames;
//     return data;
//   }
// }
