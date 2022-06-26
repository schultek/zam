part of split_module;

class NewExchangeActionElement with ElementBuilder<ActionElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.new_exchange;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.split_new_exchange_action_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.split_new_exchange_action_text);
  }

  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.currency_exchange,
      text: module.context.tr.new_exchange.replaceAll(' ', '\n'),
      onTap: (BuildContext context) async {
        var logic = context.read(splitLogicProvider);
        var result =
            await Navigator.of(context).push<ExchangeEntry>(ModulePageRoute(context, child: const EditExchangePage()));
        if (result != null) {
          logic.updateEntry(result);
        }
      },
    );
  }
}
