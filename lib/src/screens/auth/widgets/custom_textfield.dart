import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool? autoFocus;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final bool? readOnly;
  final TextCapitalization? textCapitalization;
  final IconData? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.labelText,
      this.keyboardType,
      required this.isPassword,
      this.autoFocus,
      this.validator,
      this.onChanged,
      this.decoration,
      this.readOnly,
      this.prefixIcon,
      this.textCapitalization, this.inputFormatters});

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscured : false,
      
      keyboardType: widget.isPassword && !_isObscured
          ? TextInputType.number
          : widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      autofocus: false,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        ...?widget.inputFormatters
      ],
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null,
        border: const OutlineInputBorder(),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon:
                    Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        labelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}
