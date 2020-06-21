import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {

	final String text;

	const TitleText({ Key key, this.text }) : super(key: key);

	Widget build(BuildContext context) {
		return Text( 
			text, 
			style : 
				TextStyle( 
					color: Theme.of(context).primaryIconTheme.color,
					fontWeight: FontWeight.w800,
					fontSize: 20,
				)
			)
		;
	}

}

