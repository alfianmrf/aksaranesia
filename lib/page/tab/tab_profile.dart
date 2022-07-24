import 'package:aks/ui/elements.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aks/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter_slidable/flutter_slidable.dart";
import "package:aks/function/get_profiledata.dart";
import "package:readmore/readmore.dart";
import "package:aks/page/view_writing.dart";

class TabProfile extends StatefulWidget {
	@override
	_TabProfileState createState() => _TabProfileState();
}

class _TabProfileState extends State<TabProfile> with SingleTickerProviderStateMixin {
	TabController _controller;
	UserData user;
	FirebaseAuth _auth = FirebaseAuth.instance;

	final List<dynamic> buku = [
		[
			"https://cdn.gramedia.com/uploads/items/9786230304750_REVENGE_CLUB_1_1-1__w150_hauto.jpg",
			"Akasha : Revenge Club 01",
			"ANAJIRO/AOISEI"
		],
		[
			"https://cdn.gramedia.com/uploads/items/9786024526986_Sebuah-Seni-Untuk-Bersikap-Bodo-Amat__w150_hauto.jpg",
			"Sebuah Seni untuk Bersikap Bodo Amat",
			"Mark Manson"
		],
		[
			"https://cdn.gramedia.com/uploads/items/selamat_tinggal__w150_hauto.jpg",
			"Selamat Tinggal",
			"Tere Liye"
		],
		[
			"https://cdn.gramedia.com/uploads/items/9786020645667__w150_hauto.jpeg",
			"Shine",
			"Jessica Jung"
		],
		[
			"https://cdn.gramedia.com/uploads/items/9786020451060_Love-in-Chaos__w150_hauto.jpg",
			"Love in Chaos",
			"Yenny Marissa"
		],
	];

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
		user = context.watch<UserNotifier>().user;
		return Column(
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
																child: _auth.currentUser.photoURL == null ?
																FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png'))
																		:
																FadeInImage(image: NetworkImage(_auth.currentUser.photoURL), placeholder: AssetImage('assets/images/user.png')),
															),
														),
														SizedBox(width: 20),
														Expanded(
															child: Column(
																	crossAxisAlignment: CrossAxisAlignment.start,
																	children: [
																		Text(
																			_auth.currentUser.displayName,
																			style: TextStyle(
																				color: primary,
																				fontWeight: FontWeight.bold,
																				fontSize: 18,
																			),
																		),
																		Text(user.classCode, style: TextStyle(color: primary, fontSize: 16)),
																		Text((user.bio == "" || user.bio == null) ? "-" : user.bio, style: TextStyle(color: primary)),
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
												Text(user.points.toString(), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
							fontFamily: DefaultTextStyle.of(context).style.fontFamily,
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
											stream: ProfileData.getStatus(),
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
																						child: _auth.currentUser.photoURL == null ?
																						FadeInImage(image: AssetImage('assets/images/user.png'), placeholder: AssetImage('assets/images/user.png')) :
																						FadeInImage(image: NetworkImage(_auth.currentUser.photoURL), placeholder: AssetImage('assets/images/user.png')),
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
																												_auth.currentUser.displayName,
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
										stream: ProfileData.getWriting(),
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
																return Slidable(
																	actionPane: SlidableDrawerActionPane(),
																actionExtentRatio: 0.25,
																child: ListTile(
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
																	subtitle: Text(_auth.currentUser.displayName),
																),
																	secondaryActions: <Widget>[
																	new IconSlideAction(
																		caption: 'Delete',
																		color: Colors.red,
																		icon: Icons.delete,
																		onTap: () {
																			ProfileData.deleteWriting(writes[index].id, user.points).whenComplete(() {
																				context.read<UserNotifier>().setUser(
																					user.classCode,
																					user.address,
																					user.bio,
																					user.points - 75,
																					user.type
																				);
																			});
																		}
																	),
																],
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
											stream: ProfileData.getBookRead(_auth.currentUser.uid),
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
						],
					),
        ),
			]
		);
	}
}
