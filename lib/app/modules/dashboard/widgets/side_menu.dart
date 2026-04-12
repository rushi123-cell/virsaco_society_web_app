import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../dashboard_controller.dart';

class SideMenu extends GetView<DashboardController> {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: AppColors.secondary,
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 20),
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
            title: "Logout",
            icon: Icons.logout,
            index: -1,
            press: () => controller.logout(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.domain,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            "Virsaco",
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
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
    final DashboardController controller = Get.find();

    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        ),
        child: ListTile(
          onTap: press,
          horizontalTitleGap: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Icon(
            icon,
            color: isSelected ? AppColors.primary : Colors.white54,
            size: 20,
          ),
          title: Text(
            title,
            style: GoogleFonts.inter(
              color: isSelected ? AppColors.primary : Colors.white54,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }
}
