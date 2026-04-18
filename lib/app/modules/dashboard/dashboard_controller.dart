import 'package:get/get.dart';

class DashboardController extends GetxController {
  final selectedIndex = 0.obs;

  // For Research Building Sub-sections
  final selectedResearchSubSection = 0.obs; // 0 for Staff, 1 for Store Room
  final selectedStoreCategory = "".obs; // e.g., "Stationary"
  
  // For Hostel Sub-sections
  final selectedHostelSubSection = 0.obs; // 0 for Atithi Gruh, 1 for Boys, 2 for Girls

  // Role simulation
  final isDirector = false.obs;

  // For Ground Management Sub-sections
  final selectedGroundSubSection = 0.obs; // 0: Field trial plot, 1: Poly house, 2: Net house, 3: Campus

  // For Leave Management Sub-sections
  final selectedLeaveSubSection = 0.obs; // 0: Apply Leave, 1: Leave Status/Approvals
  final selectedLeaveDate = "".obs;
  final isMultipleLeave = false.obs;
  final multipleSelectedDates = <DateTime>[].obs;

  // For Employee Management Sub-sections
  final selectedEmployeeSubSection = 0.obs; // 0: Employee List, 1: Add Employee
  final employeeCurrentPage = 1.obs;
  final employeesPerPage = 10;

  // For Stationary Sub-sections
  final selectedStationarySubSection = 0.obs; // 0: Stock In, 1: Stock Out
  final inventoryPage = 1.obs; // Shared for sub-sections to keep it simple or distinct if needed
  
  // Research Staff Pagination
  final researchStaffPage = 1.obs;

  // Dashboard Stats
  final onLeaveToday = 8.obs;
  final isLeaveListExpanded = true.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
    // Reset sub-sections when switching main sections
    if (index != 1) {
      selectedResearchSubSection.value = 0;
      selectedStoreCategory.value = "";
      selectedStationarySubSection.value = 0;
    }
    if (index != 2) selectedHostelSubSection.value = 0;
    if (index != 3) selectedGroundSubSection.value = 0;
    if (index != 5) {
      selectedLeaveSubSection.value = 0;
      resetLeaveForm();
    }
    if (index != 6) selectedEmployeeSubSection.value = 0;
  }

  void resetLeaveForm() {
    selectedLeaveDate.value = "";
    isMultipleLeave.value = false;
    multipleSelectedDates.clear();
  }

  bool addLeaveDate(DateTime date) {
    if (multipleSelectedDates.length >= 4) return false;
    if (!multipleSelectedDates.contains(date)) {
      multipleSelectedDates.add(date);
      return true;
    }
    return false;
  }

  void removeLeaveDate(DateTime date) {
    multipleSelectedDates.remove(date);
  }

  void changeEmployeeSubSection(int index) {
    selectedEmployeeSubSection.value = index;
    if (index == 0) employeeCurrentPage.value = 1;
  }

  void changeResearchSubSection(int index) {
    selectedResearchSubSection.value = index;
    if (index != 1) selectedStoreCategory.value = "";
  }

  void changeStoreCategory(String category) {
    selectedStoreCategory.value = category;
  }
  
  void changeHostelSubSection(int index) {
    selectedHostelSubSection.value = index;
  }

  void changeGroundSubSection(int index) {
    selectedGroundSubSection.value = index;
  }

  void changeLeaveSubSection(int index) {
    selectedLeaveSubSection.value = index;
  }

  void toggleRole() {
    isDirector.value = !isDirector.value;
  }

  void logout() {
    Get.offAllNamed('/login');
  }
}
