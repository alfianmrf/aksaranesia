import 'package:aks/ui/elements.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import "package:aks/function/get_profiledata.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:readmore/readmore.dart";
import "package:aks/page/chat_page.dart";
import "package:aks/page/view_writing.dart";

class ViewProfile extends StatefulWidget {
	@override
	ViewProfile(this.userId, this.photoURL, this.points, this.bio, this.displayName, this.classCode);
	final String userId, photoURL, bio, displayName, classCode;
	final int points;
	_ViewProfile createState() => _ViewProfile();
}

class _ViewProfile extends State<ViewProfile> with SingleTickerProviderStateMixin {
	TabController _controller;
	FirebaseAuth _auth = FirebaseAuth.instance;

	@override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				elevation: 0,
				title: Text(
					widget.displayName,
					style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge.color),
				),
      ),
		  body: Column(
		  	children: [
		  		Container(
		  			width: double.infinity,
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
		  			    Row(
		  			    	mainAxisAlignment: MainAxisAlignment.spaceBetween,
		  			    	crossAxisAlignment: CrossAxisAlignment.start,
		  			      children: [
		  			        Expanded(
		  			          child: Padding(
												padding: EdgeInsets.all(15),
		  			            child: Row(
		  			            	crossAxisAlignment: CrossAxisAlignment.start,
		  			            	children: [
		  			            		CircleAvatar(
		  		              backgroundColor: Colors.grey,
		  		              radius: 35,
		  		              child: ClipOval(
		  		                child: widget.photoURL == "" ?
		  		                  FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
		  		                :
		  		                  FadeInImage(image: NetworkImage(widget.photoURL), placeholder: AssetImage('assets/images/user.png')),
		  		              ),
		  			                ),
		  			                SizedBox(width: 20),
		  			                Expanded(
		  			                  child: Column(
		  			                  	crossAxisAlignment: CrossAxisAlignment.start,
		  			                  	children: [
		  			                  		Text(
																		widget.displayName,
																		style: TextStyle(
																			color: primary,
																			fontWeight: FontWeight.bold,
																			fontSize: 18,
																		),
																	),
																	Text(widget.classCode, style: TextStyle(color: primary, fontSize: 16)),
		  			                  		Text((widget.bio == "" || widget.bio == null) ? "-" : widget.bio, style: TextStyle(color: primary)),
		  			                  	]
		  			                  ),
		  			                ),
		  			            	]
		  			            ),
		  			          ),
		  			        ),
		  			        Padding(
											padding: EdgeInsets.only(right: 30, bottom: 15),
		  			          child: Column(
		  			          	children: [
													Image.asset('assets/images/medal.png', height: 60),
													Text(widget.points.toString(), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
		  			          	],
		  			          ),
		  			        )
		  			      ],
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
		  			),
		  		),
					Container(
						margin: EdgeInsets.symmetric(horizontal: 15),
						padding: EdgeInsets.all(5),
						decoration: BoxDecoration(
							color: Colors.grey[300],
							borderRadius: BorderRadius.circular(25),
						),
						child: TabBar(
							controller: _controller,
							indicator: BubbleTabIndicator(
								tabBarIndicatorSize: TabBarIndicatorSize.tab,
								indicatorHeight: 35,
								indicatorColor: primary,
							),
							unselectedLabelColor: Colors.black,
							labelColor: Colors.white,
							labelStyle: TextStyle(
								fontWeight: FontWeight.bold,
								fontFamily: Theme.of(context).textTheme.titleLarge.fontFamily,
							),
							tabs: [
								Tab(child: Text("Status")),
								Tab(child: Text("Tulisan")),
								Tab(child: Text("Buku")),
							],
						),
					),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                Column(
                	children: [
                		StreamBuilder<QuerySnapshot>(
                		  stream: ProfileData.getStatusById(widget.userId),
                		  builder: (context, status) {
                		    if(status.data == null) {
                		    	return SizedBox(
                		    		width: double.infinity,
                						height: 2,
                						child: LinearProgressIndicator(minHeight: 2)
                					);
                		    } else {
                		    	var statuses = status.data.docs;
                		    	if(statuses.length <= 0) {
                		    		return Expanded(
                		    		  child: Center(
                		    		  	child: Column(
                		    		  		mainAxisAlignment: MainAxisAlignment.center,
                		    		  		children: [
                		    		  			Image.asset("assets/images/empty.png", width: 200),
                		    		  			Text("Wah belum ada status nih...")
                		    		  		]
                		    		  	)
                		    		  ),
                		    		);
                		    	} else {
                		    		return Expanded(
                		    		  child: ListView.builder(
																itemCount: statuses.length,
																padding: EdgeInsets.only(top: 15, left: 15, right: 15),
																itemBuilder: (context, index) {
																	DateTime date = statuses[index]['created'].toDate();
																	return Slidable(
																		actionPane: SlidableDrawerActionPane(),
																		actionExtentRatio: 0.25,
																		child: Container(
																			decoration: BoxDecoration(
																				color: Colors.white,
																				borderRadius: BorderRadius.circular(10),
																			),
																			padding: EdgeInsets.all(12),
																			margin: EdgeInsets.only(bottom: 15),
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						width: 40,
																						height: 40,
																						child: widget.photoURL == "" ?
																							FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png')) :
																							FadeInImage(image: NetworkImage(widget.photoURL), placeholder: AssetImage('assets/images/user.png')),
																					),
																					SizedBox(width: 10),
																					Expanded(
																						child: Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								SizedBox(height: 5),
																								Row(
																								  children: [
																								    Expanded(
																								      child: Text(
																								      	widget.displayName,
																								      	style: TextStyle(
																								      		fontWeight: FontWeight.bold,
																								      		fontSize: 16,
																								      	),
																								      ),
																								    ),
																										Text(
																											"${date.day}/${date.month}/${date.year}",
																											style: TextStyle(fontSize: 12, color: primary.withOpacity(0.5)),
																										),
																								  ],
																								),
																								SizedBox(height: 5),
																								ReadMoreText(
																									"${statuses[index]['text']}",
																									colorClickableText: Colors.blue.withOpacity(0.7),
																									trimMode: TrimMode.Line,
																									trimLines: 3,
																									trimCollapsedText: "...Lanjutkan Membaca",
																									trimExpandedText: "\n\nCiutkan",
																									delimiter: "",
																								),
																							],
																						),
																					),
																				],
																			),
																		),
																	);
																},
															),
                		    		);
                		    	}
                		    }
                		  }
                		)
                	],
                ),
                Column(
                	children: [
                		StreamBuilder<QuerySnapshot>(
                			stream: ProfileData.getWritingById(widget.userId),
                			builder: (context, write) {
                				if(write.data == null) {
                					return SizedBox(
                						width: double.infinity,
                						height: 2,
                						child: LinearProgressIndicator(minHeight: 2)
                					);
            						} else {
              							var writes = write.data.docs;
              							if(writes.length <= 0) {
              								return Expanded(
              								  child: Center(
		                  		    			child: Column(
		                  		    				mainAxisAlignment: MainAxisAlignment.center,
		                  		    				children: [
	                		    					Image.asset("assets/images/empty.png", width: 200),
	                		    					Text("Wah belum ada tulisan nih...")
	                		    				]
	                		    			)
                		    			),
              							);
          								} else {
          									return Expanded(
          									  child: ListView.separated(
          									  	separatorBuilder: (context, index) => SizedBox(height:5),
          									  	itemCount: writes.length,
          									  	padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          									  	itemBuilder: (context, index) {
          									  		return ListTile(
          									  			onTap: () => Navigator.push(context, MaterialPageRoute(
          									  				builder: (context) => ViewWriting(id: writes[index].id)
          									  			)),
	  														  	tileColor: Theme.of(context).cardColor,
	  														  	leading: CircleAvatar(
	  													        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
	  													        child: Icon(Icons.book_outlined),
	  													        foregroundColor: Theme.of(context).primaryColor,
	  													      ),
	  													      title: Text(writes[index]["title"]),
	  													      subtitle: Text(widget.displayName),
	  														  );
        									  	},
        									  ),
        									);
        								}
          						}
              			}
              		)
              	],
              ),
								Column(
									children: [
										StreamBuilder<QuerySnapshot>(
												stream: ProfileData.getBookRead(widget.userId),
												builder: (context, book) {
													if(book.connectionState == ConnectionState.waiting) {
														return SizedBox(
																width: double.infinity,
																height: 2,
																child: LinearProgressIndicator(minHeight: 2)
														);
													} else {
														var books = book.data.docs;
														if(books.length <= 0) {
															return Expanded(
																child: Center(
																		child: Column(
																				mainAxisAlignment: MainAxisAlignment.center,
																				children: [
																					Image.asset("assets/images/empty.png", width: 200),
																					Text("Wah belum ada buku yang dibaca nih...")
																				]
																		)
																),
															);
														} else {
															return Expanded(
																child: ListView.builder(
																	itemCount: books.length,
																	padding: EdgeInsets.only(top: 15, left: 15, right: 15),
																	itemBuilder: (context, index) {
																		DateTime date = books[index]['created'].toDate();
																		return Container(
																			decoration: BoxDecoration(
																				color: Colors.white,
																				borderRadius: BorderRadius
																						.circular(10),
																			),
																			padding: EdgeInsets.all(12),
																			margin: EdgeInsets.only(
																					bottom: 15,
																					left: 8,
																					right: 8
																			),
																			child: Row(
																				children: [
																					ClipRRect(
																							borderRadius: BorderRadius.circular(20),
																							child: FadeInImage(
																								image: NetworkImage(
																										books[index]['imageUrl']),
																								placeholder: AssetImage(
																										'assets/images/icon/buku.png'),
																								width: 100,
																							)
																					),
																					SizedBox(width: 15),
																					Expanded(
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment
																										.start,
																								children: [
																									Text(
																										books[index]['title'],
																										style: TextStyle(
																											fontWeight: FontWeight.bold,
																											fontSize: 14,
																										),
																									),
																									SizedBox(height: 5),
																									Align(alignment: Alignment.bottomLeft,
																										child: Text("${date.day}/${date.month}/${date.year}",
																											style: TextStyle(
																													fontSize: 12,
																													color: primary.withOpacity(0.5)),
																											textAlign: TextAlign.right,
																										),
																									),
																								],
																								mainAxisSize: MainAxisSize.max,

																							)
																					)
																				],
																			),
																		);
																	},
																),
															);
														}
													}
												}
										)
									],
								),
            ]
          ),
        )
		  	]
		  ),
			floatingActionButton: _auth.currentUser.uid ==  widget.userId ? SizedBox() :
			FloatingActionButton(
				child: ImageIcon(
					AssetImage("assets/images/message.png"),
					color: primary,
					size: 22,
				),
				backgroundColor: Colors.grey[300],
				onPressed: () => Navigator.push(context, MaterialPageRoute(
					builder: (context) {
						return ChatPage(widget.userId, widget.photoURL, widget.displayName);
					}
				))
			),
		);
	}
}
