import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../models/response_model/vasti_sarvekshan_resp_model.dart';

class VastiSarvekshanScreen extends StatefulWidget {
  const VastiSarvekshanScreen({super.key});

  @override
  State<VastiSarvekshanScreen> createState() => _VastiSarvekshanScreenState();
}

class _VastiSarvekshanScreenState extends State<VastiSarvekshanScreen> {
  VastiSarvekshanRespModel? data;

  getReportDataFun() async {
    setState(() {
      data = null;
      // _isLoading = true;
    });
    Map<String, dynamic> formData = {
      "GeoUnitID": int.tryParse(_selectedGeoUnitId.toString()) ?? null,
      "type": type ?? null,
      "AppUserID": int.tryParse(Statics.userDetails['userID']) ?? null,
    };

    String formattedJson = const JsonEncoder.withIndent('  ').convert(formData);
    log("Form Data (JSON):\n$formattedJson");
    data = await Statics.getVastiSarvekshanDataDump(context, formData);
    // log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${jsonDecode(jsonEncode(vijayadashamiReport))}");
    setState(() {
      data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
