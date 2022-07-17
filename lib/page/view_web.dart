import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewWeb extends StatelessWidget {
	ViewWeb({this.url});
	final String url;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				elevation: 0,
				centerTitle: true,
				backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
				title: Text("Web View", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge.color)),
			),
			body: SafeArea(
			  child: Column(
			  	children: [
			  		Expanded(
			  			child: WebView(
			  				initialUrl: url,
			  				javascriptMode: JavascriptMode.unrestricted,
			  			),
			  		)
			  	]
			  ),
			),
		);
	}
}
