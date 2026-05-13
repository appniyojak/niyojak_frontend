import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niyojak_prod/screens/sankalit_data_name.dart';
import 'package:niyojak_prod/screens/tulnatmak_sankalit_baithak.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../helpers/static_data.dart' as Statics;
import '../models/response_model/dropdown_level_responsemodel.dart';
import '../models/response_model/sankalit_data_names_model.dart';
import '../providers/bals.dart';
import '../utils/globals.dart';
import '../widgets/app_drawer.dart';
import '../widgets/legend.dart';
import '../widgets/single_column_row.dart';
import '../widgets/two_column_row.dart';

class AnnualBaithakEkatritVrutta extends StatefulWidget {
  static const routeName = '/annual-baithak-ekatrit-vrutta';

  @override
  _AnnualBaithakEkatritVruttaState createState() => _AnnualBaithakEkatritVruttaState();
}

class _AnnualBaithakEkatritVruttaState extends State<AnnualBaithakEkatritVrutta> {
  final GlobalKey _globalKey = GlobalKey();

  bool _isSearching = false;
  bool _isExpanded = false;

  List<GeoUnitMasterBAL>? _linkedMahaanagar;
  List<GeoUnitMasterBAL>? _linkedVibhaag;
  List<GeoUnitMasterBAL>? _linkedBhaag;
  List<GeoUnitMasterBAL>? _linkedShahar;
  List<GeoUnitMasterBAL>? _linkedNagar;
  List<GeoUnitMasterBAL>? _linkedupnagar;
  List<StaticMasterBAL>? _baithakTypes;
  List<List<String>> donloadexportList = [];

  String? _linkedupnagarValue = '';
  String? _selctedLevel = 'praant';
  String? _selctedLevelName = '';
  String _selctedLevelNames = '';
  List<String?> _selctedLevelNameList = [];
  String? _selectedGeoUnitId;

  String? _linkedMahaanagarValue = '';
  String? _linkedVibhaagValue = '';
  String? _linkedBhaagValue = '';
  String? _linkedShaharValue = '';
  String? _linkedNagarValue = '';
  String? _baithakTypeValue = '';
  String? _baithakTypeYear = '';
  String? _selectedBaithak = '';
  int? _baithakType;
  int? geoID;
  String _selectedNagarAndBaithak = '';
  String? mahanagarId = '';
  String? vibhagId = '';

