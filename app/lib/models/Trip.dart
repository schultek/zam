import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String name;
  String id;

  Trip(this.id, this.name);

  factory Trip.fromDocument(DocumentSnapshot document) {
    return Trip(document.id, document.get("name"));
  }
}