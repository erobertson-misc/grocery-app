import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FlatIconButton.dart';
import 'package:grocery_app2/_widgetLibrary/Headers/DataViewHeader.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/HeaderContentLayout.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/RawDataView/RawDataEdit.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/RawDataView/RawDataView.dart';

class ItemInfoView extends StatefulWidget {

	final ItemData item;
	final bool newItem;
	final String house;
	final String store;
	const ItemInfoView({ Key key, this.item, this.newItem = false, this.house , this.store  }) : super(key: key);
	ItemInfoViewState createState() => ItemInfoViewState();

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

class ItemInfoViewState extends State<ItemInfoView> {

	bool view = true;
	Map<String, dynamic> dataChanges = Map<String, dynamic>();
	ItemData item;
	String pageTitle;
	
	int expectedCount;
	String houseLoc;
	String storeLoc;

	void initState() {
		super.initState();
		if ( widget.newItem ){
			view = false;
			item = ItemData(
				name : '',
				expected: 0,
				notes: '',
				onList: 0,
				listIndex: -1,
				checked: false,
				store: widget.store == null ? getStoreLocations()[0].name : widget.store,
				house: widget.house == null ? getHouseLocations()[0].name : widget.house,
			);
			pageTitle = 'New Item';
		}
		else{
			item = widget.item;
			pageTitle = item.name;
		}
		houseLoc = item.house;
		storeLoc = item.store;
		expectedCount = item.expected;
	}

	// Updates

	void saveData () {
		if ( widget.newItem ){
			if ( dataChanges['Name'] == null ) showError( 'Item needs a name' );
			else{
				newItem( dataChanges['Name'], dataChanges['Notes'] != null ? dataChanges['Notes'] : '', houseLoc, storeLoc, expectedCount).then((_)=>{
					Navigator.pop(context)
				});
			}

		}else {
			if ( dataChanges.isEmpty ) return;
			String name = dataChanges['Name'] == null ? item.name : dataChanges['Name'];
			String notes = dataChanges['Notes'] == null ? item.notes : dataChanges['Notes'];
			updateItem(name, notes, houseLoc, storeLoc, expectedCount, item.listIndex).then((_)=>{
				Navigator.pop(context)
			});
			dataChanges = Map<String, dynamic>();
		}
		
	}

	// Render

	Widget build(BuildContext context) {
		return Scaffold( body: 
			HeaderContentLayout(
				header: DataViewHeader( title: pageTitle, highlightEdit : !view, 
					onDelete: (){
						deleteItem( item.listIndex ).then((value) => Navigator.pop(context));
					}, 
					onEdit: (){
						setState((){
							view = !view;
							if ( view ) saveData();
						});
					} 
				),
				content: view ? [
					 RawDataView( data: [
						DataViewItem( data : item.name, title: 'Name', icon: Icons.sim_card ),
						DataViewItem( data : item.notes, title: 'Notes', icon: Icons.note ),
						DataViewItem( data : expectedCount.toString(), title: 'Expected', icon: Icons.sim_card_alert ),
						DataViewItem( data : item.onList.toString(), title: 'On List', icon: Icons.list ),
						DataViewItem( data : item.house, title: 'At House', icon: Icons.home ),
						DataViewItem( data : item.store, title: 'At Store', icon: Icons.store ),
					])]:
					[RawDataEdit(
						data: [
							DataEditItem( icon: Icons.sim_card, title: 'Name', type: 'string', state : item.name ),
							DataEditItem( icon: Icons.note, title: 'Notes', type: 'string', state : item.notes ),
							DataEditItem( icon: Icons.sim_card_alert, title: 'Expected', type: 'number', state : expectedCount ),
							DataEditItem( icon: Icons.home, title: 'At House', type: 'cataglory', state : houseLoc, options: houseLocationNames() ),
							DataEditItem( icon: Icons.store, title: 'At Store', type: 'cataglory', state : storeLoc, options: storeLocationNames() ),
						],
						onChange: (key, value){
							if ( key == 'Expected' ){
								setState((){
									expectedCount = value as int;
									print( expectedCount );
								});
							}
							print( key );
							if ( key == 'At House')
								setState((){ houseLoc = value; });
							if ( key == 'At Store')
								setState((){ storeLoc = value; });
							dataChanges.update(key, (a) => value, ifAbsent: ()=>value);
						}
					),
					Container( margin: EdgeInsets.all(20), child: FlatIconButton(icon: Icons.check, text: 'Save Data', onTap: saveData ))
				],
			)
		);
	}
}