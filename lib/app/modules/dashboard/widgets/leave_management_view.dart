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
          _buildHeader(context),
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.calendar_today_rounded,
            color: AppColors.primary,
            size: 28,
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Leave Management",
              style: GoogleFonts.outfit(
                fontSize: Responsive.isMobile(context) ? 22 : 28,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            Text(
              "Manage your time off and track application status",
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.grey),
            ),
          ],
        ),
        const Spacer(),
        // Role Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Row(
            children: [
              Obx(() => Text(
                controller.isDirector.value ? "Director" : "Employee",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              )),
              const SizedBox(width: 8),
              Obx(() => Switch.adaptive(
                activeColor: AppColors.primary,
                value: controller.isDirector.value,
                onChanged: (_) => controller.toggleRole(),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubNav() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.lightGrey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SubNavItem(
              title: "Apply Leave",
              icon: Icons.add_circle_outline,
              isSelected: controller.selectedLeaveSubSection.value == 0,
              onTap: () => controller.changeLeaveSubSection(0),
            ),
            _SubNavItem(
              title: "Leave History",
              icon: Icons.history,
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
          const SizedBox(height: 40),
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
      {"type": "CL (Casual)", "count": "12", "color": Colors.blue, "icon": Icons.beach_access},
      {"type": "PL (Paid)", "count": "08", "color": Colors.orange, "icon": Icons.payments_outlined},
      {"type": "Sick Leave", "count": "05", "color": Colors.teal, "icon": Icons.medical_services_outlined},
    ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: balances.map((b) => _BalanceCard(
        title: b['type'] as String,
        count: b['count'] as String,
        color: b['color'] as Color,
        icon: b['icon'] as IconData,
      )).toList(),
    );
  }

  Widget _buildApplyLeaveForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_document, color: AppColors.primary),
              const SizedBox(width: 12),
              Text("Create Application", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.warning.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Leave Application Policy",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.warning, fontSize: 14),
                      ),
                      Text(
                        "You can have max 4 pending applications. Please contact HR for urgent requests.",
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.secondary.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: _buildFormField("Leave Type", ["CL (Casual)", "PL (Paid)", "Sick Leave"], Icons.category_outlined)),
              const SizedBox(width: 24),
              Expanded(child: _buildFormField("Duration", ["Full Day", "First Half", "Second Half"], Icons.access_time)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildFormField("Range Selection", ["Single Date", "Date Range"], Icons.date_range)),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Date", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          controller.selectedLeaveDate.value = "${date.day}/${date.month}/${date.year}";
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.event_available, color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Obx(() => Text(
                              controller.selectedLeaveDate.value.isEmpty ? "Click to pick date" : controller.selectedLeaveDate.value,
                              style: GoogleFonts.inter(
                                fontSize: 14, 
                                color: controller.selectedLeaveDate.value.isEmpty ? AppColors.grey : AppColors.secondary,
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text("Reason for Leave", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary)),
          const SizedBox(height: 10),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Briefly explain the reason...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              filled: true,
              fillColor: AppColors.lightGrey.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Get.snackbar("Success", "Leave application submitted successfully!",
                    snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.success, colorText: Colors.white);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text("Submit Application", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, List<String> options, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: options[0],
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.inter(fontSize: 14)))).toList(),
          onChanged: (v) {},
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            filled: true,
            fillColor: AppColors.lightGrey.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveStatusTable(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 40)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Application History", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(flex: 2, child: _headerText("Applied")),
                Expanded(flex: 2, child: _headerText("Type")),
                Expanded(flex: 3, child: _headerText("Duration")),
                Expanded(flex: 2, child: _headerText("Status")),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _StatusRow(
              date: "Apr ${12 - index}, 2024",
              type: index % 2 == 0 ? "CL" : "Sick",
              range: "Apr 15 - Apr 15",
              status: index == 0 ? "Pending" : "Approved",
            ),
          ),
        ],
      ),
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
              name: "Staff Member ${index + 1}",
              type: "Casual Leave",
              duration: "Full Day",
              reason: "Personal work at hometown.",
              dates: "Apr 20, 2024",
              avatarColor: [Colors.blue, Colors.orange, Colors.teal, Colors.purple][index % 4],
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerText(String text) {
    return Text(text, style: GoogleFonts.inter(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13));
  }
}

class _SubNavItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubNavItem({required this.title, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : [],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? AppColors.primary : AppColors.grey),
            const SizedBox(width: 8),
            Text(title, style: GoogleFonts.inter(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? AppColors.primary : AppColors.grey)),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;

  const _BalanceCard({required this.title, required this.count, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 20),
          Text(title, style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(count, style: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.secondary)),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(color: AppColors.lightGrey.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(date, style: GoogleFonts.inter(color: AppColors.secondary, fontWeight: FontWeight.w500))),
          Expanded(flex: 2, child: Text(type, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primary))),
          Expanded(flex: 3, child: Text(range, style: GoogleFonts.inter(color: AppColors.grey))),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: (status == "Approved" ? AppColors.success : AppColors.warning).withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
              child: Text(status, textAlign: TextAlign.center, style: TextStyle(color: status == "Approved" ? AppColors.success : AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
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
  final Color avatarColor;

  const _ApprovalCard({required this.name, required this.type, required this.duration, required this.dates, required this.reason, required this.avatarColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.white, 
        borderRadius: BorderRadius.circular(24), 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20)],
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.5))
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundColor: avatarColor.withOpacity(0.1), child: Text(name[0], style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 18))),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _InfoChip(label: type, icon: Icons.category_outlined),
                    const SizedBox(width: 12),
                    _InfoChip(label: dates, icon: Icons.event_note),
                  ],
                ),
                const SizedBox(height: 12),
                Text("“$reason”", style: GoogleFonts.inter(fontSize: 13, color: AppColors.grey, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Row(
            children: [
              _ActionButton(onPressed: () {}, icon: Icons.check, label: "Approve", color: AppColors.success),
              const SizedBox(width: 12),
              _ActionButton(onPressed: () {}, icon: Icons.close, label: "Reject", color: AppColors.error),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.lightGrey.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.grey),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const _ActionButton({required this.onPressed, required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }
}
