import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app2/Widgets/ItemListResult.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FilterButton.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FlatIconButton.dart';
import 'package:grocery_app2/_widgetLibrary/Headers/DataViewHeader.dart';
import 'package:grocery_app2/_widgetLibrary/Headers/ToggleButtonHeader.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/HeaderContentLayout.dart';
import 'package:grocery_app2/_widgetLibrary/Text/TitleText.dart';

import 'ItemInfoView.dart';
import 'LocationInfoView.dart';

typedef Update = void Function();

class HouseLocationView extends StatefulWidget {

	final LocationData loc;
	const HouseLocationView({ Key key, this.loc }) : super(key: key);
	HouseLocationViewState createState() => HouseLocationViewState();

}

class HouseLocationViewState extends State<HouseLocationView> {

	LocationData location;
	String activeFilter = 'Show All';

	
	void initState() {
		super.initState();
		location = widget.loc;
	}

	Update updateFilter (String nextFilter){ return () => {
		setState((){
			activeFilter = nextFilter;
		})
	};}

	void reload ( _ ) {
		setState((){
			location =  getHouseLocation( location.name );
			activeFilter = 'Show All';
		});
	}

	void showError ( String message ) {
		Fluttertoast.cancel();
		Fluttertoast.showToast(
			msg: message,
			toastLength: Toast.LENGTH_SHORT,
			gravity: ToastGravity.BOTTOM,
			timeInSecForIosWeb: 1,
			backgroundColor: Colors.red,
			textColor: Colors.white,
			fontSize: 14.0
		);
	}
	List<Widget> locationItems ( BuildContext context ){
		List<Widget> results = [];
		print('re-rendered');
		print( location.items.length );
		for ( var i = 0 ; i < location.items.length && results.length < 100 ; i += 1 ) {
			if ( activeFilter == 'Show Expected' && location.items[i].expected == 0 ) continue;
			results.add( ItemListResult( item : location.items[i], showExpected: true, dataChange: reload ));
		}
		if ( results.length == 0 ) 
			return [Text( 'No items to display', style: TextStyle( color: Theme.of(context).primaryColor)) ];
		return results;
	}	

	Widget build(BuildContext context) {
		return Scaffold( body: 
			HeaderContentLayout(
				header: DataViewHeader( title: widget.loc.name, 
						onDelete: (){
							if ( widget.loc.name == 'unsorted' ) showError('Cant delete this location');
							else deleteLocation( widget.loc.name, widget.loc.home ).then((value) => Navigator.pop(context));
						}, 
						onEdit: (){
							Navigator.push(context, MaterialPageRoute(builder: (context) => LocationInfoView( loc: widget.loc, house: true, newItem: false, ))).
								then( (a){
									if ( widget.loc.name == '')
										Navigator.pop(context);
									else {
										reload( 0  );
									}
								});
						} ,
						onCreate: (){
							Navigator.push(context, MaterialPageRoute(builder: (context) => ItemInfoView( newItem: true, house: widget.loc.name ))).then( reload );
						},
				),
				content: [	
					Row( 
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [	
							Text('Filter House Items: '),
							Row(
								mainAxisAlignment: MainAxisAlignment.end,
								children: [
									FilterButton(  currentFilter: activeFilter, requestSwitch: updateFilter('Show Expected') , text: 'Show Expected' ),
									FilterButton(  currentFilter: activeFilter, requestSwitch: updateFilter('Show All') , text: 'Show All' ),
								]
							)
							
					]),
					Container(
						margin: EdgeInsets.only(bottom : 30, top : 30 ),
						child: Column( children: locationItems( context ))
					),
					Container(
						margin: EdgeInsets.all(10),
						child : FlatIconButton(
							icon: Icons.add, 
							onTap: (){
								Navigator.push(context, MaterialPageRoute(builder: (context) => ItemInfoView( newItem: true, house: widget.loc.name ))).then(
									(value){
										print('tap callback');
										reload(0);
									}
								);
							},
							text: 'New Item'
						)
					)
				]
			)
		);
	}
}