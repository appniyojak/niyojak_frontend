import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;

class Legend extends StatelessWidget {
  final legendString;
  final extraString;
  final double? fontsize;
  Legend({Key? key, this.legendString, this.extraString, this.fontsize}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            Text(
              (legendString == null || legendString == "" ? "" : Statics.getLabel(legendString)),
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.purple, fontSize: fontsize == 0 ? 18 : fontsize, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Divider(
          color: Colors.black,
        ),
        if (extraString != null && extraString != '')
          Wrap(
            children: [
              Text(
                extraString,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.purple, fontSize: fontsize == 0 ? 14 : fontsize! - 4, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
