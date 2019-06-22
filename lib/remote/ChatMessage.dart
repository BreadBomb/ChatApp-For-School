import 'dart:convert';

ChatMessage chatMessageFromJson(String str) => ChatMessage.fromJson(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
  String text;
  String time;
  String userName;
  bool systemMsg;

  ChatMessage({
    this.text,
    this.time,
    this.userName,
    this.systemMsg,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => new ChatMessage(
    text: json["text"],
    time: json["time"],
    userName: json["userName"],
    systemMsg: json["systemMsg"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "time": time,
    "userName": userName,
    "systemMsg": systemMsg,
  };
}
