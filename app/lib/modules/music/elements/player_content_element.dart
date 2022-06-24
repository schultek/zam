part of music_module;

@MappableClass()
class PlayerParams {
  final bool allowUserAccount;
  final bool showPlayerControls;
  final bool showPlaylistControls;

  PlayerParams({
    this.allowUserAccount = false,
    this.showPlayerControls = true,
    this.showPlaylistControls = true,
  });
}

class PlayerContentElement with ElementBuilder<ContentElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.player;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.player_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.player_text);
  }

  @override
  FutureOr<ContentElement?> build(ModuleContext<ModuleElement> module) {
    var params = module.getParams<PlayerParams?>() ?? PlayerParams();

    var isSignedIn = module.context.read(spotifyIsSignedInProvider).value ?? false;
    if (!params.allowUserAccount && !isSignedIn && !module.context.read(isOrganizerProvider)) {
      return null;
    }

    return ContentElement(
      module: module,
      builder: (context) {
        var signedInValue = context.watch(spotifyIsSignedInProvider);

        return signedInValue.when(
          data: (signedIn) {
            if (!signedIn) {
              if (params.allowUserAccount) {
                return GestureDetector(
                  onTap: () {
                    signInToSpotify(context);
                  },
                  child: SimpleCard(
                    title: context.tr.login_spotify,
                    icon: Icons.music_note,
                  ),
                );
              } else {
                return const NeedsSetupCard(
                  child: SimpleCard(
                    title: 'Spotify',
                    icon: Icons.music_note,
                  ),
                );
              }
            } else {
              return SpotifyPlayerCard(
                showPlayerControls: params.showPlayerControls,
                showPlaylistControls: params.showPlaylistControls,
              );
            }
          },
          loading: () => const LoadingShimmer(),
          error: (e, st) => Text('${context.tr.error}: $e'),
        );
      },
      settings: (context) => [
        SwitchListTile(
          title: Text(context.tr.allow_user_accounts),
          subtitle: Text(context.tr.allow_users_spotify_login),
          value: params.allowUserAccount,
          onChanged: (value) {
            module.updateParams(params.copyWith(allowUserAccount: value));
          },
        ),
        ListTile(
          title: Text(context.tr.login_spotify),
          subtitle: Text(context.watch(spotifyIsSignedInProvider).when(
              data: (d) => d ? context.tr.signed_in : context.tr.signed_out,
              loading: () => context.tr.loading,
              error: (e, _) => '${context.tr.error}: $e')),
          trailing: context.read(spotifyIsSignedInProvider).value == true
              ? IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read(musicLogicProvider).signOut();
                  },
                )
              : null,
          onTap: () {
            signInToSpotify(context);
          },
        ),
        SwitchListTile(
          title: Text(context.tr.show_player_controls),
          subtitle: Text(context.tr.allow_control_playback),
          value: params.showPlayerControls,
          onChanged: (value) {
            module.updateParams(params.copyWith(showPlayerControls: value));
          },
        ),
        SwitchListTile(
          title: Text(context.tr.show_playlist_controls),
          subtitle: Text(context.tr.allow_modify_playlist),
          value: params.showPlaylistControls,
          onChanged: (value) {
            module.updateParams(params.copyWith(showPlaylistControls: value));
          },
        ),
      ],
    );
  }

  Future<void> signInToSpotify(BuildContext context) {
    return context
        .read(musicLogicProvider)
        .signInToSpotify((authUri, redirectUri) => openSignIn(context, authUri, redirectUri));
  }

  Future<String?> openSignIn(BuildContext context, Uri authUri, String redirectUri) async {
    var response = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(top: 15),
          child: SafeArea(
            bottom: false,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: authUri.toString(),
                userAgent: 'Chrome/102.0.0.0 Mobile',
                navigationDelegate: (navReq) {
                  if (navReq.url.startsWith(redirectUri)) {
                    Navigator.of(context).pop(navReq.url);
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            ),
          ),
        ),
      ),
    );
    return response;
  }
}
