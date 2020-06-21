import 'package:flutter/material.dart';
import '../Text/ToggledText.dart';

typedef RequestSwitch = void Function(  );

class FilterButton extends StatelessWidget {

	final String text;
	final String currentFilter;
	final RequestSwitch requestSwitch;

	const FilterButton({ Key key,  this.text, this.currentFilter, this.requestSwitch }) : super(key: key);

	Widget build(BuildContext context) {
		bool active = currentFilter == text;
		return InkWell(
			child: Container(
				margin: EdgeInsets.all(7),
				padding: EdgeInsets.only(left: 10, right:10, top: 5, bottom: 5 ),
				child: Container(
					child: ToggledText( text: text, active : active )
				),
				decoration: BoxDecoration(
					borderRadius: BorderRadius.all( Radius.circular(4) ),
					color: active ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
					border : active ? null : Border.all( color: Theme.of(context).primaryColor, width: 1.0 ),
				)
			),
			onTap:requestSwitch
		);
	}

}

