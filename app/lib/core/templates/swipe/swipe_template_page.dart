part of 'swipe_template.dart';

enum SwipePageLocation { left, main, right }

@MappableClass(discriminatorValue: 'swipe')
class SwipeTemplatePage extends TemplatePage {
  const SwipeTemplatePage({required this.layout});

  final LayoutModel layout;

  List<Widget> getSettings(
    SwipeTemplateModel model,
    void Function(SwipeTemplatePage?) update,
    void Function(int) changePage,
  ) {
    var page = [model.leftPage, model.mainPage, model.rightPage].indexOf(this);
    var isMain = this == model.mainPage;
    return [
      PageSettingsHeader(page: page, changePage: changePage),
      Builder(builder: (context) {
        return SettingsSection(
          title: context.tr.layout,
          margin: EdgeInsets.zero,
          children: [
            Builder(builder: (context) {
              return ListTile(
                title: Text(layout.name),
                subtitle: Text(context.tr.tap_to_change),
                trailing: isMain
                    ? null
                    : IconButton(
                        icon: Icon(Icons.delete, color: context.theme.colorScheme.error),
                        onPressed: () {
                          update(null);
                        },
                      ),
                onTap: () async {
                  var newLayout = await LayoutPreviewSwitcher.show(
                    context,
                    layout,
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(child: PreviewCard(width: 40, height: 10)),
                    ),
                  );
                  if (newLayout != null) {
                    update(copyWith(layout: newLayout));
                  }
                },
              );
            }),
            ...layout.settings(context, (newLayout) => update(copyWith(layout: newLayout))),
          ],
        );
      }),
    ];
  }

  static List<Widget> getEmptyPageSettings(
    int page,
    void Function(SwipeTemplatePage) update,
    void Function(int) changePage,
  ) {
    return [
      PageSettingsHeader(page: page, empty: true, changePage: changePage),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Builder(builder: (context) {
          return OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add),
            label: Text(context.tr.add_page),
            onPressed: () {
              update(const SwipeTemplatePage(layout: FullPageLayoutModel()));
            },
          );
        }),
      ),
    ];
  }
}

class PageSettingsHeader extends StatelessWidget {
  const PageSettingsHeader({required this.page, required this.changePage, this.empty = false, Key? key})
      : super(key: key);

  final int page;
  final bool empty;
  final void Function(int) changePage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: page == 0
                ? null
                : IconButton(
                    icon: const Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      changePage(-1);
                    },
                  ),
          ),
          Expanded(
            child: empty
                ? Container()
                : Text(
                    page == 0
                        ? context.tr.left_page
                        : page == 1
                            ? context.tr.main_page
                            : context.tr.right_page,
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headline6,
                  ),
          ),
          SizedBox(
            width: 50,
            child: page == 2
                ? null
                : IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right),
                    onPressed: () {
                      changePage(1);
                    },
                  ),
          )
        ],
      ),
    );
  }
}
