import 'package:cloud_firestore/cloud_firestore.dart';

class HomeData {
	static Stream<QuerySnapshot> writingSnapshot(String classCode) {
		var _db = FirebaseFirestore.instance;
		return _db.collection('writing').where('classCode', isEqualTo: classCode).orderBy('created', descending: true).limit(5).snapshots();
	}

	static Stream<DocumentSnapshot> getUserData(String userId) {
		var _db = FirebaseFirestore.instance;
		return _db.collection('users').doc(userId).snapshots();
	}

	static Stream<QuerySnapshot> storySnapshot(String classCode) {
		var _db = FirebaseFirestore.instance;
		return _db.collection('story').where('classCode', isEqualTo: classCode).orderBy('created', descending: true).snapshots();
	}
}