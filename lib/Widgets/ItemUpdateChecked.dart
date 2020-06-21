import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Inputs/NumberInput.dart';

typedef Toggle = void Function ( bool state ) ;

class ItemUpdateChecked extends StatelessWidget {

	final ItemData item;
	final Toggle toggle;

	const ItemUpdateChecked({ Key key, this.item, this.toggle }) : super(key: key); 

	Widget build ( BuildContext context ){
		return Checkbox(
			onChanged: ( bool s ){ 
				if ( item.onList == 0 ) return;
				toggle(s);
				setChecked( item.listIndex, s );
			},
			value: item.checked,
		);
	}

}