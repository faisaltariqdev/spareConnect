import 'package:flutter/material.dart';
import 'package:spare_connect/view/auth/signup_home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController with a duration (e.g., 3 seconds)
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Animation duration
    );

    // Define the fade animation (from 0.0 to 1.0)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,  // Use easeIn for a smooth fade-in effect
      ),
    );

    // Start the animation
    _animationController.forward();

    // After a delay of 7 seconds, navigate to the HomeScreen
    Future.delayed(Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpHome()),
      );
    });
  }

  @override
  void dispose() {
    // Dispose of the AnimationController to free up resources
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0342F), Color(0xFFA81015)], // Gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          // Wrap the logo with FadeTransition for the fade-in effect
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              'assets/images/logo.png',
              width: 300,
              height: 300,
            ),
          ),
        ),
      ),
    );
  }
}

