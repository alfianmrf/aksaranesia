import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewWriting extends StatelessWidget {
	ViewWriting({this.id});

	final _db = FirebaseFirestore.instance;
	final String id;
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				leading: IconButton(
					icon: Icon(Icons.close),
					onPressed: () => Navigator.of(context).pop(),
				),
				elevation: 0,
			),
			body: StreamBuilder<DocumentSnapshot>(
				stream: _db.collection('writing').doc(id).snapshots(),
				builder: (context, snapshot){
					if(snapshot.data == null) {
						return SizedBox();
					} else {
						var data = snapshot.data;
						return Padding(
						  padding: const EdgeInsets.symmetric(horizontal: 15),
						  child: Column(
						  	children: [
						  		Expanded(
						  		  child: ListView(
						  		    children: [
						  		    	Text(data["title"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
						  					SizedBox(height: 20),
						  		      Text(data["text"]),
						  		    ],
						  		  ),
						  		),
						  	]
						  ),
						);
					}
				},
			)
		);
	}
}
