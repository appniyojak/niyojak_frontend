import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../swayamsevak_daayitva_list.dart';
import '../../../helpers/static_data.dart' as Statics;

class EditSwayamsevakDaayitva extends StatefulWidget {
  static const String routeName = '/edit-swayamsevak-daayitva-screen';

  State<StatefulWidget> createState() {
    return new EditSwayamsevakDaayitvaState();
  }
}

class EditSwayamsevakDaayitvaState extends State<EditSwayamsevakDaayitva> {
  Statics.ScreenArguments? args;
  var swID;
  var viewType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments;
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
      appBar: AppBar(
        title: Text(Statics.getLabel('EditSwayamsevak')),
      ),
      body: DaayitvaList(
        swId: swID,
        onSaveSwDetails: onSaveDetails,
        viewType: viewType,
      ),
    );
  }
}
