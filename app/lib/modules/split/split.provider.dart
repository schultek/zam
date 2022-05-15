part of split_module;

final splitProvider = StreamProvider<SplitState?>((ref) {
  var doc = ref.watch(moduleDocProvider('split'));

  doc.get().then((d) {
    if (!d.exists) {
      doc.mapped().set(SplitState());
    }
  });

  return doc.snapshotsMapped<SplitState?>();
});

final splitLogicProvider = Provider((ref) => SplitLogic(ref));

class SplitLogic {
  final Ref ref;
  final DocumentReference doc;
  SplitLogic(this.ref) : doc = ref.watch(moduleDocProvider('split'));

  Future<void> addEntry(SplitEntry entry) {
    return doc.update({
      'entries': FieldValue.arrayUnion([Mapper.toValue(entry)])
    });
  }

  Future<void> addNewPot(String name) {
    var id = generateRandomId(8);
    return doc.update({
      'pots.$id': Mapper.toValue(SplitPot(name: name)),
    });
  }
}
