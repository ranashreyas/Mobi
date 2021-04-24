import 'package:flutter/material.dart';
import 'package:pdapp/suggestions.dart';

import 'addWord.dart';
import 'draw_screen.dart';
import 'keyboard.dart';


class BottomNavBar extends StatefulWidget {
  @override
  State createState() => new BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {

  @override
  Widget build(BuildContext context) {
    return new BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Colors.cyan[50],
      child: new Container(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.07, 0, MediaQuery.of(context).size.width*0.07, 0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.library_books, color: Colors.black),
//                  title: Text('Mobility Tests'),
              color: Colors.cyan[100],
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Draw()));
              },
            ),
            IconButton(
              icon: Icon(Icons.keyboard, color: Colors.black87),
//                  title: Text("Advanced Keyboard"),
              color: Colors.cyan[100],
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Keyboard()));
              },
            ),
            IconButton(
              icon: Icon(Icons.list, color: Colors.black87),
//                  title: Text("Suggested Words"),
              color: Colors.cyan[100],
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Suggestions()));
              },
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.black87),
//                  title: Text('Add Word'),
              color: Colors.cyan[100],
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddWord()));
              },
            ),
          ]
        )
      )
    );
  }
}