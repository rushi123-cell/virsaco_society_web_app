import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/utils/responsive.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/dynamic_background.dart';
import '../../../routes/app_pages.dart';
import 'signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DynamicBackground(
        child: Responsive(
          mobile: _buildSignupForm(context, isMobile: true),
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
                        const Icon(Icons.person_add_outlined, size: 100, color: Colors.white),
                        const SizedBox(height: 20),
                        Text(
                          'Join Virsaco Society',
                          style: GoogleFonts.outfit(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Create an account to get started',
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
                child: _buildSignupForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context, {bool isMobile = false}) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64),
        constraints: const BoxConstraints(maxWidth: 550),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Create Account',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: controller.nameController,
                hintText: 'Enter your full name',
                labelText: 'Full Name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: controller.emailController,
                hintText: 'Enter your email',
                labelText: 'Email Address',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: controller.passwordController,
                hintText: 'Create a password',
                labelText: 'Password',
                isPassword: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 32),
              Obx(() => CustomButton(
                text: 'Register Now',
                isLoading: controller.isLoading.value,
                onPressed: controller.signup,
              )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: GoogleFonts.inter(color: AppColors.grey),
                  ),
                  TextButton(
                    onPressed: () => Get.offNamed(Routes.LOGIN),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
