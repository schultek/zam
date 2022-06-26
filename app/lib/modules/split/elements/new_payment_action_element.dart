part of split_module;

class NewPaymentActionElement with ElementBuilder<ActionElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.new_payment;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.split_new_payment_action_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.split_new_payment_action_text);
  }

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
