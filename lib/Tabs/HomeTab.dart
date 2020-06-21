import 'package:flutter/material.dart';
import 'package:grocery_app2/Views/HouseLocationView.dart';
import 'package:grocery_app2/Views/ItemInfoView.dart';
import 'package:grocery_app2/Views/LocationInfoView.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FlatIconButton.dart';
import 'package:grocery_app2/_widgetLibrary/Headers/IconHeader.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/HeaderContentLayout.dart';
import 'package:grocery_app2/_widgetLibrary/ListItems/DraggableButtonListItem.dart';
import 'package:grocery_app2/_widgetLibrary/Other/IconIndicator.dart';
import 'package:grocery_app2/_widgetLibrary/Text/TitleText.dart';
import 'package:grocery_app2/_widgetLibrary/Text/ToggledText.dart';

class HomeTab extends StatefulWidget {

	HomeTab({Key key}) : super(key: key);
	HomeTabState createState() => HomeTabState();

}

class HomeTabState extends State<HomeTab> {

	var locations = getHouseLocations();

	void reloadSelf ( _ ) {
		print( 'reload called ');
		setState((){
			locations = getHouseLocations();
			print('reloaded home tab data');
		});
	}

	List<Widget> getLocations () {
		List<Widget> widgets = [];
		for ( int i = 0 ; i < locations.length; i ++ ){
			widgets.add( DraggableButtonListItem(
				left: [ IconIndicator(icon : Icons.home, inverse: true), ToggledText( text : locations[i].name, active: true)],
				right: [ToggledText( text : locations[i].priorityCount.toString() + ' expected', active: true)],
				onTap: (){
					Navigator.push(context, MaterialPageRoute(builder: (context) => HouseLocationView( loc: locations[i] )))
						.then( reloadSelf );
				},
				key : UniqueKey()
			));
		}
		return widgets;
	}

	
	Widget build(BuildContext context) {

		List<Widget> locations = getLocations();

		return HeaderContentLayout(
			header: IconHeader(
				icon: Icons.home,
				content: [ TitleText(text: 'Locations at House' )],
				alignment: 'right',
			),
			content: [
				Container( 
					height:  MediaQuery.of(context).size.height - 290,
					child : 
					ReorderableListView ( 
						children: locations, 
						onReorder: (a,b){
							reorderHomeLocations(a, b);
							reloadSelf(1);
						}, 
					)
				),
				Container(
					margin: EdgeInsets.all(10),
					child : FlatIconButton(
						icon: Icons.add, 
						onTap: (){
							Navigator.push(context, MaterialPageRoute(builder: (context) => LocationInfoView( newItem: true, house: true, )))
								.then( reloadSelf );
						},
						text: 'New Location'
					)
				)
			],
		);
  	}


}