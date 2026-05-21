import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/static_data.dart' as Statics;
import '../../../utils/globals.dart';
import '../../../utils/stable_geounit_class.dart';

class ShakhaaSaptahReportTab extends StatefulWidget {
  const ShakhaaSaptahReportTab({super.key});

  @override
  State<ShakhaaSaptahReportTab> createState() => _ShakhaaSaptahReportTabState();
}

class _ShakhaaSaptahReportTabState extends State<ShakhaaSaptahReportTab> {
  bool isShakhaaSelected = true;
  bool _isExpanded = true;

  _getData(bool isDaily, {bool isStart = false}) async {
    // await _setData();
    if (!isStart) isShakhaaSelected = isDaily;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dm = await MyAppGlobals.getLevelLDB();

      final controller = context.read<GeoHierarchyController>();

      await controller.initialize(dm);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
        child: Column(
          spacing: 12,
          children: [
            _typeTab(),
            vastiGraamDropdown(),
          ],
        ),
      ),
    );
  }

  Widget vastiGraamDropdown() {
    return Consumer<GeoHierarchyController>(builder: (_, ctrl, __) {
      return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            isExpanded: _isExpanded,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(Statics.getLabel('Filters')),
              );
            },
            body: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  GeoDropdownWidget(
                    level: GeoLevel.mahaanagar,
                    title: 'Mahaanagar',
                    controller: ctrl,
                  ),

                  // if (ctrl.hasItems(GeoLevel.vibhaag))
                  GeoDropdownWidget(
                    level: GeoLevel.vibhaag,
                    title: 'Vibhaag',
                    controller: ctrl,
                  ),

                  if (ctrl.hasItems(GeoLevel.bhaag))
                    GeoDropdownWidget(
                      level: GeoLevel.bhaag,
                      title: 'Bhaag',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.nagar))
                    GeoDropdownWidget(
                      level: GeoLevel.nagar,
                      title: 'Nagar',
                      controller: ctrl,
                    ),

                  ////////////////////////////////////////
                  /// CONDITIONAL

                  if (ctrl.hasItems(GeoLevel.upnagar))
                    GeoDropdownWidget(
                      level: GeoLevel.upnagar,
                      title: 'upnagarUpkhanda',
                      controller: ctrl,
                    ),

                  ////////////////////////////////////////

                  if (ctrl.hasItems(GeoLevel.mandal))
                    GeoDropdownWidget(
                      level: GeoLevel.mandal,
                      title: 'Mandal',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.graam))
                    GeoDropdownWidget(
                      level: GeoLevel.graam,
                      title: 'Graam',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.vasti))
                    GeoDropdownWidget(
                      level: GeoLevel.vasti,
                      title: 'Vasti',
                      controller: ctrl,
                    ),

                  if (ctrl.hasItems(GeoLevel.shakhaa))
                    GeoDropdownWidget(
                      level: GeoLevel.shakhaa,
                      title: 'Shaakhaa',
                      controller: ctrl,
                    ),

                  SizedBox(height: 12),
                  if (isShakhaaSelected)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (ctrl.deepestSelectedLevelId == 1)
                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                            onPressed: () {
                              final trail = ctrl.hierarchyTrail;

                              print(trail.toJson());
                              print(ctrl.deepestSelectedLevelId);
                              // _search("Search", context);
                            },
                            child: Text(
                              Statics.getLabel('Search'),
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        MaterialButton(
                            onPressed: () {
                              print("clear button pressed");
                              ctrl.loadHierarchyForUser();
                            },
                            child: Text(Statics.getLabel('clear'))),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                          onPressed: () {
                            // _search("Search", context);
                          },
                          child: Text(
                            Statics.getLabel('Search'),
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        MaterialButton(
                            onPressed: () {
                              print("clear button pressed");
                              ctrl.loadHierarchyForUser();
                            },
                            child: Text(Statics.getLabel('clear'))),
                      ],
                    )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _typeTab() {
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 6),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: MediaQuery.sizeOf(context).width,
      height: 40,
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: !isShakhaaSelected ? (MediaQuery.sizeOf(context).width * 0.47) : 8,
            child: Container(
              width: (MediaQuery.sizeOf(context).width * 0.47 - 12),
              height: 36,
              decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(12)),
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _getData(true),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                    child: Text("Shakhaa Only", style: TextStyle(color: isShakhaaSelected ? Colors.white : Colors.black)),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => _getData(false),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                    child: Text("Level Wise", style: TextStyle(color: isShakhaaSelected ? Colors.black : Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
