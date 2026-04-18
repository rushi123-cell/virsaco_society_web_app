import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/utils/app_images.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../dashboard_controller.dart';
import '../../../../common/widgets/custom_pagination.dart';

class VesselsView extends GetView<DashboardController> {
  final String vesselType; // "Glass" or "Plastic"
  final IconData icon;

  const VesselsView({super.key, required this.vesselType, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(width: 20),
              Text(
                "$vesselType Vessels Management",
                style: GoogleFonts.outfit(
                  fontSize: Responsive.isMobile(context) ? 22 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const Spacer(),
              _buildSubNav(),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Obx(() {
              return controller.selectedStationarySubSection.value == 0
                  ? _buildIncomingItems(context)
                  : _buildItemDistribution(context);
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
              title: "Stock In",
              icon: Icons.login_outlined,
              isSelected: controller.selectedStationarySubSection.value == 0,
              onTap: () => controller.selectedStationarySubSection.value = 0,
            ),
            _SubNavItem(
              title: "Stock Out",
              icon: Icons.logout_outlined,
              isSelected: controller.selectedStationarySubSection.value == 1,
              onTap: () => controller.selectedStationarySubSection.value = 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Items Received (Stock In)",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: 400,
          height: 45,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: " Search $vesselType vessels...",
              hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.grey),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(AppImages.search, width: 18, height: 18),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 900),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - (Responsive.isDesktop(context) ? 360 : 64),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 3, child: _headerText("Item Name")),
                                  Expanded(flex: 2, child: _headerText("Received Date")),
                                  Expanded(flex: 2, child: _headerText("Quantity")),
                                  Expanded(flex: 3, child: _headerText("Source")),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                itemCount: 10,
                                separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.lightGrey),
                                itemBuilder: (context, index) {
                                  return _IncomingCard(
                                    item: index % 3 == 0 ? "Beaker 250ml" : (index % 3 == 1 ? "Test Tubes" : "Conical Flask"),
                                    date: "Apr ${10 - (index % 10)}, 2024",
                                    count: "${(index + 1) * 5} Units",
                                    source: "Lab Equipments Co.",
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.lightGrey)),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Obx(() {
                        const totalItems = 45;
                        const itemsPerPage = 10;
                        final start = (controller.inventoryPage.value - 1) * itemsPerPage + 1;
                        final end = (controller.inventoryPage.value * itemsPerPage) > totalItems ? totalItems : (controller.inventoryPage.value * itemsPerPage);
                        return Text(
                          "Showing $start-$end of $totalItems",
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey, fontWeight: FontWeight.bold),
                        );
                      }),
                      CustomPagination(currentPage: controller.inventoryPage, totalPages: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemDistribution(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Usage History (Stock Out)",
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: 400,
          height: 45,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: " Search usage history...",
              hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.grey),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(AppImages.search, width: 18, height: 18),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 1200),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - (Responsive.isDesktop(context) ? 360 : 64),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: _headerText("Item")),
                                  Expanded(flex: 2, child: _headerText("Issued To")),
                                  Expanded(flex: 2, child: _headerText("Department")),
                                  Expanded(flex: 2, child: _headerText("Items Count")),
                                  Expanded(flex: 2, child: _headerText("Issued Date")),
                                  if (vesselType == "Glass") Expanded(flex: 1, child: _headerText("Broken")),
                                  Expanded(flex: 2, child: _headerText("Status")),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                itemCount: 10,
                                separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.lightGrey),
                                itemBuilder: (context, index) {
                                  return _DistributionCard(
                                    item: index % 2 == 0 ? "Beaker 250ml" : "Flask (Conical)",
                                    person: "Researcher ${index + 1}",
                                    division: "$vesselType Lab",
                                    itemCount: "2 Items",
                                    isGlass: vesselType == "Glass",
                                    brokenCount: index % 5 == 0 ? "1" : "0",
                                    takenDate: "Apr 08, 2024",
                                    status: "In Use",
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.lightGrey)),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Obx(() {
                        const totalItems = 45;
                        const itemsPerPage = 10;
                        final start = (controller.inventoryPage.value - 1) * itemsPerPage + 1;
                        final end = (controller.inventoryPage.value * itemsPerPage) > totalItems ? totalItems : (controller.inventoryPage.value * itemsPerPage);
                        return Text(
                          "Showing $start-$end of $totalItems",
                          style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey, fontWeight: FontWeight.bold),
                        );
                      }),
                      CustomPagination(currentPage: controller.inventoryPage, totalPages: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : [],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? AppColors.primary : AppColors.grey),
            const SizedBox(width: 8),
            Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? AppColors.primary : AppColors.grey)),
          ],
        ),
      ),
    );
  }
}

class _IncomingCard extends StatefulWidget {
  final String item;
  final String date;
  final String count;
  final String source;

  const _IncomingCard({required this.item, required this.date, required this.count, required this.source});

  @override
  State<_IncomingCard> createState() => _IncomingCardState();
}

class _IncomingCardState extends State<_IncomingCard> {
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03), blurRadius: _isHovered ? 12 : 6, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(widget.item, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary))),
            Expanded(flex: 2, child: Text(widget.date, style: GoogleFonts.inter(color: AppColors.grey))),
            Expanded(flex: 2, child: Text(widget.count, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primary))),
            Expanded(flex: 2, child: Text(widget.source, style: GoogleFonts.inter(color: AppColors.grey, fontSize: 13))),
          ],
        ),
      ),
    );
  }
}

class _DistributionCard extends StatefulWidget {
  final String item;
  final String person;
  final String division;
  final String itemCount;
  final String takenDate;
  final String status;
  final bool isGlass;
  final String brokenCount;

  const _DistributionCard({
    required this.item,
    required this.person,
    required this.division,
    required this.itemCount,
    required this.takenDate,
    required this.status,
    this.isGlass = false,
    this.brokenCount = "0",
  });

  @override
  State<_DistributionCard> createState() => _DistributionCardState();
}

class _DistributionCardState extends State<_DistributionCard> {
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03), blurRadius: _isHovered ? 12 : 6, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(widget.item, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary))),
            Expanded(flex: 2, child: Text(widget.person, style: GoogleFonts.inter(color: AppColors.secondary))),
            Expanded(flex: 2, child: Text(widget.division, style: GoogleFonts.inter(color: AppColors.grey, fontSize: 13))),
            Expanded(flex: 2, child: Text(widget.itemCount, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primary))),
            Expanded(flex: 2, child: Text(widget.takenDate, style: GoogleFonts.inter(color: AppColors.grey))),
            if (widget.isGlass)
              Expanded(
                flex: 1,
                child: Text(
                  widget.brokenCount,
                  style: GoogleFonts.inter(
                    color: widget.brokenCount != "0" ? AppColors.error : AppColors.grey,
                    fontWeight: widget.brokenCount != "0" ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(widget.status, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
