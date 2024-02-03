import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // This method's name remains unchanged as it does not conflict.
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Renamed method to avoid overloading
  Future<bool> signInWithEmailAndPasswordAndHandleError(String email, String password, void Function(FirebaseAuthException e) errorCallback) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      return false;
    }
  }

  // Method to sign up with email and password, with error handling
  Future<bool> createUserWithEmailAndPassword(String email, String password, void Function(FirebaseAuthException e) errorCallback) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
      return false;
    }
  }

  // Method to sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Method to check if the user is already signed in
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Method to initialize the user authentication state
  void initAuth(void Function(User? user) onAuthStateChanged) {
    _auth.authStateChanges().listen(onAuthStateChanged);
  }
}
