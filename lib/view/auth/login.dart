// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validation/form_validation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pos_app/constant/navigation.dart';
import 'package:pos_app/constant/widgets/Inputfield.dart';
import 'package:pos_app/constant/colors.dart';
import 'package:pos_app/constant/widgets/customButton.dart';
import 'package:pos_app/constant/font_styles.dart';
import 'package:pos_app/constant/image.dart';
import 'package:pos_app/constant/text_styles.dart';
import 'package:pos_app/constant/widgets/toast_alert.dart';
import 'package:pos_app/provider/user_provider.dart';
import 'package:pos_app/view/dashboard/dashboard_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool obstructText = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: Center(
                    child: SizedBox(
                      height: 70.h,
                      width: 89.w,
                      child: Image.asset(
                        AppImages.logo,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60.h),
                Center(
                  child: Text(
                    'Login',
                    style: TextStyles.titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text('Sign in to continue',
                      style: TextStyle(
                        fontFamily: FontStyles.nunito,
                        fontSize: 12.sp,
                      )),
                ),
                SizedBox(height: 40.h),
                MyInputField(
                    labelText: 'Username',
                    controller: usernameController,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      final validator = Validator(validators: [
                        const RequiredValidator(),
                      ]);
                      return validator.validate(
                        label: 'username',
                        value: val,
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                MyInputField(
                    obstruct: obstructText,
                    labelText: 'Password',
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            obstructText = !obstructText;
                          });
                        },
                        icon: obstructText
                            ? Icon(Icons.visibility_off, size: 24.r)
                            : Icon(Icons.visibility, size: 24.r)),
                    validator: (val) {
                      final validator = Validator(validators: [
                        const RequiredValidator(),
                      ]);
                      return validator.validate(
                        label: 'password',
                        value: val,
                      );
                    }),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 50,
                  // width: double.infinity,
                  child: CustomButtons(
                    label: 'Login',
                    txtClr: Colors.white,
                    btnClr: primaryColor,
                    ontap: () async {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        if (usernameController.text.trim() ==
                                userData.username &&
                            passwordController.text.trim() ==
                                userData.password) {
                          // navigatePushReplacement(context, DashboardPage());
                          await Hive.box('isLoggedBox').put('login', true);
                        } else {
                          Toasts.authShowFailure(
                              'Invalid username or password');
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
