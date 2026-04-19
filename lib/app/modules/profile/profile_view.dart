import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_controller.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Responsive.isDesktop(context) 
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildStatsCard(context)),
                            const SizedBox(width: 32),
                            Expanded(flex: 3, child: _buildInfoEditor(context)),
                          ],
                        )
                      : Column(
                          children: [
                            _buildStatsCard(context),
                            const SizedBox(height: 32),
                            _buildInfoEditor(context),
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

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.secondary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, AppColors.profileGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Decorative elements
            Positioned(
              right: -50,
              top: -50,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white.withOpacity(0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 66,
                    backgroundColor: AppColors.lightGrey,
                    child: Icon(Icons.person, size: 70, color: AppColors.secondary),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            "Rushita Ramani",
            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.secondary),
          ),
          Text(
            "Super Administrator",
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          _buildQuickStat(Icons.event_available, "Total Days Active", "342 Days"),
          const Divider(height: 40),
          _buildQuickStat(Icons.task_alt, "Applications Processed", "1,240"),
          const Divider(height: 40),
          _buildQuickStat(Icons.workspace_premium, "VIRSACO Rank", "Head Admin"),
        ],
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey)),
            Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.secondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoEditor(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Account Information", style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondary)),
              Obx(() => TextButton.icon(
                onPressed: controller.toggleEdit,
                icon: Icon(controller.isEditing.value ? Icons.close : Icons.edit, size: 18),
                label: Text(controller.isEditing.value ? "Cancel" : "Edit Profile"),
                style: TextButton.styleFrom(
                  foregroundColor: controller.isEditing.value ? AppColors.error : AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),
          Text("Manage your personal details and contact information", style: GoogleFonts.inter(fontSize: 14, color: AppColors.grey)),
          const SizedBox(height: 48),
          _buildFieldRow(
            [
              _buildModernField("Full Name", controller.nameController, Icons.person_outline),
              _buildModernField("Email Address", controller.emailController, Icons.email_outlined),
            ],
            context,
          ),
          const SizedBox(height: 32),
          _buildFieldRow(
            [
              _buildModernField("Phone Number", controller.phoneController, Icons.phone_android_outlined),
              _buildModernField("User Role", controller.roleController, Icons.work_outline),
            ],
            context,
          ),
          const SizedBox(height: 48),
          Obx(() => controller.isEditing.value 
              ? SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => controller.saveProfile(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("Save All Changes", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                )
              : const SizedBox()),
        ],
      ),
    );
  }

  Widget _buildFieldRow(List<Widget> fields, BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Column(children: fields.map((f) => Padding(padding: const EdgeInsets.only(bottom: 24), child: f)).toList());
    }
    return Row(
      children: fields.map((f) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: f))).toList(),
    );
  }

  Widget _buildModernField(String label, TextEditingController textController, IconData icon) {
    return Obx(() {
      final editing = controller.isEditing.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.grey)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: editing ? Colors.white : AppColors.lightGrey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: editing ? AppColors.primary : Colors.transparent, width: 1.5),
            ),
            child: Row(
              children: [
                Icon(icon, color: editing ? AppColors.primary : AppColors.grey, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: editing 
                      ? TextField(
                          controller: textController,
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.secondary),
                          decoration: const InputDecoration(isDense: true, border: InputBorder.none, contentPadding: EdgeInsets.zero),
                        )
                      : Text(textController.text, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.secondary)),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
