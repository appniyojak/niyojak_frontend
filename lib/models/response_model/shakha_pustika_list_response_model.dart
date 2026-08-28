// models/response_model/shakha_pustika_list_resp_model.dart

class GetShaakhaPustikaListItem {
  final int pkid;
  final int yearno;
  final int monthno;
  final int canupdate;
  final String? karyakramname;
  final String? vayogatname;
  final String? subjecttext;
  final String? filepath;

  GetShaakhaPustikaListItem({
    required this.pkid,
    required this.yearno,
    required this.monthno,
    required this.canupdate,
    this.karyakramname,
    this.vayogatname,
    this.subjecttext,
    this.filepath,
  });

  factory GetShaakhaPustikaListItem.fromJson(Map<String, dynamic> json) {
    return GetShaakhaPustikaListItem(
      pkid: json['pkid'] ?? 0,
      yearno: json['yearno'] ?? 0,
      monthno: json['monthno'] ?? 0,
      canupdate: json['canupdate'] ?? 0,
      karyakramname: json['karyakramname']?.toString(),
      vayogatname: json['vayogatname']?.toString(),
      subjecttext: json['subjecttext']?.toString(),
      filepath: json['filepath']?.toString(),
    );
  }
}

class GetShaakhaPustikaListRespModel {
  final String? status;
  final String? message;
  final List<GetShaakhaPustikaListItem> list;

  GetShaakhaPustikaListRespModel({
    this.status,
    this.message,
    required this.list,
  });

  factory GetShaakhaPustikaListRespModel.fromJson(Map<String, dynamic> json) {
    return GetShaakhaPustikaListRespModel(
      status: json['Status']?.toString(), // CHANGED — capital S from backend
      message: json['Message']?.toString(), // CHANGED — capital M from backend
      list: (json['list'] as List<dynamic>?) // CHANGED — key is 'list', not 'data'
              ?.map((e) => GetShaakhaPustikaListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
