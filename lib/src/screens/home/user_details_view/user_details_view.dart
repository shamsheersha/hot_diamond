import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_event.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_state.dart';

import 'package:hot_diamond_users/src/screens/home/home_screen/widget/user_details_form.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
    context.read<UserDetailsBloc>().add(FetchUserDetails());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text('Profile', style: TextStyle(color: Colors.black87)),
      actions: [
        TextButton.icon(
          onPressed: () => _updateUserDetails(context),
          icon: const Icon(Icons.check, color: Colors.green),
          label: const Text(
            'Save',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return BlocListener<UserDetailsBloc, UserDetailsState>(
      listener: _handleStateChanges,
      child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
        builder: (context, state) {
          if (state is UserDetailsLoading) {
            return const _LoadingIndicator();
          } else if (state is UserDetailsLoaded) {
            _initializeControllers(state);
            return SingleChildScrollView(
              child: _buildUserDetailsContent(state),
            );
          } else if (state is UserDetailsError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const Center(child: Text('No user details available.'));
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, UserDetailsState state) {
    if (state is UserDetailsUpdated) {
      showCustomSnackbar(context, 'User details updated successfully!');
    } else if (state is UserDetailsError) {
      showCustomSnackbar(context, 'Error: ${state.error}');
    }
  }

  void _initializeControllers(UserDetailsLoaded state) {
    _nameController.text = state.name;
    _emailController.text = state.email;
    _phoneController.text = state.phoneNumber;
  }

  Widget _buildUserDetailsContent(UserDetailsLoaded state) {
    return Column(
      children: [
        _ProfileImageSection(
          profileImage: state.profileImage,
          onImagePick: () => _pickAndUploadImage(context),
        ),
        UserDetailsForm(
          name: state.name,
          nameController: _nameController,
          emailController: _emailController,
          phoneController: _phoneController,
        ),
      ],
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    try {
      await _checkAndRequestPermissions();
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        context.read<UserDetailsBloc>().add(UpdateProfileImage(
          imagePath: image.path,
          email: _emailController.text,
        ));
      }
    } on Exception catch (error) {
      showCustomSnackbar(context, 'Error: ${_getErrorMessage(error)}');
    }
  }

  String _getErrorMessage(Exception error) {
    if (error is PlatformException) {
      switch (error.code) {
        case 'photo_access_denied':
          return 'Photo access denied. Please grant permission in settings.';
        case 'image_picker_error':
          return 'Failed to pick image. Please try again.';
        default:
          return 'Unexpected error occurred while picking image.';
      }
    }
    return error.toString();
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _LoadingDialog(message: message),
    );
  }

  Future<void> _checkAndRequestPermissions() async {
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
    if (await Permission.photos.status.isDenied) {
      await Permission.photos.request();
    }
  }

  void _updateUserDetails(BuildContext context) {
    context.read<UserDetailsBloc>().add(UpdateUserDetails(
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
        ));
  }
}

// Extracted Widgets
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.black,));
  }
}

class _LoadingDialog extends StatelessWidget {
  final String message;

  const _LoadingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _ProfileImageSection extends StatelessWidget {
  final String? profileImage;
  final VoidCallback onImagePick;

  const _ProfileImageSection({
    required this.profileImage,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _buildProfileImage(),
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 57,
      backgroundColor: Colors.grey[300],
      child: profileImage != null
          ? ClipOval(
              child: Image.network(
                profileImage!,
                width: 114,
                height: 114,
                fit: BoxFit.cover,
              ),
            )
          : const Icon(Icons.person, size: 60, color: Colors.white),
    );
  }

  Widget _buildEditButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: onImagePick,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.edit, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
