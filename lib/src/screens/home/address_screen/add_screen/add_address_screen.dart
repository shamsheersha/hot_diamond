import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/address/address_bloc.dart';
import 'package:hot_diamond_users/src/controllers/address/address_event.dart';
import 'package:hot_diamond_users/src/controllers/address/address_state.dart';
import 'package:hot_diamond_users/src/enum/address_type.dart';
import 'package:hot_diamond_users/src/model/address/address_model.dart';
import 'package:hot_diamond_users/src/screens/auth/widgets/custom_textfield.dart';
import 'package:hot_diamond_users/widgets/custom_Button.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';

class AddAddressScreen extends StatefulWidget {
  final Address? addressToEdit;

  const AddAddressScreen({
    Key? key,
    this.addressToEdit,
  }) : super(key: key);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _stateController;
  late final TextEditingController _cityController;
  late final TextEditingController _houseController;
  late final TextEditingController _roadController;
  late final TextEditingController _landmarkController;

  bool _isDefaultAddress = false;
  AddressType _addressType = AddressType.home;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.addressToEdit?.name ?? '');
    _phoneController = TextEditingController(text: widget.addressToEdit?.phoneNumber ?? '');
    _pincodeController = TextEditingController(text: widget.addressToEdit?.pincode ?? '');
    _stateController = TextEditingController(text: widget.addressToEdit?.state ?? '');
    _cityController = TextEditingController(text: widget.addressToEdit?.city ?? '');
    _houseController = TextEditingController(text: widget.addressToEdit?.houseNumber ?? '');
    _roadController = TextEditingController(text: widget.addressToEdit?.roadName ?? '');
    _landmarkController = TextEditingController(text: widget.addressToEdit?.landmark ?? '');

    if (widget.addressToEdit != null) {
      _isDefaultAddress = widget.addressToEdit!.isDefault;
      _addressType = widget.addressToEdit!.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _houseController.dispose();
    _roadController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final address = Address(
      id: widget.addressToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      pincode: _pincodeController.text.trim(),
      state: _stateController.text.trim(),
      city: _cityController.text.trim(),
      houseNumber: _houseController.text.trim(),
      roadName: _roadController.text.trim(),
      landmark: _landmarkController.text.trim(),
      type: _addressType,
      isDefault: _isDefaultAddress,
    );

    if (widget.addressToEdit != null) {
      context.read<AddressBloc>().add(UpdateAddress(address));
    } else {
      context.read<AddressBloc>().add(AddAddress(address));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.addressToEdit != null ? 'Edit Address' : 'Add New Address'),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressOperationSuccess) {
            showCustomSnackbar(
              context,
              widget.addressToEdit != null
                  ? 'Address updated successfully'
                  : 'Address saved successfully',
            );
            Navigator.pop(context, true);
          }

          if (state is AddressError) {
            showCustomSnackbar(context, state.message);
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPersonalInfoSection(),
              const SizedBox(height: 24),
              _buildAddressDetailsSection(),
              const SizedBox(height: 24),
              _buildAddressTypeSection(),
              const SizedBox(height: 24),
              _buildDefaultAddressSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          controller: _nameController,
          prefixIcon: Icons.person_outline,
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Name is required';
            if (value!.length < 3) return 'Name must be at least 3 characters';
            return null;
          },
          isPassword: false,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          controller: _phoneController,
          labelText: 'Phone Number',
          hintText: 'Enter your phone number',
          prefixIcon: Icons.phone_outlined,
          isPassword: false,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Phone number is required';
            if (value!.length != 10) return 'Phone number must be 10 digits';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAddressDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          controller: _pincodeController,
          labelText: 'Pincode',
          hintText: 'Enter your pincode',
          prefixIcon: Icons.location_on_outlined,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          keyboardType: TextInputType.number,
          isPassword: false,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Pincode is required';
            if (value!.length != 6) return 'Pincode must be 6 digits';
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextfield(
                controller: _stateController,
                prefixIcon: Icons.location_city_outlined,
                labelText: 'State',
                hintText: 'Enter your state',
                isPassword: false,
                textCapitalization: TextCapitalization.words,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'State is required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextfield(
                controller: _cityController,
                labelText: 'City',
                hintText: 'Enter your city',
                prefixIcon: Icons.location_city_outlined,
                isPassword: false,
                textCapitalization: TextCapitalization.words,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'City is required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          controller: _houseController,
          labelText: 'House No/Building Name',
          hintText: 'Enter your house number',
          prefixIcon: Icons.home_outlined,
          isPassword: false,
          textCapitalization: TextCapitalization.words,
          validator: (value) =>
              value?.isEmpty ?? true ? 'House number is required' : null,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          controller: _roadController,
          labelText: 'Road Name/Area/Colony',
          hintText: 'Enter your road name',
          prefixIcon: Icons.location_city_outlined,
          isPassword: false,
          textCapitalization: TextCapitalization.words,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Road name is required' : null,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          controller: _landmarkController,
          labelText: 'Landmark (Optional)',
          hintText: 'Enter your landmark',
          prefixIcon: Icons.location_on_outlined,
          isPassword: false,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildAddressTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildRadioTile(AddressType.home, 'Home'),
        _buildRadioTile(AddressType.work, 'Work'),
        _buildRadioTile(AddressType.other, 'Other'),
      ],
    );
  }

  Widget _buildRadioTile(AddressType type, String label) {
    return RadioListTile<AddressType>(
      title: Text(label),
      fillColor: MaterialStateProperty.all(Colors.black),
      value: type,
      groupValue: _addressType,
      onChanged: (AddressType? value) {
        if (value != null) {
          setState(() => _addressType = value);
        }
      },
    );
  }

  Widget _buildDefaultAddressSection() {
    return SwitchListTile(
      title: const Text(
        'Set as default address',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: _isDefaultAddress,
      onChanged: (bool value) {
        setState(() => _isDefaultAddress = value);
      },
      activeColor: Colors.black,
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        return CustomButton(
          text: widget.addressToEdit != null ? 'Update Address' : 'Save Address',
          onPressed: state is AddressLoading ? null : _submitForm,
          isLoading: state is AddressLoading,
          color: Theme.of(context).primaryColor,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
        );
      },
    );
  }
}
