import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/swayamsevak_module/edit_module/edit_swayamsevak_transfer.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../helpers/static_data.dart' as Statics;

class SwayamsevakTransferCard extends StatefulWidget {
  final swTransferItem;
  var onCheckCard;
  var onUnCheckCard;
  bool _isChecked;
  var refreshList;

  SwayamsevakTransferCard(this.swTransferItem, this.onCheckCard, this.onUnCheckCard, this._isChecked, this.refreshList);

  @override
  _SwayamsevakTransferCardState createState() => _SwayamsevakTransferCardState();
}

class _SwayamsevakTransferCardState extends State<SwayamsevakTransferCard> {
  void _deleteSwayamsevakTransfer(var context, var swayamsevakTransferID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSwayamsevakTransfer')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteSwayamsevakTransferForApp(json.encode({"SwayamsevakTransferID": swayamsevakTransferID}));
                  if (data.contains("Deleted Successfully")) {
                    Statics.showToast(Statics.getLabel('SwayamsevakTransferDeletedSuccessfully'));
                    widget.refreshList();
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteSwayamsevakTransfer'));

                  Navigator.of(ctx).pop();
                },
              ),
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationNo')),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.swTransferItem["StatusCode"] == "Initiated"
        ? Card(
            margin: EdgeInsets.all(5),
            elevation: 5,
            child: ListTile(
              title: Text(widget.swTransferItem["FullName"]),
              leading: Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.purple,
                  value: widget._isChecked == null ? false : widget._isChecked,
                  onChanged: (value) {
                    setState(() {
                      widget._isChecked = value!;
                      if (value == true)
                        widget.onCheckCard(widget.swTransferItem["Email"], widget.swTransferItem["MobileNumber"]);
                      else
                        widget.onUnCheckCard(widget.swTransferItem["Email"], widget.swTransferItem["MobileNumber"]);
                    });
                  }),
              trailing: Container(
                height: 50,
                width: 0.1 * Statics.getDeviceSize(context).width,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0.0,
                      top: 0.0,
                      child: PopupMenuButton(
                        onSelected: (value) {
                          if (value == "Delete") {
                            _deleteSwayamsevakTransfer(context, widget.swTransferItem["SwayamsevakTransferID"].toString());
                          } else {
                            Navigator.of(context).pushNamed(EditSwayamsevakTransferScreen.routeName,
                                arguments: Statics.ScreenArgumentsSwayamsevakTransfer(widget.swTransferItem["SwayamsevakTransferID"].toString(), '0', value));
                          }
                        },
                        icon: Icon(
                          FontAwesomeIcons.ellipsisV,
                          color: Colors.grey,
                        ),
                        itemBuilder: (BuildContext context) {
                          return [
                            Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
                            Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
                            Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
                          ].map((Statics.MenuItem menuItem) {
                            return PopupMenuItem(
                              //value: menuItem.menuVal,
                              value: menuItem.menuKey,
                              child: ListTile(
                                leading: Icon(
                                  menuItem.iconVal,
                                  color: Colors.purple,
                                ),
                                title: Text(menuItem.menuVal),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  if (widget.swTransferItem["SourceBhaagName"].toString().isNotEmpty)
                    Wrap(
                      spacing: 1,
                      children: [
                        Text('From:' + widget.swTransferItem["SourceBhaagName"]),
                        Text(', To:' + widget.swTransferItem["DestinationBhaagName"]),
                        Text(', Initiated On:' + widget.swTransferItem["TransferInitiatedDateStr"]),
                        Text(', Status:' + widget.swTransferItem["StatusCode"]),
                      ],
                    ),
                  SizedBox(
                    height: 5,
                  ),
                  Wrap(spacing: 2, children: [
                    RichText(
                        text: TextSpan(
                      text: 'M: ${widget.swTransferItem["MobileNumber"].toString()}${widget.swTransferItem["Email"].toString().isNotEmpty ? ',' : ''}',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          UrlLauncher.launch("tel://" + widget.swTransferItem["MobileNumber"].toString());
                        },
                    )),
                    if (widget.swTransferItem['Email'].toString().isNotEmpty)
                      RichText(
                        text: TextSpan(
                            text: 'E: ${widget.swTransferItem["Email"].toString()}',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                UrlLauncher.launch("mailto:" + widget.swTransferItem["Email"].toString());
                              }),
                      )
                  ])
                ],
              )),
            ),
          )
        : Container();
  }
}
