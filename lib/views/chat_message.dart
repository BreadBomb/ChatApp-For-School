import 'package:flutter/material.dart';

const String _name = "Anonymous";

class ChatMessageView extends StatelessWidget {
  final String text;
  final bool otherSide;
  final String user;

// constructor to get text from textfield
  ChatMessageView({this.text, this.otherSide, this.user});

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Container(
            padding: EdgeInsets.all(5),
            decoration: new BoxDecoration(
              color: this.otherSide == true ? Colors.white : new Color.fromARGB(255, 220, 248, 198),
              boxShadow: <BoxShadow>[
                new BoxShadow(color: Colors.black26, blurRadius: 10)
              ],
              borderRadius: BorderRadius.circular(5),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(this.user,
                    style: new TextStyle(fontWeight: FontWeight.bold)),
                new Divider(
                  height: 3,
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                )
              ],
            )));
  }
}
