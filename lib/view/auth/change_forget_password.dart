import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spare_connect/view/auth/login_screen.dart';

import '../../controllers/auth_conntroller/auth_controller.dart';
import '../../utils/size_config.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/custom_toast.dart';
import '../../widget/dimens.dart';
import '../../widget/my_colors.dart';


class ChangeForgotPass extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  // final String uId;
  // final String reqId;
  // final bool fromSignIn;
  // ChangeForgotPass(
  //     {required this.fromSignIn, required this.uId, required this.reqId});
  //ChangePasswordController controller = Get.put(ChangePasswordController());

  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.white,
          leading: Placeholder(
            color: MyColors.cardGrey.withOpacity(.0),
            child: Container(
              // color: Colors.red,
              margin: EdgeInsets.only(left: getWidth(10)),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.cardGrey.withOpacity(.5)),
              width: getWidth(10),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: MyColors.black,
                ),
                onPressed: () {
                  //controller.clearData();
                  Get.back();
                },
              ),
            ),
          ),
          leadingWidth: getWidth(60),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: changePasswordFormKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/reset_password.png",
                  height: getHeight(205),
                  width: getWidth(205),
                ),
                SizedBox(
                  height: getHeight(60),
                ),
                Text(
                  'Reset Password',
                  style: TextStyle(
                      fontSize: getFont(32),

                      fontWeight: FontWeight.w900,
                      color: MyColors.primaryColor),
                ),
                SizedBox(
                  height: getHeight(32),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(

                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CustomTextField(
                          //controller: controller.otp,
                          text: 'Enter OTP',
                          // validator: (value) {
                          //   return controller.validation.validateOTP(value!);
                          // },
                          length: 50,
                          bordercolor: Color(0xFFE0342F),
                          keyboardType: TextInputType.text,
                          inputFormatters:
                          FilteringTextInputFormatter.singleLineFormatter),
                    ),
                  ),
                ),
                SizedBox(
                  height: getHeight(10),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(

                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CustomTextField(
                          //controller: controller.newPass,
                          text: 'Enter New Password'.tr,
                          // validator: (value) {
                          //   return controller.validation
                          //       .validateNewPassword(value!);
                          // },
                          // sufficon: 1,
                          obscureText: true,
                          length: 50,
                          bordercolor: Color(0xFFE0342F),
                          keyboardType: TextInputType.text,
                          inputFormatters:
                          FilteringTextInputFormatter.singleLineFormatter),
                    ),
                  ),
                ),
                SizedBox(
                  height: getHeight(10),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(

                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CustomTextField(
                          //controller: controller.confirmNewPass,
                          text: 'Enter Confirm Password',
                          // validator: (value) {
                          //   return controller.validation
                          //       .validateConfirmPassword(value!);
                          // },
                          length: 50,
                          obscureText: true,
                          // sufficon: 1,
                          bordercolor: Color(0xFFE0342F),

                          keyboardType: TextInputType.text,
                          inputFormatters:
                          FilteringTextInputFormatter.singleLineFormatter),
                    ),
                  ),
                ),
                SizedBox(
                  height: getHeight(40),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
                  child: CustomButton(
                    text: 'Reset Password'.tr,
                    borderColor: Colors.transparent,
                    color: Color(0xFFE0342F),
                    fontWeight: FontWeight.w500,
                    //roundCorner: Dimens.size5,
                    onPressed: () async {
                      String otp = ""; // Fetch OTP from the controller
                      String newPassword = ""; // Fetch new password from the controller
                      String confirmPassword = ""; // Fetch confirm password from the controller

                      if (otp.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
                        CustomToast.failToast("All fields are required.");
                        return;
                      }

                      if (newPassword != confirmPassword) {
                        CustomToast.failToast("Passwords do not match.");
                        return;
                      }

                      // Assuming OTP is valid (in real-world cases, you need to verify the OTP)
                      try {
                        User? user = FirebaseAuth.instance.currentUser;

                        // Use Firebase to update password (you can reauthenticate the user if needed)
                        await user!.updatePassword(newPassword);

                        CustomToast.successToast("Password updated successfully.");
                        Get.to(() => LoginScreen());
                      } catch (e) {
                        CustomToast.failToast("Error: ${e.toString()}");
                      }
                    },


                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
