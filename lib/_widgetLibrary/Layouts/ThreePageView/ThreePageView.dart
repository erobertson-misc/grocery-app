import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PositionalIndicator.dart';

class ThreePageView extends StatefulWidget {

	final List<Widget> views;
	final List<IconData> icons;
	final Widget floatingIconView;
	final IconData floatingIcon;

	ThreePageView({Key key, this.icons, this.views, this.floatingIconView, this.floatingIcon}) : super(key: key);
	ThreePageViewState createState() => ThreePageViewState();

}

class ThreePageViewState extends State<ThreePageView> {

	PageController _controller = PageController( initialPage: 1 );
	int currentPage = 1;

	// Init

	void initState(){
		super.initState();
		_controller.addListener( _onScroll );
	}
	
	// Update

	void _onScroll() {
		if (currentPage !=_controller.page.round() ) 
			setState( () =>  currentPage = _controller.page.round() );
	}

	// Rendering 

	Widget buildFloatingIcon () {
		if ( widget.floatingIconView == null ) return null;
		return Padding(
			padding: const EdgeInsets.only(bottom: 40.0),
			child: FloatingActionButton(
				onPressed: (){
					Navigator.push(context, MaterialPageRoute(builder: (context) => widget.floatingIconView));
				},
				child: Icon(Icons.settings , color: Theme.of(context).primaryIconTheme.color, size:40), 
				backgroundColor: Theme.of(context).primaryColor,
			),
		);
	}

	Widget build(BuildContext context) {
		SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
			statusBarColor: Theme.of(context).secondaryHeaderColor
		));
		return Scaffold( 
			backgroundColor: Theme.of(context).backgroundColor,
			body: Column( children: [
				Flexible( child: PageView( 
						controller: _controller,
						children: widget.views 
						)
					),
					PositionalIndicator ( 
						position: currentPage, 
						icons: widget.icons,
						requestSwitch: ( int pos ){ 
							_controller.animateTo( MediaQuery.of(context).size.width * pos, duration: Duration( milliseconds: 300 ), curve: Curves.easeInOut ); 
						},
					)
				]),
				floatingActionButton: buildFloatingIcon()
		);
  	}

}
