import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pdapp/addWord.dart';

import 'draw_screen.dart';

class Start extends StatefulWidget {
  @override
  StartState createState() => StartState();
}

class StartState extends State<Start> {

  void initState(){
    super.initState();
    
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            Draw()), (Route<dynamic> route) => false);
      });
    });
  }

  Widget build(BuildContext context){
    return Scaffold(

      backgroundColor: Colors.cyan[50],

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/MobiTestLogo.png",
              height: MediaQuery.of(context).size.width * 0.7,
              width: MediaQuery.of(context).size.width * 0.7,
//              fit: BoxFit.fitWidth,
            ),
//            Padding(
//              padding: EdgeInsets.all(15),
//                child: Text("MobiTest - Noninvasive Parkinson's Detector", style: new TextStyle(
//                fontWeight: FontWeight.bold,
//                fontSize: 25,
//              )),
//            ),
          ],
        )
      ),
    );
  }
}