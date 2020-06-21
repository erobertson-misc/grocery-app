import 'package:flutter/material.dart';

typedef OnTap = void Function(  );

class DraggableButtonListItem extends StatelessWidget {

	final List<Widget> left;
	final List<Widget> right;
	final OnTap onTap;

	const DraggableButtonListItem({ Key key,  this.left, this.right, this.onTap }) : super(key: key);

	Widget build(BuildContext context) {
		return Container(
			height: 50,
			margin: EdgeInsets.all(3),
			child: Material( 
				color: Colors.transparent,
				child: InkWell(
					child : Container(
						padding: EdgeInsets.only(left: 10, right:10 ),
						child: Row( 
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Row ( children: left ),
								Row(
									children: [
										Row ( children: right),
										Container( margin: EdgeInsets.only(left: 10), child : Icon( Icons.drag_handle ))
									],
								)
							],
						),
					),
					onTap: onTap,
				)
			),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.all( Radius.circular(4) ),
				color: Theme.of(context).primaryColor,
			)
		);
	}

}

