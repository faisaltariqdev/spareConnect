
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spare_connect/utils/size_config.dart';
import 'package:spare_connect/view/auth/splash_screen.dart';
import 'package:spare_connect/view/homepage/homepage.dart';
import 'package:spare_connect/view/seller/seller_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GetMaterialApp(
      title: "Spare Connect",
      defaultTransition: Transition.rightToLeft,
      debugShowCheckedModeBanner: false,
      home: _getInitialScreen(), // Dynamically determine the initial screen
    );
  }

  Widget _getInitialScreen() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // User is logged in, fetch their userType
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid) // Fetch the user's document
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            // Document does not exist or error occurred
            return SplashScreen();
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null || !data.containsKey('userType')) {
            // If the 'userType' field is missing, navigate to SplashScreen
            return SplashScreen();
          }

          final userType = data['userType'];

          if (userType == 'seller') {
            return SellerDashboardScreen();
          } else if (userType == 'customer') {
            return HomePage();
          } else {
            return SplashScreen(); // Default fallback
          }
        },
      );
    } else {
      // User is not logged in, show SplashScreen
      return SplashScreen();
    }
  }
}
