import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spare_connect/widget/custom_textfield.dart';
import 'package:spare_connect/widget/custom_button.dart';
import 'package:spare_connect/widget/phone_picker.dart';
import 'package:spare_connect/widget/custom_date_picker.dart';
import 'package:spare_connect/widget/my_colors.dart';
import 'package:spare_connect/controllers/auth_conntroller/auth_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../../widget/dimens.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  AuthController authController = Get.put(AuthController());
  String accountType = 'customer'; // Default account type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        centerTitle: true,
        backgroundColor: MyColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Picture and Account Type Buttons
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context, 0);
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: MyColors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: MyColors.grey.withOpacity(0.2), width: 0.5),
                        ),
                        height: getHeight(80),
                        width: getWidth(80),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child:
                          // Obx(() => authController.galleryImgCompress.value != ""
                          //     ? Image(
                          //   fit: BoxFit.fill,
                          //   image: FileImage(authController.galleryImg! as File),
                          // )
                          //     : Icon(
                          //   Icons.person,
                          //   color: MyColors.white,
                          //   size: getWidth(40),
                          // )),
                          Obx(() => authController.galleryImg.value != null
                              ? Image(
                            fit: BoxFit.fill,
                            image: FileImage(authController.galleryImg.value!),
                          )
                              : Icon(
                            Icons.person,
                            color: MyColors.white,
                            size: getWidth(40),
                          )),

                        ),
                      ),
                      Positioned(
                        bottom: getHeight(1),
                        right: getHeight(1),
                        child: Container(
                          padding: EdgeInsets.all(getHeight(3)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColors.grey.withOpacity(0.6),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: MyColors.white,
                            size: getWidth(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimens.size5),
              Text(
                'Upload Profile Picture',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: MyColors.black.withOpacity(.6),
                  fontSize: getFont(16),
                ),
              ),
              SizedBox(height: getHeight(20)),

              // Account Type Selection Buttons
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Customer Button
                        Container(
                          height: getHeight(50),
                          width: getWidth(150),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: accountType == 'customer'
                                  ? MyColors.primaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                            color: accountType == 'customer'
                                ? MyColors.primaryColor
                                : Colors.transparent,
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                accountType = 'customer';
                              });
                            },
                            child: Text(
                              'Customer',
                              style: TextStyle(
                                color: accountType == 'customer'
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        // Seller Button
                        Container(
                          height: getHeight(50),
                          width: getWidth(150),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: accountType == 'seller'
                                  ? MyColors.primaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                            color: accountType == 'seller'
                                ? MyColors.primaryColor
                                : Colors.transparent,
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                accountType = 'seller';
                              });
                            },
                            child: Text(
                              'Seller',
                              style: TextStyle(
                                color: accountType == 'seller'
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),

              // Common Fields (for both customer and seller)
              CustomTextField(
                controller: authController.nameController,
                text: "",
                labelText: "Full Name",
                keyboardType: TextInputType.text,
                height: getHeight(60),
                bordercolor: MyColors.primaryColor.withOpacity(0.6),
                icon: Icon(Icons.text_fields_rounded),
                color: MyColors.primaryColor,
              ),
              SizedBox(height: 8),
              CustomTextField(
                controller: authController.emailController,
                text: "",
                labelText: "Email Address",
                keyboardType: TextInputType.emailAddress,
                height: getHeight(60),
                bordercolor: MyColors.primaryColor.withOpacity(0.6),
                icon: Icon(Icons.email_outlined),
                color: MyColors.primaryColor,
              ),
              SizedBox(height: 8),
              CustomTextField(

                controller: authController.passwordController,
                text: "",
                labelText: "Password",
                keyboardType: TextInputType.visiblePassword,
                height: getHeight(60),
                bordercolor: MyColors.primaryColor.withOpacity(0.6),
                icon: Icon(Icons.password_outlined),

                color: MyColors.primaryColor,
              ),
              SizedBox(height: 8),
              PhonePicker(
                controller: authController.phoneController,
                borderColor: MyColors.primaryColor,
                maxLength: 10,
                countryCode: Constants.countryCode,
              ),
              SizedBox(height: 8),
              CustomTextField(
                controller: authController.countryController,
                text: "",
                labelText: "Country",
                keyboardType: TextInputType.text,
                height: getHeight(60),
                bordercolor: MyColors.primaryColor.withOpacity(0.6),
                icon: Icon(Icons.location_city),
                color: MyColors.primaryColor,
              ),
              SizedBox(height: 8),
              CustomDatePickerField(
                controller: authController.DOBController,
                labelText: "Date of Birth",
                hintText: "",
                borderColor: MyColors.primaryColor,
                roundCorner: 8.0,
                onDateChanged: (selectedDate) {
                  print("Selected Date of Birth: $selectedDate");
                },
              ),
              SizedBox(height: 8),

              // Conditional Fields for Seller
              if (accountType == 'seller') ...[
                CustomTextField(
                  controller: authController.cnicController,
                  text: "",
                  labelText: "CNIC",
                  keyboardType: TextInputType.number,length: 13,
                  height: getHeight(60),
                  bordercolor: MyColors.primaryColor.withOpacity(0.6),
                  icon: Icon(Icons.perm_identity_outlined),
                  color: MyColors.primaryColor,
                ),
                CustomTextField(
                  controller: authController.businessNameController,
                  text: "",
                  labelText: "Business Name",
                  keyboardType: TextInputType.text,
                  height: getHeight(60),
                  bordercolor: MyColors.primaryColor.withOpacity(0.6),
                  icon: Icon(Icons.business),
                  color: MyColors.primaryColor,
                ),
                SizedBox(height: 8),
                CustomTextField(
                  controller: authController.businessAddressController,
                  text: "",
                  labelText: "Business Address",
                  keyboardType: TextInputType.streetAddress,
                  height: getHeight(60),
                  bordercolor: MyColors.primaryColor.withOpacity(0.6),
                  icon: Icon(Icons.location_on),
                  color: MyColors.primaryColor,
                ),
                SizedBox(height: 20),
              ],

              // Submit Button
              CustomButton(
                text: "Submit",
                onPressed: () async {
                  if (authController.validateInputs()) {
                    // Show loader
                    Get.dialog(
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false,
                    );

                    // Set account type
                    authController.userType.value = accountType;

                    // Create account
                    await authController.createAccount();

                    // Hide loader
                    // Get.back();
                  }
                },
                color: MyColors.primaryColor,
                borderColor: Colors.transparent,
              ),


            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context, int index) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          height: getHeight(100),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera, size: 24),
                title: Text('Camera', style: TextStyle(fontSize: getFont(18))),
                onTap: () {
                  authController.openCamera(index, context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
