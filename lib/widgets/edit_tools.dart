import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class EditToolsContainer extends StatelessWidget {
  const EditToolsContainer({super.key, required this.showToolbar, this.onTap});

  final bool showToolbar;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.edit, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Edit Tools',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
    );
  }
}

class AnimatedEditTools extends StatelessWidget {
  const AnimatedEditTools({
    super.key,
    required this.showToolbar,
    required QuillController quillController,
  }) : _quillController = quillController;

  final bool showToolbar;
  final QuillController _quillController;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 1000),
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
              child: ListOfEditTools(quillController: _quillController),
            )
          : const SizedBox.shrink(),
    );
  }
}

class ListOfEditTools extends StatelessWidget {
  const ListOfEditTools({super.key, required QuillController quillController})
    : _quillController = quillController;

  final QuillController _quillController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            imageButtonOptions: const QuillToolbarImageButtonOptions(),
            videoButtonOptions: null,
            cameraButtonOptions: null,
          ),
        ),
      ),
    );
  }
}

class QuillEditorContainer extends StatelessWidget {
  const QuillEditorContainer({
    super.key,
    required QuillController quillController,
    required ScrollController scrollController,
    required FocusNode focusNode,
  }) : _quillController = quillController,
       _scrollController = scrollController,
       _focusNode = focusNode;

  final QuillController _quillController;
  final ScrollController _scrollController;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
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
    );
  }
}
