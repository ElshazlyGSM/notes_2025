import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_states.dart';
import 'package:notes_2025/models/notes_model.dart';
import 'package:notes_2025/widgets/custom_appbar.dart';
import 'package:notes_2025/widgets/custom_note.dart';
import 'package:notes_2025/widgets/notes_search_delegate.dart';

class NotesBody extends StatelessWidget {
  const NotesBody({super.key});

  @override
  Widget build(BuildContext context) {
    // لاستدعاء الميثود بدل متحول ل ستاتفول
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetNoteCubit>().getNote();
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppbar(
            onPressed: () {
              showSearch(
                context: context,
                delegate: NotesSearchDelegate(
                  notes: context.read<GetNoteCubit>().notes ?? [],
                ),
              );
            },

            text: 'Notes',
            icon: Icons.search,
          ),
          const SizedBox(height: 25),
          Expanded(
            child: BlocBuilder<GetNoteCubit, GetNoteState>(
              builder: (context, state) {
                List<NotesModel> notes =
                    BlocProvider.of<GetNoteCubit>(context).notes ?? [];
                return ListView.builder(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return CustomNote(note: notes[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
