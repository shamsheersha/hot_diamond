import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_event.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_state.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_bloc.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_event.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_state.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_bloc.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_event.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_state.dart';
import 'package:hot_diamond_users/src/model/cart/cart_item_model.dart';
import 'package:hot_diamond_users/src/screens/connectivity_checker/no_internet_screen.dart';
import 'package:hot_diamond_users/src/screens/home/checkout/checkout_screen.dart';
import 'package:hot_diamond_users/widgets/show_custom_dialog.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, connectivityState) {
        if (!connectivityState.isConnected) {
          return NoInternetScreen(
            onRetry: () {
              context.read<ConnectivityBloc>().add(CheckConnectivity());
            },
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Cart'),
            backgroundColor: Colors.grey[100],
            actions: [
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartUpdated && state.items.isNotEmpty) {
                    return IconButton(
                      icon: const Icon(Icons.clear_all),
                      onPressed: () {
                        _showClearCartDialog(context);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            color: Colors.black,
            onRefresh: () async {
              context.read<CartBloc>().add(LoadCart());
            },
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }

                if (state is CartError) {
                  return _buildErrorWidget(context, state.message);
                }

                if (state is CartUpdated) {
                  if (state.items.isEmpty) {
                    return _buildEmptyCartWidget();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Items',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return _buildCartItem(item);
                          },
                        ),
                      ),
                      _buildCartSummary(state.items),
                    ],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CartBloc>().add(LoadCart());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartWidget() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(List<CartItem> items) {
    double originalTotal = items.fold(
      0,
      (sum, item) => sum + (_getOriginalPrice(item) * item.quantity),
    );
    double finalTotal = items.fold(
      0,
      (sum, item) => sum + (_calculateItemPrice(item) * item.quantity),
    );
    double totalSavings = originalTotal - finalTotal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (totalSavings > 0) ...[
              _buildTotalSavings(totalSavings),
              const SizedBox(height: 16),
            ],
            _buildTotalRow(finalTotal),
            const SizedBox(height: 16),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSavings(double totalSavings) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.savings_outlined,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Total Savings: ₹${totalSavings.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(double finalTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '₹${finalTotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CheckoutScreen(),
          ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Proceed to Checkout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    final itemPrice = _calculateItemPrice(item);
    final itemTotal = itemPrice * item.quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemImage(item),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItemName(item),
                if (item.selectedVariation != null) ...[
                  const SizedBox(height: 4),
                  _buildItemVariation(item),
                ],
                const SizedBox(height: 8),
                _buildItemPriceDetails(item, itemPrice, itemTotal),
                const SizedBox(height: 8),
                _buildItemQuantity(item),
              ],
            ),
          ),
          _buildItemActions(item),
        ],
      ),
    );
  }

  Widget _buildItemImage(CartItem item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        item.item.imageUrls.first,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildItemName(CartItem item) {
    return Text(
      item.item.name,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildItemVariation(CartItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '1x ${item.selectedVariation!.displayName}',
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildItemPriceDetails(
      CartItem item, double itemPrice, double itemTotal) {
    return Row(
      children: [
        _buildUnitPrice(item, itemPrice),
        const SizedBox(width: 16),
        _buildTotalPrice(itemTotal),
      ],
    );
  }

  Widget _buildUnitPrice(CartItem item, double itemPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit Price:',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        Row(
          children: [
            Text(
              '₹${itemPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (item.item.hasValidOffer) ...[
              const SizedBox(width: 8),
              Text(
                '₹${_getOriginalPrice(item).toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTotalPrice(double itemTotal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total:',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        Text(
          '₹${itemTotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildItemQuantity(CartItem item) {
    return Row(
      children: [
        Text(
          'Quantity: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, size: 20),
          onPressed: () => _updateQuantity(item, item.quantity - 1),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${item.quantity}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, size: 20),
          onPressed: () => _updateQuantity(item, item.quantity + 1),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildItemActions(CartItem item) {
    return Column(
      children: [
        _buildFavoriteButton(item),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _removeItem(item),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(CartItem item) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        final isFavorite = state is FavoritesLoaded &&
            state.favorites.any((fav) => fav.id == item.item.id);

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            if (isFavorite) {
              context
                  .read<FavoriteBloc>()
                  .add(RemoveFromFavorites(itemId: item.item.id));
            } else {
              context.read<FavoriteBloc>().add(AddToFavorites(item: item.item));
            }
          },
        );
      },
    );
  }

  double _calculateItemPrice(CartItem item) {
    if (item.selectedVariation != null) {
      return item.item.hasValidOffer
          ? item.item.calculateDiscountedPrice(item.selectedVariation!.price)
          : item.selectedVariation!.price;
    }
    return item.item.hasValidOffer
        ? item.item.calculateDiscountedPrice(item.item.price)
        : item.item.price;
  }

  double _getOriginalPrice(CartItem item) {
    return item.selectedVariation?.price ?? item.item.price;
  }

  void _updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity < 1) return;

    context.read<CartBloc>().add(UpdateCartItemQuantity(item, newQuantity));
  }

  void _removeItem(CartItem item) {
    showCustomDialog(
      context: context,
      title: 'Remove Item',
      content: 'Are you sure you want to remove this item from your cart?',
      onConfirm: () {
        context.read<CartBloc>().add(
              RemoveItemFromCart(item.item,
                  selectedVariation: item.selectedVariation),
            );
      },
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      title: 'Clear Cart',
      content: 'Are you sure you want to clear all items from your cart?',
      onConfirm: () {
        context.read<CartBloc>().add(ClearCart());
      },
    );
  }
}
