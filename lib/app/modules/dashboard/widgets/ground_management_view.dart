import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../dashboard_controller.dart';

class GroundManagementView extends GetView<DashboardController> {
  const GroundManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 40,
            runSpacing: 16,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.landscape_outlined,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Ground Management",
                    style: GoogleFonts.outfit(
                      fontSize: Responsive.isMobile(context) ? 22 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              _buildSubNav(),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Obx(() {
              String title = "";
              switch (controller.selectedGroundSubSection.value) {
                case 0:
                  title = "Field Trial Plot";
                  break;
                case 1:
                  title = "Poly House";
                  break;
                case 2:
                  title = "Net House";
                  break;
                case 3:
                  title = "Campus";
                  break;
              }
              return _buildManagementContent(context, title);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSubNav() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.lightGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SubNavItem(
                title: "Field Trial Plot",
                isSelected: controller.selectedGroundSubSection.value == 0,
                onTap: () => controller.changeGroundSubSection(0),
              ),
              _SubNavItem(
                title: "Poly House",
                isSelected: controller.selectedGroundSubSection.value == 1,
                onTap: () => controller.changeGroundSubSection(1),
              ),
              _SubNavItem(
                title: "Net House",
                isSelected: controller.selectedGroundSubSection.value == 2,
                onTap: () => controller.changeGroundSubSection(2),
              ),
              _SubNavItem(
                title: "Campus",
                isSelected: controller.selectedGroundSubSection.value == 3,
                onTap: () => controller.changeGroundSubSection(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagementContent(BuildContext context, String sectionTitle) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWorkerSection(context, sectionTitle),
          const SizedBox(height: 48),
          _buildItemsSection(context, sectionTitle),
        ],
      ),
    );
  }

  Widget _buildWorkerSection(BuildContext context, String sectionTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Workers Today ($sectionTitle)",
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Total: 12",
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Worker Table
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 800),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - (Responsive.isDesktop(context) ? 360 : 64),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: _headerText("Worker Name")),
                        Expanded(flex: 2, child: _headerText("Shift")),
                        Expanded(flex: 2, child: _headerText("Check-in")),
                        Expanded(flex: 2, child: _headerText("Status")),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return _WorkerCard(
                        name: "Worker ${index + 1}",
                        shift: index % 2 == 0 ? "Morning" : "Evening",
                        checkIn: "08:3${index} AM",
                        status: "On Duty",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(BuildContext context, String sectionTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Items Issue and Delivery ($sectionTitle)",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 1000),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - (Responsive.isDesktop(context) ? 360 : 64),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: _headerText("Item Detail")),
                        Expanded(flex: 2, child: _headerText("Issue Date")),
                        Expanded(flex: 2, child: _headerText("Delivery Date")),
                        Expanded(flex: 2, child: _headerText("Taken Date")),
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
                    itemBuilder: (context, index) {
                      return _ItemCard(
                        detail: "Farming Tools Set #${100 + index}",
                        issueDate: "Apr 10, 2024",
                        deliveryDate: "Apr 11, 2024",
                        takenDate: "Apr 12, 2024",
                        status: index == 0 ? "Pending" : "Completed",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }
}

class _SubNavItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubNavItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

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
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]
              : [],
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.grey,
          ),
        ),
      ),
    );
  }
}

class _WorkerCard extends StatefulWidget {
  final String name;
  final String shift;
  final String checkIn;
  final String status;

  const _WorkerCard({
    required this.name,
    required this.shift,
    required this.checkIn,
    required this.status,
  });

  @override
  State<_WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<_WorkerCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.primary.withOpacity(0.05) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03),
              blurRadius: _isHovered ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(widget.name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Text(widget.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary)),
                ],
              ),
            ),
            Expanded(flex: 2, child: Text(widget.shift, style: GoogleFonts.inter(color: AppColors.grey))),
            Expanded(flex: 2, child: Text(widget.checkIn, style: GoogleFonts.inter(color: AppColors.grey))),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.status,
                  style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatefulWidget {
  final String detail;
  final String issueDate;
  final String deliveryDate;
  final String takenDate;
  final String status;

  const _ItemCard({
    required this.detail,
    required this.issueDate,
    required this.deliveryDate,
    required this.takenDate,
    required this.status,
  });

  @override
  State<_ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<_ItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.primary.withOpacity(0.05) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03),
              blurRadius: _isHovered ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(widget.detail, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary))),
            Expanded(flex: 2, child: Text(widget.issueDate, style: GoogleFonts.inter(color: AppColors.grey))),
            Expanded(flex: 2, child: Text(widget.deliveryDate, style: GoogleFonts.inter(color: AppColors.grey))),
            Expanded(flex: 2, child: Text(widget.takenDate, style: GoogleFonts.inter(color: AppColors.grey))),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (widget.status == "Completed" ? AppColors.success : AppColors.warning).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.status,
                  style: TextStyle(
                    color: widget.status == "Completed" ? AppColors.success : AppColors.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
