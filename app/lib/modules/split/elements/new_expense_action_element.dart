part of split_module;

class NewExpenseActionElement with ElementBuilderMixin<ActionElement> {
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
