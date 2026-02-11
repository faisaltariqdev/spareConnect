
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';


import '../utils/constants.dart';
import '../utils/singletone.dart';
import '../utils/size_config.dart';
import 'dimens.dart';
import 'my_colors.dart';

class PhonePicker extends StatefulWidget {
  final String countryCode;
  final Function()? onTap;
  final TextEditingController? controller;
  final AutovalidateMode? autovalidateMode;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final bool isOptional;
  final bool autoFocus;
  final FocusNode? focusNode;
  final int? maxLength;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? cursorColor;
  final TextAlign? textAlign;
  final List<BoxShadow>? boxShadow;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  PhonePicker({
    Key? key,
    required this.countryCode,
    this.readOnly = false,
    this.onTap,
    this.controller,
    this.onChanged,
    this.validator,
    this.autovalidateMode,
    this.isOptional = false,
    this.autoFocus = false,
    this.focusNode,
    this.maxLength,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.cursorColor,
    this.textAlign,
    this.boxShadow,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
  }) : super(key: key);

  @override
  _PhonePickerState createState() => _PhonePickerState();
}

class _PhonePickerState extends State<PhonePicker> {
  late FocusNode _focusNode;
  String? errorText;
  late String _countryCode;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _countryCode = widget.countryCode;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        if (!_focusNode.hasFocus) {
          validateField(_controller?.text);
        }
      });
    });
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller?.dispose();
    }
    super.dispose();
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

    if (!widget.isOptional) {
      if (value == null || value.isEmpty) {
        setState(() {
          errorText = 'This field is required';
        });
        return;
      } else if (!isValidPhone(value)) {
        setState(() {
          errorText = 'Invalid phone number';
        });
        return;
      }
    }

    // If all validations pass or field is optional
    setState(() {
      errorText = null;
    });
  }

  bool isValidPhone(String value) {
    // Basic phone validation regex (supports numbers, spaces, and dashes)
    RegExp phoneRegExp = RegExp(r'^\d{10,15}$');
    return phoneRegExp.hasMatch(value.replaceAll(RegExp(r'[\s\-]'), ''));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height ?? getHeight(60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
            border: Border.all(
              color: errorText != null
                  ? Colors.red
                  : (_focusNode.hasFocus
                  ? Colors.green
                  : (widget.borderColor ?? MyColors.greyFont.withOpacity(0.3))),
              width: 1.5,
            ),
            color: widget.backgroundColor ?? Colors.white,
            boxShadow: widget.boxShadow ?? [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: getWidth(Dimens.size120),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(widget.borderRadius ?? 5),
                    topLeft: Radius.circular(widget.borderRadius ?? 5),
                  ),
                ),
                child: CountryCodePicker(
                  padding: EdgeInsets.zero,
                  showFlag: true,
                  flagWidth: 25,
                  onChanged: (code) {
                    setState(() {
                      _countryCode = code.dialCode!;
                      SingleToneValue.instance.code = _countryCode;
                    });
                  },
                  showDropDownButton: true,
                  textStyle: TextStyle(
                    fontSize: getFont(16),
                    color: MyColors.black.withOpacity(0.5),
                  ),
                  favorite: [Constants.country, Constants.countryCode],
                  initialSelection: Constants.countryCode,
                ),
              ),
              Expanded(
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: _controller,
                  readOnly: widget.readOnly,
                  autofocus: widget.autoFocus,
                  maxLength: widget.maxLength,
                  keyboardType: TextInputType.number,
                  style: textTheme.titleMedium!.copyWith(
                    fontSize: widget.fontSize ?? getFont(16),
                    fontWeight: widget.fontWeight ?? FontWeight.w500,
                    color: widget.textColor ?? MyColors.textColor,
                  ),
                  cursorColor: widget.cursorColor ?? Colors.black,
                  textAlign: widget.textAlign ?? TextAlign.start,
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    validateField(value);
                  },
                  onTap: widget.onTap,
                  decoration: InputDecoration(
                    filled: false,
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.only(top: 1, bottom: 0, left: 10),
                    counterText: "",
                    labelText: "Phone",
                    labelStyle: TextStyle(
                      fontSize: getFont(16),
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(.4),
                    ),
                    //hintText: "Phone",
                    hintStyle: TextStyle(
                      fontSize: getFont(16),
                      color: Colors.black.withOpacity(0.4),
                      fontWeight: FontWeight.w400,
                    ),
                    errorText: null, // We handle error text manually
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: getHeight(22),
          child: errorText != null
              ? Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: getFont(12),
              ),
            ),
          )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}




