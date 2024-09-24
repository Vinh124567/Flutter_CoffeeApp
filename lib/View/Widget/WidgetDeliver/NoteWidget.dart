import 'package:flutter/material.dart';

class NoteWidget extends StatelessWidget {
  final String note;
  final TextEditingController noteController;
  final Function onSaveNote;

  const NoteWidget({
    Key? key,
    required this.note,
    required this.noteController,
    required this.onSaveNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            // Nếu note đã có nội dung, hiển thị lại nội dung này
            noteController.text = note.isNotEmpty ? note : '';
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'Thêm Ghi Chú',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: TextField(
                controller: noteController,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Cà phê và Ghi chú',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onSaveNote();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        height: 25,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note_outlined, size: 20, color: Colors.black),
            SizedBox(width: 5),
            Text("Note", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
