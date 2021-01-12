// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

List<ContactPerson> contactPersonFromJson(String str) =>
    List<ContactPerson>.from(
        json.decode(str).map((x) => ContactPerson.fromJson(x)));

String contactPersonToJson(List<ContactPerson> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ContactPerson {
  ContactPerson({
    this.id,
    this.name,
    this.contact,
    this.initial,
  });
  int id;
  String name;
  String contact;
  String initial;

  factory ContactPerson.fromJson(Map<String, dynamic> json) => ContactPerson(
        id: json["id"],
        name: json["name"],
        contact: json["contact"],
        initial: json["initial"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contact": contact,
        "initial": initial,
      };
}
