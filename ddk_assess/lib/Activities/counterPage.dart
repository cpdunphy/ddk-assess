import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CouterPageState();
}

class _CouterPageState extends State<CounterPage> {

  Stopwatch stopwatch = new Stopwatch();
  int taps = 0;
  
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
                
              },
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width*.22,
            height: MediaQuery.of(context).size.width*.22,
            child: new RawMaterialButton(
              fillColor: Color.fromRGBO(186, 99, 24, 1),
              elevation: 5, //Flat
              shape: new CircleBorder(),
              child:  Text(
               "Log",
                style: new TextStyle(
                  fontSize: MediaQuery.of(context).size.height*.022,
                  color: Color.fromRGBO(255, 176, 107, 1),
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                
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
        color: Color.fromRGBO(3, 198, 252, 1),
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
          taps += 1;
        },
      ),
    );
  }

  
  
  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new Scaffold(
        body: new Container(
          padding: EdgeInsets.all(10),
          child: new Stack(
            children: <Widget>[
              //TODO:
            ],
          ),
        ),
      ),
    );
  }
}