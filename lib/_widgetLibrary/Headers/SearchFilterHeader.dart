import 'package:flutter/material.dart';
import '../Buttons/FilterButton.dart';

typedef SearchChange = void Function(String newText);
typedef FilterChange = void Function(String filter);

class SearchFilterHeader extends StatefulWidget {

	final String hint;
	final List<String> filters;
	final SearchChange onChange;
	final FilterChange onFilter;

	SearchFilterHeader({ Key key,  this.hint, this.filters, this.onChange, this.onFilter }) : super(key: key);
	SearchFilterHeaderState createState() => SearchFilterHeaderState();

}

class SearchFilterHeaderState extends State<SearchFilterHeader> {

  	TextEditingController _controller = TextEditingController( );
	String filter;

	// Init

	void initState(){
		super.initState();
		filter = widget.filters[0];
	}

	// Rendering 

	Widget build(BuildContext context) {
		return Container(
			width: 350,
			child: Column( children: [
				Container( child: 
					Row( 
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children : [
							Container( 
								width: 250,
								child: TextFormField(
									controller: _controller,
									decoration: InputDecoration( 
										hintText: widget.hint,
										hintStyle: TextStyle( color: Theme.of(context).primaryColor ),
										border: InputBorder.none,
										prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
									),
									style: TextStyle( color : Theme.of(context).primaryColor ),
									onChanged: widget.onChange,
								),
							),
							IconButton(
								icon: Icon(Icons.cancel),
								color: Theme.of(context).primaryColor,
								onPressed: (){
									_controller.text = '';
									widget.onChange('');
								},
							)
					]),
					padding: EdgeInsets.only(top: 3),
					decoration: BoxDecoration(
						color: Theme.of(context).backgroundColor,
						borderRadius: BorderRadius.all( Radius.circular(4) ),
						border: Border.all( color: Theme.of(context).primaryColor, width: 1.0 ),
					),
				),
				Row( 
					mainAxisAlignment: MainAxisAlignment.end,
					children: widget.filters.map((f) => 
						FilterButton( text: f, currentFilter: filter, requestSwitch: (){ setState((){ filter = f; widget.onFilter( f ); }) ;})
					).toList()
				)
			]),
			
		);
	}
	}

            