import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../theme_context.dart';

const double _kWidthOfScrollItem = 67.2;

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({Key? key, required this.schemeIndex, required this.onChange}) : super(key: key);

  final int schemeIndex;
  final Function(int) onChange;

  @override
  _ThemeSelectorState createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  late ScrollController scrollController;
  late int schemeIndex;

  @override
  void initState() {
    super.initState();
    schemeIndex = widget.schemeIndex;
    scrollController =
        ScrollController(keepScrollOffset: true, initialScrollOffset: _kWidthOfScrollItem * schemeIndex - 5);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ThemeSelector oldWidget) {
    if (widget.schemeIndex != schemeIndex) {
      schemeIndex = widget.schemeIndex;
      scrollController.animateTo(_kWidthOfScrollItem * schemeIndex,
          duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLight = context.theme.brightness == Brightness.light;
    return SizedBox(
      height: 76,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: FlexColor.schemesList.length,
              itemBuilder: (BuildContext context, int index) {
                return FlexThemeModeOptionButton(
                  optionButtonBorderRadius: 12,
                  height: 30,
                  width: 30,
                  padding: const EdgeInsets.all(0.3),
                  optionButtonMargin: EdgeInsets.zero,
                  borderRadius: 0,
                  unselectedBorder: BorderSide.none,
                  selectedBorder: BorderSide(
                    color: context.theme.primaryColorLight,
                    width: 4,
                  ),
                  onSelect: () {
                    scrollController.animateTo(_kWidthOfScrollItem * index,
                        duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
                    schemeIndex = index;
                    widget.onChange(index);
                  },
                  selected: schemeIndex == index,
                  backgroundColor: context.theme.colorScheme.surface,
                  flexSchemeColor: isLight ? FlexColor.schemesList[index].light : FlexColor.schemesList[index].dark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
