part of split_module;

class BalanceActionElement with ElementBuilderMixin<ActionElement> {
  @override
  FutureOr<ActionElement?> build(ModuleContext module) async {
    var split = await module.context.read(splitProvider.future);
    if (split == null) {
      return null;
    }

    var params = module.hasParams ? module.getParams<BalanceFocusParams>() : BalanceFocusParams();

    var source = params.getSource(module.context);
    if (source == null && !module.context.read(isOrganizerProvider)) {
      return null;
    }

    return ActionElement.builder(
      module: module,
      icon: source == null ? Icons.account_balance : null,
      iconWidget: source == null
          ? null
          : source.type == SplitSourceType.user
              ? UserAvatar(id: source.id, needsSurface: false)
              : Center(child: PotIcon(id: source.id)),
      text: (context) {
        return source == null
            ? context.tr.balances + '\n0.00 €'
            : '${context.watch(splitSourceLabelProvider(source))}\n'
                '${context.watch(sourceBalanceProvider(source)).toPrintString()}';
      },
      onNavigate: (context) => const SplitPage(),
      settings: (context) => [
        SwitchListTile(
          title: Text(context.tr.current_user),
          value: params.currentUser,
          onChanged: (value) {
            module.updateParams(params.copyWith(currentUser: value));
          },
        ),
        ListTile(
          enabled: !params.currentUser,
          title: Text(context.tr.from),
          subtitle: Text(params.source != null
              ? module.context.read(splitSourceLabelProvider(params.source!))
              : context.tr.tap_to_add),
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
