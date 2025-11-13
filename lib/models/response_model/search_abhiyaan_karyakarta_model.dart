import 'AbhiyaanSwayamsevakListResponse.dart';

class SearchAbhiyaanKaryakartaRespModel {
  String? status;
  String? message;
  bool ispresentinassewak = false;
  AbhiyanSwayamsevakList? swayamsevak;

  SearchAbhiyaanKaryakartaRespModel({this.status, this.message, this.ispresentinassewak = false, this.swayamsevak});

  SearchAbhiyaanKaryakartaRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    ispresentinassewak = json['ispresentinassewak'] == 1;
    swayamsevak = json['SwayamsevakList'] != null ? new AbhiyanSwayamsevakList.fromJson(json['SwayamsevakList']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['ispresentinassewak'] = this.ispresentinassewak;
    if (this.swayamsevak != null) {
      data['SwayamsevakList'] = this.swayamsevak!.toJson();
    }
    return data;
  }
}
