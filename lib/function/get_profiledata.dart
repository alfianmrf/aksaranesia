import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class ProfileData {
	static Stream<QuerySnapshot> getStatus() {
		FirebaseAuth _auth = FirebaseAuth.instance;
		FirebaseFirestore _db = FirebaseFirestore.instance;
		return _db.collection('story').where('userId', isEqualTo: _auth.currentUser.uid).orderBy('created', descending: true).snapshots();
	}

	static Stream<QuerySnapshot> getWriting() {
		FirebaseAuth _auth = FirebaseAuth.instance;
		FirebaseFirestore _db = FirebaseFirestore.instance;
		return _db.collection('writing').where('userId', isEqualTo: _auth.currentUser.uid).orderBy('created', descending: true).snapshots();
	}

	static Stream<QuerySnapshot> getStatusById(userId) {
		FirebaseAuth _auth = FirebaseAuth.instance;
		FirebaseFirestore _db = FirebaseFirestore.instance;
		return _db.collection('story').where('userId', isEqualTo: userId).orderBy('created', descending: true).snapshots();
	}

	static Stream<QuerySnapshot> getWritingById(userId) {
		FirebaseAuth _auth = FirebaseAuth.instance;
		FirebaseFirestore _db = FirebaseFirestore.instance;
		return _db.collection('writing').where('userId', isEqualTo: userId).orderBy('created', descending: true).snapshots();
	}

	static void deleteStatus(statusId) async {
		FirebaseFirestore _db = FirebaseFirestore.instance;
		return await _db.collection('story').doc(statusId).delete();
	}

	static Future<void> deleteWriting(writingId, points) {
		FirebaseFirestore _db = FirebaseFirestore.instance;
		FirebaseAuth _auth = FirebaseAuth.instance;
		_db.collection('users').doc(_auth.currentUser.uid).set({
			'points': points - 75,
		}, SetOptions(merge: true));
		return _db.collection('writing').doc(writingId).delete();
	}
}