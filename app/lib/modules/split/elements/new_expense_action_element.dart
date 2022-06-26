part of split_module;

class NewExpenseActionElement with ElementBuilder<ActionElement> {
  @override
  String getTitle(BuildContext context) {
    return context.tr.new_expense;
  }

  @override
  String getSubtitle(BuildContext context) {
    return context.tr.split_new_expense_action_subtitle;
  }

  @override
  Widget buildDescription(BuildContext context) {
    return Text(context.tr.split_new_expense_action_text);
  }

  @override
  FutureOr<ActionElement?> build(ModuleContext module) {
    return ActionElement(
      module: module,
      icon: Icons.shopping_basket,
      text: module.context.tr.new_expense.replaceAll(' ', '\n'),
      onTap: (BuildContext context) async {
        var logic = context.read(splitLogicProvider);
        var result =
            await Navigator.of(context).push<ExpenseEntry>(ModulePageRoute(context, child: const EditExpensePage()));
        if (result != null) {
          logic.updateEntry(result);
        }
      },
    );
  }
}
