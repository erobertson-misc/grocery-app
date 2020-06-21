import 'package:flutter/material.dart';
import 'package:grocery_app2/Widgets/ItemOnList.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FilterButton.dart';
import 'package:grocery_app2/_widgetLibrary/Headers/DataViewHeader.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/HeaderContentLayout.dart';

import 'LocationInfoView.dart';

typedef Update = void Function();

class StoreLocationView extends StatefulWidget {

	final LocationData loc;
	const StoreLocationView({ Key key, this.loc }) : super(key: key);
	StoreLocationViewState createState() => StoreLocationViewState();

}

class StoreLocationViewState extends State<StoreLocationView> {

	LocationData location;
	String activeFilter = 'Show On List';

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
		print('store page reloaded');
		setState((){
			location =  getStoreLocation( location.name );
			activeFilter = 'Show All';
		});
	}

	List<Widget> locationItems ( BuildContext context ){
		List<Widget> results = [];
		for ( var i = 0 ; i < location.items.length && results.length < 100 ; i += 1 ) {
			if ( activeFilter == 'Show On List' && location.items[i].onList == 0 ) continue;
			results.add( ItemOnListResult( item : location.items[i], update: (){reload(0);} ));
		}
		if ( results.length == 0 ) 
			return [Text( 'No items to display', style: TextStyle( color: Theme.of(context).primaryColor)) ];
		return results;
	}	

	Widget build(BuildContext context) {
		return Scaffold( body: 
			HeaderContentLayout(
				header: DataViewHeader( title: location.name, 
						onDelete: (){
							if ( widget.loc.name == 'unsorted' ) showError('Cant delete this location');
							else deleteLocation( widget.loc.name, widget.loc.home ).then((value) => Navigator.pop(context));
						}, 
						onEdit: (){
							Navigator.push(context, MaterialPageRoute(builder: (context) => LocationInfoView( loc: widget.loc, house: false, newItem: false, ))).
								then( (a){
									if ( widget.loc.name == '')
										Navigator.pop(context);
									else {
										reload( 0  );
									}
								});
						} 
				),
				content: [	
					Row( 
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [	
							Text('Filter Store Items: '),
							Row(
								mainAxisAlignment: MainAxisAlignment.end,
								children: [
									FilterButton(  currentFilter: activeFilter, requestSwitch: updateFilter('Show On List') , text: 'Show On List' ),
									FilterButton(  currentFilter: activeFilter, requestSwitch: updateFilter('Show All') , text: 'Show All' ),
								]
							)
					]),
					Column( children: locationItems( context )
				)]
			)
		);
	}
}