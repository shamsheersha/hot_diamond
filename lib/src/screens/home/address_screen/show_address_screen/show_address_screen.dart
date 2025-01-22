import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/address/address_bloc.dart';
import 'package:hot_diamond_users/src/controllers/address/address_event.dart';
import 'package:hot_diamond_users/src/controllers/address/address_state.dart';
import 'package:hot_diamond_users/src/enum/address_type.dart';
import 'package:hot_diamond_users/src/model/address/address_model.dart';
import 'package:hot_diamond_users/src/screens/home/address_screen/add_screen/add_address_screen.dart';
import 'package:lottie/lottie.dart';

class ShowAddressScreen extends StatelessWidget {
  const ShowAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Addresses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddAddress(context),
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add New Address',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AddressError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AddressBloc>().add(LoadAddresses());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AddressesLoaded) {
            if (state.addresses.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    
                    SizedBox(height: 24),
                    Text(
                      'No addresses found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add your first delivery address',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 24),
                    // ElevatedButton(
                    //   onPressed: () => _navigateToAddAddress(context),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Theme.of(context).primaryColor,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 32,
                    //       vertical: 16,
                    //     ),
                    //   ),
                    //   child: const Text(
                    //     'Add New Address',
                    //     style: TextStyle(fontSize: 16),
                    //   ),
                    // ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AddressBloc>().add(LoadAddresses());
              },
              color: Colors.black,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.addresses.length,
                itemBuilder: (context, index) {
                  final address = state.addresses[index];
                  return Card(
                    elevation: 2,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getAddressTypeIcon(address.type),
                                color: Colors.grey[800],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                address.type.toString().split('.').last.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (address.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'DEFAULT',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              const Spacer(),
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    await _navigateToEditAddress(context, address);
                                  } else if (value == 'delete') {
                                    _showDeleteConfirmation(context, address.id);
                                  }
                                },
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Text(
                            address.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${address.houseNumber}, ${address.roadName}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          if (address.landmark?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Landmark: ${address.landmark}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            '${address.city}, ${address.state} - ${address.pincode}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                               Icon(
                                Icons.phone,
                                size: 16,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                address.phoneNumber,
                                style:  TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  IconData _getAddressTypeIcon(AddressType type) {
    switch (type) {
      case AddressType.home:
        return Icons.home_outlined;
      case AddressType.work:
        return Icons.work_outline;
      case AddressType.other:
        return Icons.location_on_outlined;
    }
  }

  Future<void> _navigateToAddAddress(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<AddressBloc>(),
          child: const AddAddressScreen(),
        ),
      ),
    );

    if (result == true && context.mounted) {
      context.read<AddressBloc>().add(LoadAddresses());
    }
  }

  Future<void> _navigateToEditAddress(BuildContext context, Address address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<AddressBloc>(),
          child: AddAddressScreen(addressToEdit: address),
        ),
      ),
    );

    if (result == true && context.mounted) {
      context.read<AddressBloc>().add(LoadAddresses());
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context, String addressId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: <Widget>[
            TextButton(
              child:  Text('Cancel',style: TextStyle(color: Colors.grey[900]),),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                context.read<AddressBloc>().add(DeleteAddress(addressId));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}