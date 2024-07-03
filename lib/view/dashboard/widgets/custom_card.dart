import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_app/constant/text_styles.dart';

class CustomCard extends StatelessWidget {
  void Function()? onTap;
  String img;
  String title;
  String price;

  CustomCard({
    required this.onTap,
    required this.img,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.w),
        child: Container(
          // width: 120.w,
          // height: 120.h,
          padding: EdgeInsets.symmetric(horizontal: 42.w, vertical: 22.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(img, height: 50.h, width: 50.w),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.cardTextStyle,
              ),
              Text(
                price,
                textAlign: TextAlign.center,
                style: TextStyles.cardTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
