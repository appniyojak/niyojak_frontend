import 'dart:convert';

import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;

class EventMembersCard extends StatefulWidget {
  final memberItem;
  var onSaveDetails;
  var onCheckCard;
  var onUnCheckCard;
  var viewType;
  var isSharing;

  bool _isChecked;

  EventMembersCard(this.memberItem, this.onSaveDetails, this.onCheckCard, this.onUnCheckCard, this.viewType, this.isSharing, this._isChecked);
  @override
  _EventMembersCardState createState() => _EventMembersCardState();
}

class _EventMembersCardState extends State<EventMembersCard> {
  void _deleteMember(var context, var eventID, var swayamsevakID, bool isSharing) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({
          "EventID": eventID,
          "SwayamsevakID": swayamsevakID,
          "ApekshitOrSharing": isSharing == true ? "Sharing" : "Apekshit",
          "ModifiedBy": Statics.userDetails["userID"]
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteMember')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteEventMembers(inputData);
                  if (data == "Event Apekshit/Sharing Deleted Successfully ") {
                    Statics.showToast(Statics.getLabel('MemberDeletedSuccessfully'));

                    widget.onSaveDetails();
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteMember'));

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
        title: Text(widget.memberItem["SwayamsevakName"]),
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
        trailing: (widget.viewType != "ViewApekshitList" && widget.viewType != "ViewSharingList")
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
                              _deleteMember(context, widget.memberItem["EventID"], widget.memberItem["SwayamsevakID"], widget.isSharing);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Text(""),
      ),
    );
  }
}
