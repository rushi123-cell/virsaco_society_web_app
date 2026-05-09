import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/custom_toast.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  final _authService = Get.find<AuthService>();
  final _firestoreService = Get.find<FirestoreService>();

  bool _isValidEmail(String email) {
    return GetUtils.isEmail(email);
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      CustomToast.showError('Error', 'Please enter email and password');
      return;
    }

    if (!_isValidEmail(email)) {
      CustomToast.showError('Invalid Email', 'Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      CustomToast.showError('Weak Password', 'Password must be at least 6 characters long');
      return;
    }

    isLoading.value = true;
    try {
      final credential = await _authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      
      if (credential != null) {
        // Store/Update user info in Firestore
        final now = DateTime.now().toIso8601String();
        await _firestoreService.setDocument('users', credential.user!.uid, {
          'email': credential.user!.email,
          'lastLogin': now,
          'updatedAt': now,
        });
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
