import 'package:functions_framework/functions_framework.dart' as ff;

export 'package:functions_framework/functions_framework.dart' hide CloudFunction;

class CloudFunction extends ff.CloudFunction {
  final EventArcTrigger? trigger;

  const CloudFunction({String? target, this.trigger}) : super(target: target);
}

abstract class EventArcTrigger {}

class FirestoreTrigger implements EventArcTrigger {
  const FirestoreTrigger.onCreate(this.documentPath) : event = 'Create';

  final String documentPath;

  final String event;
}
