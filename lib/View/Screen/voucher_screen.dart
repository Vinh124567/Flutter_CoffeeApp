
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Model/voucher_dto.dart';
import '../../Data/Response/status.dart';
import '../../ViewModel/voucher_view_model.dart';

class VoucherScreen extends StatefulWidget {
  final List<Voucher> selectedVouchers;

  const VoucherScreen({Key? key, required this.selectedVouchers}) : super(key: key);

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  late List<Voucher> selectedVouchers;

  @override
  void initState() {
    super.initState();
    selectedVouchers = List.from(widget.selectedVouchers); // Sao chép danh sách voucher đã chọn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VoucherViewModel>(context, listen: false).fetchVoucherListApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Vouchers"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, selectedVouchers),
          icon: const ImageIcon(
            AssetImage('assets/images/ic_arrow_left.png'),
          ),
        ),
      ),
      body: Consumer<VoucherViewModel>(
        builder: (context, voucherViewModel, child) {
          List<Voucher> availableVouchers = voucherViewModel.voucherList.data?.data ?? [];

          switch (voucherViewModel.voucherList.status!) {
            case Status.LOADING:
              return const Center(child: CircularProgressIndicator());
            case Status.ERROR:
              return Center(child: Text(voucherViewModel.voucherList.message.toString()));
            case Status.COMPLETED:
              return ListView.builder(
                itemCount: availableVouchers.length,
                itemBuilder: (context, index) {
                  final voucher = availableVouchers[index];
                  final isSelected = selectedVouchers.contains(voucher);

                  return ListTile(
                    title: Text(voucher.code ?? "Unknown Voucher"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(voucher.description ?? "No description"),
                        Text("Discount: ${voucher.discount?.toStringAsFixed(0) ?? '0'}%"),
                        Text("Valid from: ${voucher.validFrom}"),
                        Text("Valid until: ${voucher.validUntil}"),
                      ],
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_box, color: Colors.green)
                        : Icon(Icons.check_box_outline_blank),
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedVouchers.remove(voucher);
                        } else {
                          selectedVouchers.add(voucher);
                        }
                      });
                    },
                  );
                },
              );
          }
        },
      ),
    );
  }
}



