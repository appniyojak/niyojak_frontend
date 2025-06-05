import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:niyojak_prod/helpers/static_data.dart';
import 'package:niyojak_prod/models/response_model/VishishtaVyaktiModel.dart';
import '../helpers/static_data.dart' as Statics;

class AddEditVisheshVyaktiScreen extends StatefulWidget {
  static const routeName = '/add-edit-vishesh-vyakti';
  @override
  State<AddEditVisheshVyaktiScreen> createState() => _AddEditVisheshVyaktiScreenState();
}

class _AddEditVisheshVyaktiScreenState extends State<AddEditVisheshVyaktiScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController anyaSansthaController = TextEditingController();
  TextEditingController sansthaNameController = TextEditingController();
  TextEditingController sansthaPadhController = TextEditingController();
  TextEditingController anyaMahitiController = TextEditingController();

  String selectedSansthaValue = "";
  String selectedVisheshValue = "";
  VishishtaVyaktiModel? argsData;
  bool dataSet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(ModalRoute.of(context)!.settings.arguments != null){
    argsData = ModalRoute.of(context)!.settings.arguments as VishishtaVyaktiModel;
    if (argsData != null) {
      nameController.text = argsData!.name!;
      addressController.text = argsData!.address!;
      mobileController.text = argsData!.mobile!;
      if (argsData!.sanstha != "धार्मिक" && argsData!.sanstha != "सामाजिक" && argsData!.sanstha != "शैक्षणिक" &&
          argsData!.sanstha != "सेवा" && argsData!.sanstha != "सांस्कृतिक") {
        selectedSansthaValue = "अन्य";
        anyaSansthaController.text = argsData!.sanstha!;
      } else {
        selectedSansthaValue = argsData!.sanstha!;
      }
      sansthaNameController.text = argsData!.sanshthaName!;
      sansthaPadhController.text = argsData!.sanshthaPadh!;
      selectedVisheshValue = argsData!.vishesh!;
      anyaMahitiController.text = argsData!.anyaMahiti!;
      dataSet = true;
      }
    }

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
              child: Form(
              key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: nameController,
                        style: TextStyle(fontSize: 16,),
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            isDense: true,
                            labelText: "पूर्ण नाव",
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5),)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Statics.getLabel('mandatoryInformation');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: addressController,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            isDense: true,
                            labelText: Statics.getLabel('Address'),
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Statics.getLabel('mandatoryInformation');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: mobileController,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            isDense: true,
                            labelText: "दूरभाष",
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return Statics.getLabel('mandatoryInformation');
                          } else if (value.length != 10) {
                            return 'कृपया 10 अंकों का मोबाइल नंबर दर्ज करें';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 9.0),
                          child: Text(
                            "${Statics.getLabel('shreni')}  :",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.86,
                          // margin: EdgeInsets.only(right: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  isDense: true,
                                  iconSize: 30,
                                  underline: SizedBox(),
                                  value: selectedSansthaValue == "" ? null : selectedSansthaValue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSansthaValue = newValue!;
                                    });
                                  },
                                  items: <String>["धार्मिक", "सामाजिक", "शैक्षणिक", "सेवा", "सांस्कृतिक", "अन्य"]
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 3.0),
                                        child: Text(value),
                                      ),
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
                                      hintText: "संस्था कुठल्या विषयात काम करते",
                                    ),
                                    keyboardType: TextInputType.text,
                                    onSaved: (value) {
                                      // swDetails.fullName = value.trim();
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Statics.getLabel('mandatoryInformation');
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: sansthaNameController,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            isDense: true,
                            labelText: "संस्थेचे नाव",
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Statics.getLabel('mandatoryInformation');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: sansthaPadhController,
                      decoration: InputDecoration(
                        labelText: "संस्थेत कुठल्या पदावर",
                        isDense: true,
                        border:
                            OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey.shade700), borderRadius: BorderRadius.circular(5)),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        // swDetails.fullName = value.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Statics.getLabel('mandatoryInformation');
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 9.0),
                          child: Text(
                            "${Statics.getLabel('special')}                       :",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.52,
                          // margin: EdgeInsets.only(right: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black38)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 0, top: 5, bottom: 5),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              isDense: true,
                              iconSize: 30,
                              underline: SizedBox(),
                              value: selectedVisheshValue == "" ? null : selectedVisheshValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedVisheshValue = newValue!;
                                });
                              },
                              items: <String>["अनुकूल", "प्रतिकूल", "तटस्थ", "संघाशी जुडू इच्छितात", "जुने स्वयंसेवक","अन्य"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Text(value),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: anyaMahitiController,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        autofocus: false,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: "अन्य विशेष माहिती",
                            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Statics.getLabel('mandatoryInformation');
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        print("selectedVisheshValue==> $selectedVisheshValue");

                        if (nameController.text.isEmpty) {
                          print("पूर्ण नाव प्रविष्ट करा");
                          Statics.showToast("पूर्ण नाव प्रविष्ट करा");
                          return null;
                        } else if (mobileController.text.isEmpty) {
                          print("मोबाइल क्रमांक प्रविष्ट करा");
                          Statics.showToast("मोबाइल क्रमांक प्रविष्ट करा");
                          return null;
                        } else if (selectedSansthaValue == "" || selectedSansthaValue == "अन्य" && anyaSansthaController == "") {
                          print(" संस्था प्रविष्ट करा");
                          Statics.showToast(" संस्था प्रविष्ट करा");
                          return null;
                        } else if (selectedSansthaValue.isNotEmpty && selectedSansthaValue != "" && sansthaNameController.text.isEmpty) {
                          print("संस्थेचे नाव प्रविष्ट करा");
                          Statics.showToast("संस्थेचे नाव प्रविष्ट करा");
                          return null;
                        } else if (selectedSansthaValue.isNotEmpty && selectedSansthaValue != "" && sansthaPadhController.text.isEmpty) {
                          print("संस्थेमध्ये पद प्रविष्ट करा");
                          Statics.showToast("संस्थेमध्ये पद प्रविष्ट करा");
                          return null;
                        }  else if ( selectedVisheshValue == "" ) {
                          print("विशेष प्रविष्ट करा");
                          Statics.showToast("विशेष प्रविष्ट करा");
                          return null;
                        } else {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          VishishtaVyaktiModel modelData = VishishtaVyaktiModel(
                              name: nameController.text,
                              address: addressController.text,
                              mobile: mobileController.text,
                              sanstha: selectedSansthaValue == "अन्य" ? anyaSansthaController.text : selectedSansthaValue,
                              sanshthaName: sansthaNameController.text,
                              sanshthaPadh: sansthaPadhController.text,
                              vishesh: selectedVisheshValue,
                              anyaMahiti: anyaMahitiController.text);
                          print(modelData.toJson());
                          Navigator.of(context).pop(modelData);
                        }
                      },
                      child: Text(
                        Statics.getLabel('Submit'),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
