// models/response_model/shakha_pustika_by_id_resp_model.dart

class GetShaakhaPustikaByIdData {
  final int pkid;
  final int karyakramid;
  final int yearno;
  final int monthno;
  final String? subjecttext;
  final String? filepath;
  final String? urllink;
  final String? vayogatid;

  GetShaakhaPustikaByIdData({
    required this.pkid,
    required this.karyakramid,
    required this.yearno,
    required this.monthno,
    this.subjecttext,
    this.filepath,
    this.urllink,
    this.vayogatid,
  });

  factory GetShaakhaPustikaByIdData.fromJson(Map<String, dynamic> json) {
    return GetShaakhaPustikaByIdData(
      pkid: json['pkid'] ?? 0,
      karyakramid: json['karyakramid'] ?? 0,
      yearno: json['yearno'] ?? 0,
      monthno: json['monthno'] ?? 0,
      subjecttext: json['subjecttext']?.toString(),
      filepath: json['filepath']?.toString(),
      urllink: json['urllink']?.toString(),
      vayogatid: json['vayogatid']?.toString(),
    );
  }
}

class GetShaakhaPustikaByIdRespModel {
  final String? status;
  final String? message;
  final GetShaakhaPustikaByIdData? data;

  GetShaakhaPustikaByIdRespModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetShaakhaPustikaByIdRespModel.fromJson(Map<String, dynamic> json) {
    return GetShaakhaPustikaByIdRespModel(
      status: json['Status']?.toString(),
      message: json['Message']?.toString(),
      data: json['data'] != null ? GetShaakhaPustikaByIdData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }
}
