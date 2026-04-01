import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../widgets/legend.dart';
import '../../widgets/titlebar.dart';
import '../../helpers/static_data.dart' as Statics;

class SwayamSevakLinkedSooochi extends StatefulWidget {
  var swId;
  var onSaveSwDetails;
  var viewType;

  SwayamSevakLinkedSooochi({Key? key, this.swId, this.onSaveSwDetails, this.viewType}) : super(key: key);

  @override
  _SwayamSevakLinkedSooochiState createState() => _SwayamSevakLinkedSooochiState();
}

class _SwayamSevakLinkedSooochiState extends State<SwayamSevakLinkedSooochi> {
  List<DataColumn>? _memberIncolumns;
  List<DataRow>? _memberInrows;

  List<DataColumn>? _sharedcolumns;
  List<DataRow>? _sharedrows;

  bool _isfetingData = false;

  @override
  void initState() {
    super.initState();
    populateDetails();
  }

  void populateDetails() async {
    setState(() {
      _isfetingData = true;
    });
    var membersData = await Statics.getSwayamSevakMembersInSoochi(widget.swId);

    var data = membersData == null ? null : membersData["TaggedSoochi"];
    var data1 = membersData == null ? null : membersData["SharedSoochi"];
    if (data != null && data.length > 0) {
      await getMembersColumnsandRows(data);
    } else {
      if (!mounted) return;
      setState(() {
        _memberIncolumns = null;
      });
    }

    if (data1 != null && data1.length > 0) {
      await getSharedColumnsandRows(data1);
    } else {
      if (!mounted) return;
      setState(() {
        _sharedcolumns = null;
      });
    }
    setState(() {
      _isfetingData = false;
    });
  }

  getMembersColumnsandRows(List<dynamic> dataList) async {
    List<DataColumn> cols = [];

    cols.add(new DataColumn(label: Text(Statics.getLabel('SoochiName'))));

    List<DataRow> row = [];
    for (var data in dataList) {
      List<DataCell> cells = [];
      cells.add(new DataCell(Container(width: Statics.getDeviceSize(context).width * 0.8, child: Text(data["SoochiName"].toString()))));

      row.add(new DataRow(cells: cells));
    }
    if (!mounted) return;
    setState(() {
      _memberIncolumns = cols;
      _memberInrows = row;
    });
  }

  getSharedColumnsandRows(List<dynamic> dataList) async {
    List<DataColumn> cols = [];

    cols.add(new DataColumn(label: Text(Statics.getLabel('SoochiName'))));
    cols.add(new DataColumn(label: Text(Statics.getLabel('CanEdit'))));

    List<DataRow> row = [];
    for (var data in dataList) {
      List<DataCell> cells = [];
      cells.add(new DataCell(Container(width: Statics.getDeviceSize(context).width * 0.4, child: Text(data["SoochiName"].toString()))));
      cells.add(new DataCell(Container(
          width: Statics.getDeviceSize(context).width * 0.4,
          child: data["CanEdit"] == true ? Icon(FontAwesomeIcons.check, color: Colors.purple) : Icon(FontAwesomeIcons.times, color: Colors.purple))));

      row.add(new DataRow(cells: cells));
    }
    if (!mounted) return;
    setState(() {
      _sharedcolumns = cols;
      _sharedrows = row;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: Column(
              children: [
                TitleBar(legendString: 'searchSoochiScreenLabel', fontsize: 18),
                SizedBox(
                  height: 20,
                ),
                Legend(legendString: 'MemberIn', fontsize: 15),
                Container(
                  height: Statics.getDeviceSize(context).height * 0.2,
                  width: Statics.getDeviceSize(context).width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DataTable(
                            columnSpacing: 20,
                            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                            columns: _memberIncolumns == null ? <DataColumn>[DataColumn(label: Text("No Data Found"))] : _memberIncolumns!,
                            rows: _memberInrows == null ? <DataRow>[] : _memberInrows!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Legend(legendString: 'SharedSoochis', fontsize: 15),
                Container(
                  height: Statics.getDeviceSize(context).height * 0.2,
                  width: Statics.getDeviceSize(context).width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DataTable(
                            columnSpacing: 20,
                            headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                            columns: _sharedcolumns == null ? <DataColumn>[DataColumn(label: Text("No Data Found"))] : _sharedcolumns!,
                            rows: _sharedrows == null ? <DataRow>[] : _sharedrows!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        inAsyncCall: _isfetingData);
  }
}
