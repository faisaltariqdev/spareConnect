import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spare_connect/utils/size_config.dart';
import 'package:spare_connect/widget/my_colors.dart';

class OrdersStatusScreen extends StatelessWidget {
  const OrdersStatusScreen({Key? key}) : super(key: key);

  // Helper function to fetch orders
  Stream<QuerySnapshot> fetchOrdersByStatus(String status) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not logged in");
    }
    return FirebaseFirestore.instance
        .collection('orders')
        .where('customerId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          backgroundColor: Color(0xFFE0342F),
          title: Text(
            'Your Orders',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: Icon(Icons.pending_actions),
                text: 'Pending Orders',
              ),
              Tab(
                icon: Icon(Icons.check_circle_outline),
                text: 'Completed Orders',
              ),
            ],
          ),
          automaticallyImplyLeading: true,

        ),
        body: TabBarView(
          children: [
            // Pending Orders
            StreamBuilder<QuerySnapshot>(
              stream: fetchOrdersByStatus('Pending'),
              builder: (context, snapshot) {
                return _buildOrderList(snapshot, 'Pending');
              },
            ),
            // Completed Orders
            StreamBuilder<QuerySnapshot>(
              stream: fetchOrdersByStatus('Completed'),
              builder: (context, snapshot) {
                return _buildOrderList(snapshot, 'Completed');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(AsyncSnapshot<QuerySnapshot> snapshot, String status) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error fetching orders.'));
    }

    final orders = snapshot.data?.docs ?? [];

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'No $status Orders Found!',
              style: TextStyle(fontSize: getFont(18), color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index].data() as Map<String, dynamic>;
        final List products = order['products'] ?? [];

        return Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Order ID and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long, color: Colors.blueGrey),
                        SizedBox(width: getWidth(8)),
                        Text(
                          'Order ID: ${orders[index].id.substring(0, 4)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: getFont(16)),
                        ),
                      ],
                    ),
                    Chip(
                      label: Text(
                        status,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor:
                      status == 'Pending' ? Colors.orange : Colors.green,
                    ),
                  ],
                ),
                Divider(),

                // Product List
                Text(
                  'Products:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: getFont(16)),
                ),
                SizedBox(height: 5),
                ...products.map((product) {
                  return Row(
                    children: [
                      Icon(Icons.shopping_bag, size: 18, color: Colors.blueGrey),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${product['productName']} x${product['quantity']}',
                          style: TextStyle(fontSize: getFont(15)),
                        ),
                      ),
                    ],
                  );
                }).toList(),

                SizedBox(height: 5),

                // Total Amount and Shipping
                Row(
                  children: [
                    Icon(Icons.payment, color: Colors.green),
                    SizedBox(width: 5),
                    Text(
                      'Total Amount: PKR ${order['totalAmount']}',
                      style: TextStyle(fontSize: getFont(16)),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.redAccent),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Shipping: ${order['shippingAddress']}',
                        style: TextStyle(fontSize: getFont(16)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.payment, color: Colors.blue),
                    SizedBox(width: 5),
                    Text(
                      'Payment: ${order['paymentMethod']}',
                      style: TextStyle(fontSize: getFont(16)),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.orange),
                    SizedBox(width: 5),
                    Text(
                      'Order Date: ${order['orderDate'].toDate()}',
                      style: TextStyle(fontSize: getFont(16)),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // Action Buttons
                // Action Buttons
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: status == 'Pending'
                          ? MyColors.primaryColor
                          : Colors.blue, // Different color for feedback
                      shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(
                          vertical: getHeight(10), horizontal: getWidth(20)),
                    ),
                    icon: Icon(
                      status == 'Pending'
                          ? Icons.cancel
                          : Icons.feedback, // Feedback icon for completed orders
                      color: Colors.white,
                    ),
                    label: Text(
                      status == 'Pending' ? 'Cancel Order' : 'Give Feedback',
                      style:
                      TextStyle(fontSize: getFont(16), color: Colors.white),
                    ),
                    onPressed: () async {
                      if (status == 'Pending') {
                        // Cancel Order Logic
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(orders[index].id)
                            .update({'status': 'Cancelled'});

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Order Cancelled')),
                        );
                      } else {
                        // Open the feedback dialog
                        _showFeedbackDialog(context, orders[index].id);
                      }
                    },
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }


  // void _showFeedbackDialog(BuildContext context, String orderId) {
  //   final TextEditingController feedbackController = TextEditingController();
  //   int selectedRating = 0; // Variable to store the selected rating
  //
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //         title: Text('Give Feedback'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Rating Selector
  //             Text(
  //               'Rate your experience:',
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //             ),
  //             SizedBox(height: 10),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: List.generate(4, (index) {
  //                 return IconButton(
  //                   onPressed: () {
  //                     selectedRating = index + 1; // Update the rating
  //                     Navigator.pop(context); // Close the dialog to refresh
  //                     _showFeedbackDialog(context, orderId); // Reopen the dialog
  //                   },
  //                   icon: Icon(
  //                     index < selectedRating
  //                         ? Icons.star
  //                         : Icons.star_border, // Highlight stars based on selection
  //                     color: Colors.amber,
  //                     size: getHeight(24),
  //                   ),
  //                 );
  //               }),
  //             ),
  //             SizedBox(height: 20),
  //
  //             // Feedback Input Field
  //             TextField(
  //               controller: feedbackController,
  //               maxLines: 3,
  //               decoration: InputDecoration(
  //                 hintText: 'Write your feedback here...',
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               final feedback = feedbackController.text.trim();
  //
  //               if (selectedRating == 0) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text('Please select a star rating.')),
  //                 );
  //                 return;
  //               }
  //
  //               if (feedback.isNotEmpty) {
  //                 final user = FirebaseAuth.instance.currentUser;
  //
  //                 if (user == null) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(content: Text('User not logged in.')),
  //                   );
  //                   return;
  //                 }
  //
  //                 // Fetch the customer's name from Firestore
  //                 DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(user.uid)
  //                     .get();
  //
  //                 Map<String, dynamic>? userData =
  //                 userDoc.data() as Map<String, dynamic>?; // Safely cast to Map
  //                 String customerName = userData?['name'] ?? 'Unknown Customer';
  //
  //                 // Save feedback to Firestore
  //                 await FirebaseFirestore.instance
  //                     .collection('orders')
  //                     .doc(orderId)
  //                     .update({
  //                   'feedback': {
  //                     'customerName': customerName,
  //                     'rating': selectedRating,
  //                     'comment': feedback,
  //                   }
  //                 });
  //
  //                 Navigator.pop(context); // Close the dialog
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text('Thank you for your feedback!')),
  //                 );
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(content: Text('Feedback cannot be empty.')),
  //                 );
  //               }
  //             },
  //             child: Text('Submit'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  void _showFeedbackDialog(BuildContext context, String orderId) {
    final TextEditingController feedbackController = TextEditingController();
    int selectedRating = 0; // Variable to store the selected rating

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text('Give Feedback'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Rating Selector
                  Text(
                    'Rate your experience:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) { // Changed to 5 stars
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1; // Update the rating
                          });
                        },
                        icon: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border, // Highlight stars based on selection
                          color: Colors.amber,
                          size: 24, // Adjusted size for clarity
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),

                  // Feedback Input Field
                  TextField(
                    controller: feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Write your feedback here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final feedback = feedbackController.text.trim();

                    if (selectedRating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a star rating.')),
                      );
                      return;
                    }

                    if (feedback.isNotEmpty) {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User not logged in.')),
                        );
                        return;
                      }

                      // Fetch the customer's name from Firestore
                      DocumentSnapshot userDoc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get();

                      Map<String, dynamic>? userData =
                      userDoc.data() as Map<String, dynamic>?; // Safely cast to Map
                      String customerName = userData?['name'] ?? 'Unknown Customer';

                      // Save feedback to Firestore
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .update({
                        'feedback': {
                          'customerName': customerName,
                          'rating': selectedRating,
                          'comment': feedback,
                        }
                      });

                      Navigator.pop(context); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Thank you for your feedback!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Feedback cannot be empty.')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }







}
