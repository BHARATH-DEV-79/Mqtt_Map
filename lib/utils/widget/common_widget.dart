import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String amount;
  final String productName;
  final String platform;

  // 🔥 NEW DATA
  final String orderId;
  final String customerName;
  final String orderStatus;
  final String deliveryAgent;

  final Color cardColor;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.amount,
    required this.productName,
    required this.platform,

    // new
    required this.orderId,
    required this.customerName,
    required this.orderStatus,
    required this.deliveryAgent,

    this.cardColor = Colors.purple,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 IMAGE (OLD)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (_, __) =>
                      const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 💰 AMOUNT (OLD)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 📦 PRODUCT NAME (OLD)
            Text(
              productName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            // 🏷 PLATFORM (OLD)
            Text(
              platform,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),

            const Divider(color: Colors.white30),

            // 🆕 NEW DETAILS
            Text(
              'Order #$orderId',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Customer: $customerName',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              'Agent: $deliveryAgent',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),

            const SizedBox(height: 6),

            // 🟢 STATUS CHIP (NEW)
            _StatusChip(status: orderStatus),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'Delivered':
        color = Colors.green;
        break;
      case 'In Transit':
        color = Colors.orange;
        break;
      case 'Cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
