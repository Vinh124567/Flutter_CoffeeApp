// address_section.dart
import 'package:flutter/material.dart';
import '../../../Model/address_dto.dart';
import '../../../routes/route_name.dart';

class AddressSection extends StatelessWidget {
  final Address? selectedAddress;
  final Function(Address?) onAddressSelected;
  final Function(String) onNoteUpdated;
  final String note;
  final TextEditingController noteController;

  const AddressSection({
    Key? key,
    required this.selectedAddress,
    required this.onAddressSelected,
    required this.onNoteUpdated,
    required this.note,
    required this.noteController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Deliver Address",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 13),
        const Text("Customer's address"),
        const SizedBox(height: 10),
        selectedAddress == null
            ? const Text("No address selected")
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${selectedAddress!.name ?? 'Unknown'}"),
            Text("Phone: ${selectedAddress!.phone ?? 'Unknown'}"),
            Text("Address: ${selectedAddress!.address ?? 'Unknown'}"),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    RouteName.address,
                    arguments: selectedAddress,
                  ) as Address?;

                  if (result != null) {
                    onAddressSelected(result);
                  }
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
                      Icon(Icons.edit, size: 20, color: Colors.black),
                      SizedBox(width: 5),
                      Text("Edit address",
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // Gán thông tin cà phê mặc định nếu note chưa có nội dung
                      String initialText = ''; // Bạn có thể điều chỉnh nếu cần

                      // Nếu note đã có nội dung, hiển thị lại nội dung này
                      noteController.text = note.isNotEmpty ? note : initialText;

                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Thêm Ghi Chú',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: noteController,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    labelText: 'Cà phê và Ghi chú',
                                    labelStyle: const TextStyle(fontSize: 14),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(width: 0.5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0xffC67C4E), width: 0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Hủy',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              onNoteUpdated(noteController.text);
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
                      Icon(Icons.event_note_outlined,
                          size: 20, color: Colors.black),
                      SizedBox(width: 5),
                      Text("Note", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
