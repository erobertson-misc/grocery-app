import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:http/http.dart' as http;

String yourUserID = '';
String activeUserID = '';

dynamic listData = {};
Color toastColor = Colors.black;
typedef Callback = void Function () ;

HashMap<String, LocationData> houseLocationLookup = new HashMap<String, LocationData>();
List<LocationData> houseLocations = [];

HashMap<String, LocationData> storeLocationLookup = new HashMap<String, LocationData>();
List<LocationData> storeLocations = [];

List<ItemData> allItems = [];

String accountName;
String color;
List<String> joinedAccounts = [];

// Setup

void setUserId ( String id ) { yourUserID = id; }
void setToastColor ( Color color ) { toastColor = color; }

// Feedback

void showMessage ( String message ) {
	Fluttertoast.cancel();
	Fluttertoast.showToast(
		msg: message,
		toastLength: Toast.LENGTH_SHORT,
		gravity: ToastGravity.BOTTOM,
		timeInSecForIosWeb: 1,
		backgroundColor: toastColor,
		textColor: Colors.white,
		fontSize: 14.0
	);
}
void loading ( ) {
	Fluttertoast.showToast(
		msg: 'Processing . . . ',
		toastLength: Toast.LENGTH_SHORT,
		gravity: ToastGravity.CENTER,
		timeInSecForIosWeb: 1,
		backgroundColor: toastColor,
		textColor: Colors.white,
		fontSize: 14.0
	);
}

void error ( a ){
	Fluttertoast.showToast(
		msg: 'Error processing action, are you connected to the internet?',
		toastLength: Toast.LENGTH_SHORT,
		gravity: ToastGravity.BOTTOM,
		timeInSecForIosWeb: 1,
		backgroundColor: Colors.red,
		textColor: Colors.white,
		fontSize: 14.0
	);
}

// Access Data

String getListName () {
  return listData['account_name'];
}

List<LocationData> getHouseLocations () {
  return houseLocations;
}
List<LocationData> getStoreLocations () {
  return storeLocations;
}
LocationData getHouseLocation ( String name) {
  return houseLocationLookup[name];
}
LocationData getStoreLocation ( String name) {
  return storeLocationLookup[name];
}
List<ItemData> getAllItems ( ) {
  return allItems;
}
List<String> houseLocationNames () {
  return houseLocations.map((e) => e.name).toList();
}
List<String> storeLocationNames () {
  return storeLocations.map((e) => e.name).toList();
}

// Data Parse calls

void decodeAndParse ( String body ) {
	listData = json.decode( body )['Attributes'];
	parseData();
}

// Local Data Updates

// Api Requests

Future<void> newLocation ( String loc, bool home ) async {
	loading();
	var response = await http.post( 
		'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/location/new', 
		body: json.encode({ 'userID': activeUserID, 'location': loc, 'home': home })).catchError( error );
	decodeAndParse( response.body );
	showMessage( 'Location \'$loc\' created' );
}
Future<void> deleteLocation ( String loc, bool home) async {
	loading();
	var response = await http.post( 
		'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/location/delete', 
		body: json.encode({ 'userID': activeUserID, 'location': loc, 'home': home })).catchError( error );
	decodeAndParse( response.body );
	showMessage( 'Location \'$loc\' deleted' );
}

Future<void> renameLocation ( String oldName, String newName, bool home ) async {
	print( oldName );
	print( newName );
	loading();
	var response = await http.post( 
		'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/location/rename', 
		body: json.encode({ 'userID': activeUserID, 'oldName': oldName, 'newName': newName, 'home': home }));
	decodeAndParse( response.body );
	showMessage( 'Location \'$newName\' renamed' );
}
Future<void> reorderHomeLocations ( int index, int newIndex ) async {

  LocationData target = houseLocations[index];
  if ( newIndex > index ) newIndex -=1;
  print('$index => $newIndex ');
  houseLocations.removeAt(index);
  houseLocations.insert(newIndex, target);
  // Adjust order
  List<String> order = houseLocationNames();
  print( houseLocationNames().join(', ') );
  await http.post( 'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/home/reorder', body: json.encode({ 'userID': activeUserID, 'newOrder' : order}));
}
Future<void> reorderStoreLocations ( int index, int delta ) async {
  // Swap down
  LocationData target = storeLocations[index];
  storeLocations[index] = storeLocations[index+delta];
  storeLocations[index+delta] = target;
  print( '$index $delta' );
  // Adjust order
  List<String> order = storeLocationNames();
  await http.post( 'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/store/reorder', body: json.encode({ 'userID': activeUserID, 'newOrder' : order}));
}
Future<void> newItem ( String name, String notes, String home, String store, int expected ) async {
	loading();
	var response = await http.post( 
		'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/items/new', 
		body: json.encode({ 'userID': activeUserID, 'name' : name, 'notes' : notes, 'home': home, 'store' : store, 'expected' : expected }));
	decodeAndParse( response.body );
	showMessage( 'Item \'$name\' created' );
}

Future<void> deleteItem ( int item ) async {
	loading();
    await http.post( 
    	'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/items/delete', 
    	body: json.encode({ 'userID': activeUserID, 'index': item }));
	showMessage( 'Item deleted' );
}
Future<void> updateItem ( String name, String notes, String home, String store, int expected, int index ) async{
  	loading();
	var response = await http.post(  'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/items/update', 
    body: json.encode({ 
		'userID': activeUserID, 
		'name' : name, 
		'notes' : notes, 
		'home': home, 
		'store' : store, 
		'expected' : expected, 
		'index' : index, 
		'onList' : allItems[index].onList, 
		'checked' : allItems[index].checked }));
  	decodeAndParse( response.body );
	showMessage( 'Item \'$name\' updated' );
}

