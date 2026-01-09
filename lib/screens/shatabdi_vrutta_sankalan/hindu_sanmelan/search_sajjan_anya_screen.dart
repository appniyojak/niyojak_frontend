import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../../helpers/static_data.dart' as Statics;
import '../../../models/response_model/vijayaDashamiInitModel.dart';

class SearchSajjanAnyaScreen extends StatefulWidget {
  static const String routeName = '/search-sajjan-anya-view';

  const SearchSajjanAnyaScreen({super.key});

  @override
  State<SearchSajjanAnyaScreen> createState() => _SearchSajjanAnyaScreenState();
}

class _SearchSajjanAnyaScreenState extends State<SearchSajjanAnyaScreen> {
  String? geoUnitId;
  bool fromMukhya = false;

  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  Vastisarsajjanshakti? sajjanMukhya;
  List<Vastisarsajjanshakti> sajjanList = [];
  List<Vastisarsajjanshakti> selectedsajjanList = [];

  Vastisanyaprabhavi? anyaMukhya;
  List<Vastisanyaprabhavi> anyaList = [];
  List<Vastisanyaprabhavi> selectedanyaList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _search() async {
    setState(() {
      _isSearching = true;
    });
    await _getSwList();
    setState(() {
      _isSearching = false;
    });
  }

