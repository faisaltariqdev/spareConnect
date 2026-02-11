import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spare_connect/utils/size_config.dart';

import '../view/product_detail_screen.dart';

class ProductWidget extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String condition;
  final int quantity;
  final String sellerName;
  final String sellerContact;
  final String sellerLocation;
  final String stock;
  final String description;
  final String deliveryDays;
  final String warranty;
  final String sellerId;
  final String productId;




  const ProductWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.price,
    required this.condition,
    required this.quantity,
    required this.deliveryDays,
    required this.description,
    required this.sellerContact,
    required this.sellerLocation,
    required this.sellerName,
    required this.stock,
    required this.warranty,
    required this.sellerId,
    required this.productId

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () {
        Get.to(() => ProductDetailsScreen(
          product: {
            'name': title,
            'price': price,
            'condition': condition,
            'quantity': quantity,
            'images': [image], // Images remain a list
            'description': description, // Corrected: String
            'sellerName': sellerName,   // Corrected: String
            'sellerContact': sellerContact, // Corrected: String
            'sellerLocation': sellerLocation, // Corrected: String
            'stock': stock, // Corrected: String
            'deliveryDays': deliveryDays, // Corrected: String
            'warranty': warranty, // Corrected: String
            'sellerId' : sellerId,
            'productId' : productId,
          },
        ));
      },



      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  image,
                  height: getHeight(150),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Product Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: getFont(16),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Product Price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'PKR${price}',
                style: TextStyle(
                  fontSize: getFont(14),
                  color: Colors.green,
                ),
              ),
            ),
            // Product Condition and Quantity
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Condition: $condition',
                    style: TextStyle(
                      fontSize: getFont(12),
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    'Qty: $quantity',
                    style: TextStyle(
                      fontSize: getFont(12),
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getHeight(8)),
          ],
        ),
      ),
    );
  }
}
