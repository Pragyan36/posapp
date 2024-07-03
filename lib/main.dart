import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pos_app/constant/colors.dart';
import 'package:pos_app/constant/text_styles.dart';
import 'package:pos_app/network/dbservices.dart';
import 'package:pos_app/view/auth/landing_page.dart';
import 'package:pos_app/view/auth/login.dart';
import 'package:pos_app/view/dashboard/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDatabase();
  await Hive.initFlutter();
  await Hive.openBox('fuelBox');
  await Hive.openBox('storeDetailsBox');
  await Hive.openBox('userBox');
  print(Hive.box("userBox").get(
    "ip",
  ));
  await Hive.openBox('isLoggedBox');

  //status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: primaryColor,
    // statusBarIconBrightness: Brightness.light,
  ));
  //lock orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: false,
        builder: (context) => MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
            ),
            appBarTheme: AppBarTheme(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: primaryColor,
                ),
                centerTitle: true,
                backgroundColor: primaryColor,
                titleTextStyle: TextStyles.appBarStyle,
                iconTheme: const IconThemeData(color: Colors.white)),
          ),
          home: ValueListenableBuilder(
            valueListenable: Hive.box('userBox').listenable(),
            builder: (context, box, child) => box.isEmpty
                ? const LandingPage()
                : ValueListenableBuilder(
                    valueListenable: Hive.box('isLoggedBox').listenable(),
                    builder: (context, box, child) =>
                        box.isEmpty ? const LoginPage() : DashboardPage()),
          ),
        );
      },
    );
  }
}