Future<void> finishShopping ( ) async {
  	loading();
    var response = await http.post( 
		'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/finish', 
		body: json.encode({ 'userID': activeUserID}));
  	decodeAndParse( response.body );
	showMessage( 'Checked items cleared from list' );
}

Future<String> lookupAccountName ( String id ) async {
	print( 'looking up name for $id');
  	var response = await http.post( 'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/user/loadUser', body: json.encode({ 'userID': id }));
  	return json.decode( response.body )['Item']['account_name'] as String;
}
Future<void> renameAccount ( String name ) async {
  	loading();
  	var response = await http.post( 'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/rename', body: json.encode({ 'userID': yourUserID, 'name' : name }));
	accountName = name;
	
	//decodeAndParse( response.body );
	showMessage( 'Renamed Account' );
}
Future<void> setActiveAccount ( String id ) async {
  	loading();
  	await http.post( 'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/setActive', body: json.encode({ 'userID': yourUserID, 'userIDActive' : id }));
	await pullData();
	showMessage( 'Switched Active List' );
}


Future<String> signupNewUser() async{
  var response = await http.post( 'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/user/signup');
  print('Response from signup: ' + response.body );
  return json.decode( response.body )['id'];
}

Future<void> pullData(  ) async {
  var response = await http.post( 'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/user/loadUser', body: json.encode({ 'userID': yourUserID }));
  var data = json.decode( response.body )['Item'];
  accountName = data['account_name'];
  joinedAccounts= []	;
  data['joined'].forEach( (acc){
	  print( acc );
	joinedAccounts.add(acc as String);
  });

  activeUserID = data['active'] ;
  response = await http.post( 'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/user/loadUser', body: json.encode({ 'userID': activeUserID }));
  listData = json.decode( response.body )['Item'];
  parseData();
}

Future<void> updateAccountName ( String name ) async {
  await http.post( 'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/user/setName', body: json.encode({ 'userID': yourUserID, 'name' : name }));
  listData['account_name'] = name;
}

Future<void> updateItemListQuantity ( int index, int newCount ) async {
	print( 'Item Index: $index' );
	print( 'Item Name: ' +allItems[index].name );
  var a = allItems[index].onList;
  var b = newCount;
  print('data at start $a => $b');
  if ( allItems[index].onList == 0 && newCount > 0 ){
    storeLocationLookup[allItems[index].store].priorityCount += 1;
    print( storeLocationLookup[allItems[index].store].priorityCount );
  }
  if ( allItems[index].onList != 0 && newCount == 0 ){
    storeLocationLookup[allItems[index].store].priorityCount -= 1;
    print( storeLocationLookup[allItems[index].store].priorityCount );
  }
  allItems[index].onList = newCount;
  print('changed to $newCount');
  await http.post( 'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/items/setNewQuantity', body: json.encode({ 'userID': activeUserID, 'index' : index, 'count' : newCount }));
}

Future<void> setChecked ( int index, bool checked ) async {
  allItems[index].checked = checked;
  if ( checked ){ storeLocationLookup[allItems[index].store].checkedCount += 1; }
  else{ storeLocationLookup[allItems[index].store].checkedCount -= 1; }
  print( '$index $checked');
  await http.post( 
    'https://l8k0kgay08.execute-api.us-east-1.amazonaws.com/items/setChecked', 
    body: json.encode({ 'userID': activeUserID, 'index': index, 'checked' : checked }));
}


// Parse the data
void parseData () {
  print('Atempting parse');


  // Clear lookups
  allItems.clear();
  houseLocations.clear();
  houseLocationLookup.clear();
  storeLocations.clear();
  storeLocationLookup.clear();

  // Add back the locations
  listData['home_loc'].forEach( (loc){
    var newLoc = LocationData( name: loc, home: true );
    houseLocations.add( newLoc );
    houseLocationLookup.putIfAbsent(loc, () => newLoc);
  });

  listData['store_loc'].forEach( (loc){
    var newLoc = LocationData( name: loc, home: false );
    storeLocations.add( newLoc );
    storeLocationLookup.putIfAbsent(loc, () => newLoc);
  });

  // Add Accounts



  // For every item loaded, put them in the right locations
  for ( var i = 0 ; i < listData['shopping_items'].length; i += 1 ){
    var element = listData['shopping_items'][i];
    
    String houseLoc = element['home'];
    String storeLoc = element['store'];
    int expected = element['expected'];
    bool checked = element['checked'];

    var item = ItemData(
      expected: expected,
      onList: element['onList'],
      name: element['name'],
      notes: element['notes'],
      house: houseLoc,
      store: storeLoc,
      checked: checked,
      listIndex: i
    );

    var house = houseLocationLookup[houseLoc];
    house.totalCount += 1;
    house.priorityCount += expected != 0 ? 1 : 0 ;
    house.items.add( item );

    var store = storeLocationLookup[storeLoc];
    store.totalCount += 1;
    store.priorityCount += element['onList'] != 0 ? 1 : 0 ;
    store.checkedCount += element['onList'] != 0 ? (checked ? 1: 0) : 0;
    store.items.add( item );

    allItems.add( item );
    
  }

}