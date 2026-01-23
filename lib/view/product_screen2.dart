import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controller/controller.dart';
import '../model/model.dart';
import '../routes/app_routs.dart';
import '../utils/constant/app_colors.dart';
import '../utils/widget/common_widget.dart';

class Productdetails extends StatefulWidget {
  final Data data;
  const Productdetails({super.key, required this.data});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.data.orderStatus ?? 'Pending';
  }

  void _showStatusUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Delivery Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DeliveryStatus.all.map((status) {
            return RadioListTile<String>(
              title: Text(status),
              value: status,
              groupValue: _currentStatus,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _currentStatus = value);
                  Navigator.pop(context);
                  _updateStatus(value);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _updateStatus(String newStatus) {
  final orderId = widget.data.orderId;

  if (orderId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order ID is missing'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  context.read<ProductController>().updateOrderStatus(
    orderId,
    newStatus,
  );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status updated to: $newStatus'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details",style: TextStyle(color: Appcolors.primary),),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit,color: Appcolors.primary,size: 27,),
            onPressed: _showStatusUpdateDialog,
            tooltip: 'Update Status',
          ),
          IconButton(
            icon: const Icon(Icons.location_on, color: Appcolors.primary,size: 27,),
           onPressed: () => context.pushNamed(Approute.mappage),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 400,
                      width: 400,
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      height: 350,
                      width: 350,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                        image: DecorationImage(
                          image: NetworkImage(widget.data.productImage ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 500,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Appcolors.text2,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                ),
                Container(
                  height: 450,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Appcolors.primary,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonDetailRow(
                          label: 'Order ID',
                          value: widget.data.agantid ?? '',
                        ),
                        CommonDetailRow(
                          label: 'Customer',
                          value: widget.data.customerName ?? '',
                        ),
                        CommonDetailRow(
                          label: 'Address',
                          value: widget.data.address ?? '',
                        ),
                        CommonDetailRow(
                          label: 'Delivery Agent',
                          value: widget.data.deliveryagent ?? 'Not assigned',
                        ),
                        CommonDetailRow(
                          label: 'Product',
                          value: widget.data.productName ?? '',
                        ),
                        CommonDetailRow(
                          label: 'Platform',
                          value: widget.data.platform ?? '',
                        ),
                        CommonDetailRow(
                          label: 'Amount',
                          value: '₹${widget.data.amount}',
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CommonDetailRow(
                                label: 'Status',
                               value: _currentStatus,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _showStatusUpdateDialog,
                              icon: const Icon(Icons.edit, size: 16,color: Appcolors.primary,),
                              label: const Text('Update',style: TextStyle(color: Appcolors.primary),),
                              style: ElevatedButton.styleFrom(  side: BorderSide(color: Appcolors.primary),
                                backgroundColor: Appcolors.background,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Appcolors.background,
        onPressed: () => context.pushNamed(Approute.mappage),
        shape: const CircleBorder(side: BorderSide(color: Colors.black12)),
        child: const Icon(Icons.location_on, color: Appcolors.primary,size: 35,),
      ),
    );
  }
}
