import 'package:flutter/material.dart';
import 'dart:convert';

import '../helpers/static_data.dart' as Statics;

class SoochiSharingCard extends StatefulWidget {
  final sharingItem;
  var onSaveDetails;
  var onCheckCard;
  var onUnCheckCard;
  var viewType;
  bool _isChecked;
  SoochiSharingCard(this.sharingItem, this.onSaveDetails, this.onCheckCard, this.onUnCheckCard, this.viewType, this._isChecked);
  @override
  _SoochiSharingCardState createState() => _SoochiSharingCardState();
}

class _SoochiSharingCardState extends State<SoochiSharingCard> {
  void _deleteSharing(var context, var soochiID, var soochiSharingID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({"SoochiID": soochiID, "SoochiSharingID": soochiSharingID, "ModifiedBy": Statics.userDetails["userID"]});
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSharing')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteSoochiSharing(inputData);
                  if (data == "Soochi Sharing Deleted Successfully ") {
                    Statics.showToast(Statics.getLabel('SoochiSharingDeletedSuccessfully'));

                    widget.onSaveDetails();
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteSoochiSharing'));

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
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        title: Text(widget.sharingItem["SwayamsevakFullName"]),
        leading: Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.purple,
            value: widget._isChecked == null ? false : widget._isChecked,
            onChanged: (value) {
              setState(() {
                widget._isChecked = value!;
                if (value == true)
                  widget.onCheckCard(widget.sharingItem["Email"], widget.sharingItem["MobileNumber"]);
                else
                  widget.onUnCheckCard(widget.sharingItem["Email"], widget.sharingItem["MobileNumber"]);
              });
            }),
        trailing: widget.viewType != "ViewSharing"
            ? Container(
                height: 50,
                width: 0.1 * Statics.getDeviceSize(context).width,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0.0,
                      top: 0.0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteSharing(context, widget.sharingItem["SoochiID"], widget.sharingItem["SoochiSharingID"]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Text(""),
        subtitle: Container(
            width: 0.75 * Statics.getDeviceSize(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Wrap(
                  children: [
                    Text(widget.sharingItem["DaayitvaGeoUnitName"]),
                    Text(widget.sharingItem["DaayitvaLevelName"]),
                    Text(widget.sharingItem["DaayitvaName"]),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
