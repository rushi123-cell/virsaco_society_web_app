import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../dashboard_controller.dart';
import '../../../../common/widgets/custom_pagination.dart';

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
            ElevatedButton.icon(
              onPressed: () => _showAddWorkerDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add Worker"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 16),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: controller.getGroundWorkersStream(),
              builder: (context, snapshot) {
                final total = snapshot.data?.length ?? 0;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Total: $total",
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                );
              }
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Worker Table
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: controller.getGroundWorkersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Text("No workers assigned yet.", style: GoogleFonts.inter(color: AppColors.grey)),
              );
            }
            final workers = snapshot.data!;
            return SingleChildScrollView(
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
                        itemCount: workers.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final worker = workers[index];
                          return _WorkerCard(
                            name: worker['name'] ?? '',
                            shift: worker['shift'] ?? '',
                            checkIn: worker['checkInTime'] ?? '',
                            status: worker['status'] ?? 'On Duty',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ],
    );
  }

  Widget _buildItemsSection(BuildContext context, String sectionTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Tools & Materials ($sectionTitle)",
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _showAddStockDialog(context, controller.selectedGroundStockSubSection.value == 0),
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add Stock"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 16),
            _buildStockSubNav(),
          ],
        ),
        const SizedBox(height: 24),
        Obx(() {
          return controller.selectedGroundStockSubSection.value == 0
              ? _buildStockIn(context)
              : _buildStockOut(context);
        }),
      ],
    );
  }

  Widget _buildStockSubNav() {
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
              isSelected: controller.selectedGroundStockSubSection.value == 0,
              onTap: () => controller.selectedGroundStockSubSection.value = 0,
            ),
            _SubNavItem(
              title: "Stock Out",
              isSelected: controller.selectedGroundStockSubSection.value == 1,
              onTap: () => controller.selectedGroundStockSubSection.value = 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockIn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getGroundStockInStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: Text("No stock in records.", style: GoogleFonts.inter(color: AppColors.grey)),
            );
          }
          
          final items = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 800),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Column(
                          children: [
                            _GroundStockInCard(
                              item: item['itemName'] ?? '',
                              date: item['receivedDate'] ?? '',
                              qty: item['quantity'] ?? '',
                              source: item['source'] ?? '',
                            ),
                            if (index < items.length - 1) const Divider(height: 1, color: AppColors.lightGrey),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildStockOut(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getGroundStockOutStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: Text("No stock out records.", style: GoogleFonts.inter(color: AppColors.grey)),
            );
          }
          
          final items = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 1000),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - (Responsive.isDesktop(context) ? 360 : 64),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Column(
                          children: [
                            _ItemCard(
                              detail: item['itemDetail'] ?? '',
                              issueDate: item['issueDate'] ?? '',
                              deliveryDate: item['deliveryDate'] ?? '',
                              takenDate: item['takenDate'] ?? '',
                              status: item['status'] ?? 'Pending',
                            ),
                            if (index < items.length - 1) const Divider(height: 1, color: AppColors.lightGrey),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
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

  void _showAddWorkerDialog(BuildContext context) {
    final nameController = TextEditingController();
    final shiftController = TextEditingController(text: 'Morning');
    final checkInController = TextEditingController(text: '08:00 AM');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Worker"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Worker Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: shiftController,
              decoration: const InputDecoration(labelText: "Shift (e.g. Morning, Evening)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: checkInController,
              decoration: const InputDecoration(labelText: "Check-in Time", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.addGroundWorker({
                  'name': nameController.text.trim(),
                  'shift': shiftController.text.trim(),
                  'checkInTime': checkInController.text.trim(),
                  'status': 'On Duty',
                  'createdAt': DateTime.now().toIso8601String(),
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showAddStockDialog(BuildContext context, bool isStockIn) {
    final nameController = TextEditingController();
    final dateController = TextEditingController();
    final qtyOrStatusController = TextEditingController();
    final sourceOrDetailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isStockIn ? "Add Stock In" : "Add Stock Out"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: isStockIn ? "Item Name" : "Item Detail",
                border: const OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: isStockIn ? "Received Date (e.g. Apr 10, 2024)" : "Issue Date",
                border: const OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: qtyOrStatusController,
              decoration: InputDecoration(
                labelText: isStockIn ? "Quantity" : "Status (Pending/Completed)",
                border: const OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: sourceOrDetailController,
              decoration: InputDecoration(
                labelText: isStockIn ? "Source" : "Taken Date",
                border: const OutlineInputBorder()
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                if (isStockIn) {
                  controller.addGroundStockIn({
                    'itemName': nameController.text.trim(),
                    'receivedDate': dateController.text.trim(),
                    'quantity': qtyOrStatusController.text.trim(),
                    'source': sourceOrDetailController.text.trim(),
                    'createdAt': DateTime.now().toIso8601String(),
                  });
                } else {
                  controller.addGroundStockOut({
                    'itemDetail': nameController.text.trim(),
                    'issueDate': dateController.text.trim(),
                    'status': qtyOrStatusController.text.trim(),
                    'takenDate': sourceOrDetailController.text.trim(),
                    'deliveryDate': dateController.text.trim(), // Simplification
                    'createdAt': DateTime.now().toIso8601String(),
                  });
                }
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text("Add"),
          ),
        ],
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


class _GroundStockInCard extends StatefulWidget {
  final String item;
  final String date;
  final String qty;
  final String source;

  const _GroundStockInCard({
    required this.item,
    required this.date,
    required this.qty,
    required this.source,
  });

  @override
  State<_GroundStockInCard> createState() => _GroundStockInCardState();
}

class _GroundStockInCardState extends State<_GroundStockInCard> {
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
            Expanded(flex: 3, child: Text(widget.source, style: GoogleFonts.inter(color: AppColors.grey))),
          ],
        ),
      ),
    );
  }
}


