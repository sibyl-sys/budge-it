import 'package:flutter/material.dart';
import 'package:money_tracker/services/transaction.dart';

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
    // TODO: implement initState
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
          height: 400,
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
