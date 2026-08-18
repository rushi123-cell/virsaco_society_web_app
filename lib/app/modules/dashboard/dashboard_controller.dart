import 'package:get/get.dart';

import '../profile/profile_view.dart';
import '../profile/profile_binding.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../../common/widgets/custom_toast.dart';

class DashboardController extends GetxController {
  final selectedIndex = 0.obs;

  // For Research Building Sub-sections
  final selectedResearchSubSection = 0.obs; // 0 for Staff, 1 for Store Room
  final selectedStoreCategory = "".obs; // e.g., "Stationary"
  
  // For Hostel Sub-sections
  final selectedHostelSubSection = 0.obs; // 0 for Atithi Gruh, 1 for Boys, 2 for Girls

  // Role simulation
  final isDirector = false.obs;
  final isEmployee = false.obs;

  // For Ground Management Sub-sections
  final selectedGroundSubSection = 0.obs; // 0: Field trial plot, 1: Poly house, 2: Net house, 3: Campus
  final selectedGroundStockSubSection = 0.obs; // 0 for Stock In, 1 for Stock Out
  final groundStockPage = 1.obs;

  // For Leave Management Sub-sections
  final selectedLeaveSubSection = 0.obs; // 0: Apply Leave, 1: Leave Status/Approvals
  final selectedLeaveDate = "".obs;
  final isMultipleLeave = false.obs;
  final multipleSelectedDates = <DateTime>[].obs;

  // For Employee Management Sub-sections
  final selectedEmployeeSubSection = 0.obs; // 0: Employee List, 1: Add Employee
  final employeeCurrentPage = 1.obs;
  final employeesPerPage = 10;
  final isLoadingEmployees = false.obs;
  final isRegisteringEmployee = false.obs;

  // For Stationary Sub-sections
  final selectedStationarySubSection = 0.obs; // 0: Stock In, 1: Stock Out
  final inventoryPage = 1.obs; // Shared for sub-sections to keep it simple or distinct if needed
  
  // Research Staff Pagination
  final researchStaffPage = 1.obs;

  // Dashboard Stats
  final totalStaff = 0.obs;
  final onLeaveToday = 0.obs;
  final presentToday = 0.obs;
  final pendingTasks = 0.obs;
  
  final isLeaveListExpanded = true.obs;
  final leaveListPage = 1.obs;

  // Logged in User Data
  final currentUserName = "User".obs;
  final currentUserRole = "Member".obs;

  // For Notifications
  final notificationsPage = 1.obs;

  void changeIndex(int index) {
    if (index == 7) {
      Get.to(() => const ProfileView(), binding: ProfileBinding());
      return;
    }
    selectedIndex.value = index;
    // Reset sub-sections when switching main sections
    if (index != 1) {
      selectedResearchSubSection.value = 0;
      selectedStoreCategory.value = "";
      selectedStationarySubSection.value = 0;
    }
    if (index != 2) selectedHostelSubSection.value = 0;
    if (index != 3) {
      selectedGroundSubSection.value = 0;
      selectedGroundStockSubSection.value = 0;
      groundStockPage.value = 1;
    }
    if (index != 5) {
      selectedLeaveSubSection.value = 0;
      resetLeaveForm();
    }
    if (index != 6) selectedEmployeeSubSection.value = 0;
  }

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStats();
    fetchCurrentUserData();
  }

  void fetchCurrentUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      final doc = await _firestoreService.getDocument('users', user.uid);
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        currentUserName.value = data['fullName'] ?? "User";
        currentUserRole.value = data['post'] ?? "Member";
      }
    }
  }

  void fetchDashboardStats() async {
    // This could be optimized with Firestore aggregations or a separate stats doc
    _firestoreService.getCollectionStream('users').listen((snapshot) {
      totalStaff.value = snapshot.docs.length;
      // For now, let's say 'present' is everyone who isn't explicitly on leave
      // In a real app, you'd check a 'leaves' collection
    });
    
    // Simulate some stats for now if leave collection doesn't exist yet, 
    // but try to fetch if possible.
    onLeaveToday.value = 0; 
    presentToday.value = totalStaff.value;
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

  final _authService = Get.find<AuthService>();
  final _firestoreService = Get.find<FirestoreService>();

  Stream<List<Map<String, dynamic>>> getEmployeesStream() {
    return _firestoreService.getCollectionStream('users').map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> registerEmployee({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    isRegisteringEmployee.value = true;
    try {
      final credential = await _authService.signUpWithEmail(email, password);
      if (credential != null) {
        final now = DateTime.now().toIso8601String();
        await _firestoreService.setDocument('users', credential.user!.uid, {
          ...userData,
          'uid': credential.user!.uid,
          'createdAt': now,
          'updatedAt': now,
        });
        
        CustomToast.showSuccess("Success", "Employee registered successfully!");
        changeEmployeeSubSection(0); // Go back to list
      }
    } catch (e) {
      CustomToast.showError("Error", "Failed to register employee: $e");
    } finally {
      isRegisteringEmployee.value = false;
    }
  }

  String get currentGroundSectionName {
    switch (selectedGroundSubSection.value) {
      case 0: return "Field Trial Plot";
      case 1: return "Poly House";
      case 2: return "Net House";
      case 3: return "Campus";
      default: return "Field Trial Plot";
    }
  }

  Stream<List<Map<String, dynamic>>> getGroundWorkersStream() {
    return _firestoreService.getCollectionStream('ground_workers').map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .where((data) => data['groundSection'] == currentGroundSectionName)
          .toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getGroundStockInStream() {
    return _firestoreService.getCollectionStream('ground_stock_in').map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .where((data) => data['groundSection'] == currentGroundSectionName)
          .toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getGroundStockOutStream() {
    return _firestoreService.getCollectionStream('ground_stock_out').map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .where((data) => data['groundSection'] == currentGroundSectionName)
          .toList();
    });
  }

  Future<void> addGroundWorker(Map<String, dynamic> data) async {
    await _firestoreService.addDocument('ground_workers', {
      ...data,
      'groundSection': currentGroundSectionName,
    });
    CustomToast.showSuccess('Success', 'Worker added successfully');
  }

  Future<void> addGroundStockIn(Map<String, dynamic> data) async {
    await _firestoreService.addDocument('ground_stock_in', {
      ...data,
      'groundSection': currentGroundSectionName,
    });
    CustomToast.showSuccess('Success', 'Stock In added successfully');
  }

  Future<void> addGroundStockOut(Map<String, dynamic> data) async {
    await _firestoreService.addDocument('ground_stock_out', {
      ...data,
      'groundSection': currentGroundSectionName,
    });
    CustomToast.showSuccess('Success', 'Stock Out added successfully');
  }

  void logout() async {
    await _authService.signOut();
    Get.offAllNamed('/login');
  }
}
