import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niyojak_prod/screens/search_swayamsewak_soochi.dart';

import '../screens/swayamsevak_basic_info.dart';
import '../helpers/static_data.dart' as Statics;

class EditSwayamsevakSoochiInfo extends StatefulWidget {
  static const String routeName = '/edit-swayamsevak-soochi-screen';
  State<StatefulWidget> createState() {
    return new EditSwayamsevakSoochiInfoState();
  }
}

class EditSwayamsevakSoochiInfoState extends State<EditSwayamsevakSoochiInfo> {
  Statics.ScreenArgumentsForSoochi? args;
  var swID;
  var viewType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArgumentsForSoochi;
    swID = args!.itemID;
    viewType = args!.viewType;
  }

  void onSaveDetails(outputID) {
    setState(() {
      swID = outputID;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchSwayamsewakSoochiScreen(
        swId: swID.toString(),
        onSaveSwDetails: onSaveDetails,
        viewType: viewType,
      ),
    );
  }
}
