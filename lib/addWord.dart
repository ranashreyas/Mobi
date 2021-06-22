import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdapp/suggestions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavBar.dart';
import 'Statistics.dart';
import 'draw_screen.dart';
import 'keyboard.dart';

class AddWord extends StatefulWidget {
  @override
  _AddWord createState() => _AddWord();
}

class _AddWord extends State<AddWord> {

  int _selectedIndex = 3;
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            automaticallyImplyLeading: false,
            title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text("Add Word", style: new TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                )
              )
            ),
            backgroundColor: Colors.cyan[100],
          ),
          preferredSize: Size.fromHeight(60),
        ),

        body: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(2.0),
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter a search term'

                ),
              ),
            ),

            Container(
              height: 100,
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              child: FlatButton(
                splashColor: Colors.cyan[100],
                child: Center(
                    child: Text("Add Word", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  List <String> _wordList = prefs.getStringList("All_Words");
                  _wordList.add(myController.text.replaceAll(" ", "-").toLowerCase());
                  await prefs.setStringList("All_Words", _wordList);
                  print(_wordList.toString());
                  myController.text = "";
                },
              )
            )

          ],
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.show_chart),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Statistics()));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavBar(),
      )
    );
  }



}