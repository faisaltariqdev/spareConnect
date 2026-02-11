import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spare_connect/utils/size_config.dart';
import 'package:spare_connect/view/homepage/homepage.dart';
import 'package:spare_connect/widget/custom_button.dart';
import 'package:spare_connect/widget/custom_textfield.dart';
import 'package:get/get.dart';
import '../../controllers/auth_conntroller/auth_controller.dart';
import 'create_account.dart';
import 'forget_password.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or App name at the top
              Image.asset(
                "assets/images/logo1.png",
                height: 250,
                width: 250,
              ),
              SizedBox(height: 10),

              // Email TextField
              CustomTextField(
                controller: authController.emailController,
                text: "",
                labelText: "Email Address",
                keyboardType: TextInputType.emailAddress,
                height: getHeight(60),
                bordercolor: Color(0xFFE0342F).withOpacity(0.6),
                icon: Icon(Icons.email_outlined),
                color: Color(0xFFE0342F),
              ),
              SizedBox(height: 20),

              // Password TextField
              CustomTextField(
                controller: authController.passwordController,
                text: "",
                labelText: "Password",
                keyboardType: TextInputType.visiblePassword,
                height: getHeight(60),
                bordercolor: Color(0xFFE0342F).withOpacity(0.6),
                icon: Icon(Icons.password_outlined),
                color: Color(0xFFE0342F),
              ),
              SizedBox(height: 30),

              // Login Button
              Obx(() => authController.isLoading.value
                  ? CircularProgressIndicator()
                  : CustomButton(
                text: "Login",
                onPressed: () {
                  authController.login();
                },
                color: Color(0xFFE0342F),
                borderColor: Colors.transparent,
              )),
              SizedBox(height: 20),

              // Sign Up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => CreateAccountScreen());
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFFE0342F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Forgot Password link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ForgetPassword());
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFFE0342F),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
