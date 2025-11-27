import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_2025/constants.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_states.dart';
import 'package:notes_2025/models/notes_model.dart';

class GetNoteCubit extends Cubit<GetNoteState> {
  GetNoteCubit() : super(InitailState());

  List<NotesModel>? notes;
  getNote() async {
    var noteBox = Hive.box<NotesModel>(kNotesBox);
    notes = noteBox.values.toList();
    emit(GetNotesSuccessState());

    log(notes!.length.toString());
  }
}
