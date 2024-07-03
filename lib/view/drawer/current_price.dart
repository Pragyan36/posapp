import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_app/constant/text_styles.dart';
import 'package:pos_app/constant/widgets/toast_alert.dart';
import 'package:pos_app/provider/fuel_prices_provider.dart';
import 'package:pos_app/view/drawer/widgets/custom_dialog_box.dart';

class CurrentPrice extends ConsumerWidget {
  CurrentPrice({super.key});

  final TextEditingController petroPriceController = TextEditingController();
  final TextEditingController dieselPriceController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fuelPrices = ref.watch(fuelPricesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Price'),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Petrol Price Rs. ${fuelPrices.petrolPrice.isEmpty ? '0' : fuelPrices.petrolPrice}',
                      style: TextStyles.cardTextStyle,
                    ),
                    IconButton(
                      onPressed: () async {
                        await showModal(
                          configuration: const FadeScaleTransitionConfiguration(
                            transitionDuration: Duration(milliseconds: 400),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                              controller: petroPriceController,
                              onFieldSubmitted: (val) async {
                                if (val.trim().isEmpty) {
                                  return Toasts.showFailure('required');
                                } else {
                                  ref
                                      .read(fuelPricesProvider.notifier)
                                      .setPetrolPrice(
                                          petroPriceController.text.trim());
                                  Navigator.of(context).pop();
                                }
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(fuelPrices.petrolPrice.isEmpty
                          ? Icons.add
                          : Icons.edit),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Diesel Price Rs. ${fuelPrices.dieselPrice.isEmpty ? '0' : fuelPrices.dieselPrice}',
                      style: TextStyles.cardTextStyle,
                    ),
                    IconButton(
                      onPressed: () async {
                        await showModal(
                          configuration: const FadeScaleTransitionConfiguration(
                            transitionDuration: Duration(milliseconds: 400),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                              controller: dieselPriceController,
                              onFieldSubmitted: (val) async {
                                if (val.trim().isEmpty) {
                                  return Toasts.showFailure('required');
                                } else {
                                  ref
                                      .read(fuelPricesProvider.notifier)
                                      .setDieselPrice(
                                          dieselPriceController.text.trim());
                                  Navigator.of(context).pop();
                                }
                              },
                            );
                          },
                        );
                      },
                      icon: Icon(fuelPrices.dieselPrice.isEmpty
                          ? Icons.add
                          : Icons.edit),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
