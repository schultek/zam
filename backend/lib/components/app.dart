import 'package:jaspr/jaspr.dart';

class App extends StatelessComponent {
  final Map<String, dynamic> group;

  const App(this.group);

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield DomComponent(
      tag: 'header',
      children: [
        DomComponent(
          tag: 'img',
          attributes: {'src': group['logoUrl'] as String},
        ),
        DomComponent(
          tag: 'h1',
          child: Text(group['name'] as String),
        ),
      ],
    );

    yield DomComponent(
      tag: 'p',
      child: Text('This is an auto-generated landing page.'),
    );

    var link = group['landingPage']?['link'] as String?;
    if (link != null) {
      yield DomComponent(
        tag: 'a',
        attributes: {'href': link},
        child: Text('Join Now'),
      );
    }
  }
}
