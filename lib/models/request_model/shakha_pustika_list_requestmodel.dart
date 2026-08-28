// models/request_model/shakha_pustika_list_req_model.dart

class GetShaakhaPustikaListRequest {
  final int cuserid;
  final int geounitid;
  final int karyakramid;
  final int monthno;
  final int yearno;
  final int vayogatid;

  GetShaakhaPustikaListRequest({
    required this.cuserid,
    required this.geounitid,
    required this.karyakramid,
    required this.monthno,
    required this.yearno,
    required this.vayogatid,
  });

  Map<String, dynamic> toJson() {
    return {
      'cuserid': cuserid,
      'geounitid': geounitid,
      'karyakramid': karyakramid,
      'monthno': monthno,
      'yearno': yearno,
      'vayogatid': vayogatid,
    };
  }
}
