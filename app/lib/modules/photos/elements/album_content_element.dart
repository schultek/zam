part of photos_module;

class AlbumContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) async {
    if (module.hasParams) {
      var albumId = module.getParams<String>();
      var album = await module.context.read(albumShortcutProvider(albumId).future);

      return ContentElement(
        module: module,
        builder: (context) => PhotosAlbumShortcutCard(album),
        onTap: (context) {
          launchUrl(
            Uri.parse(album.albumUrl),
            mode: LaunchMode.externalApplication,
          );
        },
        whenRemoved: (context) {
          context.read(googleAccountProvider.notifier).signOut();
          context.read(photosLogicProvider).removeAlbumShortcut(album.id);
        },
      );
    } else {
      if (!module.context.read(isOrganizerProvider)) {
        return null;
      }

      return ContentElement(
        module: module,
        builder: (context) => SimpleCard(
          title: context.tr.select_album,
          icon: Icons.image,
        ),
        settings: (context) => [
          ListTile(
            title: Text(context.tr.select_album),
            onTap: () {
              selectAlbum(context, module);
            },
          ),
        ],
      );
    }
  }

  void selectAlbum(BuildContext context, ModuleContext module) async {
    var isSignedIn = await context.read(isSignedInWithGoogleProvider.future);
    if (!isSignedIn) {
      isSignedIn = await showSignInWithGooglePrompt(context);
      if (!isSignedIn) return;
    }

    var albums = await context.read(photosLogicProvider).getAlbums();

    var selectedAlbum = await Navigator.of(context).push(SelectPhotosAlbumPage.route(albums));

    if (selectedAlbum != null) {
      var docId = await context.read(photosLogicProvider).createAlbumShortcut(selectedAlbum);
      module.updateParams(docId);
    }
  }

  Future<bool> showSignInWithGooglePrompt(BuildContext context) async {
    var didSignIn = await showPrompt<bool>(
      context,
      title: context.tr.sign_in_google,
      body: context.tr.sign_in_google_desc,
      onContinue: () => context.read(googleAccountProvider.notifier).signIn(),
    );
    return didSignIn ?? false;
  }

  Future<T?> showPrompt<T>(BuildContext context,
      {required String title, String? body, required FutureOr<T> Function() onContinue}) async {
    var result = await showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: body != null ? Text(body) : null,
        actions: [
          TextButton(
            onPressed: () async {
              var result = await onContinue();
              Navigator.of(context).pop(result);
            },
            child: Text(context.tr.do_continue),
          ),
        ],
      ),
    );
    return result;
  }
}
