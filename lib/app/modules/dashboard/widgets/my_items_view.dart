import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../dashboard_controller.dart';
import '../../../../common/widgets/custom_pagination.dart';

class MyItemsView extends GetView<DashboardController> {
  const MyItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Items",
                    style: GoogleFonts.outfit(
                      fontSize: Responsive.isMobile(context) ? 22 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    "Track items you have taken, returned, or broken",
                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: _buildItemsTable(context),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTable(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 40),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Item History",
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search item name or status...",
                    hintStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.grey),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: _headerText("Item Detail")),
                Expanded(flex: 2, child: _headerText("Module Source")),
                Expanded(flex: 2, child: _headerText("Issue Date")),
                Expanded(flex: 2, child: _headerText("Return Date")),
                Expanded(flex: 2, child: _headerText("Status")),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final status = ["Returned", "Pending", "Broken", "Returned"][index];
                return _ItemRow(
                  detail: ["Laptop (Dell XPS)", "Safety Helmet", "Glass Beakers", "ID Badge"][index],
                  source: ["Stationary", "Ground Mgmt", "Research Bldg", "Admin"][index],
                  issueDate: "Apr ${10 - index}, 2024",
                  returnDate: status == "Pending" ? "-" : "Apr ${15 - index}, 2024",
                  status: status,
                );
              },
            ),
          ),
        ],
      ),
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

class _ItemRow extends StatelessWidget {
  final String detail;
  final String source;
  final String issueDate;
  final String returnDate;
  final String status;

  const _ItemRow({
    required this.detail,
    required this.source,
    required this.issueDate,
    required this.returnDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (status == "Returned") statusColor = AppColors.success;
    else if (status == "Broken") statusColor = AppColors.error;
    else statusColor = AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(detail, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary))),
          Expanded(flex: 2, child: Text(source, style: GoogleFonts.inter(color: AppColors.grey))),
          Expanded(flex: 2, child: Text(issueDate, style: GoogleFonts.inter(color: AppColors.grey))),
          Expanded(flex: 2, child: Text(returnDate, style: GoogleFonts.inter(color: AppColors.grey))),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
