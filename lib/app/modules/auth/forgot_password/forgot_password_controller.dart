import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/custom_toast.dart';
import '../../../services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;

  final _authService = Get.find<AuthService>();

  bool _isValidEmail(String email) {
    return GetUtils.isEmail(email);
  }

  void sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      CustomToast.showError('Error', 'Please enter your email');
      return;
    }

    if (!_isValidEmail(email)) {
      CustomToast.showError('Invalid Email', 'Please enter a valid email address');
      return;
    }

    isLoading.value = true;
    try {
      await _authService.sendPasswordResetEmail(emailController.text.trim());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
