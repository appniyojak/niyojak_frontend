import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:niyojak_prod/helpers/static_data.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:http/http.dart' as http;
import '../helpers/static_data.dart' as Statics;
import '../models/response_model/get_otp_model.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  static const String routeName = '/forget-password-screen';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 60.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        Statics.getLabel('logInBanner'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child:  LogInOTPCard(),
                  ),
                  Text(
                    'Version - ${Statics.packageInfo['versionNumber']}${Statics.patchSuffix}',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogInOTPCard extends StatefulWidget {
  @override
  _LogInOTPCardState createState() => _LogInOTPCardState();
}

class _LogInOTPCardState extends State<LogInOTPCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _enteredotpController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Timer? _timer;
  int _secondsRemaining = 0;
  bool _showEnterOtp = false;
  var showPasswordFields = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  GetOtpModel? getOtpModel;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneNumberController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSendingOtp = true;
    });
    try {
      final response = await http.post(
        Uri.parse(getOtpForForgetPassWord),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'MobileNumber': _phoneNumberController.text.toString()}),
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print("responseBody  $responseBody");
        getOtpModel = GetOtpModel.fromJson(responseBody);
        _otpController.text = getOtpModel!.otp!;
        setState(() {
          _showEnterOtp = true;
          _startTimer();
        });
      } else {
        print("_sendOtp 3 $_sendOtp");
        _showError(Statics.getLabel('sendFailedOTP'));
      }
    } catch (error) {
      print("_sendOtp 4 $_sendOtp");
      _showError(Statics.getLabel('sendFailedOTP'));
    } finally {
      setState(() {
        _isSendingOtp = false;
      });
    }
  }


  Future<void> submitChangePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSendingOtp = true;
    });
    try {
      final response = await http.post(
        Uri.parse(forgotPasswordApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
              'newpassword': _confirmPasswordController.text.toString(),
              'SwayamsevakID': getOtpModel!.swayamsevakID,
            }),
      );
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print("responseBody  $responseBody");
        _showSuccess(Statics.getLabel('passwordchangeSuccess'));
        Navigator.of(context).pushReplacementNamed(LogInScreen.routeName);
        setState(() {
          _showEnterOtp = true;
          _startTimer();
        });
      } else {
        _showError(Statics.getLabel('mobileNumberLabel'));
      }
    } catch (error) {
      print("submitChangePassword 4 ");
      _showError(Statics.getLabel('FailedtoChangePass'));
    } finally {
      print("submitChangePassword 5 ");
      setState(() {
        _isSendingOtp = false;
      });
    }
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_enteredotpController.text.length != 4) {
      _showError(Statics.getLabel('digit4validation'));
      return;
    }
    setState(() {
      _isVerifyingOtp = true;
    });
    try {
      if (_otpController.text.toString() == _enteredotpController.text.toString()) {
        setState(() {
          showPasswordFields = true;
        });
        _showSuccess(Statics.getLabel('OTPSucess'));
      } else {
        _showError(Statics.getLabel('InvalidOTP'));
      }
    } catch (error) {
      _showError(Statics.getLabel('InvalidOTP'));
    } finally {
      setState(() {
        _isVerifyingOtp = false;
      });
    }
  }



  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.red))),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.green))),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_showEnterOtp && !showPasswordFields)
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: Statics.getLabel('mobileNumberLabel'),),
                  validator: (value) {
                    if (value == null || value.length != 10) {
                      return Statics.getLabel('mobileValidation');
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                if (_showEnterOtp && !showPasswordFields)
                  Column(
                    children: [
                      PinInputTextField(
                        controller: _enteredotpController,
                        pinLength: 4,
                        decoration: UnderlineDecoration(
                          colorBuilder: PinListenColorBuilder(Colors.black, Colors.blue),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                if (!showPasswordFields)
                ElevatedButton(
                  onPressed: _isSendingOtp
                      ? null
                      : _showEnterOtp && _secondsRemaining > 0
                      ? null
                      : _sendOtp,
                  child: _isSendingOtp
                      ? CircularProgressIndicator()
                      : Text(_showEnterOtp && _secondsRemaining > 0
                      ? '${Statics.getLabel('ReSendOtp')} $_secondsRemaining'
                      : Statics.getLabel('SendOtp')),
                ),
                if (!showPasswordFields && _showEnterOtp)
                  ElevatedButton(
                    onPressed: _isVerifyingOtp ? null : _verifyOtp,
                    child: _isVerifyingOtp
                        ? CircularProgressIndicator()
                        : Text(Statics.getLabel('VerifyOTP')),
                  ),
                if (showPasswordFields)
                  Column(
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(labelText: Statics.getLabel('NewPassword')),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 4) {
                            return Statics.getLabel('NewPasswordValidationMessage');
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(labelText: Statics.getLabel('ConfirmPassword')),
                        obscureText: true,
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return Statics.getLabel('PasswordValidationMessage');
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitChangePassword();

                            print("Password successfully reset");
                          }
                        },
                        child: Text(Statics.getLabel('Submit')),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
