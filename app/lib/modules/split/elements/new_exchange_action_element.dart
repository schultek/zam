part of split_module;

class NewExchangeActionElement with ElementBuilderMixin<ActionElement> {
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
