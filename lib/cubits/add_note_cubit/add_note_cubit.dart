import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_2025/constants.dart';
import 'package:notes_2025/cubits/add_note_cubit/add_note_states.dart';
import 'package:notes_2025/models/notes_model.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(InitailState());

  addNote(NotesModel note) async {
    emit(AddNotesLoadingState());
    try {
      var noteBox = Hive.box<NotesModel>(kNotesBox);
      await noteBox.add(note);
      emit(AddNotesSuccessState());
    } catch (e) {
      emit(AddNotesFailureState(errMessage: e.toString()));
    }
  }
}
