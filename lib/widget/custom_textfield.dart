import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/size_config.dart';
import 'my_colors.dart';


// Custom input formatter to restrict emojis
class EmojiInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Define a regex pattern to match emojis
    final regex = RegExp(
        r'[^\u0000-\u007F\u0080-\u00FF\u0100-\u017F\u0180-\u024F\u1E00-\u1EFF]');

    // Remove any matching characters
    String filtered = newValue.text.replaceAll(regex, '');
    return TextEditingValue(
      text: filtered,
      selection: newValue.selection.copyWith(
        baseOffset: filtered.length,
        extentOffset: filtered.length,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final bool skipValidation;
  final double? height;
  final double? width;
  final double? roundCorner;
  final Color? bordercolor;
  final Color? background;
  final String? labelText;
  final String text;
  final double verticalPadding;
  final TextInputType keyboardType;
  final dynamic inputFormatters; // Preserved as dynamic
  final bool readonly;
  final bool autoFocus;
  final Widget? icon;
  final Widget? suffixIcon;
  final InputBorder? border;
  final String? errorText;
  final FocusNode? focusNode;
  final String? suffixtext;
  final Color? hintColor;
  final Color? textColor;
  final Color? cursorColor;
  final TextAlign? textAlign;
  final int? maxlines;
  final int? length; // Renamed from maxLength
  final Color? color;
  final bool? obscureText; // Renamed from isObscure
  final double? fontSize;
  final FontWeight? fontWeight;
  final AutovalidateMode? autovalidateMode;
  final bool isOptional;
  final Function(String)? onFieldSubmitted;
  final List<BoxShadow>? boxShadow;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  CustomTextField({
    Key? key,
    this.skipValidation = false,
    this.height,
    this.width,
    this.roundCorner,
    this.suffixIcon,
    this.bordercolor,
    this.background,
    this.controller,
    this.border,
    this.maxlines,
    this.length, // Preserved length
    this.labelText,
    required this.text,
    this.validator,
    this.onChanged,
    this.errorText,
    this.readonly = false,
    this.autoFocus = false,
    this.focusNode,
    this.hintColor,
    this.icon,
    this.color,
    this.suffixtext,
    required this.keyboardType,
    this.inputFormatters,
    this.obscureText, // Preserved obscureText
    this.textColor,
    this.cursorColor,
    this.onFieldSubmitted,
    this.verticalPadding = 0.0,
    this.boxShadow = const [],
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.autovalidateMode,
    this.isOptional = false, // Define if the field is optional
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  String? errorText; // To hold validation error text

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        // Validate when focus changes
        if (!_focusNode.hasFocus) {
          validateField(widget.controller?.text);
        }
      });
    });
  }

  void validateField(String? value) {
    // Use custom validator if provided
    if (widget.validator != null) {
      final result = widget.validator!(value);
      setState(() {
        errorText = result;
      });
      return;
    }

    if (widget.skipValidation) {
      setState(() {
        errorText = null; // Skip validation
      });
      return;
    }

    // Validate only if the field is not optional
    if (!widget.isOptional) {
      if (value == null || value.isEmpty) {
        setState(() {
          errorText = 'This field is required';
        });
        return;
      }

      if (widget.keyboardType == TextInputType.emailAddress &&
          !isValidEmail(value)) {
        setState(() {
          errorText = 'Invalid email address';
        });
        return;
      }

      if (widget.keyboardType == TextInputType.phone &&
          !isValidPhone(value)) {
        setState(() {
          errorText = 'Invalid phone number';
        });
        return;
      }
    } else {
      // Reset error if the field is optional
      setState(() {
        errorText = null;
      });
      return;
    }

    // If all validations pass or field is optional
    setState(() {
      errorText = null;
    });
  }

  bool isValidEmail(String value) {
    // Basic email validation regex
    RegExp emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegExp.hasMatch(value);
  }

  bool isValidPhone(String value) {
    // Basic phone validation regex (supports + and numbers)
    RegExp phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegExp.hasMatch(value);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height ?? getHeight(60),
          width: widget.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null
                  ? Colors.red // Show red border if there's an error
                  : (_focusNode.hasFocus
                  ? Colors.green // Change border color when focused
                  : (widget.bordercolor ?? Colors.black.withOpacity(.1))),
              width: 1.5,
            ),
            borderRadius:
            BorderRadius.circular(widget.roundCorner ?? 8), // Preserve roundCorner
            boxShadow: widget.boxShadow,
            color: widget.background ?? Colors.white,
          ),
          child: TextFormField(
            focusNode: _focusNode,
            maxLength: widget.length, // Renamed from maxLength to length
            maxLines: widget.maxlines ?? 1,
            autofocus: widget.autoFocus,
            style: textTheme.titleMedium!.copyWith(
              fontSize: widget.fontSize ?? getFont(16),
              height: 1,
              color: widget.textColor ?? MyColors.textColor,
              fontWeight: widget.fontWeight ?? FontWeight.w500,
            ),
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            textAlign: widget.textAlign ?? TextAlign.start,
            onChanged: (value) {
              widget.onChanged?.call(value);
              validateField(value); // Validate on text change
            },
            cursorColor: widget.cursorColor ?? Colors.black,
            inputFormatters: [
              if (widget.inputFormatters is List<TextInputFormatter>)
                ...widget.inputFormatters
              else if (widget.inputFormatters != null)
                widget.inputFormatters,
              EmojiInputFormatter(), // Add the custom formatter here
            ],
            readOnly: widget.readonly,
            obscureText: widget.obscureText ?? false, // Renamed from isObscure to obscureText
            onFieldSubmitted: widget.onFieldSubmitted,
            decoration: InputDecoration(

              contentPadding: EdgeInsets.symmetric(
                  horizontal: getWidth(10), vertical: getHeight(12)),
              border: widget.border ?? InputBorder.none,
              hintText: widget.text,
              labelText: widget.labelText,

              labelStyle: TextStyle(

                fontSize: getFont(16),
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(.4),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: widget.suffixIcon,
              hintStyle: TextStyle(
                color: widget.hintColor ?? MyColors.hintText,
                fontWeight: FontWeight.w500,
                fontSize: widget.fontSize ?? getFont(16),
              ),
              prefixIcon: widget.icon != null
                  ? Padding(
                padding: EdgeInsets.all(12),
                child: widget.icon,
              )
                  : null,
              counterText: '', // Removed the counter text
              errorText: null, // Remove errorText from InputDecoration
            ),
            autovalidateMode: widget.autovalidateMode,
          ),
        ),
        SizedBox(
          height: getHeight(14), // Reserve space for errorText to prevent shifting
          child: errorText != null
              ? Text(
            errorText!,
            style: TextStyle(color: Colors.red, fontSize: getFont(12)),
          )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
