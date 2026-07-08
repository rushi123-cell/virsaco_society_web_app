import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import '../../common/widgets/custom_toast.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> _firebaseUser = Rx<User?>(null);

  bool _isInitialState = true;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
    
    _firebaseUser.listen((user) {
      if (_isInitialState) {
        _isInitialState = false;
        if (user != null) {
          Get.offAllNamed('/dashboard');
        }
      } else {
        if (user == null && Get.currentRoute != '/login') {
          Get.offAllNamed('/login');
        }
      }
    });
  }


  Stream<User?> get userStream => _auth.authStateChanges();

  User? get currentUser => _firebaseUser.value;

  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      // Create a secondary app instance to avoid logging out the current admin
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );
      
      UserCredential credential = await FirebaseAuth.instanceFor(app: secondaryApp)
          .createUserWithEmailAndPassword(email: email, password: password);
          
      // Clean up the secondary app
      await secondaryApp.delete();
      
      return credential;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      CustomToast.showError('Error', 'An unexpected error occurred');
      return null;
    }
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return null;
    } catch (e) {
      CustomToast.showError('Error', 'An unexpected error occurred');
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      CustomToast.showSuccess('Success', 'Password reset email sent!');
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      CustomToast.showError('Error', 'An unexpected error occurred');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message = 'Authentication failed';
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email.';
        break;
      case 'wrong-password':
        message = 'Incorrect password.';
        break;
      case 'invalid-email':
        message = 'The email address is badly formatted.';
        break;
      case 'user-disabled':
        message = 'This user has been disabled.';
        break;
      default:
        message = e.message ?? message;
    }
    CustomToast.showError('Error', message);
  }
}
