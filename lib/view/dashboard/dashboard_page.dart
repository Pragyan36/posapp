import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_app/constant/colors.dart';
import 'package:pos_app/constant/text_styles.dart';
import 'package:pos_app/provider/fuel_prices_provider.dart';
import 'package:pos_app/view/dashboard/widgets/custom_card.dart';
import 'package:pos_app/view/dashboard/widgets/custom_drawer.dart';
import 'package:pos_app/view/diesel/diesel_page.dart';
import 'package:pos_app/view/petrol/petrol_page.dart';

class DashboardPage extends ConsumerWidget {
  DashboardPage({super.key});
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, ref) {
    final fuelPrice = ref.watch(fuelPricesProvider);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: primaryColor,
        drawer: CustomDrawer(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Icon(
                          Icons.sort,
                          color: Colors.white,
                          size: 30.r,
                        )),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Dashboard',
                  style: TextStyles.headingStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Welcome',
                  style: TextStyles.welcomeStyle,
                ),
              ),
              SizedBox(height: 45.h),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 30.w),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xffE9E9E9),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomCard(
                        onTap: () {
                          Navigator.of(context)
                              .push(CupertinoPageRoute(builder: (context) {
                            return DieselPage();
                          }));
                        },
                        img: 'assets/icons/diesel.png',
                        title: 'Diesel',
                        price:
                            'Rs. ${fuelPrice.dieselPrice.isEmpty ? 0 : fuelPrice.dieselPrice}',
                      ),
                      CustomCard(
                        onTap: () {
                          Navigator.of(context)
                              .push(CupertinoPageRoute(builder: (context) {
                            return PetrolPage();
                          }));
                        },
                        img: 'assets/icons/petrol.png',
                        title: 'Petrol',
                        price:
                            'Rs. ${fuelPrice.petrolPrice.isEmpty ? 0 : fuelPrice.petrolPrice}',
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
