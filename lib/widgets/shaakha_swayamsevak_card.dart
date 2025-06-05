import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../helpers/static_data.dart' as Statics;

class ShaakhaaSwayamSevakCard extends StatefulWidget {
  final swItem;
  var onCheckCard;
  var onUnCheckCard;
  var isSelected;
  ShaakhaaSwayamSevakCard(this.swItem, this.onCheckCard, this.onUnCheckCard, this.isSelected);
  @override
  _ShaakhaaSwayamSevakCardState createState() => _ShaakhaaSwayamSevakCardState();
}

class _ShaakhaaSwayamSevakCardState extends State<ShaakhaaSwayamSevakCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        title: Text(widget.swItem["FullName"]),
        leading: Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.purple,
            value: widget.isSelected == null ? false : widget.isSelected,
            onChanged: (value) {
              setState(() {
                widget.isSelected = value;
                if (value == true)
                  widget.onCheckCard(widget.swItem["Email"], widget.swItem["MobileNumber"]);
                else
                  widget.onUnCheckCard(widget.swItem["Email"], widget.swItem["MobileNumber"]);
              });
            }),
        subtitle: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            if (widget.swItem["LinkedGeoUnitName"].toString().isNotEmpty)
              Wrap(
                spacing: 1,
                children: [
                  Text(widget.swItem["LinkedGeoUnitName"]),
                ],
              ),
            SizedBox(
              height: 5,
            ),
            Wrap(spacing: 2, children: [
              RichText(
                  text: TextSpan(
                text: 'M: ${widget.swItem["MobileNumber"].toString()}${widget.swItem["Email"].toString().isNotEmpty ? ',' : ''}',
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    UrlLauncher.launch("tel://" + widget.swItem["MobileNumber"].toString());
                  },
              )),
              if (widget.swItem['Email'].toString().isNotEmpty)
                RichText(
                  text: TextSpan(
                      text: 'E: ${widget.swItem["Email"].toString()}',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          UrlLauncher.launch("mailto:" + widget.swItem["Email"].toString());
                        }),
                )
            ])
          ],
        )),
      ),
    );
  }
}
