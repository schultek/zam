import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

class TheButtonRepository {
  String tripId;
  DateTime? lastReset;
  double? aliveHours;

  late StreamSubscription<DocumentSnapshot> _firebaseSubscription;

  Stream<double> get buttonState => _controller.stream;

  late StreamController<double> _controller;
  late Timer _timer;
  double? value;

  TheButtonRepository(this.tripId) {
    _firebaseSubscription = FirebaseFirestore.instance
        .collection("trips")
        .doc(tripId)
        .collection("modules")
        .doc("thebutton")
        .snapshots()
        .listen((snapshot) {
      lastReset = (snapshot.get("lastReset") as Timestamp).toDate();
      aliveHours = snapshot.get("aliveHours") * 1.0 as double;
      _updateValue();
    });

    _controller = StreamController.broadcast();
    _setupTimer();
  }

  Future<double> getValue() async => value ?? await buttonState.first;

  void _updateValue() {
    if (lastReset == null) {
      return;
    }

    var duration = DateTime.now().difference(lastReset!);
    var hours = duration.inSeconds / 3600.0;

    if (hours >= aliveHours!) {
      value = 1;
    } else {
      value = hours / aliveHours!;
    }

    _controller.sink.add(value!);
  }

  void _setupTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if ((value ?? 0) < 1) {
        _updateValue();
      }
    });
  }

  void dispose() {
    _firebaseSubscription.cancel();
    _controller.sink.close();
    _timer.cancel();
  }

  void resetState() {
    if ((value ?? 1) < 1) {
      FirebaseFirestore.instance
          .collection("trips")
          .doc(tripId)
          .collection("modules")
          .doc("thebutton")
          .set({"lastReset": Timestamp.now()}, SetOptions(merge: true));
    }
  }
}
