import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Tableitems extends StatelessWidget {
  final String name;
  const Tableitems({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: 'Nunito',
          ),
        ),
      ),
    );
  }
}
