import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdapp/suggestions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavBar.dart';
import 'addWord.dart';
import 'draw_screen.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {


  @override
  Future initState() {
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
              title: Text("Statistics", style: new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              )),
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

          body: Container(
            margin: EdgeInsets.all(20),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.cyan[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
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