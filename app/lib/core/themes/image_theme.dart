part of themes;

class ImageTheme extends ThemeState {
  final ui.Image image;
  final ImageProvider provider;

  PaletteGenerator palette;
  List<PaletteColor> belowColors;

  ImageTheme({
    required this.image,
    required this.provider,
    required this.palette,
    List<PaletteColor>? colors,
  }) : belowColors = colors ?? [palette.dominantColor!];

  @override
  ImageTheme computeFillColor(
      {required BuildContext context, ColorPreference? preference, bool matchTextColor = false}) {
    if (belowColors.isEmpty) {
      var theme = ImageTheme(
        image: image,
        provider: provider,
        palette: palette,
        colors: [palette.dominantColor!],
      );
      theme.loadContextFillColor(context, preference: preference);
      return theme;
    } else {
      var colors = [...belowColors];

      if (colors.last == palette.dominantColor) {
        colors.add(palette.lightMutedColor!);
      } else {
        colors.add(palette.dominantColor!);
      }

      return ImageTheme(
        image: image,
        provider: provider,
        palette: palette,
        colors: colors,
      );
    }
  }

  void loadContextFillColor(BuildContext context, {ColorPreference? preference}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      RenderBox renderBox = context.findRenderObject()! as RenderBox;
      var position = renderBox.localToGlobal(Offset.zero);
      var rect = position & renderBox.size;
      palette = await PaletteGenerator.fromImage(image, region: rect, maximumColorCount: 1);

      belowColors = [palette.dominantColor!];
      notifyListeners();
    });
  }

  @override
  Color computeTextColor({ColorPreference? preference}) {
    return currentPaletteColor.bodyTextColor;
  }

  @override
  Widget getBackgroundWidget(BuildContext context, Widget child) {
    return InheritedThemeState(
      theme: ImageTheme(
        image: image,
        provider: provider,
        palette: palette,
        colors: [],
      ),
      child: Stack(children: [
        Positioned.fill(
          child: Image(
            image: provider,
            fit: BoxFit.cover,
          ),
        ),
        child,
      ]),
    );
  }

  @override
  Color get baseColor => palette.dominantColor!.color;

  PaletteColor get currentPaletteColor => belowColors.isNotEmpty ? belowColors.last : palette.dominantColor!;

  @override
  Color get currentFillColor => currentPaletteColor.color;

  static Future<ImageTheme> load() async {
    var url =
        'https://images.pexels.com/photos/1666021/pexels-photo-1666021.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940';

    Completer<ImageInfo> completer = Completer();
    var img = NetworkImage(url);
    img.resolve(ImageConfiguration.empty).addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;

    var paletteGenerator = await PaletteGenerator.fromImage(
      imageInfo.image,
      filters: [],
    );

    return ImageTheme(
      image: imageInfo.image,
      provider: img,
      palette: paletteGenerator,
    );
  }

  @override
  ImageTheme copy() => ImageTheme(image: image, provider: provider, palette: palette, colors: [...belowColors]);
}
