// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:niyojak_prod/helpers/static_data.dart';
//
// class ApiRepository {
//   static const _headers = {'Content-Type': 'application/json', 'Accept': '*/*'};
//
//   /// null = error / unavailable, [] = no data
//   static Future<List<T>?> getList<T>({
//     required String url,
//     required Map<String, dynamic> body,
//     required List<T> Function(Map<String, dynamic> json) parse,
//     required Future<List<T>> Function() fromLocal,
//     bool Function()? skipLocalFallback,
//     BuildContext? context,
//   }) =>
//       _fetch<List<T>>(
//         url: url,
//         body: body,
//         parse: parse,
//         fromLocal: fromLocal,
//         skipLocalFallback: skipLocalFallback,
//         context: context,
//       );
//
//   static Future<T?> getById<T>({
//     required String url,
//     required Map<String, dynamic> body,
//     required T? Function(Map<String, dynamic> json) parse,
//     required Future<T?> Function() fromLocal,
//     bool Function()? skipLocalFallback,
//     BuildContext? context,
//   }) =>
//       _fetch<T?>(
//         url: url,
//         body: body,
//         parse: parse,
//         fromLocal: fromLocal,
//         skipLocalFallback: skipLocalFallback,
//         context: context,
//       );
//
//   // Single place for the flow: connectivity -> API -> local fallback
//   static Future<R?> _fetch<R>({
//     required String url,
//     required Map<String, dynamic> body,
//     required R Function(Map<String, dynamic> json) parse,
//     required Future<R?> Function() fromLocal,
//     bool Function()? skipLocalFallback,
//     BuildContext? context,
//   }) async {
//     Future<R?> local() async {
//       log("skipLocalFallback >> ${skipLocalFallback?.call()}");
//       if (skipLocalFallback?.call() ?? false) return null;
//       log("No internet — falling back to local data");
//       final _list = await fromLocal();
//       log("local response >>>>>>>> ${_list is List ? _list.length : _list}");
//       return _list;
//     }
//
//     final connected = await isInternetConnected();
//     if (connected != true) return local(); // offline -> DB
//
//     final showLoader = context != null;
//     if (showLoader) showLoaderDialog(context);
//
//     try {
//       log("api >>> $url");
//       log("req >>> ${jsonEncode(body)}");
//       final response = await http.post(Uri.parse(url), headers: _headers, body: jsonEncode(body));
//
//       if (response.statusCode == 200) {
//         log("response.body >>>>>>>> ${(((response.body)))}");
//         return parse(jsonDecode(response.body) as Map<String, dynamic>);
//       }
//       log("API failed ${response.statusCode} - ${response.body}, falling back to local");
//       return await local(); // server error -> DB
//     } catch (e) {
//       log("Exception: $e");
//       return null;
//     } finally {
//       if (showLoader && context.mounted) Navigator.of(context, rootNavigator: true).pop();
//     }
//   }
// }
