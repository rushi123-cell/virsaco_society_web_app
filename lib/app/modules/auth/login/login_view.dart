import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/utils/responsive.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/dynamic_background.dart';
import '../../../routes/app_pages.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DynamicBackground(
        child: Responsive(
          mobile: _buildLoginForm(context, isMobile: true),
          desktop: Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.science_outlined, size: 100, color: Colors.white),
                        const SizedBox(height: 20),
                        Text(
                          'VIRSACO SOCIETY',
                          style: GoogleFonts.outfit(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Research | Innovation | Progress',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: _buildLoginForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, {bool isMobile = false}) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64),
        constraints: const BoxConstraints(maxWidth: 550),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile) ...[
              const Center(
                child: Icon(Icons.science_outlined, size: 64, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              'Welcome Back',
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please enter your details to sign in.',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 48),
            CustomTextField(
              controller: controller.emailController,
              hintText: 'Enter your email',
              labelText: 'Email Address',
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 24),
            Obx(() => CustomTextField(
                  controller: controller.passwordController,
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  isPassword: !controller.isPasswordVisible.value,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                )),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Obx(() => CustomButton(
                  text: 'Sign In',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.login,
                )),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: GoogleFonts.inter(color: AppColors.grey),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.SIGNUP),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
