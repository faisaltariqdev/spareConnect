import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SellerDashboardController extends GetxController {
  var totalSales = '0'.obs; // Initialize total sales
  var listedProducts = 0.obs; // Initialize listed products count
  var pendingOrders = 0.obs; // Initialize pending orders count
  var deliveredOrders = 0.obs; // Initialize delivered orders count

  // Fetch live updates for dashboard metrics
  // void fetchDashboardMetrics() {
  //   final userId = FirebaseAuth.instance.currentUser?.uid;
  //
  //   if (userId == null) return;
  //
  //   // Fetch Total Sales
  //   FirebaseFirestore.instance
  //       .collection('orders')
  //       .where('sellerId', isEqualTo: userId)
  //       .where('status', isEqualTo: 'Completed')
  //       .snapshots()
  //       .listen((snapshot) {
  //     double total = snapshot.docs.fold(0, (sum, doc) {
  //       return sum + (doc['totalPrice'] ?? 0.0);
  //     });
  //     totalSales.value = '${total.toStringAsFixed(2)}';
  //   });
  //
  //   // Fetch Listed Products
  //   FirebaseFirestore.instance
  //       .collection('products')
  //       .where('userId', isEqualTo: userId)
  //       .snapshots()
  //       .listen((snapshot) {
  //     listedProducts.value = snapshot.docs.length;
  //   });
  //
  //   // Fetch Pending Orders
  //   FirebaseFirestore.instance
  //       .collection('orders')
  //       .where('sellerId', isEqualTo: userId)
  //       .where('status', isEqualTo: 'Pending')
  //       .snapshots()
  //       .listen((snapshot) {
  //     pendingOrders.value = snapshot.docs.length;
  //   });
  //
  //   // Fetch Delivered Orders
  //   FirebaseFirestore.instance
  //       .collection('orders')
  //       .where('sellerId', isEqualTo: userId)
  //       .where('status', isEqualTo: 'Completed')
  //       .snapshots()
  //       .listen((snapshot) {
  //     deliveredOrders.value = snapshot.docs.length;
  //   });
  // }
  void fetchDashboardMetrics() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print("UserID Seller: $userId");

    if (userId == null) return;

    FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .listen((snapshot) {
      double totalSalesAmount = 0.0;
      int pendingCount = 0;
      int completedCount = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? '';
        final totalAmount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
        final products = data['products'] as List<dynamic>? ?? [];

        // Check if the sellerId matches in the products array
        final sellerProducts = products.where((product) {
          return product['sellerId'] == userId;
        }).toList();

        if (sellerProducts.isNotEmpty) {
          // Count Pending Orders
          if (status == 'Pending') {
            pendingCount++;
          }

          // Count Completed Orders and Add to Total Sales
          if (status == 'Completed') {
            completedCount++;
            totalSalesAmount += totalAmount; // Add the total amount
          }
        }
      }

      // Update observables
      pendingOrders.value = pendingCount;
      deliveredOrders.value = completedCount;
      totalSales.value = '${totalSalesAmount.toStringAsFixed(2)}';

      // Debug Prints
      print("Total Sales Amount: $totalSalesAmount");
      print("Pending Orders: $pendingCount");
      print("Completed Orders: $completedCount");
    });

    FirebaseFirestore.instance
        .collection('products')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      listedProducts.value = snapshot.docs.length;
      print("Listed Products: ${snapshot.docs.length}");
    });
  }




  @override
  void onInit() {
    super.onInit();
    fetchDashboardMetrics(); // Call to start listening to real-time updates
  }
}
