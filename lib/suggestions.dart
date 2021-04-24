import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdapp/Statistics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavBar.dart';
import 'addWord.dart';
import 'draw_screen.dart';
import 'keyboard.dart';

class Suggestions extends StatefulWidget {
  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestions> {

  int _selectedIndex = 2;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Map<String, Map<String, int>> markovModel = new Map();
  List<String> topTwelveWords = new List();
  String previousWord;

  void updateMarkov(){


    print(markovModel);
    //markovModel.forEach((word, wordWeights) => topTwelveWords.add(word));

    if(previousWord != null){
      topTwelveWords.clear();
      Map<String, int> weights = markovModel[previousWord];
      var sortedKeys = weights.keys.toList(growable:false)
        ..sort((k1, k2) => weights[k2].compareTo(weights[k1]));
      Map<String, int> sortedMap = new LinkedHashMap
          .fromIterable(sortedKeys, key: (k) => k, value: (k) => weights[k]);

      sortedMap.forEach((word, wordWeights) => topTwelveWords.add(word));

      print(sortedMap.toString());
    }



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getWords().then((tempList){
      for(String word in tempList){

        Map<String, int> temp = new Map();
        for(String word2 in tempList){
          temp[word2.split(" ")[0]] = 0;
        }

        markovModel[word.split(" ")[0]] = temp;
      }

      print(markovModel);
      markovModel.forEach((word, wordWeights) => topTwelveWords.add(word));
      print(topTwelveWords.toString());

      setState(() {

      });
    });
  }

  Future<List<String>> _getWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List <String> _wordList = new List();
    _wordList.addAll(prefs.getStringList("A"));
    _wordList.addAll(prefs.getStringList("B"));
    _wordList.addAll(prefs.getStringList("C"));
    _wordList.addAll(prefs.getStringList("D"));
    _wordList.addAll(prefs.getStringList("E"));
    _wordList.addAll(prefs.getStringList("F"));
    _wordList.addAll(prefs.getStringList("G"));
    _wordList.addAll(prefs.getStringList("H"));
//    _wordList.addAll(prefs.getStringList("I"));
//    _wordList.addAll(prefs.getStringList("J"));
//    _wordList.addAll(prefs.getStringList("K"));
    _wordList.addAll(prefs.getStringList("L"));
    _wordList.addAll(prefs.getStringList("M"));
    _wordList.addAll(prefs.getStringList("N"));
    _wordList.addAll(prefs.getStringList("O"));
    _wordList.addAll(prefs.getStringList("P"));
//    _wordList.addAll(prefs.getStringList("Q"));
//    _wordList.addAll(prefs.getStringList("R"));
    _wordList.addAll(prefs.getStringList("S"));
    _wordList.addAll(prefs.getStringList("T"));
//    _wordList.addAll(prefs.getStringList("U"));
//    _wordList.addAll(prefs.getStringList("V"));
    _wordList.addAll(prefs.getStringList("W"));
    _wordList.addAll(prefs.getStringList("Y"));
//    _wordList.addAll(prefs.getStringList("Z"));
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
              splashColor: Colors.cyan[100],
              child: Center(
                  child: Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
              onPressed: (){
                //markovModel.update(previousWord, markovModel[previousWord].update(name, markovModel[previousWord][name]++));
                if(previousWord!= null)
                  markovModel[previousWord][name]++;
                setState(() {
//                  print("set state");
                  updateMarkov();
                  previousWord = name;
                  print("just tapped on " + name);
                });
              },
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            title: Text("Suggestions", style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            )),
            backgroundColor: Colors.cyan[100],
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
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(0):" "),
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(1):" "),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(2):" "),
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(3):" "),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(4):" "),
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(5):" "),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(6):" "),
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(7):" "),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(8):" "),
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(9):" "),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width/6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(10):" "),
                  createBtn((topTwelveWords.length != 0)?topTwelveWords.elementAt(11):" "),
                ],
              ),
            ),
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
      ),
    );
  }

}