import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spare_connect/view/seller/manage_product_screen.dart';
import 'package:spare_connect/view/seller/seller_order_screen.dart';
import 'package:spare_connect/view/seller/seller_rating_Screen.dart';

import '../../controllers/seller_conntrollers/seller_dashboard.dart';
import '../../utils/size_config.dart';
import '../auth/signup_home.dart';
import 'add_product_screen.dart';


class SellerDashboardScreen extends StatelessWidget {
  final SellerDashboardController controller = Get.put(SellerDashboardController());

  final Color primaryColor = Color(0xFFE0342F); // Custom Primary Color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Dashboard',style: TextStyle(color: Colors.white),),
        backgroundColor: primaryColor, // Use the custom primary color
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu), // Drawer (hamburger) icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer on icon click
              },
            );
          },
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,

        ),

      ),
      drawer: AnimatedDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchDashboardMetrics(); // Re-fetch metrics
          // Add a short delay to simulate loading
          await Future.delayed(Duration(seconds: 1));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                'Welcome, Seller!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Dashboard Metrics
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    Obx(() => _buildDashboardCard('Total Sales', "PKR${controller.totalSales.value}")),
                    Obx(() => _buildDashboardCard('Listed Products', '${controller.listedProducts.value}')),
                    Obx(() => _buildDashboardCard('Pending Orders', '${controller.pendingOrders.value}')),
                    Obx(() => _buildDashboardCard('Delivered Orders', '${controller.deliveredOrders.value}')),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Quick Actions
              Text(
                'Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAction(
                    icon: Icons.add_box,
                    label: 'Add Product',
                    onTap: () {
                      Get.to(()=>AddProductScreen()); // Navigate to Add Product Screen
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.list_alt,
                    label: 'Manage Products',
                    onTap: () {
                      Get.to(()=>ManageProductScreen()); // Navigate to Manage Products Screen
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.shopping_cart,
                    label: 'Orders',
                    onTap: () {
                      Get.to(()=>SellerOrderScreen()); // Navigate to Order Management Screen
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Dashboard Cards
  Widget _buildDashboardCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: getFont(20), fontWeight: FontWeight.bold, color: primaryColor),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Quick Actions
  Widget _buildQuickAction(
      {required IconData icon, required String label, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: primaryColor, // Use the custom primary color
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}





class AnimatedDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            //colors: [Colors.redAccent, Colors.pinkAccent],
            colors: [Colors.white,Colors.white],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: getHeight(40),),
            // Profile Section with Animation
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedDrawerHeader(),
            ),

            // Navigation Items
            ListTile(


              leading: Icon(Icons.home, color: Color(0xFFE0342F)),
              title: Text('Home', style: TextStyle(color: Color(0xFFE0342F))),
              onTap: () {
                Get.back();
                //Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: Color(0xFFE0342F)),
              title: Text('All Orders', style: TextStyle(color: Color(0xFFE0342F))),
              onTap: () {
                Get.to(()=>SellerOrderScreen());
                //Navigator.pushNamed(context, '/orders');
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback_outlined, color: Color(0xFFE0342F)),
              title: Text('Rating & Feedback', style: TextStyle(color: Color(0xFFE0342F))),
              onTap: () {
                Get.to(()=>SellerRatingScreen());

              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Color(0xFFE0342F)),
              title: Text('Logout', style: TextStyle(color: Color(0xFFE0342F))),
              onTap: () {
                // Perform logout
                _showLogoutDialog(context); // Show confirmation dialog
                //Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
// Function to show the confirmation dialog
// Function to show the confirmation dialog before logout
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Are you sure?",
          style: TextStyle(
            color: Color(0xFFE0342F),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Do you really want to log out? You will be signed out of your account.",
          style: TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Perform logout logic
              _logout(context);
            },
            child: Text(
              "Logout",
              style: TextStyle(
                color: Color(0xFFE0342F),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// Logout functionality and navigate to SignUpHome screen
// Logout functionality and navigate to SignUpHome screen after showing a loader
void _logout(BuildContext context) async {
  try {
    // Show a loader while logging out
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // Loader displayed while waiting
        );
      },
    );

    // Sign out the user from Firebase
    await FirebaseAuth.instance.signOut();

    // Wait for 2 seconds before navigating to SignUpHome screen
    await Future.delayed(Duration(seconds: 2));

    // Close the loader dialog
    Navigator.pop(context);

    // Navigate to the SignUpHome screen after the delay
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpHome()), // Replace with your SignUpHome screen
    );
  } catch (e) {
    print("Error signing out: $e");
    Navigator.pop(context); // In case of an error, close the loader dialog
  }
}





class AnimatedDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen for changes in auth state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading indicator while fetching user data
        }

        User? user = snapshot.data;

        if (user == null) {
          // If the user is not logged in, show 'Guest' as name
          return _buildDrawerHeader('Guest', 'Not logged in', '');
        }

        // Fetch the user's name and other details from Firestore
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Loading indicator while fetching Firestore data
            }

            if (snapshot.hasError) {
              return _buildDrawerHeader('Error', 'Failed to load user data', '');
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              // If no data exists for the user, return default data
              return _buildDrawerHeader('Guest', 'Not logged in', '');
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String name = userData['name'] ?? 'Guest'; // Get the name from Firestore or use 'Guest'
            String email = user.email ?? 'No Email';
            String photoUrl = userData['profileImage'] ?? ''; // Get the photo URL from FirebaseAuth, or empty if not available

            return _buildDrawerHeader(name, email, photoUrl);
          },
        );
      },
    );
  }

  // Widget to build the drawer header
  Widget _buildDrawerHeader(String name, String email, String photoUrl) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        color: Color(0xFFE0342F),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: photoUrl.isNotEmpty
                ? NetworkImage(photoUrl) // User's photo if available
                : NetworkImage('https://www.w3schools.com/w3images/avatar2.png'), // Default image
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name, // Display user name or 'Guest'
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
