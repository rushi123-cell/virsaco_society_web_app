import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/values/app_colors.dart';
import 'privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600, 
            color: Colors.white, 
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Header filling the top space
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.shield_outlined, size: 40, color: Colors.white),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Data Privacy & Security',
                            style: GoogleFonts.outfit(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'We are committed to protecting your personal information and your right to privacy. This document outlines how we collect, use, and safeguard your data within the VIRSACO platform.',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (MediaQuery.of(context).size.width > 800) ...[
                       const SizedBox(width: 48),
                       Icon(Icons.admin_panel_settings_outlined, size: 160, color: Colors.white.withOpacity(0.15)),
                       const SizedBox(width: 48),
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Responsive Grid/Wrap to fill horizontal space
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate dynamic width to create 2 columns on large screens
                  double spacing = 24;
                  int columns = constraints.maxWidth > 900 ? 2 : 1;
                  double cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      _buildGridCard(
                        width: cardWidth,
                        number: '01',
                        title: 'Information Collection',
                        content: 'The Application may collect and process personal information necessary for society management functionality. This includes names, contact details, and residential unit information to manage resident profiles, facilitate communication, and handle administrative tasks.',
                      ),
                      _buildGridCard(
                        width: cardWidth,
                        number: '02',
                        title: 'Location Data',
                        content: 'This Application does not collect precise information about the location of your mobile device or computer. We only track actions related to your apartment or community facilities as entered by you.',
                      ),
                      _buildGridCard(
                        width: cardWidth,
                        number: '03',
                        title: 'Third-Party Access',
                        content: 'We do not sell or trade your personally identifiable information to outside parties. We may only disclose User Provided Information as required by law (e.g., subpoena) or when we believe disclosure is necessary to protect rights, safety, or investigate fraud.',
                      ),
                      _buildGridCard(
                        width: cardWidth,
                        number: '04',
                        title: 'Data Retention',
                        content: 'We will retain User Provided data for as long as you use the Application and for a reasonable time thereafter to ensure smooth operation of society administration. If you wish to delete your data, please contact your society admin.',
                      ),
                      _buildGridCard(
                        width: cardWidth,
                        number: '05',
                        title: 'Security Measures',
                        content: 'We are concerned about safeguarding the confidentiality of your information. We provide robust physical, electronic, and procedural safeguards to protect information we process and maintain against unauthorized access or disclosure.',
                      ),
                      _buildGridCard(
                        width: cardWidth,
                        number: '06',
                        title: 'Policy Updates',
                        content: 'This Privacy Policy may be updated from time to time for any reason. You are advised to consult this Privacy Policy regularly for any changes, as continued use is deemed approval of all changes.',
                      ),
                      _buildGridCard(
                        // Make the final contact card full width
                        width: constraints.maxWidth,
                        number: '07',
                        title: 'Contact Information',
                        content: 'If you have any questions regarding privacy while using the Application, or have questions about our practices, please contact us via email at info@virsaco.com. We are always here to help clarify our data practices.',
                        isFullWidth: true,
                      ),
                    ],
                  );
                }
              ),
              const SizedBox(height: 48),
              Center(
                child: Text(
                  '© ${DateTime.now().year} VIRSACO. All rights reserved.',
                  style: GoogleFonts.inter(
                    color: AppColors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard({
    required double width,
    required String number,
    required String title,
    required String content,
    bool isFullWidth = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                number,
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary.withOpacity(0.15),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.black.withOpacity(0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
