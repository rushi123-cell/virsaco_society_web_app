import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../../../../common/widgets/custom_pagination.dart';
import '../dashboard_controller.dart';

class NotificationsView extends GetView<DashboardController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildNotificationsList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notifications Center",
          style: GoogleFonts.outfit(
            fontSize: Responsive.isMobile(context) ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Review all your recent society alerts, inventory requests, and leave updates.",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            separatorBuilder: (context, index) => const Divider(height: 32, color: AppColors.lightGrey),
            itemBuilder: (context, index) {
              return _NotificationItem(index: index);
            },
          ),
          const SizedBox(height: 16),
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
                  const totalItems = 35;
                  const itemsPerPage = 10;
                  final start = (controller.notificationsPage.value - 1) * itemsPerPage + 1;
                  final end = (controller.notificationsPage.value * itemsPerPage) > totalItems
                      ? totalItems
                      : (controller.notificationsPage.value * itemsPerPage);
                  return Text(
                    "Showing $start-$end of $totalItems",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
                CustomPagination(currentPage: controller.notificationsPage, totalPages: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final int index;

  const _NotificationItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = index < 3;
    final String type = _getType(index);
    final String title = _getTitle(index);
    final String time = _getTime(index);
    final IconData icon = _getIcon(index);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnread ? AppColors.primary.withOpacity(0.1) : AppColors.lightGrey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isUnread ? AppColors.primary : AppColors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      type,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isUnread ? AppColors.primary : AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey),
                    ),
                    if (isUnread) ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "NEW",
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
                    color: AppColors.secondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getType(int index) {
    if (index % 3 == 0) return "LEAVE REQUEST";
    if (index % 3 == 1) return "INVENTORY ALERT";
    return "SYSTEM UPDATE";
  }

  String _getTitle(int index) {
    if (index % 3 == 0) return "New Leave Request from Lab Assistant for Sick Leave.";
    if (index % 3 == 1) return "Low stock warning: A4 Paper Bundles dropped below 20 units.";
    return "Monthly database backup completed successfully.";
  }

  String _getTime(int index) {
    if (index == 0) return "2 mins ago";
    if (index == 1) return "15 mins ago";
    if (index == 2) return "1 hour ago";
    if (index == 3) return "4 hours ago";
    return "Yesterday";
  }

  IconData _getIcon(int index) {
    if (index % 3 == 0) return Icons.event_note_outlined;
    if (index % 3 == 1) return Icons.warning_amber_outlined;
    return Icons.system_security_update_good_outlined;
  }
}
