import 'package:flutter/material.dart';

class IconHeader extends StatelessWidget {

	final List<Widget> content;
	final IconData icon;
	final String alignment;

	IconHeader({ Key key,  this.content, this.icon, this.alignment }) : super(key: key);

	// Rendering 

	List<Widget> getRowData ( BuildContext context ) {
		if ( alignment == 'right' )
			return [
				Row( children : content ),
				Icon(icon, color: Theme.of(context).primaryIconTheme.color, size: 70 )
			];
		else
			return [
				Icon(icon, color: Theme.of(context).primaryIconTheme.color, size: 70 ), 
				Row( children : content )
			];
	}

	Widget build(BuildContext context) {
		return Container(
			margin: EdgeInsets.only(top: 20),
			padding: EdgeInsets.only(bottom: 6),
			child: Row( 
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				crossAxisAlignment: CrossAxisAlignment.end,
				children: getRowData( context ),
			),
		);
	}
}

            