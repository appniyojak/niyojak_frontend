import 'dart:async';
import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:niyojak_prod/helpers/database_helper.dart';
import 'package:niyojak_prod/models/response_model/AbhiyaanLoginDataResponse.dart';
import 'package:niyojak_prod/screens/AbhiyanScreen.dart';
import 'package:niyojak_prod/screens/edit_swayamsevak_screen.dart';
import 'package:niyojak_prod/screens/forget_password.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/static_data.dart' as Statics;
import '../helpers/static_data.dart';
import '../models/response_model/get_otp_model.dart';
import '../providers/login.dart';
import '../screens/change_password.dart';
import '../screens/home_screen.dart';
import '../screens/update_version.dart';
import '../utils/hard_loader.dart';

class LogInScreen extends StatefulWidget {
  static const String routeName = '/login-screen';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool showOTPCard = false;
  bool hardLoader = false;

  void switchCard() {
    setState(() {
      showOTPCard = !showOTPCard;
    });
  }

  @override
  void initState() {
    deleteDB();
    // TODO: implement initState

    super.initState();
  }

  deleteDB() async {
    deleteDatabase(await getDatabasesPath());
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = Statics.getDeviceSize(context);
    return WillPopScope(
      onWillPop: () => LoaderUtils.onWillPop(context), // Use the loader's onWillPop logic
      child: Scaffold(
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
                      child: showOTPCard ? LogInOTPCard(switchCard) : LogInCard(switchCard),
                    ),
                    Text(
                      'Version - ${Statics.packageInfo['versionNumber']}${Statics.patchSuffix}',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthService {
  static Future<void> loginWithPassword(BuildContext context, GlobalKey<FormState> formKey, Map<String, String> logInMap, ValueNotifier<bool> isLoadingNotifier, VoidCallback switchScreens) async {
    print("loginWithPassword 1");
    isLoadingNotifier.value = true;
    LoaderUtils.toggleLoader(context, true);
    print("Mobile :- ${logInMap['mobileNumber']} ..... password :- ${logInMap['password']} .......... otplogin:-  ${logInMap['otplogin']} ");
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) {
      print("loginWithPassword 2");

      // Invalid!
      LoaderUtils.toggleLoader(context, false);
      isLoadingNotifier.value = false;
      return;
    }
    formKey.currentState!.save();
    print("loginWithPassword 3");
    try {
      print("loginWithPassword 4");
      bool isConnected = await Statics.isInternetConnected();
      TextInput.finishAutofillContext();
      print("loginWithPassword 5");
      if (!isConnected) {
        print("loginWithPassword 6");
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
        LoaderUtils.toggleLoader(context, false);
        isLoadingNotifier.value = false;
      } else {
        print("loginWithPassword 7");
        await LogIn().usrLogIn(context, logInMap['mobileNumber']!, logInMap['password'], logInMap['otplogin']!);
        BackgroundFetch.start().then((int status) {
          print("loginWithPassword 8");
          print('[BackgroundFetch] start success: $status');
        }).catchError((e) {
          print("loginWithPassword 9");
          print('[BackgroundFetch] start FAILURE: $e');
          LoaderUtils.toggleLoader(context, false);
          isLoadingNotifier.value = false;
        });
        LoaderUtils.toggleLoader(context, false);
        isLoadingNotifier.value = false;
        print("loginWithPassword 10");
        switchScreens();
      }
    } on Exception catch (ex) {
      print("loginWithPassword 11");
      LoaderUtils.toggleLoader(context, false);
      Statics.showErrorDialog(context, Statics.getLabel('unableToCompleteProcess'));
      isLoadingNotifier.value = false;
      print("Eroorrrrrrrrrrr  $ex");
    } catch (error) {
      print("loginWithPassword 12");
      print(error);
      String errorMessage = Statics.getLabel('autheticationFailed');
      LoaderUtils.toggleLoader(context, false);
      Statics.showErrorDialog(context, errorMessage);
      isLoadingNotifier.value = false;
    }
    print("loginWithPassword 13");
  }

// static Future<void> loginWithOTP(BuildContext context, GlobalKey<FormState> formKey, String verificationId, TextEditingController otpController,
//     ValueNotifier<bool> isLoadingNotifier, logInmap, VoidCallback switchScreens) async {
//   print("loginWithOTP 1");
//   FocusScope.of(context).unfocus();
//   if (!formKey.currentState!.validate()) {
//     print("loginWithOTP 2");
//
//     // Invalid!
//     return;
//   }
//   print("loginWithOTP 3");
//
//   isLoadingNotifier.value = true;
//   try {
//     print("loginWithOTP 4");
//
//     // PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
//     //   verificationId: verificationId,
//     //   smsCode: otpController.text,
//     // );
//     // await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
//     print('Login OTP successful');
//     loginWithPassword(
//       context,
//       formKey,
//       logInmap,
//       isLoadingNotifier,
//       switchScreens,
//     );
//   } catch (e) {
//     print("loginWithOTP 5");
//
//     LoaderUtils.toggleLoader(context,false);
//     Statics.showErrorDialog(context, "Please check and enter the correct verification code again");
//     print('Error login with OTP: $e');
//     LoaderUtils.toggleLoader(context,false);
//     isLoadingNotifier.value = false;
//     LoaderUtils.toggleLoader(context,false);
//
//   }
//   print("loginWithOTP 6");
//
// }
}

class LogInOTPCard extends StatefulWidget {
  final VoidCallback switchCard;

  LogInOTPCard(this.switchCard);

  @override
  _LogInOTPCardState createState() => _LogInOTPCardState();
}

class _LogInOTPCardState extends State<LogInOTPCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isLoadingNotifier1 = ValueNotifier(false);

  var showEnterOtp = false;
  Timer? timer;
  int secondsRemaining = 30;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  String verificationId = '';
  Map<String, String> logInMap = {'mobileNumber': '', 'password': '', 'otplogin': '1'};
  AbhiyanSwayamsevakdata? initialData;

  @override
  void initState() {
    super.initState();

    _phoneNumberController.addListener(() {
      setState(() {
        logInMap['mobileNumber'] = _phoneNumberController.text;
      });
    });
    // _otpController.addListener(() {
    //   setState(() {
    //     logInMap['password'] = _otpController.text;
    //   });
    // });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _phoneNumberController.dispose();
    _otpController.dispose();
    timer!.cancel();
    super.dispose();
  }

  // Future<void> sendOTP() async {
  //   // setState(() {
  //   //   isLoadingNotifier.value = true;
  //   // });
  //   // isLoadingNotifier.value = false;
  //
  //   if (_phoneNumberController.text.isNotEmpty && _phoneNumberController.text.length == 10) {
  //
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: "+91${_phoneNumberController.text}",
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await auth.signInWithCredential(credential);
  //       },
  //       verificationFailed: (FirebaseException e) {
  //         LoaderUtils.toggleLoader(context,false);
  //         isLoadingNotifier.value = false;
  //         isLoadingNotifier1.value = false;
  //         // Statics.showToast(e.toString());
  //         Statics.showToast("Firebase Error");
  //         print("e:-- $e");
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         LoaderUtils.toggleLoader(context,false);
  //         isLoadingNotifier.value = false;
  //         isLoadingNotifier1.value = false;
  //         if(timer != null){
  //           timer!.cancel();
  //         }
  //         timer = Timer.periodic(const Duration(seconds: 1), (_) {
  //           if (secondsRemaining != 0) {
  //             setState(() {
  //               secondsRemaining--;
  //             });
  //           }
  //         });
  //         setState(() {
  //           this.verificationId = verificationId;
  //           showEnterOtp = true;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         LoaderUtils.toggleLoader(context,false);
  //         isLoadingNotifier.value = false;
  //         isLoadingNotifier1.value = false;
  //         setState(() {
  //           this.verificationId = verificationId;
  //         });
  //       },
  //     );
  //   } else {
  //     setState(() {
  //       LoaderUtils.toggleLoader(context,false);
  //       isLoadingNotifier.value = false;
  //       isLoadingNotifier1.value = false;
  //     });
  //     Statics.showToast( Statics.getLabel("EntervalidNumber"));
  //   }
  // }

  Timer? _timer;
  int _secondsRemaining = 0;
  bool _showEnterOtp = false;
  var showPasswordFields = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  GetOtpModel? getOtpModel;
  final TextEditingController _enteredotpController = TextEditingController();

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
          _isSendingOtp = false;
        });
        isLoadingNotifier.value = true;
        await AuthService.loginWithPassword(
          context,
          _formKey,
          logInMap,
          isLoadingNotifier,
          () => switchScreens2(context),
        );
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

