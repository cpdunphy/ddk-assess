import 'dart:async';
import 'dart:convert';

import 'package:ddk_assess/Data-Mngr/tapEntry.dart';
import 'package:ddk_assess/UI/countDownPainter.dart';
import 'package:ddk_assess/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';


class TimerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {

  AnimationController controller;
  AnimationController timer;

  bool isFinished = false;

  final GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();

  int taps = 0;

  int counter = 3;

  bool sheetPresent = false;

  String get timerString {
    Duration duration = controller.duration - (controller.duration * controller.value);
    return "${(duration.inMinutes).toString().padLeft(2, "0")}:${(duration.inSeconds%60).toString().padLeft(2, "0")}";
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5)
    )..addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.completed) {
        setState(() {
          controller.reset();
          isFinished = true;
          timer.reset();
          MyApp.entries.add(new TapEntry(taps, controller.duration, DateTime.now()));
        });
      }
    });

    timer = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
      lowerBound: 0,
      upperBound: 1
    )
    ..addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.completed && status != AnimationStatus.dismissed) {
        Timer timer = new Timer(new Duration(milliseconds: 150), () {
          setState(() {
            
          });
        });   
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.dispose();
    controller.dispose();
  }

  void showCountDownTimeSelector(Size screen) {
    setState(() {
      sheetPresent = true;
    });
    new Picker(
      height: screen.height*.3,
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(begin: 0, end: 60),
      ]),
      hideHeader: false,
      title: new Text("Select Duration"),
      
      onConfirm: (Picker picker, List value) {
        setState(() {
          sheetPresent = false;
          controller.duration = new Duration(seconds: value[0]);
        });
      },
      onCancel: () {
        setState(() {
          sheetPresent = false;
        });
      }
    ).show(_scaffoldKey.currentState);
  }
  

  void showTimerTimeSelector(Size screen) {
    setState(() {
      sheetPresent = true;
    });
    new Picker(
      height: screen.height*.3,
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(begin: 0, end: 60),
      ]),
      hideHeader: false,
      title: new Text("Select Delay"),
      onConfirm: (Picker picker, List value) {
        setState(() {
          sheetPresent = false;
          timer.duration = new Duration(seconds: value[0]);
        });
      },
      onCancel: () {
        setState(() {
          sheetPresent = false;
        });
      }
    ).show(_scaffoldKey.currentState);
  }

  Widget animatedTimer(Size screen) {
    return Align(
      alignment: FractionalOffset.topCenter,
      child: SizedBox(
        height: screen.height*.35,
        width: screen.height*.35,
        child: AspectRatio(
          aspectRatio: 1,
          child: new Stack(
            children: <Widget>[
              new Positioned.fill(
                child: new AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return new CustomPaint(
                      painter: CountDownPainter(
                        animation: controller,
                        backgroundColor: Colors.grey,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
              new Positioned.fill(
                child: new GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onDoubleTap: () {
                    if(isFinished) {
                      showCountDownTimeSelector(screen);
                    } else if(timer.value == 0) {
                      showTimerTimeSelector(screen);
                    }
                  },
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      isFinished ? new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            timerString,
                            style: new TextStyle(
                              fontSize: screen.height*.35*.2
                            ),
                          ),
                          new Padding(
                            padding: EdgeInsets.only(left: screen.width*.35*.6, right: screen.width*.35*.6),
                            child: new Divider(
                              thickness: 4,
                              color: Colors.grey[600],
                            ),
                          ),
                          new Text(
                            "$taps taps",
                            style: new TextStyle(
                              fontSize: screen.height*.35*.1
                            ),
                          ),
                        ],
                      ):
                      timer.value == 1 ?
                      new AnimatedBuilder(
                        animation: controller,
                        builder: (BuildContext context, Widget child) {
                          return new Text(
                            timerString,
                            style: new TextStyle(
                              fontSize: screen.height*.1
                            ),
                          );
                        },
                      ) :
                      new AnimatedBuilder(
                        animation: timer,
                        builder: (BuildContext context, Widget child) {
                          return new Text(
                            "${(timer.duration.inSeconds - (timer.duration.inSeconds * timer.value)).ceil().toString()}",
                            style: new TextStyle(
                              fontSize: screen.height*.1
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget controlButtons(Size screen) {
    return new Padding(
      padding: EdgeInsets.all(20),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width*.22,
            height: MediaQuery.of(context).size.width*.22,
            child: new RawMaterialButton(
              fillColor: Colors.grey[800],
              elevation: 5, //Flat
              shape: new CircleBorder(),
              child: new Text(
                "Stop",
                style: new TextStyle(
                  fontSize: MediaQuery.of(context).size.height*.022,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                if(sheetPresent)
                  return null;
                controller.reset();
                timer.reset();
                taps = 0;
                setState(() {
                  isFinished = false;
                });
              },
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width*.22,
            height: MediaQuery.of(context).size.width*.22,
            child: new AnimatedBuilder(
              animation: timer,
              builder: (BuildContext context, Widget child) {
                return new AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return new RawMaterialButton(
                      fillColor: controller.isAnimating || timer.isAnimating ? Color.fromRGBO(186, 99, 24, 1) : Color.fromRGBO(52, 161, 40, 1),
                      elevation: 5, //Flat
                      shape: new CircleBorder(),
                      child:  Text(
                        controller.isAnimating || timer.isAnimating ? "Pause" : "Start",
                        style: new TextStyle(
                          fontSize: MediaQuery.of(context).size.height*.022,
                          color: controller.isAnimating || timer.isAnimating ? Color.fromRGBO(255, 176, 107, 1) : Color.fromRGBO(111, 247, 96, 1),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () {
                        if(sheetPresent)
                          return null;
                        
                        if(isFinished)
                          setState(() {
                            isFinished = false;
                            taps = 0;
                          });

                        if(controller.isAnimating || timer.isAnimating) {
                          if(timer.isAnimating) {
                            timer.stop();
                          } else {
                            controller.stop();
                          }
                          controller.notifyListeners();
                          timer.notifyListeners();
                        } else {
                          if(timer.isCompleted) {
                            controller.animateTo(1);
                          } else
                            timer.animateTo(1).whenComplete(
                              () => controller.animateTo(1)
                            );
                        }
                      },
                    ); 
                  }
                ); 
              },
            )
          ),
        ],
      ),
    );
  }

  Widget tapButton(Size screen) {
    return new SizedBox(
      width: screen.width*.85,
      height: screen.width*.75,
      child: new RaisedButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20)
        ),
        color: controller.isAnimating && !sheetPresent ? Color.fromRGBO(3, 198, 252, 1) : Color.fromRGBO(4, 157, 199, 1),
        splashColor: Color.fromRGBO(2, 168, 214, .5),
        child: new Container(
          alignment: Alignment.center,
          child: new Text(
            "Tap!",
            style: new TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screen.height*.05
            ),
          ),
        ),
        onPressed: () {
          if(sheetPresent || !controller.isAnimating) {
            return null;
          }
          taps += 1;
        },
      ),
    );
  }



  @override 
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return new SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: new Padding(
          padding: EdgeInsets.all(10),
          child: new Stack(
            children: <Widget>[
              animatedTimer(screen),
              new Align(
                alignment: FractionalOffset.bottomCenter,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget> [
                    controlButtons(screen),
                    tapButton(screen)
                  ],    
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}