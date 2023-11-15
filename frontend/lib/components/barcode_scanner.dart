import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:na_zeszyt/api.dart';
import 'package:na_zeszyt/components/primary_loader.dart';
import 'package:na_zeszyt/components/scanned_product_menu.dart';
import 'package:na_zeszyt/shared/themeData.dart';

class BarcodeScanner extends StatelessWidget {
  const BarcodeScanner({
    super.key,
    required this.parentContext,
    required this.sheetData,
  });

  final SheetApi sheetData;
  final BuildContext parentContext;

  static void popup(BuildContext context, SheetApi sheetData) {
    showDialog(
      context: context,
      builder: (_) => BarcodeScanner(parentContext: context, sheetData: sheetData),
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = MobileScannerController();

    return MobileScanner(
      controller: controller,
      onDetect: (capture) async {
        await onDetect(context, capture.barcodes.first.rawValue!);
      },
      errorBuilder: (context, error, child) {
        Navigator.pop(context);
        return const SizedBox.shrink();
      },
      overlay: Scaffold(
        backgroundColor: const Color(0x4C000000),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Color(0x80FFFFFF),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              bottomBarButton("Dodaj ręcznie", () {
                // TODO:
              }),
              const Spacer(),
              bottomBarButton("Zmień kamerę", () {
                controller.switchCamera();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomBarButton(String textValue, void Function() onPressed) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Text(
          textValue,
          style: const TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> onDetect(BuildContext context, String barcode) async {
    Navigator.pop(context);

    var loader = PrimaryLoader(context: context);
    loader.popup();

    ProductApi? productData;
    try {
      productData = await ProductApi.fetchProduct(barcode);
    } catch (_) {
      loader.hidePopup();
      return;
      // TODO: error message
    }
    loader.hidePopup();

    if (productData == null) {
      // TODO: handle this one
    } else {
      ScannedProductMenu.popup(
        parentContext,
        productData: productData,
        sheetData: sheetData,
      );
    }
  }
}