  Future<void> _getSwList() async {
    sajjanList = [];
    selectedsajjanList = [];
    anyaList = [];
    selectedanyaList = [];
    sajjanMukhya = null;
    anyaMukhya = null;
    log("calling");
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var inputData = {
        "geounitid": int.parse(geoUnitId ?? "0"),
        // "AppUserID": "5693",
        "search": _searchController.text.trim(),
      };
      log(jsonEncode(inputData));
      final sajjanAnyaData = await Statics.searchSajjanAnyaForVisheshMukhyaFun(inputData);
      setState(() {});
      if (sajjanAnyaData != null) {
        setState(() {
          sajjanList = sajjanAnyaData.vastisarsajjanshakti ?? [];
          anyaList = sajjanAnyaData.vastisanyaprabhavi ?? [];
        });
      }
    }
  }

  Future<void> saveData() async {
    log("calling");
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var inputData = {
        "sajjanvisheshtiid": selectedsajjanList.map((e) => e.pkid.toString()).join(","),
        "annyavisheshtiid": selectedanyaList.map((e) => e.pkId.toString()).join(","),
        "sajjanmukhyaatitiid": sajjanMukhya?.pkid ?? 0,
        "annyamukhyaatitiid": anyaMukhya?.pkId ?? 0,
        "geounitid": geoUnitId,
        "AppUserID": int.parse(Statics.userDetails['userID']),
      };
      log(jsonEncode(inputData));
      final _res = await Statics.saveSajjanAnyaFromSearch(context, inputData);
      setState(() {});
      if (_res) {
        setState(() {});
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    setState(() {
      geoUnitId = args["geoUnitId"];
      fromMukhya = args["fromMukhya"] ?? false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(fromMukhya ? Statics.getLabel('addMukhyaAtithi') : Statics.getLabel('addVIshishthaAtithi'), style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 15),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${Statics.getLabel('Search')} ",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      ":",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(fontSize: 16),
                      autofocus: false,
                      onChanged: (v) {
                        if (v.isEmpty) {
                          sajjanList = [];
                          selectedsajjanList = [];
                          anyaList = [];
                          selectedanyaList = [];
                          sajjanMukhya = null;
                          anyaMukhya = null;
                        }
                        setState(() {});
                      },
                      // inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                      // keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        // suffixIcon: InkWell(
                        //   onTap: () async {
                        //     FocusScope.of(context).unfocus();
                        //     if (_searchController.text.length < 10) {
                        //       Statics.showToast(Statics.getLabel('MobileValidationMessage'));
                        //       return null;
                        //     }
                        //     await _search("Search");
                        //     setState(() {});
                        //   },
                        //   borderRadius: BorderRadius.circular(30),
                        //   child: Icon(
                        //     Icons.search,
                        //     size: 25,
                        //   ),
                        // ),
                        border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              if (_isSearching) CircularProgressIndicator(color: Colors.purple),

              //
              if (sajjanList.isNotEmpty && _searchController.text.isNotEmpty) ...[
                Text(
                  Statics.getLabel('SajjanShakti'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
                const Divider(),
                Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.5),
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemCount: sajjanList.length ?? 0,
                    itemBuilder: (context, index) {
                      final _data = sajjanList[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: fromMukhya
                            ? () => setState(() {
                                  sajjanMukhya = _data;
                                  anyaMukhya = null;
                                })
                            : () => setState(() => selectedsajjanList.add(_data)),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.all(5),
                          surfaceTintColor: Colors.transparent,
                          elevation: 5,
                          child: Container(
                              decoration: BoxDecoration(color: selectedsajjanList.contains(_data) ? Colors.purple.shade50 : Colors.white),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                spacing: 8,
                                children: [
                                  if (selectedsajjanList.contains(_data) || sajjanMukhya == _data)
                                    Icon(
                                      fromMukhya ? Icons.radio_button_checked : Icons.check_box_rounded,
                                      color: Colors.purple,
                                    ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _data.name ?? "",
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 12),
                                        RichText(
                                            text: TextSpan(
                                          text: 'M: ${_data.samparkasutraMobileNumber}',
                                          style: TextStyle(color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              UrlLauncher.launch("tel://" + (_data.samparkasutraMobileNumber ?? ''));
                                            },
                                        ))
                                      ],
                                    ),
                                  ),
                                  // if (selectedsajjanList.contains(_data))
                                  InkWell(
                                    onTap: () => showPersonDetailsPopup(context, _data, index + 1),
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                ),
              ],

              //
              if (anyaList.isNotEmpty && _searchController.text.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  Statics.getLabel('anyaPrabhaviLok'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 8),
                Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.5),
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemCount: anyaList.length ?? 0,
                    itemBuilder: (context, index) {
                      final _data = anyaList[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: fromMukhya
                            ? () => setState(() {
                                  sajjanMukhya = null;
                                  anyaMukhya = _data;
                                })
                            : () => setState(() => selectedanyaList.add(_data)),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.all(5),
                          surfaceTintColor: Colors.transparent,
                          elevation: 5,
                          child: Container(
                              decoration: BoxDecoration(color: selectedanyaList.contains(_data) ? Colors.purple.shade50 : Colors.white),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  if (selectedanyaList.contains(_data) || anyaMukhya == _data)
                                    Icon(
                                      fromMukhya ? Icons.radio_button_checked : Icons.check_box_rounded,
                                      color: Colors.purple,
                                    ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _data.name ?? "",
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 12),
                                        RichText(
                                            text: TextSpan(
                                          text: 'M: ${_data.doorabhaash}',
                                          style: TextStyle(color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              UrlLauncher.launch("tel://" + (_data.doorabhaash ?? ''));
                                            },
                                        ))
                                      ],
                                    ),
                                  ),
                                  if (selectedanyaList.contains(_data))
                                    InkWell(
                                      onTap: () => showPersonDetailsPopup(context, _data, index + 1),
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.purple,
                                      ),
                                    ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                ),
              ],

              //
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              // _searchController.text.trim().isNotEmpty
              //     ? MaterialButton(
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              //         padding: EdgeInsets.symmetric(
              //           horizontal: 15,
              //           vertical: 8,
              //         ),
              //         color: Theme.of(context).primaryColor,
              //         textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
              //         onPressed: () async {
              //           FocusManager.instance.primaryFocus?.unfocus();
              //           // if (_searchController.text.trim().isNotEmpty) {
              //             _search();
              //         },
              //         child: Text(
              //           Statics.getLabel('Submit'),
              //           style: TextStyle(fontSize: 16),
              //         ),
              //       )
              //     :
              (selectedsajjanList.isNotEmpty || selectedanyaList.isNotEmpty || sajjanMukhya != null || anyaMukhya != null)
                  ? MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        // if (_searchController.text.trim().isNotEmpty) {
                        saveData();
                      },
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        // if (from == "swayamsevak") {
                        //   Fluttertoast.showToast(
                        //     msg: Statics.getLabel("workInProgress"),
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.BOTTOM,
                        //   );
                        //   return;
                        // }
                        if (_searchController.text.length < 3) {
                          Statics.showToast(Statics.getLabel('minimumWordsRequired'));
                          return null;
                        }
                        await _search();
                        setState(() {});
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.search), SizedBox(width: 6), Text(Statics.getLabel("search"))],
                      ),
                    ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showPersonDetailsPopup(BuildContext context, dynamic item, int srNo) {
  List<Map<String, String>> details = [];

  // Agar Vastisarsajjanshakti ka object aaya
  if (item is Vastisarsajjanshakti) {
    details = [
      {"${Statics.getLabel('Vasti')} :": item.vastiname ?? ""},
      {"${Statics.getLabel('Name')} :": item.name ?? ""},
      {"${Statics.getLabel('Address')} :": item.address ?? ""},
      {"${Statics.getLabel('mobileNumberLabel')} :": item.doorabhaash ?? ""},
      {"${Statics.getLabel('shreni')}  :": item.selectedDropdownValueName ?? ""},
      {"${Statics.getLabel('OrganizationName')}  :": item.sanstheCheNaav ?? ""},
      {"${Statics.getLabel('sansthetKuthalaPadavar')}   :": item.sansthechaKuthalaPadavar ?? ""},
      {"${Statics.getLabel('samparkSthiti')}  :": item.selectedDropdownValueName1 ?? ""},
      {"${Statics.getLabel('special')} :": item.visheshname ?? ""},
      {"${Statics.getLabel('prabhavKshetra')} :": item.prabhaavkshetrName ?? ""},
      {"${Statics.getLabel('samparkSootraNaav')} :": item.samparkasutranava ?? ""},
      {"${Statics.getLabel('samparakSootraDoorbhash')} :": item.samparkasutraMobileNumber ?? ""},
    ];
  }

  // Agar Vastisanyaprabhavi ka object aaya
  else if (item is Vastisanyaprabhavi) {
    details = [
      {"${Statics.getLabel('Vasti')}  :": item.vastiName ?? ""},
      {"${Statics.getLabel('Name')} :": item.name ?? ""},
      {"${Statics.getLabel('Address')}:": item.address ?? ""},
      {"${Statics.getLabel('mobileNumberLabel')} :": item.doorabhaash ?? ""},
      {"${Statics.getLabel('shreni')}  :": item.shreneeName ?? ""},
      {"${Statics.getLabel('upshreni')} :": item.upshreneeName ?? ""},
      {"${Statics.getLabel('otherUpshreni')}  :": item.otherUpshrenee ?? ""},
      {"${Statics.getLabel('upshreni')}2 :": item.upshrenee2Name ?? ""},
      {"${Statics.getLabel('otherUpshreni')}2 :": item.otherUpshrenee2 ?? ""},
      {"${Statics.getLabel('special')}  :": item.visheshName ?? ""},
      {"${Statics.getLabel('prabhavKshetra')} :": item.prabhaavKshetreName ?? ""},
      {"${Statics.getLabel('other')} ${Statics.getLabel('special')}  :": item.anyaVishesMahiti ?? ""},
      {"${Statics.getLabel('samparkStithi')} :": item.samparkSthit ?? ""},
      {"${Statics.getLabel('samparkSootraNaav')} :": item.samparkAsutraNav ?? ""},
      {"${Statics.getLabel('samparakSootraDoorbhash')} :": item.samparkaSutraDoorbhash ?? ""},
    ];
  }

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.purpleAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${Statics.getLabel('PersonalDetails')}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // 🔹 Details List
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: details
                        .map(
                          (e) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    e.keys.first,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    e.values.first.isEmpty ? "-" : e.values.first,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 🔹 Footer Button
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    minimumSize: const Size.fromHeight(45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: Text(
                    "${Statics.getLabel('bandKara')}",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
