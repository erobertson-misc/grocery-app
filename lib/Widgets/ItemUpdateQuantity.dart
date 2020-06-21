import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Inputs/NumberInput.dart';

class ItemUpdateQuantity extends StatelessWidget {

	final ItemData item;
	final Callback refresh;

	const ItemUpdateQuantity({ Key key, this.item, this.refresh }) : super(key: key); 

	Widget build ( BuildContext context ){
		return NumberInput( quantity: item.onList, modifyQuantity: (quantity){ 
			print('updated');
			updateItemListQuantity( item.listIndex, quantity);
			refresh();
		});
	}

}