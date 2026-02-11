import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:spare_connect/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

import 'checkout_screenn.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;


  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    // Fetch images or default to placeholders
    List<String> images = List<String>.from(product['images'] ?? [
      'https://via.placeholder.com/300',
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFE0342F),
        title: Text('Product Details', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CarouselSlider(
                items: images.map((img) {
                  return Image.network(
                    img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: getHeight(250),
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  viewportFraction: 0.9,
                ),
              ),
            ),
            SizedBox(height: getHeight(20)),

            // Title and Price with Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    product['name'] ?? 'No Product Name',
                    style: TextStyle(
                        fontSize: getFont(26), fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.green),
                    Text(
                      "PKR${product['price']}" ?? 'No Price',
                      style: TextStyle(
                          fontSize: getFont(22),
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: getHeight(10)),

            // Condition and Quantity with Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.new_releases, color: Colors.orange),
                    SizedBox(width: getWidth(8)),
                    Text(
                      'Condition: ${product['condition'] ?? 'N/A'}',
                      style: TextStyle(fontSize: getFont(18)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.inventory, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Qty: ${product['quantity'] ?? '0'}',
                      style: TextStyle(fontSize: getFont(18)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: getHeight(20)),

            // Description with Icon
            Row(
              children: [
                Icon(Icons.description, color: Colors.grey),
                SizedBox(width: getWidth(8)),
                Text(
                  'Description',
                  style: TextStyle(
                      fontSize: getFont(18), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  product['description'] ?? 'No description available.',
                  style: TextStyle(fontSize: getFont(16), color: Colors.grey[700]),
                ),
              ),
            ),
            SizedBox(height: getHeight(20)),

            // Seller Information with Icons
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.storefront, color: Colors.blueGrey),
                SizedBox(width: getWidth(8)),
                Text(
                  textAlign: TextAlign.start,
                  'Seller Information',
                  style: TextStyle(
                      fontSize: getFont(18), fontWeight: FontWeight.bold),
                ),
                SizedBox(width: getWidth(90),),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap :(){
                            final contact = product['sellerContact'];
                            if (contact != null) {
                              _openWhatsApp(contact);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Seller contact not available')),
                              );
                            }
                          },
                          child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 32.0)),
                      SizedBox(width: getWidth(20),),
                      InkWell(
                          onTap: (){
                            final location = product['sellerLocation'];
                            if (location != null) {
                              _openGoogleMaps(location);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Seller location not available')),
                              );
                            }
                          },
                          child: FaIcon(FontAwesomeIcons.map, color: Colors.green, size: 32.0)),

                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(8),),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                      spreadRadius: 1),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.black),
                        SizedBox(width: getWidth(8)),
                        Text('Seller: ${product['sellerName'] ?? 'N/A'}'),
                      ],
                    ),
                    SizedBox(height: getHeight(8),),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.green),
                        SizedBox(width: getWidth(8)),
                        Text('Contact: ${product['sellerContact'] ?? 'N/A'}'),
                      ],
                    ),
                    SizedBox(height: getHeight(8),),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: getWidth(8)),
                        Text('Location: ${product['sellerLocation'] ?? 'N/A'}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: getHeight(20)),



            // Delivery Days and Stock with Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_shipping, color: Colors.orange),
                    SizedBox(width: getWidth(8)),
                    Text(
                      'Delivery Days: ${product['deliveryDays'] ?? 'N/A'}',
                      style: TextStyle(fontSize: getFont(16)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: product['stock'] == 'In Stock'
                          ? Colors.green
                          : Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Stock: ${product['stock'] ?? 'Out of Stock'}',
                      style: TextStyle(fontSize: getFont(16)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: getHeight(20)),

            // Warranty with Icon
            Row(
              children: [
                Icon(Icons.verified, color: Colors.purple),
                SizedBox(width: getWidth(8)),
                Text(
                  'Warranty: ${product['warranty'] ?? 'No Warranty'}'' Days',
                  style: TextStyle(fontSize: getFont(16)),
                ),
              ],
            ),
            SizedBox(height: getHeight(20)),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE0342F),
                    ),
                    // onPressed: () {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text('Added to Cart!')));
                    //  // Get.to(()=>CheckoutScreen());
                    // },
                    onPressed: () async {
                      try {
                        // Fetch the current logged-in user
                        final User? user = FirebaseAuth.instance.currentUser;

                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User not logged in. Please log in first.')),
                          );
                          return;
                        }

                        final String userId = user.uid;

                        // Cart Data
                        final cartData = {
                          'userId': userId, // Add current user's ID
                          'productId': product['productId'],
                          'sellerId': product['sellerId'],
                          'name': product['name'],
                          'price': product['price'],
                          'quantity': _quantity, // User selected quantity
                          'image': (product['images'] as List).isNotEmpty
                              ? product['images'][0]
                              : 'https://via.placeholder.com/150',
                          'addedAt': FieldValue.serverTimestamp(),
                        };

                        // Add to Firebase
                        await FirebaseFirestore.instance.collection('carts').add(cartData);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Product added to cart!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add product to cart!')),
                        );
                        print("Error: $e");
                      }
                    },

                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    label: Text('Add to Cart',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: getWidth(10)),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('Proceeding to Checkout!')));
                      //Get.to(()=>CheckoutScreen());
                      Get.to(() => CheckoutScreen(
                          product: {

                          'sellerId' : product['sellerId'],
                          'productId' : product['productId'],
                          'name': product['name'],
                          'price': product['price'],
                          'quantity': _quantity, // Quantity selected by the user
                          'image': (product['images'] as List).isNotEmpty ? product['images'][0]
                           : 'https://via.placeholder.com/150', // First image or placeholder
                          }));

                    },
                    icon: Icon(Icons.payment, color: Colors.white),
                    label: Text('Buy Now',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // Functions to handle WhatsApp and Google Maps
  void _openWhatsApp(String contact) async {
    // Format the number to include the country code
    String formatWhatsAppNumber(String number) {
      if (number.startsWith('0')) {
        number = number.substring(1); // Remove leading zero
      }
      final countryCode = '92'; // Replace with your actual country code
      return countryCode + number;
    }

    // Format the contact number
    final formattedContact = formatWhatsAppNumber(contact);
    final uri = Uri.parse("https://wa.me/$formattedContact");

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        print('WhatsApp launched successfully.');
      } else {
        print('Could not launch WhatsApp.');
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }



  void _openGoogleMaps(String location) async {
    final query = Uri.encodeComponent(location);
    final uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch Google Maps');
    }
  }
}
