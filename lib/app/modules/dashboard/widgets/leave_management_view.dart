import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../dashboard_controller.dart';

class LeaveManagementView extends GetView<DashboardController> {
  const LeaveManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(width: 20),
              Text(
                "Leave Management",
                style: GoogleFonts.outfit(
                  fontSize: Responsive.isMobile(context) ? 22 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const Spacer(),
              // Role Toggle for Demo
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 200,
                  child: Obx(() => SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      controller.isDirector.value ? "Director Mode" : "Employee Mode",
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    value: controller.isDirector.value,
                    onChanged: (_) => controller.toggleRole(),
                  )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSubNav(),
          const SizedBox(height: 32),
          Expanded(
            child: Obx(() {
              if (controller.isDirector.value) {
                return _buildDirectorView(context);
              } else {
                return _buildEmployeeView(context);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSubNav() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.lightGrey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SubNavItem(
              title: "Apply Leave",
              isSelected: controller.selectedLeaveSubSection.value == 0,
              onTap: () => controller.changeLeaveSubSection(0),
            ),
            _SubNavItem(
              title: "Leave Status",
              isSelected: controller.selectedLeaveSubSection.value == 1,
              onTap: () => controller.changeLeaveSubSection(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeView(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeaveBalance(context),
          const SizedBox(height: 32),
          controller.selectedLeaveSubSection.value == 0
              ? _buildApplyLeaveForm(context)
              : _buildLeaveStatusTable(context),
        ],
      ),
    );
  }

  Widget _buildDirectorView(BuildContext context) {
    return _buildDirectorApprovalList(context);
  }

  Widget _buildLeaveBalance(BuildContext context) {
    final balances = [
      {"type": "CL (Casual)", "count": "12", "color": Colors.blue},
      {"type": "PL (Paid)", "count": "08", "color": Colors.orange},
      {"type": "Sick Leave", "count": "05", "color": Colors.teal},
    ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: balances.map((b) => _BalanceCard(
        title: b['type'] as String,
        count: b['count'] as String,
        color: b['color'] as Color,
      )).toList(),
    );
  }

  Widget _buildApplyLeaveForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Apply for New Leave", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary)),
          const SizedBox(height: 24),
          // Form Constraints Message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.warning),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Note: Maximum 4 pending leaves allowed. For more, please contact the Management Team.",
                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.secondary, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Form Fields
          _buildFormField("Leave Type", ["CL", "PL", "Sick Leave"]),
          const SizedBox(height: 24),
          _buildFormField("Duration", ["Full Day", "Half Day"]),
          const SizedBox(height: 24),
          _buildFormField("Date Range", ["Single Date", "Multiple Days"]),
          const SizedBox(height: 24),
          Text("Reason", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.grey)),
          const SizedBox(height: 8),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter reason for leave...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: AppColors.lightGrey.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.snackbar("Success", "Leave application submitted successfully!",
                    snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.success, colorText: Colors.white);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Submit Application", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.grey)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: options[0],
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.lightGrey.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveStatusTable(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Leave History", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Expanded(flex: 2, child: _headerText("Applied Date")),
              Expanded(flex: 2, child: _headerText("Type")),
              Expanded(flex: 3, child: _headerText("Date Range")),
              Expanded(flex: 2, child: _headerText("Status")),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _StatusRow(
            date: "Apr ${12 - index}, 2024",
            type: index == 0 ? "CL" : "PL",
            range: "Apr 14-15, 2024",
            status: index == 0 ? "Pending" : "Approved",
          ),
        ),
      ],
    );
  }

  Widget _buildDirectorApprovalList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pending Approvals", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary)),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) => _ApprovalCard(
              name: "Employee ${index + 1}",
              type: "CL",
              duration: "Full Day",
              reason: "Personal work at hometown.",
              dates: "Apr 20, 2024",
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerText(String text) {
    return Text(text, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14));
  }
}

class _SubNavItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubNavItem({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(title, style: GoogleFonts.inter(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? AppColors.primary : AppColors.grey)),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _BalanceCard({required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(count, style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String date;
  final String type;
  final String range;
  final String status;

  const _StatusRow({required this.date, required this.type, required this.range, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(date, style: GoogleFonts.inter(color: AppColors.grey))),
          Expanded(flex: 2, child: Text(type, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.secondary))),
          Expanded(flex: 3, child: Text(range, style: GoogleFonts.inter(color: AppColors.grey))),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (status == "Approved" ? AppColors.success : AppColors.warning).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(status, textAlign: TextAlign.center, style: TextStyle(color: status == "Approved" ? AppColors.success : AppColors.warning, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final String name;
  final String type;
  final String duration;
  final String dates;
  final String reason;

  const _ApprovalCard({required this.name, required this.type, required this.duration, required this.dates, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.lightGrey)),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundColor: AppColors.primary.withOpacity(0.1), child: Text(name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.secondary)),
                const SizedBox(height: 4),
                Text("$type | $duration | $dates", style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey)),
                const SizedBox(height: 8),
                Text("Reason: $reason", style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.check_circle, color: AppColors.success)),
              const SizedBox(width: 8),
              IconButton(onPressed: () {}, icon: const Icon(Icons.cancel, color: AppColors.error)),
            ],
          ),
        ],
      ),
    );
  }
}
