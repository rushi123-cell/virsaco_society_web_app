import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../values/app_colors.dart';

class CustomPagination extends StatelessWidget {
  final RxInt currentPage;
  final int totalPages;

  const CustomPagination({
    super.key,
    required this.currentPage,
    this.totalPages = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PaginationActionBtn(
            icon: Icons.chevron_left,
            onTap: () {
              if (currentPage.value > 1) currentPage.value--;
            },
            enabled: currentPage.value > 1,
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Obx(() => Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(totalPages, (index) {
                return _PageNumberBtn(
                  pageNum: index + 1,
                  isActive: currentPage.value == (index + 1),
                  onTap: () => currentPage.value = index + 1,
                );
              }),
            )),
          ),
          const SizedBox(width: 12),
          _PaginationActionBtn(
            icon: Icons.chevron_right,
            onTap: () {
              if (currentPage.value < totalPages) currentPage.value++;
            },
            enabled: currentPage.value < totalPages,
          ),
        ],
      ),
    );
  }
}

class _PaginationActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _PaginationActionBtn({
    required this.icon, 
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled ? AppColors.white : AppColors.lightGrey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled ? AppColors.lightGrey.withOpacity(0.5) : Colors.transparent,
          ),
          boxShadow: enabled ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : [],
        ),
        child: Icon(
          icon, 
          color: enabled ? AppColors.primary : AppColors.grey.withOpacity(0.3), 
          size: 22,
        ),
      ),
    );
  }
}

class _PageNumberBtn extends StatelessWidget {
  final int pageNum;
  final bool isActive;
  final VoidCallback onTap;

  const _PageNumberBtn({
    required this.pageNum,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isActive ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Text(
          "$pageNum",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? Colors.white : AppColors.secondary,
          ),
        ),
      ),
    );
  }
}
