import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
	static void createStory(String classCode, String userId, String text) {
		final _db = FirebaseFirestore.instance;
		_db.collection('story').doc().set({
			'classCode': classCode,
			'userId': userId,
			'text': text,
			'created': DateTime.now()
		});
	}

	static void createWriting(String classCode, String userId, String title, String text) {
		final _db = FirebaseFirestore.instance;
		_db.collection('writing').doc().set({
			'classCode': classCode,
			'userId': userId,
			'title': title,
			'text': text,
			'created': DateTime.now()
		});
	}

	static void addWritingPoints(int oldScore, String userId) {
		final _db = FirebaseFirestore.instance;
		int newScore = 75 + oldScore;
		_db.collection('users').doc(userId).set({
			'points': newScore,
		}, SetOptions(merge: true));
	} 
}
