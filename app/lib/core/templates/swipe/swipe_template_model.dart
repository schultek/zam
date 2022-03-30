part of 'swipe_template.dart';

@MappableClass(discriminatorValue: 'swipe')
class SwipeTemplateModel extends TemplateModel {
  final SwipeTemplatePage mainPage;
  final SwipeTemplatePage? leftPage;
  final SwipeTemplatePage? rightPage;

  const SwipeTemplateModel({
    this.mainPage = const SwipeTemplatePage(layout: GridLayoutModel()),
    this.leftPage,
    this.rightPage,
  });

  @override
  String get name => 'Swipe Template';

  @override
  Template<TemplateModel> builder() => SwipeTemplate(this);

  @override
  Widget preview() => Row(
        children: [
          const FullPageLayoutModel().preview().apply(scale: 0.8),
          const GridLayoutModel().preview(
            header: MainGroupHeader.preview(),
          ),
          const FullPageLayoutModel().preview().apply(scale: 0.8),
        ],
      );
}
