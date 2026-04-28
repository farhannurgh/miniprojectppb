import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report_model.dart';

class FirestoreService {
  FirestoreService._();

  static final CollectionReference<Map<String, dynamic>> _reports =
      FirebaseFirestore.instance.collection('reports');

  static Future<void> saveReport(ReportModel report) async {
    await _reports.doc(report.id).set(report.toMap());
  }

  static Stream<List<ReportModel>> userReports(String userId) {
    return _reports.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      final List<ReportModel> reports = snapshot.docs
          .map((doc) => ReportModel.fromDocument(doc))
          .toList();

      reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reports;
    });
  }
}
