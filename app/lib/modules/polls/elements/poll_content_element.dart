part of polls_module;

class PollContentElement with ElementBuilder<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    if (module.hasParams) {
      var pollId = module.getParams<String>();
      return ContentElement(
        module: module,
        builder: (context) => SimpleCard(
          title: '${context.tr.poll}\n$pollId',
          icon: Icons.add_reaction,
        ),
      );
    } else {
      if (!module.context.read(isOrganizerProvider)) {
        return null;
      }
      return ContentElement(
        module: module,
        builder: (context) => SimpleCard(
          title: context.tr.new_poll_create,
          icon: Icons.add,
        ),
        settings: DialogElementSettings(
            builder: (context) => [
                  ListTile(
                    title: Text(context.tr.new_poll_create),
                    onTap: () async {
                      var pollId = await Navigator.of(context).push(CreatePollPage.route());
                      if (pollId != null) {
                        module.updateParams(pollId);
                      }
                    },
                  ),
                ]),
      );
    }
  }
}
