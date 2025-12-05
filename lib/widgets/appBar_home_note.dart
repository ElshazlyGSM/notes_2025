import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/views/theme_settings_view.dart';
import 'package:notes_2025/widgets/font_resize.dart';
import 'package:notes_2025/widgets/notes_search_delegate.dart';

class AppbarHomeNote extends StatelessWidget {
  const AppbarHomeNote({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Notes', style: TextStyle(fontSize: 30)),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: NotesSearchDelegate(
                notes: context.read<GetNoteCubit>().notes ?? [],
              ),
            );
          },
          icon: Icon(Icons.search, size: 30),
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThemeSettingsView()),
            );
          },
        ),
      ],
    );
  }
}
