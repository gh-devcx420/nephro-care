import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthNotifier extends StateNotifier<User?> {
  // Constructor
  AuthNotifier() : super(FirebaseAuth.instance.currentUser) {
    _initializeAuthState();
  }

  // Public business logic methods
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
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

      state = userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      final userPhotoUrl = state?.photoURL;
      if (userPhotoUrl != null) {
        await CachedNetworkImage.evictFromCache(userPhotoUrl);
      }
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      state = null;
    } catch (e) {
      rethrow;
    }
  }

  // Initialization methods (like lifecycle methods)
  void _initializeAuthState() {
    FirebaseAuth.instance.idTokenChanges().listen((user) {
      state = user;
    });
  }

  // Getters at the end
  bool get isAuthenticated => state != null;

  String? get currentUserId => state?.uid;
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});
