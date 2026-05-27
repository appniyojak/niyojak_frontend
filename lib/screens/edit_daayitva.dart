import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;
import 'swayamsevak_module/swayamsevak_daayitva_edit.dart';

class EditDaayitva extends StatefulWidget {
  static const routeName = '/edit-daayitva-screen';

  @override
  _EditDaayitvaState createState() => _EditDaayitvaState();
}

class _EditDaayitvaState extends State<EditDaayitva> {
  Statics.ScreenArguments2? args;
  var theId;
  var viewType;
  var onSaveDetails;
  var daayitvaForID;
  var daayitvaForCode;
  var dataID;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments2;
    theId = args?.swayamsevakID;
    viewType = args?.viewType;
    onSaveDetails = args?.onSaveDetails;
    daayitvaForID = args?.daayitvaForID;
    daayitvaForCode = args?.daayitvaForCode;
    dataID = args?.dataID;

    print("daayitvaForCode daayitvaForCode :----$daayitvaForCode");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Statics.getLabel('Daayitva')),
      ),
      body: SwayamSevakDaayitvaEdit(
        swId: theId,
        onSaveSwDetails: onSaveDetails,
        viewType: viewType,
        daayitvaForCode: daayitvaForCode,
        daayitvaForID: daayitvaForID,
        dataID: dataID,
      ),
    );
  }
}
