import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop/Model/address_dto.dart';
import 'package:coffee_shop/ViewModel/address_view_model.dart';
import '../../Data/Response/status.dart';
import '../../ViewModel/auth_view_model.dart';

class EditAddressScreen extends StatefulWidget {
  final Address address;
  const EditAddressScreen({super.key, required this.address});

  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa địa chỉ'),
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
                  decoration: const InputDecoration(labelText: 'Tên khách hàng'), // Thêm trường 'name'
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Địa chỉ'),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Điện thoại'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final address = Address(
                        id: widget.address.id, // id sẽ được gán từ backend
                        address: _addressController.text,
                        phone: _phoneController.text,
                        name: _nameController.text,
                        userId:authViewModel.user?.uid.toString()// Thêm 'name'
                    );
                    viewModel.updateAddress(
                      address, // Truyền dữ liệu Address vào data
                    ).then((_) {
                      if (viewModel.updateAddressResponse.status == Status.COMPLETED) {
                        Navigator.pop(context, true); // Truyền dữ liệu `true` để thông báo rằng đã thêm địa chỉ thành công
                      }
                    }).catchError((error) {
                      print('Lỗi khi sửa địa chỉ: $error');
                    });
                  },
                  child: const Text('Sửa địa chỉ'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
