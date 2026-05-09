import 'package:get/get.dart';
import 'login_controller.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
