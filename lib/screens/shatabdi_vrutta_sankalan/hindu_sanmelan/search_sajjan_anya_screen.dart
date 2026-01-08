import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../helpers/static_data.dart' as Statics;

class SearchSajjanAnyaScreen extends StatefulWidget {
  static const String routeName = '/search-sajjan-anya-view';

  const SearchSajjanAnyaScreen({super.key});

  @override
  State<SearchSajjanAnyaScreen> createState() => _SearchSajjanAnyaScreenState();
}

class _SearchSajjanAnyaScreenState extends State<SearchSajjanAnyaScreen> {
  String? geoUnitId;

  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

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
    log("calling");
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var inputData = {
        "geounitid": geoUnitId,
        // "AppUserID": "5693",
        "search": _searchController.text.trim(),
      };
      log(jsonEncode(inputData));
      // abhiyaanPramukhSwayamsevak = await Statics.searchSajjanAnyaForVisheshMukhyaFun(inputData);
      // setState(() {});
      // if (abhiyaanPramukhSwayamsevak != null) {
      //   setState(() {});
      // }
    }
  }

  Future<void> saveData() async {
    log("calling");
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var inputData = {
        "geounitid": geoUnitId,
        // "AppUserID": "5693",
        "search": _searchController.text.trim(),
      };
      log(jsonEncode(inputData));
      await Statics.saveSajjanAnyaFromSearch(context, inputData);
      setState(() {});
      // if (abhiyaanPramukhSwayamsevak != null) {
      //   setState(() {});
      // }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    setState(() {
      geoUnitId = args["geoUnitId"];
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
        title: Text(Statics.getLabel('addMukhyaAtithi'), style: TextStyle(fontWeight: FontWeight.bold)),
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
                          // _selectedPramukh = null;
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
              // if ((abhiyaanPramukhSwayamsevak != null && abhiyaanPramukhSwayamsevak!.isNotEmpty) && _searchController.text.isNotEmpty)
              //   Container(
              //     constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.5),
              //     child: ListView.separated(
              //       shrinkWrap: true,
              //       separatorBuilder: (context, index) => SizedBox(height: 12),
              //       itemCount: abhiyaanPramukhSwayamsevak?.length ?? 0,
              //       itemBuilder: (context, index) {
              //         final _data = abhiyaanPramukhSwayamsevak![index];
              //         return InkWell(
              //           borderRadius: BorderRadius.circular(12),
              //           onTap: () => setState(() {
              //             _selectedPramukh = _data;
              //           }),
              //           child: Card(
              //             clipBehavior: Clip.antiAlias,
              //             margin: EdgeInsets.all(5),
              //             surfaceTintColor: Colors.transparent,
              //             elevation: 5,
              //             child: Container(
              //                 decoration: BoxDecoration(color: _selectedPramukh == _data ? Colors.purple.shade50 : Colors.white),
              //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Row(
              //                       children: [
              //                         Expanded(
              //                           child: Text(
              //                             _data.participantName ?? "",
              //                             style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
              //                           ),
              //                         ),
              //                         if (_selectedPramukh == _data)
              //                           Icon(
              //                             Icons.check_box_rounded,
              //                             color: Colors.purple,
              //                           )
              //                       ],
              //                     ),
              //                     SizedBox(height: 12),
              //                     RichText(
              //                         text: TextSpan(
              //                       text: 'M: ${_data.participantNumber}',
              //                       style: TextStyle(color: Colors.blue),
              //                       recognizer: TapGestureRecognizer()
              //                         ..onTap = () {
              //                           UrlLauncher.launch("tel://" + (_data.participantNumber ?? ''));
              //                         },
              //                     ))
              //                   ],
              //                 )),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              _searchController.text.isNotEmpty
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
                        if (_searchController.text.trim().isEmpty) {
                          return;
                        }
                        _search();
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
