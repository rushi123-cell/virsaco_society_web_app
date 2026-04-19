import 'package:firebase_core/firebase_core.dart';
// TODO: Uncomment these imports AFTER generating your config files with FlutterFire CLI!
import '../../firebase_options_test.dart' as test_env;
import '../../firebase_options_prod.dart' as prod_env;

enum Environment { test, prod }

class EnvConfig {
  /// Reads the --dart-define=ENV flag passed during build/run. Default is 'test'.
  static const String _envString = String.fromEnvironment('ENV', defaultValue: 'test');

  static Environment get currentEnvironment {
    return _envString == 'prod' ? Environment.prod : Environment.test;
  }

  /// Returns the correct Firebase options based on the active environment.
  static FirebaseOptions get currentFirebaseOptions {
    switch (currentEnvironment) {
      case Environment.prod:
        return prod_env.DefaultFirebaseOptions.currentPlatform;
      case Environment.test:
      default:
        return test_env.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
