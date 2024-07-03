import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validation.dart';
import 'package:pos_app/constant/colors.dart';
import 'package:pos_app/constant/text_styles.dart';
import 'package:pos_app/constant/widgets/customButton.dart';
import 'package:pos_app/constant/widgets/toast_alert.dart';
import 'package:pos_app/provider/store_details_provider.dart';

class StoreDetails extends ConsumerStatefulWidget {
  const StoreDetails({super.key});

  @override
  ConsumerState<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends ConsumerState<StoreDetails> {
  final TextEditingController storename = TextEditingController();
  final TextEditingController storelocation = TextEditingController();
  final TextEditingController storecontact = TextEditingController();
  final TextEditingController storeemail = TextEditingController();
  final TextEditingController storepan = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final details = ref.read(storeDetailsProvider);
    storename.text = details.name;
    storelocation.text = details.location;
    storecontact.text = details.contact;
    storeemail.text = details.email;
    storepan.text = details.pan;
  }

  @override
  void dispose() {
    storename.dispose();
    storelocation.dispose();
    storecontact.dispose();
    storeemail.dispose();
    storepan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(storeDetailsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Details'),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(
                  0,
                  2,
                ), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Store Name: ${details.name}",
                  style: TextStyles.cardTextStyle),
              Text("Store Location: ${details.location}",
                  style: TextStyles.cardTextStyle),
              Text("Store Contact: ${details.contact}",
                  style: TextStyles.cardTextStyle),
              Text("Store email: ${details.email}",
                  style: TextStyles.cardTextStyle),
              Text("Store PAN: ${details.pan}",
                  style: TextStyles.cardTextStyle),
              const SizedBox(
                height: 20.0,
              ),
              CustomButtons(
                label: details.name.isEmpty ? "Add" : "Update",
                ontap: () async {
                  await showModal(
                    configuration: const FadeScaleTransitionConfiguration(
                      transitionDuration: Duration(milliseconds: 400),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: AlertDialog(
                          backgroundColor: Colors.white,
                          alignment: Alignment.bottomCenter,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          content: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: storename,
                                  textInputAction: TextInputAction.next,
                                  validator: (val) {
                                    final validator = Validator(validators: [
                                      const RequiredValidator(),
                                    ]);
                                    return validator.validate(
                                      label: 'store name',
                                      value: val,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Store Name",
                                      border: OutlineInputBorder()),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: storelocation,
                                  textInputAction: TextInputAction.next,
                                  validator: (val) {
                                    final validator = Validator(validators: [
                                      const RequiredValidator(),
                                    ]);
                                    return validator.validate(
                                      label: 'store location',
                                      value: val,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Store Location",
                                      border: OutlineInputBorder()),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: storecontact,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    final validator = Validator(validators: [
                                      const RequiredValidator(),
                                    ]);
                                    return validator.validate(
                                      label: 'contact',
                                      value: val,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Store Contact",
                                      border: OutlineInputBorder()),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: storeemail,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                      hintText: "Store Email",
                                      border: OutlineInputBorder()),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: storepan,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                      hintText: "Store PAN",
                                      border: OutlineInputBorder()),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomButtons(
                                  label: "Submit",
                                  btnClr: primaryColor,
                                  txtClr: Colors.white,
                                  ontap: () {
                                    _formKey.currentState!.save();
                                    FocusScope.of(context).unfocus();

                                    if (_formKey.currentState!.validate()) {
                                      ref
                                          .read(storeDetailsProvider.notifier)
                                          .setStoredetails(
                                              storename.text.trim(),
                                              storelocation.text.trim(),
                                              storecontact.text.trim(),
                                              storeemail.text.trim(),
                                              storepan.text.trim());
                                      Navigator.of(context).pop();
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                btnClr: primaryColor,
                txtClr: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
