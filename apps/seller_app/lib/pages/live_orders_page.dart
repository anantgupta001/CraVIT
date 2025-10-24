import 'package:flutter/material.dart';
import 'package:cravit_core/models/order.dart'; // Changed to AppOrder
import 'package:cravit_core/services/order_service.dart';
import 'package:cravit_ui/widgets/order_card.dart';
import 'package:seller_app/main.dart'; // For activeVendorId

class LiveOrdersPage extends StatefulWidget {
  const LiveOrdersPage({super.key});

  @override
  State<LiveOrdersPage> createState() => _LiveOrdersPageState();
}

class _LiveOrdersPageState extends State<LiveOrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'New'),
            Tab(text: 'In-Progress'),
            Tab(text: 'Ready'),
          ],
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(["placed", "accepted"]), // New orders
              _buildOrderList(["accepted"]), // In-Progress orders
              _buildOrderList(["ready"]), // Ready orders
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderList(List<String> statuses) {
    return StreamBuilder<List<AppOrder>>(
      stream: _orderService.streamOrdersForVendor(activeVendorId, statuses: statuses),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders found.'));
        }
        final orders = snapshot.data!;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCard(
              order: order,
              trailing: _buildActionButtons(order),
              onTap: () {
                // TODO: Implement order details view or action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on order ${order.id}')),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildActionButtons(AppOrder order) {
    if (order.status == "placed") {
      return ElevatedButton(
        onPressed: () => _acceptOrder(order.id),
        child: const Text("Accept"),
      );
    } else if (order.status == "accepted") {
      return ElevatedButton(
        onPressed: () => _markReady(order.id),
        child: const Text("Mark Ready"),
      );
    } else if (order.status == "ready") {
      return ElevatedButton(
        onPressed: () => _showCompleteOrderDialog(order.id),
        child: const Text("Complete"),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _acceptOrder(String orderId) async {
    try {
      await _orderService.acceptOrder(orderId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order accepted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept order: ${e.toString()}')),
      );
    }
  }

  Future<void> _markReady(String orderId) async {
    try {
      final pickupCode = await _orderService.markReady(orderId);
      _showPickupCodeDialog(pickupCode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order marked ready!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark order ready: ${e.toString()}')),
      );
    }
  }

  void _showPickupCodeDialog(String pickupCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Ready!'),
        content: Text('Pickup Code: $pickupCode'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCompleteOrderDialog(String orderId) async {
    String? pickupCode;
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Order'),
        content: TextField(
          onChanged: (value) => pickupCode = value,
          decoration: const InputDecoration(hintText: 'Enter pickup code'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(pickupCode),
            child: const Text('Complete'),
          ),
        ],
      ),
    ).then((value) => pickupCode = value);

    if (pickupCode != null && pickupCode!.isNotEmpty) {
      _completeOrder(orderId, pickupCode!);
    }
  }

  Future<void> _completeOrder(String orderId, String pickupCode) async {
    try {
      await _orderService.completeOrder(orderId, pickupCode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order completed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete order: ${e.toString()}')),
      );
    }
  }
}
