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
        settings: (context) => [
          ListTile(
            title: Text(context.tr.resend_notification),
            subtitle: Text(context.tr.resend_notification_desc),
            onTap: () async {
              var send = await SettingsDialog.confirm(context, context.tr.confirm_resend);
              if (send) {
                await context.read(announcementLogicProvider).resendNotification(announcementId);
              }
            },
          ),
        ],
      );
    } else {
      if (module.context.read(isOrganizerProvider)) {
        return ContentElement(
          module: module,
          size: ElementSize.wide,
          builder: (context) => AspectRatio(
            aspectRatio: 2.1,
            child: NeedsSetupCard(
              title: context.tr.new_announcement,
              icon: Icons.add_comment,
            ),
          ),
          settingsAction: (context) async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AnnouncementPage(
                  parentArea: Area.of<ContentElement>(module.context)!,
                  onCreate: (id) => module.updateParams(id),
                ),
              ),
            );
          },
        );
      } else {
        return null;
      }
    }
  }
}
