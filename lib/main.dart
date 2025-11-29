import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_2025/constants.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/cubits/theme_cubit/theme_cubit.dart';
import 'package:notes_2025/models/notes_model.dart';
import 'package:notes_2025/simple_bloc_observer.dart';
import 'package:notes_2025/views/notes_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تفعيل الـ Status Bar الشفاف
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  await Hive.initFlutter();
  Bloc.observer = SimpleBlocObserver();

  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox<NotesModel>(kNotesBox);
  
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetNoteCubit()..getNote()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            
            // الثيم الفاتح
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark, // أيقونات سوداء
                  statusBarBrightness: Brightness.light,
                ),
              ),
            ),
            
            // الثيم الداكن
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: Color(0xFF1A1A1A),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light, // أيقونات بيضاء
                  statusBarBrightness: Brightness.dark,
                ),
              ),
              cardColor: Color(0xFF2C2C2C),
            ),
            
            home: NotesView(),
          );
        },
      ),
    );
  }
}