import 'package:flutter/material.dart';

class IconIndicator extends StatelessWidget {

	final IconData icon;
	final bool inverse;
	final bool border;

	const IconIndicator({ Key key, this.icon, this.inverse = false, this.border = false }) : super(key: key);

	Widget build(BuildContext context) {
		return Container( 
			margin: EdgeInsets.only(top: 5, left: 5, right: 15, bottom: 5),
			padding: EdgeInsets.all(5),
			child : 
				Icon( icon , color : inverse ? Theme.of(context).primaryIconTheme.color : Theme.of(context).primaryColor)
			,
			decoration: BoxDecoration(
				borderRadius: BorderRadius.all( Radius.circular(4) ),
				color: border? (inverse? Theme.of(context).primaryColor:Theme.of(context).backgroundColor) : Colors.transparent,
			)
		);
	}

}

