import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app2/Views/ItemInfoView.dart';
import 'package:grocery_app2/_networking/networking.dart';

class AccountLinkView extends StatefulWidget {
  AccountLinkView({ 
    Key key
  }) : super(key: key);
  AccountLinkViewState createState() => AccountLinkViewState();
}

class AccountLinkViewState extends State<AccountLinkView> {

  List<String> code = ['','',''];

  update (int i ) => (String s){
    setState((){
      code[i] = s.toUpperCase();
    });
  };

  Widget input ( int number ){
    return Container(
      margin: EdgeInsets.all(4),
      width: 80,
      child: TextFormField(
        textCapitalization: TextCapitalization.characters,
        textAlign: TextAlign.center,
        initialValue: '',
        inputFormatters: [
          LengthLimitingTextInputFormatter(4),
        ],
		onChanged: update(number),
      )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Link this device to another'),
      ),
      body: Container( 
        margin: EdgeInsets.only(top: 50),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text('Enter the code from the device you want to link to'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                input(0),
                input(1),
                input(2),
              ]
            ),
            Container( margin: EdgeInsets.all(20), child:
              FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text('Link Device', style: TextStyle( color: Theme.of(context).primaryIconTheme.color, fontWeight: FontWeight.bold )),
                onPressed: (){ 
					if ( code.join('').length != 12 )
						showError('Please enter a 12 character code');
					else
						setActiveAccount(code.join('')).then((_)=>{ Navigator.pop(context) });
				},
              )
            )
          ]
        )
      )
    );
  }
}