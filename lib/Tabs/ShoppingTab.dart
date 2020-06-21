import 'package:flutter/material.dart';
import 'package:grocery_app2/Views/HouseLocationView.dart';
import 'package:grocery_app2/Views/LocationInfoView.dart';
import 'package:grocery_app2/Views/StoreLocationView.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FilterButton.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FlatIconButton.dart';
import 'package:grocery_app2/_widgetLibrary/Headers/IconHeader.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/HeaderContentLayout.dart';
import 'package:grocery_app2/_widgetLibrary/ListItems/DraggableButtonListItem.dart';
import 'package:grocery_app2/_widgetLibrary/Other/IconIndicator.dart';
import 'package:grocery_app2/_widgetLibrary/Text/TitleText.dart';
import 'package:grocery_app2/_widgetLibrary/Text/ToggledText.dart';

typedef Update = void Function();

class ShoppingTab extends StatefulWidget {

	ShoppingTab({Key key}) : super(key: key);
	ShoppingTabState createState() => ShoppingTabState();

}

class ShoppingTabState extends State<ShoppingTab> {

	String activeFilter = 'Show On List';

	String getLocationText( LocationData location ){
		return location.checkedCount.toString() + ' / ' + location.priorityCount.toString() + ' items';
	}	

	Update updateFilter (String nextFilter){ return () => {
		setState((){
			activeFilter = nextFilter;
		})
	};}



	List<Widget> getLocations () {
		List<Widget> widgets = [];
		var locations = getStoreLocations();
		for ( int i = 0 ; i < locations.length; i ++ ){
			if ( activeFilter == 'Show On List' && locations[i].priorityCount == 0 ) continue;
			widgets.add( DraggableButtonListItem(
				left: [ IconIndicator(icon : Icons.store, inverse: true), ToggledText( text : locations[i].name, active: true)],
				right: [ToggledText( text : getLocationText( locations[i] ), active: true)],
				onTap: (){
					Navigator.push(context, MaterialPageRoute(builder: (context) => StoreLocationView( loc: locations[i] ))).then((_){ setState((){}); });
				},
				key : UniqueKey()
			));
		}
		return widgets;
	}

	
	Widget build(BuildContext context) {
		return HeaderContentLayout(
			header: IconHeader(
				icon: Icons.store,
				content: [ TitleText(text: 'Locations at Store' )],
				alignment: 'left',
			),
			content: [
				Row( 
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: [	
						Text('Filter Store Locations: '),
						Row(
							mainAxisAlignment: MainAxisAlignment.end,
							children: [
								FilterButton(  currentFilter: activeFilter, requestSwitch: updateFilter('Show On List') , text: 'Show On List' ),
								FilterButton(  currentFilter: activeFilter, requestSwitch: updateFilter('Show All') , text: 'Show All' ),
							]
						)
						
				]),
				Container( 
					height:  MediaQuery.of(context).size.height - 395,
					child : 
					ReorderableListView ( 
						children: getLocations(), 
						onReorder: (a,b){
							reorderStoreLocations(a, b);
							setState((){});
						}, 
					)
				),
				Container(
					margin: EdgeInsets.all(10),
					child : Column(
						children: [ 
							FlatIconButton(
								icon: Icons.shopping_cart, 
								onTap: (){
									finishShopping().then( (_){ setState((){}); }  );
								},
								text: 'Done Shopping'
							),
							
							FlatIconButton(
								icon: Icons.add, 
								onTap: (){
									Navigator.push(context, MaterialPageRoute(builder: (context) => LocationInfoView( newItem: true, house: false, )))
										.then( (_){ setState((){ activeFilter = 'Show All'; }); } );
								},
								text: 'New Location'
							)
						]
					)
				)
			],
		);
  	}


}