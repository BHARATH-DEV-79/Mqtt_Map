import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/model.dart';
import '../services/product_service.dart';

class ProductController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  ResponseListProduct? _productList;
  ResponseListProduct? get productList => _productList;

  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  List<Data>? get filteredOrders {
    if (_productList?.data == null) return null;
    if (_selectedFilter == 'All') return _productList!.data;

    return _productList!.data!
        .where((order) => order.orderStatus == _selectedFilter)
        .toList();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Fetch orders from API
  Future<void> getList() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await getproduct();
      _productList = response;
      debugPrint(" Loaded ${response.data?.length ?? 0} orders");
    } catch (e) {
      debugPrint(" API Error: $e");
      errorMessage = "Failed to load orders. Please try again.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateOrderStatus(String orderId, String newStatus) {
    if (_productList?.data == null) return;

    final index = _productList!.data!.indexWhere(
      (order) => order.orderId == orderId,
    );

    if (index != -1) {
      _productList!.data![index].orderStatus = newStatus;
      notifyListeners();

      debugPrint(" Order $orderId updated to: $newStatus");
    }
  }

  final Map<String, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  void updateAgentLocation(String agentId, double lat, double lng) {
    // Find the order for this agent
    final order = _productList?.data?.firstWhere(
      (o) => o.agantid == agentId,
      orElse: () => Data(),
    );

    _markers[agentId] = Marker(
      markerId: MarkerId(agentId),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: order?.deliveryagent ?? 'Agent $agentId',
        snippet: order?.customerName != null
            ? 'Delivering to ${order!.customerName}'
            : 'No active delivery',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        order?.orderStatus == 'Delivered'
            ? BitmapDescriptor.hueGreen
            : BitmapDescriptor.hueRed,
      ),
    );
    notifyListeners();
  }
}
