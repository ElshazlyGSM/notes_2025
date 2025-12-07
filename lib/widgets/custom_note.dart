import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/models/notes_model.dart';
import 'package:notes_2025/views/edit_note_view.dart';

class CustomNote extends StatelessWidget {
  const CustomNote({super.key, required this.note});
  final NotesModel note;

  // دالة لحساب إذا كان اللون فاتح أو غامق
  bool _isLightColor(Color color) {
    // حساب الـ luminance (السطوع)
    return color.computeLuminance() > 0.5;
  }

  String getPlainText(String deltaJson) {
    try {
      final delta = Delta.fromJson(jsonDecode(deltaJson));
      final doc = Document.fromDelta(delta);
      return doc.toPlainText().trim(); // دي بترجع النص العادي بدون أي تنسيق
    } catch (e) {
      return deltaJson; // لو فشل في التحويل يرجع النص الأصلي
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteColor = Color(note.color);
    // اختيار لون النص بناءً على لون الخلفية
    final textColor = _isLightColor(noteColor) ? Colors.black : Colors.white;
    final subtitleColor = _isLightColor(noteColor)
        ? Colors.black87
        : Colors.white70;
    final dateColor = _isLightColor(noteColor)
        ? Colors.grey.shade700
        : Colors.grey.shade300;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EditNoteView(note: note);
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        decoration: BoxDecoration(
          color: noteColor,
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
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: textColor, // لون ثابت
                  ),
                ),
              ),
              subtitle: Text(
                getPlainText(note.subTitleJson),
                style: TextStyle(
                  fontSize: 20,
                  color: subtitleColor, // لون ثابت
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                onPressed: () {
                  note.delete();
                  BlocProvider.of<GetNoteCubit>(context).getNote();
                },
                icon: Icon(
                  Icons.delete,
                  size: 28,
                  color: textColor, // لون ثابت
                ),
              ),
            ),
            Text(
              note.date,
              style: TextStyle(color: dateColor), // لون ثابت
            ),
            Text(
              note.dateEdit != null ? 'Edit: ${note.dateEdit}' : '',
              style: TextStyle(color: dateColor), // لون ثابت
            ),
          ],
        ),
      ),
    );
  }
}
