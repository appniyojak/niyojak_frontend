import 'offline_shaakhaa_pustika_resp_model.dart';

class GetShaakhaPustikaByIdRespModel {
  final String? status;
  final String? message;
  final OfflineShaakhaPustika? data;

  GetShaakhaPustikaByIdRespModel({
    this.status,
    this.message,
    this.data,
  });

  factory GetShaakhaPustikaByIdRespModel.fromJson(Map<String, dynamic> json) {
    return GetShaakhaPustikaByIdRespModel(
      status: json['Status']?.toString(),
      message: json['Message']?.toString(),
      data: json['data'] != null ? OfflineShaakhaPustika.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }
}
