import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app2/Views/AccountLinkView.dart';
import 'package:grocery_app2/Views/HouseLocationView.dart';
import 'package:grocery_app2/Views/ItemInfoView.dart';
import 'package:grocery_app2/Views/LocationInfoView.dart';
import 'package:grocery_app2/Widgets/AccountListResult.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FilterButton.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/FlatIconButton.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/PaddedIconButton.dart';
import 'package:grocery_app2/_widgetLibrary/Headers/IconHeader.dart';
import 'package:grocery_app2/_widgetLibrary/Layouts/HeaderContentLayout.dart';
import 'package:grocery_app2/_widgetLibrary/ListItems/DraggableButtonListItem.dart';
import 'package:grocery_app2/_widgetLibrary/Other/IconIndicator.dart';
import 'package:grocery_app2/_widgetLibrary/Text/TitleText.dart';
import 'package:grocery_app2/_widgetLibrary/Text/ToggledText.dart';

class AccountTab extends StatefulWidget {

	AccountTab({Key key}) : super(key: key);
	AccountTabState createState() => AccountTabState();

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

class AccountTabState extends State<AccountTab> {

  	TextEditingController _controller = TextEditingController( );
	
	void initState(){
		super.initState();
		_controller.text = accountName;
	}

	List<Widget> getAccounts () {
		return joinedAccounts.map( (account){
			return AccountListResult( account: account, active: activeUserID==account, reload: (){ setState((){}); }, );
		}).toList();
	}

	Widget build(BuildContext context) {

		return HeaderContentLayout(
			header: IconHeader(
				icon: Icons.settings,
				content: [ TitleText(text: 'Account Settings' )],
				alignment: 'right',
			),
			content: [
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Container( 
							width: 250,
							child: TextFormField(
								controller: _controller,
								decoration: InputDecoration( 
									hintText: 'Name of your account',
									hintStyle: TextStyle( color: Theme.of(context).primaryColor ),
									prefixIcon: Icon(Icons.account_circle, color: Theme.of(context).primaryColor),
								),
								style: TextStyle( color : Theme.of(context).primaryColor ),
							),
						),
						FlatButton(child: IconIndicator(icon: Icons.check, border: true, inverse: true,), onPressed: (){
							if ( _controller.text  == '' ) showError('List must have a name');
							else renameAccount( _controller.text ).then((_){ setState((){}); });
						})
					]
				),
				Container(
					width: 350,
					padding: EdgeInsets.all(10),
					margin: EdgeInsets.all(20), 
					child: Column(children: <Widget>[
						FlatIconButton(icon: Icons.info, text: 'View linking info', onTap: (){
							showAccountInformationDialog( context, yourUserID.substring(0,4) + ' - ' + yourUserID.substring(4,8) + ' - ' + yourUserID.substring(8,12));
						}),
						FlatIconButton(icon: Icons.info, text: 'Link to another account', onTap: (){
							Navigator.push(context, MaterialPageRoute(builder: (context) => AccountLinkView()));
						})
					]),
					decoration: BoxDecoration(
						color: Theme.of(context).accentColor,
						borderRadius: BorderRadius.all( Radius.circular(4) ),
						border: Border.all( color: Theme.of(context).primaryColor, width: 1.0 ),
					),
				),
				Container(
					width: 350,
					padding: EdgeInsets.all(10),
					margin: EdgeInsets.all(20), 
					child: Column(children: <Widget>[
						Text('Select Active List'),
						Column(children: getAccounts() )
					]),
					decoration: BoxDecoration(
						color: Theme.of(context).accentColor,
						borderRadius: BorderRadius.all( Radius.circular(4) ),
						border: Border.all( color: Theme.of(context).primaryColor, width: 1.0 ),
					),
				)
			],
		);
  	}


}

showAccountInformationDialog(BuildContext context, String text) {

  Widget okButton = FlatButton(
    child: Text("Dismiss"),
    onPressed: () { Navigator.of(context).pop(); },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Account Linking Information"),
    content: Text("This is the account number needed for linking: \n\n $text"),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}