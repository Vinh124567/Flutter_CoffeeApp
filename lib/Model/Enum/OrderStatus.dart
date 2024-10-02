enum OrderStatus {
  pending,
  cancelled,
  shipped,
  delivered,
}

extension OrderStatusExtension on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'PENDING';
      case OrderStatus.cancelled:
        return 'CANCELLED';
      case OrderStatus.shipped:
        return 'SHIPPED';
      case OrderStatus.delivered:
        return 'DELIVERED';
    }
  }
}
