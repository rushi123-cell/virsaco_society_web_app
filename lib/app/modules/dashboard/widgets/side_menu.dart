import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/utils/app_images.dart';
import '../../../../common/values/app_colors.dart';
import '../dashboard_controller.dart';

class SideMenu extends GetView<DashboardController> {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLogo(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(color: Colors.white10, height: 1),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                 children: [
                  _DrawerListTile(
                    title: "Dashboard",
                    index: 0,
                    press: () => controller.changeIndex(0),
                  ),
                  _DrawerListTile(
                    title: "Research Building",
                    index: 1,
                    press: () => controller.changeIndex(1),
                  ),
                  _DrawerListTile(
                    title: "Hostel",
                    index: 2,
                    press: () => controller.changeIndex(2),
                  ),
                  _DrawerListTile(
                    title: "Ground Management",
                    index: 3,
                    press: () => controller.changeIndex(3),
                  ),
                  _DrawerListTile(
                    title: "Leave Management",
                    index: 4,
                    press: () => controller.changeIndex(4),
                  ),
                  _DrawerListTile(
                    title: "Employee Management",
                    index: 6,
                    press: () => controller.changeIndex(6),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(color: Colors.white10, height: 1),
          ),
          const SizedBox(height: 16),
          _DrawerListTile(
            title: "Settings",
            index: 5,
            press: () {},
          ),
          _DrawerListTile(
            title: "Logout",
            index: -1,
            press: () => controller.logout(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                AppImages.logo,
                height: 32,
                width: 32,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "VIRSACO",
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  "Admin Portal",
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white38,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatefulWidget {
  const _DrawerListTile({
    required this.title,
    required this.press,
    required this.index,
  });

  final String title;
  final VoidCallback press;
  final int index;

  @override
  State<_DrawerListTile> createState() => _DrawerListTileState();
}

class _DrawerListTileState extends State<_DrawerListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find();

    return Obx(() {
      final isSelected = controller.selectedIndex.value == widget.index;
      final activeColor = isSelected ? AppColors.primary : Colors.white;

      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.press,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? AppColors.primary.withOpacity(0.15)
                  : (_isHovered ? Colors.white.withOpacity(0.05) : Colors.transparent),
              border: Border.all(
                color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: GoogleFonts.outfit(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
