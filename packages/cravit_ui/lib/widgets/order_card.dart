import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cravit_core/models/order.dart'; // Changed to AppOrder

class OrderCard extends StatelessWidget {
  final AppOrder order;
  final VoidCallback? onTap;
  final Widget? trailing;

  const OrderCard({
    Key? key,
    required this.order,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID: ${order.id}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: 8),
              Text('Amount: \$${order.amount.toStringAsFixed(2)}'),
              Text('Status: ${order.status.toUpperCase()}'),
              Text(
                'Time: ${DateFormat('MMM d, yyyy HH:mm').format(order.createdAt.toDate())}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
