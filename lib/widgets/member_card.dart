import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/static_data.dart' as Statics;

class SoochiMembersCard extends StatefulWidget {
  final memberItem;
  var onSaveDetails;
  var onCheckCard;
  var onUnCheckCard;
  var viewType;

  bool _isChecked;

  SoochiMembersCard(this.memberItem, this.onSaveDetails, this.onCheckCard, this.onUnCheckCard, this.viewType, this._isChecked);
  @override
  _SoochiMembersCardState createState() => _SoochiMembersCardState();
}

class _SoochiMembersCardState extends State<SoochiMembersCard> {
  void _deleteMember(var context, var soochiID, var soochiMemberID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({"SoochiID": soochiID, "SoochiMemberID": soochiMemberID, "ModifiedBy": Statics.userDetails["userID"]});
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteMember')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteSoochiMembers(inputData);
                  if (data == "Soochi Member Deleted Successfully ") {
                    Statics.showToast(Statics.getLabel('SoochiMemberDeletedSuccessfully'));

                    widget.onSaveDetails();
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteSoochiMember'));

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
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        title: Text(widget.memberItem["SwayamsevakFullName"]),

        leading: Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.purple,
            value: widget._isChecked,
            onChanged: (value) {
              setState(() {
                widget._isChecked = value!;
                if (value == true)
                  widget.onCheckCard(widget.memberItem["Email"], widget.memberItem["MobileNumber"]);
                else
                  widget.onUnCheckCard(widget.memberItem["Email"], widget.memberItem["MobileNumber"]);
              });
            }),
        trailing: widget.viewType != "ViewMembers"
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
                              _deleteMember(context, widget.memberItem["SoochiID"], widget.memberItem["SoochiMemberID"]);
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
                GestureDetector(
                    onTap:() {
                      _makePhoneCall(widget.memberItem["MobileNumber"]);
                    },
                    child: Text("${widget.memberItem["MobileNumber"]}",style: TextStyle(color: Colors.blueAccent),)),
                SizedBox(
                  height: 5,
                ),
                Text("${widget.memberItem["Email"] == ''? "N/A":widget.memberItem["Email"]}"),
                SizedBox(
                  height: 5,
                ),
                Wrap(
                  children: [
                    Text(widget.memberItem["DaayitvaGeoUnitName"]),
                    Text(widget.memberItem["DaayitvaLevelName"]),
                    Text(widget.memberItem["DaayitvaName"]),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
