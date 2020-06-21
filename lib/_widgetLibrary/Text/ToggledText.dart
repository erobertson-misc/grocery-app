import 'package:flutter/material.dart';

class ToggledText extends StatelessWidget {

	final bool active;
	final String text;
	final double scale;

	const ToggledText({ Key key,  this.active, this.text, this.scale = 1 }) : super(key: key);

	Widget build(BuildContext context) {
		return Text( 
			text, 
			style : 
				TextStyle( 
					color: active ? Theme.of(context).primaryIconTheme.color : Theme.of(context).primaryColor,
					fontWeight: FontWeight.w800,
					fontSize: 14 * scale
				)
			)
		;
	}

}

