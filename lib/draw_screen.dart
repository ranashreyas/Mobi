import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pdapp/BottomNavBar.dart';
import 'package:pdapp/Statistics.dart';
import 'package:pdapp/suggestions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'LineChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'addWord.dart';
import 'keyboard.dart';

import 'package:flutter/services.dart';


class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  Color selectedColor = Colors.redAccent;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List();
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  int startTime = 0;
  int previousTime = 0;
  int currentTime = 0;
  double prevVelocity = 0;
  double currVelocity = 0;
//  double prevDistance;
//  double currDistance;

  double acceleration = 0;
  int dt = 0;

  double avgDT = 0;
  int ctrRefresh = 0;
  double finalDT = 8.340;
  double timePassed = 0;

  double prevDX = 0, prevDY = 0;
  double currDX = 0, currDY = 0;

  double currAngle = 0;

  Random r = new Random();
  int randomNum = 10;
  bool endedDrawing = false;
  int staticSpiral = 0;
  double dev = 0;
  var staticHistogram = new List(16);
  var dynamicHistogram = new List(16);

  var staticHistogramAngle = new List(18);
  var dynamicHistogramAngle = new List(18);

  List<GraphPoints> data = new List();
  List<Angles> angles = new List();
//  List<charts.Series<GraphPoints, int>> temp;
  List<charts.Series<Angles, int>> temp;


  double difference = 0;

  double totalDistanceStability = 0;

  double staticSpiralScore = 0;
  double dynamicSpiralScore = 0;



  void initState(){
    super.initState();

    staticSpiralScore = 0.0;
    dynamicSpiralScore = 0.0;

    for(int x = 0; x < 16; x++){
      staticHistogram[x] = 0;
      dynamicHistogram[x] = 0;
    }

    for(int x = 0; x < 18; x++){
      staticHistogramAngle[x] = 0;
      dynamicHistogramAngle[x] = 0;
    }
//    _instructionsModal(context);
  }

