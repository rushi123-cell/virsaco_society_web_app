part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const PROFILE = _Paths.PROFILE;
  
  // Dashboard Sections
  static const RESEARCH_BUILDING = _Paths.RESEARCH_BUILDING;
  static const HOSTEL = _Paths.HOSTEL;
  static const GROUND_MANAGEMENT = _Paths.GROUND_MANAGEMENT;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const DASHBOARD = '/dashboard';
  static const PROFILE = '/profile';
  
  static const RESEARCH_BUILDING = '/research-building';
  static const HOSTEL = '/hostel';
  static const GROUND_MANAGEMENT = '/ground-management';
}
