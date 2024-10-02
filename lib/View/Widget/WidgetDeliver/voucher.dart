import 'package:coffee_shop/Model/voucher_dto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../routes/route_name.dart';
import '../../StateDeliverScreen/voucher_provider.dart'; // Thay đổi đường dẫn theo dự án của bạn

class VoucherWidget extends StatelessWidget {
  const VoucherWidget({Key? key}) : super(key: key);

  void _navigateToVoucherSelection(BuildContext context) async {
    await Navigator.pushNamed(context, RouteName.voucher);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VoucherProvider>(
      builder: (context, voucherProvider, child) {
        List<Voucher> selectedVouchers = voucherProvider.selectedVouchers ?? [];

        return InkWell(
          onTap: () => _navigateToVoucherSelection(context),
          child: Container(
            height: 60,
            padding: const EdgeInsets.only(left: 20, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.0),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.discount, size: 20),
                Expanded(
                  child: Text(
                    selectedVouchers.isNotEmpty
                        ? "    Discount is Applied (${selectedVouchers.length} selected)"
                        : "    Apply Discount",
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        );
      },
    );
  }
}
