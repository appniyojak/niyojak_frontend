import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niyojak_prod/models/response_model/VisheshVyaktiListResponse.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/bals.dart';
import '../providers/swayamsevak_provider.dart';
import 'VisheshVyaktShodhScreen.dart';

class EditVisheshVyaktiScreen extends StatefulWidget {
  static const routeName = '/edit-vishesh-vyakti';

  @override
  State<EditVisheshVyaktiScreen> createState() =>
      _EditVisheshVyaktiScreenState();
}

class _EditVisheshVyaktiScreenState extends State<EditVisheshVyaktiScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController anyaSansthaController = TextEditingController();
  TextEditingController sansthaNameController = TextEditingController();
  TextEditingController sansthaPadhController = TextEditingController();
  TextEditingController anyaMahitiController = TextEditingController();

  String selectedSansthaValue = "";
  String selectedVisheshValue = "";
  GruhasamparkVisheshVyaktiData? argsData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments
          as GruhasamparkVisheshVyaktiData;
      if (args != null) {
        setState(() {
          argsData = args;
          _populateFields();
        });
      }
    });
  }

  void _populateFields() {
    if (argsData != null) {
      print("argsDataargsDataargsData ==:--- ${argsData!.toJson()}");
      nameController.text = argsData!.visheshVyaktiName ?? '';
      addressController.text = argsData!.address ?? '';
      mobileController.text = argsData!.mobileNumber ?? '';
      if (argsData!.sansthaType != "धार्मिक" &&
          argsData!.sansthaType != "सामाजिक" &&
          argsData!.sansthaType != "शैक्षणिक" &&
          argsData!.sansthaType != "सेवा" &&
          argsData!.sansthaType != "सांस्कृतिक") {
        selectedSansthaValue = "अन्य";
        anyaSansthaController.text = argsData!.sansthaType ?? '';
      } else {
        selectedSansthaValue = argsData!.sansthaType ?? '';
      }
      sansthaNameController.text = argsData!.sansthaName ?? '';
      selectedVisheshValue = argsData!.visheshNote ?? '';
      anyaMahitiController.text = argsData!.anyaVishesh ?? '';
      sansthaPadhController.text = argsData!.sansthaPadh ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "विशिष्ट व्यक्ती",
              style: TextStyle(fontSize: 20),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  buildTextField(
                      "पूर्ण नाव", nameController, TextInputType.text),
                  SizedBox(height: 20),
                  buildTextField(Statics.getLabel('Address'), addressController,
                      TextInputType.text),
                  SizedBox(height: 20),
                  buildTextField("${Statics.getLabel('doorBhash')}",
                      mobileController, TextInputType.number, inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly
                  ]),
                  SizedBox(height: 20),
                  buildDropdownSection(),
                  SizedBox(height: 20),
                  buildTextField("संस्थेचे नाव", sansthaNameController,
                      TextInputType.text),
                  SizedBox(height: 20),
                  buildTextField("संस्थेत कुठल्या पदावर", sansthaPadhController,
                      TextInputType.text),
                  SizedBox(height: 20),
                  buildSpecialDropdownSection(),
                  SizedBox(height: 20),
                  buildMultiLineTextField(
                      "अन्य विशेष माहिती", anyaMahitiController),
                  SizedBox(height: 30),
                  buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, TextInputType inputType,
      {List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 16),
      autofocus: false,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        contentPadding:
            EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget buildDropdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${Statics.getLabel('saamaajikSanstha')}  :",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black38),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  iconSize: 30,
                  underline: SizedBox(),
                  value: selectedSansthaValue.isEmpty
                      ? null
                      : selectedSansthaValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSansthaValue = newValue!;
                      print("  ========================   $newValue");
                    });
                  },
                  items: [
                    "धार्मिक",
                    "सामाजिक",
                    "शैक्षणिक",
                    "सेवा",
                    "सांस्कृतिक",
                    "अन्य"
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(value)),
                    );
                  }).toList(),
                ),
              ),
              if (selectedSansthaValue == "अन्य")
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    controller: anyaSansthaController,
                    decoration: InputDecoration(
                        hintText: "संस्था कुठल्या विषयात काम करते"),
                    keyboardType: TextInputType.text,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSpecialDropdownSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${Statics.getLabel('special')}  :",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black38),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: DropdownButton<String>(
              isExpanded: true,
              isDense: true,
              iconSize: 30,
              underline: SizedBox(),
              value: selectedVisheshValue.isEmpty ? null : selectedVisheshValue,
              onChanged: (String? newValue) {
                setState(() {
                  selectedVisheshValue = newValue!;
                });
              },
              items: [
                "अनुकूल",
                "प्रतिकूल",
                "तटस्थ",
                "संघाशी जुडू इच्छितात",
                "जुने स्वयंसेवक",
                "अन्य"
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(value)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMultiLineTextField(
      String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 16),
      autofocus: false,
      maxLines: 4,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding:
            EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (nameController.text.isEmpty) {
          showSnackbar("कृपया नाव लिहा");
        }
        // else if (addressController.text.isEmpty) {
        //   showSnackbar("कृपया पत्ता लिहा");
        // }
        else if (mobileController.text.isEmpty) {
          showSnackbar("कृपया मोबाईल नंबर लिहा");
        } else if (mobileController.text.length != 10) {
          showSnackbar("कृपया १० अंकी मोबाईल नंबर लिहा");
        } else if (selectedSansthaValue.isEmpty) {
          showSnackbar("कृपया संस्थेचा प्रकार निवडा");
        } else if (selectedSansthaValue == "अन्य" &&
            anyaSansthaController.text.isEmpty) {
          showSnackbar("कृपया संस्थेचा प्रकार लिहा");
        } else if (sansthaNameController.text.isEmpty) {
          showSnackbar("कृपया संस्थेचे नाव लिहा");
        } else if (sansthaPadhController.text.isEmpty) {
          showSnackbar("कृपया संस्थेत पद लिहा");
        } else if (selectedVisheshValue.isEmpty) {
          showSnackbar("कृपया विशेष माहिती निवडा");
        } else {
          editVisheshVyakti();
          // Navigator.of(context).pop(true);
          Navigator.of(context).pop();
        }
      },
      child: Text("जतन करा"),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> editVisheshVyakti() async {
    // try {
    List<UserDataBAL> user = await Statics.getUserDataLDB();
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      var data = {
        "AnyaVishesh": anyaMahitiController.text,
        "Email": addressController.text,
        "GruhasamparkID": argsData!.gruhasamparkID,
        "GruhasamparkVisheshID": argsData!.gruhasamparkVisheshID,
        "MobileNumber": mobileController.text,
        "SansthaName": sansthaNameController.text,
        "SansthaPadh": sansthaPadhController.text,
        "SansthaType": selectedSansthaValue == "अन्य"
            ? anyaSansthaController.text
            : selectedSansthaValue,
        "VisheshNote": selectedVisheshValue,
        "VisheshVyaktiName": nameController.text
      };
      print(jsonEncode(data));
      var result = await SwayamsevakProvider()
          .updateAbhiyanGruhaSampark(jsonEncode(data));
      Statics.showToast(result['Message']);
      if (result['Status'] == "200") {
        print("succeed");
        Statics.showToast(result['Message']);
        setState(() {});
        Navigator.of(context).pop();
        Navigator.of(context)
            .pushReplacementNamed(VisheshVyaktiShodhScreen.routeName);
      } else {
        Statics.showToast(result['Message']);
      }
    }
    // } catch (e) {
    //   print(e);
    //   Statics.showToast(Statics.getLabel('unableToSaveData'));
    // }
  }
}
