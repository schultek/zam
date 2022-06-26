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

    var params = module.hasParams ? module.getParams<BalancesListParams>() : BalancesListParams();

    var hasBalances = split?.balances.values
            .where((b) => b.amounts.values.where((v) => params.showZeroBalances ? true : v != 0).isNotEmpty)
            .isNotEmpty ??
        false;

    if (hasBalances) {
      return ContentElement(
        module: module,
        size: ElementSize.wide,
        builder: (context) => BalancesList(params: params),
        onNavigate: (context) => const SplitPage(),
        settings: DialogElementSettings(
          builder: BalanceListSettingsBuilder(params, module),
        ),
      );
    }

    if (module.context.read(isOrganizerProvider)) {
      return ContentElement(
        module: module,
        size: ElementSize.wide,
        builder: (context) => ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 20),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              const MockBalanceTile(),
              const MockBalanceTile(),
              const MockBalanceTile(),
              const MockBalanceTile(),
            ].intersperse(const Divider(height: 0)).toList(),
          ),
        ),
        onNavigate: (context) => const SplitPage(),
        settings: SetupDialogElementSettings(
          hint: module.context.tr.add_an_expense,
          builder: BalanceListSettingsBuilder(params, module),
        ),
      );
    }

    return null;
  }
}

class BalanceListSettingsBuilder {
  BalanceListSettingsBuilder(this.params, this.module);

  final BalancesListParams params;
  final ModuleContext module;

  List<Widget> call(BuildContext context) {
    return [
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
    ];
  }
}

class MockBalanceTile extends StatelessWidget {
  const MockBalanceTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ThemedSurface(
        preference: const ColorPreference(useHighlightColor: true),
        builder: (context, color) => CircleAvatar(
          radius: 15,
          backgroundColor: context.surfaceColor,
          foregroundColor: context.onSurfaceColor,
          child: const Center(child: Icon(Icons.account_circle_outlined, size: 20)),
        ),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 14,
          width: 120,
          color: context.onSurfaceColor.withOpacity(0.4),
        ),
      ),
      trailing: Container(
        height: 12,
        width: 80,
        color: context.onSurfaceColor.withOpacity(0.4),
      ),
      minLeadingWidth: 20,
    );
  }
}
