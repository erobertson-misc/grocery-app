import 'package:flutter/material.dart';
import '../Text/ToggledText.dart';

typedef Callback = void Function(  );

class PaddedIconButton extends StatelessWidget {

	final IconData icon;
	final Callback onTap;
	final bool highlight;

	const PaddedIconButton({ Key key,  this.icon, this.onTap, this.highlight = false }) : super(key: key);

	Widget build(BuildContext context) {
		Color background = Theme.of(context).secondaryHeaderColor;
		Color iconColor = Theme.of(context).primaryIconTheme.color;
		return new Container( 
			margin: EdgeInsets.all(5),
			child : 
				Material ( child : 
					InkWell(child: 
						Icon(icon, color: highlight ? background : iconColor), 
						onTap: onTap),
						color: Colors.transparent,
					),
					width: 40,
					height: 40,
					decoration: BoxDecoration(
						borderRadius: BorderRadius.all( Radius.circular(4) ),
						color: highlight ? iconColor : Colors.transparent,
					)
			);
	}

}

