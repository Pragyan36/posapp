import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pos_app/constant/colors.dart';
import 'package:pos_app/constant/navigation.dart';
import 'package:pos_app/constant/text_styles.dart';
import 'package:pos_app/view/drawer/Bills.dart';
import 'package:pos_app/view/drawer/current_price.dart';
import 'package:pos_app/view/drawer/setting.dart';
import 'package:pos_app/view/drawer/store_details.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.6,
        child: Drawer(
          child: Column(
            children: [
              Container(
                color: primaryColor,
                height: 100.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/icons/home.png',
                    width: 24,
                    height: 24,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyles.cardTextStyle,
                  ),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (context) {
                    return Bills();
                  }));
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/icons/printer.png',
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Re-print', style: TextStyles.cardTextStyle),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  navigatePush(context, Setting());
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/icons/setting.png',
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Setting', style: TextStyles.cardTextStyle),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () async {
                  // Navigator.of(context).pop();
                  await Hive.box('isLoggedBox').clear();
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/icons/exit.png',
                    width: 24,
                    height: 24,
                  ),
                  title: Text('Logout', style: TextStyles.cardTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
