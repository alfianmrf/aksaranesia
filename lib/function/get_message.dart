import "package:cloud_firestore/cloud_firestore.dart";

class Message {
	static Future<String> retrieveMessageId(myId, opponentId) async {
		String id;
		final _db = FirebaseFirestore.instance;
		DocumentSnapshot<dynamic> value = await _db.collection('chat').doc("$opponentId:$myId").get();
		if(value.exists) {
			id = "$opponentId:$myId";
		} else {
			id = "$myId:$opponentId";
		}
		return id;
	}

	static Stream<QuerySnapshot> getMessageData(messageId) {
		final _db = FirebaseFirestore.instance;
		return _db.collection('chat').doc(messageId).collection("messages").orderBy('timestamp', descending: true).snapshots();
	}

	static void send(text, opponentId, myId, messageId) {
		final _db = FirebaseFirestore.instance;
		_db.collection('chat').doc(messageId).set({
      "users": [
        myId,
        opponentId
      ]
    }, SetOptions(merge: true));

    _db.collection('chat').doc(messageId).collection('messages').add({
      "message": text,
      "sender": myId,
      "timestamp": DateTime.now()
    });
	}

	static Stream<QuerySnapshot> getListChat(myId) {
		final _db = FirebaseFirestore.instance;
		return _db.collection('chat').where('users', arrayContains: myId).snapshots();
	}

	static String getOpponentId(List<dynamic> users, myId) {
    String id;
    users.forEach((opponentId) {
      if(opponentId != myId) {
        id = opponentId;
      }
    });
    return id;
  }

  static Stream<QuerySnapshot> getLastMessage(messageId) {
  	final _db = FirebaseFirestore.instance;
  	return _db.collection('chat').doc(messageId).collection('messages').orderBy('timestamp', descending: true).limit(1).snapshots();
  }
}