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
          _buildWelcomeHeader(context),
          const SizedBox(height: 32),
          _buildQuickStats(context),
          const SizedBox(height: 48),
          Expanded(child: _buildOnLeaveSection(context)),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Society Dashboard",
          style: GoogleFonts.outfit(
            fontSize: Responsive.isMobile(context) ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Welcome back! Here's a quick overview of today's activities.",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        _StatCard(title: "Total Staff", count: "48", icon: Icons.people_outline, color: Colors.blue),
        _StatCard(title: "Present Today", count: "32", icon: Icons.how_to_reg_outlined, color: Colors.teal),
        _StatCard(title: "On Leave", count: "08", icon: Icons.event_busy_outlined, color: Colors.orange),
        _StatCard(title: "Pending Tasks", count: "14", icon: Icons.assignment_late_outlined, color: Colors.purple),
      ],
    );
  }

  Widget _buildOnLeaveSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.event_note, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Text(
              "On Leave Today",
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(() => Text(
                "${controller.onLeaveToday.value} Members",
                style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold),
              )),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: 8,
              separatorBuilder: (context, index) => const Divider(height: 32, color: AppColors.lightGrey),
              itemBuilder: (context, index) {
                return _LeaveListItem(
                  name: "Staff Member ${index + 1}",
                  role: index % 2 == 0 ? "Senior Researcher" : "Lab Assistant",
                  leaveType: index % 3 == 0 ? "Sick Leave" : "Casual Leave",
                  duration: "Full Day",
                  reason: "Personal work at home.",
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _LeaveListItem extends StatelessWidget {
  final String name;
  final String role;
  final String leaveType;
  final String duration;
  final String reason;

  const _LeaveListItem({
    required this.name,
    required this.role,
    required this.leaveType,
    required this.duration,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 16)),
              Text(role, style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey)),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(leaveType, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 14)),
              Text(duration, style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey)),
            ],
          ),
        ),
        if (Responsive.isDesktop(context))
          Expanded(
            flex: 4,
            child: Text(
              "“$reason”",
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey, fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Away",
            style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.count, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 14, color: AppColors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(count, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondary)),
            ],
          ),
        ],
      ),
    );
  }
}
