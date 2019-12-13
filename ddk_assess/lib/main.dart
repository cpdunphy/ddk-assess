import 'package:ddk_assess/Activities/dataPage.dart';
import 'package:ddk_assess/Activities/timerPage.dart';
import 'package:ddk_assess/Data-Mngr/tapEntry.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage()
    );
  }
  static List<TapEntry> entries = new List();
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Widget> displays = [TimerPage(), null, null]; //Need activities

  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int selected) => () {
          setState(() {
            _currentIndex = selected;
            print(_currentIndex);
          });
        },
        items: <BottomNavigationBarItem> [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.av_timer),
            title: new Text("Timer")
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.timer),
            title: new Text("Count")
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            title: new Text("History")
          )
        ],
      ),
      body: displays[_currentIndex],
    );
  }
}
