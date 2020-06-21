import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_app2/_networking/dataTypes.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FlatIconButton.dart';
import 'package:grocery_app2/_widgetLibrary/ListItems/ToggleButtonListItem.dart';
import 'package:grocery_app2/_widgetLibrary/Other/IconIndicator.dart';
import 'package:grocery_app2/_widgetLibrary/Text/ToggledText.dart';

typedef Toggle = void Function ( bool state ) ;
typedef Callback = void Function( );

class AccountListResult extends StatefulWidget {

	final String account;
	final bool active;
	final Callback reload;

	const AccountListResult({ Key key, this.account, this.active, this.reload}) : super(key: key); 
	AccountListResultState createState() => AccountListResultState();

}

class AccountListResultState extends State<AccountListResult> {

	String name = '. . .';

	void initState() {
		super.initState();
		getNames();
	}

	Future<void> getNames() async {
		name = await lookupAccountName( widget.account );
		setState((){});
	}

	Widget build ( BuildContext context ){
		return ToggleButtonListItem(
			active: widget.active,
			left: [ IconIndicator(icon: Icons.account_circle, inverse: widget.active), Container( child : ToggledText ( text : name, active: widget.active ), margin: EdgeInsets.all(5)) ],
			right: [ IconIndicator(icon: Icons.touch_app, inverse: widget.active) ],
			onTap: () {
				setActiveAccount( widget.account ).then((_)=>{ widget.reload() });
			}
		);
	}

}