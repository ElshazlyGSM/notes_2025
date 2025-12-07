import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:intl/intl.dart';
import 'package:notes_2025/cubits/get_note_cubit/get_note_cubit.dart';
import 'package:notes_2025/models/notes_model.dart';
import 'package:notes_2025/widgets/colors_list.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({super.key, required this.note});
  final NotesModel note;

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late QuillController _quillController;
  late ScrollController _scrollController;
  late FocusNode _focusNode;
  Color selectedColor = const Color(0xFF2A9D8F);
  bool showToolbar = false;

  String formattedDate = DateFormat(
    'dd/MM/yyyy – hh:mm a',
  ).format(DateTime.now());

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    selectedColor = Color(widget.note.color);
    _scrollController = ScrollController();
    _focusNode = FocusNode();

    // Load Quill document from saved JSON
    if (widget.note.subTitleJson.isNotEmpty) {
      try {
        final jsonData = jsonDecode(widget.note.subTitleJson);
        var myDelta = Delta.fromJson(jsonData);
        _quillController = QuillController(
          document: Document.fromDelta(myDelta),
          selection: const TextSelection.collapsed(offset: 0),
        );

        // Force rebuild to ensure images are loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
          }
        });
      } catch (e) {
        debugPrint('Error loading note: $e');
        _quillController = QuillController.basic();
      }
    } else {
      _quillController = QuillController.basic();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    _quillController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void saveNote() {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    widget.note.title = titleController.text;
    widget.note.subTitleJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );
    widget.note.dateEdit = formattedDate;
    widget.note.color = selectedColor.toARGB32();

    widget.note.save();
    BlocProvider.of<GetNoteCubit>(context).getNote();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: saveNote,
            icon: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),

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
                  selectedColor: selectedColor,
                  onColorSelected: (color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Title Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      titleController.text = value!;
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Toolbar Toggle Button
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        showToolbar = !showToolbar;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Edit Tools',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            showToolbar ? Icons.expand_less : Icons.expand_more,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Toolbar (قابلة للإظهار والإخفاء)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: showToolbar
                      ? Container(
                          constraints: const BoxConstraints(maxHeight: 100),
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border(
                              top: BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: 0.2),
                              ),
                              bottom: BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: QuillSimpleToolbar(
                              controller: _quillController,
                              config: QuillSimpleToolbarConfig(
                                showFontFamily: false,
                                showStrikeThrough: false,
                                showSubscript: false,
                                showColorButton: true,
                                showBackgroundColorButton: false,
                                showAlignmentButtons: true,
                                showInlineCode: false,
                                showCodeBlock: true,
                                showQuote: false,
                                showLink: true,
                                showClearFormat: false,
                                showClipboardPaste: true,
                                embedButtons: FlutterQuillEmbeds.toolbarButtons(
                                  imageButtonOptions:
                                      const QuillToolbarImageButtonOptions(),
                                  videoButtonOptions: null,
                                  cameraButtonOptions: null,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                const SizedBox(height: 16),

                // Editor with Container and Border
                Container(
                  height: 300,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: QuillEditor(
                    controller: _quillController,
                    scrollController: _scrollController,
                    focusNode: _focusNode,
                    config: QuillEditorConfig(
                      padding: const EdgeInsets.all(12),
                      placeholder: 'Start writing your note...',
                      autoFocus: false,
                      expands: false,
                      scrollable: true,
                      embedBuilders: FlutterQuillEmbeds.editorBuilders(),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