//  double standardDeviation(){
//    double variation = 0;
//    for(int x = 0; x < data.length; x++){
//      variation += (data.elementAt(x).acceleration * data.elementAt(x).acceleration).toDouble() / data.length;
//    }
//    return sqrt(variation);
//  }

  // the current time, in “seconds since the epoch”
  int currentTimeMS() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return ms;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
          child: AppBar(
            title: Text((staticSpiral == 0)? "Static Spiral Test":(staticSpiral == 1)? "Dynamic Spiral Test": "Stability Test", style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            )),
            backgroundColor: Colors.cyan[100],
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.info, color: Colors.blueAccent, size: 30),
                onPressed: (){
                  _instructionsModal(context);
                },
              )
            ],
          ),
        preferredSize: Size.fromHeight(60),
      ),
      body: Stack(
        children: <Widget>[

          //determining whether to do static/dynamic/stability
          (staticSpiral == 0)? Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            width: MediaQuery.of(context).size.width,

            child: FittedBox(
              child: Image(image: AssetImage('images/spiral.jpeg')),
              fit: BoxFit.fill
            )
          ): (staticSpiral == 1)?(
            (randomNum >8)?Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: MediaQuery.of(context).size.width,

              child: FittedBox(
                  child: Image(image: AssetImage('images/spiral.jpeg')),
                  fit: BoxFit.fill
              )
            ):Container(
              width: MediaQuery.of(context).size.width,

            )
          ):Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),

                    child:((timePassed).round() > 10)?(
                     Text((timePassed).round().toString(), style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 30,
                    ))):(Text((timePassed).round().toString(), style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    )))
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                    child: Icon(Icons.brightness_1, color: Colors.black, size: 10),
                  )

                ],
              )
            )

          ),

          Column(
            children: <Widget>[

//              PreferredSize(
//                child: AppBar(
//                  title: Text((staticSpiral == 0)? "Static Spiral Test":(staticSpiral == 1)? "Dynamic Spiral Test": "Stability Test", style: new TextStyle(
//                    color: Colors.black,
//                    fontWeight: FontWeight.bold,
//                    fontSize: 35,
//                  )),
//                  backgroundColor: Colors.pink[100],
//                  actions: <Widget>[
//                    IconButton(
//                      icon: Icon(Icons.info, color: Colors.blueAccent, size: 30),
//                      onPressed: (){
//                        _instructionsModal(context);
//                      },
//                    )
//                  ],
//                ),
//                preferredSize: Size.fromHeight(60),
//              ),

              Container(
                height: MediaQuery.of(context).size.width,
                child: GestureDetector(

                  onPanUpdate: (details) {
                    setState(() {
                      RenderBox renderBox = context.findRenderObject();

                      randomNum = r.nextInt(10);
                      currentTime = currentTimeMS();
                      dt = currentTime-previousTime;

                      avgDT += dt;
                      ctrRefresh++;

                      //currDistance = details.globalPosition.distance;
                      currDX = details.globalPosition.dx;
                      currDY = details.globalPosition.dy;
                      currVelocity = sqrt((currDY-prevDY)*(currDY-prevDY) + (currDX-prevDX)*(currDX-prevDX))/(avgDT/ctrRefresh);
                      if(staticSpiral == 2)
                        totalDistanceStability += sqrt((currDY-prevDY)*(currDY-prevDY) + (currDX-prevDX)*(currDX -prevDX));

                      acceleration = (currVelocity - prevVelocity)/(avgDT/ctrRefresh);
                      data.add(new GraphPoints(((currentTime-startTime)).round(), (acceleration*1000000).round()));
//                      print(((currentTime-startTime)).round().toString() + ", " + (acceleration*1000000).round().toString());
                      previousTime = currentTime;
                      prevVelocity = currVelocity;

                      if(staticSpiral == 2){
                        timePassed = (currentTime-startTime)/1000.0;
                      }

                      prevDX = currDX;
                      prevDY = currDY;
                      points.add(DrawingPoints(
                          points: renderBox.globalToLocal(new Offset(details.globalPosition.dx, details.globalPosition.dy-(MediaQuery.of(context).padding.top+60))),
                          paint: Paint()
                            ..strokeCap = strokeCap
                            ..isAntiAlias = true
                            ..color = selectedColor.withOpacity(opacity)
                            ..strokeWidth = strokeWidth));
                      if(points.length>=3){
                        var vectA = [points.elementAt(points.length-3).points.dx-points.elementAt(points.length-2).points.dx,points.elementAt(points.length-3).points.dy-points.elementAt(points.length-2).points.dy];
                        var vectB = [points.elementAt(points.length-1).points.dx-points.elementAt(points.length-2).points.dx,points.elementAt(points.length-1).points.dy-points.elementAt(points.length-2).points.dy];
                        var numerator = vectA[0]*vectB[0] + vectA[1]*vectB[1];
                        var denom = sqrt(vectA[0]*vectA[0] + vectA[1]*vectA[1]) * sqrt(vectB[0]*vectB[0] + vectB[1]*vectB[1]);
                        denom += 0.000001;
                        currAngle = 180/3.1415926535897932 * (acos(numerator/denom));
//                        print(currAngle);
                        angles.add(new Angles(((currentTime-startTime)).round(), currAngle));
                      }

                    });
                  },
                  onPanStart: (details) {
                    setState(() {

//                      print("statusBar + appBar: " + (MediaQuery.of(context).padding.top+60).toString());

                      points.clear();
                      data.clear();
                      angles.clear();

                      prevDX = details.globalPosition.dx;
                      prevDY = details.globalPosition.dy;

                      previousTime = currentTimeMS();
                      startTime = previousTime;

                      if(staticSpiral == 0){

                        difference = 0;
                        totalDistanceStability = 0;
                      }


                      prevVelocity = 0;
                      acceleration = 0;
                      RenderBox renderBox = context.findRenderObject();
                      points.add(DrawingPoints(
                          points: renderBox.globalToLocal(new Offset(details.globalPosition.dx, details.globalPosition.dy-(MediaQuery.of(context).padding.top+60))),
                          paint: Paint()
                            ..strokeCap = strokeCap
                            ..isAntiAlias = true
                            ..color = selectedColor.withOpacity(opacity)
                            ..strokeWidth = strokeWidth));
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
//                      print("points: " + points.length.toString() + " data: " + data.length.toString());
                      points.clear();
//                      print("end " + totalDistanceStability.toString());
//                      dev = standardDeviation();
//                      points.clear();
                      endedDrawing = true;
                      if(staticSpiral == 0){
                        totalDistanceStability = 0;
                        fillStaticHistogramAngles();
                        staticSpiral = 1;
                        randomNum = 10;
                      } else if(staticSpiral == 1){
                        staticSpiral = 2;
                        fillDynamicHistogramAngles();

//                        difference = findDifference();
                        staticSpiralScore = calculateStaticSpiralScore();
                        dynamicSpiralScore = calculateDynamicSpiralScore();
//                        print(difference);
                        for(int x = 0; x < 16; x++){
                          staticHistogram[x] = 0;
                          dynamicHistogram[x] = 0;
                        }
                        for(int x = 0; x < 18; x++){
                          staticHistogramAngle[x] = 0;
                          dynamicHistogramAngle[x] = 0;
                        }

                      } else {
                        staticSpiral = 0;
                        _storeTestScores();
                        print(staticSpiralScore);
                        print(dynamicSpiralScore);
                        print(totalDistanceStability);
                        //totalDistanceStability = 0;

                      }
//                      temp = [
//                        new charts.Series<GraphPoints, int>(
//                          id: 'Sales',
//                          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//                          domainFn: (GraphPoints x, _) => x.time,
//                          measureFn: (GraphPoints x, _) => x.acceleration,
//                          data: data,
//                        )
//                      ];
//                      points.add(null);
                      temp = [
                        new charts.Series<Angles, int>(
                          id: 'Sales',
                          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (Angles x, _) => x.time,
                          measureFn: (Angles x, _) => x.angle,
                          data: angles,
                        )
                      ];
                      points.add(null);
                    });
                  },
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
//                    size: Size.fromHeight(MediaQuery.of(context).size.width),
                    painter: DrawingPainter(
                      pointsList: points,
                    ),
                  ),
                ),
              ),

              Flexible(
                child: Container(
                color: Colors.cyan[100],
//                height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width-0,
                child: Center(

                    child: ListView(
                      children: <Widget>[
//                        Text("Angle " + (currAngle==double.nan).toString(), style: new TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 30,
//                        )),
//                        Text("Angle " + currAngle.round().toString(), style: new TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 30,
//                        )),

//                        Text("dx, dy " + currDX.round().toString() + ", " + currDY.round().toString(), style: new TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 30,
//                        )),
//                        Text(((avgDT/ctrRefresh).toString()) + " dt", style: new TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 30,
//                        )),
//                        Text(((currVelocity*1000).toString() + "0000").substring(0, 4) + " pixels/s", style: new TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 30,
//                        )),
//                        Text(((acceleration*1000000).toString() + "0000").substring(0, 4) + " pixels/s^2", style: new TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 30,
//                        )),
//                        Text("Standard Deviation: " + dev.toString(), style: new TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 30,
//                        )),
                        ((staticSpiral == 0)?

                        (Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Static Spiral Test Results: " + staticSpiralScore.round().toString() + "%", style: new TextStyle(
                            color: (staticSpiralScore.round()>= 0 && staticSpiralScore.round() <= 25)?
                              (Colors.lightGreen):
                                ((staticSpiralScore.round()> 25 && staticSpiralScore.round() <= 50)?
                                (Colors.yellow):
                                Colors.redAccent
                              ),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                        )) : Container()),

                        ((staticSpiral == 0)?
                        (Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Dynamic Spiral Test Results: " + dynamicSpiralScore.round().toString() + "%", style: new TextStyle(
                            color: (dynamicSpiralScore.round()>= 0 && dynamicSpiralScore.round() <= 25)?
                              (Colors.lightGreen):
                              ((dynamicSpiralScore.round()> 25 && dynamicSpiralScore.round() <= 50)?
                              (Colors.yellow):
                              Colors.redAccent
                              ),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                        )) : Container()),

                        ((staticSpiral == 0)?
                        (Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Stability Test Results: " + totalDistanceStability.round().toString(), style: new TextStyle(
                            color: (totalDistanceStability.round()>= 0 && totalDistanceStability.round() <= 5)?
                              (Colors.lightGreen):
                              ((totalDistanceStability.round()> 5 && totalDistanceStability.round() <= 15)?
                              (Colors.yellow):
                              Colors.redAccent
                              ),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                        )) : Container()),


                        Container(
                            margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
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
                                  child: Text("Start Over", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                              ),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Draw()),
                                );
                              },
                            )
                        ),


                        (endedDrawing)? Container(
                          height: 200,
                          child: LineChart(temp),
                        ):
                        Container()
                      ],
                    )

                ),
              )
              )

            ],
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

    );
  }

