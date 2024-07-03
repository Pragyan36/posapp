import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words_nepali/number_to_words_nepali.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_app/constant/widgets/tablebody.dart';
import 'package:pos_app/constant/widgets/tabletitle.dart';
import 'package:pos_app/constant/widgets/toast_alert.dart';
import 'package:pos_app/models/bill.dart';
import 'package:pos_app/network/dbservices.dart';
import 'package:pos_app/provider/fuel_prices_provider.dart';
import 'package:pos_app/provider/store_details_provider.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class Bills extends ConsumerStatefulWidget {
  const Bills({super.key});

  @override
  ConsumerState<Bills> createState() => _BillsState();
}

class _BillsState extends ConsumerState<Bills> {
  @override
  void initState() {
    super.initState();

    billget();
  }

  List<Bill> bills = [];

  Future<void> billget() async {
    List<Bill> getbill = await DatabaseHelper.instance.getbill();
    setState(() {
      bills = getbill;
    });
  }

  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> exportToCSV(BuildContext context) async {
    await requestPermissions();

    List<List<dynamic>> rows = [];
    rows.add(["Invoice no.", "Liters", "Fuel Type", "Price"]);

    for (var bill in bills) {
      List<dynamic> row = [];
      row.add(bill.ID);
      row.add(bill.LITER);
      row.add(bill.FUELTYPE);
      row.add(bill.PRICE);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);

    // Construct the path to the Downloads directory
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = "bills_$timestamp.csv";
    final downloadsPath = "/storage/emulated/0/Download/$fileName";
    final file = File(downloadsPath);

    try {
      await file.writeAsString(csv);
      Toasts.showSuccess('CSV file saved at: $downloadsPath');
    } catch (e) {
      Toasts.showSuccess('Failed to save CSV file: $e');
      debugPrint('Failed to save CSV file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeDetails = ref.watch(storeDetailsProvider);
    final petrolPrice = ref.watch(fuelPricesProvider);

    void _printInvoice(Bill bill) async {
      try {
        await SunmiPrinter.startTransactionPrint(true);

        // Invoice header
        await SunmiPrinter.printText(storeDetails.name,
            style: SunmiStyle(
                align: SunmiPrintAlign.CENTER,
                bold: true,
                fontSize: SunmiFontSize.LG));
        await SunmiPrinter.printText(storeDetails.location,
            style: SunmiStyle(
                align: SunmiPrintAlign.CENTER,
                bold: true,
                fontSize: SunmiFontSize.MD));
        await SunmiPrinter.printText(storeDetails.email,
            style: SunmiStyle(
                align: SunmiPrintAlign.CENTER,
                bold: true,
                fontSize: SunmiFontSize.MD));
        await SunmiPrinter.printText('PAN ${storeDetails.pan}',
            style: SunmiStyle(
                align: SunmiPrintAlign.CENTER,
                bold: true,
                fontSize: SunmiFontSize.MD));
        await SunmiPrinter.printText('PH : ${storeDetails.contact}',
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
        await SunmiPrinter.printText('BILL No: ${bill.ID}',
            style: SunmiStyle(bold: true, fontSize: SunmiFontSize.MD));
        await SunmiPrinter.printText(
            'Date: ${DateFormat('d LLL, yyyy HH:mm:ss').format(DateTime.parse(bill.DATE!))}',
            style: SunmiStyle(bold: true, fontSize: SunmiFontSize.MD));
        await SunmiPrinter.lineWrap(1);

        // Table header
        await SunmiPrinter.printText('Item   Qty(Ltr)   Rate     Price',
            style: SunmiStyle(bold: true, align: SunmiPrintAlign.LEFT));
        await SunmiPrinter.printText('--------------------------------');

        // Items
        await SunmiPrinter.printText(
            '${bill.FUELTYPE}  ${bill.LITER}    ${bill.FUELTYPE == 'Petrol' ? double.parse(petrolPrice.petrolPrice).toStringAsFixed(2) : double.parse(petrolPrice.dieselPrice).toStringAsFixed(2)}  ${double.parse(bill.PRICE!).toStringAsFixed(2)}',
            style: SunmiStyle(align: SunmiPrintAlign.LEFT));
        await SunmiPrinter.printText('--------------------------------');

        // Total
        double totalAmount = double.parse('${bill.PRICE}');

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
        title: const Text("Bills"),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => exportToCSV(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const TableTitle(
            item1: "Inovice no.",
            item2: "Liters",
            item3: "Fuel Type",
            item4: "Print",
            item5: "Price",
          ),
          Expanded(
            child: ListView.builder(
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  return Tablebody(
                    item1: bills[index].ID.toString(),
                    item2: bills[index].LITER,
                    item3: bills[index].FUELTYPE,
                    item5: bills[index].PRICE,
                    onTap: () {
                      _printInvoice(bills[index]);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
