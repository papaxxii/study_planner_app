import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_user_model.dart';
import 'admin_user_remote_data_source.dart';

class AdminUserRemoteDataSourceImpl implements AdminUserRemoteDataSource {
  final FirebaseFirestore firestore;

  AdminUserRemoteDataSourceImpl({required this.firestore});

  CollectionReference get userCollection => firestore.collection('users');

  @override
  @override
  Future<List<AdminUserModel>> getAllUsers() async {
    final snapshot = await userCollection.get();
    return snapshot.docs
        .map(
          (doc) => AdminUserModel.fromFirebase(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }

  @override
  Future<AdminUserModel> getUserDetails(String userId) async {
    final doc = await userCollection.doc(userId).get();
    return AdminUserModel.fromFirebase(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );
  }

  @override
  Future<void> updateUserRole(String userId, String role) async {
    await userCollection.doc(userId).update({'role': role});
  }

  @override
  Future<void> deleteUserAccount(String userId) async {
    await userCollection.doc(userId).delete();
  }
}
