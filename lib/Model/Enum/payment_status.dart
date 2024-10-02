enum PaymentStatus {
  paid,
  not_yet_paid,
}

extension OrderStatusExtension on PaymentStatus {
  String get value {
    switch (this) {
      case PaymentStatus.paid:
        return 'PAID';
      case PaymentStatus.not_yet_paid:
        return 'NOT YET PAID';
    }
  }
}
