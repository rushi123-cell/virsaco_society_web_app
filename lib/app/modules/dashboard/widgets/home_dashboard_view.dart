import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../dashboard_controller.dart';

class HomeDashboardView extends GetView<DashboardController> {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.dashboard_outlined, color: AppColors.primary, size: 32),
              const SizedBox(width: 16),
              Text(
                "Dashboard Overview",
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickStats(context),
                  const SizedBox(height: 48),
                  _buildTodayLeaveSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: Responsive.isDesktop(context) ? 4 : (Responsive.isTablet(context) ? 2 : 1),
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 1.5,
      children: [
        _StatCard(title: "Total Staff", value: "124", icon: Icons.people_outline, color: Colors.blue),
        Obx(() => _StatCard(
          title: "On Leave Today",
          value: controller.onLeaveToday.value.toString(),
          icon: Icons.calendar_today_outlined,
          color: AppColors.error,
        )),
        _StatCard(title: "Present Today", value: "116", icon: Icons.check_circle_outline, color: AppColors.success),
        _StatCard(title: "Pending Tasks", value: "12", icon: Icons.assignment_outlined, color: Colors.orange),
      ],
    );
  }

  Widget _buildTodayLeaveSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "On Leave Today",
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => controller.changeIndex(5), // Go to Leave Management
                child: Row(
                  children: [
                    Text("Manage Leaves", style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (context, index) => Divider(color: AppColors.lightGrey.withOpacity(0.5)),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text("${index + 1}", style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Staff Member ${index + 101}", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary)),
                          Text(index % 2 == 0 ? "Full Day" : "Half Day (Morning)", style: GoogleFonts.inter(color: AppColors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (index % 3 == 0 ? Colors.orange : Colors.blue).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        index % 3 == 0 ? "Sick Leave" : "Casual Leave",
                        style: TextStyle(
                          color: index % 3 == 0 ? Colors.orange : Colors.blue,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.inter(color: AppColors.grey, fontWeight: FontWeight.w500)),
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.secondary)),
        ],
      ),
    );
  }
}
