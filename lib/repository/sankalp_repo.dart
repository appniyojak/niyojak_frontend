import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:niyojak_prod/models/response_model/get_sankalp_response_model.dart';

import 'package:niyojak_prod/models/response_model/save_sankalp_response_model.dart';
import '../helpers/static_data.dart' as Statics;

class SankalpRepo {
  final jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  Future<GetSankalpResponseModel> getSankalp(Map<String, dynamic> body) async {
    GetSankalpResponseModel getSankalpResponse;
    final response = await http.post(Uri.parse(Statics.urlGetSankalpForApp), headers: jHeaders, body: json.encode(body));
    print("Response-${response.body}");
    getSankalpResponse = GetSankalpResponseModel.fromJson(json.decode(response.body));
    return getSankalpResponse;
  }

  Future<SaveSankalpDataResponseModel> saveData(Map<String, dynamic> body) async {
    SaveSankalpDataResponseModel sankalpDataResponse;
    final response = await http.post(Uri.parse(Statics.urlSaveSankalForApp), body: json.encode(body), headers: jHeaders);
    print("Response-${response.body}");
    sankalpDataResponse = SaveSankalpDataResponseModel.fromJson(json.decode(response.body));
    return sankalpDataResponse;
  }

  // Future<void> getSankalp(Map<String, dynamic> body) async {
  //   final response = await http.post(
  //       Uri.parse(Statics.urlGetSankalpForApp),
  //       headers: jHeaders,
  //       body: json.encode(body));
  //   print("Response-${response.body}");
  //
}
