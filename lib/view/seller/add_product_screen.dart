import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spare_connect/utils/size_config.dart';
import 'package:spare_connect/widget/custom_button.dart';
import 'package:spare_connect/widget/my_colors.dart';

import '../../controllers/seller_conntrollers/add_product_controller.dart';

class AddProductScreen extends StatelessWidget {
  final AddProductController controller = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name
            TextField(
              controller: controller.productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: controller.categories.first,
              items: controller.categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                controller.categoryController.text = value!;
              },
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Price
            TextField(
              controller: controller.priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Quantity
            TextField(
              controller: controller.quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Condition Dropdown
            DropdownButtonFormField<String>(
              value: controller.condition.value,
              items: ['New', 'Used'].map((condition) {
                return DropdownMenuItem<String>(
                  value: condition,
                  child: Text(condition),
                );
              }).toList(),
              onChanged: (value) {
                controller.condition.value = value!;
              },
              decoration: InputDecoration(
                labelText: 'Condition',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Stock Dropdown
            DropdownButtonFormField<String>(
              value: controller.stockStatus.value,
              items: ['In Stock', 'Out of Stock'].map((stock) {
                return DropdownMenuItem<String>(
                  value: stock,
                  child: Text(stock),
                );
              }).toList(),
              onChanged: (value) {
                controller.stockStatus.value = value!;
              },
              decoration: InputDecoration(
                labelText: 'Stock Status',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Delivery Days
            TextField(
              controller: controller.deliveryDaysController,
              decoration: InputDecoration(
                labelText: 'Delivery Days',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Warranty
            TextField(
              controller: controller.warrantyController,
              decoration: InputDecoration(
                labelText: 'Warranty',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Seller Location
            TextField(
              controller: controller.sellerLocationController,
              decoration: InputDecoration(
                labelText: 'Seller Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Seller Contact
            TextField(
              controller: controller.sellerContactController,
              decoration: InputDecoration(
                labelText: 'Seller Contact',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Description
            TextField(
              controller: controller.descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: getHeight(16)),

            // Image Picker Button
            CustomButton(
              color: MyColors.primaryColor,
              borderColor: MyColors.primaryColor,
              text: 'Pick Images',
              onPressed: () async {
                await controller.pickImages();
              },
            ),
            SizedBox(height: getHeight(16)),

            // Add Product Button
            CustomButton(
              color: MyColors.primaryColor,
              borderColor: MyColors.primaryColor,
              text: 'Add Product',
              onPressed: () {
                controller.submitProduct();
              },
            ),
          ],
        ),
      ),
    );
  }
}
