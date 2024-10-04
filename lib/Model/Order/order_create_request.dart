
import 'package:coffee_shop/Model/Order/order_item_dto.dart';

class OrderCreateRequest {
  String? userId;
  double? totalPrice;
  String? notes;
  String? status;
  List<OrderItemDTO>? orderItems;
  List<String>? voucherCodes;
  int? userAddressId;
  String? paymentStatus;
  double? discountAmount;
  double? totalAfterDiscount;

  OrderCreateRequest(
      {this.userId,
        this.totalPrice,
        this.notes,
        this.status,
        this.orderItems,
        this.voucherCodes,
        this.userAddressId,
      this.paymentStatus,
        this.discountAmount,
        this.totalAfterDiscount});

  OrderCreateRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    totalPrice = json['totalPrice'];
    notes = json['notes'];
    status = json['status'];
    discountAmount=json['discountAmount'];
    totalAfterDiscount=json['totalAfterDiscount'];
    if (json['orderItems'] != null) {
      orderItems = <OrderItemDTO>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new OrderItemDTO.fromJson(v));
      });
    }
    voucherCodes = json['voucherCodes'].cast<String>();
    userAddressId = json['userAddressId'];
    paymentStatus=json['paymentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['totalPrice'] = this.totalPrice;
    data['notes'] = this.notes;
    data['status'] = this.status;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    data['voucherCodes'] = this.voucherCodes;
    data['discountAmount']=this.discountAmount;
    data['totalAfterDiscount']=this.totalAfterDiscount;
    data['userAddressId'] = this.userAddressId;
    data['paymentStatus']=this.paymentStatus;
    return data;
  }

  @override
  @override
  String toString() {
    return 'OrderCreateRequest{userId: $userId, totalPrice: $totalPrice, notes: $notes, status: $status, orderItems: $orderItems, voucherCodes: $voucherCodes, userAddressId: $userAddressId, paymentStatus: $paymentStatus}';
  }
}
