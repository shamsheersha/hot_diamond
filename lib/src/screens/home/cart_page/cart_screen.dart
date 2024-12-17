import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_event.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_state.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';
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
    context.read<CartBloc>().add(FetchCartItems());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.grey[100],
        actions: [
          // Clear Cart Button
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartUpdated && state.items.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: () {
                    showCustomDialog(
                      context: context,
                      title: 'Clear Cart',
                      content:
                          'Are you sure you want to clear all items from your cart?',
                      onConfirm: () {
                        context.read<CartBloc>().add(ClearCart());
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartUpdated && state.items.isNotEmpty) {
            // Calculate total cart value
            double totalCartValue = state.items.fold(
                0,
                (total, cartItem) =>
                    total + (cartItem.item.price * cartItem.quantity));

            return Stack(
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          Text('Items',style: CustomTextStyles.headline2,),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final cartItem = state.items[index];
                          return ListTile(
                            title: Text(cartItem.item.name),
                            leading:
                                Image.network(cartItem.item.imageUrls.first),
                            subtitle: Text(
                                'Price: ₹${cartItem.item.price} x ${cartItem.quantity}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    'Total: ₹${cartItem.item.price * cartItem.quantity}'),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.grey[800]),
                                  onPressed: () {
                                    showCustomDialog(
                                      context: context,
                                      title: 'Remove Item',
                                      content:
                                          'Are you sure you want to remove this item from your cart?',
                                      onConfirm: () {
                                        context.read<CartBloc>().add(
                                              RemoveItemFromCart(cartItem.item),
                                            );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 120, // Fixed height for the parent container
                    width: double.infinity, // Full width of the screen
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(0, 1),
                          color: Colors.grey,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10,left: 13,right: 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total',style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),),
                              Text('Rs.${totalCartValue.toStringAsFixed(2)}',style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CartScreen()));
                            },
                            child: Container(
                              height:
                                  55, // Set a fixed height for the red container here
                              width: double.infinity, // Make it full width
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                    offset: Offset(0, 1),
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'Proceed to Checkout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Your cart is empty.'));
        },
      ),
    );
  }
}
