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

class _FetchOrdersScreenState extends State<FetchOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Pending', 'Processing', 'Delivered', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    context.read<OrderBloc>().add(FetchOrders());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.grey[100],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          labelColor: Colors.red[700],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.red[700],
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrdersLoaded) {
            return TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) {
                final filteredOrders = _filterOrders(state.orders, tab);
                return _buildOrdersList(filteredOrders);
              }).toList(),
            );
          }

          if (state is OrderFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return const Center(child: Text('No orders found'));
        },
      ),
    );
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders, String tab) {
    if (tab == 'All') return orders;
    return orders.where((order) => 
      order.status.toString().split('.').last.toLowerCase() == tab.toLowerCase()
    ).toList();
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
            Text(
              DateFormat('MMM dd, yyyy').format(order.createdAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.items.length} items',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                '₹${order.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildStatusChip(OrderStatus status) {
    final colors = {
      OrderStatus.pending: Colors.orange,
      OrderStatus.processing: Colors.blue,
      OrderStatus.delivered: Colors.green,
      OrderStatus.cancelled: Colors.red,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colors[status]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors[status]!.withOpacity(0.5)),
      ),
      child: Text(
        status.toString().split('.').last,
        style: TextStyle(
          color: colors[status],
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
              item.item.imageUrls.first,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
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