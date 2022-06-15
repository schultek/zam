part of split_module;

class NewPaymentActionElement with ElementBuilderMixin<ActionElement> {
  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.payment,
      text: module.context.tr.new_payment.replaceAll(' ', '\n'),
      onTap: (BuildContext context) async {
        var logic = context.read(splitLogicProvider);
        var result =
            await Navigator.of(context).push<PaymentEntry>(ModulePageRoute(context, child: const EditPaymentPage()));
        if (result != null) {
          logic.updateEntry(result);
        }
      },
    );
  }
}
