import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'draw_screen.dart';

class Keyboard extends StatefulWidget {
  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {

  int _selectedIndex = 1;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<String> _wordList = new List();
  List<Widget> _widgetWords = new List();

  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    _createSharedPrefs();
  }


  Future _createSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("A")) {
      List<String> dict = new List();
      dict.add("ac-high 0 0 0");
      dict.add("ac-low 0 0 0");
      dict.add("ac-off 0 0 0");
      dict.add("ac-on 0 0 0");
      dict.add("airbed 0 0 0");
      await prefs.setStringList("A", dict);
      dict.clear();

      dict.add("bathroom 0 0 0");
      dict.add("bed-down 0 0 0");
      dict.add("breathing-prob 0 0 0");
      dict.add("bed 0 0 0");
      await prefs.setStringList("B", dict);
      dict.clear();

      dict.add("chair 0 0 0");
      dict.add("change 0 0 0");
      dict.add("clean 0 0 0");
      dict.add("clothes 0 0 0");
      dict.add("cold 0 0 0");
      dict.add("cream 0 0 0");
      dict.add("crushed 0 0 0");
      await prefs.setStringList("C", dict);
      dict.clear();

      dict.add("dressing 0 0 0");
      dict.add("drink 0 0 0");
      dict.add("dry 0 0 0");
      dict.add("dining-room 0 0 0");
      await prefs.setStringList("D", dict);
      dict.clear();

      dict.add("eat 0 0 0");
      await prefs.setStringList("E", dict);
      dict.clear();

      dict.add("fan-fast 0 0 0");
      dict.add("fan-off 0 0 0");
      dict.add("fan-on 0 0 0");
      dict.add("fan-slow 0 0 0");
      dict.add("fell 0 0 0");
      dict.add("fresh 0 0 0");
      dict.add("full 0 0 0");
      await prefs.setStringList("F", dict);
      dict.clear();

      dict.add("gate 0 0 0");
      await prefs.setStringList("G", dict);
      dict.clear();

      dict.add("half 0 0 0");
      dict.add("hand 0 0 0");
      dict.add("happy 0 0 0");
      dict.add("hospital 0 0 0");
      dict.add("hurt 0 0 0");
      await prefs.setStringList("H", dict);
      dict.clear();

      dict.add("less 0 0 0");
      dict.add("light-off 0 0 0");
      dict.add("light-on 0 0 0");
      await prefs.setStringList("L", dict);
      dict.clear();

      dict.add("massage 0 0 0");
      dict.add("medicine 0 0 0");
      dict.add("medicine-pain 0 0 0");
      dict.add("more 0 0 0");
      dict.add("mouth 0 0 0");
      dict.add("mouth-wash 0 0 0");
      dict.add("music 0 0 0");
      await prefs.setStringList("M", dict);
      dict.clear();

      dict.add("news 0 0 0");
      dict.add("nose 0 0 0");
      dict.add("not 0 0 0");
      dict.add("not-hungry 0 0 0");
      dict.add("number 0 0 0");
      await prefs.setStringList("N", dict);
      dict.clear();

      dict.add("off 0 0 0");
      dict.add("oil 0 0 0");
      dict.add("on 0 0 0");
      dict.add("open 0 0 0");
      await prefs.setStringList("O", dict);
      dict.clear();

      dict.add("pain 0 0 0");
      dict.add("pain-ointment 0 0 0");
      dict.add("pajama 0 0 0");
      dict.add("phone 0 0 0");
      dict.add("pillow 0 0 0");
      dict.add("pillow-different 0 0 0");
      dict.add("pillow-thick 0 0 0");
      dict.add("pillow-thin 0 0 0");
      await prefs.setStringList("P", dict);
      dict.clear();

      dict.add("sad 0 0 0");
      dict.add("scarf 0 0 0");
      dict.add("sleep 0 0 0");
      dict.add("small 0 0 0");
      dict.add("socks 0 0 0");
      dict.add("songs 0 0 0");
      dict.add("spoon 0 0 0");
      dict.add("switch 0 0 0");
      await prefs.setStringList("S", dict);
      dict.clear();

      dict.add("t-shirt 0 0 0");
      dict.add("thick 0 0 0");
      dict.add("thin 0 0 0");
      dict.add("time 0 0 0");
      dict.add("today 0 0 0");
      dict.add("toilet 0 0 0");
      dict.add("tomorrow 0 0 0");
      dict.add("towel 0 0 0");
      dict.add("tube 0 0 0");
      dict.add("turn 0 0 0");
      dict.add("tv 0 0 0");
      await prefs.setStringList("T", dict);
      dict.clear();

      dict.add("warm 0 0 0");
      dict.add("wash 0 0 0");
      dict.add("water 0 0 0");
      dict.add("water-less 0 0 0");
      dict.add("water-more 0 0 0");
      dict.add("wet 0 0 0");
      dict.add("wheelchair 0 0 0");
      await prefs.setStringList("W", dict);
      dict.clear();

      dict.add("yesterday 0 0 0");
      await prefs.setStringList("Y", dict);
      dict.clear();
    }
  }

  void populateWidgetWords(List<String> words){
    _widgetWords.clear();
    for(int x = 0; x < words.length; x++)
      _widgetWords.add(Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
        ),
        height: MediaQuery.of(context).size.width/6,
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          onPressed: (){
            print(words.elementAt(x).split(" ")[0]);
          },
          splashColor: Colors.pink[100],
          child: Center(
            child: Text(words.elementAt(x).split(" ")[0], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )
        )
      ));
    print(_widgetWords.length);
  }

  Future<List<String>> _getWords(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _wordList = prefs.getStringList(s);
    return _wordList;
  }

  Widget createBtn(String name){
    return Expanded(
      child: Container(
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
              child: Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ),
          onPressed: (){
            _getWords(name).then((onValue){
              setState(() {
                populateWidgetWords(onValue);
              });
            });
          },
        )
      )
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex==1){
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
            title: Text("Advanced Keyboard", style: new TextStyle(
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

        body: ListView(
          children: <Widget>[
            Container(

              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width,

              child: Row(
                children: <Widget>[
                  createBtn("A"),
                  createBtn("B"),
                  createBtn("C"),
                  createBtn("D"),
                  createBtn("E"),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  createBtn("F"),
                  createBtn("G"),
                  createBtn("H"),
                  createBtn("I"),
                  createBtn("J"),
                ],
              ),
            ),
            Container(
//              color: Colors.grey,
              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  createBtn("K"),
                  createBtn("L"),
                  createBtn("M"),
                  createBtn("N"),
                  createBtn("O"),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  createBtn("P"),
                  createBtn("Q"),
                  createBtn("R"),
                  createBtn("S"),
                  createBtn("T"),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  createBtn("U"),
                  createBtn("V"),
                  createBtn("W"),
                  createBtn("Y"),
                  createBtn("Z"),
                ],
              ),
            ),
            Column(
              children: _widgetWords,
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
//          BottomNavigationBarItem(
//            icon: Icon(Icons.school),
//            title: Text('School'),
//          ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.redAccent,
          onTap: _onItemTapped,
        ),
      ),
    );
  }



}