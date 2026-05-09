import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
  }
}
