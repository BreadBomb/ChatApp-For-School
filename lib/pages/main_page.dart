import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                onPressed: () => {},
                child: new Icon(Icons.chat, size: 50.0),
                shape: CircleBorder(),
                padding: EdgeInsets.all(15.0),
                  textColor: Colors.white,
                color: Colors.pinkAccent
              ),
              Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(new Radius.circular(5)),
                  color: Colors.black12
                ),
                margin: EdgeInsets.only(left: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: new Text("Join Room", style: new TextStyle(fontSize: 15.0),),
                ),
              )
            ],
          ),
          new Container(
            margin: EdgeInsets.only(top: 20)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                  onPressed: () => {},
                  child: new Icon(Icons.add, size: 50.0),
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(15.0),
                  textColor: Colors.white,
                  color: Colors.deepPurpleAccent
              ),
              Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(new Radius.circular(5)),
                    color: Colors.black12
                ),
                margin: EdgeInsets.only(left: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: new Text("Create Room", style: new TextStyle(fontSize: 15.0),),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
