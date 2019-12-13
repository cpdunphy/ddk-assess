import 'package:ddk_assess/Activities/dataPage.dart';
import 'package:ddk_assess/Activities/timerPage.dart';
import 'package:ddk_assess/Data-Mngr/tapEntry.dart';
import 'package:flutter/gestures.dart';
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<Widget> displays = [TimerPage(), null, null]; //Need activities
  TabController controller; 

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3, initialIndex: 0); 
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: controller.index,
        onTap: (int index) {
          setState(() {
            controller.index = index;
          });
        },
        items: <BottomNavigationBarItem> [
          new BottomNavigationBarItem(
            icon: Icon(Icons.av_timer),
            title: new Text("Timer")
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            title: new Text("Counter")
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: new Text("History")
          )
        ],
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: <Widget>[TimerPage(), new Container(), new Container()],
      )
    );
  }
}
