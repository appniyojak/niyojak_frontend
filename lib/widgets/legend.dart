import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;

class Legend extends StatelessWidget {
  final legendString;
  final extraString;
  final double? fontsize;
  final void Function()? onPressed;
  final IconData? icon;

  Legend({Key? key, this.legendString, this.extraString, this.fontsize, this.onPressed, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // mainAxisAlignment: onPressed == null ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          children: [
            if (onPressed != null) SizedBox(width: 24),
            Expanded(
              child: Text(
                (legendString == null || legendString == "" ? "" : Statics.getLabel(legendString, returnKey: true)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple, fontSize: fontsize == 0 ? 18 : fontsize, fontWeight: FontWeight.w600),
              ),
            ),
            if (onPressed != null) IconButton(onPressed: onPressed, icon: Icon(icon ?? Icons.list_rounded, color: Colors.purple))
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
