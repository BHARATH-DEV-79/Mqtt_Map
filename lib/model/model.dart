// model.dart - Final version with auto-generated agent info
class ResponseListProduct {
  final int? status;
  final String? message;
  final List<Data>? data;

  ResponseListProduct({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseListProduct.fromJson(Map<String, dynamic> json) {
    return ResponseListProduct(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((e) => Data.fromJson(e))
          .toList() ?? [],
    );
  }
}

class Data {
  String? orderid;
  String? platform;
  String? customername;
  String? address;
  String? productName;
  String? productImage;
  String? orderStatus;
  int? amount;
  
  // ✅ Computed properties - no API changes needed
  String? get deliveryAgent => _generateAgentName();
  String? get agentId => _generateAgentId();

  Data({
    this.orderid,
    this.platform,
    this.customername,
    this.address,
    this.productName,
    this.productImage,
    this.orderStatus,
    this.amount,
  });

  Data.fromJson(Map<String, dynamic> json) {
    orderid = json['orderid'];
    platform = json['platform'];
    customername = json['customername'];
    address = json['address'];
    productName = json['productName'];
    productImage = json['productImage'];
    orderStatus = json['orderStatus'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    return {
      'orderid': orderid,
      'platform': platform,
      'customername': customername,
      'address': address,
      'productName': productName,
      'productImage': productImage,
      'orderStatus': orderStatus,
      'amount': amount,
    };
  }

  // ✅ Generate agent name from customer name or order ID
  String _generateAgentName() {
    if (customername != null && customername!.isNotEmpty) {
      // Use first word of customer name as agent name
      final words = customername!.split(' ');
      return 'Agent ${words.first}';
    }
    // Fallback to order ID
    return 'Agent ${orderid?.substring(0, 3) ?? 'XXX'}';
  }

  // ✅ Generate consistent agent ID from order ID
  String _generateAgentId() {
    if (orderid != null && orderid!.isNotEmpty) {
      // Use order ID hash to create agent ID
      final hash = orderid!.hashCode.abs() % 10; // Agent 0-9
      return 'agent_00$hash';
    }
    return 'agent_001'; // Default fallback
  }

  // ✅ Copy method for updating status locally
  Data copyWith({
    String? orderid,
    String? platform,
    String? customername,
    String? address,
    String? productName,
    String? productImage,
    String? orderStatus,
    int? amount,
  }) {
    return Data(
      orderid: orderid ?? this.orderid,
      platform: platform ?? this.platform,
      customername: customername ?? this.customername,
      address: address ?? this.address,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      orderStatus: orderStatus ?? this.orderStatus,
      amount: amount ?? this.amount,
    );
  }
}


// ✅ Delivery status constants
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