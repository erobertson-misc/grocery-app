import 'package:flutter/material.dart';

class HeaderContentLayout extends StatelessWidget {

	final Widget header;
	final List<Widget> content;

	HeaderContentLayout({ Key key, this.header, this.content }) : super(key: key);

	Widget build(BuildContext context) {
		return ListView(
			children: [
				Container( 
					padding: EdgeInsets.only(top: 10),
					child: Container(
						padding: EdgeInsets.all(10),
						child: header
					),
					decoration: BoxDecoration(
						color: Theme.of(context).secondaryHeaderColor,
						border: Border( bottom: BorderSide(color: Theme.of(context).accentColor, width: 1.0 )),
					)
				),
				Container(
					margin: EdgeInsets.only(top: 20, right: 10, left: 10 ),
					child: Column( 
						children: content 
					),
				),
		]);
  	}

}