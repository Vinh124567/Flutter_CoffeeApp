import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop/Model/address_dto.dart';
import 'package:coffee_shop/ViewModel/address_view_model.dart';
import '../../Data/Response/status.dart';
import '../../ViewModel/auth_view_model.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController(); // Thêm trường 'name'

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: Consumer<AddressViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'), // Thêm trường 'name'
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final address = Address(
                      id: null, // id sẽ được gán từ backend
                      address: _addressController.text,
                      phone: _phoneController.text,
                      name: _nameController.text,
                      userId:authViewModel.user?.uid.toString()// Thêm 'name'
                    );
                    viewModel.addAddressApi(
                      address, // Truyền dữ liệu Address vào data
                    ).then((_) {
                      // Khi API gọi xong và có trạng thái `COMPLETED`, quay lại màn hình trước đó
                      if (viewModel.createAddressResponse.status == Status.COMPLETED) {
                        Navigator.pop(context, true); // Truyền dữ liệu `true` để thông báo rằng đã thêm địa chỉ thành công
                      }
                    }).catchError((error) {
                      // Xử lý lỗi nếu cần thiết
                      print('Error adding address: $error');
                    });
                  },
                  child: const Text('Add Address'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
