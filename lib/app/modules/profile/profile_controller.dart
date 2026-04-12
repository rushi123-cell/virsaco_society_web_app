import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final isEditing = false.obs;
  final isLoading = false.obs;

  // Form Controllers
  final nameController = TextEditingController(text: 'Rushita Ramani');
  final emailController = TextEditingController(text: 'rushita.admin@virsaco.com');
  final phoneController = TextEditingController(text: '+91 98765 43210');
  final roleController = TextEditingController(text: 'Administrator');

  @override
  void onInit() {
    super.onInit();
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      // Logic for canceling edits could go here (resetting controllers)
    }
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    isEditing.value = false;
    
    Get.snackbar(
      "Success",
      "Profile updated successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    roleController.dispose();
    super.onClose();
  }
}
