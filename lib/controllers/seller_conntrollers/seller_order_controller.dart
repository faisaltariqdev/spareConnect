//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// class OrderController extends GetxController {
//   var pendingOrders = <Map<String, dynamic>>[].obs;
//   var deliveredOrders = <Map<String, dynamic>>[].obs;
//   var cancelledOrders = <Map<String, dynamic>>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchOrders();
//   }
//
//   void fetchOrders() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//
//     if (userId == null) {
//       print("User is not logged in");
//       return;
//     }
//
//     FirebaseFirestore.instance
//         .collection('orders')
//         .snapshots()
//         .listen((snapshot) {
//       // Process orders that contain the sellerId in their products
//       List<Map<String, dynamic>> fetchedOrders = snapshot.docs
//           .map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data['orderId'] = doc.id; // Set the document ID as orderId
//         return data;
//       })
//           .where((order) => _containsSellerId(order, userId)) // Filter by sellerId
//           .toList();
//
//       // Update observable lists with new data
//       pendingOrders.assignAll(
//           fetchedOrders.where((order) => order['status'] == 'Pending').toList());
//       deliveredOrders.assignAll(
//           fetchedOrders.where((order) => order['status'] == 'Completed').toList());
//       cancelledOrders.assignAll(
//           fetchedOrders.where((order) => order['status'] == 'Cancelled').toList());
//
//       // Log the updates
//       print("Orders updated in real-time: Pending: ${pendingOrders.length}, Delivered: ${deliveredOrders.length}, Cancelled: ${cancelledOrders.length}");
//     });
//   }
//
//   bool _containsSellerId(Map<String, dynamic> order, String sellerId) {
//     List products = order['products'] ?? [];
//     return products.any((product) => product['sellerId'] == sellerId);
//   }
//
//
//
//   void updateOrderStatus(String orderId, String newStatus) async {
//     try {
//       // Update Firestore
//       await FirebaseFirestore.instance
//           .collection('orders')
//           .doc(orderId)
//           .update({'status': newStatus});
//
//       // Find the order in the current list and update local state
//       Map<String, dynamic>? updatedOrder;
//
//       // Check each list to find the order
//       if (pendingOrders.any((order) => order['orderId'] == orderId)) {
//         updatedOrder = pendingOrders.firstWhere((order) => order['orderId'] == orderId);
//         pendingOrders.removeWhere((order) => order['orderId'] == orderId);
//       } else if (deliveredOrders.any((order) => order['orderId'] == orderId)) {
//         updatedOrder = deliveredOrders.firstWhere((order) => order['orderId'] == orderId);
//         deliveredOrders.removeWhere((order) => order['orderId'] == orderId);
//       } else if (cancelledOrders.any((order) => order['orderId'] == orderId)) {
//         updatedOrder = cancelledOrders.firstWhere((order) => order['orderId'] == orderId);
//         cancelledOrders.removeWhere((order) => order['orderId'] == orderId);
//       }
//
//       // Update the status and move to the correct list
//       if (updatedOrder != null) {
//         updatedOrder['status'] = newStatus;
//
//         if (newStatus == 'Completed') {
//           deliveredOrders.add(updatedOrder);
//         } else if (newStatus == 'Cancelled') {
//           cancelledOrders.add(updatedOrder);
//         }
//       }
//
//       // Notify the UI to refresh the state
//       pendingOrders.refresh();
//       deliveredOrders.refresh();
//       cancelledOrders.refresh();
//
//       print("Order status successfully updated to: $newStatus");
//     } catch (e) {
//       print("Error updating order status: $e");
//     }
//   }
//
//
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var pendingOrders = <Map<String, dynamic>>[].obs;
  var deliveredOrders = <Map<String, dynamic>>[].obs;
  var cancelledOrders = <Map<String, dynamic>>[].obs;

  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() {
    if (userId.isEmpty) {
      print("User not logged in.");
      return;
    }

    // Listen to real-time updates
    FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .listen((snapshot) {
      // Reset the lists
      pendingOrders.clear();
      deliveredOrders.clear();
      cancelledOrders.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final List products = data['products'] ?? [];

        // Check if the order contains this seller's products
        final sellerProducts = products.where((product) {
          return product['sellerId'] == userId;
        }).toList();

        if (sellerProducts.isNotEmpty) {
          // Add orderId and filtered products to the data
          data['orderId'] = doc.id;
          data['products'] = sellerProducts;

          // Categorize the orders by status
          if (data['status'] == 'Pending') {
            pendingOrders.add(data);
          } else if (data['status'] == 'Completed') {
            deliveredOrders.add(data);
          } else if (data['status'] == 'Cancelled') {
            cancelledOrders.add(data);
          }
        }
      }

      // Notify listeners
      pendingOrders.refresh();
      deliveredOrders.refresh();
      cancelledOrders.refresh();
    });
  }

  // Function to update the order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});
      print("Order status successfully updated to: $newStatus");
    } catch (e) {
      print("Error updating order status: $e");
    }
  }
}
