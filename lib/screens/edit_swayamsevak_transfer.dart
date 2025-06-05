import 'package:flutter/material.dart';
import '../screens/swayamsevak_transfer_details.dart';

import '../helpers/static_data.dart' as Statics;

class EditSwayamsevakTransferScreen extends StatefulWidget {
  static const String routeName = '/edit-swayamsevak-transfer-screen';
  State<StatefulWidget> createState() {
    return new EditSwayamsevakTransferScreenState();
  }
}

class EditSwayamsevakTransferScreenState extends State<EditSwayamsevakTransferScreen> {
  Statics.ScreenArgumentsSwayamsevakTransfer? args;
  var theId;
  var swId;
  var viewType;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArgumentsSwayamsevakTransfer;
    theId = args!.swTransferID;
    swId = args!.swID;
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
        title: Text(Statics.getLabel('EditSwayamsevakTransferLabel')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SwayamsevakTransferDetails(
        swayamsevakTransferID: theId,
        swayamsevakID: swId,
        onSaveDetails: onSaveDetails,
        viewType: viewType,
      ),
    );
  }
}
