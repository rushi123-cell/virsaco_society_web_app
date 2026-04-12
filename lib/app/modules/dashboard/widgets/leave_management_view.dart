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
              const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 32),
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

  // --- EMPLOYEE VIEW ---
  Widget _buildEmployeeView(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeaveBalance(context),
          const SizedBox(height: 48),
          _buildApplyLeaveForm(context),
        ],
      ),
    );
  }

  Widget _buildLeaveBalance(BuildContext context) {
    final balances = [
      {"type": "CL (Casual Leave)", "count": "12", "color": Colors.blue},
      {"type": "PL (Paid Leave)", "count": "8", "color": Colors.green},
      {"type": "Sick Leave", "count": "5", "color": Colors.orange},
      {"type": "Total Taken", "count": "4", "color": Colors.purple},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isDesktop(context) ? 4 : (Responsive.isTablet(context) ? 2 : 1),
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 2.5,
      ),
      itemCount: balances.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(color: balances[index]["color"] as Color, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(balances[index]["type"] as String, style: GoogleFonts.inter(color: AppColors.grey, fontSize: 13)),
                  Text(balances[index]["count"] as String, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildApplyLeaveForm(BuildContext context) {
    final applicationCount = 4; // Mock variable to demonstrate the constraint

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Apply for Leave", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.secondary)),
          const SizedBox(height: 24),
          if (applicationCount >= 4)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.error.withOpacity(0.3))),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "You have reached the maximum of 4 applied leaves. Please connect with the management team for further applications.",
                      style: GoogleFonts.inter(color: AppColors.error, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _buildDropdownField("Leave Type", ["Casual Leave", "Paid Leave", "Sick Leave", "Maternity/Paternity"]),
              _buildDropdownField("Duration", ["Full Day", "First Half", "Second Half"]),
              _buildDateField("Start Date"),
              _buildDateField("End Date"),
            ],
          ),
          const SizedBox(height: 24),
          Text("Reason", style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.secondary)),
          const SizedBox(height: 8),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter reason for leave...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.lightGrey)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: applicationCount < 4 ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                disabledBackgroundColor: AppColors.lightGrey,
              ),
              child: Text("Submit Application", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- DIRECTOR VIEW ---
  Widget _buildDirectorView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pending Leave Approvals", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.secondary)),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _LeaveApprovalCard(
                name: "Employee ${index + 1}",
                type: index % 2 == 0 ? "Casual Leave" : "Sick Leave",
                dates: "Apr 15 - Apr 17, 2024",
                reason: "Family emergency and personal work at hometown.",
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper Widgets
  Widget _buildDropdownField(String label, List<String> items) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.secondary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(border: Border.all(color: AppColors.lightGrey), borderRadius: BorderRadius.circular(12)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items[0],
                isExpanded: true,
                items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (_) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.secondary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(border: Border.all(color: AppColors.lightGrey), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Select Date", style: GoogleFonts.inter(color: AppColors.grey)),
                const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaveApprovalCard extends StatelessWidget {
  final String name;
  final String type;
  final String dates;
  final String reason;

  const _LeaveApprovalCard({required this.name, required this.type, required this.dates, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(type, style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(width: 12),
                    Text(dates, style: GoogleFonts.inter(color: AppColors.grey, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(reason, style: GoogleFonts.inter(color: AppColors.grey, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Row(
            children: [
              _ActionBtn(label: "Reject", color: AppColors.error, isOutline: true),
              const SizedBox(width: 12),
              _ActionBtn(label: "Approve", color: AppColors.success, isOutline: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatefulWidget {
  final String label;
  final Color color;
  final bool isOutline;

  const _ActionBtn({required this.label, required this.color, required this.isOutline});

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: _isHovered ? 4 : 0,
            backgroundColor: widget.isOutline ? Colors.white : widget.color,
            foregroundColor: widget.isOutline ? widget.color : Colors.white,
            side: widget.isOutline ? BorderSide(color: widget.color) : BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(widget.label, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ),
    );
  }
}
