import 'package:aks/function/get_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
	static void createStory(String classCode, String userId, String text) {
		final _db = FirebaseFirestore.instance;
		_db.collection('story').doc().set({
			'classCode': classCode,
			'userId': userId,
			'text': text,
			'likes': 0,
			'comments': 0,
			'created': DateTime.now()
		});
	}

	static void createStoryLike(String userId, String storyId, String ownerId,{bool isMySelf = false}) {
		final _db = FirebaseFirestore.instance;

		// check if userId has liked storyId
		_db.collection('storylike').where('userId', isEqualTo: userId).where('storyId', isEqualTo: storyId).get().then((snapshot) {
			// if not, create new like
			if(snapshot.docs.isEmpty) {
				// incrementing like count
				_db.collection('story').doc(storyId).update({
					'likes': FieldValue.increment(1)
				});

				// storing like data
				_db.collection('storylike').doc().set({
					'userId': userId,
					'storyId': storyId,
					'created': DateTime.now()
				});
 
        // creating notification
        if(!isMySelf) {
          createStoryNotification(userId, storyId, ownerId, 'memberikan suka di status kamu');
        }
        
			}
			// if yes, delete the like
			else {
				// decrementing like count
				_db.collection('story').doc(storyId).update({
					'likes': FieldValue.increment(-1)
				});

				// deleting like data
				_db.collection('storylike').doc(snapshot.docs.first.id).delete();
			}
		});
	}

	static void createStoryComment(String userId, String storyId, String ownerId, String text, {bool isMySelf = false}) {
		final _db = FirebaseFirestore.instance;

		_db.collection('story').doc(storyId).update({
			'comments': FieldValue.increment(1)
		});

		// storing comment data
		_db.collection('storycomments').doc().set({
			'userId': userId,
			'storyId': storyId,
			'text': text,
			'created': DateTime.now()
		});

    // creating notification
    if(!isMySelf) {
      createStoryNotification(userId, storyId, ownerId, 'mengomentari status kamu');
    }
	}

  static void createStoryNotification(String userId, String storyId, String ownerId, String text) {
    final _db = FirebaseFirestore.instance;

    _db.collection('notification').doc().set({
      'userId': userId,
      'storyId': storyId,
      'ownerId': ownerId,
      'text': text,
      'read' : false,
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
