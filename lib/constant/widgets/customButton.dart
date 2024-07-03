// ignore: file_names
import 'package:flutter/material.dart';
import 'package:pos_app/constant/text_styles.dart';

class CustomButtons extends StatelessWidget {
  final String label;
  final Color btnClr;
  final Color txtClr;
  final VoidCallback ontap;
  final EdgeInsets? margin;
  final double? width;
  final bool? isloading;

  const CustomButtons({
    Key? key,
    required this.label,
    required this.btnClr,
    required this.txtClr,
    required this.ontap,
    this.margin,
    this.width,
    this.isloading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 0,),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: const BoxDecoration(boxShadow: []),
        child: MaterialButton(
            onPressed: ontap,
            elevation: 5,
            color: btnClr,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: (isloading == true)
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    label,
                    style: TextStyles.headingStyle,
                  )),
      ),
    );
  }
}
