import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Model/voucher_dto.dart';
import '../../Data/Response/status.dart';
import '../../ViewModel/auth_view_model.dart';
import '../../ViewModel/voucher_view_model.dart';
import '../StateDeliverScreen/voucher_provider.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      Provider.of<VoucherViewModel>(context, listen: false)
          .fetchVoucherListApi(authViewModel.user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Vouchers"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const ImageIcon(
            AssetImage('assets/images/ic_arrow_left.png'),
          ),
        ),
      ),
      body: Consumer2<VoucherViewModel, VoucherProvider>(
        builder: (context, voucherViewModel, voucherProvider, child) {
          List<Voucher> availableVouchers =
              voucherViewModel.voucherList.data?.data ?? [];

          switch (voucherViewModel.voucherList.status!) {
            case Status.LOADING:
              return const Center(child: CircularProgressIndicator());
            case Status.ERROR:
              return Center(
                  child: Text(voucherViewModel.voucherList.message.toString()));
            case Status.COMPLETED:
              return ListView.builder(
                itemCount: availableVouchers.length,
                itemBuilder: (context, index) {
                  final voucher = availableVouchers[index];
                  final isSelected = voucherProvider.isSelected(voucher);

                  return ListTile(
                    title: Text(voucher.code ?? "Unknown Voucher"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(voucher.description ?? "No description"),
                        Text(
                            "Discount: ${voucher.discount?.toStringAsFixed(0) ?? '0'}%"),
                        Text("Valid from: ${voucher.validFrom}"),
                        Text("Valid until: ${voucher.validUntil}"),
                      ],
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_box, color: Colors.green)
                        : const Icon(Icons.check_box_outline_blank),
                    onTap: () {
                      voucherProvider.toggleVoucher(voucher); // Cập nhật danh sách voucher thông qua Provider
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
