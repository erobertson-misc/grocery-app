import 'package:flutter/material.dart';
import 'package:grocery_app2/_widgetLibrary/Other/IconIndicator.dart';

class DataViewItem {
	final String title;
	final IconData icon;
	final String data;
	DataViewItem({this.title = '', this.icon, this.data = ''}); 
}

class RawDataView extends StatelessWidget {

	final List<DataViewItem> data;

	RawDataView({ Key key, this.data }) : super(key: key);

	Widget build(BuildContext context) {
		return Column( 
			children: data.map( (item) => Container( child :
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween, 
					children: [
						Row( children: [ 
							IconIndicator( icon: item.icon, inverse: true, border: true ), 
							Text( item.title, style: TextStyle( color : Theme.of(context).primaryColor, fontWeight: FontWeight.w800) ),
						]),
						Flexible( child: Text(
							item.data, 
							maxLines: 5, 
							style: TextStyle( color : Theme.of(context).primaryColor, fontWeight: FontWeight.w800), textAlign: TextAlign.right, )
						)
				]),
				decoration: BoxDecoration(
					borderRadius: BorderRadius.all( Radius.circular(4) ),
					color: Theme.of(context).accentColor
				),
				margin: EdgeInsets.all(5),
				padding: EdgeInsets.only(right: 20)
			)).toList(),
		);
  	}

}