// To parse this JSON data, do
//
//     final joinRoom = joinRoomFromJson(jsonString);

import 'dart:convert';

JoinRoom joinRoomFromJson(String str) => JoinRoom.fromJson(json.decode(str));

String joinRoomToJson(JoinRoom data) => json.encode(data.toJson());

class JoinRoom {
  int code;
  String message;
  String time;
  Data data;

  JoinRoom({
    this.code,
    this.message,
    this.time,
    this.data,
  });

  factory JoinRoom.fromJson(Map<String, dynamic> json) => new JoinRoom(
    code: json["code"],
    message: json["message"],
    time: json["time"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "time": time,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  String name;
  String sessionMotd;
  bool isWriting;

  Data({
    this.id,
    this.name,
    this.isWriting,
    this.sessionMotd
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
    id: json["id"],
    name: json["name"],
    sessionMotd: json["sesionMotd"],
    isWriting: json["isWriting"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sesionMotd": sessionMotd,
    "isWriting": isWriting,
  };
}
