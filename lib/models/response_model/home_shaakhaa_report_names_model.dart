import 'names_data_model.dart';

class HomeShaakhaaReportNamesRespModel {
  String? status;
  String? message;
  List<DataDetails>? data;

  HomeShaakhaaReportNamesRespModel({this.status, this.message, this.data});

  HomeShaakhaaReportNamesRespModel.fromJson(Map<String, dynamic> json) {
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
