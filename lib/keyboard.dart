import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdapp/suggestions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavBar.dart';
import 'Statistics.dart';
import 'addWord.dart';
import 'draw_screen.dart';

class Keyboard extends StatefulWidget {
  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<String> _wordList = new List();
  List<Widget> _widgetWords = new List();

  Map<String, Map<String, int>> markovModel = new Map();
  String previousWord;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createSharedPrefs().then((onValue){
      print(markovModel);
    });


  }



  Future _createSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dict = new List();
    if(!prefs.containsKey("All_Words")){
      dict.add("ac-high");
      dict.add("ac-low");
      dict.add("ac-off");
      dict.add("ac-on");
      dict.add("airbed");
      dict.add("bathroom");
      dict.add("bed-down");
      dict.add("breathing-prob");
      dict.add("bed");
      dict.add("chair");
      dict.add("change");
      dict.add("clean");
      dict.add("clothes");
      dict.add("cold");
      dict.add("cream");
      dict.add("crushed");
      dict.add("dressing");
      dict.add("drink");
      dict.add("dry");
      dict.add("dining-room");
      dict.add("eat");
      dict.add("fan-fast");
      dict.add("fan-off");
      dict.add("fan-on");
      dict.add("fan-slow");
      dict.add("fell");
      dict.add("fresh");
      dict.add("full");
      dict.add("gate");
      dict.add("half");
      dict.add("hand");
      dict.add("happy");
      dict.add("hospital");
      dict.add("hurt");
      dict.add("less");
      dict.add("light-off");
      dict.add("light-on");
      dict.add("massage");
      dict.add("medicine");
      dict.add("medicine-pain");
      dict.add("more");
      dict.add("mouth");
      dict.add("mouth-wash");
      dict.add("music");
      dict.add("news");
      dict.add("nose");
      dict.add("not");
      dict.add("not-hungry");
      dict.add("number");
      dict.add("off");
      dict.add("oil");
      dict.add("on");
      dict.add("open");
      dict.add("pain");
      dict.add("pain-ointment");
      dict.add("pajama");
      dict.add("phone");
      dict.add("pillow");
      dict.add("pillow-different");
      dict.add("pillow-thick");
      dict.add("pillow-thin");
      dict.add("sad");
      dict.add("scarf");
      dict.add("sleep");
      dict.add("small");
      dict.add("socks");
      dict.add("songs");
      dict.add("spoon");
      dict.add("switch");
      dict.add("t-shirt");
      dict.add("thick");
      dict.add("thin");
      dict.add("time");
      dict.add("today");
      dict.add("toilet");
      dict.add("tomorrow");
      dict.add("towel");
      dict.add("tube");
      dict.add("turn");
      dict.add("tv");
      dict.add("warm");
      dict.add("wash");
      dict.add("water");
      dict.add("water-less");
      dict.add("water-more");
      dict.add("wet");
      dict.add("wheelchair");
      dict.add("yesterday");
      await prefs.setStringList("All_Words", dict);
    } else {
      dict = prefs.getStringList("All_Words");
    }
    _wordList = dict;
    for(String word in dict){

      if(prefs.getStringList(word) == null){
        List<String> tempPref = new List();
        Map<String, int> temp = new Map();
        for(String word2 in dict){

          temp[word2] = 0;
          tempPref.add(word2 + " 0");
        }

        await prefs.setStringList(word, tempPref);

        markovModel[word] = temp;
      } else {
        List<String> tempPref = prefs.getStringList(word);
        Map<String, int> temp = new Map();

        for(String word2 in tempPref){
          temp[word2.split(" ")[0]] = int.parse(word2.split(" ")[1]);
        }

        markovModel[word] = temp;
      }
    }
  }

  Future _saveMarkovModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dict = prefs.getStringList("All_Words");

    for(String word in dict){

      List<String> tempPref = new List();
      for(String word2 in dict) {
        tempPref.add(word2 + " " + markovModel[word][word2].toString());
      }

      await prefs.setStringList(word, tempPref);

    }
  }



  //Each of the buttons that appear starting with the letter
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
            if(previousWord != null)
              markovModel[previousWord][words.elementAt(x).split(" ")[0]]++;
            print(markovModel);
            _saveMarkovModel();
            previousWord = words.elementAt(x).split(" ")[0];
            print(words.elementAt(x).split(" ")[0]);
          },
          splashColor: Colors.cyan[100],
          child: Center(
            child: Text(words.elementAt(x).split(" ")[0], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )
        )
      ));
//    print(_widgetWords.length);
  }

  List<String> _getList(String s) {
    List<String> wordsThatStartWith = new List();
    for(String i in _wordList){
      if(i.startsWith(s)){
        wordsThatStartWith.add(i);
      }
    }
    return wordsThatStartWith;
  }

  Widget createBtn(String letter){
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
          splashColor: Colors.cyan[100],
          child: Center(
              child: Text(letter, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ),
          onPressed: (){
            setState(() {
              populateWidgetWords(_getList(letter.toLowerCase()));
            });
          },
        )
      )
    );
  }
//  Future<List<String>> _getWords() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    List <String> _wordList = new List();
//    _wordList.addAll(prefs.getStringList("A"));
//    _wordList.addAll(prefs.getStringList("B"));
//    _wordList.addAll(prefs.getStringList("C"));
//    _wordList.addAll(prefs.getStringList("D"));
//    _wordList.addAll(prefs.getStringList("E"));
//    _wordList.addAll(prefs.getStringList("F"));
//    _wordList.addAll(prefs.getStringList("G"));
//    _wordList.addAll(prefs.getStringList("H"));
//    if(prefs.getStringList("I") != null)
//      _wordList.addAll(prefs.getStringList("I"));
//    if(prefs.getStringList("J") != null)
//      _wordList.addAll(prefs.getStringList("J"));
//    if(prefs.getStringList("K") != null)
//      _wordList.addAll(prefs.getStringList("K"));
//    _wordList.addAll(prefs.getStringList("L"));
//    _wordList.addAll(prefs.getStringList("M"));
//    _wordList.addAll(prefs.getStringList("N"));
//    _wordList.addAll(prefs.getStringList("O"));
//    _wordList.addAll(prefs.getStringList("P"));
//    if(prefs.getStringList("Q") != null)
//      _wordList.addAll(prefs.getStringList("Q"));
//    if(prefs.getStringList("R") != null)
//      _wordList.addAll(prefs.getStringList("R"));
//    _wordList.addAll(prefs.getStringList("S"));
//    _wordList.addAll(prefs.getStringList("T"));
//    if(prefs.getStringList("U") != null)
//      _wordList.addAll(prefs.getStringList("U"));
//    if(prefs.getStringList("V") != null)
//      _wordList.addAll(prefs.getStringList("V"));
//    _wordList.addAll(prefs.getStringList("W"));
//    _wordList.addAll(prefs.getStringList("Y"));
//    if(prefs.getStringList("Z") != null)
//      _wordList.addAll(prefs.getStringList("Z"));
//    return _wordList;
//  }

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
              child: Text("Accessible Keyboard", style: new TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                )
              ),
            ),
            backgroundColor: Colors.cyan[100],
//            actions: <Widget>[
//              IconButton(
//                icon: Icon(Icons.info, color: Colors.blueAccent, size: 30),
//                onPressed: (){
//                  //_instructionsModal(context);
//                },
//              )
//            ],
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


        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.show_chart),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Statistics()));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavBar()
      ),
    );
  }
}