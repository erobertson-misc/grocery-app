import 'package:flutter/material.dart';
import 'package:grocery_app2/_widgetLibrary/Buttons/PaddedIconButton.dart';

typedef Callback = void Function();

class DataViewHeader extends StatelessWidget {

	final Callback onEdit;
	final Callback onDelete;
	final Callback onCreate;
	final String title;
	final bool highlightEdit;

	DataViewHeader({ Key key, this.title, this.onEdit, this.onDelete, this.highlightEdit = false, this.onCreate}) : super(key: key);

	// Rendering 

	Widget build(BuildContext context) {
		Color icons = Theme.of(context).primaryIconTheme.color;
		return Container(
			child: Row( 
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Row(children: [
						PaddedIconButton(icon : Icons.arrow_back_ios, onTap: (){ Navigator.pop(context); }),
						Text(title.length > 20 ?  title.substring(0,20) + '...' : title, style:  TextStyle( color: icons, fontSize: 18))
					]),
					Row( children: [
						onCreate == null ? Text('') : PaddedIconButton(icon : Icons.add, onTap: onCreate ),
						PaddedIconButton(icon : Icons.edit, onTap: onEdit, highlight: highlightEdit ),
						PaddedIconButton(icon : Icons.delete, onTap: onDelete ),
					]),
				],
			),
		);
	}
}

            