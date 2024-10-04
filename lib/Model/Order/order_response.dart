import 'dart:ffi';

import 'package:coffee_shop/Model/Cart/cart_response.dart';

import '../address_dto.dart';

class OrderResponse {
  int? status;
  String? message;
  OrderResponseData? data;

  OrderResponse({this.status, this.message, this.data});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new OrderResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'OrderResponse{status: $status, message: $message, data: $data}';
  }
}

class OrderResponseData {
  int? id;
  String? orderDate;
  double? totalPrice;
  String? notes;
  Address? address;
  String? status;
  List<CartItemData>? orderItems;
  String? transactionCode;
  double? discountAmount;
  double? totalAfterDiscount;

  OrderResponseData(
      {this.id,
      this.orderDate,
      this.totalPrice,
      this.notes,
      this.address,
      this.status,
      this.orderItems,
      this.transactionCode,
      this.discountAmount,
      this.totalAfterDiscount});

  OrderResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderDate = json['orderDate'];
    totalPrice = json['totalPrice'];
    notes = json['notes'];
    transactionCode = json['transactionCode'];
    discountAmount=json['discountAmount'];
    totalAfterDiscount=json['totalAfterDiscount'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    status = json['status'];
    if (json['orderItems'] != null) {
      orderItems = <CartItemData>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new CartItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderDate'] = this.orderDate;
    data['totalPrice'] = this.totalPrice;
    data['notes'] = this.notes;
    data['discountAmount']=this.discountAmount;
    data['totalAfterDiscount']=this.totalAfterDiscount;
    data['transactionCode'] = this.transactionCode;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['status'] = this.status;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'OrderResponseData{id: $id, orderDate: $orderDate, totalPrice: $totalPrice, notes: $notes, address: $address, status: $status, orderItems: $orderItems, transactionCode: $transactionCode, discountAmount: $discountAmount, totalAfterDiscount: $totalAfterDiscount}';
  }
}
