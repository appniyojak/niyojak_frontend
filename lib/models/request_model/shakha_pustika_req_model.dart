// models/shaakha_pustika_request_model.dart

class CreateUpdateShaakhaPustikaRequest {
  final int pkid;
  final int karyakramid;
  final int monthno;
  final int yearno;
  final int cuserid;
  final String vayogatid;
  final String? subjecttext;
  final String? filepath;
  final String? urllink;
  final String? filebase64;

  CreateUpdateShaakhaPustikaRequest({
    this.pkid = 0,
    required this.karyakramid,
    required this.monthno,
    required this.yearno,
    required this.cuserid,
    required this.vayogatid,
    required this.subjecttext,
    this.filepath,
    this.urllink,
    this.filebase64,
  });

  Map<String, dynamic> toJson() {
    return {
      'pkid': pkid,
      'karyakramid': karyakramid,
      'monthno': monthno,
      'yearno': yearno,
      'cuserid': cuserid,
      'vayogatid': vayogatid,
      'subjecttext': subjecttext ?? '',
      'filepath': filepath ?? '',
      'urllink': urllink ?? '',
      'filebase64': filebase64 ?? '',
    };
  }
}
// models/shaakha_pustika_response_model.dart

class CreateUpdateShaakhaPustikaRespModel {
  final String? Status;
  final String? Message;

  CreateUpdateShaakhaPustikaRespModel({this.Status, this.Message});

  factory CreateUpdateShaakhaPustikaRespModel.fromJson(Map<String, dynamic> json) {
    return CreateUpdateShaakhaPustikaRespModel(
      Status: json['Status']?.toString(),
      Message: json['Message']?.toString(),
    );
  }
}
