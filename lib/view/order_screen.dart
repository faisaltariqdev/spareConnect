import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:spare_connect/utils/size_config.dart';
import 'package:spare_connect/view/homepage/homepage.dart';
import 'package:spare_connect/widget/my_colors.dart';

class OrderScreen extends StatefulWidget {
  final String orderId;

  OrderScreen({required this.orderId});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Map<String, dynamic>? orderData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .get();

      if (doc.exists) {
        setState(() {
          orderData = doc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String value}) {
    return Card(
      
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent, size: 30),
        title: Text(
          title,
          style: TextStyle(fontSize: getFont(16), fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: getFont(14), fontWeight: FontWeight.w500, color: Colors.black54),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: MyColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.redAccent,
        ),
      )
          : orderData == null
          ? Center(
        child: Text(
          'Order not found',
          style: TextStyle(fontSize: getFont(18), color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'Your Order Summary',
                style: TextStyle(
                  fontSize: getFont(20),
                  fontWeight: FontWeight.bold,
                  color: MyColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: getHeight(20)),

            // Order Details Cards
            _buildInfoCard(
              icon: Icons.shopping_bag_outlined,
              title: 'Product Name',
              value: orderData!['productName'] ?? 'N/A',
            ),
            SizedBox(height: getHeight(8)),
            _buildInfoCard(
              icon: Icons.production_quantity_limits,
              title: 'Quantity',
              value: '${orderData!['quantity']}',
            ),
            SizedBox(height: getHeight(8)),
            _buildInfoCard(
              icon: Icons.attach_money_rounded,
              title: 'Total Price',
              value: 'PKR ${orderData!['totalPrice'].toStringAsFixed(2)}',
            ),
            SizedBox(height: getHeight(8)),
            _buildInfoCard(
              icon: Icons.payment_rounded,
              title: 'Payment Method',
              value: orderData!['paymentMethod'] ?? 'N/A',
            ),
            SizedBox(height: getHeight(8)),
            _buildInfoCard(
              icon: Icons.location_on_rounded,
              title: 'Shipping Address',
              value: orderData!['shippingAddress'] ?? 'N/A',
            ),
            SizedBox(height: getHeight(8)),
            _buildInfoCard(
              icon: Icons.check_circle_outline,
              title: 'Order Status',
              value: orderData!['status'] ?? 'Pending',
            ),

            Spacer(),

            // Footer Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Get.to(()=>HomePage());
                },
                icon: Icon(Icons.navigate_next_sharp, color: Colors.white),
                label: Text(
                  'Go to Home Screen',
                  style: TextStyle(fontSize: getFont(16), color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
