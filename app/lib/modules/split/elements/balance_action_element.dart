part of split_module;

class BalanceActionElement with ElementBuilderMixin<ActionElement> {
  @override
  FutureOr<ActionElement?> build(ModuleContext module) async {
    var split = await module.context.read(splitProvider.future);
    if (split == null) {
      return null;
    }

    var params = module.hasParams ? module.getParams<BalanceFocusParams>() : BalanceFocusParams(null);

    if (params.source == null) {
      if (module.context.read(isOrganizerProvider)) {
        return ActionElement(
          module: module,
          icon: Icons.account_balance,
          text: module.context.tr.balances + '\n0.00 €',
          onNavigate: (context) => const SplitPage(),
          settings: (context) => [
            ListTile(
              title: Text(context.tr.from),
              onTap: () async {
                var source = await SelectSourceDialog.show(context, null);
                if (source != null) {
                  module.updateParams(params.copyWith(source: source));
                }
              },
            )
          ],
        );
      } else {
        return null;
      }
    } else {
      return ActionElement(
        module: module,
        icon: params.source!.type == SplitSourceType.user ? Icons.account_balance : Icons.savings,
        text: module.context.read(splitSourceLabelProvider(params.source!)) +
            '\n' +
            module.context.read(sourceBalanceProvider(params.source!)).toPrintString(),
        onNavigate: (context) => const SplitPage(),
        settings: (context) => [
          ListTile(
            title: Text(context.tr.from),
            subtitle: Text(module.context.read(splitSourceLabelProvider(params.source!))),
            onTap: () async {
              var source = await SelectSourceDialog.show(context, params.source);
              if (source != null) {
                module.updateParams(params.copyWith(source: source));
              }
            },
          )
        ],
      );
    }
  }
}
