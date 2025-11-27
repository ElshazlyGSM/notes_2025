import 'package:flutter/material.dart';
import 'package:notes_2025/models/notes_model.dart';
import 'package:notes_2025/views/edit_note_view.dart';

class NotesSearchDelegate extends SearchDelegate {
  final List<NotesModel> notes; // قائمة النوتات للبحث فيها

  NotesSearchDelegate({this.notes = const []});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // إغلاق البحث
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = notes
        .where(
          (note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.subTitle.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];
        return ListTile(
          title: Text(maxLines: 1, overflow: TextOverflow.ellipsis, note.title),
          subtitle: Text(
            note.subTitle.length > 50
                ? '${note.subTitle.substring(0, 50)}...'
                : note.subTitle,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            close(context, note);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditNoteView(note: note)),
            ); // ممكن تفتح صفحة التعديل للنوت
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = notes
        .where(
          (note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.subTitle.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final note = suggestions[index];
        return ListTile(
          title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            note.subTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            query = note.title;
            showResults(context);
          },
        );
      },
    );
  }
}
