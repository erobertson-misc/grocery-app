import 'package:flutter/material.dart';
import 'package:grocery_app2/_widgetLibrary/Inputs/NumberInput.dart';
import 'package:grocery_app2/_widgetLibrary/Other/IconIndicator.dart';

typedef ValueChange = void Function(String key, dynamic newValue);

class DataEditItem {
	final String title;
	final IconData icon;
	final String type;
	final dynamic state;
	final dynamic options;
	DataEditItem({this.title, this.icon, this.type, this.state, this.options}); 
}

class RawDataEdit extends StatelessWidget {

	final List<DataEditItem> data;
	final ValueChange onChange;

	RawDataEdit({ Key key, this.data, this.onChange }) : super(key: key);

	Widget generateDataEdit (BuildContext context, DataEditItem item ){
		if ( item.type == 'string'){
			return TextFormField(
				initialValue: item.state as String,
				onChanged: (String s){
					onChange( item.title, s );
				},
				decoration: InputDecoration(
					hintText: item.title + ' here',
					contentPadding: EdgeInsets.only(right: 20)
				),
				style: TextStyle( color : Theme.of(context).primaryColor, fontWeight: FontWeight.w800, fontSize: 14),				
				textAlign: TextAlign.end,
			);
		}
		if ( item.type == 'number'){
			return NumberInput(
					dark: true,
					quantity: item.state as int,
					modifyQuantity: (int n){
						onChange( item.title, n );
				});
		}
		if ( item.type == 'cataglory'){
			return DropdownButton(
				value: item.state as String,
				iconSize: 24,
				elevation: 16,
             	items: item.options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle( color: Theme.of(context).primaryColor)),
                    );
              	}).toList(),
              	onChanged: (String s){onChange( item.title, s ) ;},
            );
		}
		else return null;
	}

	Widget build(BuildContext context) {
		return Column( 
			children: [
				Column( children : data.map( (item) => Container( child :
					Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween, 
						children: [
							Row( children: [ 
								IconIndicator( icon: item.icon, inverse: true, border: true ), 
								Text( item.title, style: TextStyle( color : Theme.of(context).primaryColor, fontWeight: FontWeight.w800) ),
							]),
							Container( child : generateDataEdit( context, item), width: 200 )
							
					]),
					decoration: BoxDecoration(
						borderRadius: BorderRadius.all( Radius.circular(4) ),
						color: Theme.of(context).accentColor
					),
					margin: EdgeInsets.all(5),
					padding: EdgeInsets.only(right: 20)
				)).toList()),
			],
		);
  	}

}