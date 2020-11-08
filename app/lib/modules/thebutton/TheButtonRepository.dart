

import 'dart:async';

class TheButtonRepository {

  Stream<double> get buttonState => _controller.stream;

  StreamController<double> _controller;
  Timer _timer;
  double value;

  TheButtonRepository(double initialState) {
    this._controller = StreamController.broadcast();
    this._pushValue(initialState);
    this._setupTimer();
  }

  _pushValue(double value) {
    this.value = value;
    this._controller.sink.add(value);
  }

  _setupTimer() {
    this._timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      if (this.value < 1) {
        this._pushValue(this.value + 0.02);
      }
    });
  }

  dispose() {
    this._controller.sink.close();
    this._timer.cancel();
  }

  resetState() {
    this._pushValue(0);
  }

}
