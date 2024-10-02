
class VoucherList {
  int? status;
  String? message;
  List<Voucher>? data;

  VoucherList({this.status, this.message, this.data});

  VoucherList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Voucher>[];
      json['data'].forEach((v) {
        data!.add(Voucher.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Voucher {
  int? id;
  String? code;
  String? description;
  double? discount;
  String? validFrom;
  String? validUntil;

  Voucher(
      {this.id,
        this.code,
        this.description,
        this.discount,
        this.validFrom,
        this.validUntil});

  Voucher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    description = json['description'];
    discount = json['discount'];
    validFrom = json['validFrom'];
    validUntil = json['validUntil'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['description'] = description;
    data['discount'] = discount;
    data['validFrom'] = validFrom;
    data['validUntil'] = validUntil;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Voucher &&
              runtimeType == other.runtimeType &&
              id == other.id);

  @override
  int get hashCode => id.hashCode;

}