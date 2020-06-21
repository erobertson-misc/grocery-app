/*
	Backend code for grocery app
*/

'use strict';

let AWS = require("aws-sdk");
AWS.config.update({ region: "us-east-1" });
let database = new AWS.DynamoDB.DocumentClient();
let TableName = 'grocery-users';

// ! Utils 

async function dataInsert ( request ){
	request.ReturnValues = "ALL_OLD"
	return new Promise( (yes,no) => {
        database.put(request, (err,data) => {
			console.log(`Data insert `, err, data );
            if ( err ){
				console.log(`Data insert failed.`)
				console.log(`Request of ${JSON.stringify(request)} `)
				console.log(`Error of ${JSON.stringify(err)}`)
				yes({ statusCode: 500, body : JSON.stringify(err) })
			}
            if ( data ) yes({ statusCode: 200, body: JSON.stringify(request.Item) })
        })
    })
}

async function dataAccess ( request ){
	return new Promise( (yes,no) => {
        database.get(request, (err,data) => {
			console.log(`Data access `, err, data );
            if ( err ) {
				console.log(`Data access failed.`)
				console.log(`Request of ${JSON.stringify(request)} `)
				console.log(`Error of ${JSON.stringify(err)}`)
				yes({ statusCode: 500, body : JSON.stringify(err) })
			}
            if ( data ) yes({ statusCode: 200, body: JSON.stringify(data) })
        })
    })
}

async function rawDataAccess ( userID ){
    let request = { TableName,  Key: { 'id': userID } };
	return new Promise( (yes,no) => {
        database.get(request, (err,data) => {
            if ( err ) {
				console.log(`Data access failed.`)
				console.log(`Request of ${JSON.stringify(request)} `)
				console.log(`Error of ${JSON.stringify(err)}`)
				yes( {} )
			}
            if ( data ) yes( data )
        })
    })
}

async function dataUpdate ( request ){
	request.ReturnValues = "ALL_NEW"
	return new Promise( (yes,no) => {
        database.update(request, (err,data) => {
			console.log(`Data update `, err, data );
            if ( err ) {
				console.log(`Data update failed.`)
				console.log(`Request of ${JSON.stringify(request)} `)
				console.log(`Error of ${JSON.stringify(err)}`)
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                yes({ statusCode: 200, body: JSON.stringify(data) })
            }
        })
    })
}
// ! Signup Data

// Give user a 12 didgit id
function genUserId () {
	return 	Math.floor(Math.random()*16777215).toString(16).padStart(6,'0').toUpperCase() +
			Math.floor(Math.random()*16777215).toString(16).padStart(6,'0').toUpperCase();
}

module.exports.signup = async event => {

	let userID = genUserId()
    let insertRequest = { TableName,
        Item:{ 
            id: userID, 
            account_name: 'Un-named list', 
            joined: [userID], 
            active: userID,
            shopping_items : [{
				checked : false,
				expected : 2,
				home : 'Fridge',
				name : 'Milk',
				notes: '1 Gallon Whole Organic',
				onList : 2,
				store : 'Dairy'
			}],
            store_loc: [
				'Produce',
				'Meats',
				'Bakery',
				'Dairy',
				'Aisle 1',
				'Aisle 2',
				'Aisle 3',
				'Aisle 4',
				'Aisle 5',
				'Aisle 6',
				'Aisle 7',
				'Aisle 8',
				'Aisle 9',
				'Aisle 10',
				'Aisle 11',
				'Aisle 12',
				'Aisle 13',
				'Aisle 14',
				'Aisle 15',
				'Aisle 16',
				'Aisle 17',
				'Aisle 18',
				'unsorted',
			],
            home_loc: [
				'Fridge',
				'Freezer',
				'Pantry',
				'Toiletires',
				'unsorted',
			],
			color : 'blue'
	}}

    return await dataInsert( insertRequest );
}

// ! Loading User Data

module.exports.loadUser = async event => {

    let {userID} = JSON.parse(event.body)
    let accessRequest = { TableName,  Key: { 'id': userID } };
    
    return await dataAccess( accessRequest );
}

// ! Set User Data

module.exports.setName = async event => {

    let { userID, name } = JSON.parse(event.body)

    let updateRequest = { 
		TableName,
        Key:{ "id": userID },
        UpdateExpression: "set account_name = :n",
        ExpressionAttributeValues:{ ":n" : name }
    };
    
    return await dataUpdate( updateRequest );
}

module.exports.setNewQuantity = async event => {

    let { userID, index, count } = JSON.parse(event.body)

    let updateRequest = {
        TableName,
        Key:{ "id": userID },
        UpdateExpression:"set shopping_items["+index+"].onList = :c",
        ExpressionAttributeValues:{ ":c":count }
    };
    
    return await dataUpdate( updateRequest );
}


module.exports.reorderHomeLocations = async event => {

    let { userID, newOrder } = JSON.parse(event.body)

    let updateRequest = {
        TableName,
        Key:{ "id": userID },
        UpdateExpression:"set home_loc = :l",
        ExpressionAttributeValues:{ ":l": newOrder }
    };
    
    return await dataUpdate( updateRequest );
}


module.exports.reorderStoreLocations = async event => {

    let { userID, newOrder } = JSON.parse(event.body)

    let updateRequest = {
        TableName,
        Key:{ "id": userID },
        UpdateExpression:"set store_loc = :l",
        ExpressionAttributeValues:{ ":l": newOrder }
    };
    
    return await dataUpdate( updateRequest );
}


module.exports.newItem = async event => {

    let { name, notes, home, store, expected, userID } = JSON.parse(event.body)

    let item = { name, notes, expected, onList: 0, home, store, checked : false }
	
    let updateRequest = { 
		TableName,
        Key:{ "id": userID },
        UpdateExpression:"set shopping_items = list_append(shopping_items, :i)",
        ExpressionAttributeValues:{ ":i": [item] }
    };
        
    return await dataUpdate( updateRequest );
}


