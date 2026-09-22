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
  final String? anyapath;
  final String? urllink;
  final String? filebase64;
  final String? anyabase64;

  CreateUpdateShaakhaPustikaRequest({
    this.pkid = 0,
    required this.karyakramid,
    required this.monthno,
    required this.yearno,
    required this.cuserid,
    required this.vayogatid,
    required this.subjecttext,
    this.filepath,
    this.anyapath,
    this.urllink,
    this.filebase64,
    this.anyabase64,
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
      'anyapath': anyapath ?? '',
      'urllink': urllink ?? '',
      'filebase64': filebase64 ?? '',
      'anyabase64': anyabase64 ?? '',
    };
  }
}
