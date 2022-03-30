part of announcement_module;

class AnnouncementContentElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) async {
    if (module.hasParams) {
      var announcementId = module.getParams<String>();

      if (await module.context.read(isDismissedProvider(announcementId).future)) {
        return null;
      }

      return ContentElement(
        module: module,
        size: ElementSize.wide,
        whenRemoved: (context) {
          context.read(announcementLogicProvider).removeAnnouncement(announcementId);
        },
        builder: (context) => Consumer(
          builder: (context, ref, _) {
            var announcement = ref.watch(announcementProvider(announcementId));

            return AnnouncementCard(
              announcement: announcement,
              onDismissed: !context.read(isOrganizerProvider)
                  ? () {
                      context.read(announcementLogicProvider).dismiss(announcementId);
                      Area.of<ContentElement>(context)?.reload();
                    }
                  : null,
            );
          },
        ),
      );
    } else {
      if (module.context.read(isOrganizerProvider)) {
        return ContentElement(
          module: module,
          size: ElementSize.wide,
          builder: (context) => AspectRatio(
            aspectRatio: 2.1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: context.onSurfaceHighlightColor,
                    size: 50,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    context.tr.new_announcement,
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.bodyText1!.apply(color: context.onSurfaceColor),
                  ),
                ],
              ),
            ),
          ),
          settings: (context) => [
            ListTile(
              title: Text(context.tr.new_announcement),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AnnouncementPage(
                      parentArea: Area.of<ContentElement>(module.context)!,
                      onCreate: (id) => module.updateParams(id),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      } else {
        return null;
      }
    }
  }
}
