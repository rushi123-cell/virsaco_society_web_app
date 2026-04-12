import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../dashboard_controller.dart';
import 'stationary_view.dart';
import '../dashboard_view.dart'; // To use _StatCard if we made it public or just redo it

class ResearchBuildingView extends GetView<DashboardController> {
  const ResearchBuildingView({super.key});

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
            // Consistent gap between title and sub-nav
            runSpacing: 16,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.biotech_outlined,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Research Building",
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
              if (controller.selectedResearchSubSection.value == 0) {
                return _buildStaffDetails(context);
              } else {
                if (controller.selectedStoreCategory.value == "Stationary") {
                  return Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => controller.changeStoreCategory(""),
                            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Back to Categories",
                            style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Expanded(child: StationaryView()),
                    ],
                  );
                }
                return _buildStoreRoom(context);
              }
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
                title: "Staff Details",
                index: 0,
                isSelected: controller.selectedResearchSubSection.value == 0,
                onTap: () => controller.changeResearchSubSection(0),
              ),
              _SubNavItem(
                title: "Store Room",
                index: 1,
                isSelected: controller.selectedResearchSubSection.value == 1,
                onTap: () => controller.changeResearchSubSection(1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaffDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Staff Directory",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 20,),
        // Header & Data Section with Horizontal Scroll
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 900),
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width -
                    (Responsive.isDesktop(context) ? 300 : 80),
                child: Column(
                  children: [
                    // Header Row
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: _headerText("Name")),
                          Expanded(flex: 2, child: _headerText("Position")),
                          Expanded(flex: 2, child: _headerText("Joined Date")),
                          Expanded(flex: 1, child: _headerText("Leaves")),
                          Expanded(flex: 1, child: _headerText("Status")),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Data Rows
                    Expanded(
                      child: ListView.separated(
                        itemCount: 8,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return _StaffCard(
                            name: "Staff Member ${index + 1}",
                            post: index % 2 == 0
                                ? "Senior Researcher"
                                : "Lab Assistant",
                            date: "Jan 12, 2023",
                            leaves: "${index * 2}",
                            isVerified: index % 3 != 0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
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

  Widget _buildStoreRoom(BuildContext context) {
    final categories = [
      {"name": "Stationary", "icon": Icons.edit_note, "color": Colors.blue},
      {"name": "Glass Vessels", "icon": Icons.biotech, "color": Colors.teal},
      {"name": "Chemicals", "icon": Icons.science, "color": Colors.orange},
      {"name": "Plastic Vessels", "icon": Icons.opacity, "color": Colors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Storage Inventory",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (categories[index]["name"] == "Stationary") {
                    controller.changeStoreCategory("Stationary");
                  }
                },
                child: _CategoryCard(
                  title: categories[index]["name"] as String,
                  icon: categories[index]["icon"] as IconData,
                  color: categories[index]["color"] as Color,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StaffCard extends StatefulWidget {
  final String name;
  final String post;
  final String date;
  final String leaves;
  final bool isVerified;

  const _StaffCard({
    required this.name,
    required this.post,
    required this.date,
    required this.leaves,
    required this.isVerified,
  });

  @override
  State<_StaffCard> createState() => _StaffCardState();
}

class _StaffCardState extends State<_StaffCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withOpacity(0.3)
                : Colors.transparent,
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
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      widget.name[0],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.name,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.post,
                style: GoogleFonts.inter(color: AppColors.grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.date,
                style: GoogleFonts.inter(color: AppColors.grey),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                widget.leaves,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      (widget.isVerified ? AppColors.success : AppColors.error)
                          .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.isVerified ? "Verified" : "Pending",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isVerified
                        ? AppColors.success
                        : AppColors.error,
                    fontSize: 11,
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


class _SubNavItem extends StatelessWidget {
  final String title;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubNavItem({
    required this.title,
    required this.index,
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

class _CategoryCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(_isHovered ? 0.2 : 0.05),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 48, color: widget.color),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "View Items",
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
