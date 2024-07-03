import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_app/constant/colors.dart';
import 'package:pos_app/constant/widgets/tableitems.dart';

class Tablebody extends StatelessWidget {
  final String? item1;
  final String? item2;
  final String? item3;
  final String? item4;
  final String? item5;
  void Function()? onTap;
   Tablebody({
    super.key,
    this.item1,
    this.item2,
    this.item3,
    this.item4,
    this.item5,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: secondaryColor,
        border: Border(
          left: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
          right: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
          // No top border
        ),
      ),
      child: Row(
        children: [
          Tableitems(
            name: item1 ?? '',
          ),
          const VerticalDivider(
            thickness: 1,
            color: Colors.black,
          ),
          Tableitems(
            name: item2 ?? '',
          ),
          const VerticalDivider(
            thickness: 1,
            color: Colors.black,
          ),
          Tableitems(
            name: item3 ?? '',
          ),
          const VerticalDivider(
            thickness: 1,
            color: Colors.black,
          ),
          Tableitems(
            name: item5 ?? '',
          ),
          const VerticalDivider(
            thickness: 1,
            color: Colors.black,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: onTap,
              child: SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: Image.asset(
                    "assets/icons/printer.png",
                    color: primaryColor,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
