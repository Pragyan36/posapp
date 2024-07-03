import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/constant/navigation.dart';
import 'package:pos_app/view/drawer/current_price.dart';
import 'package:pos_app/view/drawer/store_details.dart';
import 'package:pos_app/view/drawer/widgets/setting_card.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          SettingCard(
            onTap: () {
              navigatePush(context, CurrentPrice());
            },
            text: 'Current Fuel Prices',
          ),
          SettingCard(
            text: 'Store Details',
            onTap: () {
              navigatePush(context, StoreDetails());
            },
          ),
        ],
      ),
    );
  }
}
