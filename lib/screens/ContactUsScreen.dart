import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  TextEditingController messageController = TextEditingController();
  late Size size = MediaQuery.of(context).size;
  XFile? _selectedImage;

  bool _isSearching = false;

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
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // "Please Write your message here",
                "${Statics.getLabel('message')}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width * 0.04,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                clipBehavior: Clip.antiAlias,
                width: size.width,
                height: size.height * 0.1,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(3)),
                child: TextField(
                  // clipBehavior: Clip.antiAlias,
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    // hintText: 'Enter text here',
                    border: InputBorder.none, // Remove the bottom line
                  ),
                ),
              ),
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
                  onTap: () {
                    _pickImage(context);
                    // print("clicked");
                  },
                  child: _selectedImage != null
                      ? Stack(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(top: 10,bottom: 20),
                        padding: EdgeInsets.all(7),
                        width: size.width,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(3)),
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
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  shape: BoxShape.circle),
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
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3)),
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
                    if (messageController.text.isEmpty) {
                      Statics.showToast(
                        "${Statics.getLabel('PleaseEnterYourMessage')}"
                      );
                    } else {
                      hitSendMail();
                    }
                    // print("presseed");
                  },
                  elevation: 0,
                  //   color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(7)),

                  child: Text(
                    "${Statics.getLabel('Submit')}",
                    style: TextStyle(
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

  Future<void> _pickImage(BuildContext context) async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
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
        String base64Image = "";
        if (_selectedImage != null) {
          List<int> imageBytes = File(_selectedImage!.path).readAsBytesSync();
          base64Image = base64Encode(imageBytes);
        }

        var data = {
          "userid": Statics.userDetails["userID"],
          "msg": messageController.text,
          "file": base64Image,
          "ext":
          _selectedImage != null ? _selectedImage!.name.split(".").last : ""
        };

        log(data.toString());

        var result = await SwayamsevakProvider().sendMailCall(jsonEncode(data));
        if (result.status == "200") {
          print("succeed");
          Statics.showToast(result.message);
          // abhiyaanGruhaSamparkDataList = result.abhiyanGruhasamparkData;
          messageController.clear();
          _selectedImage = null;
          setState(() {
            _isSearching = false;
          });
        } else {
          setState(() {
            _isSearching = false;
          });
          Statics.showToast(
              Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
        }
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      print(e);
      Statics.showToast(
          Statics.getLabel('noDataFoundTryAnotherSearch').split(",").first);
    }
  }
}
