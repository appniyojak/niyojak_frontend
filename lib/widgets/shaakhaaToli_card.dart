import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../helpers/static_data.dart' as Statics;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ShaakhaaToliCard extends StatelessWidget {
  final toliItem;

  ShaakhaaToliCard(this.toliItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        title: Text(toliItem["FullName"]),
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
                    Text(toliItem["DaayitvaName"].toString()),
                    SizedBox(
                      width: (0.05 * Statics.getDeviceSize(context).width),
                    ),
                    Text(toliItem["StartYear"].toString()),
                    SizedBox(width: (0.05 * Statics.getDeviceSize(context).width)),
                    RichText(
                        text: TextSpan(
                      text: 'M: ${toliItem["MobileNumber"].toString()}',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          UrlLauncher.launch("tel://" + toliItem["MobileNumber"].toString());
                        },
                    )),
                    SizedBox(
                      width: (0.05 * Statics.getDeviceSize(context).width),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            )),
      ),
    );
  }
}
