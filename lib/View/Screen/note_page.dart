import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../StateDeliverScreen/note_provider.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tải ghi chú nếu có từ provider
    final note = Provider.of<NoteProvider>(context, listen: false).note;
    _noteController.text = note; // Điền ghi chú vào trường nhập
  }

  void _saveNote() {
    Provider.of<NoteProvider>(context, listen: false)
        .updateNote(_noteController.text); // Cập nhật ghi chú vào provider

    // Hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ghi chú đã được lưu: ${_noteController.text}')),
    );
    _noteController.clear(); // Xóa trường nhập
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập Ghi Chú'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập ghi chú của bạn ở đây...',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Lưu Ghi Chú'),
            ),
          ],
        ),
      ),
    );
  }
}
