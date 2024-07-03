import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_app/constant/colors.dart';
import 'package:pos_app/constant/widgets/tableitems.dart';

class TableTitle extends StatelessWidget {
  final String? item1;
  final String? item2;
  final String? item3;
  final String? item4;
  final String? item5;
  const TableTitle({
    super.key,
    this.item1,
    this.item2,
    this.item3,
    this.item4,
    this.item5,
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
            width: 2.0,
          ),
          right: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),

          bottom: BorderSide(
            color: Colors.black,
            width: 2.0,
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
            thickness: 2,
            color: Colors.black,
          ),
          Tableitems(
            name: item2 ?? '',
          ),
          const VerticalDivider(
            thickness: 2,
            color: Colors.black,
          ),
          Tableitems(
            name: item3 ?? '',
          ),
          const VerticalDivider(
            thickness: 2,
            color: Colors.black,
          ),
          Tableitems(
            name: item5 ?? '',
          ),
          const VerticalDivider(
            thickness: 2,
            color: Colors.black,
          ),
          Tableitems(
            name: item4 ?? '',
          ),
        ],
      ),
    );
  }
}
