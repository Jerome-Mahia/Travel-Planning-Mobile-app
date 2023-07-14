import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class NoteEditingScreen extends StatefulWidget {
  const NoteEditingScreen({super.key});

  @override
  State<NoteEditingScreen> createState() => _NoteEditingScreenState();
}

class _NoteEditingScreenState extends State<NoteEditingScreen> {
  QuillController _controller = QuillController.basic();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure you want to exit the Notes editor?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No',
                    style: TextStyle(color: Colors.red, fontSize: 18)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Yes',
                    style: TextStyle(color: Colors.green, fontSize: 18)),
              ),
            ],
          ),
        );
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Note Editing Screen'),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {
                  var json = jsonEncode(_controller.document.toPlainText());
                  Navigator.pop(context, json);
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                QuillToolbar.basic(controller: _controller),
                Expanded(
                  child: Container(
                    child: QuillEditor.basic(
                      controller: _controller,
                      readOnly: false, // true for view only mode
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
