import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../swayamsevak_other_info.dart';
import '../../../helpers/static_data.dart' as Statics;

class EditSwayamsevakOtherInfo extends StatefulWidget {
  static const String routeName = '/edit-swayamsevak-other-info-screen';

  State<StatefulWidget> createState() {
    return new EditSwayamsevakOtherInfoState();
  }
}

class EditSwayamsevakOtherInfoState extends State<EditSwayamsevakOtherInfo> {
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
      body: SwayamsevakOtherInfo(
        swId: swID,
        onSaveSwDetails: onSaveDetails,
        viewType: viewType,
      ),
    );
  }
}
