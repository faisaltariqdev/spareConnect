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
import 'change_forget_password.dart';


class ForgetPassword extends StatelessWidget {
  // Define the controller for the email field
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 35,
                            color: MyColors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Image.asset(
                    "assets/images/forgot_pass_pic.png",
                    height: getHeight(252),
                    width: getWidth(252),
                  ),
                  SizedBox(height: getHeight(60)),
                  Text(
                    'ForgotPassword'.tr,
                    style: TextStyle(
                      fontSize: getFont(32),
                      fontWeight: FontWeight.w900,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: getHeight(32)),
                  Text(
                    'Enter your email address. A Reset link will be sent to your registered email'
                        .tr,
                    style: Get.textTheme.headline5!.copyWith(
                      color: MyColors.black.withOpacity(.6),
                      fontSize: getFont(14),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getHeight(30)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
                    child: Container(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: CustomTextField(
                          controller: emailController,  // Pass the controller here
                          text: "",
                          labelText: "Email Address",
                          keyboardType: TextInputType.emailAddress,
                          height: getHeight(60),
                          bordercolor: Color(0xFFE0342F).withOpacity(0.6),
                          icon: Icon(Icons.email_outlined),
                          color: Color(0xFFE0342F),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  CustomButton(
                    text: 'Continue'.tr,
                    fontWeight: FontWeight.w500,
                    width: 374,
                    fontSize: 16,
                    color: Color(0xFFE0342F),
                    borderColor: Colors.transparent,
                    roundCorner: Dimens.size5,
                    onPressed: () async {
                      String email = emailController.text.trim();  // Get email from controller

                      if (email.isEmpty || !GetUtils.isEmail(email)) {
                        CustomToast.failToast("Please enter a valid email address");
                        return;
                      }

                      // Send the password reset email
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                        CustomToast.successToast("Reset link sent to your email.");
                        //Get.to(() => ChangeForgotPass());
                        Get.to(()=>LoginScreen());
                      } catch (e) {
                        CustomToast.failToast("Error: ${e.toString()}");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

