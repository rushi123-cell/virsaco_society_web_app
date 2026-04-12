import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../dashboard_controller.dart';

class StationaryView extends GetView<DashboardController> {
  const StationaryView({super.key});

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
                Icons.edit_note,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(width: 20),
              Text(
                "Stationary Management",
                style: GoogleFonts.outfit(
                  fontSize: Responsive.isMobile(context) ? 22 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIncomingItems(context),
                  const SizedBox(height: 48),
                  _buildItemDistribution(context),
                ],
              ),
            ),
          ),
        ],
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
                        Expanded(flex: 3, child: _headerText("Item Name")),
                        Expanded(flex: 2, child: _headerText("Received Date")),
                        Expanded(flex: 2, child: _headerText("Quantity")),
                        Expanded(flex: 2, child: _headerText("Source/Vendor")),
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
                      return _IncomingCard(
                        item: index == 0 ? "A4 Paper Bundles" : (index == 1 ? "Blue Pens (Box)" : "Calculators"),
                        date: "Apr ${10 - index}, 2024",
                        qty: "${(index + 1) * 10} Units",
                        source: "Virsaco Supplies Ltd",
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

  Widget _buildItemDistribution(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Item Usage & Returns (Stock Out)",
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
                        Expanded(flex: 2, child: _headerText("Item")),
                        Expanded(flex: 2, child: _headerText("Taken By")),
                        Expanded(flex: 2, child: _headerText("Taken Date")),
                        Expanded(flex: 2, child: _headerText("Return Date")),
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
                      return _DistributionCard(
                        item: index % 2 == 0 ? "Projector" : "Whiteboard Markers",
                        person: "Staff Member ${index + 1}",
                        takenDate: "Apr 05, 2024",
                        returnDate: index % 3 == 0 ? "Pending" : "Apr 08, 2024",
                        status: index % 3 == 0 ? "Issued" : "Returned",
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

class _IncomingCard extends StatefulWidget {
  final String item;
  final String date;
  final String qty;
  final String source;

  const _IncomingCard({
    required this.item,
    required this.date,
    required this.qty,
    required this.source,
  });

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
          color: _isHovered ? AppColors.secondary.withOpacity(0.05) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? AppColors.secondary.withOpacity(0.3) : Colors.transparent,
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
            Expanded(flex: 3, child: Text(widget.item, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary))),
            Expanded(flex: 2, child: Text(widget.date, style: GoogleFonts.inter(color: AppColors.grey))),
            Expanded(flex: 2, child: Text(widget.qty, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primary))),
            Expanded(flex: 2, child: Text(widget.source, style: GoogleFonts.inter(color: AppColors.grey))),
          ],
        ),
      ),
    );
  }
}

class _DistributionCard extends StatefulWidget {
  final String item;
  final String person;
  final String takenDate;
  final String returnDate;
  final String status;

  const _DistributionCard({
    required this.item,
    required this.person,
    required this.takenDate,
    required this.returnDate,
    required this.status,
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
            Expanded(flex: 2, child: Text(widget.item, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary))),
            Expanded(flex: 2, child: Text(widget.person, style: GoogleFonts.inter(color: AppColors.secondary))),
            Expanded(flex: 2, child: Text(widget.takenDate, style: GoogleFonts.inter(color: AppColors.grey))),
            Expanded(
              flex: 2,
              child: Text(
                widget.returnDate,
                style: GoogleFonts.inter(
                  color: widget.returnDate == "Pending" ? AppColors.error : AppColors.grey,
                  fontWeight: widget.returnDate == "Pending" ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (widget.status == "Returned" ? AppColors.success : AppColors.warning).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.status == "Returned" ? AppColors.success : AppColors.warning,
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
