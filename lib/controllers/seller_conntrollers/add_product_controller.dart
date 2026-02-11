import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/firebase_service.dart';
import '../../view/seller/seller_dashboard.dart';

class AddProductController extends GetxController {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deliveryDaysController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final TextEditingController sellerLocationController = TextEditingController();
  final TextEditingController sellerContactController = TextEditingController();

  var condition = 'New'.obs;
  var stockStatus = 'In Stock'.obs;

  var categories = ['Engine Parts', 'Transmission Parts', 'Body Parts', 'Fuel System'].obs;

  RxList<File> selectedImages = RxList<File>([]);

  final FirebaseService _firebaseService = FirebaseService();

  String sellerName = '';
  String sellerEmail = '';

  @override
  void onInit() {
    super.onInit();
    fetchSellerDetails();
  }

  Future<void> fetchSellerDetails() async {
    try {
      // Fetch current user details
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        sellerEmail = user.email ?? 'No Email';
        var userData = await _firebaseService.getUserDetails(user.uid);
        sellerName = userData['name'] ?? 'Unknown Seller';
      }
    } catch (e) {
      print('Error fetching seller details: $e');
    }
  }

  // Pick images
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      selectedImages.value = images.map((e) => File(e.path)).toList();
    }
  }

  // Submit product
  Future<void> submitProduct() async {
    try {
      String productName = productNameController.text.trim();
      String category = categoryController.text.trim();
      double price = double.tryParse(priceController.text.trim()) ?? 0.0;
      int quantity = int.tryParse(quantityController.text.trim()) ?? 0;
      String condition = this.condition.value;
      String stock = stockStatus.value;
      String description = descriptionController.text.trim();
      String deliveryDays = deliveryDaysController.text.trim();
      String warranty = warrantyController.text.trim();
      String sellerLocation = sellerLocationController.text.trim();
      String sellerContact = sellerContactController.text.trim();

      if (productName.isEmpty || price <= 0 || quantity <= 0) {
        throw Exception("Please fill in all required fields.");
      }

      // Upload images
      List<String> imageUrls = [];
      for (var image in selectedImages) {
        String imageUrl = await _firebaseService.uploadImage(image);
        imageUrls.add(imageUrl);
      }
      // Get current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Add product with seller details
      await _firebaseService.addProduct(
        productName: productName,
        category: category,
        price: price,
        quantity: quantity,
        condition: condition,
        stock: stock,
        description: description,
        deliveryDays: deliveryDays,
        warranty: warranty,
        sellerLocation: sellerLocation,
        sellerContact: sellerContact,
        sellerName: sellerName, // Seller's name
        sellerEmail: sellerEmail, // Seller's email
        imageUrls: imageUrls,
        userId: userId, // Pass the current user's ID
      );

      Get.snackbar("Success", "Product added successfully!");
      Get.off(() => SellerDashboardScreen());
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", e.toString());
    }
  }
}
