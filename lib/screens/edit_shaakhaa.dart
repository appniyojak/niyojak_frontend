import 'package:flutter/material.dart';
import '../screens/shaakhaa_details.dart';

import '../helpers/static_data.dart' as Statics;

class EditShaakhaaScreen extends StatefulWidget {
  static const String routeName = '/edit-shaakhaa-screen';
  State<StatefulWidget> createState() {
    return new EditShaakhaaScreenState();
  }
}

class EditShaakhaaScreenState extends State<EditShaakhaaScreen> {
  Statics.ScreenArguments? args;
  var theId;
  var viewType;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Statics.getLabel('EditShaakhaa')),
      ),
      body: ShaakhaaDetails(
        shaakhaaId: theId.toString(),
        onSaveDetails: onSaveDetails,
        viewType: viewType,
      ),
    );
  }
}
