
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionOfPhotos {
  Future<bool> getFromGallery(BuildContext context) async {
    var platform = Platform.isIOS ? Permission.photos : Permission.storage;
    if(Platform.isIOS)
    {
      platform = Permission.photos;
    }
    if(Platform.isAndroid)
    {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        platform = Permission.storage;
      } else {
        platform = Permission.photos;
      }
    }

    var stauts = await platform.status;
    await platform.request();
    Get.log("status  $stauts ");
    if (await platform.status.isDenied) {
      if (Platform.isIOS) {
        await platform.request();
      } else {
        showDeleteDialog(context);
      }

      return false;
    } else if (await platform.status.isPermanentlyDenied) {
      if (Platform.isIOS) {
        showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("Settings".tr),
              content: Text(
                  "This lets you to share from your camera roll and enables other features for photos and videos. Go to your settings and tap \"Photos\""),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Not now".tr),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  onPressed: () => openAppSettings(),
                  child: Text("iOS Settings".tr),
                )
              ],
            ));
      } else {
        showDeleteDialog(context);
      }
      return false;
    } else if (await platform.isGranted) {
      return true;
    } else if (await platform.isLimited) {
      return true;
    }

    return false;
  }

  Future<bool> getFromCamera(BuildContext context) async {
    //var status = await Permission.camera.status;
    var status = await Permission.camera.status; //
    await Permission.camera.request();
    if (await Permission.camera.status.isDenied) {
      if (Platform.isIOS) {
        await Permission.camera.request();
      } else {
        showDeleteDialog(context);

        return false;
      }
    }
    if (await Permission.camera.status.isPermanentlyDenied) {
      if (Platform.isIOS) {
        showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("Settings".tr),
              content: Text(
                  "In iPhone settings, tap Lesbons Contacts and turn on Camera"
                      .tr),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Not now".tr),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: Text("iOS Settings".tr),
                  onPressed: openAppSettings,
                )
              ],
            ));
      } else {
        showDeleteDialog(context);
      }

      return false;
    } else if (await Permission.camera.isGranted ||
        await Permission.camera.isLimited) {
      return true;
    }
    return false;
  }
}

showDeleteDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Text(
      "Not now".tr,
      style: TextStyle(fontSize: 12),
    ),
  );
  Widget continueButton = GestureDetector(
    onTap: () async {
      openAppSettings();
    },
    child: Text("Open settings".tr,
        style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12)),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    actionsPadding: EdgeInsets.only(right: 15, bottom: 15),
    // shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(Radius.circular(36.0))),
    title: Text(
      "Settings".tr,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    ),
    content: Text(
      "Open app settings, give access to your camera and storage".tr,
      style: TextStyle(fontWeight: FontWeight.w400),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
