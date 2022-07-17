import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitData {
	final _auth = FirebaseAuth.instance;
	final _db = FirebaseFirestore.instance;

	Future<DocumentSnapshot> getData() async {
		DocumentSnapshot dbValue = await _db.collection('users').doc(_auth.currentUser.uid).get();
		return dbValue;
	}
}