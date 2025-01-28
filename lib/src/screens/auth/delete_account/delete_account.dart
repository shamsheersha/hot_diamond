import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_bloc.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_event.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_state.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';

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
            Navigator.of(context).pop(); // Close dialog
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
                'This action cannot be undone. All your data including orders, cart items, addresses, and favorites will be permanently deleted. Please enter your password to confirm.',
                style: CustomTextStyles.bodyText2,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _isLoading ? null : () {
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
            const CircularProgressIndicator(color: Colors.red)
          else
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthenticationBloc>().add(
                    DeleteAccountEvent(password: _passwordController.text),
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

