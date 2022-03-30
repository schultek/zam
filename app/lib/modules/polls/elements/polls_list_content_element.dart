part of polls_module;

class PollsListContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) async {
    var polls = await module.context.read(pollsProvider.future);
    if (polls.isNotEmpty) {
      return ContentElement.list(
        module: module,
        builder: PollsListBuilder(),
        spacing: 10,
      );
    }
    return null;
  }
}
