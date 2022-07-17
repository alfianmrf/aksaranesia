import "package:flutter/material.dart";
import "package:aks/ui/elements.dart";
import "package:aks/page/view_web.dart";

class TabSearch extends StatelessWidget {
	List<Map<String, String>> source = [
		{
			'title': 'Wattpad',
			'logo': 'assets/images/source/wattpad.png',
			'url': 'https://www.wattpad.com/search',
		},
		{
			'title': 'Sinta',
			'logo': 'assets/images/source/sinta.png',
			'url': 'https://sinta.kemdikbud.go.id/journals',
		},
		{
			'title': 'Project Gutenberg',
			'logo': 'assets/images/source/gutenberg.png',
			'url': 'https://www.gutenberg.org/ebooks/',
		},
		{
			'title': 'Many Books',
			'logo': 'assets/images/source/manybooks.png',
			'url': 'https://manybooks.net/search-book',
		},
		{
			'title': 'Books Yard',
			'logo': 'assets/images/source/booksyard.png',
			'url': 'https://www.bookyards.com/en/welcome',
		},
		{
			'title': 'Google Scholar',
			'logo': 'assets/images/source/scholar.png',
			'url': 'https://scholar.google.com/',
		},
		{
			'title': 'Kamus Besar Bahasa Indonesia',
			'logo': 'assets/images/source/kbbi.png',
			'url': 'https://kbbi.kemdikbud.go.id/',
		},
	];

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
		  child: Padding(
		  	padding: EdgeInsets.all(15),
		  	child: Column(
		  		crossAxisAlignment: CrossAxisAlignment.start,
		  		children: [
		  			Padding(
		  				padding: const EdgeInsets.only(top: 5, bottom: 15),
		  				child: Text(
		  					'Sumber bacaan yang bisa kamu baca',
		  					style: TextStyle(
		  						fontWeight: FontWeight.bold,
		  						fontSize: 16,
		  					),
		  				),
		  			),
		  			ListView.separated(
		  				physics: NeverScrollableScrollPhysics(),
		  				shrinkWrap: true,
		  				itemCount: source.length-1,
		  				itemBuilder: (BuildContext context, int index) {
		  					return InkWell(
		  						onTap: () => Navigator.push(context, MaterialPageRoute(
		  								builder: (context) => ViewWeb(url: source[index]['url'])
		  						)),
		  						child: Container(
		  							padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
		  							decoration: BoxDecoration(
		  								color: Colors.white,
		  								borderRadius: BorderRadius.circular(20),
		  							),
		  							child: Row(
		  								children: [
		  									Image.asset(source[index]['logo']),
		  									SizedBox(width: 10),
		  									Expanded(child: Text(source[index]['title'])),
		  								],
		  							),
		  						),
		  					);
		  				},
		  				separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
		  			),
						Padding(
							padding: const EdgeInsets.only(top: 20, bottom: 15),
							child: Text(
								'Ada KBBI juga loh yang bisa kamu akses',
								style: TextStyle(
									fontWeight: FontWeight.bold,
									fontSize: 16,
								),
							),
						),
						InkWell(
							onTap: () => Navigator.push(context, MaterialPageRoute(
									builder: (context) => ViewWeb(url: source.last['url'])
							)),
							child: Container(
								padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
								decoration: BoxDecoration(
									color: Colors.white,
									borderRadius: BorderRadius.circular(20),
								),
								child: Row(
									children: [
										Image.asset(source.last['logo']),
										SizedBox(width: 10),
										Expanded(child: Text(source.last['title'])),
									],
								),
							),
						),
		  		],
		  	),
		  ),
		);
	}
}