import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/titlebar.dart';
import '../helpers/static_data.dart' as Statics;

class ShaakhaaSevaVastiLink extends StatefulWidget {
  static const routeName = '/shaakhaa-sewa-vasti-screen';
  @override
  _ShaakhaaSevaVastiLinkState createState() => _ShaakhaaSevaVastiLinkState();
}

class _ShaakhaaSevaVastiLinkState extends State<ShaakhaaSevaVastiLink> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  //bool _isChecked = false;
  List<dynamic>? _sewaVastiList;
  Statics.ScreenArguments? args;
  var shaakhaaID;
  var _isFirstCall = true;
  var _isLoading = false;
  bool _isfetingData = false;
  var shaakhaaName = '';

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstCall == true) {
      args = ModalRoute.of(context)!.settings.arguments as Statics.ScreenArguments;
      shaakhaaID = args!.itemID;
      shaakhaaName = args!.viewType;
      getVastiList();
    }
    _isFirstCall = false;
  }

  void getVastiList() async {
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      setState(() {
        _isfetingData = true;
      });
      var data = await Statics.getShaakhaaSewaVastiLinksForApp(shaakhaaID);
      setState(() {
        _sewaVastiList = data;
      });
      setState(() {
        _isfetingData = false;
      });
    } else {
      setState(() {
        _isfetingData = false;
      });
      _sewaVastiList = null;
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        await saveSwDetails();
      }
    } on Exception catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }

    setState(() {
      _isLoading = false;
    });
  }

  saveSwDetails() async {
    var inputData = '{"ShaakhaaSewaVastiLinkList":[';
    for (int i = 0; i < _sewaVastiList!.length; i++) {
      if (_sewaVastiList![i]["ShaakhaaID"] == null || _sewaVastiList![i]["ShaakhaaID"].toString() == shaakhaaID) {
        inputData += '{"PraantID": 1, "ShaakhaaID": ' +
            shaakhaaID +
            ', "SewaVastiID": ' +
            _sewaVastiList![i]["SewaVastiID"].toString() +
            ', "IsLinked": ' +
            (_sewaVastiList![i]["IsLinked"] == true ? 'true' : 'false') +
            '},';
      }
    }
    if (inputData != "") {
      inputData = inputData.substring(0, inputData.length - 1);
      inputData += '],"ModifiedBy": ' + Statics.userDetails["userID"].toString() + '}';
    }
    var data = await Statics.saveShaakhaaSewaVastiLinkForApp(inputData);

    setState(() {
      shaakhaaID = data;
      getVastiList();
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  Statics.getLabel('SewaVasti'),
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              width: Statics.getDeviceSize(context).width,
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  TitleBar(extraString: shaakhaaName, fontsize: 15),
                  SizedBox(height: 10),
                  AbsorbPointer(
                    absorbing: (
                        // (Statics.userDetails["LevelName"] == "Bhaag" || Statics.userDetails["LevelName"] == "Nagar")
                        (Statics.userDetails["LevelName"] == "Bhaag" ||Statics.userDetails["LevelName"] == "भाग/जिला" ||Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
                            Statics.userDetails["LevelName"] == "Nagar" || Statics.userDetails["LevelName"] == "नगर/तालुका")
                            &&
                            // (Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
                            //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                            //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah")
                        (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                            Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                            Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
                            Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
                            Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
                            Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" )
                    )
                        ? false
                        : true,
                    child: Container(
                      // height: Statics.getDeviceSize(context).height * 0.7,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _sewaVastiList == null ? 1 : _sewaVastiList!.length,
                        itemBuilder: (context, i) {
                          if (_sewaVastiList == null || _sewaVastiList!.length == 0) {
                            return Center(child: Text(Statics.getLabel('noDataFoundTryAnotherSearch')));
                          } else {
                            return AbsorbPointer(
                              absorbing: (_sewaVastiList![i]["ShaakhaaID"] == null || _sewaVastiList![i]["ShaakhaaID"].toString() == shaakhaaID)
                                  ? false
                                  : true,
                              child: ListTile(
                                title: Card(
                                  margin: EdgeInsets.all(5),
                                  elevation: 5,
                                  child: ListTile(
                                    title: Text(_sewaVastiList![i]["SewaVastiName"]),
                                    subtitle: Text(_sewaVastiList![i]["ShaakhaaName"]),
                                    leading: Checkbox(
                                        checkColor: Colors.white,
                                        activeColor:
                                            (_sewaVastiList![i]["ShaakhaaID"] == null || _sewaVastiList![i]["ShaakhaaID"].toString() == shaakhaaID)
                                                ? Colors.purple
                                                : Colors.grey,
                                        value: _sewaVastiList![i]["IsLinked"] == null ? false : _sewaVastiList![i]["IsLinked"],
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              _sewaVastiList![i]["IsLinked"] = value;
                                              _sewaVastiList![i]["ShaakhaaID"] = shaakhaaID;
                                            } else {
                                              _sewaVastiList![i]["IsLinked"] = value;
                                              _sewaVastiList![i]["ShaakhaaID"] = null;
                                            }
                                          });
                                        }),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else if ((
                      // (Statics.userDetails["LevelName"] == "Bhaag" || Statics.userDetails["LevelName"] == "Nagar")
                      (Statics.userDetails["LevelName"] == "Bhaag" ||Statics.userDetails["LevelName"] == "भाग/जिला" ||Statics.userDetails["LevelName"] == "भाग/जिल्हा" ||
                          Statics.userDetails["LevelName"] == "Nagar" || Statics.userDetails["LevelName"] == "नगर/तालुका")
                          &&
                          // (Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||
                          //     Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||
                          //     Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah")
                      (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
                          Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" || Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
                          Statics.userDetails["DaayitvaName"] == "Baal Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Mahaavidyaalayeen Vidyaarthi Pramukh"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"   || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी प्रमुख"  ||Statics.userDetails["DaayitvaName"] == "Vyavasaayee Saha-Pramukh"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"   || Statics.userDetails["DaayitvaName"] == "व्यवसायी सह प्रमुख"  || Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Tarun Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "तरुण व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Praudh Vyavsayee Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "प्रौढ व्यवसायी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Bal Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "बाल विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "Mahavidyaleen Vidyarthi Sah Pramukh" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" || Statics.userDetails["DaayitvaName"] == "महाविद्यालयीन विद्यार्थी सह प्रमुख" ||
Statics.userDetails["DaayitvaName"] == "App Sanyojak"  ||Statics.userDetails["DaayitvaName"] == "एप संयोजक" ||
                          Statics.userDetails["DaayitvaName"] == "Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "कार्यवाह" ||
                          Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
                          Statics.userDetails["DaayitvaName"] == "Saha-Kaaryavaah" ||Statics.userDetails["DaayitvaName"] == "सह कार्यवाह" )
                  ) ==
                      false)
                    Container()
                  else
                    MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button!.color,
                      onPressed: _submit,
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                ]),
              ),
            ),
          ),
        ),
        inAsyncCall: _isfetingData);
  }
}
