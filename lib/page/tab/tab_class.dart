import 'package:aks/ui/elements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:aks/model/user_model.dart";
import "package:provider/provider.dart";
import 'package:aks/function/get_classdata.dart';
import "package:aks/page/view_profile.dart";


class TabClass extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		UserData user = context.watch<UserNotifier>().user;
		return Column(
			children: [
				Container(
					width: double.infinity,
					height: 150,
					decoration: BoxDecoration(
						gradient: LinearGradient(
							colors: [
								accent,
								Theme.of(context).scaffoldBackgroundColor,
							],
							begin: const FractionalOffset(0.0, 0.0),
							end: const FractionalOffset(0.0, 2.0),
							stops: [0.0, 1.0],
							tileMode: TileMode.clamp,
						),
					),
					child: Column(
					  children: [
					    Expanded(
					      child: Padding(
									padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
					        child: Row(
					        	children: [
					        		AspectRatio(
												aspectRatio: 1.4,
												child: Image.asset("assets/images/classUI.png", fit: BoxFit.fitWidth),
											),
					        		SizedBox(width: 15),
					        		Expanded(
					        			child: Padding(
					        			  padding: EdgeInsets.symmetric(vertical: 15),
					        			  child: Column(
													crossAxisAlignment: CrossAxisAlignment.start,
					        			  	children: [
					        			  		Text(
															user.classCode ?? '',
															style: TextStyle(
																color: primary,
																fontWeight: FontWeight.bold,
																fontSize: 18,
															),
														),
														StreamBuilder<QuerySnapshot>(
																stream: ClassData.getTeacher(user.classCode),
																builder: (context, teacher) {
																	if(teacher.data == null || teacher.data.docs.length <= 0) {
																		return Text("-", style: TextStyle(color: primary));
																	} else {
																		var teachers = teacher.data.docs;
																		return Text(teachers[0]['displayName'], style: TextStyle(color: primary));
																	}
																}
														),
					        			  	]
					        			  ),
					        			)
					        		),
					        	]
					        ),
					      ),
					    ),
							Container(
								width: double.infinity,
								height: 20,
								decoration: BoxDecoration(
									color: Theme.of(context).scaffoldBackgroundColor,
									borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
								),
							),
					  ],
					)
				),
				Expanded(
					child: StreamBuilder<QuerySnapshot>(
					  stream: ClassData.getClassMate(user.classCode),
					  builder: (context, classmate) {
					  	if(classmate.data == null || classmate.data.docs.length <= 0) {
					  		return Container();
					  	} else {
					  		var classmates = classmate.data.docs;
					  		return ListView.builder(
					  			itemCount: classmates.length,
					  			itemBuilder: (context, index) {
					  				return ListTile(
					  					onTap: () => Navigator.push(context, MaterialPageRoute(
					  						builder: (context) {
					  							return ViewProfile(
					  								classmates[index].id,
					  								classmates[index]['photoURL'],
					  								classmates[index]['points'],
					  								classmates[index]['bio'],
					  								classmates[index]['displayName'],
														classmates[index]['classCode'],
					  							);
					  						}
					  					)),
					  					contentPadding: EdgeInsets.symmetric(horizontal:15, vertical: 0),
					  					leading: Padding(
					  					  padding: EdgeInsets.only(bottom: 15),
					  					  child: CircleAvatar(
					              backgroundColor: Colors.grey,
					              radius: 20,
					              child: ClipOval(
					                child: classmates[index]['photoURL'] == '' ?
					                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
					                :
					                  FadeInImage(image: NetworkImage(classmates[index]['photoURL']), placeholder: AssetImage('assets/images/user.png')),
					              ),
					            ),
					  					),
					            title: Padding(
					              padding: EdgeInsets.only(bottom: 5),
					              child: Text(classmates[index]['displayName'], style: TextStyle(fontWeight: FontWeight.bold)),
					            ),
					            subtitle: Text(classmates[index]['type'] == 0 ? 'Murid' : 'Guru'),
					            trailing: user.type == 1 ? Container(
					              child: Wrap(
					              	crossAxisAlignment: WrapCrossAlignment.center,
					              	spacing: 10,
					              	children: [
					              		Image.asset('assets/images/medal.png', height: 20),
					              		Text("${classmates[index]['points']} pts", style: TextStyle(fontSize: 15)),
					              	],
					              ),
					            ) :
					            SizedBox(),
					  				);
					  			},
						    );
					  	}
					  }
					),
				)
			],
		);
	}
}