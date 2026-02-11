import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spare_connect/utils/size_config.dart';
import 'package:spare_connect/view/auth/login_screen.dart';
import 'package:spare_connect/widget/custom_button.dart';
import 'package:get/get.dart';

import 'create_account.dart';


class SignUpHome extends StatelessWidget {
  // Controllers to manage form inputs
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: getHeight(100),),
              // Logo or app name at the top
              Image.asset("assets/images/logo1.png",height: 250,width: 250,),
              SizedBox(height: 20),
          
              CustomButton(text: "Create Account", onPressed: (){
                Get.to(()=>CreateAccountScreen());
              },
                color: Color(0xFFE0342F),borderColor: Colors.transparent,),
          
              SizedBox(height: 20),
          
              CustomButton(text: "Login", onPressed: (){
                Get.to(()=> LoginScreen());
              },color: Colors.transparent,borderColor: Color(0xFFE0342F),textColor: Color(0xFFE0342F),),

              SizedBox(height: 30),
          
            ],
          ),
        ),
      ),
    );
  }
}
