
class ResponseListProduct {
  int? status;
  String? message;
  List<Data>? data;

  ResponseListProduct({this.status, this.message, this.data});

  ResponseListProduct.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? orderId;
  String? platform;
  String? customerName;
  String? address;
  String? productName;
  String? productImage;
  String? orderStatus;
  int? amount;
  String? deliveryagent;
  String? agantid;

  Data(
      {this.orderId,
      this.platform,
      this.customerName,
      this.address,
      this.productName,
      this.productImage,
      this.orderStatus,
      this.amount,
      this.deliveryagent,
      this.agantid});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    platform = json['platform'];
    customerName = json['customerName'];
    address = json['address'];
    productName = json['productName'];
    productImage = json['productImage'];
    orderStatus = json['orderStatus'];
    amount = json['amount'];
    deliveryagent = json['Deliveryagent'];
    agantid = json['agantid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['platform'] = this.platform;
    data['customerName'] = this.customerName;
    data['address'] = this.address;
    data['productName'] = this.productName;
    data['productImage'] = this.productImage;
    data['orderStatus'] = this.orderStatus;
    data['amount'] = this.amount;
    data['Deliveryagent'] = this.deliveryagent;
    data['agantid'] = this.agantid;
    return data;
  }
}
class DeliveryStatus {
  static const String pending = 'Pending';
  static const String inTransit = 'In Transit';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
  
  static const List<String> all = [
    pending,
    inTransit,
    delivered,
    cancelled,
  ];
}