import 'package:flutter/material.dart';

typedef ModifyQuantity = void Function( int delta );

class NumberInput extends StatelessWidget {

	final int quantity;
	final ModifyQuantity modifyQuantity;
	final bool dark;

	const NumberInput({ Key key, this.quantity, this.modifyQuantity, this.dark = false }) : super(key: key);

	void change ( int delta ) {
		if ( quantity + delta < 0 ) return;
		modifyQuantity( quantity + delta );
	}
	void increment(){ change( 1 ); }
	void decrement(){ change( -1 ); }


	List<Widget> getIndicator (BuildContext context ) {
		Color primary = Theme.of(context).primaryColor;
		Color icon = Theme.of(context).primaryIconTheme.color;
		if ( quantity > 0 )
			return [
				IconButton( icon: Icon( Icons.remove, color: dark? primary : icon ), onPressed: decrement),
				Container(
					margin: EdgeInsets.only(left: 10.0, right: 10.0),
					child : Text( quantity.toString(),style: TextStyle(fontSize: 15, color: dark? primary : icon ), )
				),
				IconButton( icon: Icon( Icons.add, color: dark? primary : icon ), onPressed: increment),
			];
		else
			return [IconButton( icon: Icon( Icons.add, color: Theme.of(context).primaryColor ), onPressed: increment)];
		
	}

	Widget build(BuildContext context) {
		return Material(
			child: Row( children: getIndicator( context), mainAxisAlignment: MainAxisAlignment.end, ),
			color: Colors.transparent,
		);
	}
}
