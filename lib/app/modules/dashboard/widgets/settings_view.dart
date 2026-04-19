import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../common/values/app_colors.dart';
import '../../../../common/widgets/custom_toast.dart';
import '../dashboard_controller.dart';

class SettingsView extends GetView<DashboardController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(color: AppColors.background),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildSecuritySection(context),
                      const SizedBox(height: 24),
                      _buildDataBackupSection(context),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: _buildOrganizationConfigSection(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Settings & Preferences",
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Manage your account security and organization metrics.",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return _buildCard(
      title: "Security & Account",
      icon: Icons.shield_outlined,
      children: [
        _SettingsRow(
          icon: Icons.lock_outline,
          title: "Change Password",
          subtitle: "Update your current login password",
          actionText: "Update",
          onTap: () => _showChangePasswordDialog(context),
        ),
        const Divider(height: 32, color: AppColors.lightGrey),
        _SettingsRow(
          icon: Icons.devices_outlined,
          title: "Session Management",
          subtitle: "Signed in on Chrome (MacOS) and 1 other device",
          actionText: "Log out all",
          isDestructive: true,
          onTap: () => _showLogoutSessionsDialog(context),
        ),
      ],
    );
  }

  Widget _buildDataBackupSection(BuildContext context) {
    return _buildCard(
      title: "Data & Backup",
      icon: Icons.cloud_download_outlined,
      children: [
        _SettingsRow(
          icon: Icons.file_download_outlined,
          title: "Export Organization Logs",
          subtitle: "Download all inventory and employee data as CSV",
          actionText: "Export CSV",
          onTap: () => CustomToast.showSuccess(context, "Exporting Data", "Check your downloads folder shortly."),
        ),
        const Divider(height: 32, color: AppColors.lightGrey),
        _SettingsRow(
          icon: Icons.backup_outlined,
          title: "Database Backup",
          subtitle: "Last backup was successfully completed 2 days ago",
          actionText: "Backup Now",
          onTap: () => CustomToast.showSuccess(context, "Backup Started", "Securing your latest metrics to the cloud."),
        ),
      ],
    );
  }

  Widget _buildOrganizationConfigSection(BuildContext context) {
    return _buildCard(
      title: "Organization Configuration",
      icon: Icons.business_outlined,
      children: [
        _SettingsRow(
          icon: Icons.policy_outlined,
          title: "Global Leave Policy",
          subtitle: "Set default CL and PL allocations for new hires",
          actionText: "Edit Quotas",
          onTap: () => _showGlobalLeavePolicyDialog(context),
        ),
        const Divider(height: 32, color: AppColors.lightGrey),
        _SettingsRow(
          icon: Icons.badge_outlined,
          title: "Role & Department Editor",
          subtitle: "Manage job titles and departmental access rights",
          actionText: "Manage Roles",
          onTap: () => _showRoleEditorDialog(context),
        ),
        const Divider(height: 32, color: AppColors.lightGrey),
        _SettingsRow(
          icon: Icons.view_module_outlined,
          title: "Module Toggles",
          subtitle: "Enable or disable distinct side modules",
          actionText: "Configure",
          onTap: () => _showModuleTogglesDialog(context),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Change Password", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.secondary)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Current Password", isPassword: true),
                const SizedBox(height: 16),
                _buildTextField("New Password", isPassword: true),
                const SizedBox(height: 16),
                _buildTextField("Confirm New Password", isPassword: true),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                CustomToast.showSuccess(context, "Password Updated", "Your password has been changed successfully.");
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text("Update Password", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutSessionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Log out all other sessions?", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.error)),
          content: Text("This will aggressively terminate any connected sessions on browsers or devices other than this one.", style: GoogleFonts.inter(color: AppColors.grey)),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                CustomToast.showSuccess(context, "Sessions Terminated", "All other sessions have been successfully logged out.");
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text("Revoke Sessions", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showGlobalLeavePolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Global Leave Quotas", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.secondary)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Annual Casual Leaves (CL)", initialValue: "18"),
                const SizedBox(height: 16),
                _buildTextField("Annual Paid Leaves (PL)", initialValue: "12"),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                CustomToast.showSuccess(context, "Policies Updated", "New leave allocations applied globally.");
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text("Save Settings", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showRoleEditorDialog(BuildContext context) {
    final roles = ["Admin", "Director", "Senior Researcher", "Lab Assistant", "Staff"];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Manage Roles", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.secondary)),
              IconButton(onPressed: () => _showEditRoleDialog(context, ""), icon: const Icon(Icons.add_circle, color: AppColors.primary)),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: roles.map((role) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(role, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary)),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.edit_outlined, color: AppColors.grey, size: 18),
                      onPressed: () => _showEditRoleDialog(context, role),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Close", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.grey)),
            ),
          ],
        );
      },
    );
  }

  void _showEditRoleDialog(BuildContext context, String currentRole) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(currentRole.isEmpty ? "Add New Role" : "Edit Role", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.secondary)),
          content: SizedBox(
            width: 350,
            child: _buildTextField("Role Name", initialValue: currentRole),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                CustomToast.showSuccess(context, currentRole.isEmpty ? "Role Created" : "Role Updated", "The role has been successfully saved.");
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text("Save", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showModuleTogglesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Module Configuration", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.secondary)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSwitchRow("Research Building UI", true),
                _buildSwitchRow("Hostel Management", true),
                _buildSwitchRow("Ground Management", true),
                _buildSwitchRow("Employee Check-in Tracking", false),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                CustomToast.showSuccess(context, "Modules Updated", "Dashboard modules reconfigured successfully.");
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text("Save", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, {bool isPassword = false, String initialValue = ""}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.secondary, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: isPassword,
          initialValue: initialValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.lightGrey)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.lightGrey)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(String label, bool initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: AppColors.secondary)),
          Switch(
            value: initialValue,
            onChanged: (val) {},
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  State<_SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<_SettingsRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(widget.icon, color: AppColors.grey, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: GoogleFonts.inter(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isDestructive
                    ? (_isHovered ? AppColors.error : AppColors.error.withOpacity(0.1))
                    : (_isHovered ? AppColors.primary : AppColors.primary.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.actionText,
                style: GoogleFonts.inter(
                  color: widget.isDestructive
                      ? (_isHovered ? Colors.white : AppColors.error)
                      : (_isHovered ? Colors.white : AppColors.primary),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
