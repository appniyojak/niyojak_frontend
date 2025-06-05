import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/legend.dart';

import '../helpers/static_data.dart' as Statics;
import '../widgets/app_drawer.dart';
import '../screens/home_screen.dart';
import '../providers/bals.dart';

class ProfileSettings extends StatefulWidget {
  static const String routeName = '/profile-settings';
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  StaticMasterBAL? _prfrdLangvalue = null;
  int? _selprfrdLangvalue = null;
  String? _selprfrdLangCode = "";
  var _isLoading = false;

  List<StaticMasterBAL>? _prfrdLang;

  String _otpUser='';

  @override
  void initState() {
    super.initState();
    populateDropdown();
  }

  void populateDropdown() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _otpUser =  pref.getString("otpuser")?? '';
    print("_otpUser $_otpUser");
    var data = await Statics.getStaticLDB("PreferredLanguage");
    setState(() {
      _prfrdLang = data;
      populateDetails();
    });
  }

  void populateDetails() async {
    var data = _prfrdLang![_prfrdLang!.indexWhere((p) => p.code == Statics.userDetails["languagePreference"] && p.entityType == "PreferredLanguage")];
    setState(() {
      _prfrdLangvalue = data;
    });
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
        await saveProfileDetails();
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

  saveProfileDetails() async {
    var data = await Statics.updateProfileData("PreferredLanguageID", _selprfrdLangvalue.toString(), _selprfrdLangCode!);
    if (data == "Cannot Update Settings")
      Statics.showToast(data);
    else {
      setState(() {
        Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => ProfileSettings()));
        //populateDetails();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      if (Navigator.of(context).canPop()) {
        print("sdjhs:--- ${Navigator.of(context).canPop()}");
        Navigator.of(context).pop();
      } else {
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
      }
      return false;
    },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('ChangeLanguage'),
            style: TextStyle(fontSize: 24),
          ),
        ),
        drawer: _otpUser =="true" ? Container():AppDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Legend(legendString: 'PersonalDetails'),
                        Text(Statics.userDetails['FullName'], style: TextStyle(fontSize: 24)),
                        Wrap(
                          spacing: 5,
                          children: [
                            Text(
                              Statics.userDetails['DaayitvaGeoUnitName'],
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              Statics.userDetails['LevelName'],
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              Statics.userDetails['DaayitvaName'],
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Legend(legendString: 'ChangeLanguage'),
                  if(_prfrdLang != null)
                  DropdownButtonFormField<StaticMasterBAL>(
                    decoration: InputDecoration(labelText: Statics.getLabel('SelectPreferredLanguage')),
                    isExpanded: true,
                    value: _prfrdLangvalue == null ? null : _prfrdLangvalue,
                    items: _prfrdLang!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                    onChanged: (value) {
                      setState(() {
                        _prfrdLangvalue = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) return Statics.getLabel('PreferredLanguageValidationMessage');

                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _selprfrdLangvalue = value.staticID;
                        _selprfrdLangCode = value.code!;
                      } else
                        _selprfrdLangvalue = _selprfrdLangCode = null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
