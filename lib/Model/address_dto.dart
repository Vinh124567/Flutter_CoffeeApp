class AddressDTO {
  int? status;
  String? message;
  List<Address>? data;
  AddressDTO({this.status, this.message, this.data});

  AddressDTO.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Address>[];
      json['data'].forEach((v) {
        data!.add(Address.fromJson(v));
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

class Address {
  int? id;
  String? address;
  String? phone;
  String? name;
  String? userId;

  Address({this.id, this.address, this.phone, this.name,this.userId});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    phone = json['phone'];
    name = json['name'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['phone'] = phone;
    data['name'] = name;
    data['userId'] = userId;
    return data;
  }
}