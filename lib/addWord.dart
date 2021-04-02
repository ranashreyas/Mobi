import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdapp/suggestions.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex == 3){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddWord()),
        );
      } else if(_selectedIndex == 2){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Suggestions()),
        );
      } else if(_selectedIndex==1){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Keyboard()),
        );
      } else if(_selectedIndex==0){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Draw()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            title: Text("Add Word", style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            )),
            backgroundColor: Colors.pink[100],
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.info, color: Colors.blueAccent, size: 30),
                onPressed: (){
                  //_instructionsModal(context);
                },
              )
            ],
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
                splashColor: Colors.pink[100],
                child: Center(
                    child: Text("Add Word", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  List <String> _wordList = prefs.getStringList(myController.text.toUpperCase()[0].toString());
                  _wordList.add(myController.text.replaceAll(" ", "-") + " 0 0 0");
                  await prefs.setStringList(myController.text.toUpperCase()[0].toString(), _wordList);
                  print(_wordList.toString());
                  myController.text = "";
                },
              )
            )

          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Tests'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.keyboard),
              title: Text("Advanced Keyboard"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text("Suggested Words"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('Add Word'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.redAccent,
          onTap: _onItemTapped,
        ),
      )
    );
  }



}