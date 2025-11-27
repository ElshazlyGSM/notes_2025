import 'package:flutter/material.dart';
import 'package:notes_2025/widgets/add_note_bottom_sheet.dart';
import 'package:notes_2025/widgets/notes_body.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NotesBody(),
        floatingActionButton: FloatingActionButton(
          // backgroundColor: kPrimaryColor,
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled:
                  true, //  lBottomSheet عشان ال يطلع لفوق لما الكيبورد يظهر
              context: context,
              builder: (context) {
                return AddNoteBottomSheet();
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
