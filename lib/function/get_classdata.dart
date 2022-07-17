import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassData {
	static Stream<QuerySnapshot> getTeacher(classCode) {
		final _db = FirebaseFirestore.instance;
		return _db.collection('users').where('classCode', isEqualTo: classCode).where('type', isEqualTo: 1).limit(1).snapshots();
	}

	static Stream<QuerySnapshot> getClassMate(classCode) {
		final _db = FirebaseFirestore.instance;
		return _db.collection('users').where('classCode', isEqualTo: classCode).snapshots();
	}
}