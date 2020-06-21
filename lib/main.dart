import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app2/Tabs/AccountTab.dart';
import 'package:grocery_app2/Tabs/ShoppingTab.dart';
import 'package:grocery_app2/Views/ItemInfoView.dart';
import 'package:grocery_app2/_networking/networking.dart';
import 'Tabs/HomeTab.dart';
import 'Tabs/ListTab.dart';
import '_widgetLibrary/Layouts/ThreePageView/ThreePageView.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> initialDataLoad () async {
  final prefs = await SharedPreferences.getInstance();
  //await prefs.clear();

  //prefs.clear();
  String userid = prefs.getString('userid') ?? '';
  bool showWelcomeScreen = false;
	print('Loading .$userid.');
  if ( userid == '' ){
    userid = await signupNewUser();
    prefs.setString('userid', userid);
    showWelcomeScreen = true;
  }
  setUserId(userid);
  await pullData();

  return showWelcomeScreen;
}

void main()  {
  	WidgetsFlutterBinding.ensureInitialized();
	SystemChrome.setPreferredOrientations([
		DeviceOrientation.portraitUp,
		DeviceOrientation.portraitDown,
	]);
	Widget app = Application();
	runApp( app );
}

class Application extends StatefulWidget {

	const Application({ Key key }) : super(key: key); 
	ApplicationState createState() => ApplicationState();

}

class ApplicationState extends State<Application> {
	
	bool welcome = false;
	bool processing = true;

	void initState(){
		super.initState();
  		initialDataLoad().then( (showWelcome) => {
			setState(() {
				print('got response of $showWelcome');
				Fluttertoast.cancel();
				welcome = showWelcome;
				processing = false;
			})
		});
	}

	Widget build(BuildContext context) {
		setToastColor( Colors.blue[800] );
		print( 'Main re-rendered with welcome : $welcome');

		if ( processing )
			loading();

		return MaterialApp(
			
			title: 'Qucik Shop',
			debugShowCheckedModeBanner: false, 
			
			theme: ThemeData(
				primaryColor: Colors.blue,
				accentColor: Colors.blue[100],
				secondaryHeaderColor: Colors.blue[800],

				backgroundColor: Colors.grey[100],
				hoverColor: Colors.grey[300],

				iconTheme: IconThemeData( color: Colors.white ),

				visualDensity: VisualDensity.adaptivePlatformDensity,
			),

			home: ThreePageView(
				views : [
					ShoppingTab(),
					processing ? Text('Pulling data from cloud') : ListTab( welcome: welcome),
					HomeTab(),
					AccountTab(),
				],
				icons: [ 
					Icons.shopping_basket,
					Icons.view_list,
					Icons.home,
					Icons.settings,
				]
			)

		);
	}
	

}