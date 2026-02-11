import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddToCartScreen extends StatefulWidget {
  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}
// cart_data.dart

class _AddToCartScreenState extends State<AddToCartScreen> {
  final Map<String, String> product = {
    'title': 'Amazing Spare Part',
    'description': 'High quality spare part for your vehicle.',
    'price': '\$199.99',
    'condition': 'New', // Added condition: New or Used
    'deliveryDays': '3-5 business days', // Delivery days added
    'image1': 'https://www.serac-group.com/wp-content/uploads/2019/09/Parts.jpg',
    'image2': 'https://st.depositphotos.com/2551561/2894/i/450/depositphotos_28947513-stock-photo-spare-parts-for-car.jpg',
    'image3': 'https://image.made-in-china.com/318f0j00dQAGOWBPfIUK/7%E6%9C%8810%E6%97%A5wheelhub.mp4.webp',
  };

  int _quantity = 1; // Quantity control

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      product['image1']!,
      product['image2']!,
      product['image3']!,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE0342F),
        title: Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            CarouselSlider(
              items: images.map((img) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        img,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                viewportFraction: 0.9,
              ),
            ),
            SizedBox(height: 20),

            // Product Title
            Text(
              product['title']!,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),

            // Product Description
            Text(
              product['description']!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20),

            // Price
            Text(
              product['price']!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE0342F),
              ),
            ),
            SizedBox(height: 20),

            // Condition (New or Used)
            Text(
              'Condition: ${product['condition']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),

            // Delivery Days
            Text(
              'Delivery Time: ${product['deliveryDays']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Quantity Control
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Quantity: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline, color: Color(0xFFE0342F)),
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      },
                    ),
                    Text(
                      '$_quantity',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: Color(0xFFE0342F)),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Add to Cart Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE0342F),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5, // Adds shadow effect
                ),
                onPressed: () {
                  // Add to cart functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to Cart!')),
                  );
                },
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