module.exports.updateItem = async event => {

    let { name, notes, home, store, expected, userID, onList, checked, index } = JSON.parse(event.body)
	let item = { name, notes, onList, checked, expected, home, store }
	
    let updateRequest = {
        TableName,
        Key:{ "id": userID },
        UpdateExpression:"set shopping_items["+index+"] = :d",
        ExpressionAttributeValues:{ ":d": item },
    };
    
    return await dataUpdate( updateRequest );
}

module.exports.renameLocation = async event => {
    
	let { oldName, newName, userID, home } = JSON.parse(event.body)
	
	let userData = ( await rawDataAccess( userID )) ['Item'];
	let target = home ? 'home' : 'store';
	let targetLocation = `${target}_loc`
	
	userData['shopping_items'].forEach( item => {
		if ( item[ target ] == oldName )
			item[ target ] = newName
	});

	userData[ targetLocation ] = userData[ targetLocation ].map( loc => loc == oldName ? newName : loc)

	/*console.log( oldName, newName )
	console.log ( targetLocation )
	console.log( userData[ targetLocation ] )
	console.log( userData[ targetLocation ].includes(oldName)) 
	console.log( JSON.stringify( userData) );*/

	let updateRequest = {
		TableName,
		Key:{ "id": userID },
		UpdateExpression:"set shopping_items = :i , home_loc = :h , store_loc = :s",
		ExpressionAttributeValues:{
			":i": userData['shopping_items'],
			":h": userData['home_loc'],
			":s": userData['store_loc']
		}
	}; 
	
	return await dataUpdate( updateRequest );
	
}

module.exports.deleteLocation = async event => {
    
	let { location, userID, home } = JSON.parse(event.body)
	
	let userData = ( await rawDataAccess( userID )) ['Item'];
	let target = home ? 'home' : 'store';
	let targetLocation = `${target}_loc`
	
	// Move items to unsorted
	userData['shopping_items'].forEach( item => {
		if ( item[ target ] === location )
			item[target] = 'unsorted'
	})

	// Add unsorted locaiton if it doesnt exist
	if ( ! userData[ targetLocation ].includes('unsorted') ) 
		userData[ targetLocation ].push('unsorted')

	// Remove location from location list
	userData[ targetLocation ] = userData[ targetLocation ].filter( loc => loc != location )

	let updateRequest = {
		TableName ,
		Key:{ "id": userID },
		UpdateExpression:"set shopping_items = :i , home_loc = :h , store_loc = :s",
		ExpressionAttributeValues:{
			":i": userData['shopping_items'],
			":h": userData['home_loc'],
			":s": userData['store_loc']
		}
	};

	return await dataUpdate( updateRequest );
}

module.exports.newLocation = async event => {
    
    let { userID, home, location } = JSON.parse(event.body)
	let target = home ? 'home_loc' : 'store_loc';

    let updateRequest = {
        TableName,
        Key:{ "id": userID },
        UpdateExpression: `set ${target} = list_append(${target}, :i)`,
        ExpressionAttributeValues:{ ":i": [location] }
    }

	return await dataUpdate( updateRequest );

}

module.exports.deleteItem = async event => {
    
    let { userID, index } = JSON.parse(event.body)

    let updateRequest = {
        TableName,
        Key:{ "id": userID },
        UpdateExpression: `REMOVE shopping_items[${index}]`
	}
	
	return await dataUpdate( updateRequest );
}

module.exports.setChecked = async event => {
    
    let { userID, index, checked } = JSON.parse(event.body)

    let updateRequest = {
        TableName,
        Key:{ "id": userID },
        UpdateExpression:"set shopping_items["+index+"].checked = :c",
        ExpressionAttributeValues:{
            ":c": checked
        }
    };

	return await dataUpdate( updateRequest );
}

module.exports.finishShopping = async event => {
    
    let { userID } = JSON.parse(event.body)
    let userDataRequest = { TableName: 'grocery-users', Key: { 'id': userID } };

	let userData = ( await rawDataAccess( userID )) ['Item'];

	userData['shopping_items'].forEach( item => {
		if ( item.checked ){
			item.checked = false;
			item.onList = 0;
		}
	});
	
	let updateRequest = {
		TableName,
		Key:{ "id": userID },
		UpdateExpression:"set shopping_items = :i",
		ExpressionAttributeValues:{
			":i": userData['shopping_items'],
		}
	};

	return await dataUpdate( updateRequest );
}


module.exports.SetActiveAccount = async event => {
    
    let { userID, userIDActive } = JSON.parse(event.body)
	let userData = ( await rawDataAccess( userID )) ['Item'];

	let validAccount = (await rawDataAccess( userIDActive ))['Item'];
	console.log( userIDActive, validAccount['account_name'] )
	if ( ! validAccount['account_name'] ) return { statusCode: 500, body : 'Invalid Account' }

	if ( ! userData['joined'].includes(userIDActive) )
		userData['joined'].push( userIDActive )

    let updateRequest = {
        TableName,
        Key:{ "id": userID },
        UpdateExpression: `set active = :a , joined = :i `,
        ExpressionAttributeValues:{ ":a": userIDActive, ":i": userData['joined'] }
    }

	return await dataUpdate( updateRequest );
}


module.exports.RenameAccout = async event => {
    
	let { userID, name } = JSON.parse(event.body)
	
    let updateRequest = {
        TableName,
        Key:{ "id": userID },
        UpdateExpression: `set account_name = :a `,
        ExpressionAttributeValues:{ ":a": name }
    }

	return await dataUpdate( updateRequest );
}

