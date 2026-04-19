import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/utils/responsive.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_toast.dart';

class AddStoreItemForm extends StatefulWidget {
  final String category;

  const AddStoreItemForm({super.key, required this.category});

  @override
  State<AddStoreItemForm> createState() => _AddStoreItemFormState();
}

class _AddStoreItemFormState extends State<AddStoreItemForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add New ${widget.category} Item",
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Fill the details below to add a new item into the stock.",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 32),
              _buildGridForm([
                CustomTextField(
                  hintText: "Enter item name",
                  labelText: "Item Name",
                ),
                CustomTextField(
                  hintText: "Enter quantity or count",
                  labelText: "Quantity",
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                  hintText: "Enter supplier or module source",
                  labelText: "Source / Supplier",
                ),
                CustomTextField(
                  hintText: "Select Date",
                  labelText: "Received Date",
                  controller: _dateController,
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      _dateController.text = "${date.day}/${date.month}/${date.year}";
                    }
                  },
                ),
              ]),
              const SizedBox(height: 24),
              CustomTextField(
                hintText: "Briefly explain condition, specifications, or usage...",
                labelText: "Notes & Specifications",
                maxLines: 4,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: Responsive.isMobile(context) ? double.infinity : 300,
                height: 56,
                child: CustomButton(
                  text: "Add Item to Stock",
                  onPressed: () {
                    CustomToast.showSuccess(
                      context,
                      "Item Added",
                      "${widget.category} Item added successfully into the inventory stock!",
                    );
                  },
                ),
              ),
            ],
          ),
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
}
