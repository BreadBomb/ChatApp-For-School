import 'dart:convert';

import 'package:chat/remote/CreateRoom.dart';
import 'package:chat/remote/JoinRoom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

import 'chat.dart';
import 'main_page.dart';

class CreateRoomPage extends StatefulWidget {
  bool loading = false;
  String qrCodeID = "";
  String usernameID = "";
  String username = "";
  String sessionName = "";
  bool failed = false;
  String failedMessage = "";
  bool isNextDisabled = false;

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final motdTextFieldController = TextEditingController();
  final usernameTextFieldController = TextEditingController();

  Future<CreateRoom> createRoom(String motd) async {
    var response;

    try {
      response = await http
          .get('http://storage.wichtrup-li.de:8080/room/create?motd=' + motd);
    } catch (e) {
      setState(() {
        widget.failed = true;
        widget.failedMessage = e.toString();
      });
      return null;
    }

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return CreateRoom.fromJson(json.decode(response.body));
    } else {
      setState(() {
        widget.failed = true;
        widget.failedMessage = response.reasonPhrase;
      });
      return null;
    }
  }

  Future<JoinRoom> joinRoom(String roomId, String username) async {
    var response;

    try {
      response = await http.get(
          'http://storage.wichtrup-li.de:8080/room/join?id=' +
              roomId +
              '&username=' +
              username);
    } catch (e) {
      setState(() {
        widget.failed = true;
        widget.failedMessage = e.toString();
      });
      return null;
    }

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return JoinRoom.fromJson(json.decode(response.body));
    } else {
      setState(() {
        widget.failed = true;
        widget.failedMessage = response.reasonPhrase;
      });
      return null;
    }
  }

  Widget GetQrCodeOrFailed() {
    debugPrint(widget.loading.toString());
    if (widget.failed) {
      return SizedBox(
        width: 300,
        height: 300,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.error,
              color: Colors.redAccent,
            ),
            new Text(
              widget.failedMessage,
              style: new TextStyle(color: Colors.redAccent),
            )
          ],
        ),
      );
    } else {
      return new QrImage(
        data: widget.qrCodeID,
        size: 300.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    PageView pageView = new PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "Erstelle Raum",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Container(
                  margin: EdgeInsets.only(top: 20),
                ),
                new Text(
                  "Um einem Raum erstellen zu können, musst du zuerst deinen Namen eingeben:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.left,
                ),
                new Container(
                  margin: EdgeInsets.only(top: 40),
                ),
                new TextField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: usernameTextFieldController,
                ),
              ],
            ),
          );
        }
        if (index == 1) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "Erstelle Raum",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Container(
                  margin: EdgeInsets.only(top: 20),
                ),
                new Text(
                  "Gib deinem neuen Raum einen Namen:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.left,
                ),
                new Container(
                  margin: EdgeInsets.only(top: 40),
                ),
                new TextField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: motdTextFieldController,
                ),
              ],
            ),
          );
        }
        if (index == 2) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "Erstelle Raum",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Container(
                  margin: EdgeInsets.only(top: 20),
                ),
                new Text(
                  "Scanne mit anderen Geräten den Code um dem Raum beizutreten.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.left,
                ),
                new Container(
                    margin: EdgeInsets.only(top: 40),
                    child: new Center(
                        child: new Card(
                            elevation: 3,
                            child: new ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(3),
                                child: new SizedOverflowBox(
                                    size: Size(300, 300),
                                    child: widget.loading
                                        ? new CircularProgressIndicator()
                                        : GetQrCodeOrFailed())))))
              ],
            ),
          );
        }
      },
      controller: new PageController(),
    );

    return new Scaffold(
        body: SafeArea(
      child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(child: pageView),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                            (route) => route.isFirst == true);
                      },
                      color: Colors.deepPurple,
                      child: Text(
                        "Abbrechen",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10, bottom: 5),
                    child: RaisedButton(
                      onPressed: widget.isNextDisabled ||
                              widget.loading ||
                              widget.failed
                          ? null
                          : () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              pageView.controller.nextPage(
                                  duration: Duration(milliseconds: 200),
                                  curve: new ElasticOutCurve());
                              Next(pageView.controller.page);
                            },
                      color: Colors.pinkAccent,
                      child: Text(
                        "Weiter",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    ));
  }

  Next(double page) {
    debugPrint(page.toString());
    if (page == 1.0) {
      this.setState(() {
        widget.loading = true;
      });
      this.createRoom(motdTextFieldController.text).then((createRoom) {
        if (createRoom != null) {
          this
              .joinRoom(createRoom.data.id, usernameTextFieldController.text)
              .then((joinRoom) {
            debugPrint(createRoom.data.id);
            this.setState(() {
              widget.loading = false;
              widget.qrCodeID = createRoom.data.id;
              widget.usernameID = joinRoom.data.id;
              widget.username = joinRoom.data.name;
              widget.sessionName = createRoom.data.motd;
            });
          });
        } else {
          this.setState(() {
            widget.loading = false;
            widget.isNextDisabled = true;
          });
        }
      });
    }
    if (page == 2.0) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(
                    sessionId: widget.qrCodeID,
                    username: widget.username,
                    userID: widget.usernameID,
                    sessionName: widget.sessionName,
                  )),
          (route) => route.isFirst == true);
    }
  }
}
