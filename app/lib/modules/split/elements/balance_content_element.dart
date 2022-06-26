part of split_module;

class BalanceContentElement with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.balance_content_element;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.balance_content_element_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.balance_content_element_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext module) async {
    var params = module.hasParams ? module.getParams<BalanceFocusParams>() : BalanceFocusParams();

    var source = params.getSource(module.context);
    if (source == null && !module.context.read(isOrganizerProvider)) {
      return null;
    }

    return ContentElement(
      module: module,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Transform.scale(
                  scale: 1.6,
                  child: source == null
                      ? Icon(Icons.account_balance, color: context.onSurfaceColor)
                      : source.isUser
                          ? UserAvatar(id: source.id)
                          : Center(child: PotIcon(id: source.id)),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                source == null
                    ? context.tr.balances + '\n0.00 €'
                    : '${context.watch(splitSourceLabelProvider(source))}\n'
                        '${context.watch(sourceBalanceProvider(source)).toPrintString()}',
                textAlign: TextAlign.center,
                style: context.theme.textTheme.titleLarge!.copyWith(color: context.onSurfaceColor),
              ),
            ],
          ),
        ),
      ),
      onNavigate: (context) => const SplitPage(),
      settings: source != null
          ? DialogElementSettings(
              builder: BalanceSettingsBuilder(params, module),
            )
          : SetupDialogElementSettings(
              hint: module.context.tr.select_a_balance,
              builder: BalanceSettingsBuilder(params, module),
            ),
    );
  }
}

class BalanceSettingsBuilder {
  final BalanceFocusParams params;
  final ModuleContext module;

  BalanceSettingsBuilder(this.params, this.module);

  List<Widget> call(BuildContext context) {
    return [
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
    ];
  }
}
