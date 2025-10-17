
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

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
    return UserModel.fromFirebase(userDoc.data()!, userDoc.id);
  }

  @override
  Future<UserModel> getUserProfile(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
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
