// profile.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_bloc.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_event.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_state.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_state.dart';
import 'package:hot_diamond_users/src/screens/auth/login/login.dart';
import 'package:hot_diamond_users/src/screens/home/address_screen/show_address_screen/show_address_screen.dart';
import 'package:hot_diamond_users/src/screens/home/cart_page/cart_screen.dart';
import 'package:hot_diamond_users/src/screens/home/favorite_items/favorite_items.dart';
import 'package:hot_diamond_users/src/screens/home/my_order_screen/my_orders_screen.dart';
import 'package:hot_diamond_users/src/screens/home/profile/widget/menu_button_widget.dart';
import 'package:hot_diamond_users/src/screens/home/user_details_view/user_details_view.dart';
import 'package:hot_diamond_users/src/screens/term_&_coditions/terms_and%20_conditions.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account successfully deleted'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else if (state is DeleteAccountFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is LogOutSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: CustomTextStyles.headline1,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
              builder: (context, state) {
                if (state is UserDetailsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                } else if (state is UserDetailsLoaded) {
                  return Column(
                    children: [
                      _buildUserHeader(context, state),
                      const SizedBox(height: 24),
                      _buildMenuOptions(context),
                    ],
                  );
                } else if (state is UserDetailsError) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return const Center(child: Text('No user data available'));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, UserDetailsLoaded state) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const UserDetailsView()),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            backgroundImage: state.profileImage != null && state.profileImage!.isNotEmpty
                ? NetworkImage(state.profileImage!)
                : null,
            child: state.profileImage == null || state.profileImage!.isEmpty
                ? Text(
                    state.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.phoneNumber,
                  style: CustomTextStyles.bodyText2,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    ),
  );
}

  Widget _buildMenuOptions(BuildContext context) {
    return Column(
      children: [
        _buildMenuSection(
          'Account',
          [
            MenuButton(
              icon: Icons.location_on_outlined,
              label: 'My Addresses',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ShowAddressScreen()),
              ),
            ),
            MenuButton(
              icon: Icons.list_alt_rounded,
              label: 'My Orders',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FetchOrdersScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildMenuSection(
          'Shopping',
          [
            MenuButton(
              icon: Icons.favorite_border,
              label: 'My Favorites',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              ),
            ),
            MenuButton(
              icon: Icons.shopping_cart_outlined,
              label: 'My Cart',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildMenuSection(
          'Settings',
          [
            MenuButton(
              icon: Icons.security,
              label: 'Privacy Policy',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TermsConditionsScreen()),
              ),
            ),
            MenuButton(
              icon: Icons.delete_forever,
              label: 'Delete Account',
              onPressed: () => _showDeleteAccountDialog(context),
              textColor: Colors.red,
              iconColor: Colors.red,
            ),
            MenuButton(
              icon: Icons.logout_outlined,
              label: 'Log Out',
              onPressed: () => _showLogOutConfirmationDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<Widget> buttons) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: CustomTextStyles.headline2,
            ),
          ),
          ...buttons,
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const DeleteAccountDialog(),
    );
  }

  void _showLogOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            'Log Out Confirmation',
            style: CustomTextStyles.headline2,
          ),
          content: const Text(
            'Are you sure you want to log out? You will need to sign in again to access your account.',
            style: CustomTextStyles.bodyText2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: CustomTextStyles.bodyText1,
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthenticationBloc>().add(SignOutEvent());
                Navigator.of(context).pop();
              },
              child: const Text(
                'Log Out',
                style: CustomTextStyles.buttonText,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Delete Account Dialog Widget
class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({Key? key}) : super(key: key);

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is DeleteAccountLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
          if (state is DeleteAccountSuccess || state is DeleteAccountFailure) {
            Navigator.of(context).pop();
          }
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Delete Account',
          style: CustomTextStyles.headline2,
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This action cannot be undone. All your data including orders, cart items, addresses, and favorites will be permanently deleted.',
                style: CustomTextStyles.bodyText2,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: CustomTextStyles.bodyText1,
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Colors.red),
            )
          else
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthenticationBloc>().add(
                        DeleteAccountEvent(
                          password: _passwordController.text,
                        ),
                      );
                }
              },
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}