import 'package:flutter/material.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FlatIconButton.dart';

typedef OnChange = void Function();

class ToggleButtonHeader extends StatelessWidget {

	final String text;
	final IconData icon;
	final bool active;
	final OnChange change;

	ToggleButtonHeader({ Key key,  this.text, this.icon, this.active, this.change  }) : super(key: key);

	// Rendering 

	Widget build(BuildContext context) {
		return Container(
			child: Row( 
				mainAxisAlignment: MainAxisAlignment.end,
				children: [
					FlatIconButton( icon: icon, onTap: change, text: text )
				]
			),
		);
	}
}

            