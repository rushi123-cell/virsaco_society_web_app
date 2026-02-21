import 'package:get/get.dart';

class DashboardController extends GetxController {
  final selectedIndex = 0.obs;

  // For Research Building Sub-sections
  final selectedResearchSubSection = 0.obs; // 0 for Staff, 1 for Store Room
  
  // For Hostel Sub-sections
  final selectedHostelSubSection = 0.obs; // 0 for Atithi Gruh, 1 for Boys, 2 for Girls

  void changeIndex(int index) {
    selectedIndex.value = index;
    // Reset sub-sections when switching main sections
    if (index != 0) selectedResearchSubSection.value = 0;
    if (index != 1) selectedHostelSubSection.value = 0;
  }

  void changeResearchSubSection(int index) {
    selectedResearchSubSection.value = index;
  }
  
  void changeHostelSubSection(int index) {
    selectedHostelSubSection.value = index;
  }

  void logout() {
    Get.offAllNamed('/login');
  }
}
