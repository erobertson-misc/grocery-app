import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app2/Views/ItemInfoView.dart';
import 'package:grocery_app2/Widgets/ItemUpdateChecked.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/ListItems/ToggleButtonListItem.dart';
import 'package:grocery_app2/_widgetLibrary/Other/IconIndicator.dart';
import 'package:grocery_app2/_widgetLibrary/Text/ToggledText.dart';

class ItemOnListResult extends StatefulWidget {

	final ItemData item;
	final Callback update;

	const ItemOnListResult({ Key key, this.item, this.update }) : super(key: key); 
	ItemOnListResultState createState() => ItemOnListResultState();
}

class ItemOnListResultState extends State<ItemOnListResult> {


	Widget build ( BuildContext context ){
		
		var active = !widget.item.checked;

		return Opacity(
				opacity: (!active || widget.item.onList == 0 ) ? 0.4 : 1 ,
				child : ToggleButtonListItem(
					active: active,
					left : [ IconIndicator(icon : Icons.info, inverse: active), ToggledText( active: active, text: widget.item.name + '  x ' + widget.item.onList.toString() ) ],
					right: [ ItemUpdateChecked( item: widget.item, toggle : (_){
						setState((){});
					} )  ],
					onTap: (){
						Navigator.push(context, MaterialPageRoute(builder: (context) => ItemInfoView( item: widget.item ))).then( (_){widget.update();} );
					},
			));
	}

}