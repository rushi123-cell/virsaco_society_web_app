import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_controller.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_field.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient Header
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondary, Color(0xFF00334E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Custom Back Button
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.1),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildMainProfileCard(),
                      const SizedBox(height: 32),
                      _buildDetailsGrid(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainProfileCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Container(
          padding: EdgeInsets.all(isMobile ? 24 : 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            children: [
              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  // Animated Profile Picture
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: CircleAvatar(
                          radius: isMobile ? 50 : 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: isMobile ? 46 : 56,
                            backgroundColor: AppColors.primary,
                            child: Icon(Icons.person, size: isMobile ? 50 : 60, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: isMobile ? 0 : 32, height: isMobile ? 24 : 0),
                  Expanded(
                    flex: isMobile ? 0 : 1,
                    child: Column(
                      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Flex(
                          direction: isMobile ? Axis.vertical : Axis.horizontal,
                          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Admin User",
                                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                                  style: GoogleFonts.outfit(
                                    fontSize: isMobile ? 26 : 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                Text(
                                  "Super Administrator",
                                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            if (isMobile) const SizedBox(height: 16),
                            if (!isMobile) const Spacer(),
                            Obx(() => _buildEditToggle()),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildBadge("Active", AppColors.success),
                            _buildBadge("Verified", AppColors.primary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildEditToggle() {
    final isEditing = controller.isEditing.value;
    return GestureDetector(
      onTap: controller.toggleEdit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isEditing ? AppColors.error.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isEditing ? AppColors.error.withOpacity(0.3) : AppColors.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isEditing ? Icons.close : Icons.edit_outlined,
              size: 18,
              color: isEditing ? AppColors.error : AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              isEditing ? "Cancel" : "Edit Profile",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: isEditing ? AppColors.error : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _InfoSection(
                        title: "Personal info",
                        children: [
                          _buildModernField(
                            controller: controller.nameController,
                            label: "Full Name",
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 24),
                          _buildModernField(
                            controller: controller.emailController,
                            label: "Email Address",
                            icon: Icons.alternate_email,
                          ),
                        ],
                      ),
                    ),
                    if (isWide) const SizedBox(width: 32),
                    if (isWide)
                      Expanded(
                        child: _InfoSection(
                          title: "Work info",
                          children: [
                            _buildModernField(
                              controller: controller.roleController,
                              label: "User Role",
                              icon: Icons.work_outline,
                            ),
                            const SizedBox(height: 24),
                            _buildModernField(
                              controller: controller.phoneController,
                              label: "Phone Number",
                              icon: Icons.phone_outlined,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (!isWide) const SizedBox(height: 32),
                if (!isWide)
                  _InfoSection(
                    title: "Work info",
                    children: [
                      _buildModernField(
                        controller: controller.roleController,
                        label: "User Role",
                        icon: Icons.work_outline,
                      ),
                      const SizedBox(height: 24),
                      _buildModernField(
                        controller: controller.phoneController,
                        label: "Phone Number",
                        icon: Icons.phone_outlined,
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 48),
        Obx(() => controller.isEditing.value
            ? SizedBox(
                width: 300,
                child: CustomButton(
                  text: "Save Changes",
                  isLoading: controller.isLoading.value,
                  onPressed: controller.saveProfile,
                ),
              )
            : const SizedBox()),
      ],
    );
  }

  Widget _buildModernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Obx(() {
      final isEditing = this.controller.isEditing.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isEditing ? Colors.white : AppColors.lightGrey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isEditing ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
              ),
              boxShadow: isEditing 
                  ? [BoxShadow(color: AppColors.primary.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] 
                  : [],
            ),
            child: Row(
              children: [
                Icon(icon, color: isEditing ? AppColors.primary : AppColors.grey, size: 20),
                const SizedBox(width: 16),
                Expanded(
                  child: isEditing
                      ? TextField(
                          controller: controller,
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.secondary),
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )
                      : Text(
                          controller.text,
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.secondary),
                        ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 32),
          ...children,
        ],
      ),
    );
  }
}
