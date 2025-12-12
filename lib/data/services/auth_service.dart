import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth. currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get user role from Firestore
  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'] ?? 'user';
      }
      return 'user';
    } catch (e) {
      if (kDebugMode) print('Error getting user role: $e');
      return 'user';
    }
  }

  // Check if current user is admin
  Future<bool> isAdmin() async {
    if (currentUser == null) return false;
    final role = await getUserRole(currentUser!.uid);
    return role == 'admin';
  }

  // Get user model from Firestore
  Future<UserModel? > getUserModel(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel. fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('Error getting user model: $e');
      return null;
    }
  }

  // Get current user model
  Future<UserModel?> getCurrentUserModel() async {
    if (currentUser == null) return null;
    return getUserModel(currentUser!.uid);
  }

  // Sign up with email and password
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String displayName,
    String role = 'user',
  }) async {
    try {
      // Create user with Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password:  password,
      );

      User? user = result.user;

      if (user != null) {
        // Update display name
        await user.updateDisplayName(displayName);

        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'displayName': displayName,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'photoUrl': null,
          'phoneNumber': null,
        });

        if (kDebugMode) print('✅ User created:  $email ($role)');

        return {'success': true, 'user': user};
      }

      return {'success': false, 'message': 'Failed to create user'};
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('❌ Sign up error: ${e.code}');
      return {
        'success': false,
        'message': _getErrorMessage(e. code),
      };
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) print('✅ User signed in: $email');

      return {'success': true, 'user':  result.user};
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('❌ Sign in error: ${e.code}');
      return {
        'success': false,
        'message': _getErrorMessage(e. code),
      };
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      if (kDebugMode) print('✅ User signed out');
    } catch (e) {
      if (kDebugMode) print('❌ Sign out error: $e');
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String?  photoUrl,
    String? phoneNumber,
  }) async {
    try {
      if (currentUser == null) return false;

      Map<String, dynamic> updates = {};

      if (displayName != null) {
        await currentUser!.updateDisplayName(displayName);
        updates['displayName'] = displayName;
      }

      if (photoUrl != null) {
        await currentUser!.updatePhotoURL(photoUrl);
        updates['photoUrl'] = photoUrl;
      }

      if (phoneNumber != null) {
        updates['phoneNumber'] = phoneNumber;
      }

      if (updates.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .update(updates);
      }

      if (kDebugMode) print('✅ Profile updated');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Update profile error: $e');
      return false;
    }
  }

  // Change password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (currentUser == null) {
        return {'success': false, 'message': 'No user signed in'};
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: currentUser! .email!,
        password: currentPassword,
      );

      await currentUser!.reauthenticateWithCredential(credential);

      // Update password
      await currentUser! .updatePassword(newPassword);

      if (kDebugMode) print('✅ Password changed');
      return {'success': true};
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('❌ Change password error: ${e.code}');
      return {
        'success': false,
        'message': _getErrorMessage(e. code),
      };
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Send password reset email
  Future<Map<String, dynamic>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (kDebugMode) print('✅ Password reset email sent');
      return {'success': true};
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('❌ Password reset error: ${e.code}');
      return {
        'success':  false,
        'message': _getErrorMessage(e.code),
      };
    }
  }

  // Delete account
  Future<Map<String, dynamic>> deleteAccount(String password) async {
    try {
      if (currentUser == null) {
        return {'success': false, 'message': 'No user signed in'};
      }

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: currentUser!.email! ,
        password: password,
      );

      await currentUser! .reauthenticateWithCredential(credential);

      // Delete Firestore document
      await _firestore.collection('users').doc(currentUser!.uid).delete();

      // Delete user account
      await currentUser!.delete();

      if (kDebugMode) print('✅ Account deleted');
      return {'success': true};
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('❌ Delete account error: ${e. code}');
      return {
        'success': false,
        'message': _getErrorMessage(e.code),
      };
    } catch (e) {
      if (kDebugMode) print('❌ Unexpected error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // Get all users (admin only)
  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Get users by role (admin only)
  Stream<List<UserModel>> getUsersByRole(String role) {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: role)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot. docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Update user role (admin only)
  Future<bool> updateUserRole(String uid, String newRole) async {
    try {
      await _firestore.collection('users').doc(uid).update({'role': newRole});
      if (kDebugMode) print('✅ User role updated:  $uid -> $newRole');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Update role error: $e');
      return false;
    }
  }

  // Delete user (admin only)
  Future<bool> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      if (kDebugMode) print('✅ User deleted: $uid');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ Delete user error: $e');
      return false;
    }
  }

  // Get error message from Firebase error code
  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password is too weak';
      case 'email-already-in-use':
        return 'An account already exists for this email';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'The email address is invalid';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'invalid-credential':
        return 'Invalid credentials provided';
      case 'requires-recent-login':
        return 'Please sign in again to continue';
      default:
        return 'An error occurred:  $code';
    }
  }
}