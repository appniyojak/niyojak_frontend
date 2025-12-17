import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/static_data.dart' as Statics;
import '../providers/login.dart';

downloadVersion() async {
  await LogIn().logOut();
  BackgroundFetch.stop().then((int status) {
    print('[BackgroundFetch] stop success: $status');
  });

  await launch(Platform.isIOS ? Statics.urlIOSUpdatedVersion : Statics.urlUpdatedVersion);
}

class UpdateVersion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Version",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 60, 20, 50),
        child: Center(
          child: Column(
            children: [
              Text(
                Statics.getLabel('upgradeVersion'),
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 27, color: Colors.deepOrange),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 60,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                onPressed: downloadVersion,
                child: Text(
                  Statics.getLabel('upgradeButton'),
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
