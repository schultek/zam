import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.mapper.g.dart';
import '../../providers/firebase/doc_provider.dart';

@MappableClass()
class Poll {
  final String id;
  final String name;
  final DateTime startedAt;

  final List<PollStep> steps;

  Poll(this.id, this.name, this.startedAt, this.steps);
}

@MappableClass(discriminatorKey: 'type')
class PollStep {
  final String type;

  PollStep(this.type);
}

@MappableClass(discriminatorValue: 'multiple-choice')
class MultipleChoiceQuestion extends PollStep {
  List<String> choices;
  bool multiselect;

  MultipleChoiceQuestion(this.choices, this.multiselect, String type) : super(type);
}

/*

Poll

Name, Id
StartedAt, EndingAt

Steps
  - Text, Question, ...

Logic
  - Branching, Conditions, Scores, Endings

Endings


 */

final pollsProvider =
    StreamProvider((ref) => ref.watch(moduleDocProvider('polls')).collection('polls').snapshotsMapped<Poll>());

final pollProvider = StreamProvider.family(
    (ref, String id) => ref.watch(moduleDocProvider('polls')).collection('polls').doc(id).snapshotsMapped<Poll>());

final pollsLogicProvider = Provider((ref) => PollsLogic(ref));

class PollsLogic {
  final Ref ref;
  final DocumentReference doc;
  PollsLogic(this.ref) : doc = ref.watch(moduleDocProvider('polls'));

  Future<Poll> createPoll(String name, List<PollStep> steps) async {
    var pollDoc = doc.collection('polls').doc();
    var poll = Poll(pollDoc.id, name, DateTime.now(), steps);
    await pollDoc.set(poll.toMap());
    return poll;
  }

  Future<void> deletePoll(String id) async {
    await doc.collection('polls').doc(id).delete();
  }
}
