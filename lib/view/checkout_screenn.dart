// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../utils/size_config.dart';
// import 'order_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:spare_connect/widget/custom_button.dart';
// import 'package:spare_connect/widget/my_colors.dart';
//
// class CheckoutScreen extends StatefulWidget {
//   final Map<String, dynamic> product;
//
//   CheckoutScreen({required this.product});
//
//   @override
//   _CheckoutScreenState createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   String _selectedPaymentMethod = 'Credit/Debit Card';
//   String _shippingAddress = '';
//   bool _agreedToTerms = false;
//   bool _isLoading = false; // To manage loading state
//
//   final _firestore = FirebaseFirestore.instance;
//
//   // Place Order Function
//   void _placeOrder() async {
//     if (_shippingAddress.isEmpty || !_agreedToTerms) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please provide a shipping address and agree to terms')),
//       );
//       return;
//     }
//
//     setState(() {
//       _isLoading = true; // Show loader
//     });
//
//     // Simulate a 2-second delay
//     await Future.delayed(Duration(seconds: 2));
//
//     try {
//       // Fetch user ID
//       String customerId = FirebaseAuth.instance.currentUser!.uid;
//
//       // Order Details
//       Map<String, dynamic> orderDetails = {
//         'customerId': customerId,
//         'productId': widget.product['productId'],
//         'productName': widget.product['name'],
//         'price': widget.product['price'],
//         'quantity': widget.product['quantity'],
//         'totalPrice': double.parse(widget.product['price'].replaceAll('\$', '')) * widget.product['quantity'],
//         'shippingAddress': _shippingAddress,
//         'paymentMethod': _selectedPaymentMethod,
//         'orderDate': FieldValue.serverTimestamp(),
//         'sellerId': widget.product['sellerId'],
//         'status': 'Pending',
//       };
//
//       // Save Order in Firebase
//       await _firestore.collection('orders').add(orderDetails);
//
//       setState(() {
//         _isLoading = false; // Hide loader
//       });
//
//       _showSuccessDialog(); // Show success dialog
//     } catch (e) {
//       setState(() {
//         _isLoading = false; // Hide loader
//       });
//       print("Error placing order: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to place order. Please try again.')),
//       );
//     }
//   }
//
//   // Success Dialog
//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           title: Column(
//             children: [
//               Icon(Icons.check_circle_outline, color: Colors.green, size: 50),
//               SizedBox(height: getHeight(10)),
//               Text(
//                 'Order Placed Successfully!',
//                 style: TextStyle(
//                     fontSize: getFont(20),
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Your order has been placed successfully.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: getFont(16)),
//               ),
//               SizedBox(height: getHeight(20)),
//               ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFE0342F),
//                   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Get.to(() => OrderScreen());
//                 },
//                 icon: Icon(Icons.shopping_bag, color: Colors.white),
//                 label: Text('Go to Orders', style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final product = widget.product;
//     double totalPrice = double.parse(product['price'].replaceAll('\$', '')) * product['quantity'];
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFE0342F),
//         title: Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(
//           color: Color(0xFFE0342F),
//         ),
//       )
//           : SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Order Summary
//             Card(
//               color: Colors.white,
//               elevation: 5,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: ListTile(
//                 leading: Image.network(product['image'], width: 50, height: 50, fit: BoxFit.cover),
//                 title: Text(product['name'], style: TextStyle(fontSize: getFont(18), fontWeight: FontWeight.bold)),
//                 subtitle: Text('Price: ${product['price']} x ${product['quantity']}'),
//                 trailing: Text(
//                   'PKR ${totalPrice.toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: getFont(18), fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ),
//             ),
//             SizedBox(height: getHeight(20)),
//
//             // Shipping Address
//             Text('Shipping Address', style: TextStyle(fontSize: getFont(18), fontWeight: FontWeight.bold)),
//             SizedBox(height: getHeight(20)),
//             TextField(
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.location_on, color: Colors.red),
//                 labelText: 'Enter Address',
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               onChanged: (value) => _shippingAddress = value,
//             ),
//             SizedBox(height: getHeight(20)),
//
//             // Payment Method
//             Text('Payment Method', style: TextStyle(fontSize: getFont(18), fontWeight: FontWeight.bold)),
//             DropdownButtonFormField<String>(
//               value: _selectedPaymentMethod,
//               items: ['Credit/Debit Card', 'PayPal', 'Cash on Delivery']
//                   .map((method) => DropdownMenuItem(value: method, child: Text(method)))
//                   .toList(),
//               onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
//             ),
//             SizedBox(height: getHeight(20)),
//
//             // Terms and Conditions
//             Row(
//               children: [
//                 Checkbox(
//                   value: _agreedToTerms,
//                   onChanged: (value) => setState(() => _agreedToTerms = value!),
//                   activeColor: Color(0xFFE0342F),
//                 ),
//                 Expanded(
//                   child: Text('I agree to the Terms and Conditions', style: TextStyle(fontSize: getFont(16))),
//                 ),
//               ],
//             ),
//             SizedBox(height: getHeight(20)),
//
//             // Place Order Button
//             CustomButton(
//               text: 'Place Order',
//               textColor: _agreedToTerms ? Colors.white : Colors.grey,
//               color: _agreedToTerms ? Color(0xFFE0342F) : Colors.grey,
//               borderColor: _agreedToTerms ? Color(0xFFE0342F) : Colors.grey,
//               onPressed: _agreedToTerms ? _placeOrder : null,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/size_config.dart';
import '../widget/custom_button.dart';
import '../widget/my_colors.dart';
import 'order_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  CheckoutScreen({required this.product});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Credit/Debit Card';
  String _shippingAddress = '';
  bool _agreedToTerms = false;
  bool _isLoading = false;


  final _firestore = FirebaseFirestore.instance;

  void _placeOrder() async {
    if (_shippingAddress.isEmpty || !_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a shipping address and agree to terms')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2)); // Simulate delay

    try {
      String customerId = FirebaseAuth.instance.currentUser!.uid;

      // Order details to save
      Map<String, dynamic> orderDetails = {
        'customerId': customerId,
        'productId': widget.product['productId'],
        'productName': widget.product['name'],
        'price': widget.product['price'],
        'quantity': widget.product['quantity'],
        'totalPrice': double.parse(widget.product['price'].replaceAll('\$', '')) * widget.product['quantity'],
        'shippingAddress': _shippingAddress,
        'paymentMethod': _selectedPaymentMethod,
        'orderDate': FieldValue.serverTimestamp(),
        'sellerId': widget.product['sellerId'],
        'status': 'Pending',
      };

      // Save order and get document ID
      final DocumentReference orderRef = await _firestore.collection('orders').add(orderDetails);

      setState(() {
        _isLoading = false;
      });

      // Navigate to OrderScreen with order ID
      Get.to(() => OrderScreen(orderId: orderRef.id));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error placing order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    double totalPrice = double.parse(product['price'].replaceAll('\$', '')) * product['quantity'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: MyColors.primaryColor,
        title: Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: MyColors.primaryColor))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Card(
              child: ListTile(
                leading: Image.network(product['image'], width: 50, height: 50, fit: BoxFit.cover),
                title: Text(product['name'],style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text('Price: ${product['price']} x ${product['quantity']}'),
                trailing: Text('PKR ${totalPrice.toStringAsFixed(2)}',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(height: 20),

            // Shipping Address
            Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Enter Address', border: OutlineInputBorder()),
              onChanged: (value) => _shippingAddress = value,
            ),
            SizedBox(height: 20),

            // Payment Method
            Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                ),
                Text('I agree to the Terms and Conditions'),
              ],
            ),
            SizedBox(height: 20),

            // Place Order Button
            CustomButton(
              text: 'Place Order',
              color: _agreedToTerms ? MyColors.primaryColor : Colors.grey,
              textColor: Colors.white,
              borderColor: Colors.transparent,
              onPressed: _agreedToTerms ? _placeOrder : null,
            ),
          ],
        ),
      ),
    );
  }
}
