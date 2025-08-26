import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns the current user if logged in
  User? get currentUser => _auth.currentUser;

  /// Returns the UID of the current user
  String? get uid => _auth.currentUser?.uid;

  /// Returns the email of the current user
  String? get email => _auth.currentUser?.email;

  /// Checks if a user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  /// Stream to listen for auth state changes
  Stream<User?> get userChanges => _auth.authStateChanges();

  /// Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Optional: Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  /// Optional: Register with email and password
  Future<User?> register(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }
}
