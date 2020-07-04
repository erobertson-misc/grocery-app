import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app2/Views/ItemInfoView.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_widgetLibrary/ListItems/ToggleButtonListItem.dart';
import 'package:grocery_app2/_widgetLibrary/Other/IconIndicator.dart';
import 'package:grocery_app2/_widgetLibrary/Text/ToggledText.dart';

import 'ItemUpdateQuantity.dart';

typedef Callback = void Function ( dynamic _ ) ;

class ItemListResult extends StatefulWidget {

	final ItemData item;
	final Callback dataChange;
	final bool showExpected;

	const ItemListResult({ Key key, this.item, this.showExpected = false, this.dataChange }) : super(key: key); 
	ItemListResultState createState() => ItemListResultState();
}

class ItemListResultState extends State<ItemListResult> {

	List<Widget> getLeft ( bool active ) {

		if ( ! widget.showExpected )
			return [ IconIndicator(icon : Icons.info, inverse: active), ToggledText( active: active, text: widget.item.name) ];
		else
			return [ 
				IconIndicator(icon : Icons.info, inverse: active), 
				Column( 
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					ToggledText( active: active, text: widget.item.name, scale : 1.3),
					ToggledText( active: active, text: widget.item.expected.toString() + ' expected', scale : 0.8),
				])
			];
	}

	Widget build ( BuildContext context ){
		
		var active = widget.item.onList > 0;
		var count = widget.item.onList;

		print( 'Count rendered with: $count' );

		return ToggleButtonListItem(
				active: active,
				left : getLeft( active ),
				right: [  ItemUpdateQuantity( item: widget.item, refresh: (){ print('called'); setState((){
					print(  widget.item.onList );
				}); })],
				onTap: (){
					Navigator.push(context, MaterialPageRoute(builder: (context) => ItemInfoView( item: widget.item ))).then( widget.dataChange );
				},
			);
	}

}