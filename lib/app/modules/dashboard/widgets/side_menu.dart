import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../dashboard_controller.dart';
import '../../profile/profile_view.dart';
import '../../profile/profile_binding.dart';

class SideMenu extends GetView<DashboardController> {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.secondary,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.science_outlined, size: 48, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(
                  'VIRSACO',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          _DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard_outlined,
            index: 0,
            press: () => controller.changeIndex(0),
          ),
          _DrawerListTile(
            title: "Research Building",
            icon: Icons.biotech_outlined,
            index: 1,
            press: () => controller.changeIndex(1),
          ),
          _DrawerListTile(
            title: "Hostel",
            icon: Icons.hotel_outlined,
            index: 2,
            press: () => controller.changeIndex(2),
          ),
          _DrawerListTile(
            title: "Ground Management",
            icon: Icons.landscape_outlined,
            index: 3,
            press: () => controller.changeIndex(3),
          ),
          _DrawerListTile(
            title: "Leave Management",
            icon: Icons.calendar_month_outlined,
            index: 4,
            press: () => controller.changeIndex(4),
          ),
          const Spacer(),
          _DrawerListTile(
            title: "Settings",
            icon: Icons.settings_outlined,
            index: 5,
            press: () {},
          ),
          _DrawerListTile(
            title: "Profile",
            icon: Icons.person_outline,
            index: 10,
            press: () => Get.toNamed(Routes.PROFILE),
          ),
          _DrawerListTile(
            title: "Logout",
            icon: Icons.logout,
            index: -1,
            press: controller.logout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _DrawerListTile extends GetView<DashboardController> {
  const _DrawerListTile({
    required this.title,
    required this.icon,
    required this.press,
    required this.index,
  });

  final String title;
  final IconData icon;
  final VoidCallback press;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        selected: isSelected,
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : Colors.white54,
          size: 22,
        ),
        title: Row(
          children: [
            const SizedBox(width: 8), // Gap between icon and text
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        tileColor: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      );
    });
  }
}
