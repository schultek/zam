part of thebutton_module;

class TheButtonElement with ElementBuilder<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    var buttonHelpKey = GlobalKey();
    return ContentElement(
      module: module,
      builder: (context) {
        return Consumer(builder: (context, ref, _) {
          var state = ref.watch(theButtonProvider);
          return state.when(
            data: (state) {
              if (state == null) {
                context.read(theButtonLogicProvider).init();
                return const LoadingShimmer();
              }
              return Stack(
                children: [
                  const Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: TheButton(),
                    ),
                  ),
                  Positioned.fill(child: TheButtonHelp(key: buttonHelpKey)),
                ],
              );
            },
            loading: () => const LoadingShimmer(),
            error: (e, _) => Text('${context.tr.error}: $e'),
          );
        });
      },
      settings: (context) {
        var isExpanded = false;
        return [
          StatefulBuilder(builder: (context, setState) {
            return ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (_, value) {
                setState(() => isExpanded = !value);
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: isExpanded,
                  headerBuilder: (c, b) => ListTile(
                    title: Text(context.tr.alive_period),
                    subtitle: Text(context.tr.tap_to_change),
                  ),
                  body: TheButtonSettings(
                    onChanged: (value) {
                      context.read(theButtonLogicProvider).setAliveHours(value);
                      setState(() => isExpanded = false);
                    },
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ],
            );
          }),
          ListTile(
            title: Text(context.tr.reset_health),
            onTap: () async {
              var reset = await SettingsDialog.confirm(context, text: context.tr.confirm_reset(true));
              if (reset) {
                context.read(theButtonLogicProvider).resetHealth();
              }
            },
          ),
          ListTile(
            title: Text(context.tr.reset_leaderboard),
            onTap: () async {
              var reset = await SettingsDialog.confirm(context, text: context.tr.confirm_reset(false));
              if (reset) {
                context.read(theButtonLogicProvider).resetLeaderboard();
              }
            },
          ),
        ];
      },
    );
  }
}
