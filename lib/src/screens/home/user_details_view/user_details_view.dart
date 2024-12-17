import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/src/screens/auth/widgets/custom_textfield.dart';
import 'package:hot_diamond_users/src/screens/auth/widgets/phone_numberwidget.dart';

class UserDetailsView extends StatefulWidget {
  const UserDetailsView({super.key});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Triggering the FetchUserDetails event when the screen is built
    // context.read<UserDetailsBloc>().add(FetchUserDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Profile', style: TextStyle(color: Colors.black87)),
        actions: [
          TextButton.icon(
            onPressed: () => _updateUserDetails(context),
            icon: const Icon(Icons.check, color: Colors.green),
            label: const Text(
              'Save',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: BlocListener<UserDetailsBloc, UserDetailsState>(
          listener: (context, state) {
            if (state is UserDetailsUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('User details updated successfully!')),
              );
            } else if (state is UserDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
          child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
            builder: (context, state) {
              if (state is UserDetailsLoading) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.black));
              } else if (state is UserDetailsLoaded) {
                // Pre-fill the TextFields with existing user details
                _nameController.text = state.name;
                _emailController.text = state.email;
                _phoneController.text = state.phoneNumber;

                return Column(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 57,
                                backgroundColor: Colors.grey[300],
                                child: const Icon(Icons.person,
                                    size: 60, color: Colors.white),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Hello ${state.name}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildInputField(
                            icon: Icons.person_outline,
                            child: CustomTextfield(
                              isPassword: false,
                              hintText: 'Name',
                              controller: _nameController,
                              labelText: 'Name',
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            icon: Icons.email_outlined,
                            child: CustomTextfield(
                              controller: _emailController,
                              hintText: 'Email',
                              labelText: 'Email',
                              isPassword: false,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            icon: Icons.phone_outlined,
                            child:
                                PhoneNumberWidget(controller: _phoneController),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (state is UserDetailsError) {
                return Center(child: Text('Error: ${state.error}'));
              } else {
                return const Center(child: Text('No user details available.'));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required Widget child,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(icon, color: Colors.grey),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  void _updateUserDetails(BuildContext context) {
    context.read<UserDetailsBloc>().add(UpdateUserDetails(
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
        ));
  }
}
