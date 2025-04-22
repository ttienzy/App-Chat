import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f1/models/project_progress.dart';

Stream<List<ProjectProgress>> watchProjectProgresses() {
  return FirebaseFirestore.instance
      .collection('projects')
      .snapshots()
      .map(
        (snap) =>
            snap.docs.map((doc) => ProjectProgress.fromFirestore(doc)).toList(),
      );
}
