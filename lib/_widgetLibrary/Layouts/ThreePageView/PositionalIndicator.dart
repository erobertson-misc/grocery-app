import 'package:flutter/material.dart';

typedef RequestSwitch = void Function( int position );

class PositionalIndicator extends StatelessWidget {

	final int position;
	final List<IconData> icons;
	final RequestSwitch requestSwitch;

	const PositionalIndicator({ Key key, this.position, this.icons, this.requestSwitch }) : super(key: key);

	Color iconColor( int pos, BuildContext context ) {
		return pos == position ? Theme.of(context).iconTheme.color : Theme.of(context).primaryColor;
	}
	Color backgroundColor( int pos, BuildContext context ) {
		return pos == position ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor;
	}

	List<Widget> _genIcons (BuildContext context) {
		List<Widget> _icons = [];
		for ( int i=0 ; i<icons.length; i++ ){
			_icons.add(
				FlatButton(
					color: backgroundColor(i, context),
					onPressed: (){ requestSwitch ( i ); },
					child: Icon( icons[i], size: 30, color: iconColor(i, context) ), 
				)
			);
		}
		return _icons;
	}

	Widget build(BuildContext context) {
		return Container( 
			height: 45,
			margin: EdgeInsets.only( left: 10, right: 10, bottom: 1, top: 1 ),
			padding: EdgeInsets.only( top: 3 ),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: _genIcons( context )
			),
			decoration: BoxDecoration(
				color: Theme.of(context).backgroundColor,
				border: Border(
					top: BorderSide(width: 1, color: Theme.of(context).accentColor),
				),
			),
		);
	}

}

