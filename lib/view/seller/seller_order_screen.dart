import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/seller_conntrollers/seller_order_controller.dart';

class SellerOrderScreen extends StatelessWidget {
  final OrderController controller = Get.put(OrderController());

  final Color primaryColor = Color(0xFFE0342F);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          title: Text('Orders', style: TextStyle(color: Colors.white)),
          backgroundColor: primaryColor,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Delivered'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => _buildOrderList(controller.pendingOrders, 'Pending')),
            Obx(() => _buildOrderList(controller.deliveredOrders, 'Completed')),
            Obx(() => _buildOrderList(controller.cancelledOrders, 'Cancelled')),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders, String status) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No $status orders found!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, status);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, String status) {
    final List products = order['products'] ?? [];

    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ID: ${order['orderId'].substring(0, 4)}',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent), // Transparent border
                    borderRadius: BorderRadius.circular(20),       // Rounded edges for the Chip
                    color: _getStatusColor(status),               // Background color for the Chip
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                    child: Text(
                      status,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 10),

            // Product List
            Text('Products:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ...products.map<Widget>((product) {
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '- ${product['productName']} (x${product['quantity']}) - PKR ${product['price']}',
                  style: TextStyle(fontSize: 14),
                ),
              );
            }).toList(),

            SizedBox(height: 10),

            // Payment Method
            Row(
              children: [
                Icon(Icons.payment, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Payment: ${order['paymentMethod'] ?? "N/A"}',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 5),

            // Shipping Address
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Shipping Address: ${order['shippingAddress'] ?? "N/A"}',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // Action Button for Pending Orders
            if (status == 'Pending')
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    controller.updateOrderStatus(order['orderId'], 'Completed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Mark as Delivered', style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper function to get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
