import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_app/models/user.dart';

final userProvider = StateNotifierProvider<UserProvider, UserModel>((ref) {
  return UserProvider();
});

class UserProvider extends StateNotifier<UserModel> {
  UserProvider()
      : super(UserModel(
          ip: Hive.box('userBox').get('ip', defaultValue: ''),
          username: Hive.box('userBox').get('username', defaultValue: ''),
          password: Hive.box('userBox').get('password', defaultValue: ''),
        ));

  void setuser(
    String ip,
    String username,
    String password,
  ) {
    state = UserModel(
      ip: ip,
      username: username,
      password: password,
    );
    Hive.box('userBox').put('ip', ip); //list.add
    Hive.box('userBox').put('username', username);
    Hive.box('userBox').put('password', password);
  }
}
