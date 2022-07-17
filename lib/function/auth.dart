import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
final _db = FirebaseFirestore.instance;

class AuthService {
	static Future<AuthData> login(String email, String password) async {
		try {
			UserCredential result  = await _auth.signInWithEmailAndPassword(email: email, password: password);
			return AuthData(user: result);
		} catch (e) {
			return AuthData(message: e.message);
		}
	}

	static Future<AuthData> register(String email, String password, String name) async {
		try {
			UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
			await result.user.updateDisplayName(name);
			return AuthData(user: result);
		} catch (e) {
			return AuthData(message: e.message);
		}
	}

	static void addUserToDatabase(userId, classCode, displayName, type) {
		try {
			_db.collection('users').doc(userId).set({
				'displayName': displayName,
				'classCode': classCode,
				'type': type,
				'bio': "",
				'address': "",
				'photoURL': "",
				'points': 0
			});
		} catch (e) {
			print(e.toString());
		}
	}

}

class AuthData {
	final UserCredential user;
	final String message;

	AuthData({this.user, this.message});
}
