'use strict';

let AWS = require("aws-sdk");
AWS.config.update({ region: "us-east-1" });
var database = new AWS.DynamoDB.DocumentClient();

module.exports.setName = async event => {

    let req = JSON.parse(event.body)

    let data = {
        TableName: 'grocery-users',
        Key:{
            "id": req.userID,
        },
        UpdateExpression: "set account_name = :n",
        ExpressionAttributeValues:{
            ":n":req.name
        },
        ReturnValues:"NONE"
    };
    
    return await new Promise( (yes,no) => {
        database.update(data, (err,data) => {
            if ( err ) {
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                yes({ statusCode: 200, body: JSON.stringify(data) })
            }
        })
    })
}

module.exports.setNewQuantity = async event => {

    let req = JSON.parse(event.body)

    let data = {
        TableName: 'grocery-users',
        Key:{
            "id": req.userID,
        },
        UpdateExpression:"set shopping_items["+req.index+"].onList = :c",
        ExpressionAttributeValues:{
            ":c":req.count
        },
        ReturnValues:"NONE"
    };
    
    return await new Promise( (yes,no) => {
        database.update(data, (err,data) => {
            if ( err ) {
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                yes({ statusCode: 200, body: JSON.stringify(data) })
            }
        })
    })
}


module.exports.reorderHomeLocations = async event => {

    let req = JSON.parse(event.body)

    let data = {
        TableName: 'grocery-users',
        Key:{
            "id": req.userID,
        },
        UpdateExpression:"set home_loc = :l",
        ExpressionAttributeValues:{
            ":l":req.newOrder
        },
        ReturnValues:"NONE"
    };
    
    return await new Promise( (yes,no) => {
        database.update(data, (err,data) => {
            if ( err ) {
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                yes({ statusCode: 200, body: JSON.stringify(data) })
            }
        })
    })
}



module.exports.reorderStoreLocations = async event => {

    let req = JSON.parse(event.body)

    let data = {
        TableName: 'grocery-users',
        Key:{
            "id": req.userID,
        },
        UpdateExpression:"set store_loc = :l",
        ExpressionAttributeValues:{
            ":l":req.newOrder
        },
        ReturnValues:"NONE"
    };
    
    return await new Promise( (yes,no) => {
        database.update(data, (err,data) => {
            if ( err ) {
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                yes({ statusCode: 200, body: JSON.stringify(data) })
            }
        })
    })
}


module.exports.newItem = async event => {

    let req = JSON.parse(event.body)

    let item = {
        name : req.name,
        notes: req.notes,
        onList: 0,
        home_loc: req.home,
        store_loc: req.store,
        expected: req.expected,
        checked : false,
    }
    let data = {
        TableName: 'grocery-users',
        Key:{
            "id": req.userID,
        },
        UpdateExpression:"set shopping_items = list_append(shopping_items, :i)",
        ExpressionAttributeValues:{
            ":i": [item]
        },
        ReturnValues:"ALL_NEW"
    };
    
    console.log( item )

    return await new Promise( (yes,no) => {
        database.update(data, (err,data) => {
            if ( err ) {
                console.log( err )
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                console.log( data )
                yes({ statusCode: 200, body: JSON.stringify(data) })
            }
        })
    })
}


module.exports.updateItem = async event => {

    let req = JSON.parse(event.body)

    let item = {
        name : req.name,
        notes: req.notes,
        onList: req.onList,
        home_loc: req.home,
        store_loc: req.store,
        expected: req.expected,
        checked: req.checked
    }
    let data = {
        TableName: 'grocery-users',
        Key:{
            "id": req.userID,
        },
        UpdateExpression:"set shopping_items["+req.index+"] = :d",
        ExpressionAttributeValues:{
            ":d": item
        },
        ReturnValues:"NONE"
    };
    
    console.log( item )

    return await new Promise( (yes,no) => {
        database.update(data, (err,data) => {
            if ( err ) {
                console.log( err )
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                console.log( data )
                yes({ statusCode: 200, body: JSON.stringify(data) })
            }
        })
    })
}


