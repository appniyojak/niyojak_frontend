import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/static_data.dart' as Statics;

class SingleColumnRow extends StatelessWidget {
  var txtString;
  var value;
  double? fontsize;
  Color? rowColor;
  Color? dividerColor;
  FontWeight? fontWeight;
  bool? view;
  VoidCallback? btnAction;
  Widget? subChild;
  bool showDivider;
  bool showTitle;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? subChildPadding;
  EdgeInsetsGeometry? subChildMargin;

  SingleColumnRow({
    Key? key,
    this.txtString,
    this.value,
    this.fontsize,
    this.fontWeight,
    this.view,
    this.rowColor,
    this.dividerColor,
    this.btnAction,
    this.subChild,
    this.showDivider = true,
    this.showTitle = true,
    this.padding,
    this.subChildPadding,
    this.subChildMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (txtString != null)
          Container(
            decoration: BoxDecoration(color: rowColor),
            padding: padding ?? EdgeInsets.symmetric(vertical: 8),
            // color: Colors.red,
            child: Center(
              child: SizedBox(
                width: Statics.getDeviceSize(context).width * 0.84,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(txtString, style: TextStyle(fontSize: fontsize, fontWeight: fontWeight ?? FontWeight.w500)),
                    ),
                    view == true
                        ? IconButton(
                            onPressed: btnAction,
                            icon: Icon(
                              FontAwesomeIcons.list,
                              color: Colors.purpleAccent,
                              size: 20,
                            ))
                        : Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(value == "null" || value == null ? "0" : value.toString(), style: TextStyle(fontSize: fontsize, fontWeight: fontWeight ?? FontWeight.w600)),
                          ),
                  ],
                ),
              ),
            ),
          ),
        if (subChild != null)
          Container(
            padding: subChildPadding ?? EdgeInsets.only(top: 2, bottom: 6),
            margin: subChildMargin ?? EdgeInsets.only(left: 16, right: 8),
            // color: Colors.red,
            child: Center(
              child: SizedBox(
                width: Statics.getDeviceSize(context).width,
                child: subChild,
              ),
            ),
          ),
        Center(
          child: Container(
            width: Statics.getDeviceSize(context).width,
            child: Divider(
              height: 1,
              color: dividerColor ?? Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class SingleColumnRowLegend extends StatelessWidget {
  var txtString;
  var value;
  double? fontsize = 0;
  bool? view;
  VoidCallback? btnAction;

  SingleColumnRowLegend({
    Key? key,
    this.txtString,
    this.value,
    this.fontsize,
    this.view,
    this.btnAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: Statics.getDeviceSize(context).width * 0.84,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    txtString,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.purple, fontSize: fontsize == 0 ? 18 : fontsize, fontWeight: FontWeight.w600),
                  ),
                ),
                view == true
                    ? IconButton(
                        onPressed: btnAction,
                        icon: Icon(
                          FontAwesomeIcons.list,
                          color: Colors.purpleAccent,
                          size: 20,
                        ))
                    : Flexible(
                        child: Text(value == "null" || value == null ? "0" : value, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
                      ),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            width: Statics.getDeviceSize(context).width,
            child: Divider(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class Single1ColumnRow extends StatelessWidget {
  var txtString;
  var value;
  double? fontsize = 0;
  int? valFlex;
  EdgeInsets? padding;
  Single1ColumnRow({
    Key? key,
    this.txtString,
    this.value,
    this.fontsize,
    this.valFlex,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: Statics.getDeviceSize(context).width * 0.84,
            padding: padding ?? EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(txtString, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
                ),
                Flexible(
                  flex: valFlex ?? 1,
                  child: Text(value == "null" ? "0" : value, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            width: Statics.getDeviceSize(context).width,
            child: Divider(
              color: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }
}

class Single1ColumnRowIcon extends StatelessWidget {
  var txtString;
  var value;
  double? fontsize = 0;

  Single1ColumnRowIcon({
    Key? key,
    this.txtString,
    this.value,
    this.fontsize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: Statics.getDeviceSize(context).width * 0.84,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(txtString, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
                ),
                Icon(value == "null" ? "0" : value, color: Colors.purple),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            width: Statics.getDeviceSize(context).width * 0.84,
            child: Divider(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