//  void fillStaticHistogram() {
//    for(int x = 0; x < data.length; x++) {
//      for (int y = 0; y < 16; y++) {
//        if (data.elementAt(x).acceleration < -50000 + 6250 * (y + 1) && data.elementAt(x).acceleration > -100000) {
//          staticHistogram[y]++;
//          break;
//        }
//      }
//    }
//    print(staticHistogram);
//  }

  void fillStaticHistogramAngles() {
    for(int x = 0; x < angles.length; x++) {
      for (int y = 0; y < 18; y++) {
        if (angles.elementAt(x).angle < 0 + 10 * (y + 1) && angles.elementAt(x).angle > 0) {
          staticHistogramAngle[y]++;
          break;
        }
      }
    }
    for(int i = 0; i < 18; i++){
      staticHistogramAngle[i] = staticHistogramAngle[i]/angles.length;
    }
//    print(staticHistogramAngle);
  }

//  void fillDynamicHistogram() {
//    for(int x = 0; x < data.length; x++) {
//      for (int y = 0; y < 16; y++) {
//        if (data
//            .elementAt(x)
//            .acceleration < -50000 + 6250 * (y + 1) && data.elementAt(x).acceleration > -100000) {
//          dynamicHistogram[y]++;
//          break;
//        }
//      }
//    }
//    print(dynamicHistogram);
//  }

  void fillDynamicHistogramAngles() {
    for(int x = 0; x < angles.length; x++) {
      for (int y = 0; y < 18; y++) {
        if (angles.elementAt(x).angle < 0 + 10 * (y + 1) && angles.elementAt(x).angle > 0) {
          dynamicHistogramAngle[y]++;
          break;
        }
      }
    }
    for(int i = 0; i < 18; i++){
      dynamicHistogramAngle[i] = dynamicHistogramAngle[i]/angles.length;
    }
//    print(dynamicHistogramAngle);
  }

