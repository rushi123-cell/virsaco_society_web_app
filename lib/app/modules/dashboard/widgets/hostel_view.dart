import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../dashboard_controller.dart';

class HostelView extends GetView<DashboardController> {
  const HostelView({super.key});

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
            spacing: 40, // Consistent gap between title and sub-nav
            runSpacing: 16,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.hotel_outlined, color: AppColors.primary, size: 32),
                  const SizedBox(width: 20),
                  Text(
                    "Hostel Management",
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
              switch (controller.selectedHostelSubSection.value) {
                case 0:
                  return _buildAtithiGruh(context);
                case 1:
                  return _buildHostelDetails(context, "Boys Hostel");
                case 2:
                  return _buildHostelDetails(context, "Girls Hostel");
                default:
                  return const SizedBox();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSubNav() {
    return Obx(() => SingleChildScrollView(
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
              title: "Atithi Gruh",
              isSelected: controller.selectedHostelSubSection.value == 0,
              onTap: () => controller.changeHostelSubSection(0),
            ),
            _SubNavItem(
              title: "Boys Hostel",
              isSelected: controller.selectedHostelSubSection.value == 1,
              onTap: () => controller.changeHostelSubSection(1),
            ),
            _SubNavItem(
              title: "Girls Hostel",
              isSelected: controller.selectedHostelSubSection.value == 2,
              onTap: () => controller.changeHostelSubSection(2),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildAtithiGruh(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Guest House (Atithi Gruh) Overview",
            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.secondary),
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.4,
            children: [
              _InfoCard(title: "Total Rooms", value: "12", icon: Icons.meeting_room, color: Colors.blue),
              _InfoCard(title: "Occupied", value: "8", icon: Icons.person, color: Colors.orange),
              _InfoCard(title: "Available", value: "4", icon: Icons.check_circle, color: Colors.green),
              _InfoCard(title: "Booking Rate", value: "75%", icon: Icons.trending_up, color: Colors.purple),
            ],
          ),
          const SizedBox(height: 32),
          _buildRecentCheckins(context),
        ],
      ),
    );
  }

  Widget _buildRecentCheckins(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Guest Check-ins",
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 900),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - (Responsive.isDesktop(context) ? 320 : 100),
              child: Column(
                children: [
                  _DataHeader(columns: const ["Guest Name", "Room", "Check-in", "Status"]),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _GenericDataCard(
                      values: ["Guest ${index + 1}", "A-10${index + 1}", "Feb 21, 2024", "Confirmed"],
                      isStatus: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHostelDetails(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$title Management",
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.secondary),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Add Student"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 1000),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - (Responsive.isDesktop(context) ? 320 : 80),
                child: Column(
                  children: [
                    _DataHeader(columns: const ["ID", "Student Name", "Room", "Floor", "Join Date", "Actions"]),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: 10,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) => _StudentCard(
                          id: "SID-${20240 + index}",
                          name: "Student Name ${index + 1}",
                          room: "${(index % 4) + 1}0${index}",
                          floor: "${(index % 4) + 1}",
                          date: "Aug 15, 2023",
                        ),
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
}

class _DataHeader extends StatelessWidget {
  final List<String> columns;
  const _DataHeader({required this.columns});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: columns.map((col) => Expanded(
          child: Text(
            col,
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        )).toList(),
      ),
    );
  }
}

class _GenericDataCard extends StatelessWidget {
  final List<String> values;
  final bool isStatus;

  const _GenericDataCard({required this.values, this.isStatus = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: values.asMap().entries.map((entry) {
          final index = entry.key;
          final val = entry.value;
          
          if (isStatus && index == values.length - 1) {
            return Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text("Confirmed", style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }
          
          return Expanded(
            child: Text(
              val,
              style: GoogleFonts.inter(color: AppColors.secondary, fontSize: 13),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StudentCard extends StatefulWidget {
  final String id;
  final String name;
  final String room;
  final String floor;
  final String date;

  const _StudentCard({required this.id, required this.name, required this.room, required this.floor, required this.date});

  @override
  State<_StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<_StudentCard> {
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
          border: Border.all(color: _isHovered ? AppColors.primary.withOpacity(0.3) : Colors.transparent),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Expanded(child: Text(widget.id, style: GoogleFonts.inter(color: AppColors.grey, fontSize: 13))),
            Expanded(child: Text(widget.name, style: GoogleFonts.inter(color: AppColors.secondary, fontWeight: FontWeight.w600, fontSize: 13))),
            Expanded(child: Text(widget.room, style: GoogleFonts.inter(color: AppColors.secondary, fontSize: 13))),
            Expanded(child: Text(widget.floor, style: GoogleFonts.inter(color: AppColors.secondary, fontSize: 13))),
            Expanded(child: Text(widget.date, style: GoogleFonts.inter(color: AppColors.grey, fontSize: 13))),
            Expanded(
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red)),
                ],
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
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)] : [],
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

class _InfoCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: widget.color, size: 28),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.grey, fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.value,
                  style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.secondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
