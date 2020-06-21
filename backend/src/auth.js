'use strict';

let AWS = require("aws-sdk");
AWS.config.update({ region: "us-east-1" });
var database = new AWS.DynamoDB.DocumentClient();


// New user wants to sign up for the app
module.exports.signup = async event => {

    // Get user a 12 didgit id
    let userID =
        Math.floor(Math.random()*16777215).toString(16).padStart(6,'0').toUpperCase() +
        Math.floor(Math.random()*16777215).toString(16).padStart(6,'0').toUpperCase();

    // Register it in the database
    let data = { 
        TableName:'grocery-users', 
        Item:{ 
            id: userID, 
            account_name: 'Un-named list', 
            joined: [userID], 
            active: userID,
            shopping_items : [],
            store_loc: [],
            home_loc: [],
        }
    }
    return await new Promise( (yes,no) => {
        database.put(data, (err,data) => {
            if ( err ) yes({ statusCode: 500, body : JSON.stringify(err) })
            if ( data ) yes({ statusCode: 200, body: userID })
        })
    })

}

module.exports.loadUser = async event => {

    let userID = JSON.parse(event.body).userID
    console.log( userID )

    let data = {
        TableName: 'grocery-users',
        Key: { 'id': userID }
    };
    console.log( data )
    
    return await new Promise( (yes,no) => {
        database.get(data, (err,data) => {
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
