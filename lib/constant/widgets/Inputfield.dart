import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pos_app/constant/colors.dart';
import 'package:pos_app/constant/text_styles.dart';

class MyInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool? obstruct;
  final bool? enabled;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;

  const MyInputField({
    Key? key,
    required this.labelText,
    this.controller,
    this.onChanged,
    this.suffix,
    this.obstruct,
    this.validator,
    this.enabled = true,
    this.inputType = TextInputType.multiline,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyles.cardTextStyle,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: textInputAction,
                cursorColor: primaryColor,
                keyboardType: inputType,
                controller: controller,
                validator: validator,
                onChanged: onChanged,
                textAlignVertical: TextAlignVertical.center,
                obscureText: obstruct ?? false,
                style: TextStyles.formTxtStyle,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: secondaryColor,
                  errorStyle: TextStyles.formTxtStyle,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  suffixIcon: suffix,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
