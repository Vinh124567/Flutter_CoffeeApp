import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Model/address_dto.dart';
import '../../../ViewModel/address_view_model.dart';
import '../../../routes/route_name.dart';
import '../../StateDeliverScreen/note_provider.dart';

class AddressSection extends StatelessWidget {
  const AddressSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final addressProvider = Provider.of<AddressViewModel>(context);
    Address? address=addressProvider.selectedAddress;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Deliver Address",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          const Text(
            "Customer's address",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          address == null
              ? const Text(
            "No address selected",
            style: TextStyle(fontSize: 16, color: Colors.red),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${addressProvider!.selectedAddress?.name.toString() ?? 'Unknown'}",
                  style: const TextStyle(fontSize: 16)),
              Text("Phone: ${addressProvider.selectedAddress?.phone ?? 'Unknown'}",
                  style: const TextStyle(fontSize: 16)),
              Text("Address: ${addressProvider.selectedAddress?.address! ?? 'Unknown'}",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.edit,
                  label: "Edit address",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteName.address,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.event_note_outlined,
                  label: "Note",
                  onTap: () {
                    // Điều hướng đến màn hình ghi chú và truyền ghi chú hiện tại
                    Navigator.pushNamed(
                      context,
                      RouteName.note,
                      arguments: noteProvider.note, // Truyền ghi chú hiện tại
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffC67C4E)),
          color: Color(0xffF9F2ED),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Color(0xff242424)),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(color: Color(0xff242424))),
          ],
        ),
      ),
    );
  }
}
