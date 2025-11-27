import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:notes_2025/constants.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/models/notes_model.dart';
import 'package:notes_2025/simple_bloc_observer.dart';
import 'package:notes_2025/views/notes_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Bloc.observer = SimpleBlocObserver();

  Hive.registerAdapter(NotesModelAdapter());
  // await Hive.deleteBoxFromDisk(kNotesBox);
  await Hive.openBox<NotesModel>(kNotesBox);
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetNoteCubit()..getNote(),
      child: MaterialApp(
        theme: ThemeData(brightness: Brightness.light),

        debugShowCheckedModeBanner: false,
        home: NotesView(),
      ),
    );
  }
}
