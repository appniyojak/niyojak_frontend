import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/soochi_members.dart';
import '../screens/soochi_sharing.dart';

import '../helpers/static_data.dart' as Statics;
import '../screens/edit_soochi.dart';

class SocchiCard extends StatelessWidget {
  final soochiItem;
  final serahcDetails;

  SocchiCard(this.soochiItem, this.serahcDetails);

  void _deleteSoochi(var context, var soochiID) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({"SoochiID": soochiID, "ModifiedBy": Statics.userDetails["userID"]});
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteSoochi')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteSoochiForApp(inputData);
                  if (data == "Soochi Deleted Successfully ") {
                    Statics.showToast(Statics.getLabel('SoochiDeletedSuccessfully'));
                    serahcDetails();
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteSoochi'));

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
        title: Text(
            soochiItem["SoochiName"] + (soochiItem["SoochiMemberCount"] == null ? '' : (' (' + soochiItem["SoochiMemberCount"].toString() + ')'))),
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
                    if (value == "AddMembers" || value == "ViewMembers") {
                      Navigator.of(context)
                          .pushNamed(SoochiMembers.routeName, arguments: Statics.ScreenArguments(soochiItem["SoochiID"], value));
                    } else if (value == "AddSharing" || value == "ViewSharing") {

                      Navigator.of(context)
                          .pushNamed(SoochiSharing.routeName, arguments: Statics.ScreenArguments(soochiItem["SoochiID"], value));
                    } else if (value == "Delete") {
                      _deleteSoochi(context, soochiItem["SoochiID"].toString());
                    } else
                      Navigator.of(context)
                          .pushNamed(EditSoochiScreen.routeName, arguments: Statics.ScreenArguments(soochiItem["SoochiID"], value));
                  },
                  icon: Icon(
                    FontAwesomeIcons.ellipsisV,
                    color: Colors.grey,
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      if (soochiItem["AppUserCanEdit"] == true) Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
                      Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
                      if (soochiItem["AppUserCanEdit"] == true) Statics.MenuItem(Statics.getLabel('AddMembers'), Icons.people, 'AddMembers'),
                      if (soochiItem["AppUserIsOwner"] == true) Statics.MenuItem(Statics.getLabel('AddSharing'), Icons.share, 'AddSharing'),
                      if (soochiItem["AppUserCanEdit"] == true) Statics.MenuItem(Statics.getLabel('ViewMembers'), Icons.people, 'ViewMembers'),
                      if (soochiItem["AppUserCanEdit"] == false) Statics.MenuItem(Statics.getLabel('ViewSharing'), Icons.share, 'ViewSharing'),
                      if (soochiItem["AppUserIsOwner"] == true) Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete'),
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
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(soochiItem["OwnerSwayamsevakFullName"]),
                SizedBox(
                  height: 5,
                ),
                Text(soochiItem["Remark"]),
              ],
            )),
      ),
    );
  }
}
