import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spare_connect/utils/size_config.dart';
import 'package:spare_connect/view/seller/add_product_screen.dart';
import '../../controllers/seller_conntrollers/manage_product_controller.dart';

class ManageProductScreen extends StatelessWidget {
  final ManageProductController controller = Get.put(ManageProductController());
  final Color primaryColor = Color(0xFFE0342F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Products',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor, // Use the custom primary color
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Obx(
            () => controller.productList.isEmpty
            ? Center(
          child: Text(
            'No products added yet!',
            style: TextStyle(fontSize: getFont(18), color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: controller.productList.length,
              itemBuilder: (context, index) {
                final product = controller.productList[index];
                final images = product['images'] ?? []; // List of image URLs
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        // Product Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: images.isNotEmpty
                              ? Image.network(
                            images[0], // Display the first image
                            height: getHeight(100),
                            width: getWidth(100),
                            fit: BoxFit.cover,
                          )
                              : Container(
                            height: getHeight(100),
                            width: getWidth(100),
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),

                        // Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontSize: getFont(16),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: getHeight(6)),
                              Text(
                                'Category: ${product['category']}',
                                style: TextStyle(fontSize: getFont(14), color: Colors.black54),
                              ),
                              Text(
                                'Price: PKR${product['price']}',
                                style: TextStyle(fontSize: getFont(14), color: Colors.black54),
                              ),
                              Text(
                                'Quantity: ${product['quantity']}',
                                style: TextStyle(fontSize: getFont(14), color: Colors.black54),
                              ),
                              Text(
                                'Condition: ${product['condition']}',
                                style: TextStyle(fontSize: getFont(14), color: Colors.black54),
                              ),
                            ],
                          ),
                        ),

                        // Action Buttons
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => controller.editProduct(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                            SizedBox(height: getHeight(8)),
                            ElevatedButton(
                              onPressed: () => controller.deleteProduct(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },

            ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => Get.to(()=>AddProductScreen()),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
