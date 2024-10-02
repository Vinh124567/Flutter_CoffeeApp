import 'package:coffee_shop/ViewModel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../Data/Response/status.dart';
import '../../Model/address_dto.dart';
import '../../ViewModel/address_view_model.dart';
import '../../routes/route_name.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final addressViewModel = Provider.of<AddressViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    // Gọi API để lấy danh sách địa chỉ khi màn hình được xây dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addressViewModel.fetchAddressListApi(authViewModel.user!.uid.toString());
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            title: const Text("Địa chỉ của tôi", style: TextStyle(fontSize: 16)),
            centerTitle: true,
            toolbarHeight: 50,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const ImageIcon(
                AssetImage('assets/images/ic_arrow_left.png'),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Địa chỉ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Consumer<AddressViewModel>(
              builder: (context, addressViewModel, child) {
                switch (addressViewModel.addressList.status) {
                  case Status.LOADING:
                    return const Center(child: CircularProgressIndicator());
                  case Status.ERROR:
                    return Center(
                      child: Text(addressViewModel.addressList.message ?? 'Đã xảy ra lỗi.'),
                    );
                  case Status.COMPLETED:
                    final addressList = addressViewModel.addressList.data?.data;
                    if (addressList == null || addressList.isEmpty) {
                      return const Center(child: Text('Danh sách địa chỉ trống.'));
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: addressList.length,
                        itemBuilder: (context, index) {
                          final address = addressList[index];
                          return InkWell(
                            onTap: () {
                              addressViewModel.setSelectedAddress(address);
                            },
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Radio<Address>(
                                        value: address,
                                        groupValue: addressViewModel.selectedAddress, // Sử dụng selectedAddress làm groupValue
                                        onChanged: (Address? value) {
                                          addressViewModel.setSelectedAddress(value);
                                        },
                                        activeColor: Colors.blue,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Tên: "),
                                                Text(address.name ?? 'Chưa có tên'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text("Số điện thoại: "),
                                                Text(address.phone ?? 'Chưa có số điện thoại'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text("Địa chỉ: "),
                                                Text(address.address ?? 'Chưa có địa chỉ'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            RouteName.newaddress,
                                            arguments: address,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const Gap(16),
                                  const Divider(
                                    indent: 16,
                                    endIndent: 16,
                                    color: Color(0xffE3E3E3),
                                    height: 1,
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            ),
                          );

                        },
                      ),
                    );
                  default:
                    return const Center(child: Text('Đã xảy ra lỗi không xác định.'));
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, RouteName.newaddress);
          if (result == true) {
            addressViewModel.fetchAddressListApi(authViewModel.user!.uid.toString());
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
