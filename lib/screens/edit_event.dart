import 'package:flutter/material.dart';
import '../screens/event_details.dart';

import '../helpers/static_data.dart' as Statics;

class EditEvent extends StatefulWidget {
  static const routeName = '/edit-event-screen';
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  Statics.ScreenArguments? args;
  int? theId;
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
        title: Text(Statics.getLabel('EventDetails')),
      ),
      body: EventDetails(
        eventId: theId,
        onSaveDetails: onSaveDetails,
        viewType: viewType,
      ),
    );
  }
}
