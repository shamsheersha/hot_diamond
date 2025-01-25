import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_event.dart';
import 'package:hot_diamond_users/src/controllers/order/order_bloc.dart';
import 'package:hot_diamond_users/src/enum/checkout_enums.dart';
import 'package:hot_diamond_users/src/screens/home/my_order_screen/my_orders_screen.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:hot_diamond_users/src/controllers/address/address_event.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_state.dart';
import 'package:hot_diamond_users/src/controllers/address/address_bloc.dart';
import 'package:hot_diamond_users/src/controllers/address/address_state.dart';
import 'package:hot_diamond_users/src/model/address/address_model.dart';
import 'package:hot_diamond_users/src/model/cart/cart_item_model.dart';
import 'package:hot_diamond_users/src/screens/home/address_screen/add_screen/add_address_screen.dart';

const String razorpayApiKey = 'rzp_test_jIotm3SaZbXO9x';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  Address? _selectedAddress;
  String _selectedPaymentMethod = 'cod';
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(LoadAddresses());
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showCustomSnackbar(context, 'Payment Successful! Order Placed.');
    // clear cart items
    context.read<CartBloc>().add(ClearCart());
    // create order
    final cartState = context.read<CartBloc>().state;
    if (cartState is CartUpdated) {
      // Calculate total amount
      final totalAmount = cartState.items.fold(
        0.0,
        (sum, item) => sum + (item.totalPrice),
      );

      context.read<OrderBloc>().add(CreateOrder(
          items: cartState.items,
          deliveryAddress: _selectedAddress!,
          totalAmount: totalAmount,
          paymentMethod: PaymentMethod.razorpay));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showCustomSnackbar(context, 'Payment Failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showCustomSnackbar(context, 'External Wallet Selected: ${response.walletName}');
  }

  void _startRazorpayPayment(double amount) {
    var options = {
      'key': razorpayApiKey,
      'amount': (amount * 100).toInt(),
      'name': 'Hot Diamond',
      'description': 'Payment for Order',
      'prefill': {'contact': _selectedAddress?.phoneNumber ?? '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error starting Razorpay: $e');
      showCustomSnackbar(context, 'Failed to start payment. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.grey[100],
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            showCustomSnackbar(context, 'Order placed successfully!');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const FetchOrdersScreen()));
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              if (cartState is! CartUpdated) {
                return const Center(child: CircularProgressIndicator(color: Colors.black,));
              }

              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Colors.red[700]!,
                    secondary: Colors.red[700]!,
                  ),
                ),
                child: Stepper(
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep++);
                    } else {
                      _processOrder(cartState.items);
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep--);
                    }
                  },
                  steps: [
                    _buildDeliveryStep(),
                    _buildOrderSummaryStep(cartState.items),
                    _buildPaymentStep(),
                  ],
                  controlsBuilder: (context, details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[700],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: details.onStepContinue,
                              child: Text(
                                _currentStep == 2 ? 'Place Order' : 'Continue',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          if (_currentStep > 0) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: Colors.red[700]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: details.onStepCancel,
                                child: const Text('Back'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Step _buildDeliveryStep() {
    return Step(
      title: const Text('Delivery Address'),
      content: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black,));
          }

          if (state is AddressesLoaded) {
            return Column(
              children: [
                ...state.addresses.map((address) => _buildAddressCard(address)),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddAddressScreen(),
                    ));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Address'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 92,
                    ),
                    side: BorderSide(color: Colors.red[700]!),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No addresses found'));
        },
      ),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
    );
  }

  Widget _buildAddressCard(Address address) {
    final isSelected = _selectedAddress?.id == address.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.red[700]! : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedAddress = address),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<String>(
                value: address.id,
                groupValue: _selectedAddress?.id,
                onChanged: (value) =>
                    setState(() => _selectedAddress = address),
                activeColor: Colors.red[700],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${address.houseNumber}, ${address.roadName}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      '${address.city}, ${address.state} - ${address.pincode}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Phone: ${address.phoneNumber}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Step _buildOrderSummaryStep(List<CartItem> items) {
    final total = items.fold(
      0.0,
      (sum, item) => sum + (item.totalPrice),
    );

    return Step(
      title: const Text('Order Summary'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...items.map((item) => _buildOrderItem(item)),
          const Divider(height: 32),
          _buildPriceRow('Total', total, isTotal: true),
        ],
      ),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Step _buildPaymentStep() {
    return Step(
      title: const Text('Payment Method'),
      content: Column(
        children: [
          _buildPaymentOption(
            'Cash on Delivery',
            'cod',
            Icons.money,
            'Pay when your order arrives',
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            'RAZORPAY',
            'razorpay',
            Icons.payment,
            'Pay using Razorpay',
          ),
        ],
      ),
      isActive: _currentStep >= 2,
      state: StepState.indexed,
    );
  }

  Widget _buildPaymentOption(
    String title,
    String value,
    IconData icon,
    String subtitle,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: _selectedPaymentMethod == value
              ? Colors.red[700]!
              : Colors.grey[300]!,
          width: _selectedPaymentMethod == value ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedPaymentMethod = value),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) =>
                    setState(() => _selectedPaymentMethod = value!),
                activeColor: Colors.red[700],
              ),
              Icon(icon, size: 24, color: Colors.grey[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processOrder(List<CartItem> items) {
    if (_selectedAddress == null) {
      showCustomSnackbar(context, 'Please select a delivery address');
      setState(() => _currentStep = 0);
      return;
    }

    // Calculate total amount
    final totalAmount = items.fold(
      0.0,
      (sum, item) => sum + (item.totalPrice),
    );

    if (_selectedPaymentMethod == 'razorpay') {
      // Start Razorpay payment
      _startRazorpayPayment(totalAmount);
    } else if (_selectedPaymentMethod == 'cod') {
      // clear cart
      context.read<CartBloc>().add(ClearCart());
      // create order
      final cartState = context.read<CartBloc>().state;
      if (cartState is CartUpdated) {
        // Calculate total amount
        final totalAmount = cartState.items.fold(
          0.0,
          (sum, item) => sum + (item.totalPrice),
        );

        context.read<OrderBloc>().add(CreateOrder(
            items: cartState.items,
            deliveryAddress: _selectedAddress!,
            totalAmount: totalAmount,
            paymentMethod: PaymentMethod.cod));
      }
    }
  }
}
