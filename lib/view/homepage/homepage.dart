import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spare_connect/utils/size_config.dart';
import 'package:spare_connect/widget/custom_textfield.dart';
import 'package:spare_connect/widget/bottom_navbar.dart';
import 'package:spare_connect/widget/home_items.dart';
import 'package:spare_connect/widget/my_colors.dart';
import '../../add_to_cart_screen.dart';
import '../auth/signup_home.dart';
import '../order_status_screen.dart';
import '../profile_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isLoading = true;
  bool showFilters = false; // Toggles filter options below search bar

  // For demonstration, let's filter only by 'condition'
  String selectedCondition = "All";

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  //Fetch products from Firestore
  Future<void> fetchAllProducts() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('products').get();

      // Force-cast doc.data() to Map<String, dynamic>
      allProducts = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'productId': doc.id,
          'name': data['product_name'] ?? 'No Name',
          'condition': data['condition'] ?? 'Unknown',
          'quantity': data['quantity'] ?? 0,
          'email': data['seller_email'] ?? 'no email',
          'price': data['price'] != null ? '${data['price']}' : 'No Price',
          'images': (data['images'] != null && data['images'] is List<dynamic>)
              ? List<String>.from(data['images'])
              : [],
          'sellerName': data['seller_name'] ?? 'Unknown Seller',
          'sellerContact': data['sellerContact'] ?? 'N/A',
          'sellerLocation': data['sellerLocation'] ?? 'N/A',
          'stock': data['stock'] ?? 'N/A',
          'description': data['description'] ?? 'N/A',
          'deliveryDays': data['deliveryDays'] ?? 'N/A',
          'warranty': data['warranty'] ?? 'N/A',
          'sellerId': data['userId'] ?? 'N/A',
        };
      }).toList();

      setState(() {
        filteredProducts = allProducts;
        isLoading = false; // Stop loading
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Search Functionality
  void _searchProducts(String query) {
    final results = allProducts.where((product) {
      final name = product['name'].toString().toLowerCase();
      final price = product['price'].toString().toLowerCase();
      final condition = product['condition'].toString().toLowerCase();
      final input = query.toLowerCase();

      return name.contains(input) ||
          price.contains(input) ||
          condition.contains(input);
    }).toList();

    setState(() {
      filteredProducts = results;
    });
  }

  // Filter Functionality
  void _applyFilter() {
    setState(() {
      // First, filter by condition
      filteredProducts = allProducts.where((product) {
        // If "All" is selected, we ignore the condition filter
        if (selectedCondition == "All") {
          return true;
        }
        return product['condition'].toString().toLowerCase() ==
            selectedCondition.toLowerCase();
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      selectedCondition = "All";
      filteredProducts = allProducts;
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 1) {
      Get.to(() => OrdersStatusScreen());
    } else if (index == 2) {
      Get.to(
            () => AddToCartScreenf(userId: FirebaseAuth.instance.currentUser!.uid),
      );
    } else if (index == 3) {
      Get.to(() => ProfileScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Home Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: // Shopping Cart Icon
        IconButton(
          icon: Icon(Icons.add_shopping_cart, color: Color(0xFFE0342F)),
          onPressed: () {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              Get.to(() => AddToCartScreenf(userId: user.uid));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User not logged in. Please log in first.')),
              );
            }
          },
        ),
        actions: [
          // Logout Button
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFFE0342F)),
            onPressed: () {
              _showLogoutDialog(context); // Show logout dialog
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search + Filter Icon
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    text: "",
                    keyboardType: TextInputType.text,
                    icon: Icon(Icons.search),
                    color: Colors.redAccent,
                    labelText: "Search Products...",
                    bordercolor: Colors.redAccent,
                    validator: null,
                    skipValidation: true,
                    onChanged: _searchProducts,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        showFilters = !showFilters;
                      });
                    },
                  ),
                ),
              ],
            ),

            // Display currently selected filter if it's not 'All'
            if (selectedCondition != "All")
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child:
                Container(
                  width: getWidth(160),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: MyColors.primaryColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0,top: 8,right: 8,bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          "Selected: $selectedCondition",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: getWidth(4)),
                        GestureDetector(
                          onTap: () {
                            _clearFilters();
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            // Filter options
            if (showFilters)
              Container(
                margin: EdgeInsets.only(top: 8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filter by Condition",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    DropdownButton<String>(
                      value: selectedCondition,
                      onChanged: (value) {
                        setState(() {
                          selectedCondition = value!;
                        });
                      },
                      items: ["All", "New", "Used"].map((condition) {
                        return DropdownMenuItem<String>(
                          value: condition,
                          child: Text(condition),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () {
                            _applyFilter();
                            showFilters = false;
                          },
                          child: Text(
                            "Apply",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.redAccent),
                          onPressed: () {
                            _clearFilters();
                            showFilters = false;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(height: getHeight(16)),
            Text(
              'All Products',
              style: TextStyle(fontSize: getFont(24), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: getHeight(16)),
            // Product Grid
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                  ? Center(
                child: Text(
                  "No products found",
                  style: TextStyle(fontSize: getFont(18), color: Colors.grey),
                ),
              )
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final images = product['images'] as List<String>;

                  return ProductWidget(
                    image: images.isNotEmpty
                        ? images[0]
                        : 'https://via.placeholder.com/150',
                    title: product['name'] ?? 'No Name',
                    price: product['price'] ?? 'No Price',
                    condition: product['condition'] ?? 'Unknown',
                    quantity: product['quantity'] ?? 0,
                    sellerName: product['sellerName'] ?? 'Unknown Seller',
                    sellerContact: product['sellerContact'] ?? 'N/A',
                    sellerLocation: product['sellerLocation'] ?? 'N/A',
                    stock: product['stock'] ?? 'N/A',
                    description: product['description'] ?? 'N/A',
                    deliveryDays: product['deliveryDays'] ?? 'N/A',
                    warranty: product['warranty'] ?? 'N/A',
                    sellerId: product['sellerId'] ?? 'N/A',
                    productId: product['productId'] ?? 'N/A',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Logout Dialog
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
                _logout(context); // Perform logout logic
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

  // Logout Functionality
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
        MaterialPageRoute(builder: (context) => SignUpHome()),
      );
    } catch (e) {
      print("Error signing out: $e");
      Navigator.pop(context); // In case of an error, close the loader dialog
    }
  }
}
