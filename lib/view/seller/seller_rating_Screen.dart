import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spare_connect/utils/size_config.dart';

class SellerRatingScreen extends StatelessWidget {
  SellerRatingScreen({Key? key}) : super(key: key);

  // Fetch all orders
  Stream<QuerySnapshot> fetchOrdersForSeller() {
    final sellerId = FirebaseAuth.instance.currentUser?.uid;

    if (sellerId == null) {
      throw Exception("User not logged in");
    }

    return FirebaseFirestore.instance.collection('orders').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seller Feedback',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: getFont(20),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Color(0xFFE0342F),
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchOrdersForSeller(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching feedback',
                style: TextStyle(fontSize: getFont(18), color: Colors.grey),
              ),
            );
          }

          final orders = snapshot.data?.docs ?? [];

          // Filter orders where the sellerId matches inside the products array
          final feedbackOrders = orders.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final products = data['products'] as List<dynamic>? ?? [];
            final hasSellerProduct = products.any((product) {
              final productMap = product as Map<String, dynamic>;
              return productMap['sellerId'] == FirebaseAuth.instance.currentUser?.uid;
            });
            return hasSellerProduct && data.containsKey('feedback') && data['feedback'] != null;
          }).toList();

          if (feedbackOrders.isEmpty) {
            return Center(
              child: Text(
                'No feedback available yet.',
                style: TextStyle(fontSize: getFont(18), color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: getFont(18), vertical: 8),
            itemCount: feedbackOrders.length,
            itemBuilder: (context, index) {
              final feedback = (feedbackOrders[index].data() as Map<String, dynamic>)['feedback'] as Map<String, dynamic>;
              return _buildFeedbackCard(feedback);
            },
          );
        },
      ),
    );
  }

  // Feedback Card Widget
  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with User Icon and Name
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.userCircle,
                  size: 24,
                  color: Colors.blueGrey,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    feedback['customerName'] ?? 'Unknown Customer',
                    style: TextStyle(
                      fontSize: getFont(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Rating Stars Row
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < (feedback['rating'] ?? 0)
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            SizedBox(height: 10),

            // Feedback Comment
            Row(
              children: [
                Expanded(
                  child: Text(
                    feedback['comment'] ?? 'No comment provided.',
                    style: TextStyle(
                      fontSize: getFont(18),
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FaIcon(
                  FontAwesomeIcons.commentDots,
                  size: 20,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
