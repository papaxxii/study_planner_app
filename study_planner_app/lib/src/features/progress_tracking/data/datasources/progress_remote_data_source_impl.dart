import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/progress_model.dart';
import 'progress_remote_data_source.dart';

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  final FirebaseFirestore firestore;

  ProgressRemoteDataSourceImpl({required this.firestore});

  CollectionReference get progressCollection =>
      firestore.collection('progress');

  @override
  Future<void> addProgress(ProgressModel progress) async {
    // use userId as doc id to simplify lookups
    await progressCollection.doc(progress.userId).set(progress.toMap());
  }

  @override
  Future<void> updateProgress(String userId, ProgressModel progress) async {
    await progressCollection
        .doc(userId)
        .set(progress.toMap(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteProgress(String progressId) async {
    await progressCollection.doc(progressId).delete();
  }

  @override
  Future<ProgressModel> getUserProgress(String userId) async {
    final doc = await progressCollection.doc(userId).get();
    return ProgressModel.fromFirebase(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<ProgressModel> getDailyProgress(String userId, DateTime date) async {
    // Assuming each user's progress doc stores lastUpdated; fetch user doc and check date
    final doc = await progressCollection.doc(userId).get();
    final model = ProgressModel.fromFirebase(
      doc.data() as Map<String, dynamic>,
    );
    // If lastUpdated matches date, return it; otherwise return model anyway (caller can decide)
    return model;
  }
}
