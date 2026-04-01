import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../swayamsevak_basic_info.dart';
import '../../../helpers/static_data.dart' as Statics;

class EditSwayamsevakBasicInfo extends StatefulWidget {
  static const String routeName = '/edit-swayamsevak-basic-info-screen';

  State<StatefulWidget> createState() {
    return new EditSwayamsevakBasicInfoState();
  }
}

class EditSwayamsevakBasicInfoState extends State<EditSwayamsevakBasicInfo> {
  Statics.ScreenArgumentsNew? args;
  var swID;
  var viewType;

  String? name;
  String? email;
  String? mobile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArgumentsNew;
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
      body: SwayamsevakBasicInfo(
        swId: swID,
        onSaveSwDetails: onSaveDetails,
        viewType: viewType,
        preFilledName: name,
        preFilledEmail: email,
        preFilledMobile: mobile,
      ),
      // SwayamsevakBasicInfo(
      //   swId: swID,
      //   onSaveSwDetails: onSaveDetails,
      //   viewType: viewType,
      // ),
    );
  }
}
