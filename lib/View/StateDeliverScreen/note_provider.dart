import 'package:flutter/material.dart';

class NoteProvider with ChangeNotifier {
  String _note = '';

  String get note => _note;

  void updateNote(String text) {
    _note = text;
    notifyListeners();
  }
}
