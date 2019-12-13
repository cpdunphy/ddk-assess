import 'package:cupertino_stackview/cupertino_stackview.dart';
import 'package:cupertino_stackview/cupertino_stackview_controller.dart';
import 'package:ddk_assess/Data-Mngr/tapEntry.dart';
import 'package:ddk_assess/main.dart';
import 'package:flutter/material.dart';

class DataPage extends StatefulWidget {
  @override
  createState() => new _DataPageState();
}

class _DataPageState extends State<DataPage> {

  static GlobalKey<NavigatorState> stackKey = new GlobalKey();
  

  

  Widget get settingsButton => new IconButton(
    icon: new Icon(Icons.settings),
    onPressed: () {
    },
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: settingsButton,
        title: new Text("History"),
        actions: <Widget>[
          
        ],
      ),
      body: new ListView(
        children: MyApp.entries.isNotEmpty ? MyApp.entries.map((TapEntry t) => t.display) : new Container(color: Colors.white)
      ),
    );
  }
}