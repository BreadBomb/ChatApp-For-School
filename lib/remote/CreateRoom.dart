// To parse this JSON data, do
//
//     final createRoom = createRoomFromJson(jsonString);

import 'dart:convert';

CreateRoom createRoomFromJson(String str) => CreateRoom.fromJson(json.decode(str));

String createRoomToJson(CreateRoom data) => json.encode(data.toJson());

class CreateRoom {
  int code;
  String message;
  String time;
  Data data;

  CreateRoom({
    this.code,
    this.message,
    this.time,
    this.data,
  });

  factory CreateRoom.fromJson(Map<String, dynamic> json) => new CreateRoom(
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
  String motd;
  String time;

  Data({
    this.id,
    this.motd,
    this.time,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
    id: json["id"],
    motd: json["motd"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "motd": motd,
    "time": time,
  };
}
