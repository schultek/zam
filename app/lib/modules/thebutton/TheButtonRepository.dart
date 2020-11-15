import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class TheButtonRepository {
  String tripId;
  DateTime lastReset;
  double aliveHours;

  StreamSubscription<DocumentSnapshot> _firebaseSubscription;

  Stream<double> get buttonState => _controller.stream;

  StreamController<double> _controller;
  Timer _timer;
  double value;

  TheButtonRepository(this.tripId) {

    this._firebaseSubscription = FirebaseFirestore.instance.collection("trips")
      .doc(this.tripId)
      .collection("modules")
      .doc("thebutton")
      .snapshots().listen((snapshot) {
        this.lastReset = (snapshot.get("lastReset") as Timestamp).toDate();
        this.aliveHours = snapshot.get("aliveHours") * 1.0;
        this._updateValue();
      });

    this._controller = StreamController.broadcast();
    this._setupTimer();
  }

  _updateValue() {
    if (this.lastReset == null) {
      return;
    }

    var duration = DateTime.now().difference(this.lastReset);
    var hours = duration.inSeconds / 3600.0;

    if (hours >= aliveHours) {
      this.value = 1;
    } else {
      this.value = hours / this.aliveHours;
    }

    this._controller.sink.add(value);
  }

  _setupTimer() {
    this._timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      if (this.value < 1) {
        this._updateValue();
      }
    });
  }

  dispose() {
    this._firebaseSubscription.cancel();
    this._controller.sink.close();
    this._timer.cancel();
  }

  resetState() {
    if (this.value < 1) {
      FirebaseFirestore.instance.collection("trips")
          .doc(this.tripId)
          .collection("modules")
          .doc("thebutton")
          .set({
        "lastReset": Timestamp.now()
      }, SetOptions(merge: true));
    }
  }

}
