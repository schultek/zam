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

final splitSourceLabelProvider = Provider.family((ref, SplitSource source) {
  if (source.type == SplitSourceType.user) {
    return ref.watch(groupUserByIdProvider(source.id).select((u) => u?.nickname)) ?? ref.read(l10nProvider).anonymous;
  } else {
    return ref.watch(splitProvider.select((split) => split.value?.pots[source.id]?.name)) ??
        ref.read(l10nProvider).untitled;
  }
});

final balancesProvider = Provider((ref) => ref.watch(splitProvider).value?.balances ?? {});

final sourceBalanceProvider = Provider.family((ref, SplitSource source) {
  return ref.watch(balancesProvider)[source] ?? SplitBalance({Currency.euro: 0});
});

final userBalanceProvider = Provider.family((ref, String id) {
  return ref.watch(sourceBalanceProvider(SplitSource.user(id)));
});

class SplitLogic {
  final Ref ref;
  final DocumentReference doc;
  SplitLogic(this.ref) : doc = ref.watch(moduleDocProvider('split'));

  Future<void> updateEntry(SplitEntry entry) {
    return doc.update({'entries.${entry.id}': Mapper.toValue(entry)});
  }

  Future<void> addNewPot(String name) {
    var id = generateRandomId(8);
    return doc.update({'pots.$id': Mapper.toValue(SplitPot(name: name))});
  }
}
