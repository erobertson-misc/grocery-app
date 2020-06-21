import 'package:flutter/material.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FlatIconButton.dart';
import 'package:grocery_app2/_widgetLibrary/Headers/DataViewHeader.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/HeaderContentLayout.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/RawDataView/RawDataEdit.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/RawDataView/RawDataView.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocationInfoView extends StatefulWidget {

	final LocationData loc;
	final bool newItem;
	final bool house;
	const LocationInfoView({ Key key, this.loc, this.newItem = false, this.house = false  }) : super(key: key);
	LocationInfoViewState createState() => LocationInfoViewState();

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

class LocationInfoViewState extends State<LocationInfoView> {

	bool view = false;
	LocationData location;
	String pageTitle;
	String name;
	
	int expectedCount;

	void initState() {
		super.initState();
		if ( widget.newItem ){
			view = false;
			location = LocationData(
				home : widget.house,
				name: ''
			);
			pageTitle = widget.house ? 'New House Location' : 'New Store Location';
		}
		else{
			location = widget.loc;
			pageTitle = location.name;
		}
		name = location.name;
		print( location.home );
	}

	// Updates

	void saveData () {
		if ( widget.newItem ){
			newLocation(name, location.home).then(( _ ){
				Navigator.pop(context);
			});
		}
		else{
			if ( name == '' ) showError('must have a name');
			else if ( houseLocationNames().contains(name) || storeLocationNames().contains(name))
				showError('name allready used');
			else {
				renameLocation( pageTitle, name, location.home).then(( _ ){
					setState((){ view = true; pageTitle = name; location.name = ''; });
				});
			}
		}
		
	}

	// Render

	Widget build(BuildContext context) {
		return Scaffold( body: 
			HeaderContentLayout(
				header: DataViewHeader( title: pageTitle, highlightEdit : !view, 
					onDelete: (){
						if ( widget.newItem ) Navigator.pop(context);
						else { 
							// TODO Remove existing location 
						}
					}, 
					onEdit: (){
						if ( widget.newItem ) Navigator.pop(context);
						else {
							// Go to edit view
							if ( view ) {
								setState((){ view = !view; });
							}
							// Edit edit mode
							else {
								if ( location.name == pageTitle )
									setState((){ view = true; });
								else {
									saveData();
								}
							}
						}
					} 
				),
				content: view ? [
					 RawDataView( data: [
						DataViewItem( data : name, title: 'Name', icon: Icons.sim_card ),
						DataViewItem( data : location.home ? 'house' : 'store', title: 'Type', icon: Icons.location_on ),
						DataViewItem( data : location.priorityCount.toString(), title: location.home? 'Expected' : 'OnList', icon: Icons.sim_card_alert ),
						DataViewItem( data : location.totalCount.toString(), title: 'Items', icon: Icons.list )
					])]:
					[RawDataEdit(
						data: [
							DataEditItem( icon: Icons.sim_card, title: 'Name', type: 'string', state : name ),
						],
						onChange: (key, value){
							name = value as String;
						}
					),
					Container( margin: EdgeInsets.all(20), child: FlatIconButton(icon: Icons.check, text: 'Save Data', onTap: saveData ))
				],
			)
		);
	}
}