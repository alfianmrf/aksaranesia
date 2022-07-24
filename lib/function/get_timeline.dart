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

	/*static Stream<QuerySnapshot> storyDetailSnapshot(String storyId) {
		var _db = FirebaseFirestore.instance;
		return _db.collection('story').doc(storyId).collection('comments').orderBy('created', descending: true).snapshots();
	}*/

	static Stream<DocumentSnapshot> storyDetailSnapshot(String storyId) {
		var _db = FirebaseFirestore.instance;
		return _db.collection('story').doc(storyId).snapshots();
	}
	
	static Stream<QuerySnapshot> storyCommentsSnapshot(String storyId) {
		var _db = FirebaseFirestore.instance;
		return _db.collection('storycomments').where('storyId', isEqualTo: storyId).orderBy('created', descending: false).snapshots();
	}

	static Stream<QuerySnapshot> storyLikeSnapshot(String userId, String storyId) {
		var _db = FirebaseFirestore.instance;
		return _db.collection('storylike').where('userId', isEqualTo: userId).where('storyId', isEqualTo: storyId).snapshots();
	}

  static Stream<QuerySnapshot> storyNotificationSnapshot(String ownerId) {
    var _db = FirebaseFirestore.instance;
    return _db.collection('notification').where('ownerId', isEqualTo: ownerId).orderBy('created', descending: true).snapshots();
  }

  static Future<bool> updateStatusReadNotification(String ownerId){
    var _db = FirebaseFirestore.instance;
    _db.collection('notification').where('ownerId', isEqualTo: ownerId).get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        _db.collection('notification').doc(doc.id).update({
          'read': true
        });
      });
    });
  }

	static Stream<QuerySnapshot> checkUnreadNotifications(String ownerId) {
		var _db = FirebaseFirestore.instance;
		return _db.collection('notification').where('ownerId', isEqualTo: ownerId).where('read', isEqualTo: false).snapshots();
	}
}