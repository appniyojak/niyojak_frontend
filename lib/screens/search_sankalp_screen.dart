import 'package:flutter/material.dart';

import 'package:niyojak_prod/providers/sankalp_screen_provider.dart';
import 'package:niyojak_prod/utils/custom_rect_tween.dart';
import 'package:niyojak_prod/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../helpers/static_data.dart' as Statics;

class SearchSankalpScreen extends StatefulWidget {
  static const routeName = '/search-sankalp-screen';
  const SearchSankalpScreen({Key? key}) : super(key: key);

  @override
  _SearchSankalpScreenState createState() => _SearchSankalpScreenState();
}

class _SearchSankalpScreenState extends State<SearchSankalpScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final sankalpScreenProvider = Provider.of<SankalpScreenProvider>(context, listen: false);
      sankalpScreenProvider.initiatestate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<SankalpScreenProvider>(
      builder: (context, sankalpModel, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('sankalpaLabel'),
            style: TextStyle(fontSize: 24),
          ),
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.width * 0.035),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSankalpYeardrop(sankalpModel, size),
                buildBhaagNamedrop(sankalpModel, size),
                buildTalukarop(sankalpModel, size),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder<bool>(
                          stream: sankalpModel.validateGet,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                              onPressed: !snapshot.hasData ? null : () => sankalpModel.controlSankalpData(context),
                              child: Text(Statics.getLabel('Search')),
                            );
                          }),
                      ElevatedButton(
                        onPressed: () => sankalpModel.onTapResetLink(),
                        child: Text(Statics.getLabel('clear')),
                      ),
                    ],
                  ),
                ),
                sankalpModel.isLoading == 0
                    ? SizedBox()
                    : sankalpModel.isLoading == 2
                        ? Column(
                            children: [
                              SafeArea(
                                child: Scrollbar(
                                  // isAlwaysShown: true,
                                  controller: sankalpModel.verticalScrollController,
                                  child: SingleChildScrollView(
                                    controller: sankalpModel.verticalScrollController,
                                    scrollDirection: Axis.vertical,
                                    child: Scrollbar(
                                      // isAlwaysShown: true,
                                      controller: sankalpModel.horizontalScrollController,
                                      child: SingleChildScrollView(
                                        controller: sankalpModel.horizontalScrollController,
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          children: [
                                            DataTable(
                                                // border: TableBorder.all(
                                                //     borderRadius:
                                                //         BorderRadius.zero),
                                                columnSpacing: size.width * 0.045,
                                                headingRowColor: MaterialStateProperty.all<Color>(Colors.brown.shade200),
                                                headingTextStyle:
                                                    TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600, color: Colors.black),
                                                // dataTextStyle: styleFont(
                                                //     fontSize: size.width * 0.04,
                                                //     fontWeight: FontWeight.w400,
                                                //     fontColor: Colors.black),
                                                columns: [
                                                  DataColumn(
                                                    label: Text("${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}"),
                                                  ),
                                                  DataColumn(label: Text(Statics.getLabel("sankalpaLabel"))),
                                                  DataColumn(
                                                    label: Text(Statics.getLabel("sthitiLabel")),
                                                  ),
                                                ],
                                                rows: [
                                                  DataRow(color: MaterialStateProperty.all<Color>(Colors.greenAccent), cells: [
                                                    DataCell(
                                                      Text(
                                                        Statics.getLabel("vastiLabel"),
                                                        style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(
                                                      Text(Statics.getLabel('TotalCountLabel')),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel("ShaakhaaYuktaLabel"))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "1",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.vastiHasShaakhaaSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.vastiHasShaakhaaSController,
                                                              "${Statics.getLabel('ShaakhaaYuktaLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "1")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.vastiHasShaakhaaA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel('SaaptaahikSLabel'))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "2",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.vastiHasSaaptaahikSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.vastiHasSaaptaahikSController,
                                                              "${Statics.getLabel('SaaptaahikSLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "2")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.vastiHasSaaptaahikA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel("MaasikYuktaLabel"))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "3",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.vastiHasMaasikController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.vastiHasMaasikController,
                                                              "${Statics.getLabel('MaasikYuktaLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "3")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.vastiHasMaasikA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(
                                                    cells: [
                                                      DataCell(Text(Statics.getLabel("GatividhiSLabel"))),
                                                      DataCell(
                                                        Hero(
                                                          tag: "4",
                                                          createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                          child: Material(
                                                            child: Text("${sankalpModel.vastiHasGatividhiSController.text}"),
                                                          ),
                                                        ),
                                                        showEditIcon: sankalpModel.getIsEditEnabled,
                                                        onTap: sankalpModel.getIsEditEnabled
                                                            ? () => sankalpModel.showEditDialog(
                                                                context,
                                                                sankalpModel.vastiHasGatividhiSController,
                                                                "${Statics.getLabel('GatividhiSLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                                "4")
                                                            : null,
                                                      ),
                                                      DataCell(
                                                        Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.vastiHasGatividhiA ?? 0}"),
                                                      ),
                                                    ],
                                                  ),
                                                  ////========================================== Table for GRAAM ///////////////==============================================

                                                  DataRow(color: MaterialStateProperty.all<Color>(Colors.greenAccent), cells: [
                                                    DataCell(
                                                      Text(
                                                        Statics.getLabel("GraamLabel"),
                                                        style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(
                                                      Text(Statics.getLabel('TotalCountLabel')),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel("ShaakhaaYuktaLabel"))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "5",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.graamHasShaakhaaSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.graamHasShaakhaaSController,
                                                              "${Statics.getLabel('ShaakhaaYuktaLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "5")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.graamHasShaakhaaA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel('SaaptaahikSLabel'))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "6",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.graamHasSaaptaahikSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.graamHasSaaptaahikSController,
                                                              "${Statics.getLabel('SaaptaahikSLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "6")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.graamHasSaaptaahikA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(
                                                      Text(Statics.getLabel("MaasikYuktaLabel")),
                                                    ),
                                                    DataCell(
                                                      Hero(
                                                        tag: "7",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.graamHasMaasikSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.graamHasMaasikSController,
                                                              "${Statics.getLabel('MaasikYuktaLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "7")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.graamHasMaasikA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Text(Statics.getLabel("GatividhiSLabel")),
                                                      ),
                                                      DataCell(
                                                        Hero(
                                                          tag: "8",
                                                          createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                          child: Material(
                                                            child: Text("${sankalpModel.graamHasGatividhiSController.text}"),
                                                          ),
                                                        ),
                                                        showEditIcon: sankalpModel.getIsEditEnabled,
                                                        onTap: sankalpModel.getIsEditEnabled
                                                            ? () => sankalpModel.showEditDialog(
                                                                context,
                                                                sankalpModel.graamHasGatividhiSController,
                                                                "${Statics.getLabel('GatividhiSLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                                "8")
                                                            : null,
                                                      ),
                                                      DataCell(
                                                        Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.graamHasGatividhiA ?? 0}"),
                                                      ),
                                                    ],
                                                  ),

//// =======================================Table For MANDAL =========================================================
                                                  DataRow(color: MaterialStateProperty.all<Color>(Colors.greenAccent), cells: [
                                                    DataCell(
                                                      Text(
                                                        Statics.getLabel("MandalLabel"),
                                                        style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(
                                                      Text(Statics.getLabel("TotalCountLabel")),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel("ShaakhaaYuktaLabel"))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "9",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.mandalHasShaakhaaSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.mandalHasShaakhaaSController,
                                                              "${Statics.getLabel('ShaakhaaYuktaLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "9")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.mandalHasShaakhaaA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel('SaaptaahikSLabel'))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "10",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.mandalHasSaaptaahikSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.mandalHasSaaptaahikSController,
                                                              "${Statics.getLabel('SaaptaahikSLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "10")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.mandalHasSaaptaahikA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel("MaasikYuktaLabel"))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "11",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.mandalHasMaasikSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.mandalHasMaasikSController,
                                                              "${Statics.getLabel('MaasikYuktaLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "11")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.mandalHasMaasikA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Text(Statics.getLabel("GatividhiSLabel")),
                                                      ),
                                                      DataCell(
                                                        Hero(
                                                          tag: "12",
                                                          createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                          child: Material(
                                                            child: Text("${sankalpModel.mandalHasGatividhiSController.text}"),
                                                          ),
                                                        ),
                                                        showEditIcon: sankalpModel.getIsEditEnabled,
                                                        onTap: sankalpModel.getIsEditEnabled
                                                            ? () => sankalpModel.showEditDialog(
                                                                context,
                                                                sankalpModel.mandalHasGatividhiSController,
                                                                "${Statics.getLabel('GatividhiSLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                                "12")
                                                            : null,
                                                      ),
                                                      DataCell(
                                                        Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.mandalHasGatividhiA ?? 0}"),
                                                      ),
                                                    ],
                                                  ),
////====================================== Table For Shaakhaa ===================================================
                                                  DataRow(color: MaterialStateProperty.all<Color>(Colors.greenAccent), cells: [
                                                    DataCell(
                                                      Text(
                                                        Statics.getLabel("ShaakhaaLabel"),
                                                        style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel('SanyuktaVidyaarthiLabel'))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "13",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.sVShaakhaaCountSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.sVShaakhaaCountSController,
                                                              "${Statics.getLabel('SanyuktaVidyaarthiLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "13")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.sVShaakhaaCountA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel("MahaavidyaalayeenTarunLabel"))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "14",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.mVShaakhaaCountSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.mVShaakhaaCountSController,
                                                              "${Statics.getLabel('MahaavidyaalayeenTarunLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "14")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.mVShaakhaaCountA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel("VyavasaayeeTarunLabel"))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "15",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.tVShaakhaaCountSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.tVShaakhaaCountSController,
                                                              "${Statics.getLabel('VyavasaayeeTarunLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "15")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.tVShaakhaaCountA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Text(Statics.getLabel("ProudhaVyavasaayeeLabel")),
                                                      ),
                                                      DataCell(
                                                        Hero(
                                                          tag: "16",
                                                          createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                          child: Material(
                                                            child: Text("${sankalpModel.pVShaakhaaCountSController.text}"),
                                                          ),
                                                        ),
                                                        showEditIcon: sankalpModel.getIsEditEnabled,
                                                        onTap: sankalpModel.getIsEditEnabled
                                                            ? () => sankalpModel.showEditDialog(
                                                                context,
                                                                sankalpModel.pVShaakhaaCountSController,
                                                                "${Statics.getLabel('ProudhaVyavasaayeeLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                                "16")
                                                            : null,
                                                      ),
                                                      DataCell(
                                                        Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.pVShaakhaaCountA ?? 0}"),
                                                      ),
                                                    ],
                                                  ),

                                                  ///=================================== Table For SAAPTAAHIK ===========================================
                                                  DataRow(color: MaterialStateProperty.all<Color>(Colors.greenAccent), cells: [
                                                    DataCell(
                                                      Text(
                                                        Statics.getLabel('SaaptaahikLabel'),
                                                        style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                    DataCell(
                                                      Text(""),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel('SanyuktaVidyaarthiLabel'))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "17",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.sVSaaptaahikCountSSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.sVSaaptaahikCountSSController,
                                                              "${Statics.getLabel('SanyuktaVidyaarthiLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "17")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.sVSaaptaahikCountA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel("MahaavidyaalayeenTarunLabel"))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "18",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.mVSaaptaahikCountSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.mVSaaptaahikCountSController,
                                                              "${Statics.getLabel('MahaavidyaalayeenTarunLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "18")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.mVSaaptaahikCountA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(cells: [
                                                    DataCell(Text(Statics.getLabel("VyavasaayeeTarunLabel"))),
                                                    DataCell(
                                                      Hero(
                                                        tag: "19",
                                                        createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                        child: Material(
                                                          child: Text("${sankalpModel.tVSaaptaahikCountSController.text}"),
                                                        ),
                                                      ),
                                                      showEditIcon: sankalpModel.getIsEditEnabled,
                                                      onTap: sankalpModel.getIsEditEnabled
                                                          ? () => sankalpModel.showEditDialog(
                                                              context,
                                                              sankalpModel.tVSaaptaahikCountSController,
                                                              "${Statics.getLabel('VyavasaayeeTarunLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                              "19")
                                                          : null,
                                                    ),
                                                    DataCell(
                                                      Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.tVSaaptaahikCountA ?? 0}"),
                                                    ),
                                                  ]),
                                                  DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Text(Statics.getLabel("ProudhaVyavasaayeeLabel")),
                                                      ),
                                                      DataCell(
                                                        Hero(
                                                          tag: "20",
                                                          createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                          child: Material(
                                                            child: Text("${sankalpModel.pVSaaptaahikCountSController.text}"),
                                                          ),
                                                        ),
                                                        showEditIcon: sankalpModel.getIsEditEnabled,
                                                        onTap: sankalpModel.getIsEditEnabled
                                                            ? () => sankalpModel.showEditDialog(
                                                                context,
                                                                sankalpModel.pVSaaptaahikCountSController,
                                                                "${Statics.getLabel('ProudhaVyavasaayeeLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                                "20")
                                                            : null,
                                                      ),
                                                      DataCell(
                                                        Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.pVSaaptaahikCountA ?? 0}"),
                                                      ),
                                                    ],
                                                  ),
                                                  DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Text(Statics.getLabel("MaasikMilanLabel")),
                                                      ),
                                                      DataCell(
                                                        Hero(
                                                          tag: "21",
                                                          createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                          child: Material(
                                                            child: Text("${sankalpModel.maasikCountSController.text}"),
                                                          ),
                                                        ),
                                                        showEditIcon: sankalpModel.getIsEditEnabled,
                                                        onTap: sankalpModel.getIsEditEnabled
                                                            ? () => sankalpModel.showEditDialog(
                                                                context,
                                                                sankalpModel.maasikCountSController,
                                                                "${Statics.getLabel('MaasikMilanLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                                "21")
                                                            : null,
                                                      ),
                                                      DataCell(
                                                        Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.maasikCountA ?? 0}"),
                                                      ),
                                                    ],
                                                  ),
                                                  DataRow(
                                                    cells: [
                                                      DataCell(
                                                        Text(Statics.getLabel("SanghaMandali")),
                                                      ),
                                                      DataCell(
                                                        Hero(
                                                          tag: "22",
                                                          createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                          child: Material(
                                                            child: Text("${sankalpModel.mandaliCountSController.text}"),
                                                          ),
                                                        ),
                                                        showEditIcon: sankalpModel.getIsEditEnabled,
                                                        onTap: sankalpModel.getIsEditEnabled
                                                            ? () => sankalpModel.showEditDialog(
                                                                context,
                                                                sankalpModel.mandaliCountSController,
                                                                "${Statics.getLabel('SanghaMandali')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                                "22")
                                                            : null,
                                                      ),
                                                      DataCell(
                                                        Text("${sankalpModel.getSankalpModel!.kaaryaSthitiInfo!.mandaliCountA ?? 0}"),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: size.width * 0.05),
                                child: SafeArea(
                                  child: Scrollbar(
                                    // isAlwaysShown: true,
                                    controller: sankalpModel.verticalScrollController1,
                                    child: SingleChildScrollView(
                                      controller: sankalpModel.verticalScrollController1,
                                      scrollDirection: Axis.vertical,
                                      child: Scrollbar(
                                        // isAlwaysShown: true,
                                        controller: sankalpModel.horizontalScrollController1,
                                        child: SingleChildScrollView(
                                          controller: sankalpModel.horizontalScrollController1,
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                              // border: TableBorder.all(
                                              //     borderRadius:
                                              // BorderRadius.zero),
                                              columnSpacing: size.width * 0.015,
                                              headingRowColor: MaterialStateProperty.all<Color>(Colors.brown.shade200),
                                              headingTextStyle:
                                                  TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600, color: Colors.black),
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    Statics.getLabel("SankalpAadhaarLabel"),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(Statics.getLabel("ShaakhaaLabel")),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    Statics.getLabel("SaaptaahikLabel"),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    Statics.getLabel("SanghaMandali"),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    Statics.getLabel("GatividhiSLabel"),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                              rows: [
                                                DataRow(cells: [
                                                  DataCell(
                                                    Text(
                                                      Statics.getLabel("PravaaseeKaaryakataaLabel"),
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "23",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.pKAShaakhaaCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.pKAShaakhaaCountSController,
                                                            "${Statics.getLabel('PravaaseeKaaryakataaLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "23")
                                                        : null,
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "24",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.pKASaaptaahikCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.pKASaaptaahikCountSController,
                                                            "${Statics.getLabel('PravaaseeKaaryakataaLabel')} - ${Statics.getLabel('SaaptaahikLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "24")
                                                        : null,
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "25",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.pKAMaasikCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.pKAMaasikCountSController,
                                                            "${Statics.getLabel('PravaaseeKaaryakataaLabel')} - ${Statics.getLabel('SanghaMandali')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "25")
                                                        : null,
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "26",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.pKAGatividhiCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.pKAGatividhiCountSController,
                                                            "${Statics.getLabel('PravaaseeKaaryakataaLabel')} - ${Statics.getLabel('GatividhiSLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "26")
                                                        : null,
                                                  ),
                                                ]),
                                                DataRow(cells: [
                                                  DataCell(
                                                    Text(Statics.getLabel("ShaakhaaLabel")),
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "27",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.sKAShaakhaaCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.sKAShaakhaaCountSController,
                                                            "${Statics.getLabel('ShaakhaaLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "27")
                                                        : null,
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "28",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.sKASaaptaahikCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.sKASaaptaahikCountSController,
                                                            "${Statics.getLabel('ShaakhaaLabel')} - ${Statics.getLabel('SaaptaahikLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "28")
                                                        : null,
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "29",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.sKAMaasikCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.sKAMaasikCountSController,
                                                            "${Statics.getLabel('ShaakhaaLabel')} - ${Statics.getLabel('SanghaMandali')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "29")
                                                        : null,
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "30",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.sKAGatividhiCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.sKAGatividhiCountSController,
                                                            "${Statics.getLabel('ShaakhaaLabel')} - ${Statics.getLabel('GatividhiSLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "30")
                                                        : null,
                                                  ),
                                                ]),
                                                DataRow(cells: [
                                                  DataCell(
                                                    Text(
                                                      Statics.getLabel("VistaarakshamSwayamsevakLabel"),
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "31",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.sWAShaakhaaCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.sWAShaakhaaCountSController,
                                                            "${Statics.getLabel('VistaarakshamSwayamsevakLabel')} - ${Statics.getLabel('sankalpaLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "31")
                                                        : null,
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "32",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.sWASaaptaahikCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.sWASaaptaahikCountSController,
                                                            "${Statics.getLabel('VistaarakshamSwayamsevakLabel')} - ${Statics.getLabel('SaaptaahikLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "32")
                                                        : null,
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "33",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.sWAMaasikCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.sWAMaasikCountSController,
                                                            "${Statics.getLabel('VistaarakshamSwayamsevakLabel')} - ${Statics.getLabel('SanghaMandali')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "33")
                                                        : null,
                                                  ),
                                                  DataCell(
                                                    Hero(
                                                      tag: "34",
                                                      createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
                                                      child: Material(
                                                        child: Text(
                                                          "${sankalpModel.sWAGatividhiCountSController.text}",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    showEditIcon: sankalpModel.getIsEditEnabled,
                                                    onTap: sankalpModel.getIsEditEnabled
                                                        ? () => sankalpModel.showEditDialog(
                                                            context,
                                                            sankalpModel.sWAGatividhiCountSController,
                                                            "${Statics.getLabel('VistaarakshamSwayamsevakLabel')} - ${Statics.getLabel('GatividhiSLabel')} - ${sankalpModel.getSankalpModel!.sankalpInfo!.sankalpYear}",
                                                            "34")
                                                        : null,
                                                  ),
                                                ]),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : sankalpModel.isLoading == 3
                            ? Center(child: Text("Data Not Found"))
                            : sankalpModel.isLoading == 1
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SizedBox(),
                sankalpModel.isLoading == 2
                    ? sankalpModel.isSaveLoading == 0
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: size.width * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width * 0.65,
                                  child: ElevatedButton(
                                    onPressed: () => sankalpModel.saveSankalpData(context),
                                    child: Text(Statics.getLabel('Submit')),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: size.width * 0.025, bottom: size.width * 0.025),
                            child: Center(child: CircularProgressIndicator()),
                          )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSankalpYeardrop(SankalpScreenProvider sankalpModel, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: StreamBuilder<String>(
          stream: sankalpModel.sankalpYear,
          builder: (context, snapshot) {
            return Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: Statics.getLabel('sankalpaLabel')),
                  isExpanded: true,
                  onTap: () {
                    if (snapshot.hasData) {
                      sankalpModel.changeUserSankalpYear(snapshot.data!);
                    } else {
                      sankalpModel.changeUserSankalpYear("");
                    }
                  },
                  value: snapshot.data,
                  items: sankalpModel.getSankalpYearList
                      .map(
                        (item) => DropdownMenuItem<String>(
                          child: new Text(
                            item,
                          ),
                          value: item,
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    sankalpModel.changeUserSankalpYear(val!);
                  },
                ),
                snapshot.hasError
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: Text(
                            snapshot.error.toString(),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
              ],
            );
          }),
    );
  }

  Widget buildBhaagNamedrop(SankalpScreenProvider sankalpModel, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: StreamBuilder<String>(
          stream: sankalpModel.bhaagName,
          builder: (context, snapshot) {
            return Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: Statics.getLabel('BhaagKaaryakartaaCount')),
                  isExpanded: true,
                  onTap: () {
                    if (snapshot.hasData) {
                      sankalpModel.changeUserBhaagname(snapshot.data!);
                    } else {
                      sankalpModel.changeUserBhaagname("");
                    }
                  },
                  value: snapshot.data,
                  items: sankalpModel.getBhaagList
                      .map(
                        (item) => DropdownMenuItem<String>(
                            child: new Text(
                              item.name!,
                            ),
                            value: item.geoUnitID.toString()),
                      )
                      .toList(),
                  onChanged: (val) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    sankalpModel.changeUserBhaagname(val!);
                  },
                ),
                snapshot.hasError
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: Text(
                            snapshot.error.toString(),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
              ],
            );
          }),
    );
  }

  Widget buildTalukarop(SankalpScreenProvider sankalpModel, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: StreamBuilder<String>(
          stream: sankalpModel.taalukaa,
          builder: (context, snapshot) {
            return Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: Statics.getLabel('SelectNagarValidationMessage')),
                  isExpanded: true,
                  onTap: () {
                    if (snapshot.hasData) {
                      sankalpModel.changeUserTaalukaa(snapshot.data!);
                    } else {
                      sankalpModel.changeUserTaalukaa("");
                    }
                  },
                  value: snapshot.data,
                  items: sankalpModel.getTaalukaaList
                      .map(
                        (item) => DropdownMenuItem<String>(
                          child: new Text(
                            item.name!,
                          ),
                          value: item.geoUnitID.toString(),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    sankalpModel.changeUserTaalukaa(val!);
                  },
                ),
                snapshot.hasError
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: Text(
                            snapshot.error.toString(),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
              ],
            );
          }),
    );
  }
}
