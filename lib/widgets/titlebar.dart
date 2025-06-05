import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;

class TitleBar extends StatelessWidget {
  var legendString;
  var extraString;
  double? fontsize = 0;
  TitleBar({
    Key? key,
    this.legendString,
    this.extraString,
    this.fontsize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.all(5),
      height: 30,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.purple),
      child: Center(
          child: Text(
        (legendString == null || legendString == "" ? "" : Statics.getLabel(legendString)) +
            (extraString == null || extraString == "" ? "" : (legendString == null || legendString == "" ? "" : " - ") + extraString),
        style: TextStyle(fontSize: fontsize == 0 ? 20 : fontsize, fontWeight: FontWeight.w600, color: Colors.white),
      )),
    );
  }
}
