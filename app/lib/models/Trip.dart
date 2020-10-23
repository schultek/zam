import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String name;

  Trip(this.name);

  factory Trip.fromDocument(DocumentSnapshot document) {
    return Trip(document.get("name"));
  }
}