module.exports.renameLocation = async event => {
    
    let req = JSON.parse(event.body)
    let oldName = req.old
    let newName = req.new
    let userID = req.userID
    let home = req.home

    console.log( req );

    let userDataRequest = { TableName: 'grocery-users', Key: { 'id': userID } };

    return await new Promise( (yes,no) => {
        database.get(userDataRequest, (err,data) => {
            if ( err ) {
                console.log( err )
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                let userData = data['Item']
                
                userData['shopping_items'].forEach( item => {
                    if( home ){
                        if ( item['home_loc'] == oldName )
                            item['home_loc'] = newName
                    }
                    else{
                        if ( item['store_loc'] == oldName )
                            item['store_loc'] = newName
                    }
                })
                if ( home ) 
                    userData['home_loc'] = userData['home_loc'].map( loc => loc == oldName ? newName : loc)
                else
                    userData['store_loc'] = userData['store_loc'].map( loc => loc == oldName ? newName : loc)

                
                let updateData = {
                    TableName: 'grocery-users',
                    Key:{
                        "id": userID,
                    },
                    UpdateExpression:"set shopping_items = :i , home_loc = :h , store_loc = :s",
                    ExpressionAttributeValues:{
                        ":i": userData['shopping_items'],
                        ":h": userData['home_loc'],
                        ":s": userData['store_loc']
                    },
                    ReturnValues:"NONE"
                };
                database.update(updateData, (err,data) => {
                    if ( err ) {
                        console.log( err )
                        yes({ statusCode: 500, body : JSON.stringify(err) })
                    }
                    if ( data ) {
                        console.log( data )
                        yes({ statusCode: 200, body: JSON.stringify(data) })
                    }
                })
            }
        })
    })

}


module.exports.deleteLocation = async event => {
    
    let req = JSON.parse(event.body)
    let userID = req.userID
    let home = req.home
    let location = req.location

    console.log( req );

    let userDataRequest = { TableName: 'grocery-users', Key: { 'id': userID } };

    return await new Promise( (yes,no) => {
        database.get(userDataRequest, (err,data) => {
            if ( err ) {
                console.log( err )
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                let userData = data['Item']
                
                userData['shopping_items'].forEach( item => {
                    if( home ){
                        if ( item['home_loc'] === location )
                            item['home_loc'] = 'unsorted'
                    }
                    else{
                        if ( item['store_loc'] === location )
                            item['store_loc'] = 'unsorted'
                    }
                })
                if ( home && ! userData['home_loc'].includes('unsorted') ) 
                    userData['home_loc'].push('unsorted')
                if ( !home && ! userData['store_loc'].includes('unsorted') ) 
                    userData['store_loc'].push('unsorted')

                if ( home ) userData['home_loc'] = userData['home_loc'].filter( loc => loc != location )
                if ( !home ) userData['store_loc'] = userData['store_loc'].filter( loc => loc != location )
                
                let updateData = {
                    TableName: 'grocery-users',
                    Key:{
                        "id": userID,
                    },
                    UpdateExpression:"set shopping_items = :i , home_loc = :h , store_loc = :s",
                    ExpressionAttributeValues:{
                        ":i": userData['shopping_items'],
                        ":h": userData['home_loc'],
                        ":s": userData['store_loc']
                    },
                    ReturnValues:"NONE"
                };
                console.log( JSON.stringify(data) );
                database.update(updateData, (err,data) => {
                    if ( err ) {
                        console.log( err )
                        yes({ statusCode: 500, body : JSON.stringify(err) })
                    }
                    if ( data ) {
                        console.log( data )
                        yes({ statusCode: 200, body: JSON.stringify(data) })
                    }
                })
            }
        })
    })

}


