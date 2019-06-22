import 'dart:convert';

import 'package:chat/remote/JoinRoom.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


import '../main.dart';
import 'chat.dart';

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class JoinRoomPage extends StatefulWidget {
  @override
  _JoinRoomPageState createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  QRReaderController controller;
  final usernameTextFieldController = TextEditingController();

  Future<JoinRoom> joinRoom(String roomId, String username) async {
    var response;

    try {
      response = await http.get(
          'http://storage.wichtrup-li.de:8080/room/join?id=' +
              roomId +
              '&username=' +
              username);
    } catch (e) {
      return null;
    }

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return JoinRoom.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = new QRReaderController(
        cameras[0], ResolutionPreset.high, [CodeFormat.qr], (dynamic value) {
      joinRoom(value, usernameTextFieldController.text).then((joinRoom) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                  sessionId: value,
                  username: joinRoom.data.name,
                  userID: joinRoom.data.id,
                  sessionName: joinRoom.data.sessionMotd,
                )),
                (route) => route.isFirst == true);
      });
      new Future.delayed(const Duration(seconds: 3), controller.startScanning);
    });
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      controller.startScanning();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext con3text) {
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
                  "Join Room",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Container(
                  margin: EdgeInsets.only(top: 20),
                ),
                new Text(
                  "Um einem Raum beitreten zu können, musst du zuerst deinen Namen eingeben:",
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
                  "Join Room",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Container(
                  margin: EdgeInsets.only(top: 20),
                ),
                new Text(
                  "Scanne den QR-Code, um einem Chat beizutreten:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.left,
                ),
                new Container(
                  margin: EdgeInsets.only(top: 40),
                ),
                !controller.value.isInitialized
                    ? new Container()
                    : new Center(
                        child: new Card(
                            elevation: 3,
                            child: new ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(3),
                                child: new SizedOverflowBox(
                                    size: Size(300, 300),
                                    child: new AspectRatio(
                                        aspectRatio:
                                            controller.value.aspectRatio,
                                        child:
                                            new QRReaderPreview(controller))))))
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10, bottom: 5),
                    child: RaisedButton(
                      onPressed: () => {
                            FocusScope.of(context).requestFocus(new FocusNode()),
                            pageView.controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: new ElasticOutCurve())
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
}
