
import 'package:flutter/material.dart';
import '../../Model/voucher_dto.dart';

class VoucherProvider extends ChangeNotifier {
  List<Voucher> _selectedVouchers = [];

  List<String?> getVoucherCodes() {
    return _selectedVouchers.map((voucher) => voucher.code).toList();
  }
  List<Voucher> get selectedVouchers => _selectedVouchers;

  double? _originalPrice = 0.0;
  double? _totalDiscount = 0.0;
  double? _totalPriceAfterDiscount = 0.0;

  double? get originalPrice => _originalPrice;
  double? get totalDiscount => _totalDiscount;
  double? get totalPriceAfterDiscount => _totalPriceAfterDiscount;

  void updatePaymentSummary(double originalPrice, double totalDiscount, double totalPriceAfterDiscount) {
    _originalPrice = originalPrice;
    _totalDiscount = totalDiscount;


    _totalPriceAfterDiscount = (_originalPrice! - _totalDiscount!).clamp(0.0, double.infinity);

    notifyListeners(); // Thông báo cập nhật UI
  }

  void resetValues() {
    _originalPrice = null;
    _totalDiscount = null;
    _totalPriceAfterDiscount =null;
    _selectedVouchers.clear();
    notifyListeners();
  }

  // Hàm chọn hoặc bỏ chọn voucher
  void toggleVoucher(Voucher voucher) {
    if (_selectedVouchers.contains(voucher)) {
      _selectedVouchers.remove(voucher); // Nếu voucher đã có, bỏ chọn
    } else {
      _selectedVouchers.add(voucher); // Nếu voucher chưa có, chọn
    }
    updatePaymentSummary(_originalPrice!, calculateTotalDiscount(), _originalPrice! - calculateTotalDiscount());
  }

  // Hàm kiểm tra xem voucher có đang được chọn hay không
  bool isSelected(Voucher voucher) {
    return _selectedVouchers.contains(voucher);
  }

  // Hàm xóa hết các voucher đã chọn
  void clearVouchers() {
    _selectedVouchers.clear();
    notifyListeners();
  }

  // Hàm tính tổng giảm giá từ tất cả các voucher đã chọn
  double calculateTotalDiscount() {
    double totalDiscount = 0.0;
    for (var voucher in _selectedVouchers) {
      double discountAmount = (voucher.discount ?? 0) * _originalPrice! / 100; // Tính giảm giá theo phần trăm
      totalDiscount += discountAmount; // Cộng dồn tổng giảm giá
    }
    return totalDiscount.clamp(0.0, _originalPrice!); // Đảm bảo tổng giảm giá không vượt quá giá gốc
  }
}
