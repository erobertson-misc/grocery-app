import 'package:flutter/material.dart';

typedef OnTap = void Function(  );

class ToggleButtonListItem extends StatelessWidget {

	final List<Widget> left;
	final List<Widget> right;
	final OnTap onTap;
	final bool active;

	const ToggleButtonListItem({ Key key,  this.left, this.right, this.onTap, this.active }) : super(key: key);

	Widget build(BuildContext context) {
		return Container(
			margin: EdgeInsets.all(3),
			padding: EdgeInsets.only(left: 10, right:10, top: 5, bottom: 5 ),
			child: Material( 
				color: Colors.transparent,
				child: InkWell(
					child : Row( 
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Row ( children: left ),
							Row ( children: right)
						],
					),
					onTap: onTap,
				)
			),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.all( Radius.circular(4) ),
				color: active ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
				border : Border.all( color: Theme.of(context).primaryColor, width: 1.0 ),
				boxShadow: active ? null : [
					BoxShadow(
						color: Theme.of(context).hoverColor,
						spreadRadius: 1,
						blurRadius: 2,
						offset: Offset(3, 3), // changes position of shadow
					),
				],
			)
		);
	}

}

