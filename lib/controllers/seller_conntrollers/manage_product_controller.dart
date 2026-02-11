import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:spare_connect/utils/size_config.dart';

class ManageProductController extends GetxController {
  // Reactive Product List
  var productList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    print("Mannage Product Controller Onit");
    loadProducts(); // Load products on initialization
  }

  void loadProducts() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        print("User is not authenticated");
        return;
      }

      print("Fetching products for user: $userId");

      var querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No products found for this user.");
      }

      var fetchedProducts = querySnapshot.docs.map((doc) {
        return {
          'name': doc['product_name'] ?? 'No Name',
          'category': doc['category'] ?? 'No Category',
          'price': doc['price'] ?? 0.0,
          'quantity': doc['quantity'] ?? 0,
          'condition': doc['condition'] ?? 'Unknown',
          'images': doc.data().containsKey('images') && doc['images'] != null
              ? List<String>.from(doc['images'])
              : [], // Default to empty list if 'images' doesn't exist
          'productId': doc.id,
        };
      }).toList();

      productList.assignAll(fetchedProducts);
      print("Fetched products: $fetchedProducts");
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  // Function to delete a product
  void deleteProduct(int index) async {
    try {
      // Get the product's ID
      String productId = productList[index]['productId'];

      // Delete product from Firestore
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();

      // Remove the product from the list locally
      productList.removeAt(index);

      // Show success message
      Get.snackbar(
        'Success',
        'Product deleted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error deleting product: $e");
      Get.snackbar(
        'Error',
        'Failed to delete product.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  // Function to edit a product
  void editProduct(int index) {
    // Get the product data to pre-fill the dialog fields
    var product = productList[index];

    // Show the edit dialog
    Get.dialog(
      EditProductDialog(
        product: product,
        onUpdate: (updatedProduct) async {
          // Get the product ID
          String productId = product['productId'];

          try {
            // Update the product in Firestore
            await FirebaseFirestore.instance.collection('products').doc(productId).update({
              'product_name': updatedProduct['name'],
              'category': updatedProduct['category'],
              'price': updatedProduct['price'],
              'quantity': updatedProduct['quantity'],
              'condition': updatedProduct['condition'],
            });

            // Update the product list locally
            productList[index] = updatedProduct;

            // Close the dialog
            Get.back();

            // Show success message
            Get.snackbar(
              'Success',
              'Product updated successfully!',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } catch (e) {
            print("Error updating product: $e");
            Get.snackbar(
              'Error',
              'Failed to update product.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
      ),
    );
  }


  // Function to add a new product
  void addNewProduct() {
    Get.toNamed('/addProduct');
  }
}




class EditProductDialog extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onUpdate;

  EditProductDialog({required this.product, required this.onUpdate});

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late TextEditingController conditionController;

  String stockStatus = 'In Stock'; // Dropdown default value
  File? selectedImage; // Store selected image
  bool isUploading = false; // Track upload progress

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name']);
    categoryController = TextEditingController(text: widget.product['category']);
    priceController = TextEditingController(text: widget.product['price'].toString());
    quantityController = TextEditingController(text: widget.product['quantity'].toString());
    conditionController = TextEditingController(text: widget.product['condition']);
    stockStatus = widget.product['stock'] ?? 'In Stock'; // Initialize dropdown
  }

  // Pick an image using ImagePicker
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  // Upload image to Cloudinary
  Future<String> uploadImageToCloudinary(File imageFile) async {
    const String cloudName = "dexb8rrkl"; // Cloudinary cloud name
    const String uploadPreset = "flutter_present"; // Unsigned preset

    final Uri uploadUrl =
    Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest('POST', uploadUrl)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = json.decode(await response.stream.bytesToString());
      return responseData['secure_url'];
    } else {
      throw Exception("Failed to upload image to Cloudinary");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Product',
                style: TextStyle(fontSize: getFont(20), fontWeight: FontWeight.bold),
              ),
              SizedBox(height: getHeight(20)),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              TextField(
                controller: conditionController,
                decoration: InputDecoration(labelText: 'Condition'),
              ),
              SizedBox(height: getHeight(10)),

              // Dropdown for Stock Status
              Text(
                "Stock Status:",
                style: TextStyle(fontSize: getFont(16), fontWeight: FontWeight.bold),
              ),
              SizedBox(height: getHeight(5)),
              DropdownButtonFormField<String>(
                value: stockStatus,
                items: ['In Stock', 'Out of Stock']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    stockStatus = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
              SizedBox(height: getHeight(20)),

              // Image picker section
              Text(
                "Update Image:",
                style: TextStyle(fontSize: getFont(16), fontWeight: FontWeight.bold),
              ),
              SizedBox(height: getHeight(10)),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: getHeight(120),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: selectedImage != null
                      ? Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                  )
                      : Center(
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: getHeight(20)),

              if (isUploading) Center(child: CircularProgressIndicator()),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isUploading = true;
                      });

                      // Upload image if a new one was selected
                      String imageUrl = "";
                      if (selectedImage != null) {
                        try {
                          imageUrl = await uploadImageToCloudinary(selectedImage!);
                          print("Uploaded Image URL: $imageUrl");
                        } catch (e) {
                          print("Error uploading image: $e");
                          setState(() {
                            isUploading = false;
                          });
                          return;
                        }
                      }

                      // Prepare updated product data
                      var updatedProduct = {
                        'productId': widget.product['productId'],
                        'name': nameController.text,
                        'category': categoryController.text,
                        'price': double.tryParse(priceController.text) ?? 0.0,
                        'quantity': int.tryParse(quantityController.text) ?? 0,
                        'condition': conditionController.text,
                        'stock': stockStatus,
                        'images': imageUrl.isNotEmpty
                            ? [imageUrl] // Replace with the new image URL
                            : widget.product['images'], // Keep existing images
                      };

                      widget.onUpdate(updatedProduct);
                    },
                    child: Text('Update'),
                  ),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}





