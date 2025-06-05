class VastisarvekshanDropDownDataModel {
  String? message;
  String? status;
  List<Masterdata>? masterdata;

  VastisarvekshanDropDownDataModel(
      {this.message, this.status, this.masterdata});

  VastisarvekshanDropDownDataModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['masterdata'] != null) {
      masterdata = <Masterdata>[];
      json['masterdata'].forEach((v) {
        masterdata!.add(new Masterdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.masterdata != null) {
      data['masterdata'] = this.masterdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Masterdata {
  int? id;
  int? parentid;
  int? isOther;
  String? typename;
  String? value;

  Masterdata({this.id, this.parentid, this.typename, this.value});

  Masterdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentid = json['parentid'];
    isOther = json['isother'];
    typename = json['typename'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isother'] = this.isOther;
    data['parentid'] = this.parentid;
    data['typename'] = this.typename;
    data['value'] = this.value;
    return data;
  }
}