module.exports.newLocation = async event => {
    
    let req = JSON.parse(event.body)
    let userID = req.userID
    let home = req.home
    let location = req.location

    console.log( req );
    let updateData = {
        TableName: 'grocery-users',
        Key:{
            "id": req.userID,
        },
        UpdateExpression: home ? "set home_loc = list_append(home_loc, :i)" :  "set store_loc = list_append(store_loc, :i)" ,
        ExpressionAttributeValues:{
            ":i": [location]
        },
        ReturnValues:"NONE"
    }

    return await new Promise( (yes,no) => {
        database.update(updateData, (err,data) => {
            if ( err ) {
                console.log( err )
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                console.log( data )
                yes({ statusCode: 200, body: JSON.stringify(data) })
            }
        })
    })

}


module.exports.deleteItem = async event => {
    
    let req = JSON.parse(event.body)
    let userID = req.userID
    let target = req.item

    console.log( req );

    let userDataRequest = { TableName: 'grocery-users', Key: { 'id': userID } };

    return await new Promise( (yes,no) => {
        database.get(userDataRequest, (err,data) => {
            if ( err ) {
                console.log( err )
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                let userData = data['Item']
                
                userData['shopping_items'] = userData['shopping_items'].filter( item => item.name != target );

                let updateData = {
                    TableName: 'grocery-users',
                    Key:{
                        "id": userID,
                    },
                    UpdateExpression:"set shopping_items = :i",
                    ExpressionAttributeValues:{
                        ":i": userData['shopping_items'],
                    },
                    ReturnValues:"NONE"
                };
                database.update(updateData, (err,data) => {
                    if ( err ) {
                        console.log( err )
                        yes({ statusCode: 500, body : JSON.stringify(err) })
                    }
                    if ( data ) {
                        console.log( data )
                        yes({ statusCode: 200, body: JSON.stringify(data) })
                    }
                })
            }
        })
    })

}


module.exports.setChecked = async event => {
    
    let req = JSON.parse(event.body)
    let userID = req.userID
    let index = req.item
    let checked = req.checked

    let data = {
        TableName: 'grocery-users',
        Key:{
            "id": userID,
        },
        UpdateExpression:"set shopping_items["+index+"].checked = :c",
        ExpressionAttributeValues:{
            ":c": checked
        },
        ReturnValues:"NONE"
    };

    return await new Promise( (yes,no) => {
        database.update(data, (err,data) => {
            if ( err ) {
                console.log( err )
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                console.log( data )
                yes({ statusCode: 200, body: JSON.stringify(data) })
            }
        })
    })

}

module.exports.finishShopping = async event => {
    
    let req = JSON.parse(event.body)
    let userID = req.userID

    console.log( req );

    let userDataRequest = { TableName: 'grocery-users', Key: { 'id': userID } };

    return await new Promise( (yes,no) => {
        database.get(userDataRequest, (err,data) => {
            if ( err ) {
                console.log( err )
                yes({ statusCode: 500, body : JSON.stringify(err) })
            }
            if ( data ) {
                let userData = data['Item']
                
                userData['shopping_items'].forEach( item => {
                    if ( item.checked ){
                        item.checked = false;
                        item.onList = 0;
                    }
                });
                console.log( userData['shopping_items']);

                let updateData = {
                    TableName: 'grocery-users',
                    Key:{
                        "id": userID,
                    },
                    UpdateExpression:"set shopping_items = :i",
                    ExpressionAttributeValues:{
                        ":i": userData['shopping_items'],
                    },
                    ReturnValues:"NONE"
                };
                database.update(updateData, (err,data) => {
                    if ( err ) {
                        console.log( err )
                        yes({ statusCode: 500, body : JSON.stringify(err) })
                    }
                    if ( data ) {
                        console.log( data )
                        yes({ statusCode: 200, body: JSON.stringify(data) })
                    }
                })
            }
        })
    })

}