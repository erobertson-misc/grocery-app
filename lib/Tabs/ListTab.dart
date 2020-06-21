import 'package:flutter/material.dart';
import 'package:grocery_app2/Views/ItemInfoView.dart';
import 'package:grocery_app2/Widgets/ItemListResult.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FlatIconButton.dart';
import 'package:grocery_app2/_widgetLibrary/Headers/SearchFilterHeader.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/HeaderContentLayout.dart';

class ListTab extends StatefulWidget {

	final bool welcome;
	ListTab({Key key, this.welcome }) : super(key: key);
	ListTabState createState() => ListTabState();

}

class ListTabState extends State<ListTab> {

	String searchValue = '';
	String filter = 'On List';
	List<ItemData> items = getAllItems();
	bool showWelcome; 
	void refresh(){
		setState(() {
		  items = getAllItems();
		});
	}

	void updateSearchValue ( String val ){
		setState(() {
		  searchValue = val;
		});
	}
	void updateFilterValue ( String value ){
		setState((){
			filter = value;
			print( filter );
		});
	}

	void initState() {
		super.initState();
		showWelcome = widget.welcome;
		print( 'List Re-rendered with welcome : $showWelcome');
		Future.delayed(const Duration(milliseconds: 100), () {
			if ( showWelcome ) showWelcomeDialog( context );
			showWelcome = false;
			setState((){
				print('triggered');
			});
		});
	}

	List<Widget> getSearchResults(){
		List<Widget> results = [];
		for ( var i = 0 ; i < items.length && results.length < 100 ; i += 1 ) {
			if ( filter == 'On List' && items[i].onList == 0 ) continue;
			if ( ! items[i].name.contains(searchValue) ) continue;
			results.add( ItemListResult( item : items[i], dataChange: (_){refresh();} ));
		}
		return results;
	}

	Widget build(BuildContext context) {
		return HeaderContentLayout(
			header: SearchFilterHeader(
				hint: 'Search all items',
				filters : ['All Items', 'On List'],
				onChange: updateSearchValue,
				onFilter: updateFilterValue,
			),
			content: [
				Column(
					children: getSearchResults()
				),
				Container(
					margin: EdgeInsets.all(10),
					child : FlatIconButton(
						icon: Icons.add, 
						onTap: (){
							Navigator.push(context, MaterialPageRoute(builder: (context) => ItemInfoView( newItem: true )));
						},
						text: 'New Item'
					)
				)
			],
		);
  	}

	  
	showWelcomeDialog(BuildContext context) {

		Widget okButton = FlatButton(
			child: Text("Next"),
			onPressed: () { Navigator.of(context).pop(); showSecondWelcomeDialog( context ); },
		);

		AlertDialog alert = AlertDialog(
			title: Text("App Info!"),
			content: Text("This app is makes shopping easier by allowing you sort items by categories. \n\nData is sunk to the cloud with no account needed. \n\nYou can connect with your friends and family for a single shared list.\n\nSome basic data was added to your account to get you started, but everything is fully customizable!"),
			actions: [
			okButton,
			],
		);

		showDialog(
			context: context,
			builder: (BuildContext context) {
			return alert;
			},
		);
		}
		
	showSecondWelcomeDialog(BuildContext context) {

		Widget okButton = FlatButton(
			child: Text("Finish"),
			onPressed: () { Navigator.of(context).pop(); },
		);

		AlertDialog alert = AlertDialog(
			title: Text("Usage Instructions "),
			content: Text("As you go about your normal shopping, add items to the registry and fill in basic information about them.\n\nQuckly add and remove items from the list with +/- 's next to items. \n\nItems are sorted by location in store and easy checked off as you go.\n\n Press 'finish shopping' to remove all crossed off items from your list! "),
			actions: [
			okButton,
			],
		);

		showDialog(
			context: context,
			builder: (BuildContext context) {
			return alert;
			},
		);
		}

}
