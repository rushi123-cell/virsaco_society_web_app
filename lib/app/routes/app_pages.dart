import 'package:get/get.dart';
import '../modules/auth/login/login_view.dart';
import '../modules/auth/login/login_binding.dart';
import '../modules/auth/signup/signup_view.dart';
import '../modules/auth/signup/signup_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/auth/forgot_password/forgot_password_view.dart';
import '../modules/profile/profile_view.dart';
import '../modules/profile/profile_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