  String formatTime(int seconds) {
    // Calculate minutes and seconds
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    // Format the time as "mm:ss"
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = Statics.getDeviceSize(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: 400,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: Statics.getLabel('mobileNumberLabel'),
                        ),
                        validator: (value) {
                          if (value == null || value.length != 10) {
                            return Statics.getLabel('mobileValidation');
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      // ValueListenableBuilder<bool>(
                      //   valueListenable: isLoadingNotifier1,
                      //   builder: (context, isLoading, child) {
                      //     return isLoading
                      //         ? CircularProgressIndicator()
                      //         : ElevatedButton(
                      //             onPressed: () async {
                      //               if(showEnterOtp && secondsRemaining != 0){
                      //                 return;
                      //               }
                      //               if (_phoneNumberController.text.isEmpty || _phoneNumberController.text.length != 10) {
                      //                 setState(() {
                      //                   LoaderUtils.toggleLoader(context,false);
                      //                   isLoadingNotifier.value = false;
                      //                   isLoadingNotifier1.value = false;
                      //                 });
                      //                 Statics.showToast( Statics.getLabel("EntervalidNumber"));
                      //                 return;
                      //               }
                      //               isLoadingNotifier1.value = true;
                      //               setState(() {});
                      //               await _sendOtp();
                      //               if (verificationId.isNotEmpty) {
                      //                 // isLoadingNotifier1.value = false;
                      //                 _otpController.clear();
                      //               }
                      //             },
                      //             child: Text(showEnterOtp ? secondsRemaining != 0 ? formatTime(secondsRemaining) :  Statics.getLabel('ReSendOtp') : Statics.getLabel('SendOtp')),
                      //           );
                      //   },
                      // ),
                      if (!showPasswordFields)
                        ElevatedButton(
                          onPressed: _isSendingOtp
                              ? null
                              : _showEnterOtp && _secondsRemaining > 0
                                  ? null
                                  : _sendOtp,
                          child: _isSendingOtp
                              ? CircularProgressIndicator()
                              : Text(_showEnterOtp && _secondsRemaining > 0 ? '${Statics.getLabel('ReSendOtp')} $_secondsRemaining' : Statics.getLabel('SendOtp')),
                        ),
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
                      if (!showPasswordFields && _showEnterOtp)
                        ElevatedButton(
                          onPressed: _isVerifyingOtp ? null : _verifyOtp,
                          child: _isVerifyingOtp ? CircularProgressIndicator() : Text(Statics.getLabel('VerifyOTP')),
                        ),
                      // if (showEnterOtp)
                      //   Column(
                      //     children: [
                      //       SizedBox(height: 10),
                      //       PinInputTextField(
                      //         controller: _otpController,
                      //         decoration: UnderlineDecoration(
                      //           colorBuilder: PinListenColorBuilder(Colors.black, Colors.blue),
                      //           textStyle: TextStyle(color: Colors.black),
                      //         ),
                      //         autoFocus: true,
                      //         pinLength: 4, // Set your desired length
                      //         keyboardType: TextInputType.number,
                      //         onChanged: (pin) {
                      //           // Handle pin changes
                      //         },
                      //         onSubmit: (pin) {
                      //           // Handle pin submission
                      //         },
                      //       ),
                      //       SizedBox(height: 10),
                      //       ValueListenableBuilder<bool>(
                      //         valueListenable: isLoadingNotifier,
                      //         builder: (context, isLoading, child) {
                      //           return isLoading
                      //               ? CircularProgressIndicator()
                      //               : ElevatedButton(
                      //                   onPressed: () async {
                      //                     isLoadingNotifier.value = true;
                      //                     await AuthService.loginWithOTP(
                      //                       context,
                      //                       _formKey,
                      //                       verificationId,
                      //                       _otpController,
                      //                       isLoadingNotifier,
                      //                       logInMap,
                      //                       () => switchScreens2(context),
                      //                     );
                      //                   },
                      //                   child: Text(Statics.getLabel('VerifyOTP'),),
                      //                 );
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: widget.switchCard,
                        child: Text(
                          Statics.getLabel('logInBtnOTP'),
                          style: TextStyle(fontSize: 15, color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void switchScreens2(BuildContext ctx) async {
    print("Switching EditSwayamsevakScreen()");
    // Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EditSwayamsevakScreen()));
    // Navigator.of(ctx).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => EditSwayamsevakScreen(
    //       arguments: ScreenArgumentsNew(0, "", name: "", email: "", mobile: ""),
    //     ),
    //   ),
    // );
    Navigator.of(ctx).pushReplacementNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(int.parse(Statics.userDetails['userID']), Statics.getLabel('EditMenu')));
  }
}

class LogInCard extends StatefulWidget {
  final VoidCallback switchCard;

  LogInCard(this.switchCard);

  @override
  _LogInCardState createState() => _LogInCardState();
}

class _LogInCardState extends State<LogInCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  Map<String, String> _logInMap = {'mobileNumber': '', 'password': '', 'otplogin': '0'};
  var _isAgreed = false;
  bool hardLoader = false;

  AbhiyanSwayamsevakdata? initialData;

  @override
  Widget build(BuildContext context) {
    final deviceSize = Statics.getDeviceSize(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: deviceSize.height * 0.75,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 0, right: 16.0),
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextFormField(
                  autofillHints: [AutofillHints.username],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: Statics.getLabel('mobileNumberLabel')),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) return Statics.getLabel('mobileNumberValidationMessage');
                    return null;
                  },
                  onSaved: (value) {
                    _logInMap['mobileNumber'] = value!;
                  },
                ),
                TextFormField(
                  autofillHints: [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(labelText: Statics.getLabel('passwordLabel')),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) return Statics.getLabel('passwordValidationMessage');
                    return null;
                  },
                  onSaved: (value) {
                    _logInMap['password'] = value!;
                  },
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(ForgotPassword.routeName);
                    },
                    child: Text(
                      Statics.getLabel('ForgotPassword'),
                      style: TextStyle(fontSize: 14, color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: Statics.getDeviceSize(context).width * 0.9,
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    controlAffinity: ListTileControlAffinity.leading,
                    visualDensity: VisualDensity.compact,
                    title: Wrap(
                      children: [
                        if (Statics.getLabel("IAgreeToBefore") != '') Text(Statics.getLabel("IAgreeToBefore"), style: TextStyle(fontSize: 13)),
                        InkWell(
                          child: Text(Statics.getLabel("TermsofUse"), style: TextStyle(fontSize: 13, color: Colors.blue, decoration: TextDecoration.underline)),
                          onTap: () => launch(Statics.baseUrl + '/TermsOfUse.aspx'),
                        ),
                        Text(Statics.getLabel("And"), style: TextStyle(fontSize: 13)),
                        InkWell(
                          child: Text(Statics.getLabel("PrivacyPolicy"), style: TextStyle(fontSize: 13, color: Colors.blue, decoration: TextDecoration.underline)),
                          onTap: () => launch(Statics.baseUrl + '/PrivacyPolicy.aspx'),
                        ),
                        if (Statics.getLabel("IAgreeToAfter") != '') Text(Statics.getLabel("IAgreeToAfter"), style: TextStyle(fontSize: 13)),
                      ],
                    ),
                    checkColor: Colors.white,
                    activeColor: Colors.purple,
                    value: _isAgreed,
                    onChanged: (value) {
                      setState(() {
                        _isAgreed = value!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                ValueListenableBuilder<bool>(
                  valueListenable: isLoadingNotifier,
                  builder: (context, isLoading, child) {
                    return isLoading
                        ? CircularProgressIndicator()
                        : AbsorbPointer(
                            absorbing: !_isAgreed,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              color: _isAgreed ? Theme.of(context).primaryColor : Colors.grey,
                              textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                              onPressed: () => _login(context),
                              child: Text(Statics.getLabel('logInButton')),
                            ),
                          );
                  },
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: widget.switchCard,
                  child: Text(
                    Statics.getLabel('logInBtnOTP'),
                    style: TextStyle(fontSize: 15, color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
                // SizedBox(height: 1),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //      children: [
                //        Icon(Icons.help,size: 20,color: Colors.grey),
                //        InkWell(
                //          child:
                //        Text(Statics.getLabel('helpScreenTitle'),
                //         style: TextStyle(fontSize: 15,color: Colors.grey),),
                //           onTap: () {
                //             Navigator.of(context).pushReplacementNamed(HelpScreen.routeName);
                //           },
                //         ),
                //      ],
                //    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _login(BuildContext context) async {
  //   if (!_formKey.currentState!.validate()) {
  //     // Invalid form
  //     return;
  //   }
  //   _formKey.currentState!.save();
  //   isLoadingNotifier.value = true;
  //
  //   try {
  //     await AuthService.loginWithPassword(
  //       context,
  //       _formKey,
  //       _logInMap,
  //       isLoadingNotifier,
  //       () => switchScreens(context),
  //     );
  //   } catch (error) {
  //     // Handle error
  //   } finally {
  //     isLoadingNotifier.value = false;
  //   }
  // }

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      // Invalid form
      return;
    }
    LoaderUtils.toggleLoader(context, true);
    _formKey.currentState!.save();
    isLoadingNotifier.value = true;
    try {
      await AuthService.loginWithPassword(
        context,
        _formKey,
        _logInMap,
        isLoadingNotifier,
        () => switchScreens(context),
      );
    } catch (error) {
      // Handle error
    } finally {
      LoaderUtils.toggleLoader(context, false);
      isLoadingNotifier.value = false;
    }
  }

  void switchScreens(ctx) async {
    var landingPage;
    print("switchScreens 1");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var data = pref.getString("AbhiyanSwayamsevakData");
    var otpUser = pref.getString("otpuser") ?? '';
    if (data != null) {
      print("switchScreens 2");
      initialData = AbhiyanSwayamsevakdata.fromJson(jsonDecode(data));
    }
    if (Statics.userDetails['isUpdatedVersion'] == false) {
      print("switchScreens 3");
      landingPage = UpdateVersion();
    } else {
      print("switchScreens 4");
      if (Statics.userDetails['isAuthorized']) {
        print("switchScreens 5");
        await Statics.populateUserDetailsMap();
        if (Statics.userDetails['isFirstLogin']) {
          print("switchScreens 6");
          landingPage = ChangePassword();
        } else if ((Statics.userDetails['userID'].toString().isEmpty || Statics.userDetails['userID'].toString() == "0") && initialData != null) {
          print("switchScreens 7");
          print("1234:- ${Statics.userDetails['userID'].toString()}");
          Database db = await DatabaseHelper.database;
          await db.execute('UPDATE UserDataMaster SET PreferredLanguageID=6;');
          await db.execute('UPDATE UserDataMaster SET PreferredLanguageCode=\'Marathi\';');
          Statics.userDetails['languagePreference'] = 'Marathi';
          landingPage = AbhiyanScreen();
        } else {
          print("switchScreens 8");
          landingPage = HomeScreen();
        }
        print("switchScreens 9");
      } else {
        print("switchScreens 10");
        landingPage = LogInScreen();
      }
      print("switchScreens 11");
    }
    print("switchScreens 13");
    Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => landingPage));
  }
}
