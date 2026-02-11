import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'my_colors.dart';

class CustomToast {
  static failToast(String s,
      {Color? bgcolor, Color? textColor, String? msg, len, gravity}) {
    return Fluttertoast.showToast(
      backgroundColor: bgcolor ?? MyColors.red500,
      textColor: textColor ?? MyColors.white,
      msg: msg ?? s,  // Use `s` as a fallback if `msg` is null
      toastLength: len ?? Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM, // location// duration
    );
  }

  static successToast(String s,
      {Color? bgcolor, Color? textColor, String? msg, len, gravity}) {
    return Fluttertoast.showToast(
      backgroundColor: bgcolor ?? MyColors.green300,
      textColor: textColor ?? MyColors.white,
      msg: msg ?? s,  // Use `s` as a fallback if `msg` is null
      toastLength: len ?? Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM, // location// duration
    );
  }
}
