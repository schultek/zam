part of split_module;

class BalancesListContentSegment with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.split_balance_list;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.split_balance_list_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.split_balance_list_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext module) async {
    var split = await module.context.read(splitProvider.future);
    if (split == null) {
      return null;
    }

    var params = module.hasParams ? module.getParams<BalancesListParams>() : BalancesListParams();

    var hasBalances = split.balances.values
        .where((b) => b.amounts.values.where((v) => params.showZeroBalances ? true : v != 0).isNotEmpty)
        .isNotEmpty;

    if (hasBalances) {
      return ContentElement(
        module: module,
        size: ElementSize.wide,
        builder: (context) => BalancesList(params: params),
        onNavigate: (context) => const SplitPage(),
        settings: DialogElementSettings(
            builder: (context) => [
                  SwitchListTile(
                    value: params.showZeroBalances,
                    onChanged: (v) {
                      module.updateParams(params.copyWith(showZeroBalances: v));
                    },
                    title: Text(context.tr.show_zero_balances),
                  ),
                  SwitchListTile(
                    value: params.showPots,
                    onChanged: (v) {
                      module.updateParams(params.copyWith(showPots: v));
                    },
                    title: Text(context.tr.show_pots),
                  ),
                ]),
      );
    }
    return null;
  }
}
