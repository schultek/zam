part of thebutton_module;

class TheButtonElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    var buttonHelpKey = GlobalKey();
    var buttonSettingsKey = GlobalKey();
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
                  if (context.read(isOrganizerProvider))
                    Positioned.fill(child: TheButtonSettings(key: buttonSettingsKey)),
                  Positioned.fill(child: TheButtonHelp(key: buttonHelpKey)),
                ],
              );
            },
            loading: () => const LoadingShimmer(),
            error: (e, st) => Text('${context.tr.error}: $e'),
          );
        });
      },
    );
  }
}
