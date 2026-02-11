
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/size_config.dart';

import '../widget/my_colors.dart';
import 'add_to_cart_checkout_Screen.dart';

class AddToCartScreenf extends StatelessWidget {
  final String userId;

  AddToCartScreenf({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
                  SizedBox(height: getHeight(20)),
                  Text(
                    'Your cart is empty!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final cartItems = snapshot.data!.docs;

          // Add cart document ID (Firestore ID) to each item
          List<Map<String, dynamic>> cartData = cartItems.map((doc) {
            final item = doc.data() as Map<String, dynamic>;
            item['cartId'] = doc.id; // Add document ID
            return item;
          }).toList();

          return ListView.builder(
            itemCount: cartData.length,
            itemBuilder: (context, index) {
              final item = cartData[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Image.network(
                    item['image'] ?? 'https://via.placeholder.com/150',
                    width: getWidth(80),
                    height: getHeight(80),
                    fit: BoxFit.cover,
                  ),
                  title: Text(item['name'] ?? 'No Name',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: ${item['price']}'),
                      Text('Quantity: ${item['quantity']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('carts')
                          .doc(item['cartId'])
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Item removed from cart!')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('carts')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return SizedBox.shrink();

          final cartItems = snapshot.data!.docs;

          // Calculate Total Price
          double totalPrice = cartItems.fold(0.0, (sum, doc) {
            final item = doc.data() as Map<String, dynamic>;
            return sum + double.parse(item['price'].replaceAll('\$', '')) * (item['quantity'] as int);
          });

          return Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                List<Map<String, dynamic>> cartData = cartItems.map((doc) {
                  final item = doc.data() as Map<String, dynamic>;
                  item['cartId'] = doc.id; // Add document ID for deletion
                  return item;
                }).toList();

                Get.to(() => AddToCartCheckoutScreen(
                  cartItems: cartData,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                ));
              },
              icon: Icon(Icons.payment, color: Colors.white),
              label: Text(
                'Proceed to Checkout - PKR ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: getFont(18), color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
