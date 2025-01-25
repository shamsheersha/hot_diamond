import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/order/order_bloc.dart';
import 'package:hot_diamond_users/src/enum/checkout_enums.dart';
import 'package:hot_diamond_users/src/model/cart/cart_item_model.dart';
import 'package:hot_diamond_users/src/model/order/order_model.dart';
import 'package:intl/intl.dart';

class FetchOrdersScreen extends StatefulWidget {
  const FetchOrdersScreen({super.key});

  @override
  State<FetchOrdersScreen> createState() => _FetchOrdersScreenState();
}

class _FetchOrdersScreenState extends State<FetchOrdersScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.grey[100],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<OrderBloc>().add(FetchOrders());
        },
        color: Colors.black,
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.black));
            }

            if (state is OrdersLoaded) {
              return _buildOrdersList(state.orders);
            }

            if (state is OrderFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }

            return const Center(child: Text('No orders found'));
          },
        ),
      ),
    );
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders, String tab) {
    if (tab == 'All') return orders;
    return orders
        .where((order) =>
            order.status.toString().split('.').last.toLowerCase() ==
            tab.toLowerCase())
        .toList();
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const Center(child: Text('No orders found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) => _buildOrderCard(orders[index]),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(order.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (order.status == OrderStatus.pending ||
                    order.status == OrderStatus.processing)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      side: BorderSide(color: Colors.red[700]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    minimumSize: const Size(0, 25),
                    ),
                    onPressed: () => _showCancelConfirmation(order),
                    child: const Text('Cancel Order',style: TextStyle(color: Colors.red),),
                  ),
              ],
            ),
          ],
        ),
        subtitle: _buildOrderTimeline(order),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildSectionTitle('Items'),
                ...order.items.map((item) => _buildOrderItem(item)),
                const Divider(height: 32),
                _buildSectionTitle('Delivery Address'),
                _buildAddressInfo(order),
                const Divider(height: 32),
                _buildPaymentInfo(order),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCancelConfirmation(OrderModel order) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () {
              context.read<OrderBloc>().add(
                    UpdateOrderStatus(
                      orderId: order.id,
                      newStatus: OrderStatus.cancelled,
                    ),
                  );
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('YES'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline(OrderModel order) {
    final steps = [
      OrderStatus.pending,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered
    ];

    final currentIndex = steps.indexOf(order.status);
    if (currentIndex == -1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex <= currentIndex;
            return Expanded(
              child: Container(
                height: 4,
                color: isCompleted ? Colors.green : Colors.grey[300],
              ),
            );
          }
          return Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  index ~/ 2 <= currentIndex ? Colors.green : Colors.grey[300],
            ),
            child: Icon(
              _getStatusIcon(steps[index ~/ 2]),
              size: 12,
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    final colors = {
      OrderStatus.pending: Colors.orange,
      OrderStatus.confirmed: Colors.blue[300],
      OrderStatus.processing: Colors.blue,
      OrderStatus.shipped: Colors.amber,
      OrderStatus.delivered: Colors.green,
      OrderStatus.cancelled: Colors.red,
    };

    final color = colors[status] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status.toString().split('.').last,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.item.imageUrls.isNotEmpty
                  ? item.item.imageUrls.first
                  : 'placeholder_url',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.item.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (item.selectedVariation != null)
                  Text(
                    item.selectedVariation!.displayName,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                const SizedBox(height: 4),
                Text(
                  '₹${item.totalPrice.toStringAsFixed(2)} (${item.quantity} items)',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInfo(OrderModel order) {
    final address = order.deliveryAddress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text('${address.houseNumber}, ${address.roadName}'),
        Text('${address.city}, ${address.state} - ${address.pincode}'),
        const SizedBox(height: 4),
        Text('Phone: ${address.phoneNumber}'),
      ],
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.access_time;
      case OrderStatus.processing:
        return Icons.sync;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check;
      default:
        return Icons.circle;
    }
  }

  Widget _buildPaymentInfo(OrderModel order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              order.paymentMethod.toString().split('.').last.toUpperCase(),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Total Amount',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${order.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
