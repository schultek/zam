part of split_module;

final splitProvider = StreamProvider<SplitState?>((ref) async* {
  var doc = ref.watch(moduleDocProvider('split'));

  var snapshot = await doc.get();
  if (!snapshot.exists) {
    await doc.mapped<SplitState>().set(SplitState());
  }

  yield* doc.snapshotsMapped<SplitState?>();
});

final splitLogicProvider = Provider((ref) => SplitLogic(ref));

final splitSourceLabelProvider = Provider.family((ref, SplitSource source) {
  if (source.isUser) {
    return ref.watch(groupUserByIdProvider(source.id))?.nickname ?? ref.read(l10nProvider).anonymous;
  } else {
    return ref.watch(splitProvider.select((split) => split.value?.pots[source.id]?.name)) ??
        ref.read(l10nProvider).untitled;
  }
});

final splitPotProvider = Provider.family((ref, String id) => ref.watch(splitProvider).value?.pots[id]);

final balancesProvider = Provider((ref) => ref.watch(splitProvider).value?.balances ?? {});

final sourceBalanceProvider = Provider.family((ref, SplitSource source) {
  return ref.watch(balancesProvider)[source] ?? SplitBalance.zeroEuros;
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

  Future<void> toggleBilling() {
    return doc.update({'showBilling': !(ref.read(splitProvider).value?.showBilling ?? false)});
  }

  Future<void> addNewPot(SplitPot pot) {
    var id = generateRandomId(8);
    return doc.update({'pots.$id': Mapper.toValue(pot)});
  }

  Future<void> deleteEntry(String id) {
    return doc.update({'entries.$id': FieldValue.delete()});
  }

  Future<void> addNewTemplate(SplitTemplate template) {
    return doc.update({
      'templates': FieldValue.arrayUnion([Mapper.toValue(template)]),
    });
  }

  Future<void> removeTemplate(SplitTemplate template) async {
    var templates = ref.read(splitProvider).value?.templates;
    if (templates == null) {
      return;
    }
    return doc.update({
      'templates': templates.where((t) => t != template).map(Mapper.toValue).toList(),
    });
  }

  Future<void> setBillingRates(BillingRates? rates) async {
    return doc.update({
      'billingRates': Mapper.toValue(rates),
    });
  }
}
