import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../widgets/legend.dart';

class JoinRSSDetails extends StatefulWidget {
  var joinRSSID;
  var onSaveDetails;
  var viewType;

  JoinRSSDetails({Key? key, this.joinRSSID, this.onSaveDetails, this.viewType}) : super(key: key);

  @override
  _JoinRSSDetailsState createState() => _JoinRSSDetailsState();
}

class _JoinRSSDetailsState extends State<JoinRSSDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isfetingData = false;

  JoinRSSBAL? sDetails;

  var _fullNameCntrl = TextEditingController();
  var _emailBodyCntrl = TextEditingController();
  var _mobileCntrl = TextEditingController();
  var _emailCntrl = TextEditingController();
  var _addressCntrl = TextEditingController();
  var _stateCntrl = TextEditingController();
  var _districtCntrl = TextEditingController();
  var _cityCntrl = TextEditingController();
  var _countryCntrl = TextEditingController();
  var _ageCntrl = TextEditingController();
  var _occupationCntrl = TextEditingController();
  var _remarkCntrl = TextEditingController();
  var _statusremarkCntrl = TextEditingController();
  var _jrsremarkCntrl = TextEditingController();

  String? _genderValue;
  String? geoUnitIDnew;
  List<StaticMasterBAL>? _genderList;

  String? _bhaagValue = "";
  String? _shaharValue = "";
  String? _nagarValue = "";
  String? _statusValue = "";

  List<GeoUnitMasterBAL>? _bhaag;
  List<GeoUnitMasterBAL>? _shahar;
  List<GeoUnitMasterBAL>? _nagar;
  List<StaticMasterBAL>? _status;

  DateTime? _joiningDate;
  var _joiningDateCntrl = TextEditingController();

  List<DataColumn>? _detailscolumns;
  List<DataRow>? _detailsrows;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    //populateDropdown();
    //int joinRSSID = int.parse(widget.joinRSSID);
    // if (joinRSSID > 0) {
    //   getJoinRSSDetails(widget.joinRSSID);
    // } else {
    //   if (!mounted) return;
    //   setState(() {
    //     _joiningDate = DateTime.now();
    //     _joiningDateCntrl.text =
    //         DateFormat('dd-MMM-yyyy').format(DateTime.now());

    //     sDetails = new JoinRSSBAL(joinRSSID, 1, null, null, null, null, "", "",
    //         "", "", null, "", "", "", "", "", "", "", "", "", "", "", "");
    //   });
    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    populateDropdown();
    int joinRSSID = int.parse(widget.joinRSSID);
    if (joinRSSID > 0) {
      getJoinRSSDetails(widget.joinRSSID);
    } else {
      if (!mounted) return;
      setState(() {
        _joiningDate = DateTime.now();
        _joiningDateCntrl.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());

        sDetails = new JoinRSSBAL(joinRSSID, 1, null, null, null, null, "", "", "", "", null, "", "", "", "", "", "", "", "", "", "", "", "");
      });
    }
  }

  void populateBhaagDropdown() async {
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");

    setState(() {
      _bhaag = data;
    });
  }

  void populateShaharDropdown(String bhaagIDStr) async {
    _shaharValue = null;
    _shahar = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _shahar = (shDD.length > 0 ? shDD : null);
    });
  }

  void populateNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _nagarValue = null;
    _nagar = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _nagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _nagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  void getDetailsColumnsandRows(List<dynamic> dataList) async {
    List<DataColumn> cols = [];

    cols.add(new DataColumn(label: Text(Statics.getLabel('StatusDate'))));
    cols.add(new DataColumn(label: Text(Statics.getLabel('Status'))));
    cols.add(new DataColumn(label: Text(Statics.getLabel('Status') + " " + Statics.getLabel('Remark'))));

    List<DataRow> row = [];
    for (var data in dataList) {
      List<DataCell> cells = [];

      cells.add(new DataCell(Container(width: 100, child: Text(data["StatusDateStr"].toString()))));
      cells.add(new DataCell(Container(width: 100, child: Text(data["StatusCode"].toString()))));
      cells.add(new DataCell(Container(width: 100, child: Text(data["StatusRemark"].toString()))));

      row.add(new DataRow(cells: cells));
    }
    setState(() {
      _detailscolumns = cols;
      _detailsrows = row;
    });
  }

  void getJoinRSSDetails(var theId) async {
    print("theIdtheId ==> $theId");
    setState(() {
      _isfetingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await Statics.getJoinRSSDataByID(theId.toString(), "Data");
      JoinRSSBAL? _joinRSSBAL;

      if (data.isNotEmpty) {
        _joinRSSBAL = JoinRSSBAL.fromMap(data);
        var datalist = data["ListStatusHistory"];
        log("datalist $datalist");
        // if (datalist.length > 0) old condition
        if (datalist != null)
          getDetailsColumnsandRows(datalist);
        else {
          setState(() {
            _detailscolumns = null;
            _detailsrows = null;
          });
        }
      } else {
        _joinRSSBAL = null;
      }
      if (!mounted) return;
      setState(() {
        sDetails = _joinRSSBAL;
        if (sDetails != null) {
          _fullNameCntrl.text = sDetails!.name.toString();
          _mobileCntrl.text = sDetails!.mobileNumber.toString();
          _emailCntrl.text = sDetails!.email.toString();
          _addressCntrl.text = sDetails!.address.toString();
          _genderValue = sDetails!.genderID == null ? null : sDetails!.genderID.toString();

          _districtCntrl.text = sDetails!.districtName == null ? "" : sDetails!.districtName.toString();

          _cityCntrl.text = sDetails!.cityName == null ? "" : sDetails!.cityName.toString();

          _stateCntrl.text = sDetails!.stateName == null ? "" : sDetails!.stateName.toString();

          _countryCntrl.text = sDetails!.country == null ? "" : sDetails!.country.toString();

          _ageCntrl.text = sDetails!.age == null ? "" : sDetails!.age.toString();

          _occupationCntrl.text = sDetails!.occupation == null ? "" : sDetails!.occupation.toString();

          _remarkCntrl.text = sDetails!.remark == null ? "" : sDetails!.remark.toString();

          _joiningDate = (sDetails!.joiningDate != null ? DateTime.parse(sDetails!.joiningDate!) : null);
          _joiningDateCntrl.text = (sDetails!.joiningDate != null ? DateFormat('dd-MMM-yyyy').format(_joiningDate!) : '');

          _statusremarkCntrl.text = sDetails!.statusRemark == null ? "" : sDetails!.statusRemark.toString();

          _jrsremarkCntrl.text = sDetails!.jRSRemark == null ? "" : sDetails!.jRSRemark.toString();

          _statusValue = sDetails!.statusID == null ? null : sDetails!.statusID.toString();

          _bhaagValue = sDetails!.bhaagID == null ? null : sDetails!.bhaagID.toString();
          if (_bhaagValue != null) {
            populateShaharDropdown(_bhaagValue!);
            populateNagarDropdown(_bhaagValue, null);
          }
          _shaharValue = sDetails!.shaharID == null ? null : sDetails!.shaharID.toString();

          if (_shaharValue != null) {
            populateNagarDropdown(null, _shaharValue);
          }

          _nagarValue = sDetails!.nagarID == null ? null : sDetails!.nagarID.toString();
        }
      });
    }
    setState(() {
      _isfetingData = false;
    });
  }

  _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: _joiningDate == null ? DateTime.now() : _joiningDate!,
        firstDate: DateTime((_joiningDate == null ? DateTime.now().year : _joiningDate!.year) - 80),
        lastDate: DateTime((_joiningDate == null ? DateTime.now().year : _joiningDate!.year) + 80));

    if (date != null) {
      setState(() {
        _joiningDate = date;
        _joiningDateCntrl.text = DateFormat('dd-MMM-yyyy').format(date);
      });
    }
  }

  void populateDropdown() async {
    var data = await Statics.getStaticLDB('Gender');
    var data1 = await Statics.getStaticLDB("JoinRSSStatus");

    if (!mounted) return;
    setState(() {
      _genderList = data;
      _status = data1;
    });
    populateBhaagDropdown();
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameCntrl.dispose();
    _mobileCntrl.dispose();
    _emailCntrl.dispose();
    _addressCntrl.dispose();
    _stateCntrl.dispose();
    _districtCntrl.dispose();
    _cityCntrl.dispose();
    _countryCntrl.dispose();
    _ageCntrl.dispose();
    _occupationCntrl.dispose();
    _remarkCntrl.dispose();
    _statusremarkCntrl.dispose();
    _jrsremarkCntrl.dispose();
    _emailBodyCntrl.dispose();
  }

  _submit() async {
    print("sub 1");
    if (!_formKey.currentState!.validate()) {
      print("sub 2");

      // Invalid!
      return false;
    }
    print("sub 3");

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      print("sub 4");

      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        print("sub5");

        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        print("sub 6");

        await saveSwDetails();
      }
      print("sub 7");
    } on Exception catch (error) {
      print("sub 8");

      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      print("sub 9");

      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }
    print("sub 10");

    setState(() {
      print("sub 11");

      _isLoading = false;
    });
  }

  void _populateFields() {
    if (_emailBodyCntrl.text.trim() == "") {
      Statics.showErrorDialog(context, Statics.getLabel('EmailBodyValidationMessage'));
      return;
    } else {
      var txt = _emailBodyCntrl.text;
      if (txt.contains("First Name:") &&
          txt.contains("Last Name:") &&
          txt.contains("Gender:") &&
          txt.contains("Address:") &&
          txt.contains("City:") &&
          txt.contains("District:") &&
          txt.contains("State:") &&
          txt.contains("Country:") &&
          txt.contains("Email:") &&
          txt.contains("Phone:") &&
          txt.contains("Age:") &&
          txt.contains("Occupation:") &&
          txt.contains("Remark:")) {
        int firstNameidx = txt.indexOf("First Name:");
        int lastNameidx = txt.indexOf("Last Name:");
        int genderIdx = txt.indexOf("Gender:");
        int addressIdx = txt.indexOf("Address:");
        int cityIdx = txt.indexOf("City:");
        int districtIdx = txt.indexOf("District:");
        int stateIdx = txt.indexOf("State:");
        int countryIdx = txt.indexOf("Country:");
        int emailIdx = txt.indexOf("Email:");
        int phoneIdx = txt.indexOf("Phone:");
        int ageIdx = txt.indexOf("Age:");
        int occupationIdx = txt.indexOf("Occupation:");
        int remarkIdx = txt.indexOf("Remark:");

        String firstName = txt.substring(firstNameidx, lastNameidx).split(":").length == 2 ? txt.substring(firstNameidx, lastNameidx).split(":")[1].trim() : "";
        String lastName = txt.substring(lastNameidx, genderIdx).split(":").length == 2 ? txt.substring(lastNameidx, genderIdx).split(":")[1].trim() : "";
        String gender = txt.substring(genderIdx, addressIdx).split(":").length == 2 ? txt.substring(genderIdx, addressIdx).split(":")[1].trim() : "";
        String address = txt.substring(addressIdx, cityIdx).split(":").length == 2 ? txt.substring(addressIdx, cityIdx).split(":")[1].trim() : "";
        String city = txt.substring(cityIdx, districtIdx).split(":").length == 2 ? txt.substring(cityIdx, districtIdx).split(":")[1].trim() : "";
        String district = txt.substring(districtIdx, stateIdx).split(":").length == 2 ? txt.substring(districtIdx, stateIdx).split(":")[1].trim() : "";
        String state = txt.substring(stateIdx, countryIdx).split(":").length == 2 ? txt.substring(stateIdx, countryIdx).split(":")[1].trim() : "";
        String country = txt.substring(countryIdx, emailIdx).split(":").length == 2 ? txt.substring(countryIdx, emailIdx).split(":")[1].trim() : "";
        String email = txt.substring(emailIdx, phoneIdx).split(":").length == 2 ? txt.substring(emailIdx, phoneIdx).split(":")[1].trim() : "";
        String phone = txt.substring(phoneIdx, ageIdx).split(":").length == 2 ? txt.substring(phoneIdx, ageIdx).split(":")[1].trim() : "";
        String age = txt.substring(ageIdx, occupationIdx).split(":").length == 2 ? txt.substring(ageIdx, occupationIdx).split(":")[1].trim() : "";
        String occupation = txt.substring(occupationIdx, remarkIdx).split(":").length == 2 ? txt.substring(occupationIdx, remarkIdx).split(":")[1].trim() : "";
        String remark = txt.substring(remarkIdx).split(":").length == 2 ? txt.substring(remarkIdx).split(":")[1].trim() : "";
        var statusValue = _status!.indexWhere((p) => p.code == "RecordCreated") > -1 ? _status![_status!.indexWhere((p) => p.code == "RecordCreated")].staticID.toString() : null;
        setState(() {
          _fullNameCntrl.text = firstName + " " + lastName;
          _genderValue = gender.toLowerCase() == "male"
              ? _genderList![_genderList!.indexWhere((p) => p.code == "Male")].staticID.toString()
              : gender.toLowerCase() == "female"
                  ? _genderList![_genderList!.indexWhere((p) => p.code == "Female")].staticID.toString()
                  : null;
          _addressCntrl.text = address;
          _cityCntrl.text = city;
          _districtCntrl.text = district;
          _stateCntrl.text = state;
          _countryCntrl.text = country;
          _emailCntrl.text = email;
          _mobileCntrl.text = phone;
          _ageCntrl.text = age;
          _occupationCntrl.text = occupation;
          _remarkCntrl.text = remark;
          _statusValue = statusValue;
        });
        Statics.showToast("Data fetched successfully");
      } else {
        Statics.showErrorDialog(context, Statics.getLabel('ValidEmailBodyValidationMessage'));

        _genderValue = null;
        _fullNameCntrl.text = _addressCntrl.text =
            _cityCntrl.text = _districtCntrl.text = _stateCntrl.text = _countryCntrl.text = _emailCntrl.text = _mobileCntrl.text = _ageCntrl.text = _occupationCntrl.text = _remarkCntrl.text = "";
      }
    }
  }

  saveSwDetails() async {
    var inputData = json.encode({
      "JoinRSSData": {
        "JoinRSSID": int.parse(widget.joinRSSID),
        "PraantID": 1,
        "Name": sDetails!.name,
        "MobileNumber": sDetails!.mobileNumber,
        "Email": sDetails!.email,
        "Address": sDetails!.address,
        "GenderID": sDetails!.genderID,
        "DistrictName": sDetails!.districtName,
        "CityName": sDetails!.cityName,
        "StateName": sDetails!.stateName,
        "Country": sDetails!.country,
        "Age": sDetails!.age,
        "Occupation": sDetails!.occupation,
        "Remark": sDetails!.remark,
        "JoiningDateStr": (_joiningDate != null ? DateFormat('yyyy-MM-dd').format(_joiningDate!) : null),
        "BhaagID": sDetails!.bhaagID,
        "ShaharID": sDetails!.shaharID,
        "NagarID": sDetails!.nagarID,
        "StatusID": sDetails!.statusID,
        "StatusRemark": sDetails!.statusRemark,
        "StatusDateStr": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "JRSRemark": sDetails!.jRSRemark
      },
      "ModifiedBy": Statics.userDetails["userID"].toString()
    });
    print("inputData  ----->>>>$inputData");
    var data = await Statics.saveJoinRSSForApp(inputData);
    print("data ---->>>$data");
    setState(() {
      widget.joinRSSID = data;
      widget.onSaveDetails(widget.joinRSSID);
      getJoinRSSDetails(data);
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: AbsorbPointer(
              absorbing: widget.viewType == "ViewMenu" ? true : false,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Legend(legendString: "searchJoinRSSScreenLabel", fontsize: 18),
                    AbsorbPointer(
                      absorbing: (Statics.userDetails["LevelName"] == "Praant" ||
                              Statics.userDetails["LevelName"] == "प्रांत" && Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
                              Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                              Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
                              Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख")
                          ? false
                          : true,
                      child: Column(
                        children: <Widget>[
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
                                    title: Text(Statics.getLabel('CopyFromEmail')),
                                  );
                                },
                                body: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 20, 10),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        textInputAction: TextInputAction.newline,
                                        controller: _emailBodyCntrl,
                                        decoration: InputDecoration(labelText: Statics.getLabel('EmailBody')),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 4,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 8,
                                        ),
                                        color: Theme.of(context).primaryColor,
                                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                        onPressed: _populateFields,
                                        child: Text(
                                          Statics.getLabel('PopulateFields'),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                isExpanded: _isExpanded,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _fullNameCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('FullName')),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) return (Statics.getLabel('FullNameValidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              sDetails!.name = value!.trim();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _mobileCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('Mobile')),
                            keyboardType: TextInputType.phone,
                            maxLength: 30,
                            validator: (value) {
                              if (value == null || value.isEmpty || value.trim().length < 10) return (Statics.getLabel('MobileValidationMessage'));
                              return null;
                            },
                            onSaved: (value) {
                              sDetails!.mobileNumber = value!.trim();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _emailCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('Email')),
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 100,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!value.contains('@')) return (Statics.getLabel('EmailValidationMessage'));
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                sDetails!.email = value.trim();
                              else
                                sDetails!.email = null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_genderList != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Gender')),
                              isExpanded: true,
                              value: _genderValue == null ? null : _genderValue,
                              items: _genderList!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _genderValue = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return (Statics.getLabel('GenderValidationMessage'));
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  sDetails!.genderID = int.parse(value);
                                else
                                  sDetails!.genderID = null;
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.newline,
                            controller: _addressCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('Address')),
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            maxLength: 200,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return (Statics.getLabel('AddressValidationMessage'));
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                sDetails!.address = value.trim();
                              else
                                sDetails!.address = null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _cityCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('City')),
                            keyboardType: TextInputType.text,
                            maxLength: 100,
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                sDetails!.cityName = value;
                              else
                                sDetails!.cityName = null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _districtCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('District')),
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 100,
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                sDetails!.districtName = value;
                              else
                                sDetails!.districtName = null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _stateCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('State')),
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 100,
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                sDetails!.stateName = value;
                              else
                                sDetails!.stateName = null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _countryCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('Country')),
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 100,
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                sDetails!.country = value;
                              else
                                sDetails!.country = null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _ageCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('Age')),
                            keyboardType: TextInputType.text,
                            maxLength: 100,
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                sDetails!.age = value;
                              else
                                sDetails!.age = null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _occupationCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('Occupation')),
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 100,
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                sDetails!.occupation = value;
                              else
                                sDetails!.occupation = null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.newline,
                            controller: _remarkCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('Remark')),
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            maxLength: 200,
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                sDetails!.remark = value;
                              else
                                sDetails!.remark = null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.7,
                                child: TextField(
                                  enabled: false,
                                  controller: _joiningDateCntrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('JoiningDate')),
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              IconButton(
                                color: Colors.purple,
                                icon: FaIcon(FontAwesomeIcons.solidCalendarAlt),
                                onPressed: _pickDate,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _jrsremarkCntrl,
                            decoration: InputDecoration(labelText: Statics.getLabel('JRSRemark')),
                            keyboardType: TextInputType.text,
                            maxLength: 200,
                            onSaved: (value) {
                              if (value!.isNotEmpty)
                                sDetails!.jRSRemark = value;
                              else
                                sDetails!.jRSRemark = null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 80,
                                child: MaterialButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    color: Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                                    onPressed: () {
                                      setState(() {
                                        _bhaagValue = _shaharValue = _nagarValue = null;
                                        _bhaag = _shahar = _nagar = null;
                                      });
                                      populateBhaagDropdown();
                                    },
                                    child: Text(
                                      Statics.getLabel('clear'),
                                      style: TextStyle(fontSize: 12),
                                    )),
                              ),
                            ],
                          ),
                          // LevelWiseDropdown(onFinalSelection: (String? geoUnitID) {
                          //   print("geoUnitID :- $geoUnitID");
                          // setState(() {
                          //   geoUnitIDnew = geoUnitID;
                          // });},),
                          if (_bhaag != null)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                              isExpanded: true,
                              value: _bhaagValue == "" ? null : _bhaagValue,
                              items: _bhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              validator: (value) {
                                print("ahbc acbas cjb cjacjka >>>>>>>");
                                if (value == null || value.isEmpty) return (Statics.getLabel('SelectBhaagValidationMessage'));
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _bhaagValue = value;
                                  populateShaharDropdown(value!);
                                  populateNagarDropdown(value, null);
                                });
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  sDetails!.bhaagID = int.parse(value);
                                else
                                  sDetails!.bhaagID = null;
                              },
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (_shahar != null && _shahar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                              isExpanded: true,
                              value: _shaharValue == "" ? null : _shaharValue,
                              items: _shahar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _shaharValue = value;
                                  populateNagarDropdown(null, value);
                                });
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  sDetails!.shaharID = int.parse(value);
                                else
                                  sDetails!.shaharID = null;
                              },
                            ),
                          if (_shahar != null && _shahar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (_nagar != null && _nagar!.length > 0)
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                              isExpanded: true,
                              value: _nagarValue == "" ? null : _nagarValue,
                              items: _nagar!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _nagarValue = value;
                                });
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  sDetails!.nagarID = int.parse(value);
                                else
                                  sDetails!.nagarID = null;
                              },
                            ),
                          if (_nagar != null && _nagar!.length > 0)
                            SizedBox(
                              height: 10,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_status != null)
                      DropdownButtonFormField(
                        decoration: InputDecoration(labelText: Statics.getLabel('Status')),
                        isExpanded: true,
                        value: _statusValue == "" ? null : _statusValue,
                        items: _status!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return (Statics.getLabel('StatusValidationMessage'));
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _statusValue = value;
                          });
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty)
                            sDetails!.statusID = int.parse(value);
                          else
                            sDetails!.statusID = null;
                        },
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _statusremarkCntrl,
                      decoration: InputDecoration(labelText: Statics.getLabel('Status') + " " + Statics.getLabel('Remark')),
                      keyboardType: TextInputType.text,
                      maxLength: 200,
                      onSaved: (value) {
                        if (value!.isNotEmpty)
                          sDetails!.statusRemark = value;
                        else
                          sDetails!.statusRemark = null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else if (widget.viewType == "ViewMenu")
                      Text(Statics.getLabel('canNotMakeChanges'))
                    else
                      MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: () async {
                          print("JKdfhskff");
                          await _submit().then((value) {
                            if (value != null && !value) return;
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_detailscolumns != null) Legend(legendString: "StatusHistory", fontsize: 18),
                    if (_detailscolumns != null)
                      Container(
                        height: Statics.getDeviceSize(context).height * 0.3,
                        width: Statics.getDeviceSize(context).width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                DataTable(
                                  columnSpacing: 20,
                                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                                  columns: _detailscolumns!,
                                  rows: _detailsrows!,
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
          ),
        ),
        inAsyncCall: _isfetingData);
  }
}
