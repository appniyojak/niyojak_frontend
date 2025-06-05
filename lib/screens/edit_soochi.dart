import 'package:flutter/material.dart';
import '../screens/soochi_members.dart';
import '../screens/soochi_sharing.dart';
import '../providers/bals.dart';

import '../helpers/static_data.dart' as Statics;
import './soochi_details.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditSoochiScreen extends StatefulWidget {
  static const String routeName = '/edit-soochi-screen';
  State<StatefulWidget> createState() {
    return new EditSoochiScreenState();
  }
}

class EditSoochiScreenState extends State<EditSoochiScreen> {
  Statics.ScreenArguments? args;
  var theId;
  var viewType;
  List<MenuChoices> choices = [];
  @override
  void initState() {
    super.initState();
    populateChoice();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments;
    theId = args!.itemID;
    viewType = args!.viewType;
  }

  void onSaveDetails(outputID) {
    setState(() {
      theId = outputID;
    });
  }

  void populateChoice() {
    setState(() {
      choices = [
        new MenuChoices("AddMembers", Icons.people, Statics.getLabel('AddMembers')),
        new MenuChoices("AddSharing", Icons.share, Statics.getLabel('AddSharing'))
      ];
    });
  }

  void onMenuSelected(MenuChoices choice) async {
    if (choice.menuType == "AddMembers") {
      Navigator.of(context).pushNamed(SoochiMembers.routeName, arguments: Statics.ScreenArguments(theId, "AddMembers"));
    } else if (choice.menuType == "AddSharing") {
      Navigator.of(context).pushNamed(SoochiSharing.routeName, arguments: Statics.ScreenArguments(theId, "AddSharing"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Statics.getLabel('EditSoochi')),
        actions: <Widget>[
          if (theId != "0" && viewType != "ViewMenu")
            PopupMenuButton<MenuChoices>(
              onSelected: onMenuSelected,
              icon: Icon(FontAwesomeIcons.ellipsisV),
              itemBuilder: (BuildContext context) {
                return choices.map((MenuChoices choice) {
                  return PopupMenuItem<MenuChoices>(
                    value: choice,
                    child: ListTile(leading: Icon(choice.icon), title: Text(choice.menuText!)),
                  );
                }).toList();
              },
            ),
        ],
      ),
      body: SoochiDetails(
        soochiId: theId.toString(),
        onSaveDetails: onSaveDetails,
        viewType: viewType,
      ),
    );
  }
}
