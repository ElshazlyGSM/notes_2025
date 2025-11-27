import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/models/notes_model.dart';
import 'package:notes_2025/views/edit_note_view.dart';

class CustomNote extends StatelessWidget {
  const CustomNote({super.key, required this.note});
  final NotesModel note;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (conext) {
              return EditNoteView(note: note);
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        decoration: BoxDecoration(
          color: Color(note.color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  note.title,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Text(
                note.subTitle,
                style: TextStyle(fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () {
                  note.delete();
                  BlocProvider.of<GetNoteCubit>(context).getNote();
                },
                icon: Icon(Icons.delete, size: 28),
              ),
            ),
            Text(note.date),
            Text(
              note.dateEdit != null ? 'Edit: ${note.dateEdit}' : '',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
