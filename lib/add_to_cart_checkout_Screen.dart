import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spare_connect/view/homepage/homepage.dart';
import '../utils/size_config.dart';
import '../widget/custom_button.dart';
import '../widget/my_colors.dart';

class AddToCartCheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final String userId;

  AddToCartCheckoutScreen({required this.cartItems, required this.userId});

  @override
  _AddToCartCheckoutScreenState createState() =>
      _AddToCartCheckoutScreenState();
}


class _AddToCartCheckoutScreenState extends State<AddToCartCheckoutScreen> {
  String _shippingAddress = '';
  String _selectedPaymentMethod = 'Credit/Debit Card';
  bool _agreedToTerms = false;
  bool _isLoading = false;

  final _firestore = FirebaseFirestore.instance;

  // Calculate total price
  double getTotalPrice() {
    return widget.cartItems.fold(0.0, (sum, item) {
      // Clean the price string and ensure it's parsable
      String cleanPrice = item['price']
          .toString()
          .replaceAll(RegExp(r'[^0-9.]'), ''); // Remove non-numeric characters

      double price = double.tryParse(cleanPrice) ?? 0.0; // Default to 0.0 if parsing fails
      int quantity = item['quantity'] ?? 1;

      return sum + (price * quantity);
    });
  }


  void placeOrder(List<Map<String, dynamic>> cartItems, String shippingAddress, String paymentMethod) async {
    setState(() => _isLoading = true);

    try {
      String customerId = FirebaseAuth.instance.currentUser!.uid;
      WriteBatch batch = FirebaseFirestore.instance.batch();

      Map<String, dynamic> orderData = {
        'customerId': customerId,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'Pending',
        'totalAmount': cartItems.fold(0.0, (sum, item) {
          double price = double.parse(item['price'].replaceAll(RegExp(r'[^0-9.]'), ''));
          return sum + price * (item['quantity'] ?? 1);
        }),
        'products': cartItems.map((item) {
          return {
            'productId': item['productId'] ?? '',
            'productName': item['name'] ?? 'No Name',
            'price': item['price'] ?? '0.0',
            'quantity': item['quantity'] ?? 1,
            'sellerId': item['sellerId'] ?? '',
          };
        }).toList(),
      };

      DocumentReference orderRef = FirebaseFirestore.instance.collection('orders').doc();
      batch.set(orderRef, orderData);

      for (var item in cartItems) {
        final cartRef = FirebaseFirestore.instance.collection('carts').doc(item['cartId']);
        batch.delete(cartRef);
      }

      await batch.commit();

      setState(() => _isLoading = false);
      _showSuccessDialog();
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order failed, try again.')));
    }
  }




  // void placeOrder(List<Map<String, dynamic>> cartItems, String shippingAddress, String paymentMethod) async {
  //   try {
  //     // Fetch the logged-in user's ID
  //     String customerId = FirebaseAuth.instance.currentUser!.uid;
  //
  //     // Prepare the order data
  //     Map<String, dynamic> orderData = {
  //       'customerId': customerId,
  //       'shippingAddress': shippingAddress,
  //       'paymentMethod': paymentMethod,
  //       'orderDate': FieldValue.serverTimestamp(),
  //       'status': 'Pending',
  //       'totalAmount': cartItems.fold(0.0, (sum, item) {
  //         String cleanPrice = item['price']
  //             .toString()
  //             .replaceAll(RegExp(r'[^0-9.]'), ''); // Clean price string
  //         double price = double.tryParse(cleanPrice) ?? 0.0;
  //         return sum + (price * (item['quantity'] ?? 1));
  //       }), // Total amount for all products
  //       'products': cartItems.map((item) {
  //         return {
  //           'productId': item['productId'] ?? '',
  //           'productName': item['name'] ?? 'No Name',
  //           'price': item['price'] ?? '0.0',
  //           'quantity': item['quantity'] ?? 1,
  //           'sellerId': item['sellerId'] ?? '',
  //         };
  //       }).toList(), // List of all products in the order
  //     };
  //
  //     // Add the order to the 'orders' collection in Firebase
  //     await FirebaseFirestore.instance.collection('orders').add(orderData);
  //
  //     print("Order placed successfully!");
  //   } catch (e) {
  //     print("Error placing order: $e");
  //   }
  // }

  // Success Dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Column(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 50),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Order Placed Successfully!',
                style: TextStyle(
                    fontSize: getFont(20), fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
          ],
        ),
        content: Text(
          'Your order has been placed. We will notify you with updates.',
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                  Get.to(()=>HomePage());
              },
              child: Text('Go to Home', style: TextStyle(color: MyColors.primaryColor)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        title: Text('Checkout', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColors.primaryColor,

      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: MyColors.primaryColor))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of Cart Items
            Text('Your Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ...widget.cartItems.map((item) {
              return Card(
                margin: EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['name']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing: Text('PKR ${item['price']}'),
                ),
              );
            }).toList(),

            Divider(),
            // Total Price
            ListTile(
              title: Text('Total Amount',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: Text('PKR ${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, color: Colors.green)),
            ),
            SizedBox(height: 20),

            // Shipping Address
            Text('Shipping Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your shipping address',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _shippingAddress = value,
            ),
            SizedBox(height: 20),

            // Payment Method
            Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              items: ['Credit/Debit Card', 'PayPal', 'Cash on Delivery']
                  .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
            ),
            SizedBox(height: 20),

            // Terms and Conditions
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (value) => setState(() => _agreedToTerms = value!),
                  activeColor: MyColors.primaryColor,
                ),
                Expanded(
                  child: Text('I agree to the Terms and Conditions'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Place Order Button
            CustomButton(
              text: 'Place Order',
              color: _agreedToTerms ? MyColors.primaryColor : Colors.grey,
              textColor: Colors.white,
              borderColor: Colors.transparent,
              onPressed: _agreedToTerms
                  ? () {
                placeOrder(widget.cartItems, _shippingAddress, _selectedPaymentMethod);
              }
                  : null, // Disable if terms not agreed
            ),

          ],
        ),
      ),
    );
  }
}
