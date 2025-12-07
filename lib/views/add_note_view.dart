import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:notes_2025/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:notes_2025/cubits/add_note_cubit/add_note_states.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/models/notes_model.dart';
import 'package:notes_2025/widgets/colors_list.dart';
import 'package:notes_2025/widgets/custom_buttom.dart';
import 'package:notes_2025/widgets/custom_text_form_field.dart';
import 'package:notes_2025/widgets/edit_tools.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  String? title;
  Color selectedColor = const Color(0xFF2A9D8F);
  late QuillController _quillController;
  late ScrollController _scrollController;
  late FocusNode _focusNode;
  bool showToolbar = false;

  String formattedDate = DateFormat(
    'dd/MM/yyyy – hh:mm a',
  ).format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _quillController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNoteCubit(),
      child: BlocConsumer<AddNoteCubit, AddNoteState>(
        listener: (context, state) {
          if (state is AddNotesFailureState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errMessage)));
          }
          if (state is AddNotesSuccessState) {
            BlocProvider.of<GetNoteCubit>(context).getNote();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(title: const Text("Add Note"), elevation: 0),
            body: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTextField(
                        hintText: 'Title',
                        onSaved: (value) => title = value,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Toolbar Toggle Button
                    EditToolsContainer(
                      showToolbar: showToolbar,
                      onTap: () {
                        setState(() {
                          showToolbar = !showToolbar;
                        });
                      },
                    ),

                    // Toolbar (قابلة للإظهار والإخفاء)
                    AnimatedEditTools(
                      showToolbar: showToolbar,
                      quillController: _quillController,
                    ),

                    const SizedBox(height: 16),

                    // Editor with Container and Border
                    QuillEditorContainer(
                      quillController: _quillController,
                      scrollController: _scrollController,
                      focusNode: _focusNode,
                    ),

                    const SizedBox(height: 20),

                    // Color selection
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Color',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ColorsList(
                      onColorSelected: (color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // Save button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomButtom(
                        isLoading: state is AddNotesLoadingState,
                        text: 'Save Note',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            String contentJson = jsonEncode(
                              _quillController.document.toDelta().toJson(),
                            );
                            NotesModel noteModel = NotesModel(
                              title: title!,
                              subTitleJson: contentJson,
                              date: formattedDate,
                              color: selectedColor.toARGB32(),
                            );
                            BlocProvider.of<AddNoteCubit>(
                              context,
                            ).addNote(noteModel);
                          } else {
                            setState(() {
                              autovalidateMode = AutovalidateMode.always;
                            });
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
