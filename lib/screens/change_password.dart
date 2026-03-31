import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

import '../helpers/static_data.dart' as Statics;
import 'home_screen/home_screen.dart';

class ChangePassword extends StatefulWidget {
  static const String routeName = '/change-password-screen';

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _oldPasswordCntrl = TextEditingController();
  var _newPasswordCntrl = TextEditingController();
  var _cnfirmCntrl = TextEditingController();
  var _isLoading = false;

  var _oldPassword = "";
  var _newPassword = "";
  var _cnfrmPassword = "";

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
      // Log user in
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showErrorDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        print(" _submit() --  (_oldPassword  $_oldPassword, _newPassword  $_newPassword)");
        var message = await Statics.updatePassword(_oldPassword, _newPassword);
        if (message == "Please enter correct password") {
          Statics.showToast(message);
        } else {
          Statics.showToast(message);
          Navigator.of(context).pushReplacementNamed('/');
        }
      }
    } on Exception catch (ex) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
    }

    setState(() {
      //print('login_screen.dart - here ${Statics.userDetails['isAuthorized']}');
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!Statics.userDetails['isFirstLogin']) {
          Navigator.popAndPushNamed(context, HomeScreen.routeName);
          return true;
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('ChangePassword'),
            style: TextStyle(fontSize: 24),
          ),
        ),
        drawer: (Statics.userDetails['isFirstLogin'] ? null : AppDrawer()),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _oldPasswordCntrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('OldPassword')),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) return (Statics.getLabel('OldPasswordValidationMessage'));
                      return null;
                    },
                    onSaved: (value) {
                      _oldPassword = value!;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _newPasswordCntrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('NewPassword')),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) return (Statics.getLabel('NewPasswordValidationMessage'));
                      if (value == _oldPasswordCntrl.text) return (Statics.getLabel('oldPasswordMatchValidationMessage'));
                      if (value != _cnfirmCntrl.text) return (Statics.getLabel('PasswordValidationMessage'));
                      return null;
                    },
                    onSaved: (value) {
                      _newPassword = value!;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _cnfirmCntrl,
                    decoration: InputDecoration(labelText: Statics.getLabel('ConfirmPassword')),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) return (Statics.getLabel('ConfirmPasswordValidationMessage'));
                      if (value != _newPasswordCntrl.text) return (Statics.getLabel('PasswordValidationMessage'));
                      return null;
                    },
                    onSaved: (value) {
                      _cnfrmPassword = value!;
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
                      textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                      onPressed: _submit,
                      child: Text(
                        Statics.getLabel('Submit'),
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
