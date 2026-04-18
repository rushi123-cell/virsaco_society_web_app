import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/utils/app_images.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/custom_button.dart';
import '../dashboard_controller.dart';
import '../../../../common/widgets/custom_pagination.dart';

class EmployeeManagementView extends GetView<DashboardController> {
  const EmployeeManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_outline, color: AppColors.primary, size: 32),
              const SizedBox(width: 20),
              Text(
                "Employee Management",
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
              return controller.selectedEmployeeSubSection.value == 0
                  ? const EmployeeListView()
                  : const AddEmployeeView();
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
              title: "Employee List",
              icon: Icons.list,
              isSelected: controller.selectedEmployeeSubSection.value == 0,
              onTap: () => controller.changeEmployeeSubSection(0),
            ),
            _SubNavItem(
              title: "Add Employee",
              icon: Icons.person_add,
              isSelected: controller.selectedEmployeeSubSection.value == 1,
              onTap: () => controller.changeEmployeeSubSection(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubNavItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubNavItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.primary : AppColors.grey,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeListView extends GetView<DashboardController> {
  const EmployeeListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated data
    final totalEmployees = 45;
    final totalPages = (totalEmployees / controller.employeesPerPage).ceil();

    return Column(
      children: [
        // Top Toolbar (Search and Filters)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search employee by name, ID or post...",
                      hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.grey),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(AppImages.search, color: AppColors.primary, width: 18, height: 18),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildIconButton(Icons.filter_list, "Filter"),
              const SizedBox(width: 12),
              _buildIconButton(Icons.download, "Export"),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Main Table Card
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
                // Custom Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      _headerCell("FULL NAME", 2),
                      _headerCell("MOBILE", 2),
                      _headerCell("JOB TITLE", 2),
                      _headerCell("POST", 2),
                      _headerCell("EMAIL", 3),
                      _headerCell("ACTIONS", 1),
                    ],
                  ),
                ),
                // Table Rows
                Expanded(
                  child: ListView.separated(
                    itemCount: 10,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.lightGrey),
                    itemBuilder: (context, index) {
                      final empId = (controller.employeeCurrentPage.value - 1) * 10 + index + 1;
                      return _EmployeeRow(empId: empId);
                    },
                  ),
                ),
                // Integrated Pagination (More compact)
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
                      Obx(() => Text(
                        "Showing ${(controller.employeeCurrentPage.value - 1) * 10 + 1}-${(controller.employeeCurrentPage.value * 10) > totalEmployees ? totalEmployees : (controller.employeeCurrentPage.value * 10)} of $totalEmployees",
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey, fontWeight: FontWeight.bold),
                      )),
                      CustomPagination(currentPage: controller.employeeCurrentPage, totalPages: totalPages),
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

  Widget _headerCell(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 10),
            Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.secondary, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _EmployeeRow extends StatefulWidget {
  final int empId;
  const _EmployeeRow({required this.empId});

  @override
  State<_EmployeeRow> createState() => _EmployeeRowState();
}

class _EmployeeRowState extends State<_EmployeeRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: _isHovered ? AppColors.primary.withOpacity(0.02) : Colors.transparent,
        child: Row(
          children: [
            Expanded(flex: 2, child: Text("Employee ${widget.empId}", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary))),
            Expanded(flex: 2, child: Text("+91 98765 43210", style: GoogleFonts.inter(color: AppColors.grey, fontSize: 13))),
            Expanded(flex: 2, child: Text("Senior Researcher", style: GoogleFonts.inter(color: AppColors.grey, fontSize: 13))),
            Expanded(flex: 2, child: Text("Management", style: GoogleFonts.inter(color: AppColors.grey, fontSize: 13))),
            Expanded(flex: 3, child: Text("employee${widget.empId}@virsaco.com", style: GoogleFonts.inter(color: AppColors.grey, fontSize: 13))),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18), onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AddEmployeeView extends StatefulWidget {
  const AddEmployeeView({super.key});

  @override
  State<AddEmployeeView> createState() => _AddEmployeeViewState();
}

class _AddEmployeeViewState extends State<AddEmployeeView> {
  String? selectedGender;
  String selectedFileName = "No file chosen";
  final TextEditingController _birthdateController = TextEditingController();

  @override
  void dispose() {
    _birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Details",
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary),
            ),
            const SizedBox(height: 16),
            _buildGridForm([
              CustomTextField(
                hintText: "Enter full name",
                labelText: "Full Name",
              ),
              CustomTextField(
                hintText: "Enter age",
                labelText: "Age",
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                hintText: "Select Birthdate",
                labelText: "Birthdate",
                controller: _birthdateController,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _birthdateController.text = "${date.day}/${date.month}/${date.year}";
                  }
                },
              ),
              _buildGenderDropdown(),
            ]),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: "Enter full home address",
              labelText: "Home Address",
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Text(
              "Professional Details",
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary),
            ),
            const SizedBox(height: 16),
            _buildGridForm([
              CustomTextField(
                hintText: "Enter job title",
                labelText: "Job Title",
              ),
              CustomTextField(
                hintText: "Enter post",
                labelText: "Post",
              ),
              CustomTextField(
                hintText: "Enter email address",
                labelText: "Email ID",
              ),
              CustomTextField(
                hintText: "Enter password",
                labelText: "Password",
                isPassword: true,
              ),
            ]),
            const SizedBox(height: 16),
            _buildGridForm([
              CustomTextField(
                hintText: "Mobile Number 1",
                labelText: "Primary Mobile",
              ),
              CustomTextField(
                hintText: "Mobile Number 2",
                labelText: "Alternate Mobile",
              ),
            ]),
            const SizedBox(height: 24),
            Text(
              "Documents",
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondary),
            ),
            const SizedBox(height: 16),
            _buildFileUpload(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: CustomButton(
                text: "Register Employee",
                onPressed: () {
                  Get.snackbar("Success", "Employee added effectively", backgroundColor: AppColors.success, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridForm(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 800 ? 2 : 1;
        double aspectRatio = constraints.maxWidth > 800 ? 6.5 : 4.2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 24,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
          children: children,
        );
      },
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.secondary),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 52, // Explicit height for dropdown box alignment
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGender,
                    hint: Text("Select Gender", style: GoogleFonts.inter(color: AppColors.grey, fontSize: 14)),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                    items: ["Male", "Female", "Other"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: 15, color: AppColors.black)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() => selectedGender = newValue);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFileUpload() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: AppColors.primary, size: 32),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Upload Identity Proof", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                Text("PDF, PNG or JPG (Max 5MB)", style: GoogleFonts.inter(color: AppColors.grey, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => selectedFileName = "id_proof.pdf");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(selectedFileName == "No file chosen" ? "Choose File" : "id_proof.pdf"),
          ),
        ],
      ),
    );
  }
}
