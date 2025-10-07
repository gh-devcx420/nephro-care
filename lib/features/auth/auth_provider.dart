import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser) {
    _initializeAuthState();
  }

  void _initializeAuthState() {
    // FIXED: Use idTokenChanges() instead of authStateChanges()
    // idTokenChanges() only fires when the ID token is ready and valid
    // This ensures Firestore security rules will recognize the user
    FirebaseAuth.instance.idTokenChanges().listen((user) {
      if (kDebugMode) {
        print('ID token changed: ${user?.uid ?? "null"}');
      }
      state = user;
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (kDebugMode) {
          print('Google sign-in cancelled by user');
        }
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (kDebugMode) {
        print('Successfully signed in: ${userCredential.user?.uid}');
      }

      // No artificial delay needed - idTokenChanges() handles it
      state = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Error: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with Google: $e');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      if (kDebugMode) {
        print('Signing out user: ${state?.uid}');
      }

      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      state = null;

      if (kDebugMode) {
        print('Sign out complete');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      rethrow;
    }
  }

  bool get isAuthenticated => state != null;

  String? get currentUserId => state?.uid;
}
