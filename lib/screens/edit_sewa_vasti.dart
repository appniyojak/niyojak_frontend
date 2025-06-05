import 'package:flutter/material.dart';
import '../screens/sewa_vasti_details.dart';

import '../helpers/static_data.dart' as Statics;

class EditSewaVasti extends StatefulWidget {
  static const String routeName = '/edit-sewavasti-screen';
  @override
  _EditSewaVastiState createState() => _EditSewaVastiState();
}

class _EditSewaVastiState extends State<EditSewaVasti> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  //var _isLoading = false;
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
        title: Text(Statics.getLabel('EditDetails')),
      ),
      body: SewaVastiDetails(
        sewaVastiID: theId.toString(),
        onSaveDetails: onSaveDetails,
        viewType: viewType,
      ),
    );
  }
}
