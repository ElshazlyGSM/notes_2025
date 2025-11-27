import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_2025/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:notes_2025/cubits/add_note_cubit/add_note_states.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/widgets/add_note_form.dart';

class AddNoteBottomSheet extends StatelessWidget {
  const AddNoteBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNoteCubit(),
      child: BlocConsumer<AddNoteCubit, AddNoteState>(
        listener: (context, state) {
          if (state is AddNotesFailureState) {
            log('Falild >>> ${state.errMessage}');
          }
          if (state is AddNotesSuccessState) {
            BlocProvider.of<GetNoteCubit>(context).getNote();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return AbsorbPointer(
            absorbing: state is AddNotesLoadingState,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const SingleChildScrollView(child: AddNoteForm()),
            ),
          );
        },
      ),
    );
  }
}
