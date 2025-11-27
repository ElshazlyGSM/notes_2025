import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/models/notes_model.dart';
import 'package:notes_2025/widgets/colors_list.dart';
import 'package:notes_2025/widgets/custom_appbar.dart';
import 'package:notes_2025/widgets/custom_text_form_field.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({super.key, required this.note});
  final NotesModel note;

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  late TextEditingController titleController;
  late TextEditingController subTitleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    subTitleController = TextEditingController(text: widget.note.subTitle);
  }

  @override
  void dispose() {
    titleController.dispose();
    subTitleController.dispose();
    super.dispose();
  }

  void saveNote() {
    widget.note.title = titleController.text;
    widget.note.subTitle = subTitleController.text;
    widget.note.dateEdit = formattedDate;

    widget.note.save();

    BlocProvider.of<GetNoteCubit>(context).getNote();
    Navigator.pop(context);
  }

  String formattedDate = DateFormat(
    'dd/MM/yyyy – hh:mm a',
  ).format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CustomAppbar(
                text: 'Edit',
                icon: Icons.check,
                onPressed: () {
                  saveNote();
                },
              ),
              SizedBox(height: 30),
              ColorsList(
                selectedColor: Color(widget.note.color),
                onColorSelected: (Color color) {
                  setState(() {
                    widget.note.color = color.toARGB32();
                  });
                },
              ),
              CustomTextField(
                controller: titleController,
                // labelText: 'title',
                onChanged: (value) {
                  widget.note.title = value;
                },
              ),
              SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: CustomTextField(
                    controller: subTitleController,
                    hintText: 'subTitle',
                    minLines: 5,
                    maxLines: 50,
                    onChanged: (value) {
                      widget.note.subTitle = value;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
