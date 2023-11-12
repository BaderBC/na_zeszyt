import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:na_zeszyt/api.dart';
import 'package:na_zeszyt/components/scanned_product_menu.dart';
import 'package:na_zeszyt/shared/themeData.dart';

class BarcodeScanner extends StatelessWidget {
  const BarcodeScanner({super.key});

  static void popup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const BarcodeScanner(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = MobileScannerController();

    return MobileScanner(
      controller: controller,
      onDetect: (capture) async {
        String barcode = capture.barcodes.first.rawValue!;
        ProductApi? productData = await ProductApi.fetchProduct(barcode);

        Navigator.pop(context);
        if (productData == null) {

        } else {
          ScannedProductMenu.popup(
            context,
            productData: productData,
          );
        }
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
}
