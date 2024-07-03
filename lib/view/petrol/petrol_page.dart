import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validation/form_validation.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words_nepali/number_to_words_nepali.dart';
import 'package:pos_app/constant/widgets/Inputfield.dart';
import 'package:pos_app/constant/colors.dart';
import 'package:pos_app/constant/widgets/customButton.dart';
import 'package:pos_app/constant/text_styles.dart';
import 'package:pos_app/constant/widgets/toast_alert.dart';
import 'package:pos_app/models/bill.dart';
import 'package:pos_app/network/dbservices.dart';
import 'package:pos_app/provider/fuel_prices_provider.dart';
import 'package:pos_app/provider/store_details_provider.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class PetrolPage extends ConsumerStatefulWidget {
  const PetrolPage({super.key});

  @override
  ConsumerState<PetrolPage> createState() => _PetrolPageState();
}

class _PetrolPageState extends ConsumerState<PetrolPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _litersController = TextEditingController();
  int? insertedId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initPrinter();
  }

  void initPrinter() async {
    try {
      await SunmiPrinter.bindingPrinter();
      print("Printer initialized successfully");
    } catch (e) {
      print("Error initializing printer: $e");
    }
  }

  Future<void> billvalue(BuildContext context) async {
    var body = {
      "LITER": _litersController.text,
      "FUELTYPE": "Petrol",
      "PRICE": _amountController.text,
      "DATE": DateTime.now().toString(),
    };
    print("print body${body}");
    var entry = Bill.fromJson(body);
    var result = await DatabaseHelper.instance.insertbill(entry);
    setState(() {
      insertedId = result['id'];
    });

    // _litersController.clear();
    // _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final petrolPrice = ref.watch(fuelPricesProvider);
    final details = ref.watch(storeDetailsProvider);

    final double petrolPricePerLiter = double.parse(
        petrolPrice.petrolPrice.isEmpty ? "0" : petrolPrice.petrolPrice);

    if (petrolPricePerLiter == 0) {
      Toasts.showFormFailure('You have not set the price of Petrol');
    }

    void _onAmountChanged(String value) {
      if (value.isEmpty) {
        _litersController.clear();
        return;
      }
      final double amount = double.tryParse(value) ?? 0;
      final double liters = amount / petrolPricePerLiter;
      _litersController.text = liters.toStringAsFixed(2);
    }

    void _onLitersChanged(String value) {
      if (value.isEmpty) {
        _amountController.clear();
        return;
      }
      final double liters = double.tryParse(value) ?? 0;
      final double amount = liters * petrolPricePerLiter;
      _amountController.text = amount.toStringAsFixed(2);
    }

    void _printInvoice() async {
      try {
        await SunmiPrinter.startTransactionPrint(true);

        // Invoice header
        await SunmiPrinter.printText(details.name,
            style: SunmiStyle(
                align: SunmiPrintAlign.CENTER,
                bold: true,
                fontSize: SunmiFontSize.LG));
        await SunmiPrinter.printText(details.location,
            style: SunmiStyle(
                align: SunmiPrintAlign.CENTER,
                bold: true,
                fontSize: SunmiFontSize.MD));
        await SunmiPrinter.printText(details.email,
            style: SunmiStyle(
                align: SunmiPrintAlign.CENTER,
                bold: true,
                fontSize: SunmiFontSize.MD));
        await SunmiPrinter.printText('PAN ${details.pan}',
            style: SunmiStyle(
                align: SunmiPrintAlign.CENTER,
                bold: true,
                fontSize: SunmiFontSize.MD));
        await SunmiPrinter.printText('PH : ${details.contact}',
            style: SunmiStyle(
                align: SunmiPrintAlign.CENTER,
                bold: true,
                fontSize: SunmiFontSize.MD));
        await SunmiPrinter.printText('Invoice',
            style: SunmiStyle(
                align: SunmiPrintAlign.CENTER,
                bold: true,
                fontSize: SunmiFontSize.MD));
        await SunmiPrinter.lineWrap(1);
        await SunmiPrinter.printText('BILL No: $insertedId',
            style: SunmiStyle(bold: true, fontSize: SunmiFontSize.MD));
        await SunmiPrinter.printText(
            'Date: ${DateFormat('d LLL, yyyy HH:mm:ss').format(DateTime.parse(DateTime.now().toString()))}',
            style: SunmiStyle(bold: true, fontSize: SunmiFontSize.MD));
        await SunmiPrinter.lineWrap(1);

        // Table header
        await SunmiPrinter.printText('Item   Qty(Ltr)   Rate     Price',
            style: SunmiStyle(bold: true, align: SunmiPrintAlign.LEFT));
        // await SunmiPrinter.lineWrap(1);
        await SunmiPrinter.printText('--------------------------------');

        // Items
        await SunmiPrinter.printText(
            'Petrol  ${_litersController.text.isEmpty ? "0" : _litersController.text}  ${petrolPricePerLiter.toStringAsFixed(2)}    ${_amountController.text.isEmpty ? "0" : double.parse(_amountController.text).toStringAsFixed(2)}',
            style: SunmiStyle(align: SunmiPrintAlign.LEFT));
        await SunmiPrinter.printText('--------------------------------');

        // Total
        double totalAmount = double.parse(_amountController.text.trim());
        await SunmiPrinter.printText(
            'Total                    ${totalAmount.toStringAsFixed(2)}',
            style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));

        await SunmiPrinter.printText('--------------------------------');
        String totalAmountInWords = NumberToWordsNepali(
          language: NumberToWordsLanguage.english,
          isMonetary: true,
        ).convertNumberToWordsNepali(totalAmount);

        await SunmiPrinter.printText('${totalAmountInWords.toUpperCase()} ONLY',
            style: SunmiStyle(align: SunmiPrintAlign.LEFT, bold: true));
        await SunmiPrinter.printText('--------------------------------');
        await SunmiPrinter.lineWrap(2);

        // Footer
        await SunmiPrinter.printText('Thank you for your purchase!',
            style: SunmiStyle(align: SunmiPrintAlign.CENTER));
        await SunmiPrinter.printText('',
            style: SunmiStyle(align: SunmiPrintAlign.CENTER));
        await SunmiPrinter.printText('',
            style: SunmiStyle(align: SunmiPrintAlign.CENTER));
        await SunmiPrinter.printText('',
            style: SunmiStyle(align: SunmiPrintAlign.CENTER));

        await SunmiPrinter.submitTransactionPrint();
        await SunmiPrinter.exitTransactionPrint(true);
        print("Printing completed successfully");
      } catch (e) {
        print("Error printing: $e");
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Petrol"),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please Enter Amount In Liter or Rupees",
                  style: TextStyles.cardTextStyle,
                ),
                SizedBox(height: 30.h),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyInputField(
                          controller: _litersController,
                          onChanged: _onLitersChanged,
                          inputType: TextInputType.number,
                          labelText: 'Liters (ltr) ',
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            final validator = Validator(validators: [
                              const RequiredValidator(),
                            ]);
                            return validator.validate(
                              label: 'This field',
                              value: val,
                            );
                          }),
                      SizedBox(height: 20.h),
                      MyInputField(
                          controller: _amountController,
                          onChanged: _onAmountChanged,
                          inputType: TextInputType.number,
                          labelText: 'Amounts (Rs) ',
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            final validator = Validator(validators: [
                              const RequiredValidator(),
                            ]);
                            return validator.validate(
                              label: 'This field',
                              value: val,
                            );
                          }),
                      SizedBox(height: 38.h),
                      CustomButtons(
                        label: 'Submit',
                        txtClr: Colors.white,
                        btnClr: primaryColor,
                        ontap: () {
                          _formKey.currentState!.save();
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            billvalue(context);
                            _printInvoice();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
