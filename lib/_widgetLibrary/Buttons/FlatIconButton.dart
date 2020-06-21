import 'package:flutter/material.dart';
import 'package:grocery_app2/_widgetLibrary/Other/IconIndicator.dart';

typedef Callback = void Function(  );

class FlatIconButton extends StatelessWidget {

	final IconData icon;
	final String text;
	final Callback onTap;

	const FlatIconButton({ Key key,  this.icon, this.onTap, this.text }) : super(key: key);

	Widget build(BuildContext context) {
		Color background = Theme.of(context).primaryColor;
		return  Container( 
			margin: EdgeInsets.only( top : 10 ),
			child : FlatButton(
				child: Container(
					child: Row( 
						mainAxisSize: MainAxisSize.min,
						children: [ 
							IconIndicator(icon: icon, inverse: true ), 
							Container(
								margin: EdgeInsets.only(right: 10),
								child: Text(text, style: TextStyle( color: Theme.of(context).primaryIconTheme.color, fontSize: 12 )) 
							)
						]
					),
				),
				onPressed: onTap,
			),
			decoration: BoxDecoration(
				color: background,
				borderRadius: BorderRadius.all( Radius.circular(4) ),
			)
		);
	}

}



