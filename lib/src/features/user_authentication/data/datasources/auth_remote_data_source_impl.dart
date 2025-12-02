import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userId = result.user!.uid;
    final userDoc = await firestore.collection('users').doc(userId).get();
    if (!userDoc.exists || userDoc.data() == null) {
      throw Exception('User document not found after login');
    }
    return UserModel.fromFirebase(userDoc.data()!, userDoc.id);
  }

  @override
  Future<UserModel> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userId = result.user!.uid;
    final userModel = UserModel(
      id: userId,
      name: name,
      email: email,
      role: UserRole.client,
      profileImageUrl: null,
    );

    // Create user document in Firestore
    await firestore.collection('users').doc(userId).set(userModel.toMap());
    // Also create an initial progress document for the new user
    try {
      await firestore.collection('progress').doc(userId).set({
        'userId': userId,
        'totalTasks': 0,
        'completedTasks': 0,
        'completionRate': 0.0,
        'currentStreakDays': 0,
        'lastUpdated': Timestamp.now(),
      });
    } catch (_) {
      // Non-fatal: if progress creation fails, we'll still return the user model
    }
    return userModel;
  }

  @override
  Future<UserModel> getUserProfile(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('User profile not found');
    }
    return UserModel.fromFirebase(doc.data()!, doc.id);
  }

  @override
  Future<void> logoutUser() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await firestore
        .collection('users')
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }
}
