import 'package:flutter/material.dart';

class AnimatedDrawerScreen extends StatefulWidget {
  @override
  _AnimatedDrawerScreenState createState() => _AnimatedDrawerScreenState();
}

class _AnimatedDrawerScreenState extends State<AnimatedDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE0342F),
        title: Text("Animated Drawer Example"),
        centerTitle: true,
      ),
      body: Center(child: Text("Main Screen")),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.redAccent, Colors.pinkAccent],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Profile Section with Animation
              AnimatedDrawerHeader(),

              // Home Link
              _buildDrawerItem(
                icon: Icons.home,
                title: "Home",
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              // Orders Link
              _buildDrawerItem(
                icon: Icons.shopping_cart,
                title: "My Orders",
                onTap: () {
                  Navigator.pushNamed(context, '/orders');
                },
              ),
              // Cart Link
              _buildDrawerItem(
                icon: Icons.shopping_bag,
                title: "My Cart",
                onTap: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              // Settings Link
              _buildDrawerItem(
                icon: Icons.settings,
                title: "Settings",
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              // Logout Link
              _buildDrawerItem(
                icon: Icons.exit_to_app,
                title: "Logout",
                onTap: () {
                  // Add your logout logic here
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for building Drawer items
  Widget _buildDrawerItem({required IconData icon, required String title, required Function onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onTap: () => onTap(),
    );
  }
}

class AnimatedDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
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
            backgroundImage: NetworkImage('https://www.w3schools.com/w3images/avatar2.png'),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'johndoe@email.com',
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
