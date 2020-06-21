
class ItemData {

	String name; 		// Item's Name
	String notes;		// Any Notes?
	String house;		// House Location
	String store;		// Store Location
	int expected;		// How many to expect
	int onList;			// How many on the list
	int listIndex;		// Index on global item list
	bool checked;		// Is it checked off

	ItemData({this.name, this.expected, this.notes, this.house, this.store, this.onList, this.listIndex, this.checked });
}

class LocationData {
	bool home ;
	String name;
	int priorityCount = 0 ;
	int totalCount = 0;
	int checkedCount = 0;
	List<ItemData> items = [];

	LocationData({ this.home, this.name });
}
class ListAccount {
	String name;
	String id;
	ListAccount({ this.name, this.id });
}