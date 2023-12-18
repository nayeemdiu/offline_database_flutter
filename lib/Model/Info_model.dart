// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:convert';

Information todoFromJson(String str) => Information.fromJson(json.decode(str));

String todoToJson(Information data) => json.encode(data.toJson());

class Information {
  int id;
  String name;
//  String? address;
  String degicnation;

  Information({
    required this.id,
    required this.name,
   // required this.address,
    required this.degicnation,
  });

  factory Information.fromJson(Map<String, dynamic> json) => Information(
    id: json["id"],
    name: json["name"],
    // address: json["address"],
    degicnation: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    //"address": address,
    "title": degicnation,
  };
}
