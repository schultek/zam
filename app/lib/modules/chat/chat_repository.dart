import 'package:firebase_database/firebase_database.dart';

import '../../bloc/auth_bloc.dart';
import '../../core/module/module.dart';
import '../../helpers/locator.dart';

class ChatRepository {
  final ModuleData moduleData;
  final DatabaseReference db;

  ChatRepository(this.moduleData) : db = FirebaseDatabase.instance.reference().child(moduleData.trip.id);

  Stream<List<ChannelInfo>> get channels async* {
    await for (var event in db.child("channels").onValue) {
      if (event.snapshot.value == null) {
        yield [];
        continue;
      }
      yield (event.snapshot.value as Map)
          .entries
          .map((e) => ChannelInfo(
                id: e.key as String,
                name: e.value["name"] as String,
                db: db.child(moduleData.trip.id),
              ))
          .toList();
    }
  }

  void addChannel(String name) {
    db.child("channels").push().update({"name": name});
  }

  void delete(String id) {
    db.child("channels/$id").remove();
    db.child("messages/$id").remove();
  }
}

class ChannelInfo {
  final String name;
  final String id;
  final DatabaseReference _db;

  ChannelInfo({required this.id, required this.name, required DatabaseReference db}) : _db = db;

  Stream<List<ChatMessage>> get messages async* {
    await for (var event in _db.child("/messages/$id").onValue) {
      if (event.snapshot.value == null) {
        yield [];
        continue;
      }
      yield (event.snapshot.value as Map)
          .entries
          .map((e) => ChatMessage(
                sender: e.value["sender"] as String,
                text: e.value["text"] as String,
                sentAt: DateTime.parse(e.value["sentAt"] as String),
              ))
          .toList();
    }
  }

  void send(String text) {
    _db.child("/messages/$id").push().update({
      "sender": locator<AuthBloc>().state.user!.uid,
      "text": text,
      "sentAt": DateTime.now().toUtc().toIso8601String(),
    });
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final DateTime sentAt;

  ChatMessage({required this.sender, required this.text, required this.sentAt});
}
