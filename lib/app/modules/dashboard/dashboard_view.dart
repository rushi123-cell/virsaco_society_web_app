import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virsaco_society_web_app/app/modules/dashboard/widgets/ground_management_view.dart';
import 'package:virsaco_society_web_app/app/modules/dashboard/widgets/home_dashboard_view.dart';
import 'package:virsaco_society_web_app/app/modules/dashboard/widgets/hostel_view.dart';
import 'package:virsaco_society_web_app/app/modules/dashboard/widgets/leave_management_view.dart';
import 'package:virsaco_society_web_app/app/modules/dashboard/widgets/research_building_view.dart';
import 'package:virsaco_society_web_app/app/modules/dashboard/widgets/side_menu.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import 'dashboard_controller.dart';
import '../profile/profile_view.dart';
import '../profile/profile_binding.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      drawer: const SideMenu(),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Side Menu (Only for Desktop)
            if (Responsive.isDesktop(context))
              const Expanded(
                flex: 1,
                child: SideMenu(),
              ),
            
            // Main Content Area
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: Obx(() {
                      switch (controller.selectedIndex.value) {
                        case 0:
                          return const HomeDashboardView();
                        case 1:
                          return const ResearchBuildingView();
                        case 2:
                          return const HostelView();
                        case 3:
                          return const GroundManagementView();
                        case 4:
                          return const LeaveManagementView();
                        default:
                          return const HomeDashboardView();
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      color: Colors.white,
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          
          Text(
            "Society Management System",
            style: GoogleFonts.outfit(
              fontSize: Responsive.isMobile(context) ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          
          const Spacer(),
          
          _HeaderActionIcon(icon: Icons.notifications_none_outlined, count: "5"),
          const SizedBox(width: 20),
          _ProfileDropdown(),
        ],
      ),
    );
  }
}

class _HeaderActionIcon extends StatelessWidget {
  final IconData icon;
  final String count;

  const _HeaderActionIcon({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon, color: AppColors.grey, size: 26),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              count,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => const ProfileView(), binding: ProfileBinding());
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            if (!Responsive.isMobile(context))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rushita Ramani",
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary),
                  ),
                  Text(
                    "Administrator",
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey),
                  ),
                ],
              ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}
