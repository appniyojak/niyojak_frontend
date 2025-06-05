import 'package:flutter/material.dart';
import '../helpers/static_data.dart' as Statics;

class TwoColumnRow extends StatelessWidget {
  var txtString;
  var txtString2;
  var value;
  var value2;
  double? fontsize = 0;

  TwoColumnRow({
    Key? key,
    this.txtString,
    this.value,
    this.txtString2,
    this.value2,
    this.fontsize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: Statics.getDeviceSize(context).width * 0.37,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(txtString, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
                  ),
                  Text(value == "null"?"0":value, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
                ],
              ),
              Center(
                child: Container(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: Statics.getDeviceSize(context).width * 0.37,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(txtString2, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
                  Text(value2 == "null"?"0":value2, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
                ],
              ),
              Center(
                child: Container(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NewThreeColumnRow extends StatelessWidget {
  var txtString;
  var txtString2;
  var txtString3;
  var value;
  var value2;
  var value3;
  double? fontsize = 0;

  NewThreeColumnRow({
    Key? key,
    this.txtString,
    this.value,
    this.txtString2,
    this.txtString3,
    this.value2,
    this.value3,
    this.fontsize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: Statics.getDeviceSize(context).width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value == "null"?"0":value, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          width: Statics.getDeviceSize(context).width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString2, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value2 == "null"?"0":value2, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          width: Statics.getDeviceSize(context).width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString3, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value3 == "null"?"0":value3, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

class NewFourColumnRow extends StatelessWidget {
  var txtString;
  var txtString2;
  var txtString3;
  var txtString4;
  var value;
  var value2;
  var value3;
  var value4;
  double? fontsize = 0;

  NewFourColumnRow({
    Key? key,
    this.txtString,
    this.value,
    this.txtString2,
    this.txtString3,
    this.txtString4,
    this.value2,
    this.value3,
    this.value4,
    this.fontsize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          alignment: Alignment.centerRight,
          width: Statics.getDeviceSize(context).width * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value == "null"?"0":value, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          width: Statics.getDeviceSize(context).width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString2, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value2 == "null"?"0":value2, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          width: Statics.getDeviceSize(context).width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString3, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value3 == "null"?"0":value3, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(right: 5),
          width: Statics.getDeviceSize(context).width * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString4, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value4 == "null"?"0":value4, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

class NewFiveColumnRow extends StatelessWidget {
  var txtString;
  var txtString2;
  var txtString3;
  var txtString4;
  var txtString5;
  var value;
  var value2;
  var value3;
  var value4;
  var value5;
  double? fontsize = 0;

  NewFiveColumnRow({
    Key? key,
    this.txtString,
    this.value,
    this.txtString2,
    this.txtString3,
    this.txtString4,
    this.txtString5,
    this.value2,
    this.value3,
    this.value4,
    this.value5,
    this.fontsize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          alignment: Alignment.centerRight,
          width: Statics.getDeviceSize(context).width * 0.12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value == "null"?"0":value, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          width: Statics.getDeviceSize(context).width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString2, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value2 == "null"?"0":value2, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          width: Statics.getDeviceSize(context).width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString3, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value3 == "null"?"0":value3, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(right: 5),
          width: Statics.getDeviceSize(context).width * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString4, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value4 == "null"?"0":value4, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(right: 5),
          width: Statics.getDeviceSize(context).width * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(txtString5, textAlign: TextAlign.center, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w500)),
              Text(value5 == "null"?"0":value5, style: TextStyle(fontSize: fontsize, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
