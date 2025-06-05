import 'package:flutter/material.dart';
import '../screens/join_rss_details.dart';
import '../helpers/static_data.dart' as Statics;

class EditJoinRss extends StatefulWidget {
  static const String routeName = '/edit-joinrss-screen';
  @override
  _EditJoinRssState createState() => _EditJoinRssState();
}

class _EditJoinRssState extends State<EditJoinRss> {
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
      body: JoinRSSDetails(
        joinRSSID: theId.toString(),
        onSaveDetails: onSaveDetails,
        viewType: viewType,
      ),
    );
  }
}
