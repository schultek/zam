part of counter_module;

@MappableClass()
class CounterState {
  final int count;
  final String label;

  CounterState(this.count, this.label);
}

class CounterElement with ElementBuilderMixin<ContentElement> {
  @override
  FutureOr<ContentElement?> build(ModuleContext module) {
    var params = module.getParams<CounterState?>() ??
        CounterState(0, module.context.tr.counter);

    return ContentElement(
      module: module,
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                params.label,
                style: context.theme.textTheme.bodyText1!
                    .apply(color: context.onSurfaceColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                params.count.toString(),
                style: context.theme.textTheme.headline3!
                    .apply(color: context.onSurfaceColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      onTap: (context) {
        module.updateParams(params.copyWith(count: params.count + 1));
      },
      settings: (context) => [
        InputListTile(
          label: context.tr.label,
          value: params.label,
          onChanged: (value) {
            module.updateParams(params.copyWith(label: value));
          },
        ),
      ],
    );
  }
}
