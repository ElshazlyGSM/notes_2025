import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:notes_2025/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:notes_2025/cubits/add_note_cubit/add_note_states.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/models/notes_model.dart';
import 'package:notes_2025/widgets/colors_list.dart';
import 'package:notes_2025/widgets/custom_buttom.dart';
import 'package:notes_2025/widgets/custom_text_form_field.dart';

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({super.key});

  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? title, subTitle;
  Color selectedColor = Color(0xFF2A9D8F);
  String formattedDate = DateFormat(
    'dd/MM/yyyy – hh:mm a',
  ).format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),

          // معاينة اللون المختار
          Row(
            children: [
              Text(
                'Selected Color:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              CircleAvatar(backgroundColor: selectedColor, radius: 12),
            ],
          ),

          SizedBox(height: 20),

          CustomTextField(
            hintText: 'title',
            onSaved: (value) {
              title = value;
            },
          ),
          SizedBox(height: 15),
          CustomTextField(
            hintText: 'subtitle',
            maxLines: 5,
            onSaved: (value) {
              subTitle = value;
            },
          ),
          SizedBox(height: 20),

          // قائمة الألوان
          ColorsList(
            onColorSelected: (color) {
              setState(() {
                selectedColor = color;
              });
            },
          ),

          SizedBox(height: 20),

          BlocBuilder<AddNoteCubit, AddNoteState>(
            builder: (context, state) {
              return CustomButtom(
                isLoading: state is AddNotesLoadingState,
                text: 'add',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    var noteModel = NotesModel(
                      title: title!,
                      subTitle: subTitle!,
                      date: formattedDate,
                      color: selectedColor.toARGB32(),
                    );
                    BlocProvider.of<AddNoteCubit>(context).addNote(noteModel);
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                      BlocProvider.of<GetNoteCubit>(context).getNote();
                    });
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