//  double findDifference() {
//    int sum = 0;
//    for(int x = 0; x < 16; x++){
//      sum += (staticHistogram.elementAt(x) - dynamicHistogram.elementAt(x))*
//          (staticHistogram.elementAt(x) - dynamicHistogram.elementAt(x));
//    }
//    return (sqrt(sum)/MediaQuery.of(context).size.width * 100)/500 * 100;
//  }
//  double findDifferenceAngle() {
//    double sum = 0;
//    for(int x = 0; x < 18; x++){
//      sum += (18-x + 1)*100 * (staticHistogramAngle.elementAt(x) - dynamicHistogramAngle.elementAt(x))*
//          (staticHistogramAngle.elementAt(x) - dynamicHistogramAngle.elementAt(x));
//    }
//    return sum;
//  }

  double calculateStaticSpiralScore(){
    double sum = 0;
    for(int x = 0; x < 18; x++){
      sum += (17-x)*1000 * (staticHistogramAngle.elementAt(x))*
          (staticHistogramAngle.elementAt(x));
    }
    return sum;
  }

  double calculateDynamicSpiralScore(){
    double sum = 0;
    for(int x = 0; x < 18; x++){
      sum += (17-x)*1000 * (dynamicHistogramAngle.elementAt(x))*
          (dynamicHistogramAngle.elementAt(x));
    }
    return sum;
  }

  void _instructionsModal(context) {
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Container(
        height: MediaQuery.of(context).size.height*.6,

        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("This app will use three tests to gauge the severity of Parkinson's Disease. The test will automatically switch once the current test is finished. The spiral tests will determine the finger's tremor, and the stability test will test the finger's control.", style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("1. Static Spiral Test: Starting from the right side, trace the spiral towards the center.", style: new TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20,
              )),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("2. Dynamic Spiral test: This test is similar to the Static Spiral Test, except that the spiral flashes on and off to increase difficulty.", style: new TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20,
              )),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("3. Stability Test: Try to keep your finger as steady as possible on the point shown on the screen for 10 seconds.", style: new TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20,
              )),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("At the end of each test, a graph will be generated showing the overall curvature of your tracing. A curve closer to 180 degrees demonstrates the best control and stability.", style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("The score for each test will be visible after all three tests have been finished. Results closer to zero demonstrate that the possibility of Parkinson's is low.", style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
            ),
          ],
        )
      );
    });
  }

  Future _storeTestScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("StaticSpiral")) {
      List<String> dict = new List();
      await prefs.setStringList("StaticSpiral", dict);
      await prefs.setStringList("DynamicSpiral", dict);
      await prefs.setStringList("Stability", dict);
    }
    List<String> staticSpiralScores = prefs.getStringList("StaticSpiral");
    List<String> dynamicSpiralScores = prefs.getStringList("DynamicSpiral");
    List<String> stabilityScores = prefs.getStringList("Stability");

    staticSpiralScores.add(staticSpiralScore.toStringAsFixed(2));
    dynamicSpiralScores.add(dynamicSpiralScore.toStringAsFixed(2));
    stabilityScores.add(totalDistanceStability.toStringAsFixed(2));

    await prefs.setStringList("StaticSpiral", staticSpiralScores);
    await prefs.setStringList("DynamicSpiral", dynamicSpiralScores);
    await prefs.setStringList("Stability", stabilityScores);

    print(prefs.getStringList("StaticSpiral"));
    print(prefs.getStringList("DynamicSpiral"));
    print(prefs.getStringList("Stability"));

  }

}

//PDP behavior
//[1, 2, 4, 12, 19, 9, 13, 33, 44, 9, 8, 18, 11, 4, 2, 0]
//[0, 0, 0, 1, 2, 16, 62, 117, 105, 62, 17, 1, 2, 0, 0, 0] = 130.146

//[0, 0, 0, 1, 2, 7, 66, 455, 534, 62, 4, 4, 1, 0, 0, 0]
//[0, 1, 0, 0, 4, 12, 94, 365, 384, 86, 22, 2, 1, 0, 0, 0] = 179.774

//normal behavior
//[0, 1, 0, 0, 1, 5, 88, 220, 282, 77, 4, 1, 0, 0, 1, 0]
//[0, 1, 0, 0, 0, 3, 67, 262, 287, 79, 3, 0, 0, 0, 1, 0] = 47.339

















class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;


}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});
}

class GraphPoints {
  final int time;
  final int acceleration;

  GraphPoints(this.time, this.acceleration);
}

class Angles {
  final int time;
  final double angle;

  Angles(this.time, this.angle);
}

enum SelectedMode { StrokeWidth, Opacity, Color }