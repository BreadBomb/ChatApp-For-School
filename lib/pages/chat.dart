import 'package:chat/remote/ChatMessage.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:chat/views/chat_message.dart';

class ChatPage extends StatefulWidget {
  String sessionId;
  String sessionName;
  String username;
  String userID;
  IOWebSocketChannel channel;

  ChatPage({this.sessionId, this.sessionName, this.username, this.userID});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = new TextEditingController();
  final List<ChatMessageView> _messages = <ChatMessageView>[];

  void _handleSubmit(String text) {
    _chatController.clear();
    var chatMessage = new ChatMessage(text: text, userName: widget.username, time: DateTime.now().millisecondsSinceEpoch.toString(), systemMsg: false);
    widget.channel.sink.add(chatMessageToJson(chatMessage));
  }

  @override
  void dispose() {
    widget.channel.sink.close(status.goingAway);
  }

  Widget _chatEnvironment() {
    debugPrint(widget.sessionId);
    widget.channel = IOWebSocketChannel.connect(
        "ws://storage.wichtrup-li.de:8080/chat?session=" +
            widget.sessionId +
            "&user=" +
            widget.userID);

    widget.channel.stream.listen((message) {
      debugPrint(message);
      var chatMessage = chatMessageFromJson(message);
      ChatMessageView msg = new ChatMessageView(text: chatMessage.text, user: chatMessage.userName, otherSide: chatMessage.userName != widget.username,);
      setState(() {
        _messages.insert(0, msg);
      });
    });

    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration:
                    new InputDecoration.collapsed(hintText: "Start typing ..."),
                controller: _chatController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmit(_chatController.text),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(widget.sessionName),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem>[
                  new PopupMenuItem(child: new Text("QR Code öffnen"))
                ];
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.black12,
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              new Divider(
                height: 1.0,
              ),
              new Container(
                decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: _chatEnvironment(),
              )
            ],
          ),
        ));
  }
}
