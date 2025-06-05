import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class NidhiSankalanCard extends StatelessWidget {
  final sankalanItem;
  var strType;
  var onSaveDetails;

  NidhiSankalanCard(this.sankalanItem, this.strType, this.onSaveDetails);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        title: Text(sankalanItem["GeoUnitName"]),
        subtitle: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Wrap(
                  children: [
                    Text(sankalanItem["PersonName"].toString()),
                    SizedBox(
                      width: (0.05 * Statics.getDeviceSize(context).width),
                    ),
                    if (strType == 'SahabhaagiKaaryakartaa') Text(sankalanItem["GenderCode"].toString()),
                    if (strType == 'SahabhaagiKaaryakartaa') SizedBox(width: (0.05 * Statics.getDeviceSize(context).width)),
                    if (strType == 'VisheshVyakti') Text(sankalanItem["CategoryCode"].toString()),
                    if (strType == 'VisheshVyakti') SizedBox(width: (0.05 * Statics.getDeviceSize(context).width)),
                    if (strType == 'VisheshVyakti') Text(sankalanItem["Remark"].toString()),
                    if (strType == 'VisheshVyakti') SizedBox(width: (0.05 * Statics.getDeviceSize(context).width)),
                    if (strType == 'VisheshVyakti') Text(sankalanItem["CreatedByName"].toString()),
                    if (strType == 'VisheshVyakti') SizedBox(width: (0.05 * Statics.getDeviceSize(context).width)),
                    SizedBox(
                      width: (0.05 * Statics.getDeviceSize(context).width),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                    text: TextSpan(
                  text: 'M: ${sankalanItem["MobileNumber"].toString()}',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      UrlLauncher.launch("tel://" + sankalanItem["MobileNumber"].toString());
                    },
                )),
              ],
            )),
      ),
    );
  }
}
