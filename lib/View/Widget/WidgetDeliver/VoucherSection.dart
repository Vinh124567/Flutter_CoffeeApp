// File: voucher_section.dart

import 'package:flutter/material.dart';

import '../../../Model/voucher_dto.dart';
import '../../../routes/route_name.dart';
 // Thay đổi đường dẫn theo dự án của bạn

class VoucherSection extends StatefulWidget {
  final List<Voucher> initiallySelectedVouchers;
  final Function(List<Voucher>) onVouchersSelected;

  const VoucherSection({
    Key? key,
    required this.initiallySelectedVouchers,
    required this.onVouchersSelected,
  }) : super(key: key);

  @override
  _VoucherSectionState createState() => _VoucherSectionState();
}

class _VoucherSectionState extends State<VoucherSection> {
  List<Voucher> selectedVouchers = [];

  @override
  void initState() {
    super.initState();
    selectedVouchers = widget.initiallySelectedVouchers;
  }

  void _navigateToVoucherSelection() async {
    final result = await Navigator.pushNamed(
      context,
      RouteName.voucher,
      arguments: selectedVouchers,
    ) as List<Voucher>?;

    if (result != null) {
      setState(() {
        selectedVouchers = result;
      });
      widget.onVouchersSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _navigateToVoucherSelection,
      child: Container(
        height: 60,
        padding: const EdgeInsets.only(left: 20, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
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
                    ? "Discount is Applied (${selectedVouchers.length} selected)"
                    : "Apply Discount",
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
