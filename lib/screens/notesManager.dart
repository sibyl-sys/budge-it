import 'package:flutter/material.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/widgets/importanceToggleButton.dart';

class NotesManager extends StatefulWidget {
  final String notes;
  final TransactionImportance importance;
  const NotesManager(
      {super.key, required this.notes, required this.importance});

  @override
  State<NotesManager> createState() => _NotesManagerState();
}

class _NotesManagerState extends State<NotesManager> {
  final TextEditingController notesController = TextEditingController();
  late TransactionImportance importance;

  @override
  void initState() {
    importance = widget.importance;
    notesController.text = widget.notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 350,
          height: 275,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(children: [
            Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 2.0))),
                child: Center(
                    child: Text("Add Notes",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        )))),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: TextField(
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xFF4F4F4F)),
                controller: notesController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  alignLabelWithHint: true,
                  hintText: "Notes...",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: const Color(0xFFBDBDBD)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              color: Color(0xFFFBFBFB),
              height: 100,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Importance",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFB6B6B6),
                            fontSize: 12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImportanceToggleButton(
                            selected: importance == TransactionImportance.need,
                            onChange: () {
                              setState(() {
                                importance = TransactionImportance.need;
                              });
                            },
                            text: "Need",
                            icon: Icons.favorite,
                            color: Color(0xFF5F5C96)),
                        ImportanceToggleButton(
                            selected: importance == TransactionImportance.want,
                            onChange: () {
                              setState(() {
                                importance = TransactionImportance.want;
                              });
                            },
                            text: "Want",
                            icon: Icons.star,
                            color: Color(0xFFFFB800)),
                        ImportanceToggleButton(
                            selected:
                                importance == TransactionImportance.sudden,
                            onChange: () {
                              setState(() {
                                importance = TransactionImportance.sudden;
                              });
                            },
                            text: "Sudden",
                            icon: Icons.priority_high,
                            color: Color(0xFFEF4545))
                      ],
                    )
                  ]),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        "importance": importance,
                        "notes": notesController.text
                      });
                    },
                    child: Text("SAVE",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor)),
                  )
                ])
          ]),
        ),
      ),
    );
  }
}
