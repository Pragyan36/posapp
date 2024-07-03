import 'package:flutter/material.dart';
import 'package:pos_app/constant/colors.dart';

class CustomDialogBox extends StatelessWidget {
  TextEditingController? controller;
  Function(String)? onFieldSubmitted;
  Widget? suffixIcon;
  void Function(String)? onChanged;

  CustomDialogBox(
      {this.controller,
      this.onFieldSubmitted,
      this.suffixIcon,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      alignment: Alignment.bottomCenter,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      content: TextFormField(
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: TextInputType.number,
        cursorColor: primaryColor,
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: 'Price',
          labelStyle: const TextStyle(color: primaryColor),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: primaryColor)),
        ),
      ),
    );
  }
}
