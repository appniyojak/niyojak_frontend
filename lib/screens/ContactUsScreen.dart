import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/swayamsevak_provider.dart';

class ContactUs extends StatefulWidget {
  static const routeName = '/contact-us';

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController attachNameController = TextEditingController();
  TextEditingController attachMobileController = TextEditingController();
  TextEditingController attachDaayitvaController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  late Size size = MediaQuery.of(context).size;
  XFile? _selectedImage;
  String? _compressedImg;

  bool _isSearching = false;
  bool _fileIsLoading = false;

  bool fromLogin = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fromLogin = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          // "Contact Us",
          "${Statics.getLabel('contactUs')}",
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.045,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isSearching,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fromLogin) ...[
                _commonTextField(Statics.getLabel("attachName"), attachNameController),
                SizedBox(height: 12),
                _commonTextField(Statics.getLabel("attachMobile"), attachMobileController, keyboardType: TextInputType.number, inputFormatters: [LengthLimitingTextInputFormatter(10)]),
                SizedBox(height: 12),
                _commonTextField(Statics.getLabel("attachDaayitva"), attachDaayitvaController),
                SizedBox(height: 12),
              ],
              _commonTextField(Statics.getLabel("message"), messageController, maxLines: 3),
              SizedBox(height: 12),
              Text(
                "${Statics.getLabel('attachment')}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.04,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: InkWell(
                  onTap: _fileIsLoading
                      ? null
                      : () {
                          _pickAndCompressImage(ImageSource.gallery);
                          // print("clicked");
                        },
                  child: _fileIsLoading
                      ? Center(child: CircularProgressIndicator())
                      : _selectedImage != null
                          ? Stack(
                              children: [
                                Container(
                                  // margin: EdgeInsets.only(top: 10,bottom: 20),
                                  padding: EdgeInsets.all(7),
                                  width: size.width,
                                  height: size.height * 0.25,
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
                                  child: Image.file(
                                    File(_selectedImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedImage = null;
                                      });
                                    },
                                    child: Container(
                                        // height: size.width*0.09,
                                        // width: size.width*0.09,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.close,
                                          size: size.width * 0.05,
                                        )),
                                  ),
                                )
                              ],
                            )
                          : Container(
                              // margin: EdgeInsets.only(top: 10,bottom: 20),
                              padding: EdgeInsets.all(7),
                              width: size.width,
                              height: size.height * 0.3,
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.photo,
                                    size: size.width * 0.15,
                                    color: Colors.black26,
                                  ),
                                  Text(
                                    "Select Image",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black26,
                                    ),
                                  )
                                ],
                              )),
                ),
              ),
              Center(
                child: MaterialButton(
                  color: Colors.purple,
                  onPressed: () {
                    // send();
                    if (fromLogin) {
                      final isInvalid = attachNameController.text.isEmpty || attachMobileController.text.isEmpty || attachDaayitvaController.text.isEmpty || messageController.text.isEmpty;

                      if (isInvalid) {
                        Statics.showToast(Statics.getLabel('impInfoRequired'));
                        return;
                      }
                    } else {
                      if (messageController.text.isEmpty) {
                        Statics.showToast(Statics.getLabel('PleaseEnterYourMessage'));
                        return;
                      }
                    }

                    hitSendMail();
                    // print("presseed");
                  },
                  elevation: 0,
                  //   color: Colors.blue,
                  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(7)),

                  child: Text(
                    "${Statics.getLabel('Submit')}",
                    style: TextStyle(
                      fontSize: size.width * 0.042,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _commonTextField(String title, TextEditingController controller, {int? maxLines, List<TextInputFormatter>? inputFormatters, TextInputType? keyboardType}) {
    return Column(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              // "Please Write your message here",
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.038,
              ),
            ),
            Text(
              "  *",
              style: TextStyle(
                color: Colors.red,
                fontSize: size.width * 0.038,
              ),
            ),
          ],
        ),
        TextFormField(
          // clipBehavior: Clip.antiAlias,
          controller: controller,
          keyboardType: keyboardType,
          autofocus: false,
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            // hintText: 'Enter text here',
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)), // Remove the bottom line
          ),
        ),
      ],
    );
  }

  /*
  Future<void> _pickImage(BuildContext context) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = pickedImage;
        });
      }
    } catch (e) {
      print('Error picking image: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image. Please try again later.'),
        ),
      );
    }
  }
  */

  // ─── Image pick + compress helper ─────────────────────────────────────────
  Future<String?> _pickAndCompressImage(ImageSource source) async {
    setState(() {
      _fileIsLoading = true;
    });
    final result = await ImagePicker().pickImage(source: source);
    if (result == null) return null;
    try {
      setState(() {
        _selectedImage = result;
      });
      final file = File(result.path);
      img.Image? original = img.decodeImage(file.readAsBytesSync());
      if (original == null) return null;
      img.Image compressed = img.copyResize(original, width: original.width);
      while (compressed.length > 2 * 1024 * 1024) {
        compressed = img.copyResize(compressed, width: (compressed.width * 0.9).toInt());
      }
      final bytes = img.encodeJpg(compressed, quality: 85);
      setState(() {
        _compressedImg = base64Encode(bytes);
        _fileIsLoading = false;
      });
      return "data:image/jpg;base64,${base64Encode(bytes)}";
    } catch (e) {
      log("Image compress error: $e");
      setState(() {
        _fileIsLoading = false;
      });
      return null;
    }
  }

  // Future<void> send() async {
  //   final Email email = Email(
  //     body: messageController.text,
  //     subject: "Swapnil Sir Task",
  //     recipients: ["avi313671@gmail.com"],
  //     attachmentPaths: _selectedImage != null ? [_selectedImage!.path] : [],
  //     isHTML: false,
  //   );
  //
  //   try {
  //     await FlutterEmailSender.send(email);
  //   } catch (error) {
  //     print("Error sending email: $error");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error sending email. Please try again later.'),
  //       ),
  //     );
  //   }
  // }

  hitSendMail() async {
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (isConnected) {
        setState(() {
          _isSearching = true;
        });
        // String base64Image = "";
        // if (_selectedImage != null) {
        //   List<int> imageBytes = File(_selectedImage!.path).readAsBytesSync();
        //   base64Image = base64Encode(imageBytes);
        // }

        var data = {
          "userid": (Statics.userDetails["userID"] != null && Statics.userDetails["userID"]!.toString().trim().isNotEmpty) ? Statics.userDetails["userID"] : 0,
          "name": fromLogin ? attachNameController.text.trim() : Statics.userDetails["FullName"] ?? "",
          "mobile": fromLogin ? attachMobileController.text.trim() : Statics.userDetails["MobileNumber"] ?? "",
          "daayitva": fromLogin ? attachDaayitvaController.text.trim() : Statics.userDetails["DaayitvaName"] ?? "",
          "msg": messageController.text.trim(),
          "file": _compressedImg,
          "ext": _selectedImage != null ? _selectedImage!.name.split(".").last : ""
        };

        log(data.toString());

        var result = await SwayamsevakProvider().sendMailCall(jsonEncode(data));
        if (result.status == "200") {
          print("succeed");
          Statics.showToast(result.message);
          // abhiyaanGruhaSamparkDataList = result.abhiyanGruhasamparkData;
          attachNameController.clear();
          attachMobileController.clear();
          attachDaayitvaController.clear();
          messageController.clear();
          _selectedImage = null;
          setState(() {
            _isSearching = false;
          });
        } else {
          setState(() {
            _isSearching = false;
          });
          Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
        }
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      print(e);
      Statics.showToast(Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    }
  }
}
