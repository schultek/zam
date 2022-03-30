part of music_module;

class PlayerContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext<ModuleElement> module) {
    return ContentElement(
      module: module,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          var signedInValue = ref.watch(spotifyIsSignedInProvider);
          return signedInValue.when(
            data: (signedIn) {
              if (!signedIn) {
                return const SignedOutPlayer();
              } else {
                return const SpotifyPlayerCard();
              }
            },
            loading: () => const LoadingShimmer(),
            error: (e, st) => Text('${context.tr.error}: $e'),
          );
        },
      ),
    );
  }
}
