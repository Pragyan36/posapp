import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:pos_app/models/storedetails.dart';

final storeDetailsProvider =
    StateNotifierProvider<StoreDetailsProvider, StoreDetailsModel>((ref) {
  return StoreDetailsProvider();
});

class StoreDetailsProvider extends StateNotifier<StoreDetailsModel> {
  StoreDetailsProvider()
      : super(StoreDetailsModel(
          name: Hive.box('storeDetailsBox').get('name', defaultValue: ''),
          location:
              Hive.box('storeDetailsBox').get('location', defaultValue: ''),
          contact: Hive.box('storeDetailsBox').get('contact', defaultValue: ''),
          email: Hive.box('storeDetailsBox').get('email', defaultValue: ''),
          pan: Hive.box('storeDetailsBox').get('pan', defaultValue: ''),
        ));
  void setStoredetails(
      String name, String location, String contact, String email, String pan) {
    state = StoreDetailsModel(
        name: name,
        location: location,
        contact: contact,
        email: email,
        pan: pan);
    Hive.box('storeDetailsBox').put('name', name);
    Hive.box('storeDetailsBox').put('location', location);
    Hive.box('storeDetailsBox').put('contact', contact);
    Hive.box('storeDetailsBox').put('email', email);
    Hive.box('storeDetailsBox').put('pan', pan);
  }
}
