class AddNoteState {}

class InitailState extends AddNoteState {}

class AddNotesLoadingState extends AddNoteState {}

class AddNotesSuccessState extends AddNoteState {}

class AddNotesFailureState extends AddNoteState {
  final String errMessage;

  AddNotesFailureState({required this.errMessage});
}
