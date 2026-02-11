// import 'package:flutter/material.dart';
//
// import '../widget/add_to_cart.dart';
//
// class CartScreen extends StatefulWidget {
//   @override
//   _CartScreenState createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   // Use the cartItems list from AddToCartScreen
//   List<Map<String, dynamic>> cartItems = AddToCartScreen.cartItems;
//
//   @override
//   Widget build(BuildContext context) {
//     double total = 0;
//     cartItems.forEach((item) {
//       total += double.parse(item['price']!.substring(1)) * item['quantity'];
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFE0342F),
//         title: Text('Your Cart', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Cart items list
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartItems.length,
//                 itemBuilder: (context, index) {
//                   var item = cartItems[index];
//                   return Card(
//                     margin: EdgeInsets.only(bottom: 15),
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Row(
//                         children: [
//                           Image.network(
//                             item['image'],
//                             width: 80,
//                             height: 80,
//                             fit: BoxFit.cover,
//                           ),
//                           SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item['title'],
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   'Price: ${item['price']}',
//                                   style: TextStyle(color: Colors.grey),
//                                 ),
//                                 Row(
//                                   children: [
//                                     IconButton(
//                                       icon: Icon(Icons.remove),
//                                       onPressed: () {
//                                         setState(() {
//                                           if (item['quantity'] > 1) {
//                                             item['quantity']--;
//                                           }
//                                         });
//                                       },
//                                     ),
//                                     Text('${item['quantity']}'),
//                                     IconButton(
//                                       icon: Icon(Icons.add),
//                                       onPressed: () {
//                                         setState(() {
//                                           item['quantity']++;
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             // Total Price
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: Text(
//                 'Total: \$${total.toStringAsFixed(2)}',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             // Proceed to Checkout Button
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFE0342F),
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   elevation: 5,
//                 ),
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Proceeding to Checkout')),
//                   );
//                 },
//                 child: Text(
//                   'Proceed to Checkout',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
