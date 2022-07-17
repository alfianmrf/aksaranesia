import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

	static Stream<QuerySnapshot> storyLikeSnapshot(String userId, String storyId) {
		var _db = FirebaseFirestore.instance;
		return _db.collection('storylike').where('userId', isEqualTo: userId).where('storyId', isEqualTo: storyId).snapshots();
	}

	static Future<bool> isStoryLike(String userId, String storyId) {
		var _db = FirebaseFirestore.instance;
		return _db.collection('storylike').where('userId', isEqualTo: userId).where('storyId', isEqualTo: storyId).get().then((snapshot) {
			if(snapshot.docs.isEmpty) {
				return false;
			}
			else {
				return true;
			}
		});
	}
}