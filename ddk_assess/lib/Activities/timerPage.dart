import 'dart:async';

import 'package:ddk_assess/Data-Mngr/tapEntry.dart';
import 'package:ddk_assess/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/cupertino_rounded_duration_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math';

class TimerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {

  AnimationController _controller; //Animation controller for timer and circle loading bar
  int _taps = 0; //Taps variable
  Timer _countDown;
  int _counter = 3;
  bool _running = false;

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController( //Default controller set
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _controller.addStatusListener((status) {
        if(_controller.value == 1) {
          MyApp.entries.add(new TapEntry(_taps, _controller.duration, DateTime.now()));
          _taps = 0;
          _controller.value = 0;
          setState(() {
            _running = false;
          });
        } 
      }
    );

    _countDown = Timer.periodic(Duration(seconds: 0), (timer) {
      setState(() {
        timer.cancel();
      });
    });
  }

  @override
  void dispose() {
    _controller.stop();
    _countDown.cancel();
    super.dispose();
  }

  String get timerString {
    Duration duration = _controller.duration * _controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  } 

  void startTimer() {
    print(_counter);
    const oneSec = const Duration(seconds: 1);
    _countDown = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_counter < 1) {
            timer.cancel();
            _controller.animateTo(1).whenCompleteOrCancel(() {
              setState(() {
                _running = false;
              });
            });
            setState(() {
              _running = true;
            });            
          } else {
            _counter = _counter - 1;
          }
        },
      ),
    );
  }

  Widget get tapButton {
    return new AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        print(_controller.value);
        return child;
      },
      child: CupertinoButton(
        minSize: MediaQuery.of(context).size.width*.85,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        pressedOpacity: 0.8,
        child: new Text(
          _running ? "TAP" : "Disabled",
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.height*.03
          ),
        ),
        disabledColor: Colors.grey,
        color: Colors.lightBlue[600],
        onPressed: _running ? () {
          _taps+=1;
        } : null, //enabled setter :)
      )
    );
  }

  Widget get controlButtons {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new FloatingActionButton(
          elevation: 0, //Flat
          backgroundColor: Colors.grey,
          child: !_running ? Text("Reset") : Text("Stop"),
          onPressed: () {
            _controller.stop();
            _controller.value = 0;
            _taps = 0;
          },
        ),
        new AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return new FloatingActionButton(
              elevation: 0, //Flat
              backgroundColor: _controller.isAnimating ? Colors.orange[600] : Colors.green[800],
              child: !_controller.isAnimating ? new Text("Start") : new Text("Pause"),
              onPressed: () {
                if(!_controller.isAnimating && _controller.value == 0) { //Run countdown if starting a new run
                  _counter = 3;
                  startTimer();
                  
                } else if(_controller.isAnimating) { //Stop animation (pause)
                  _controller.stop();
                  setState(() {
                    _running = false;
                  });
                } else { //If start is pressed but not a new run, continue.
                  _controller.animateTo(1).whenCompleteOrCancel(() {
                    setState(() {
                      _running = false;
                    });
                  });
                  setState(() {
                    _running = true;
                  });
                }
              },
            ); 
          }
        ),
      ],
    );
  }

  Widget get timer => new AnimatedBuilder(
    animation: _controller,
    builder: (BuildContext context, Widget child) {
      return new CircularPercentIndicator(
        startAngle: 0,
        radius: MediaQuery.of(context).size.width*.4,
        lineWidth: 10,
        percent: _controller.value,
        center: new Text(
          _countDown.isActive ? _counter.toString() : ((1-_controller.value)*_controller.duration.inSeconds).round().toString() +"\n Taps: $_taps",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
        circularStrokeCap: CircularStrokeCap.round,
        linearGradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.topLeft,
          colors: <Color> [
            Colors.blue[700],
            Colors.blue[600],
            Colors.blue[500],
            Colors.blue[300]
          ]
        ),        
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new GestureDetector(
              onTap: () => CupertinoRoundedDurationPicker.show(context, 
                initialTimerDuration: _controller.duration, 
                initialDurationPickerMode: CupertinoTimerPickerMode.ms, 
                onDurationChanged: (newDuration) {
                  setState(() {
                    _controller.duration = newDuration.inSeconds > 0 ? newDuration : _controller.duration;
                  });
                }
              ),
              child: timer,
            ), 
            new Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: controlButtons
            ),
            new Container(
              alignment: Alignment.bottomCenter,
              child: tapButton,
            ),
          ],
        ),
      ),
    );   
  }
}