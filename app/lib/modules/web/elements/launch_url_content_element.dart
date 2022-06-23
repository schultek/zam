part of web_module;

class LaunchUrlContentElement with ElementBuilder<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) async {
    var params = module.getParams<LaunchUrlParams?>() ?? LaunchUrlParams();

    if (params.url == null && !module.context.read(isOrganizerProvider)) {
      return null;
    }

    return ContentElement(
      module: module,
      builder: (context) {
        Widget child = UrlShortcutCard(params);
        if (params.url == null) child = NeedsSetupCard(child: child);
        return child;
      },
      onTap: (context) {
        var uri = Uri.tryParse(params.url ?? '');
        if (uri != null) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      settings: (context) => [
        InputListTile(
          label: context.tr.label,
          value: params.label,
          onChanged: (value) {
            module.updateParams(params.copyWith(label: value));
          },
        ),
        ListTile(
          title: const Text('Icon'),
          subtitle: Text(params.icon != null ? context.tr.tap_to_change : context.tr.tap_to_add),
          trailing: params.icon != null
              ? Text(params.icon!, style: const TextStyle(fontSize: 24))
              : const Icon(Icons.language),
          onTap: () async {
            var emoji = await showEmojiKeyboard(context);
            module.updateParams(params.copyWith(icon: emoji));
          },
        ),
        InputListTile(
          label: 'Url',
          value: params.url,
          onChanged: (value) {
            var uri = Uri.parse(value);
            if (!uri.hasScheme) {
              value = 'https://$value';
            }
            module.updateParams(params.copyWith(url: value));
          },
          keyboardType: TextInputType.url,
        ),
        SelectImageListTile(
          label: context.tr.custom_image,
          hasImage: params.imageUrl != null,
          crop: OverlayType.rectangle,
          onImageSelected: (bytes) async {
            var link = await context.read(groupsLogicProvider).uploadFile('web/images/${module.keyId}.png', bytes);
            module.updateParams(params.copyWith(imageUrl: link));
          },
          onDelete: () {
            module.updateParams(params.copyWith(imageUrl: null));
          },
        ),
      ],
    );
  }
}

class UrlShortcutCard extends StatelessWidget {
  final LaunchUrlParams params;
  const UrlShortcutCard(this.params, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (params.imageUrl == null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (params.icon != null)
                Text(
                  params.icon!,
                  style: TextStyle(fontSize: 46, color: context.onSurfaceColor),
                )
              else
                Icon(Icons.language, size: 50, color: context.onSurfaceColor),
              const SizedBox(height: 10),
              Text(
                params.label ?? context.tr.launch_url,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: context.onSurfaceColor),
                overflow: TextOverflow.fade,
                softWrap: true,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(params.imageUrl!),
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: context.theme.primaryColor.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (params.icon != null)
                      Text(
                        params.icon!,
                        style: const TextStyle(fontSize: 25),
                      )
                    else
                      const Icon(Icons.language, size: 25),
                    const SizedBox(width: 5),
                    Text(
                      params.label ?? context.tr.launch_url,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
