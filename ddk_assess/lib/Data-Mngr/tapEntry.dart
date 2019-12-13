import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TapEntry {
  DateTime _time;
  Duration _duration;
  int _taps;

  TapEntry(int taps, Duration duration, DateTime time) {
    _time = time;
    _taps = taps;
    _duration = duration;
  }

  Duration get duration => _duration;

  DateTime get time => _time;

  int get taps => _taps;

  Duration get age => DateTime.now().difference(_time);

  Widget get display {
    Duration timeDiff = age;
    return new Container(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: new Text(
              timeDiff.inSeconds > 59 ? 
                timeDiff.inMinutes > 59 ?
                  timeDiff.inHours > 23 ? timeDiff.inDays.toString() + " days ago" : timeDiff.inHours.toString() + " hours ago" 
                : timeDiff.inMinutes.toString() + " minutes ago"
              : timeDiff.inSeconds.toString() + " seconds ago",
              style: new TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          new Text(
            "$_taps taps"
          ),
          new Text(
            _duration.inMinutes.toString() +" : " + _duration.inSeconds.toString()
          ),
          new Divider()
        ],
      )
    );
  }
}