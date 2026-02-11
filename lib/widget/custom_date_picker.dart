import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../utils/size_config.dart';
import 'my_colors.dart';



class CustomDatePickerField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final double? height;
  final double? width;
  final double? roundCorner;
  final Color? borderColor;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final Function(DateTime)? onDateChanged;

  CustomDatePickerField({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.height,
    this.width,
    this.roundCorner,
    this.borderColor,
    this.backgroundColor,
    this.controller,
    this.onDateChanged,
  }) : super(key: key);

  @override
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  TextEditingController? _controller;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height ?? 60.0,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(

            border: Border.all(
              width: 1.5,
              color: Color(0xFFE0342F) ?? MyColors.black.withOpacity(.1),
            ),
            borderRadius: BorderRadius.circular(widget.roundCorner ?? 8.0),
            color: widget.backgroundColor ?? Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              // Prevent text field interaction, only allow date picker
              child: TextFormField(
                controller: _controller,
                style: TextStyle(fontSize: getFont(16), fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  labelStyle: TextStyle(
                    fontSize: getFont(16),
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  hintStyle: TextStyle(
                    fontSize: getFont(16),
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  border: InputBorder.none,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(Icons.calendar_today_outlined, size: 24.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: getHeight(4) ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

  // Function to show date picker and update the text field
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000), // Initial date set to 2000
      firstDate: DateTime(1900), // Earliest date that can be selected
      lastDate: DateTime.now(), // Latest date is today
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: MyColors.black, // Header background color
            hintColor: Colors.black, // Selected date color
            colorScheme: ColorScheme.light(
              primary: Colors.black.withOpacity(0.1), // Selected date highlight color
              onPrimary: MyColors.primaryColor, // Text color on selected date (header)
              surface: Colors.white, // Calendar background
              onSurface: Colors.black, // Default text color in the picker
            ),
            //buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Set button text color to black
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _controller?.text = DateFormat('yyyy-MM-dd').format(pickedDate); // Update text field
      });
      if (widget.onDateChanged != null) {
        widget.onDateChanged!(pickedDate);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
