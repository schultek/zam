part of polls_module;

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
