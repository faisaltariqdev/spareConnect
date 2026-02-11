import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/size_config.dart';


class CustomButton extends StatelessWidget {
  final double height;
  final double? width;
  final double? roundCorner;
  final String text;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final String? fontFamily;
  final FontWeight? fontWeight;
  void Function()? onPressed;

  CustomButton({
    this.height = 60,
    this.width,
    required this.text,
    this.fontSize,
    this.borderColor,
    this.textColor,
    this.roundCorner,
    this.color,
    this.fontWeight,
    this.fontFamily,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var mediaQuery = MediaQuery.of(context).size;
    return MaterialButton(
      elevation: 0,
      color: color ?? Get.theme.colorScheme.primary,
      height: getHeight(height),
      minWidth: width ==null?mediaQuery.width: getWidth(width!),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: borderColor == null
                ? Get.theme.colorScheme.primary
                : borderColor!),
        borderRadius:
        BorderRadius.circular(roundCorner == null ? 8 : roundCorner!),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            //fontFamily: fontFamily == null ? MyFonts.TTNorm : fontFamily,
            color: textColor == null ? theme.colorScheme.onPrimary : textColor!,
            fontSize: fontSize == null ? getFont(16) : getFont(fontSize!),
            fontWeight: fontWeight == null ? FontWeight.w500 : fontWeight),
      ),
    );
  }
}
