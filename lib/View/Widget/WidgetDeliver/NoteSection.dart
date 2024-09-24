import 'package:flutter/material.dart';

class OrderNotesWidget extends StatefulWidget {
  final String initialNote;
  final Function(String) onNoteSaved;

  const OrderNotesWidget({
    Key? key,
    required this.initialNote,
    required this.onNoteSaved,
  }) : super(key: key);

  @override
  _OrderNotesWidgetState createState() => _OrderNotesWidgetState();
}

class _OrderNotesWidgetState extends State<OrderNotesWidget> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.initialNote;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Add Note',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: _noteController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: 'Coffee and Notes',
                          labelStyle: const TextStyle(fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.onNoteSaved(_noteController.text);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
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
                Text("Edit Note", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