  dynamic _ekatritVrutta;
  int? _geoLevel;
  bool _hasGraaminKshetra = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //_shakhaaList = _getshakhaaList(-1, "get nothing", null, null);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
  }

  Future<void> initData() async {
    DropDownModel dm = await MyAppGlobals.getLevelLDB();

    setState(() {
      userLevelId = dm.levelID;
      userGeoUnitId = dm.geoUnitID;
      ddm = dm;
    });
    await populateDropdown();
  }

  // void populateDropdown() async {
  //   var data = await Statics.getStaticLDB('AnnualBaithakType');
  //   // populatelinkedBhaagDropdown();
  //   populatelinkedMahaanagarDropdown();
  //   populatelinkedVibhaagDropdown('');
  //   if (!mounted) return;
  //   log("datadata ${data.map((e) => e.monthYear)}");
  //   setState(() {
  //     _baithakTypes = data;
  //   });
  // }

  Future<void> populateAllDropdowns(int level, DropDownModel dm) async {
    setState(() {
      _selectedGeoUnitId = _linkedMahaanagarValue = _linkedVibhaagValue = _linkedBhaagValue = _linkedNagarValue = _linkedupnagarValue = null;
    });
    final selection = prepareSelection(dm);

    // Step 1: Mahaanagar
    await populatelinkedMahaanagarDropdown();
    _selectedGeoUnitId = _linkedMahaanagarValue = (level == 9 ? (dm.geoUnitID ?? "").toString() : selection.mahaanagar) ?? '';
    _selctedLevel = 'Mahaanagar';

    // Step 2: Vibhaag
    await populatelinkedVibhaagDropdown(_linkedMahaanagarValue!);
    _selectedGeoUnitId = _linkedVibhaagValue = (level == 8 ? (dm.geoUnitID ?? "").toString() : selection.vibhaag) ?? '';
    _selctedLevel = 'Vibhaag';

    // Step 3: Bhaag
    await populatelinkedBhaagDropdown(_linkedVibhaagValue!);
    _selectedGeoUnitId = _linkedBhaagValue = (level == 7 ? (dm.geoUnitID ?? "").toString() : selection.bhaag) ?? '';
    _selctedLevel = 'Bhaag';

    // Step 4: Nagar
    await populatelinkedNagarDropdown(_linkedBhaagValue, null);
    _selectedGeoUnitId = _linkedNagarValue = (level == 6 ? (dm.geoUnitID ?? "").toString() : selection.nagar) ?? '';
    _selctedLevel = 'Nagar';

    //if (selection.upnagar != null && selection.upnagar!.isNotEmpty) {
    await populatelinkedUpnagarDropdown(_linkedNagarValue);
    _linkedupnagarValue = (level == 13 ? (dm.geoUnitID ?? 0).toString() : selection.upnagar) ?? _linkedupnagarValue;
    if (level == 13) {
      _selectedGeoUnitId = (dm.geoUnitID ?? selection.upnagar).toString();
      _selctedLevel = 'Upnagar';
    }
    // }

    // if (_linkedVibhaag != null && _linkedVibhaag!.isNotEmpty) _linkedVibhaagName = _linkedVibhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedBhaag != null && _linkedBhaag!.isNotEmpty) _linkedbhaagName = _linkedBhaag!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;
    // if (_linkedNagar != null && _linkedNagar!.isNotEmpty) _linkednagarName = _linkedNagar!.firstWhere((bg) => bg.geoUnitID.toString() == _linkedBhaagValue).name;

    setState(() {});
  }

  Future<void> populateDropdown({bool fromClear = false}) async {
    setState(() {
      _linkedMahaanagarValue = _linkedVibhaagValue = _linkedBhaagValue = _linkedNagarValue = _linkedupnagarValue = null;
      _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedNagar = _linkedupnagar = null;
      _selctedLevelName = _selectedGeoUnitId = null;
      _selctedLevel = "praant";
    });
    await populatelinkedMahaanagarDropdown();
    await populatelinkedVibhaagDropdown('');
    if (fromClear || userLevelId == null || ddm == null) {
      print("object is null");
      return;
    }
    print("object is not null >>>>>>>>>>>>>>>>>>>>>>");
    await populateAllDropdowns(userLevelId!, ddm!);
    var data = await Statics.getStaticLDB('AnnualBaithakType');
    if (!mounted) return;
    log("datadata ${data.map((e) => e.monthYear)}");
    setState(() {
      _baithakTypes = data;
    });
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedMahaanagarDropdown() async {
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '', isAbhiyaan: false);
    setState(() => _linkedMahaanagar = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
    _linkedBhaagValue = _linkedNagarValue = null;
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar', '', isAbhiyaan: false);
    setState(() => _linkedVibhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedBhaagDropdown(String vibhaagIDStr) async {
    _linkedNagarValue = null;
    //_linkedbhaagName = _linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedBhaag = _linkedNagar = [];
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '', isAbhiyaan: false);
    setState(() => _linkedBhaag = data);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkedNagarValue = null;
    //_linkednagarName = _linkedmandalName = _linkedgraamName = _linkedvastiName = null;
    _linkedNagar = null;
    final parentID = shaharIDStr ?? bhaagIDStr!;
    final parentType = shaharIDStr != null ? 'Shahar' : 'Bhaag';
    final data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), parentID, parentType, '', isAbhiyaan: false);
    setState(() => _linkedNagar = data.isNotEmpty ? data : null);
    return data;
  }

  Future<List<GeoUnitMasterBAL>> populatelinkedUpnagarDropdown(String? nagarIDStr) async {
    var mnDD;
    mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['UpaNagarLevelID'].toString(), nagarIDStr!, 'Nagar', '');
    setState(() {
      _linkedupnagar = (mnDD.length > 0 ? mnDD : null);
    });
    return mnDD;
  }

  // void populatelinkedMahaanagarDropdown() async {
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MahaanagarLevelID'].toString(), '', '', '');
  //   setState(() {
  //     _linkedMahaanagar = data;
  //   });
  // }
  //
  // void populatelinkedVibhaagDropdown(String mahaanagarIDStr) async {
  //   _linkedBhaagValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VibhaagLevelID'].toString(), mahaanagarIDStr, (mahaanagarIDStr.isEmpty ? '' : 'Mahaanagar'), '');
  //   setState(() {
  //     _linkedVibhaag = data;
  //   });
  // }
  //
  // void populatelinkedBhaagDropdown(String vibhaagIDStr) async {
  //   _linkedShaharValue = _linkedNagarValue = null;
  //   var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), vibhaagIDStr, 'Vibhaag', '');
  //   setState(() {
  //     _linkedBhaag = data;
  //   });
  // }
  //
  // void populatelinkedShaharDropdown(String? bhaagIDStr) async {
  //   _linkedShaharValue = _linkedShahar = null;
  //   var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
  //   setState(() {
  //     _linkedShahar = (shDD.length > 0 ? shDD : null);
  //   });
  // }
  //
  // void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
  //   _linkedNagarValue = null;
  //   _linkedNagar = null;
  //   if (shaharIDStr != null) {
  //     var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
  //     setState(() {
  //       _linkedNagar = (ngDD.length > 0 ? ngDD : null);
  //     });
  //   } else {
  //     var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
  //     setState(() {
  //       _linkedNagar = (ngDD.length > 0 ? ngDD : null);
  //     });
  //   }
  // }

  Future<dynamic> _getEkatritVrutta(int baithakTypeID, int? geoID) async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      String strInput = json.encode({
        "AppUserID": Statics.userDetails['userID'],
        "AnnualBaithakTypeID": baithakTypeID,
        "GeoUnitID": geoID,
      });
      dynamic retVal = await Statics.getAnnualBaithakEkatritVruttaForApp(strInput);
      return retVal;
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return null;
    }
  }

  Future<void> _search() async {
    setState(() {
      _isSearching = true;
    });
    int? mahaanagarVal = _linkedMahaanagarValue == null || _linkedMahaanagarValue == "" ? null : int.parse(_linkedMahaanagarValue!);
    int? vibhaagVal = _linkedVibhaagValue == null || _linkedVibhaagValue == "" ? null : int.parse(_linkedVibhaagValue!);
    int? bhaagVal = _linkedBhaagValue == null || _linkedBhaagValue == "" ? null : int.parse(_linkedBhaagValue!);
    int? shaharVal = _linkedShaharValue == null || _linkedShaharValue == "" ? null : int.parse(_linkedShaharValue!);
    int? nagarVal = _linkedNagarValue == null || _linkedNagarValue == "" ? null : int.parse(_linkedNagarValue!);
    int? upnagar = _linkedupnagarValue == null || _linkedupnagarValue == '' ? null : int.parse(_linkedupnagarValue!);
    geoID = (upnagar != null ? upnagar : (nagarVal != null ? nagarVal : (bhaagVal != null ? bhaagVal : (vibhaagVal != null ? vibhaagVal : (mahaanagarVal != null ? mahaanagarVal : null)))));
    _baithakType = _baithakTypeValue == null || _baithakTypeValue == "" ? null : int.parse(_baithakTypeValue!);
    //print("printing all selected things:${mahaanagarVal} :${vibhaagVal} :${bhaagVal} :${nagarVal} :${upnagar} :${_baithakType} :${_baithakTypeYear}");
    _geoLevel = (upnagar != null ? 13 : (nagarVal != null ? 6 : (bhaagVal != null ? 7 : (vibhaagVal != null ? 8 : (mahaanagarVal != null ? 9 : 10)))));

    dynamic obj;
    if (_baithakType != null) {
      obj = await _getEkatritVrutta(_baithakType!, geoID);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('baithakTypeNotSelected'));
    }

    setState(() {
      if (_baithakType == null) {
        _ekatritVrutta = null;
        _selectedBaithak = '';
        _selectedNagarAndBaithak = '';
      } else {
        _selectedBaithak = _baithakTypes!.firstWhere((element) => element.staticID == _baithakType).codeForDisplay;
        log("obj $obj");
        _ekatritVrutta = obj;
        _hasGraaminKshetra = (_ekatritVrutta['HasGraaminKshetra'].toString() == '1' ? true : false);
        _selectedNagarAndBaithak = (mahaanagarVal == null ? '' : _linkedMahaanagar!.firstWhere((element) => element.geoUnitID == mahaanagarVal).name!) +
            ' | ' +
            (vibhaagVal == null ? ' - ' : _linkedVibhaag!.firstWhere((element) => element.geoUnitID == vibhaagVal).name!) +
            ' | ' +
            (bhaagVal == null ? ' - ' : _linkedBhaag!.firstWhere((element) => element.geoUnitID == bhaagVal).name!) +
            ' | ' +
            (nagarVal == null ? ' - ' : _linkedNagar!.firstWhere((element) => element.geoUnitID == nagarVal).name!) +
            ' | ' +
            (upnagar == null ? '-' : _linkedupnagar!.firstWhere((element) => element.geoUnitID == upnagar).name!);
      }

      _isSearching = false;
      _isExpanded = false;
    });
  }

  Future<void> takeScreenShot() async {
    try {
      final boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final customDir = Directory('${directory.path}/MyCustomFolder');

      if (!(await customDir.exists())) {
        await customDir.create(recursive: true); // Create the folder
      }

      final imgFile = File('${customDir.path}/screenshot.png');
      await imgFile.writeAsBytes(pngBytes);

      print("Screenshot saved to ${imgFile.path}");

      final pdf = pw.Document();
      final pageWidth = 595.27; // A4 page width in points
      final pageHeight = 841.89; // A4 page height in points

      final imgWidth = image.width.toDouble();
      final imgHeight = image.height.toDouble();

// Calculate the number of pages needed
      final numPages = (imgHeight / pageHeight).ceil();

      for (int pageNum = 0; pageNum < numPages; pageNum++) {
        final yOffset = pageNum * pageHeight;

        final imgPage = await _cropImage(
          pngBytes,
          imgWidth,
          imgHeight,
          pageWidth,
          pageHeight,
          yOffset,
        );

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(pw.MemoryImage(imgPage), fit: pw.BoxFit.contain),
              );
            },
          ),
        );
      }

      final pdfBytes = await pdf.save();
      final pdfFile = File('${customDir.path}/screenshot.pdf');
      await pdfFile.writeAsBytes(pdfBytes);

      print("PDF saved to ${pdfFile.path}");
      final result = await OpenFilex.open(pdfFile.path);
      print("Open file result: ${result.message}");
    } catch (e) {
      print("Error taking screenshot: $e");
    }
  }

  Future<Uint8List> _cropImage(
    Uint8List imageBytes,
    double imgWidth,
    double imgHeight,
    double pageWidth,
    double pageHeight,
    double yOffset,
  ) async {
    // Decode the image
    final image = await decodeImageFromList(imageBytes);

    // Calculate the portion of the image to draw
    final cropHeight = (pageHeight < imgHeight - yOffset) ? pageHeight : imgHeight - yOffset;
    final cropRect = Rect.fromLTWH(0, yOffset, imgWidth, cropHeight);

    // Calculate the scale to fit the image within the page width while keeping aspect ratio
    final scale = pageWidth / imgWidth;
    final scaledHeight = cropHeight * scale;

    // Create an image recorder
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, pageWidth, scaledHeight));

    // Draw the cropped part of the image
    canvas.drawImageRect(
      image,
      cropRect,
      Rect.fromLTWH(0, 0, pageWidth, scaledHeight),
      Paint(),
    );

    // End recording
    final picture = recorder.endRecording();
    final img = await picture.toImage(pageWidth.toInt(), scaledHeight.toInt());

    // Convert to PNG
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> redirctToList(String? type, String? annualBaithakTypeID, int? geoUnitID, String? infoName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      try {
        String strInput = json.encode({"AppUserID": Statics.userDetails['userID'], "AnnualBaithakTypeID": int.parse(annualBaithakTypeID!), "GeoUnitID": geoUnitID, "type": type});

        SankalitBaithakVruttaDataNamesModel? dataModel = await Statics.getSankalitBaithakVruttaDataNames(strInput);

        Navigator.of(context).pop(); // Close the loader

        if (dataModel != null && dataModel.listname != null) {
          Navigator.of(context).pushNamed(
            SankalitDataNamesView.routeName,
            arguments: {
              'listname': dataModel.listname,
              'infoName': infoName,
            },
          );
        } else {
          Statics.showMessageDialog(context, Statics.getLabel('NoDataAvailable'));
        }
      } catch (e) {
        Navigator.of(context).pop();
        Statics.showMessageDialog(context, Statics.getLabel('ErrorOccurred'));
      }
    } else {
      Navigator.of(context).pop();
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Statics.getLabel('annualBaithakEkatritVruttaTitle'),
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => TulnatmakBaithakEkatritVrutta()));
              },
              icon: Icon(Icons.balance_rounded))
        ],
      ),
      floatingActionButton: donloadexportList != []
          ? FloatingActionButton(
              mini: true,
              tooltip: Statics.getLabel("ExportToExcel"),
              onPressed: () async {
                takeScreenShot();
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV file saved successfully')));
              },
              child: Icon(Icons.download_sharp),
              backgroundColor: Colors.green,
            )
          : Container(),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: Statics.getDeviceSize(context).width,
          child: Column(
            children: <Widget>[
              Text(
                Statics.getLabel('annualBaithakEkatritVruttaBanner'),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isExpanded = isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(Statics.getLabel('Filters')),
                      );
                    },
                    body: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          if (_linkedMahaanagar != null)
                            buildDropdownField(
                              label: Statics.getLabel('Mahaanagar'),
                              value: _linkedMahaanagarValue,
                              items: _linkedMahaanagar!
                                  .map((bg) => DropdownMenuItem(
                                        value: bg.geoUnitID.toString(),
                                        child: Text(bg.name!),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                print("Mahaanagar---   $value");
                                setState(() {
                                  _linkedMahaanagarValue = value;
                                  _linkedVibhaagValue = null;
                                  _linkedBhaagValue = null;
                                  _linkedShaharValue = null;
                                  _linkedNagarValue = null;
                                  _linkedupnagarValue = null;
                                  mahanagarId = value;
                                  _selectedGeoUnitId = value;
                                });
                                populatelinkedVibhaagDropdown(value!);
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedVibhaag != null)
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: Statics.getLabel('Vibhaag')),
                              isExpanded: true,
                              value: _linkedVibhaagValue == "" ? null : _linkedVibhaagValue,
                              items: _linkedVibhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                print("Vibhaag---   $value");
                                setState(() {
                                  _linkedVibhaagValue = value;
                                  _linkedBhaagValue = null;
                                  _linkedShaharValue = null;
                                  _linkedNagarValue = null;
                                  _selectedGeoUnitId = value;
                                  vibhagId = value;
                                });
                                populatelinkedBhaagDropdown(value!);
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_linkedBhaag != null)
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _linkedBhaagValue == "" ? null : _linkedBhaagValue,
                              items: _linkedBhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                print("Bhaag---   $value");
                                setState(() {
                                  _linkedBhaagValue = value;
                                  _linkedShaharValue = null;
                                  _selectedGeoUnitId = value;
                                  _linkedNagarValue = null;
                                });
                                populatelinkedNagarDropdown(value, null);
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          // if (_linkedShahar != null && _linkedShahar!.length > 0)
                          //   DropdownButtonFormField(
                          //     decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                          //     isExpanded: true,
                          //     value: _linkedShaharValue == "" ? null : _linkedShaharValue,
                          //     items: _linkedShahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                          //     onChanged:MyAppGlobals.isDropdownDisabled('Mahaanagar')
                          //         ? null
                          //         :  (value) {
                          //       print("Shahar---   $value");
                          //       setState(() {
                          //         _linkedShaharValue = value;
                          //         populatelinkedNagarDropdown(null, value);
                          //         _linkedNagarValue = null;
                          //       });
                          //     },
                          //   ),
                          // if (_linkedShahar != null && _linkedShahar!.length > 0)
                          //   SizedBox(
                          //     height: 10,
                          //   ),
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                              isExpanded: true,
                              value: _linkedNagarValue == "" ? null : _linkedNagarValue,
                              items: _linkedNagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                print("Nagar---   $value");
                                setState(() {
                                  _linkedNagarValue = value;
                                  _selectedGeoUnitId = value;
                                });
                                // populatelinkedUpnagarDropdown(value);
                              },
                            ),
                          if (_linkedNagar != null && _linkedNagar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          //--------------new dropdown added----------------------//
                          /*if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                            buildDropdownField(
                              isDisabled: false,
                              label: Statics.getLabel('upnagarUpkhanda'),
                              value: _linkedupnagarValue,
                              items: _linkedupnagar!
                                  .map((bg) => DropdownMenuItem(
                                        value: bg.geoUnitID.toString(),
                                        child: Text(bg.name!),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                final selectedItem = _linkedupnagar!.firstWhere((bg) => bg.geoUnitID.toString() == value);
                                setState(() {
                                  _linkedupnagarValue = value;
                                  _selectedGeoUnitId = value;
                                  _selctedLevel = 'upnagarUpkhanda';
                                  _selctedLevelName = selectedItem.name ?? "";
                                  populatelinkedVastiDropdown(value!);
                                  populatelinkedMandalDropdown(true, value);
                                  populatelinkedNagarDropdown(null, value);
                                });
                              },
                            ),
                            if (_linkedupnagar != null && _linkedupnagar!.isNotEmpty)
                            SizedBox(
                              height: 10,
                            ),*/
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionYear')),
                            isExpanded: true,
                            value: _baithakTypeYear == "" ? null : _baithakTypeYear,
                            items: _baithakTypes
                                ?.map((bg) => bg.monthYear.toString().split(',').last)
                                .toSet()
                                .map((year) => DropdownMenuItem(
                                      value: year,
                                      child: Text(year),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              print("Year ---==>  $value");
                              setState(() {
                                _baithakTypeYear = value;
                                _baithakTypeValue = null;
                              });
                            },
                          ),

                          SizedBox(height: 10),

                          if (_baithakTypes != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('baithakType')),
                              isExpanded: true,
                              value: _baithakTypeValue == "" ? null : _baithakTypeValue,
                              items: _baithakTypes!
                                  .where((bg) => bg.monthYear.toString().split(',').last == _baithakTypeYear)
                                  .map((bg) => DropdownMenuItem(
                                        value: bg.staticID.toString(),
                                        child: Text(bg.codeForDisplay!),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _baithakTypeValue = value;
                                });
                              },
                            ),

                          // DropdownButtonFormField(
                          //   decoration: InputDecoration(labelText: Statics.getLabel('SankalpCompletionYear')),
                          //   isExpanded: true,
                          //   value: _baithakTypeYear == "" ? null : _baithakTypeYear,
                          //   items: _baithakTypes
                          //       ?.map((bg) => bg.monthYear.toString().split(',').last) // Extracting only year
                          //       .toSet() // Removing duplicates
                          //       .map((year) => DropdownMenuItem(
                          //     value: year,
                          //     child: Text(year),
                          //   ))
                          //       .toList(),
                          //   onChanged: (value) {
                          //     print("Year ---==>  $value");
                          //     setState(() {
                          //       _baithakTypeYear = value;
                          //     });
                          //   },
                          // ),
                          //
                          // SizedBox(
                          //     height: 10,
                          //   ),
                          // if(_baithakTypes != null)
                          // DropdownButtonFormField(
                          //   decoration: InputDecoration(labelText: Statics.getLabel('baithakType')),
                          //   isExpanded: true,
                          //   value: _baithakTypeValue == "" ? null : _baithakTypeValue,
                          //   items:
                          //       _baithakTypes!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _baithakTypeValue = value;
                          //     });
                          //   },
                          // ),
                          //   DropdownSearch<String>(
                          //     popupProps: PopupProps.bottomSheet(
                          //       showSearchBox: true,
                          //       fit: FlexFit.tight, // Ensures the popup width matches the dropdown width
                          //       itemBuilder: (context, item, isSelected) {
                          //         return Container(
                          //           margin: EdgeInsets.symmetric(horizontal: 8),
                          //           decoration: !isSelected
                          //               ? null
                          //               : BoxDecoration(
                          //             border: Border.all(color: Theme.of(context).primaryColor),
                          //             borderRadius: BorderRadius.circular(5),
                          //             color: Colors.grey[300],
                          //           ),
                          //           child: ListTile(
                          //             title: Text(
                          //               item,
                          //               style: TextStyle(fontSize: 14), // Adjust the font size here
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //       searchFieldProps: TextFieldProps(
                          //         decoration: InputDecoration(
                          //           border: OutlineInputBorder(),
                          //           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          //         ),
                          //       ),
                          //       constraints: BoxConstraints.tightFor(
                          //         width: double.infinity, // Ensures the popup width matches the dropdown width
                          //       ),
                          //     ),
                          //     items: _baithakTypes!.map((bg) => bg.codeForDisplay!).toList(),
                          //     dropdownDecoratorProps: DropDownDecoratorProps(
                          //       dropdownSearchDecoration: InputDecoration(
                          //         labelText: Statics.getLabel('baithakType'),
                          //       ),
                          //     ),
                          //     selectedItem: _baithakTypeValue == "" ? null : _baithakTypes?.firstWhere((element) => element.staticID.toString() == _baithakTypeValue).codeForDisplay,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         _baithakTypeValue = _baithakTypes!.firstWhere((element) => element.codeForDisplay == value).staticID.toString();
                          //       });
                          //     },
                          //   ),
                          //   DropdownSearch<String>(
                          //     popupProps: PopupProps.bottomSheet(
                          //       showSearchBox: true,
                          //       fit: FlexFit.tight, // Ensures the popup width matches the dropdown width
                          //       itemBuilder: (context, item, isSelected) {
                          //         return Container(
                          //           margin: EdgeInsets.symmetric(horizontal: 8),
                          //           decoration: !isSelected
                          //               ? null
                          //               : BoxDecoration(
                          //             border: Border.all(color: Theme.of(context).primaryColor),
                          //             borderRadius: BorderRadius.circular(5),
                          //             color: Colors.grey[300],
                          //           ),
                          //           child: ListTile(
                          //             title: Text(
                          //               item,
                          //               style: TextStyle(fontSize: 14), // Adjust the font size here
                          //             ),
                          //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8), // Adjust padding here
                          //             visualDensity: VisualDensity(vertical: -4), // Adjust density here
                          //           ),
                          //         );
                          //       },
                          //       searchFieldProps: TextFieldProps(
                          //         decoration: InputDecoration(
                          //           border: OutlineInputBorder(),
                          //           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          //         ),
                          //       ),
                          //       constraints: BoxConstraints.tightFor(
                          //         width: double.infinity, // Ensures the popup width matches the dropdown width
                          //       ),
                          //       containerBuilder: (context, popupWidget) {
                          //         return Stack(
                          //           children: [
                          //             popupWidget,
                          //             Positioned(
                          //               right: 10,
                          //               top: 10,
                          //               child: IconButton(
                          //                 icon: Icon(Icons.close),
                          //                 onPressed: () {
                          //                   Navigator.of(context).pop(); // Close the dropdown
                          //                 },
                          //               ),
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //     ),
                          //     items: _baithakTypes!.map((bg) => bg.codeForDisplay!).toList(),
                          //     dropdownDecoratorProps: DropDownDecoratorProps(
                          //       dropdownSearchDecoration: InputDecoration(
                          //         labelText: Statics.getLabel('baithakType'),
                          //       ),
                          //     ),
                          //     selectedItem: _baithakTypeValue == "" ? null : _baithakTypes?.firstWhere((element) => element.staticID.toString() == _baithakTypeValue).codeForDisplay,
                          //     onChanged: (value) {
                          //       print(value);
                          //             setState(() {
                          //               _baithakTypeValue = _baithakTypes!.firstWhere((element) => element.codeForDisplay == value).staticID.toString();
                          //             });
                          //     },
                          //   ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    isExpanded: _isExpanded,
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Wrap(
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
                            _search();
                          },
                          child: Text(
                            Statics.getLabel('Search'),
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        MaterialButton(
                            onPressed: () async {
                              setState(() {
                                mahanagarId = _linkedMahaanagarValue = _linkedVibhaagValue = _linkedBhaagValue = _linkedShaharValue = _linkedNagarValue = _linkedupnagarValue = _baithakType = null;
                                _linkedMahaanagar = _linkedVibhaag = _linkedBhaag = _linkedShahar = _linkedNagar = _linkedupnagar = null;
                                _baithakTypeValue = _selectedNagarAndBaithak = '';
                                _baithakTypeYear = null;
                                _ekatritVrutta = null;
                                _isSearching = false;
                                _selectedBaithak = '';
                              });
                              //populatelinkedBhaagDropdown();
                              await populateDropdown();
                            },
                            child: Text(Statics.getLabel('clear'))),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isSearching) CircularProgressIndicator(),
              if (_ekatritVrutta != null)
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(_selectedBaithak!, style: TextStyle(fontSize: 18)),
                        Text(_selectedNagarAndBaithak, style: TextStyle(fontSize: 15)),
                        // Legend(legendString: "bhaugolikRachanaa", fontsize: 18),
                        // //if (_geoLevel >= 10)
                        // Column(
                        //   children: [
                        //     SingleColumnRow(txtString: Statics.getLabel('mahaanagar') + ':-', value: '', fontsize: 18),
                        //     TwoColumnRow(
                        //       txtString: Statics.getLabel('sambhaagSam'),
                        //       value: _ekatritVrutta['SambhagSam'].toString(),
                        //       txtString2: Statics.getLabel('vibhaagSam'),
                        //       value2: _ekatritVrutta['VibhaagSam'].toString(),
                        //       fontsize: 15,
                        //     ),
                        //     SingleColumnRow(txtString: Statics.getLabel('bhaagSam'), value: _ekatritVrutta['JilhaSam'].toString(), fontsize: 15),
                        //   ],
                        // ),
                        // TwoColumnRow(
                        //   txtString: Statics.getLabel('bhaagCount'),
                        //   value: _ekatritVrutta['BhaagCount'].toString(),
                        //   txtString2: Statics.getLabel('nagarCount'),
                        //   value2: _ekatritVrutta['NagarCount'].toString(),
                        //   fontsize: 15,
                        // ),
                        // SingleColumnRow(txtString: Statics.getLabel('vastiCount'), value: _ekatritVrutta['VastiCount'].toString(), fontsize: 15),
                        //
                        // //if (_hasGraaminKshetra == true)
                        // SingleColumnRow(txtString: Statics.getLabel('graamin') + ':-', value: '', fontsize: 18),
                        // TwoColumnRow(
                        //   txtString: Statics.getLabel('vibhaagCount'),
                        //   value: _ekatritVrutta['GraaminVibhaagCount'].toString(),
                        //   txtString2: Statics.getLabel('jilhaCount'),
                        //   value2: _ekatritVrutta['GraaminJilhaCount'].toString(),
                        //   fontsize: 15,
                        // ),
                        // TwoColumnRow(
                        //   txtString: Statics.getLabel('taalukaaCount'),
                        //   value: _ekatritVrutta['GraaminTaalukaaCount'].toString(),
                        //   txtString2: Statics.getLabel('mandalCount'),
                        //   value2: _ekatritVrutta['GraaminMandalCount'].toString(),
                        //   fontsize: 15,
                        // ),
                        // TwoColumnRow(
                        //   txtString: Statics.getLabel('nagarCount'),
                        //   value: _ekatritVrutta['GraaminNagarCount'].toString(),
                        //   txtString2: Statics.getLabel('vastiCount'),
                        //   value2: _ekatritVrutta['GraaminVastiCount'].toString(),
                        //   fontsize: 15,
                        // ),
                        SizedBox(
                          height: 20,
                        ),

                        Legend(legendString: "kaaryaSthitiBhaugolik", fontsize: 18),

                        // Visibility(
                        //     visible: mahanagarId =="1" || vibhagId !="78"&& vibhagId !="79"&& vibhagId !="80"&& vibhagId !="81",
                        //     child:
                        Column(
                          children: [
                            SizedBox(
                              height: 7,
                            ),
                            SingleColumnRow(
                                txtString: Statics.getLabel('mahaanagar') + ':-',
                                value: '',
                                fontsize: 18,
                                view: true,
                                btnAction: () {
                                  redirctToList("mahanagar", _baithakType.toString(), geoID, Statics.getLabel('mahaanagar'));
                                }),
                            NewFourColumnRow(
                              txtString: Statics.getLabel('sambhaagSam'),
                              value: _ekatritVrutta['SambhagSam'].toString(),
                              txtString2: Statics.getLabel('vibhaagSam'),
                              value2: _ekatritVrutta['VibhaagSam'].toString(),
                              txtString3: Statics.getLabel('bhaagSam'),
                              value3: _ekatritVrutta['JilhaSam'].toString(),
                              txtString4: Statics.getLabel('bhaagCount'),
                              value4: _ekatritVrutta['BhaagCount'].toString(),
                              fontsize: 15,
                            ),

                            Container(
                              width: Statics.getDeviceSize(context).width,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            // =====================================================
                            SizedBox(
                              height: 7,
                            ),
                            NewFiveColumnRow(
                              txtString: Statics.getLabel('nagarCount'),
                              value: _ekatritVrutta['NagarCount'].toString(),
                              txtString2: Statics.getLabel('shaakhaaYuktaNagar').replaceAll(" ", "\n"),
                              value2: _ekatritVrutta['MahaanagarShaakhaaYuktaNagarCount'].toString(),
                              txtString3: 'मिलनयुक्त\nनगर',
                              value3: _ekatritVrutta['MahaanagarSamparkYuktaNagarCount'].toString(),
                              txtString4: Statics.getLabel('nagarWithMin2Shaakhaa'),
                              value4: _ekatritVrutta['MahaanagarMin2ShaakhaaYuktaNagarCount'].toString(),
                              txtString5: 'मंडळी युक्त नगर',
                              value5: _ekatritVrutta['MahaanagarMaasikYuktaNagarCount'].toString(),
                              fontsize: 15,
                            ),
                            Container(
                              width: Statics.getDeviceSize(context).width,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        // )
// ==================================  ANYA NAGAR ==============================================================
                        // Visibility(
                        //     visible:mahanagarId !="1" && vibhagId !="73" && vibhagId !="74" && vibhagId !="75" && vibhagId !="76",
                        //     child:
                        Column(
                          children: [
                            SizedBox(
                              height: 7,
                            ),
                            SingleColumnRow(
                                txtString: Statics.getLabel('anyaNagar') + ':-',
                                value: '',
                                fontsize: 18,
                                view: true,
                                btnAction: () {
                                  redirctToList("anyaNagar", _baithakType.toString(), geoID, Statics.getLabel('anyaNagar'));
                                }),
                            NewFiveColumnRow(
                              // txtString: Statics.getLabel('Total')+" "+Statics.getLabel('nagarCount'),
                              txtString: Statics.getLabel('nagarCount').toString(),
                              value: _ekatritVrutta['GraaminNagarCount'].toString(),
                              txtString2: Statics.getLabel('shaakhaaYuktaNagar').replaceAll(" ", "\n"),
                              value2: _ekatritVrutta['AnyaNagarShaakhaaYuktaNagarCount'].toString(),
                              txtString3: 'मिलनयुक्त\nनगर',
                              value3: _ekatritVrutta['AnyaNagarSamparkYuktaNagarCount'].toString(),
                              txtString4: Statics.getLabel('nagarWithMin2Shaakhaa'),
                              value4: _ekatritVrutta['AnyaNagarMin2ShaakhaaYuktaNagarCount'].toString(),
                              txtString5: 'मंडळी युक्त नगर',
                              value5: _ekatritVrutta['AnyaNagarMaasikYuktaNagarCount'].toString(),
                              fontsize: 15,
                            ),
                            Container(
                              width: Statics.getDeviceSize(context).width,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            SingleColumnRow(
                                txtString: "एकूण " + Statics.getLabel('nagarCount').split(" ").first + ':-',
                                value: '',
                                fontsize: 18,
                                view: true,
                                btnAction: () {
                                  redirctToList("nagarCountTotal", _baithakType.toString(), geoID, "एकूण " + Statics.getLabel('nagarCount').split(" ").first);
                                }),
                            NewFiveColumnRow(
                              txtString: "एकूण\n" + Statics.getLabel('nagarCount'),
                              value: (int.parse(_ekatritVrutta['GraaminNagarCount'].toString()) + int.parse(_ekatritVrutta['NagarCount'].toString())).toString(),

                              txtString2: "एकूण\n" + Statics.getLabel('shaakhaaYuktaNagar').replaceAll(" ", "\n"),
                              value2: "${(int.parse(_ekatritVrutta['AnyaNagarShaakhaaYuktaNagarCount'].toString()) + int.parse(_ekatritVrutta['MahaanagarShaakhaaYuktaNagarCount'].toString()))}",

                              txtString3: "एकूण\n" + 'मिलनयुक्त\nनगर',
                              value3: "${(int.parse(_ekatritVrutta['AnyaNagarSamparkYuktaNagarCount'].toString()) + int.parse(_ekatritVrutta['MahaanagarSamparkYuktaNagarCount'].toString()))}",

                              txtString4: "एकूण\n" + Statics.getLabel('nagarWithMin2Shaakhaa'),
                              value4:
                                  "${(int.parse(_ekatritVrutta['AnyaNagarMin2ShaakhaaYuktaNagarCount'].toString()) + int.parse(_ekatritVrutta['MahaanagarMin2ShaakhaaYuktaNagarCount'].toString()))}",

                              txtString5: 'एकूण मंडळी युक्त नगर',
                              value5: "${(int.parse(_ekatritVrutta['AnyaNagarMaasikYuktaNagarCount'].toString()) + int.parse(_ekatritVrutta['MahaanagarMaasikYuktaNagarCount'].toString()))}",
                              // value5: "",
                              fontsize: 15,
                            ),
                            Container(
                              width: Statics.getDeviceSize(context).width,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SingleColumnRow(
                                txtString: Statics.getLabel('graaminTaaluka') + ':-',
                                value: '',
                                fontsize: 18,
                                view: true,
                                btnAction: () {
                                  redirctToList("graaminTaaluka", _baithakType.toString(), geoID, Statics.getLabel('graaminTaaluka'));
                                }),
                            NewThreeColumnRow(
                              txtString: Statics.getLabel('graaminTaaluka') + "\n" + Statics.getLabel('nagarCount').split(" ").last,
                              value: _ekatritVrutta['GraaminTaalukaaCount'].toString(),
                              txtString2: Statics.getLabel('shaakhaaYukta') + " " + Statics.getLabel('graaminTaaluka'),
                              value2: _ekatritVrutta['ShaakhaaYuktaTaalukaaCount'].toString(),
                              txtString3: Statics.getLabel('shaakhaaYuktaTaalukaaKendra'),
                              value3: _ekatritVrutta['ShaakhaaYuktaTaalukaaKendraCount'].toString(),
                              fontsize: 15,
                            ),
                            Container(
                              width: Statics.getDeviceSize(context).width,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SingleColumnRow(
                                txtString: 'मंडळ:-',
                                value: '',
                                fontsize: 18,
                                view: true,
                                btnAction: () {
                                  redirctToList("mandal", _baithakType.toString(), geoID, "मंडळ");
                                }),
                            NewFourColumnRow(
                              txtString: "मंडळ\n" + Statics.getLabel('nagarCount').split(" ").last,
                              value: _ekatritVrutta['GraaminMandalCount'].toString(),
                              txtString2: Statics.getLabel('shaakhaaYukta') + "\nमंडळ",
                              value2: _ekatritVrutta['ShaakhaaYuktaMandalCount'].toString(),
                              txtString3: Statics.getLabel('saaptaahikYuktaMandal'),
                              value3: _ekatritVrutta['SaaptaahikYuktaMandalCount'].toString(),
                              txtString4: Statics.getLabel('samparkYuktaMandal'),
                              value4: _ekatritVrutta['SamparkYuktaMandalCount'].toString(),
                              fontsize: 15,
                            ),
                            Container(
                              width: Statics.getDeviceSize(context).width,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SingleColumnRow(txtString: Statics.getLabel('mahaanagar') + " वस्ती" + ':-', value: '', fontsize: 18),
                            NewFourColumnRow(
                              txtString: Statics.getLabel('mahaanagar') + "\n" + Statics.getLabel('vastiCount'),
                              value: _ekatritVrutta['VastiCount'].toString(),
                              txtString2: Statics.getLabel('mahaanagar') + "\n" + Statics.getLabel('shaakhaaYuktaVasti'),
                              value2: _ekatritVrutta['MahaanagarShaakhaaYuktaVastiCount'].toString(),
                              txtString3: Statics.getLabel('mahaanagar') + "\nमंडळीयुक्त वस्ती",
                              value3: _ekatritVrutta['MahaanagarMaasikYuktaVastiCount'].toString(),
                              txtString4: Statics.getLabel('mahaanagar') + "\n" + Statics.getLabel('samparkYuktaVasti'),
                              value4: _ekatritVrutta['MahaanagarSamparkYuktaVastiCount'].toString(),
                              fontsize: 15,
                            ),
                            Container(
                              width: Statics.getDeviceSize(context).width,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SingleColumnRow(txtString: Statics.getLabel('anyaNagar') + " वस्ती" ':-', value: '', fontsize: 18),
                            NewFourColumnRow(
                              txtString: Statics.getLabel('anyaNagar') + "\n" + Statics.getLabel('vastiCount'),
                              value: _ekatritVrutta['GraaminVastiCount'].toString(),
                              txtString2: Statics.getLabel('anyaNagar') + "\n" + Statics.getLabel('shaakhaaYuktaVasti'),
                              value2: _ekatritVrutta['AnyaNagarShaakhaaYuktaVastiCount'].toString(),
                              txtString3: Statics.getLabel('anyaNagar') + "\nमंडळीयुक्त वस्ती",
                              value3: _ekatritVrutta['AnyaNagarMaasikYuktaVastiCount'].toString(),
                              txtString4: Statics.getLabel('anyaNagar') + "\n" + Statics.getLabel('samparkYuktaVasti'),
                              value4: _ekatritVrutta['AnyaNagarSamparkYuktaVastiCount'].toString(),
                              fontsize: 15,
                            ),
                            Container(
                              width: Statics.getDeviceSize(context).width,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SingleColumnRow(
                                txtString: "एकूण " + Statics.getLabel('vastiCount').split(" ").first + ':-',
                                value: '',
                                fontsize: 18,
                                view: true,
                                btnAction: () {
                                  redirctToList("vasti", _baithakType.toString(), geoID, Statics.getLabel('vastiCount'));
                                }),
                            NewFourColumnRow(
                              txtString: "एकूण\n" + Statics.getLabel('vastiCount'),
                              value: (int.parse(_ekatritVrutta['GraaminVastiCount'].toString()) + int.parse(_ekatritVrutta['VastiCount'].toString())).toString(),
                              txtString2: "एकूण\n" + Statics.getLabel('shaakhaaYuktaVasti'),
                              value2: (int.parse(_ekatritVrutta['AnyaNagarShaakhaaYuktaVastiCount'].toString()) + int.parse(_ekatritVrutta['MahaanagarShaakhaaYuktaVastiCount'].toString())).toString(),
                              txtString3: "एकूण\nमंडळीयुक्त वस्ती",
                              value3: (int.parse(_ekatritVrutta['AnyaNagarMaasikYuktaVastiCount'].toString()) + int.parse(_ekatritVrutta['MahaanagarMaasikYuktaVastiCount'].toString())).toString(),
                              txtString4: "एकूण\n" + Statics.getLabel('samparkYuktaVasti'),
                              value4: (int.parse(_ekatritVrutta['AnyaNagarSamparkYuktaVastiCount'].toString()) + int.parse(_ekatritVrutta['MahaanagarSamparkYuktaVastiCount'].toString())).toString(),
                              fontsize: 15,
                            ),
                            Container(
                              width: Statics.getDeviceSize(context).width,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),

                            // SingleColumnRow(txtString: Statics.getLabel('nagarWithMin2Shaakhaa'), value: _ekatritVrutta['AnyaNagarMinTwoShaakhaaCount'].toString(), fontsize: 15),
                            // SingleColumnRow(txtString: Statics.getLabel('graaminJilha') + ':-', value: '', fontsize: 18),
                            // SingleColumnRow(
                            //     txtString: Statics.getLabel('shaakhaaYukta'), value: _ekatritVrutta['ShaakhaaYuktaJilhaCount'].toString(), fontsize: 15),
                            // SingleColumnRow(
                            //     txtString: Statics.getLabel('jilhaKendraWith5Shaakhaa'),
                            //     value: _ekatritVrutta['MinFiveShaakhaaJilhaKendraCount'].toString(),
                            //     fontsize: 15),
                            // SingleColumnRow(txtString: Statics.getLabel('graaminTaaluka') + ':-', value: '', fontsize: 18),
                            // SingleColumnRow(txtString: Statics.getLabel('shaakhaaYukta'), value: _ekatritVrutta['ShaakhaaYuktaTaalukaaCount'].toString(), fontsize: 15),
                            // SingleColumnRow(txtString: Statics.getLabel('shaakhaaYuktaTaalukaaKendra'), value: _ekatritVrutta['ShaakhaaYuktaTaalukaaKendraCount'].toString(), fontsize: 15),
                            // SingleColumnRow(txtString: Statics.getLabel('Mandal') + ':-', value: '', fontsize: 18),
                            // TwoColumnRow(
                            //   txtString: Statics.getLabel('shaakhaaYukta'),
                            //   value: _ekatritVrutta['ShaakhaaYuktaMandalCount'].toString(),
                            //   txtString2: Statics.getLabel('saaptaahikYuktaMandal'),
                            //   value2: _ekatritVrutta['SaaptaahikYuktaMandalCount'].toString(),
                            //   fontsize: 15,
                            // ),
                            // SingleColumnRow(
                            //     txtString: Statics.getLabel('samparkYuktaMandal'), value: _ekatritVrutta['SamparkYuktaMandalCount'].toString(), fontsize: 15),
                            // SingleColumnRow(txtString: Statics.getLabel('sthaan') + ':-', value: '', fontsize: 18),
                            SingleColumnRow(
                                txtString: Statics.getLabel('sthaan') + ':-',
                                value: '',
                                fontsize: 18,
                                view: true,
                                btnAction: () {
                                  redirctToList("sthaan", _baithakType.toString(), geoID, Statics.getLabel('sthaan'));
                                }),
                            NewThreeColumnRow(
                              txtString: 'महानगरीय\nस्थान',
                              value: _ekatritVrutta['MahaanagarShaakhaaYuktaNagarCount'].toString(),
                              txtString2: 'अन्य\nनगरीय स्थान',
                              value2: _ekatritVrutta['AnyaNagarShaakhaaYuktaNagarCount'].toString(),
                              // txtString3: 'ग्रामीण स्थान',
                              // value3: _ekatritVrutta['graminShaakhaaYuktaNagarCount'].toString(),
                              // txtString3: Statics.getLabel('totalShaakhaaYuktaSthaanCount').split(" ").first + "\n" + Statics.getLabel('sthaan').toString(),
                              // value3: _ekatritVrutta['TotalShaakhaaYuktaSthaanCount'].toString(),fontsize: 15,
                              txtString3: 'एकूण\nनगरीय स्थान',
                              value3: (int.parse(_ekatritVrutta['AnyaNagarShaakhaaYuktaNagarCount'].toString()) + int.parse(_ekatritVrutta['MahaanagarShaakhaaYuktaNagarCount'].toString())).toString(),
                            ),
                            Container(
                              width: Statics.getDeviceSize(context).width,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            NewThreeColumnRow(
                              txtString: Statics.getLabel('graamin') + "\n" + Statics.getLabel('sthaan').toString(),
                              value: _ekatritVrutta['ShaakhaaYuktaGraamCount'].toString(),
                              txtString2: Statics.getLabel('totalShaakhaaYuktaSthaanCount').split(" ").first + "\n" + Statics.getLabel('sthaan').toString(),
                              value2: "${_ekatritVrutta['MahaanagarShaakhaaYuktaNagarCount'] + _ekatritVrutta['AnyaNagarShaakhaaYuktaNagarCount'] + _ekatritVrutta['ShaakhaaYuktaGraamCount']}",
                              // txtString3: "मंडळी\n" + Statics.getLabel('sthaan'),
                              // value3: _ekatritVrutta['GraaminMandaliYuktaGraamCount'].toString(),
                              // fontsize: 15,
                              txtString3: "",
                              value3: "",
                            ),
                          ],
                        ),
                        // ),
                        SizedBox(
                          height: 25,
                        ),
                        // Legend(legendString: "sewaVrutta", fontsize: 18),
                        SingleColumnRowLegend(
                            txtString: Statics.getLabel('sewaVrutta') + ' :',
                            value: '',
                            fontsize: 18,
                            view: true,
                            btnAction: () {
                              redirctToList("sewaVrutta", _baithakType.toString(), geoID, Statics.getLabel('sewaVrutta'));
                            }),
                        TwoColumnRow(
                          txtString: 'सेवा वस्ती संख्या',
                          value: _ekatritVrutta['SewaVastiCount'].toString() == "null" ? "0" : _ekatritVrutta['SewaVastiCount'].toString(),
                          txtString2: Statics.getLabel('shaakhaaYukta'),
                          value2: _ekatritVrutta['ShaakhaaYuktaSewaVastiCount'].toString() == "null" ? "0" : _ekatritVrutta['ShaakhaaYuktaSewaVastiCount'].toString(),
                          fontsize: 15,
                        ),
                        SingleColumnRow(
                            txtString: Statics.getLabel('sewaKaaryaYukta'),
                            value: _ekatritVrutta['SewaKaaryaYuktaSewaVastiCount'].toString() == "null" ? '0' : _ekatritVrutta['SewaKaaryaYuktaSewaVastiCount'].toString(),
                            fontsize: 15),

                        SingleColumnRow(txtString: Statics.getLabel('upakramsheelShaakhaa') + ':-', value: '', fontsize: 18),
                        // TwoColumnRow(
                        //   txtString: Statics.getLabel('sewaUpakramShaakhaaCount'),
                        //   value: _ekatritVrutta['SewaUpakramShaakhaaCount'].toString(),
                        //   txtString2:
                        //       Statics.getLabel('anyaUpakramShaakhaaCount'),
                        //   value2: _ekatritVrutta['AnyaUpakramShaakhaaCount'].toString(),
                        //   fontsize: 15,
                        // ),
                        SingleColumnRow(txtString: Statics.getLabel('sewaUpakramShaakhaaCount'), value: _ekatritVrutta['SewaUpakramShaakhaaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('anyaUpakramShaakhaaCount'), value: _ekatritVrutta['AnyaUpakramShaakhaaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('Total')}", value: _ekatritVrutta['TotalUpakramShaakhaaCount'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),
                        // Legend(legendString: "sewaVrutta", fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('sewaVastiIdentifiedShaakhaaCount'), value: _ekatritVrutta['SewaVastiIdentifiedShaakhaaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('sevaPramukhIdentifiedShaakhaaCount'), value: _ekatritVrutta['SewaPramukhIdentifiedShaakhaaCount'].toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString: (_baithakType == Statics.abPratinidhiSabhaa ? 'सेवा उपक्रम संख्या (२३ ऑक्टोबर-१८ फेब्रुवारी)' : 'सेवा उपक्रम संख्या (१९ फेब्रुवारी - २२ जून)'),
                            value: _ekatritVrutta['SewaUpakramCount'].toString() == "null" ? "0" : _ekatritVrutta['SewaUpakramCount'].toString(),
                            fontsize: 15),
                        // SizedBox(height: 20,),
                        // SingleColumnRow(txtString: Statics.getLabel('shakhaJilhaKendra'),
                        //     value: _ekatritVrutta['shakhaJilhaKendra'].toString()=="null"? "0":_ekatritVrutta['shakhaJilhaKendra'].toString(),
                        //     fontsize: 16),
                        SizedBox(
                          height: 20,
                        ),

// =============================================================sewa Vasti Sampark Shaakhaa Count===================================================================================================================

                        SingleColumnRow(
                          txtString: Statics.getLabel('sewaVastiSamparkShaakhaaCount') + ':-',
                          value: '',
                          fontsize: 18,
                        ),
                        SingleColumnRow(txtString: Statics.getLabel('fourTimes'), value: _ekatritVrutta['SewaVastiSampark4Times'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('thrice'), value: _ekatritVrutta['SewaVastiSamparkThrice'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('twice'), value: _ekatritVrutta['SewaVastiSamparkTwice'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ones'), value: _ekatritVrutta['SewaVastiSamparkOnes'].toString(), fontsize: 15),
                        // SingleColumnRow(txtString: Statics.getLabel('Total'), value: _ekatritVrutta['SewaVastiSamparkToal'].toString(), fontsize: 15),
                        SizedBox(
                          height: 10,
                        ),
// ==============================================================  Masik sampark karnarya shakha   ======================================================================================================
                        SingleColumnRow(
                            txtString: Statics.getLabel('niyamitSamparkKaranewaliShaakhaaCount'),
                            value: _ekatritVrutta['SewaVastiSamparkShaakhaaCount'].toString() == "null" ? "0" : _ekatritVrutta['SewaVastiSamparkShaakhaaCount'].toString(),
                            fontsize: 15),
// ============================================================= sewa divas karnarya Shaakhaa Count===================================================================================================================

                        SingleColumnRow(txtString: Statics.getLabel('conductingSewaDayShakhaa') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('fourTimes'), value: _ekatritVrutta['SewaDivas4Times'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('thrice'), value: _ekatritVrutta['SewaDivasThrice'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('twice'), value: _ekatritVrutta['SewaDivasTwice'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ones'), value: _ekatritVrutta['SewaDivasOnes'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Total'), value: _ekatritVrutta['SewaDivasTotal'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),
// ==============================================================  Kiman 5 shakaha   ======================================================================================================
//
//                         Divider(
//                           color: Colors.black,
//                         ),
                        Column(
                          children: [
                            Center(
                              child: Container(
                                width: Statics.getDeviceSize(context).width * 0.84,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        Statics.getLabel('shakhaJilhaKendra'),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          redirctToList("kiman5ShakhaJilaKendra", _baithakType.toString(), geoID, Statics.getLabel('shakhaJilhaKendra'));
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.list,
                                          color: Colors.purpleAccent,
                                          size: 20,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: Statics.getDeviceSize(context).width,
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SingleColumnRow(
                            txtString: Statics.getLabel('Total'),
                            value: "${_ekatritVrutta['shakhaJilhaKendra'].toString() == "null" ? "0" : _ekatritVrutta['shakhaJilhaKendra'].toString()}".toString(),
                            fontsize: 15),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(Statics.getLabel('shakhaJilhaKendra'),textAlign: TextAlign.left,style: TextStyle(color: Colors.purple, fontSize:  18 , fontWeight: FontWeight.w600),),
                        //     Text("${_ekatritVrutta['shakhaJilhaKendra'].toString()=="null"? "0":_ekatritVrutta['shakhaJilhaKendra'].toString()}",style: TextStyle( fontSize:  18 , fontWeight: FontWeight.w600))
                        //   ],
                        // ),
                        // Divider(
                        //   color: Colors.black,
                        // ),
                        SizedBox(
                          height: 20,
                        ),

                        //
                        // Legend(legendString: "praathamikVargVrutta", fontsize: 18),
                        // SingleColumnRow(
                        //     txtString:
                        //         Statics.getLabel('pratinidhitShaakhaa'),
                        //     value: _ekatritVrutta['PraathamikPratinidhitShaakhaaCount'].toString(),
                        //     fontsize: 15),
                        // SingleColumnRow(
                        //     txtString:
                        //         Statics.getLabel('pratinidhitAnyaSthaan'),
                        //     value: _ekatritVrutta['PraathamikPratinidhitAnyaSthaanCount'].toString(),
                        //     fontsize: 15),
                        // SingleColumnRow(
                        //     txtString:
                        //         Statics.getLabel('Total'),
                        //     value: _ekatritVrutta['PraathamikPratinidhitTotalCount'].toString(),
                        //     fontsize: 15),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // Visibility(
                        //     visible: mahanagarId !="1" && vibhagId !="73" && vibhagId !="74" && vibhagId !="75" && vibhagId !="76",
                        //     child:
                        Column(
                          children: [
                            // Legend(legendString: "vartamaanAndSankalp", fontsize: 18),
                            Column(
                              children: [
                                Center(
                                  child: Container(
                                    width: Statics.getDeviceSize(context).width * 0.84,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            Statics.getLabel('vartamaanAndSankalp'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              redirctToList("purnaVartamaanAndSankalp", _baithakType.toString(), geoID, Statics.getLabel('vartamaanAndSankalp'));
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.list,
                                              color: Colors.purpleAccent,
                                              size: 20,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: Statics.getDeviceSize(context).width,
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Table(
                              columnWidths: {
                                0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.5),
                                1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.25),
                                2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.25),
                                3: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.25)
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Container(
                                        height: 40,
                                        child: Text(
                                          Statics.getLabel('vruttaPrakaar'),
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        )),
                                    Container(height: 40, child: Text(Statics.getLabel('vartamaan'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                                    Container(height: 40, child: Text(Statics.getLabel('sankalp'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                                  ],
                                ),
                                TableRow(children: [
                                  Text(Statics.getLabel('poornaJilhaKendra')),
                                  Text(
                                    _ekatritVrutta['PoornaJilhaKendraCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaPoornaJilhaKendraCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('poornaJilha')),
                                  Text(
                                    _ekatritVrutta['PoornaJilhaCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaPoornaJilhaCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(''),
                                  Text(''),
                                  Text(''),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('poornaTaaluka'), style: TextStyle(fontSize: 18)),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('kitaneJilhoMe')),
                                  Text(
                                    _ekatritVrutta['JilhaWithPoornaTaalukaaCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaJilhaWithPoornaTaalukaaCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('unJilhokeKulTaalukaa')),
                                  Text(
                                    _ekatritVrutta['TotalTaalukaaCountOfJilhaWithPoornaTaalukaa'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaTotalTaalukaaCountOfJilhaWithPoornaTaalukaa'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('poornaTaaluka')),
                                  Text(
                                    _ekatritVrutta['PoornaTaalukaaCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaPoornaTaalukaaCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(''),
                                  Text(''),
                                  Text(''),
                                ]),
                                TableRow(children: [
                                  Text(
                                    Statics.getLabel('poornaMandal'),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('kitaneTaalukaaoMe')),
                                  Text(
                                    _ekatritVrutta['TaalukaaWithPoornaMandalCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaTaalukaaWithPoornaMandalCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('poornaMandal')),
                                  Text(
                                    _ekatritVrutta['PoornaMandalCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaPoornaMandalCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(''),
                                  Text(''),
                                  Text(''),
                                ]),
// =============================================    PURNA  NAGAR         =======================================================================================================================================

                                TableRow(children: [
                                  Text(Statics.getLabel('poornaNagar'), style: TextStyle(fontSize: 18)),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('kitaneNagarMe')),
                                  Text(
                                    _ekatritVrutta['JilhaWithPoornana'
                                                'arCount'] ==
                                            null
                                        ? "0"
                                        : _ekatritVrutta['JilhaWithPoornana'
                                                'arCount']
                                            .toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaJilhaWithPoornanagarCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('unNagarkeKulTaalukaa')),
                                  Text(
                                    _ekatritVrutta['TotalnagarCountOfJilhaWithPoornanagar'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaTotalnagarCountOfJilhaWithPoornanagar'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('poornaNagar')),
                                  Text(
                                    _ekatritVrutta['PoornanagarCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaPoornanagarCount'].toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(''),
                                  Text(''),
                                  Text(''),
                                ]),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                        // ),
                        // Legend(legendString: "vartamaanAndSankalp", fontsize: 18),
                        // Table(
                        //   columnWidths: {
                        //     0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.5),
                        //     1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.25),
                        //     2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.25)
                        //   },
                        //   children: [
                        //     TableRow(
                        //       children: [
                        //         Container(
                        //             height: 40,
                        //             child: Text(
                        //               Statics.getLabel('vruttaPrakaar'),
                        //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        //             )),
                        //         Container(
                        //             height: 40, child: Text(Statics.getLabel('vartamaan'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                        //         Container(
                        //             height: 40, child: Text(Statics.getLabel('sankalp'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                        //       ],
                        //     ),
                        //     TableRow(children: [
                        //       Text(Statics.getLabel('poornaJilhaKendra')),
                        //       Text(
                        //         _ekatritVrutta['PoornaJilhaKendraCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //       Text(
                        //         _ekatritVrutta['SankalpaPoornaJilhaKendraCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //     ]),
                        //     TableRow(children: [
                        //       Text(Statics.getLabel('poornaJilha')),
                        //       Text(
                        //         _ekatritVrutta['PoornaJilhaCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //       Text(
                        //         _ekatritVrutta['SankalpaPoornaJilhaCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //     ]),
                        //     TableRow(children: [
                        //       Text(''),
                        //       Text(''),
                        //       Text(''),
                        //     ]),
                        //     TableRow(children: [
                        //       Text(Statics.getLabel('poornaTaaluka'), style: TextStyle(fontSize: 18)),
                        //       Text(
                        //         '',
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //       Text(
                        //         '',
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //     ]),
                        //     TableRow(children: [
                        //       Text(Statics.getLabel('kitaneJilhoMe')),
                        //       Text(
                        //         _ekatritVrutta['JilhaWithPoornaTaalukaaCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //       Text(
                        //         _ekatritVrutta['SankalpaJilhaWithPoornaTaalukaaCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //     ]),
                        //     TableRow(children: [
                        //       Text(Statics.getLabel('unJilhokeKulTaalukaa')),
                        //       Text(
                        //         _ekatritVrutta['TotalTaalukaaCountOfJilhaWithPoornaTaalukaa'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //       Text(
                        //         _ekatritVrutta['SankalpaTotalTaalukaaCountOfJilhaWithPoornaTaalukaa'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //     ]),
                        //     TableRow(children: [
                        //       Text(Statics.getLabel('poornaTaaluka')),
                        //       Text(
                        //         _ekatritVrutta['PoornaTaalukaaCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //       Text(
                        //         _ekatritVrutta['SankalpaPoornaTaalukaaCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //     ]),
                        //     TableRow(children: [
                        //       Text(''),
                        //       Text(''),
                        //       Text(''),
                        //     ]),
                        //     TableRow(children: [
                        //       Text(
                        //         Statics.getLabel('poornaMandal'),
                        //         style: TextStyle(fontSize: 18),
                        //       ),
                        //       Text(
                        //         '',
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //       Text(
                        //         '',
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //     ]),
                        //     TableRow(children: [
                        //       Text(Statics.getLabel('kitaneTaalukaaoMe')),
                        //       Text(
                        //         _ekatritVrutta['TaalukaaWithPoornaMandalCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //       Text(
                        //         _ekatritVrutta['SankalpaTaalukaaWithPoornaMandalCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //     ]),
                        //     TableRow(children: [
                        //       Text(Statics.getLabel('poornaMandal')),
                        //       Text(
                        //         _ekatritVrutta['PoornaMandalCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //       Text(
                        //         _ekatritVrutta['SankalpaPoornaMandalCount'].toString(),
                        //         style: TextStyle(fontSize: 15),
                        //       ),
                        //     ]),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),

                        if (_baithakType != null && _baithakType == Statics.abPratinidhiSabhaa)
                          Column(
                            children: <Widget>[
                              Legend(legendString: "mukhyaMaargMaahiti", fontsize: 18),
                              SingleColumnRow(txtString: Statics.getLabel('mukhyaMaargCount'), value: _ekatritVrutta['MukhyaMaargCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('graamPramukhCount'), value: _ekatritVrutta['MukhyaMaargGraamPramukhCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('mukhyaMaargGraamCount'), value: _ekatritVrutta['MukhyaMaargGraamCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('mukhyaMaargShaakhaaYuktaGraamCount'), value: _ekatritVrutta['MukhyaMaargShaakhaaYuktaGraamCount'].toString(), fontsize: 15),
                              SingleColumnRow(
                                  txtString: Statics.getLabel('mukhyaMaargSaaptaahikYuktaGraamCount'), value: _ekatritVrutta['MukhyaMaargSaaptaahikYuktaGraamCount'].toString(), fontsize: 15),
                              SingleColumnRow(
                                  txtString: Statics.getLabel('mukhyaMaargKaaryViheenGraamPramukhCount'),
                                  value: _ekatritVrutta['MukhyaMaargKaaryaViheenGraamWithGraamPramukhCount'].toString(),
                                  fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('mukhyaMaargRemainingGraamCount'), value: _ekatritVrutta['MukhyaMaargRemainingGraamCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('pastShaakhaaGraamCount'), value: _ekatritVrutta['MukhyaMaargPastShaakhaaGraamCount'].toString(), fontsize: 15),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),

                        if (_baithakType != null && _baithakType == Statics.abPratinidhiSabhaa)
                          Column(
                            children: <Widget>[
                              Legend(legendString: "sanghaShikshaaVarg", fontsize: 18),
                              SingleColumnRow(txtString: Statics.getLabel('prathamVarshGeneral') + ':-', value: '', fontsize: 18),
                              SingleColumnRow(txtString: Statics.getLabel('prashikshitShikshaarthi'), value: _ekatritVrutta['PrathamGeneralShikshaarthiCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('sthaan'), value: _ekatritVrutta['PrathamGeneralSthaanCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('taalukaa'), value: _ekatritVrutta['PrathamGeneralTaalukaaCount'].toString(), fontsize: 15),
                              SizedBox(
                                height: 10,
                              ),
                              SingleColumnRow(txtString: Statics.getLabel('dwitiyaVarshGeneral') + ':-', value: '', fontsize: 18),
                              SingleColumnRow(txtString: Statics.getLabel('prashikshitShikshaarthi'), value: _ekatritVrutta['DwitiyaGeneralShikshaarthiCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('sthaan'), value: _ekatritVrutta['DwitiyaGeneralSthaanCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('jilha'), value: _ekatritVrutta['DwitiyaGeneralJilhaCount'].toString(), fontsize: 15),
                              SizedBox(
                                height: 10,
                              ),
                              SingleColumnRow(txtString: Statics.getLabel('trutiyaVarshGeneral') + ':-', value: '', fontsize: 18),
                              SingleColumnRow(txtString: Statics.getLabel('prashikshitShikshaarthi'), value: _ekatritVrutta['TrutiyaGeneralShikshaarthiCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('sthaan'), value: _ekatritVrutta['TrutiyaGeneralSthaanCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('vibhaag'), value: _ekatritVrutta['TrutiyaGeneralVibhaagCount'].toString(), fontsize: 15),
                              SizedBox(
                                height: 10,
                              ),
                              SingleColumnRow(txtString: Statics.getLabel('prathamVarshSpecial') + ':-', value: '', fontsize: 18),
                              SingleColumnRow(txtString: Statics.getLabel('prashikshitShikshaarthi'), value: _ekatritVrutta['PrathamSpecialShikshaarthiCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('sthaan'), value: _ekatritVrutta['PrathamSpecialSthaanCount'].toString(), fontsize: 15),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),

// ==============================================================    kaaryaSthiti Sankhyaatmak  ======================================================================================================
//                         Legend(legendString: "kaaryaSthitiSankhyaatmak", fontsize: 18),
                        SingleColumnRowLegend(
                            txtString: Statics.getLabel('kaaryaSthitiSankhyaatmak') + ' :',
                            value: '',
                            fontsize: 18,
                            view: true,
                            btnAction: () {
                              redirctToList("kaaryaSthitiSankhyaatmak", _baithakType.toString(), geoID, Statics.getLabel('kaaryaSthitiSankhyaatmak'));
                            }),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.45),
                            1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.24),
                            2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.18)
                          },
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  "${Statics.getLabel('Vayogat')}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text('सध्या स्थिती', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(Statics.getLabel('TotalSankalpitShaakhaa'), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                // Container(height: 40,child: Text(Statics.getLabel('TotalSankalpitSanghMandali'),textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                              ],
                            ),
                            TableRow(children: [
                              Text(Statics.getLabel('baalSanyukt'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['BaalSahaakhaaCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['SankalpaBaalSahaakhaaCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                _ekatritVrutta['BaalTotalSankalpitShaakhaCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['BaalTotalSankalpitSanghaMandaliCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                            ]),
                            TableRow(children: [
                              Text(Statics.getLabel('mahaavidyaalayeen'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['TarunVidyaarthiShaakhaaCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['SankalpaTarunVidyaarthiShaakhaaCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                _ekatritVrutta['MahavidyalayinTotalSankalpitShaakhaCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['MahavidyalayinTotalSankalpitSanghaMandaliCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                            ]),
                            TableRow(children: [
                              Text(Statics.getLabel('vyavasaayeeTarun'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['TarunVyavasaayeeShaakhaaCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['SankalpaTarunVyavasaayeeShaakhaaCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                _ekatritVrutta['TarunTotalSankalpitShaakhaCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['TarunTotalSankalpitSanghaMandaliCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                            ]),
                            TableRow(children: [
                              Text(Statics.getLabel('proudhVyavasaayee'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['ProudhShaakhaaCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['SankalpaProudhShaakhaaCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                _ekatritVrutta['ProudhTotalSankalpitShaakhaCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['ProudhTotalSankalpitSanghaMandaliCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                            ]),
                            TableRow(children: [
                              Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['TotalShaakhaaCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['SankalpaTotalShaakhaaCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                _ekatritVrutta['AllVayogatTotalSankalpitShaakhaCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['AllVayogatTotalSankalpitSanghaMandaliCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
// ==============================================================   average Upasthiti Shaakhaa  ======================================================================================================

                        Legend(legendString: "averageUpasthitiShaakhaa", fontsize: 18),
                        SizedBox(
                          height: 5,
                        ),
                        SingleColumnRow(
                            txtString: Statics.getLabel('averageBaal'),
                            value: _ekatritVrutta['BaalAverageShaakhaa'].toString() == "null" ? "0" : _ekatritVrutta['BaalAverageShaakhaa'].toString(),
                            fontsize: 15),
                        SizedBox(
                          height: 5,
                        ),
                        SingleColumnRow(
                            txtString: Statics.getLabel('averageMahavidyaalayeen'),
                            value: _ekatritVrutta['TarunVidyaarthiAverageShaakhaa'].toString() == "null" ? "0" : _ekatritVrutta['TarunVidyaarthiAverageShaakhaa'].toString(),
                            fontsize: 15),
                        SizedBox(
                          height: 5,
                        ),
                        SingleColumnRow(
                            txtString: Statics.getLabel('averageTarunVyavasaayee'),
                            value: _ekatritVrutta['TarunVyavasaayeeAverageShaakhaa'].toString() == "null" ? "0" : _ekatritVrutta['TarunVyavasaayeeAverageShaakhaa'].toString(),
                            fontsize: 15),
                        SizedBox(
                          height: 5,
                        ),
                        SingleColumnRow(
                            txtString: Statics.getLabel('averageProudh'),
                            value: _ekatritVrutta['ProudhAverageShaakhaa'].toString() == "null" ? "0" : _ekatritVrutta['ProudhAverageShaakhaa'].toString(),
                            fontsize: 15),
                        SizedBox(
                          height: 5,
                        ),
                        SingleColumnRow(
                            txtString: 'शिशु', value: _ekatritVrutta['ShishuAverageShaakhaa'].toString() == "null" ? "0" : _ekatritVrutta['ShishuAverageShaakhaa'].toString(), fontsize: 15),
                        SizedBox(
                          height: 5,
                        ),
                        SingleColumnRow(
                            txtString: "${Statics.getLabel('Total')}",
                            value: _ekatritVrutta['TotalAverageShaakhaa'].toString() == "null" ? "0" : _ekatritVrutta['TotalAverageShaakhaa'].toString(),
                            fontsize: 15),
                        SizedBox(
                          height: 25,
                        ),

                        Legend(legendString: "nagareeySaaptaahik", fontsize: 18),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.45),
                            1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.24),
                            2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.18)
                          },
                          children: [
                            TableRow(
                              children: [
                                Container(
                                    height: 40,
                                    child: Text(
                                      "${Statics.getLabel('Vayogat')}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    )),
                                Container(height: 40, child: Text('सध्या स्थिती', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                Container(height: 40, child: Text(Statics.getLabel('sankalp'), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                              ],
                            ),
                            TableRow(children: [
                              Text(Statics.getLabel('baalSanyukt'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['NagariyaBaalSaaptaahikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                _ekatritVrutta['SankalpaNagariyaBaalSaaptaahikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                            TableRow(children: [
                              Text(Statics.getLabel('mahaavidyaalayeen'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['NagariyaTarunVidyaarthiSaaptaahikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                _ekatritVrutta['SankalpaNagariyaTarunVidyaarthiSaaptaahikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                            TableRow(children: [
                              Text(Statics.getLabel('vyavasaayeeTarun'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['NagariyaTarunVyavasaayeeSaaptaahikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                _ekatritVrutta['SankalpaNagariyaTarunVyavasaayeeSaaptaahikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                            TableRow(children: [
                              Text(Statics.getLabel('proudhVyavasaayee'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['NagariyaProudhSaaptaahikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                _ekatritVrutta['SankalpaNagariyaProudhSaaptaahikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                            TableRow(children: [
                              Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['NagariyaTotalSaaptaahikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                _ekatritVrutta['SankalpaNagariyaTotalSaaptaahikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 28,
                        ),

                        // Visibility(
                        //     visible:mahanagarId !="1" && vibhagId !="73" && vibhagId !="74" && vibhagId !="75" && vibhagId !="76",
                        //     child:
                        Column(
                          children: [
                            // Legend(legendString: "graaminSaaptaahik", fontsize: 18),
                            SingleColumnRowLegend(
                                txtString: Statics.getLabel('graaminSaaptaahikSthan'),
                                value: '',
                                fontsize: 18,
                                view: true,
                                btnAction: () {
                                  redirctToList("graaminSaaptaahik", _baithakType.toString(), geoID, Statics.getLabel('graaminSaaptaahikSthan'));
                                }),
                            Single1ColumnRow(txtString: Statics.getLabel('graaminSaaptaahikMilanYuktyaSthan'), value: getTotalCount(_ekatritVrutta), fontsize: 15),
                            Legend(
                              legendString: 'graaminSaaptaahik',
                              fontsize: 18,
                            ),
                            Table(
                              columnWidths: {
                                0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.45),
                                1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.24),
                                2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.17)
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Container(
                                        height: 40,
                                        child: Text(
                                          "${Statics.getLabel('Vayogat')}",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        )),
                                    Container(height: 40, child: Text('सध्या स्थिती', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                    Container(height: 40, child: Text(Statics.getLabel('sankalp'), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                  ],
                                ),
                                TableRow(children: [
                                  Text(Statics.getLabel('baalSanyukt'), style: TextStyle(fontSize: 15)),
                                  Text(
                                    _ekatritVrutta['GraaminBaalSaaptaahikCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaGraaminBaalSaaptaahikCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('mahaavidyaalayeen'), style: TextStyle(fontSize: 15)),
                                  Text(
                                    _ekatritVrutta['GraaminTarunVidyaarthiSaaptaahikCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaGraaminTarunVidyaarthiSaaptaahikCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('vyavasaayeeTarun'), style: TextStyle(fontSize: 15)),
                                  Text(
                                    _ekatritVrutta['GraaminTarunVyavasaayeeSaaptaahikCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaGraaminTarunVyavasaayeeSaaptaahikCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('proudhVyavasaayee'), style: TextStyle(fontSize: 15)),
                                  Text(
                                    _ekatritVrutta['GraaminProudhSaaptaahikCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaGraaminProudhSaaptaahikCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 15)),
                                  Text(
                                    _ekatritVrutta['GraaminTotalSaaptaahikCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    _ekatritVrutta['SankalpaGraaminTotalSaaptaahikCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),

                            // Legend(legendString: "TotalSaaptaahikMilan", fontsize: 18),
                            SingleColumnRowLegend(
                                txtString: Statics.getLabel('TotalSaaptaahikMilan'),
                                value: '',
                                fontsize: 18,
                                view: true,
                                btnAction: () {
                                  redirctToList("totalKaryastithiSaaptaahikMilan", _baithakType.toString(), geoID, Statics.getLabel('TotalSaaptaahikMilan'));
                                }),
                            Table(
                              columnWidths: {
                                0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.45),
                                1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.24),
                                2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.18)
                              },
                              children: [
                                TableRow(children: [
                                  Text(
                                    "${Statics.getLabel('Vayogat')}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text('सध्या स्थिती', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  // Container(height: 40,child: Text(Statics.getLabel('sankalp'),textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                  Text(Statics.getLabel('TotalSankalpitSaaptaahikMilan'), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('baalSanyukt'), style: TextStyle(fontSize: 15)),
                                  Text(
                                    ((_ekatritVrutta['NagariyaBaalSaaptaahikCount']) + _ekatritVrutta['GraaminBaalSaaptaahikCount']).toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  // Text(((_ekatritVrutta['SankalpaNagariyaBaalSaaptaahikCount'])+_ekatritVrutta['SankalpaGraaminBaalSaaptaahikCount']).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                                  Text(
                                    _ekatritVrutta['BaalTotalSankalpitSaptahikMilanCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('mahaavidyaalayeen'), style: TextStyle(fontSize: 15)),
                                  Text(
                                    ((_ekatritVrutta['NagariyaTarunVidyaarthiSaaptaahikCount']) + _ekatritVrutta['GraaminTarunVidyaarthiSaaptaahikCount']).toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  // Text(((_ekatritVrutta['SankalpaNagariyaTarunVidyaarthiSaaptaahikCount'])+ _ekatritVrutta['SankalpaGraaminTarunVidyaarthiSaaptaahikCount']).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                                  Text(
                                    _ekatritVrutta['MahavidyalayinTotalSankalpitSaptahikMilanCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('vyavasaayeeTarun'), style: TextStyle(fontSize: 15)),
                                  Text(
                                    ((_ekatritVrutta['NagariyaTarunVyavasaayeeSaaptaahikCount']) + _ekatritVrutta['GraaminTarunVyavasaayeeSaaptaahikCount']).toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  // Text(((_ekatritVrutta['SankalpaNagariyaTarunVyavasaayeeSaaptaahikCount'])+ _ekatritVrutta['SankalpaGraaminTarunVyavasaayeeSaaptaahikCount']).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                                  Text(
                                    _ekatritVrutta['TarunTotalSankalpitSaptahikMilanCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(Statics.getLabel('proudhVyavasaayee'), style: TextStyle(fontSize: 15)),
                                  Text(
                                    ((_ekatritVrutta['NagariyaProudhSaaptaahikCount']) + _ekatritVrutta['GraaminProudhSaaptaahikCount']).toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  // Text(((_ekatritVrutta['SankalpaNagariyaProudhSaaptaahikCount'])+ _ekatritVrutta['SankalpaGraaminProudhSaaptaahikCount']).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                                  Text(
                                    _ekatritVrutta['ProudhTotalSankalpitSaptahikMilanCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 15)),
                                  Text(
                                    ((_ekatritVrutta['NagariyaTotalSaaptaahikCount']) + _ekatritVrutta['GraaminTotalSaaptaahikCount']).toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  // Text(((_ekatritVrutta['SankalpaNagariyaTotalSaaptaahikCount'])+ _ekatritVrutta['SankalpaGraaminTotalSaaptaahikCount']).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                                  Text(
                                    _ekatritVrutta['AllVayogatTotalSankalpitSaptahikMilanCount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ]),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        // ),

                        Legend(legendString: "averageUpasthitiNagareeySaaptaahik", fontsize: 18),
                        SingleColumnRow(
                            txtString: Statics.getLabel('averageBaal'),
                            value: _ekatritVrutta['BaalAverageNagariyaSaaptaahik'].toString() == "null" ? "0" : _ekatritVrutta['BaalAverageNagariyaSaaptaahik'].toString(),
                            fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('averageMahavidyaalayeen'), value: _ekatritVrutta['TarunVidyaarthiAverageNagariyaSaaptaahik'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('averageTarunVyavasaayee'), value: _ekatritVrutta['TarunVyavasaayeeAverageNagariyaSaaptaahik'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('averageProudh'), value: _ekatritVrutta['ProudhAverageNagariyaSaaptaahik'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: 'शिशु', value: _ekatritVrutta['ShishuAverageNagariyaSaaptaahik'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('Total')}", value: _ekatritVrutta['TotalAverageNagariyaSaaptaahik'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),

                        // Visibility(
                        //     visible:mahanagarId !="1" && vibhagId !="73" && vibhagId !="74" && vibhagId !="75" && vibhagId !="76",
                        //     child:
                        Column(children: [
                          Legend(legendString: "averageUpasthitiGraaminSaaptaahik", fontsize: 18),
                          SingleColumnRow(
                              txtString: Statics.getLabel('averageBaal'),
                              value: _ekatritVrutta['BaalAverageGraaminSaaptaahik'].toString() == "null" ? "0" : _ekatritVrutta['BaalAverageGraaminSaaptaahik'].toString(),
                              fontsize: 15),
                          SingleColumnRow(
                              txtString: Statics.getLabel('averageMahavidyaalayeen'),
                              value: _ekatritVrutta['TarunVidyaarthiAverageGraaminSaaptaahik'].toString() == "null" ? "0" : _ekatritVrutta['TarunVidyaarthiAverageGraaminSaaptaahik'].toString(),
                              fontsize: 15),
                          SingleColumnRow(
                              txtString: Statics.getLabel('averageTarunVyavasaayee'),
                              value: _ekatritVrutta['TarunVyavasaayeeAverageGraaminSaaptaahik'].toString() == "null" ? "0" : _ekatritVrutta['TarunVyavasaayeeAverageGraaminSaaptaahik'].toString(),
                              fontsize: 15),
                          SingleColumnRow(
                              txtString: Statics.getLabel('averageProudh'),
                              value: _ekatritVrutta['ProudhAverageGraaminSaaptaahik'].toString() == "null" ? "0" : _ekatritVrutta['ProudhAverageGraaminSaaptaahik'].toString(),
                              fontsize: 15),
                          SingleColumnRow(
                              txtString: 'शिशु',
                              value: _ekatritVrutta['ShishuAverageGraaminSaaptaahik'].toString() == "null" ? "0" : _ekatritVrutta['ShishuAverageGraaminSaaptaahik'].toString(),
                              fontsize: 15),
                          SingleColumnRow(
                              txtString: "${Statics.getLabel('Total')}",
                              value: _ekatritVrutta['TotalAverageGraaminSaaptaahik'].toString() == "null" ? "0" : _ekatritVrutta['TotalAverageGraaminSaaptaahik'].toString(),
                              fontsize: 15),
                          SizedBox(
                            height: 20,
                          ),
                        ]),
                        // ),
// ================================================  Maasik Milan  ====================================================================================

                        // Legend(legendString: "MaasikMilan", fontsize: 18),
                        SingleColumnRowLegend(
                            txtString: Statics.getLabel('MaasikMilan') + ':',
                            value: '',
                            fontsize: 18,
                            view: true,
                            btnAction: () {
                              redirctToList("maasikMilan", _baithakType.toString(), geoID, Statics.getLabel('MaasikMilan'));
                            }),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.45),
                            1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.24),
                            2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.18)
                          },
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  "${Statics.getLabel('Vayogat')}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text('सध्या स्थिती', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                // Container(height: 40,child: Text(Statics.getLabel('sankalp'),textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                Text(Statics.getLabel('TotalSankalpitMasikMilan'), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                            TableRow(children: [
                              Text(Statics.getLabel('vidyaarthi'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['MaasikMilanVidyaarthiMaasikCount'].toString()
                                // _ekatritVrutta['MaasikMilanVidyaarthiMaasikCount'].toString()
                                ,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['MaasikMilanSankalpaVidyaarthiMaasikCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                _ekatritVrutta['MaasikMilanSankalpaVidyaarthiMaasikCount'].toString()
                                // "${_ekatritVrutta['BaalTotalSankalpitMaasikMilanCount'] + _ekatritVrutta['MahavidyalayinTotalSankalpitMaasikMilanCount']}"
                                ,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                            TableRow(children: [
                              Text(Statics.getLabel('vyavasaayee'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['MaasikMilanVyavasaayeeMaasikCount'].toString()
                                // _ekatritVrutta['MaasikMilanVyavasaayeeMaasikCount'].toString()
                                ,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['MaasikMilanSankalpaVyavasaayeeMaasikCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                _ekatritVrutta['MaasikMilanSankalpaVyavasaayeeMaasikCount'].toString()
                                // "${_ekatritVrutta['TarunTotalSankalpitMaasikMilanCount']+ _ekatritVrutta['ProudhTotalSankalpitMaasikMilanCount']}"
                                ,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                            TableRow(children: [
                              Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 15)),
                              Text(
                                // _ekatritVrutta['MaasikMilanTotalMaasikCount']
                                "${_ekatritVrutta['MaasikMilanVidyaarthiMaasikCount'] + _ekatritVrutta['MaasikMilanVyavasaayeeMaasikCount']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['MaasikMilanSankalpaTotalMaasikCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                // _ekatritVrutta['AllVayogatTotalSankalpitMaasikMilanCount'].toString()
                                "${_ekatritVrutta['MaasikMilanSankalpaVidyaarthiMaasikCount'] + _ekatritVrutta['MaasikMilanSankalpaVyavasaayeeMaasikCount']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
// ================================================  Sangha Mandali  ================================================

                        // Legend(legendString: "SanghaMandali", fontsize: 18),
                        SingleColumnRowLegend(
                            txtString: Statics.getLabel('SanghaMandali') + ':',
                            value: '',
                            fontsize: 18,
                            view: true,
                            btnAction: () {
                              redirctToList("sanghaMandali", _baithakType.toString(), geoID, Statics.getLabel('SanghaMandali'));
                            }),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.45),
                            1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.24),
                            2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.18)
                          },
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  "${Statics.getLabel('Vayogat')}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text('सध्या स्थिती', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                // Container(height: 40,child: Text(Statics.getLabel('sankalp'),textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                Text(Statics.getLabel('TotalSankalpitSanghMandali'), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                            TableRow(children: [
                              Text(Statics.getLabel('vidyaarthi'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['SanghMandaliVidyaarthiMaasikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['SanghMandaliSankalpaVidyaarthiMaasikCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                "${_ekatritVrutta['SanghMandaliSankalpaVidyaarthiMaasikCount']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                            TableRow(children: [
                              Text(Statics.getLabel('vyavasaayee'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['SanghMandaliVyavasaayeeMaasikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['SanghMandaliSankalpaVyavasaayeeMaasikCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                "${_ekatritVrutta['SanghMandaliSankalpaVyavasaayeeMaasikCount']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                            TableRow(children: [
                              Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['SanghMandaliTotalMaasikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text(_ekatritVrutta['SanghMandaliSankalpaTotalMaasikCount'].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15),),
                              Text(
                                "${_ekatritVrutta['SanghMandaliSankalpaVyavasaayeeMaasikCount'] + _ekatritVrutta['SanghMandaliSankalpaVidyaarthiMaasikCount']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
// ================================================  Mandali Sthan  ================================================

                        Legend(legendString: "MandaliSthan", fontsize: 18),
                        Table(
                          columnWidths: {
                            0: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.45),
                            1: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.24),
                            2: FixedColumnWidth(Statics.getDeviceSize(context).width * 0.18)
                          },
                          children: [
                            TableRow(
                              children: [
                                Container(
                                    height: 40,
                                    child: Text(
                                      "${Statics.getLabel('Vayogat')}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    )),
                                Container(height: 40, child: Text('सध्या स्थिती', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                Container(height: 40, child: Text(Statics.getLabel('sankalp'), textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                              ],
                            ),
                            TableRow(children: [
                              Text(Statics.getLabel('vidyaarthi'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['MandaliSthanVidyaarthiMaasikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                _ekatritVrutta['MandaliSthanSankalpaVidyaarthiMaasikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                            TableRow(children: [
                              Text(Statics.getLabel('vyavasaayee'), style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['MandaliSthanVyavasaayeeMaasikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                _ekatritVrutta['MandaliSthanSankalpaVyavasaayeeMaasikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                            TableRow(children: [
                              Text("${Statics.getLabel('Total')}", style: TextStyle(fontSize: 15)),
                              Text(
                                _ekatritVrutta['MandaliSthanTotalMaasikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                _ekatritVrutta['MandaliSthanSankalpaTotalMaasikCount'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
// ================================================  SHakha Toli  ================================================
//                         Legend(legendString: 'shaakhaaToli', fontsize: 18),
                        SingleColumnRowLegend(
                            txtString: Statics.getLabel('shaakhaaToli') + ':',
                            value: '',
                            fontsize: 18,
                            view: true,
                            btnAction: () {
                              redirctToList("shaakhaToli", _baithakType.toString(), geoID, Statics.getLabel('shaakhaaToli'));
                            }),
                        SingleColumnRow(txtString: Statics.getLabel('baalSanyukt'), value: _ekatritVrutta['BaalShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('mahaavidyaalayeen'), value: _ekatritVrutta['TarunVidyaarthiShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('vyavasaayeeTarun'), value: _ekatritVrutta['TarunVyavasaayeeShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('proudhVyavasaayee'), value: _ekatritVrutta['ProudhShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('Total')}", value: _ekatritVrutta['TotalShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),
// =====================================  SAptahik MIlan Toli  =======================================================
//                         Legend(legendString: 'saptahikMilanToli', fontsize: 18),
                        SingleColumnRowLegend(
                            txtString: Statics.getLabel('saptahikMilanToli') + ':',
                            value: '',
                            fontsize: 18,
                            view: true,
                            btnAction: () {
                              redirctToList("saptahikMilanToli", _baithakType.toString(), geoID, Statics.getLabel('saptahikMilanToli'));
                            }),
                        SingleColumnRow(
                            txtString: Statics.getLabel('baalSanyukt'),
                            value: _ekatritVrutta['BalSaaptaahikMilanToliCount'].toString() == "null" ? "0" : _ekatritVrutta['BalSaaptaahikMilanToliCount'].toString(),
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('mahaavidyaalayeen'),
                            value: _ekatritVrutta['TarunSaaptaahikMilanToliCount'].toString() == "null" ? "0" : _ekatritVrutta['TarunSaaptaahikMilanToliCount'].toString(),
                            fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('vyavasaayeeTarun'), value: _ekatritVrutta['TarunVyavasaayeeSaaptaahikMilanToliCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('proudhVyavasaayee'), value: _ekatritVrutta['ProudhSaaptaahikMilanToliCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('Total')}", value: _ekatritVrutta['TotalSaaptaahikMilanToliCount'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),
// =====================================     Baithak karnara shakha  =======================================================

                        // Legend(legendString: 'baithakKrnaraShakha', fontsize: 18),
                        SingleColumnRowLegend(
                            txtString: Statics.getLabel('baithakKrnaraShakha') + ':',
                            value: '',
                            fontsize: 18,
                            view: true,
                            btnAction: () {
                              redirctToList("baithakKrnaraShakha", _baithakType.toString(), geoID, Statics.getLabel('baithakKrnaraShakha'));
                            }),
                        SingleColumnRow(txtString: Statics.getLabel('baalSanyukt'), value: _ekatritVrutta['BalBaithakShaakaaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('mahaavidyaalayeen'), value: _ekatritVrutta['TarunBaithakShaakaaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('vyavasaayeeTarun'), value: _ekatritVrutta['TarunVyavasaayeeBaithakShaakaaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('proudhVyavasaayee'), value: _ekatritVrutta['ProudhBaithakShaakaaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('Total')}", value: _ekatritVrutta['TotalBaithakShaakhaaCount'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),

                        if (_baithakType != null && _baithakType == Statics.abPratinidhiSabhaa)
                          Column(
                            children: <Widget>[
                              Column(
                                children: [
                                  Text('ग्राम विकास वृत्त', style: TextStyle(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.w600)),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              // Legend(legendString: "graamVikasVrutta", fontsize: 18),
                              SingleColumnRow(txtString: Statics.getLabel('graamVikasGraamCount'), value: _ekatritVrutta['GraamVikasCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('udayGraamCount'), value: _ekatritVrutta['UdayGraamCount'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('prabhaatGraamCount'), value: _ekatritVrutta['PrabhaatGraamCount'].toString(), fontsize: 15),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),

                        if (_baithakType != null && _baithakType == Statics.abPratinidhiSabhaa)
                          Column(
                            children: <Widget>[
                              Legend(legendString: "kaaryaViheenVrutta", fontsize: 18),
                              SingleColumnRow(txtString: Statics.getLabel('vastiCountWithPastShaakhaa'), value: _ekatritVrutta['VastiCountWithPastShaakhaa'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('vastiCountWithPastSaaptaahik'), value: _ekatritVrutta['VastiCountWithPastSaaptaahik'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('graamCountWithPastShaakhaa'), value: _ekatritVrutta['GraamCountWithPastShaakhaa'].toString(), fontsize: 15),
                              SingleColumnRow(txtString: Statics.getLabel('graamCountWithPastSaaptaahik'), value: _ekatritVrutta['GraamCountWithPastSaaptaahik'].toString(), fontsize: 15),
                            ],
                          ),

                        // // Vaartaapatra Counts
                        // Column(children: <Widget>[
                        //   Legend(legendString: "saanskrutikVaartaapatraVrutta", fontsize: 18),
                        //   SingleColumnRow(txtString: Statics.getLabel('vaartaapatraVastiCount'), value: (_ekatritVrutta['VaartaapatraVastiCount'] == null ? '0' : _ekatritVrutta['VaartaapatraVastiCount'].toString()), fontsize: 15),
                        //   SingleColumnRow(txtString: Statics.getLabel('vaartaapatraCount'), value: (_ekatritVrutta['VaartaapatraCountInVasti'] == null ? '0' : _ekatritVrutta['VaartaapatraCountInVasti'].toString()), fontsize: 15),
                        //   SingleColumnRow(txtString: Statics.getLabel('vaartaapatraGraamCount'), value: (_ekatritVrutta['VaartaapatraGraamCount'] == null ? '0' : _ekatritVrutta['VaartaapatraGraamCount'].toString()), fontsize: 15),
                        //   SingleColumnRow(txtString: Statics.getLabel('vaartaapatraCount'), value: (_ekatritVrutta['VaartaapatraCountInGraam'] == null ? '0' : _ekatritVrutta['VaartaapatraCountInGraam'].toString()), fontsize: 15),
                        // ],),
                        SizedBox(
                          height: 20,
                        ),
// =============================================================Shakha Toli Baithak Kranare Saptahik Milananchi Sankhya===================================================================================================================
                        Legend(legendString: 'BaithakKrnaremilan', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('baalSanyukt'), value: _ekatritVrutta['BalBaithakSaaptaahikMilanToliCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('mahaavidyaalayeen'), value: _ekatritVrutta['TarunBaithakSaaptaahikMilanToliCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('vyavasaayeeTarun'), value: _ekatritVrutta['TarunVyavasaayeeBaithakSaaptaahikMilanToliCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('proudhVyavasaayee'), value: _ekatritVrutta['ProudhBaithakSaaptaahikMilanToliCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('Total')}", value: _ekatritVrutta['TotalProudhBaithakSaaptaahikMilanToliCount'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),

// ================================================ palak yuktya SHakha Toli  ================================================

                        Legend(legendString: "PalakYuktaShaakhaaToli", fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('baalSanyukt'), value: _ekatritVrutta['shakhapalakBaalShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('mahaavidyaalayeen'), value: _ekatritVrutta['shakhapalakTarunVidyaarthiShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('vyavasaayeeTarun'), value: _ekatritVrutta['shakhapalakTarunVyavasaayeeShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('proudhVyavasaayee'), value: _ekatritVrutta['shakhapalakProudhShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('Total')}", value: _ekatritVrutta['shakhapalakTotalShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),

// ===================================== palak yuktya SAptahik MIlan Toli  =======================================================

                        Legend(legendString: 'PalakYuktaSaptahikMilan', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('baalSanyukt'), value: _ekatritVrutta['issankalpitshakhapalakBaalShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('mahaavidyaalayeen'), value: _ekatritVrutta['issankalpitshakhapalakTarunVidyaarthiShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('vyavasaayeeTarun'), value: _ekatritVrutta['issankalpitshakhapalakTarunVyavasaayeeShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('proudhVyavasaayee'), value: _ekatritVrutta['issankalpitshakhapalakProudhShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('Total')}", value: _ekatritVrutta['issankalpitshakhapalakTotalShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),

// ================================================  Varshik utsav  ================================================

                        Legend(legendString: "VarshikutsavShaakhaaToli", fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('baalSanyukt'), value: _ekatritVrutta['varshikmahotsavBaalShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('mahaavidyaalayeen'), value: _ekatritVrutta['varshikmahotsavTarunVidyaarthiShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('vyavasaayeeTarun'), value: _ekatritVrutta['varshikmahotsavTarunVyavasaayeeShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('proudhVyavasaayee'), value: _ekatritVrutta['varshikmahotsavProudhShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('Total')}", value: _ekatritVrutta['varshikmahotsavTotalShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),

// ===================================== Varshik utsav SAptahik MIlan Toli  =======================================================

                        Legend(legendString: 'VarshikutsavSaptahikMilan', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('baalSanyukt'), value: _ekatritVrutta['varshikmahotsavsankalpitBaalShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('mahaavidyaalayeen'), value: _ekatritVrutta['varshikmahotsavsankalpitTarunVidyaarthiShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('vyavasaayeeTarun'), value: _ekatritVrutta['varshikmahotsavsankalpitTarunVyavasaayeeShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('proudhVyavasaayee'), value: _ekatritVrutta['varshikmahotsavsankalpitProudhShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SingleColumnRow(txtString: "${Statics.getLabel('Total')}", value: _ekatritVrutta['varshikmahotsavsankalpitTotalShaakhaaToliYuktaCount'].toString(), fontsize: 15),
                        SizedBox(
                          height: 20,
                        ),

// =====================================  bal vayogat gela mahina   ==============================================================================================================
                        Legend(legendString: "averageBaal", extraString: Statics.getLabel("ShaakhaaVruttaSummaryLabel"), fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('Shaakhaa') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ0'), value: "${_ekatritVrutta['balShaakhaaEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Shaakhaa1To24'), value: "${_ekatritVrutta['balShaakhaa1To24']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaGTE25'), value: "${_ekatritVrutta['balShaakhaaGTE25']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ30'), value: "${_ekatritVrutta['balShaakhaaEQ30']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikMilan') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikEQ0'), value: "${_ekatritVrutta['balSaaptaahikEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Saaptaahik1To3'), value: "${_ekatritVrutta['balSaaptaahik1To3']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikGTE4'), value: "${_ekatritVrutta['balSaaptaahikGTE4']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikMilan') + '/' + Statics.getLabel('SanghaMandali') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikEQ0'), value: "${_ekatritVrutta['balMaasikEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikEQ1'), value: "${_ekatritVrutta['balMaasikEQ1']}", fontsize: 15),
                        SizedBox(
                          height: 15,
                        ),

                        Legend(legendString: "averageMahavidyaalayeen", extraString: Statics.getLabel("ShaakhaaVruttaSummaryLabel"), fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('Shaakhaa') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ0'), value: "${_ekatritVrutta['MahavidyaShaakhaaEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Shaakhaa1To24'), value: "${_ekatritVrutta['MahavidyaShaakhaa1To24']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaGTE25'), value: "${_ekatritVrutta['MahavidyaShaakhaaGTE25']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ30'), value: "${_ekatritVrutta['MahavidyaShaakhaaEQ30']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikMilan') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikEQ0'), value: "${_ekatritVrutta['MahavidyataahikEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Saaptaahik1To3'), value: "${_ekatritVrutta['MahavidyaSaaptaahik1To3']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikGTE4'), value: "${_ekatritVrutta['MahavidyaSaaptaahikGTE4']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikMilan') + '/' + Statics.getLabel('SanghaMandali') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikEQ0'), value: "${_ekatritVrutta['MahavidyaMaasikEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikEQ1'), value: "${_ekatritVrutta['MahavidyaMaasikEQ1']}", fontsize: 15),
                        SizedBox(
                          height: 15,
                        ),

                        Legend(legendString: "averageTarunVyavasaayee", extraString: Statics.getLabel("ShaakhaaVruttaSummaryLabel"), fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('Shaakhaa') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ0'), value: "${_ekatritVrutta['TarunShaakhaaEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Shaakhaa1To24'), value: "${_ekatritVrutta['TarunShaakhaa1To24']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaGTE25'), value: "${_ekatritVrutta['TarunShaakhaaGTE25']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ30'), value: "${_ekatritVrutta['TarunShaakhaaEQ30']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikMilan') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikEQ0'), value: "${_ekatritVrutta['TarunSaaptaahikEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Saaptaahik1To3'), value: "${_ekatritVrutta['TarunSaaptaahik1To3']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikGTE4'), value: "${_ekatritVrutta['TarunSaaptaahikGTE4']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikMilan') + '/' + Statics.getLabel('SanghaMandali') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikEQ0'), value: "${_ekatritVrutta['TarunMaasikEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikEQ1'), value: "${_ekatritVrutta['TarunMaasikEQ1']}", fontsize: 15),
                        SizedBox(
                          height: 15,
                        ),

                        Legend(legendString: "averageProudh", extraString: Statics.getLabel("ShaakhaaVruttaSummaryLabel"), fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('Shaakhaa') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ0'), value: "${_ekatritVrutta['ProudhShaakhaaEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Shaakhaa1To24'), value: "${_ekatritVrutta['ProudhShaakhaa1To24']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaGTE25'), value: "${_ekatritVrutta['ProudhShaakhaaGTE25']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('ShaakhaaEQ30'), value: "${_ekatritVrutta['ProudhShaakhaaEQ30']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikMilan') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikEQ0'), value: "${_ekatritVrutta['ProudhSaaptaahikEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('Saaptaahik1To3'), value: "${_ekatritVrutta['ProudhSaaptaahik1To3']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikGTE4'), value: "${_ekatritVrutta['ProudhSaaptaahikGTE4']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikMilan') + '/' + Statics.getLabel('SanghaMandali') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikEQ0'), value: "${_ekatritVrutta['ProudhMaasikEQ0']}", fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikEQ1'), value: "${_ekatritVrutta['ProudhMaasikEQ1']}", fontsize: 15),
                        SizedBox(
                          height: 15,
                        ),

                        Legend(legendString: "Total", extraString: Statics.getLabel("ShaakhaaVruttaSummaryLabel"), fontsize: 18),
                        SingleColumnRow(txtString: Statics.getLabel('Shaakhaa') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(
                            txtString: Statics.getLabel('ShaakhaaEQ0'),
                            value: "${_ekatritVrutta['balShaakhaaEQ0'] + _ekatritVrutta['MahavidyaShaakhaaEQ0'] + _ekatritVrutta['TarunShaakhaaEQ0'] + _ekatritVrutta['ProudhShaakhaaEQ0']}",
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('Shaakhaa1To24'),
                            value: "${_ekatritVrutta['balShaakhaa1To24'] + _ekatritVrutta['MahavidyaShaakhaa1To24'] + _ekatritVrutta['TarunShaakhaa1To24'] + _ekatritVrutta['ProudhShaakhaa1To24']}",
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('ShaakhaaGTE25'),
                            value: "${_ekatritVrutta['balShaakhaaGTE25'] + _ekatritVrutta['MahavidyaShaakhaaGTE25'] + _ekatritVrutta['TarunShaakhaaGTE25'] + _ekatritVrutta['ProudhShaakhaaGTE25']}",
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('ShaakhaaEQ30'),
                            value: "${_ekatritVrutta['balShaakhaaEQ30'] + _ekatritVrutta['MahavidyaShaakhaaEQ30'] + _ekatritVrutta['TarunShaakhaaEQ30'] + _ekatritVrutta['ProudhShaakhaaEQ30']}",
                            fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('SaaptaahikMilan') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(
                            txtString: Statics.getLabel('SaaptaahikEQ0'),
                            value: "${_ekatritVrutta['balSaaptaahikEQ0'] + _ekatritVrutta['MahavidyataahikEQ0'] + _ekatritVrutta['TarunSaaptaahikEQ0'] + _ekatritVrutta['ProudhSaaptaahikEQ0']}",
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('Saaptaahik1To3'),
                            value:
                                "${_ekatritVrutta['balSaaptaahik1To3'] + _ekatritVrutta['MahavidyaSaaptaahik1To3'] + _ekatritVrutta['TarunSaaptaahik1To3'] + _ekatritVrutta['ProudhSaaptaahik1To3']}",
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('SaaptaahikGTE4'),
                            value:
                                "${_ekatritVrutta['balSaaptaahikGTE4'] + _ekatritVrutta['MahavidyaSaaptaahikGTE4'] + _ekatritVrutta['TarunSaaptaahikGTE4'] + _ekatritVrutta['ProudhSaaptaahikGTE4']}",
                            fontsize: 15),
                        SingleColumnRow(txtString: Statics.getLabel('MaasikMilan') + '/' + Statics.getLabel('SanghaMandali') + ':-', value: '', fontsize: 18),
                        SingleColumnRow(
                            txtString: Statics.getLabel('MaasikEQ0'),
                            value: "${_ekatritVrutta['balMaasikEQ0'] + _ekatritVrutta['MahavidyaMaasikEQ0'] + _ekatritVrutta['TarunMaasikEQ0'] + _ekatritVrutta['ProudhMaasikEQ0']}",
                            fontsize: 15),
                        SingleColumnRow(
                            txtString: Statics.getLabel('MaasikEQ1'),
                            value: "${_ekatritVrutta['balMaasikEQ1'] + _ekatritVrutta['MahavidyaMaasikEQ1'] + _ekatritVrutta['TarunMaasikEQ1'] + _ekatritVrutta['ProudhMaasikEQ1']}",
                            fontsize: 15),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String getTotalCount(ekatritVrutta) {
    String totalCount = "0";
    try {
      totalCount = (int.parse(ekatritVrutta['BaalSamparkYuktaGraamCount'].toString()) +
              int.parse(ekatritVrutta['MahaavidyaalayeenSamparkYuktaGraamCount'].toString()) +
              int.parse(ekatritVrutta['VyavasaayeeSamparkYuktaGraamCount'].toString()) +
              int.parse(ekatritVrutta['ProudhaSamparkYuktaGraamCount'].toString()))
          .toString();
      return totalCount;
    } catch (e) {
      print(e);
      return totalCount;
    }
  }
}
