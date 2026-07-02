class HomeScreenNamesRespModel {
  String? status;
  String? message;
  List<DataDetails>? data;

  HomeScreenNamesRespModel({this.status, this.message, this.data});

  HomeScreenNamesRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <DataDetails>[];
      json['data'].forEach((v) {
        data!.add(new DataDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataDetailsGroup {
  final String groupType;
  final List<DataDetails> items;

  DataDetailsGroup({required this.groupType, required this.items});
}

class DataDetails {
  String? value;
  String? type;

  DataDetails({this.value, this.type});

  DataDetails.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Type'] = this.type;
    return data;
  }
}
