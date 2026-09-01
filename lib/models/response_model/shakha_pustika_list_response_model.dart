import 'offline_shaakhaa_pustika_resp_model.dart';

class GetShaakhaPustikaListRespModel {
  final String? status;
  final String? message;
  final List<OfflineShaakhaPustika> list;

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
              ?.map((e) => OfflineShaakhaPustika.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
