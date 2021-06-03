import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavBar.dart';
import 'LineChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  List<String> rawStaticSpiral = new List();
  List<String> rawDynamicSpiral = new List();
  List<String> rawStability = new List();

  List<charts.Series<Values, int>> staticSpiralGraph;
  List<charts.Series<Values, int>> dynamicSpiralGraph;
  List<charts.Series<Values, int>> stabilityGraph;

  List<Values> staticSpiralScores = new List();
  List<Values> dynamicSpiralScores = new List();
  List<Values> stabilityScores = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _fillRawValues().then((onValue){
      for(int i = 0; i < rawStaticSpiral.length; i++){
        staticSpiralScores.add(new Values(i, double.parse(rawStaticSpiral[i])));
        dynamicSpiralScores.add(new Values(i, double.parse(rawDynamicSpiral[i])));
        stabilityScores.add(new Values(i, double.parse(rawStability[i])));
      }

      setState(() {
        staticSpiralGraph = [
          new charts.Series<Values, int>(
            id: 'Static Spiral Scores',
            colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
            domainFn: (Values x, _) => x.time,
            measureFn: (Values x, _) => x.score,
            data: staticSpiralScores,
          )
        ];

        dynamicSpiralGraph = [
          new charts.Series<Values, int>(
            id: 'Static Spiral Scores',
            colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
            domainFn: (Values x, _) => x.time,
            measureFn: (Values x, _) => x.score,
            data: dynamicSpiralScores,
          )
        ];

        stabilityGraph = [
          new charts.Series<Values, int>(
            id: 'Static Spiral Scores',
            colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
            domainFn: (Values x, _) => x.time,
            measureFn: (Values x, _) => x.score,
            data: stabilityScores,
          )
        ];
      });

    });
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
                fontSize: 35,
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

          body: ListView(
            children: <Widget>[
              Container(

                child: LineChart(staticSpiralGraph),

                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(142, 185, 173, 1),
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
              Container(

                child: LineChart(dynamicSpiralGraph),

                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(142, 185, 173, 1),
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
              Container(

                child: LineChart(stabilityGraph),

                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(142, 185, 173, 1),
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

  Future _fillRawValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getStringList("StaticSpiral") == null){
      rawStaticSpiral.add("0.0");
      rawDynamicSpiral.add("0.0");
      rawStability.add("0.0");
    } else{
      rawStaticSpiral = prefs.getStringList("StaticSpiral");
      rawDynamicSpiral = prefs.getStringList("DynamicSpiral");
      rawStability = prefs.getStringList("Stability");
    }

  }
}

class Values {
  final int time;
  final double score;

  Values(this.time, this.score);
}