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

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Map<String, Map<String, int>> markovModel = new Map();
  List<String> topTwelveWords = new List();
  String previousWord;
  List<String> _wordList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createSharedPrefs().then((onValue){
//      print(markovModel);
      previousWord = findMostClickedWord();
      updateTopTwelveWords();

      setState(() {

      });
    });
  }

  String findMostClickedWord(){
    Map<String, int> counts = new Map();
    for(String word in _wordList){
      counts[word] = 0;
    }

    for(String word in _wordList){
      for(String word2 in _wordList){
        counts[word2] += markovModel[word][word2];
      }
    }

//    print(counts);

    String mostClickedWord;
    int maxClicks = -1;
    for(String word in _wordList){
      if(counts[word] > maxClicks){
        mostClickedWord = word;
        maxClicks = counts[word];
      }
    }
    print("The most clicked word is: " + mostClickedWord);
    return mostClickedWord;
  }

  void updateTopTwelveWords(){
    print(markovModel[previousWord]);
    //markovModel.forEach((word, wordWeights) => topTwelveWords.add(word));

    if(previousWord != null){
      topTwelveWords.clear();
      Map<String, int> weights = markovModel[previousWord];
      var sortedKeys = weights.keys.toList(growable:false)
        ..sort((k1, k2) => weights[k2].compareTo(weights[k1]));
      Map<String, int> sortedMap = new LinkedHashMap
          .fromIterable(sortedKeys, key: (k) => k, value: (k) => weights[k]);

      sortedMap.forEach((word, wordWeights) => topTwelveWords.add(word));

//      print(sortedMap.toString());
    }
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

      print(word + ": " + prefs.getStringList(word).toString());
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
//          print(word2);
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
//    print(markovModel);
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
                  updateTopTwelveWords();
                  _saveMarkovModel();
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