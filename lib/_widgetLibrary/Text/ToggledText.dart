import 'package:flutter/material.dart';

class ToggledText extends StatelessWidget {

	final bool active;
	final String text;
	final double scale;
	final bool allowWrap;

	const ToggledText({ Key key,  this.active, this.text, this.scale = 1, this.allowWrap = false }) : super(key: key);

	Widget build(BuildContext context) {
		return Container(
			constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 250),
			child : Text( 
				text, 
				maxLines:6,
				style : 
					TextStyle( 
						color: active ? Theme.of(context).primaryIconTheme.color : Theme.of(context).primaryColor,
						fontWeight: FontWeight.w800,
						fontSize: 14 * scale
					)
				)
		);
	}

}

