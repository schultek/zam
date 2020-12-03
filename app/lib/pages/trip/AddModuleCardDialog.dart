import 'package:flutter/material.dart';
import 'package:jufa/general/module/Module.dart';

class AddModuleCardDialog extends StatefulWidget {
  final List<ModuleCard> cards;

  AddModuleCardDialog(this.cards);

  @override
  _AddModuleCardDialogState createState() => _AddModuleCardDialogState();

  static Future<ModuleCard> open(BuildContext context, List<ModuleCard> cards) {
    return showDialog<ModuleCard>(context: context, builder: (context) => AddModuleCardDialog(cards));
  }
}

class _AddModuleCardDialogState extends State<AddModuleCardDialog> {
  void closeDialog(ModuleCard card) {
    Navigator.of(context).pop(card);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actionsPadding: EdgeInsets.only(right: 10),
      title: Text("Select Module"),
      content: Container(
        height: 500,
        width: 300,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.cards.length,
            itemBuilder: (context, index) {
              var card = widget.cards[index];
              var child = GestureDetector(
                child: AbsorbPointer(
                  child: card,
                ),
                onTap: () {
                  closeDialog(card);
                },
              );
              return Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                      width: 300, child: card.size == CardSize.Wide
                      ? child
                      : Align(alignment: Alignment.center, child: Container(width: 140, child: child)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Abbrechen", style: TextStyle(color: Colors.black54)),
          onPressed: () => closeDialog(null),
        )
      ],
    );
  }
}
