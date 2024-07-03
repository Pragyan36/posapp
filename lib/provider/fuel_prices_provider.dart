import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_app/model1/fuel_prices/fuel_prices.dart';

final fuelPricesProvider =
    StateNotifierProvider<FuelPricesNotifier, FuelPrices>((ref) {
  return FuelPricesNotifier();
});

class FuelPricesNotifier extends StateNotifier<FuelPrices> {
  FuelPricesNotifier()
      : super(FuelPrices(
            petrolPrice:
                Hive.box('fuelBox').get('petrolPrice', defaultValue: ''),
            dieselPrice:
                Hive.box('fuelBox').get('dieselPrice', defaultValue: '')));

  void setPetrolPrice(String newPrice) {
    state = FuelPrices(petrolPrice: newPrice, dieselPrice: state.dieselPrice);
    Hive.box('fuelBox').put('petrolPrice', newPrice);
  }

  void setDieselPrice(String newPrice) {
    state = FuelPrices(petrolPrice: state.petrolPrice, dieselPrice: newPrice);
    Hive.box('fuelBox').put('dieselPrice', newPrice);
  }
}