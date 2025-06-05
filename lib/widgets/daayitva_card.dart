import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/edit_daayitva.dart';
import '../screens/swayamsevak_daayitva_edit.dart';
import '../helpers/static_data.dart' as Statics;

class DaayitvaCard extends StatelessWidget {
  final _daayitvaItem;
  final String _viewType;
  final onSaveSwDetails;
  final swID;
  final getSwDetails;
  DaayitvaCard(this.swID, this._daayitvaItem, this._viewType, this.onSaveSwDetails, this.getSwDetails);

  void _deleteDaayitva(var context, var daayitvaID, var daayitvaFor) async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        var inputData = json.encode({
          "SwayamsevakDaayitvaID": ((daayitvaFor == 'SanghaPreritSansthaa' || daayitvaFor == 'OtherSocialOrganization') ? null : daayitvaID),
          "SwayamsevakOtherDaayitvaID": ((daayitvaFor == 'SanghaPreritSansthaa' || daayitvaFor == 'OtherSocialOrganization') ? daayitvaID : null),
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(Statics.getLabel('AskConfirmation')),
            content: Text(Statics.getLabel('AreyouSureYouWantToDeleteDaayitva')),
            actions: <Widget>[
              MaterialButton(
                child: Text(Statics.getLabel('ConfirmationYes')),
                onPressed: () async {
                  var data = await Statics.deleteSWDaayitva(inputData);
                  if (data.contains("Deleted Successfully")) {
                    Statics.showToast(Statics.getLabel('DaayitvaDeletedSuccessfully'));

                    this.getSwDetails(swID);
                  } else
                    Statics.showToast(Statics.getLabel('CouldnotDeleteDaayitva'));

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

  final List<Statics.MenuItem> menuItem = [];
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        dense: true,
        onTap: (){
          print("object");
        },
        title: Text(_daayitvaItem["StringValue"]),
        trailing: Container(
          height: 50,
          width: 0.1 * Statics.getDeviceSize(context).width,
          child: PopupMenuButton(
            onSelected: (value) {
              if (value == 'Delete') {
                _deleteDaayitva(context, _daayitvaItem["DaayitvaDataID"], _daayitvaItem["DaayitvaForCode"]);
              } else
                Navigator.of(context).pushNamed(EditDaayitva.routeName,
                    arguments: Statics.ScreenArguments2(swID, value, onSaveSwDetails, _daayitvaItem["DaayitvaForID"].toString(),
                        _daayitvaItem["DaayitvaForCode"], _daayitvaItem["DaayitvaDataID"].toString()));
            },
            icon: Icon(
              FontAwesomeIcons.ellipsisV,
              color: Colors.grey,
            ),
            itemBuilder: (BuildContext context) {
              return [
                if (_viewType == "EditMenu") Statics.MenuItem(Statics.getLabel('EditMenu'), FontAwesomeIcons.edit, 'EditMenu'),
                Statics.MenuItem(Statics.getLabel('ViewMenu'), FontAwesomeIcons.eye, 'ViewMenu'),
                if (_viewType == "EditMenu") Statics.MenuItem(Statics.getLabel('Delete'), Icons.delete, 'Delete')
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
        subtitle: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Wrap(
              spacing: 1,
              children: [
                Text('${_daayitvaItem["DaayitvaForCode"].toString()}, '),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
