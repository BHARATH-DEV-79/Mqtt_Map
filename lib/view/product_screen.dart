import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controller/controller.dart';
import '../model/model.dart';
import '../routes/app_routs.dart';
import '../utils/widget/common_widget.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadOrders();
    });
  }

  Future<void> _loadOrders() async {
    if (!mounted) return;
    await context.read<ProductController>().getList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Orders"),
      ),
      body: Column(
        children: [
          // FILTER CHIPS
          _buildFilterChips(controller),
          if (controller.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadOrders,
                  ),
                ],
              ),
            ),

          // ORDER GRID
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.filteredOrders?.isEmpty ?? true
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inbox, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              controller.selectedFilter == 'All'
                                  ? 'No orders available'
                                  : 'No ${controller.selectedFilter} orders',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadOrders,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: controller.filteredOrders!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.62,
                          ),
                          itemBuilder: (context, index) {
                            final order = controller.filteredOrders![index];
                            return GestureDetector(
                              onTap: () => context.pushNamed(
                                Approute.product,
                                extra: order,
                              ),
                              child: ProductCard(
                                imageUrl: order.productImage ?? '',
                                amount: '₹${order.amount ?? 0}',
                                productName: order.productName ?? '',
                                platform: order.platform ?? '',
                                orderId: order.orderid ?? '',
                                customerName: order.customername ?? '',
                                orderStatus: order.orderStatus ?? 'Pending',
                                deliveryAgent: order.deliveryagent ?? 'N/A',
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ProductController controller) {
    final filters = ['All', ...DeliveryStatus.all];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = controller.selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => controller.setFilter(filter),
              backgroundColor: Colors.grey.shade200,
              selectedColor: Colors.blue.shade200,
            ),
          );
        },
      ),
    );
  }
}
