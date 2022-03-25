part of 'swipe_template.dart';

@MappableClass(discriminatorValue: 'swipe')
class SwipeTemplateModel extends TemplateModel {
  final SwipeTemplatePage mainPage;
  final SwipeTemplatePage? leftPage;
  final SwipeTemplatePage? rightPage;

  const SwipeTemplateModel({
    String? type,
    this.mainPage = const SwipeTemplatePage(layout: GridLayoutModel()),
    this.leftPage,
    this.rightPage,
  });

  @override
  String get name => 'Swipe Template';

  @override
  WidgetTemplate<TemplateModel> builder() => SwipeTemplate(this);

  @override
  Widget preview() => Row(
        children: [
          if (leftPage != null) leftPage!.layout.preview().apply(scale: 0.8),
          mainPage.layout.preview(
            header: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(child: PreviewCard(width: 40, height: 10)),
            ),
          ),
          if (rightPage != null) rightPage!.layout.preview().apply(scale: 0.8),
        ],
      );
}
