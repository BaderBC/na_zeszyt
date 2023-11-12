import 'package:flutter/material.dart';
import 'package:na_zeszyt/api.dart';
import 'package:na_zeszyt/shared/themeData.dart';

class ScannedProductMenu extends StatelessWidget {
  const ScannedProductMenu({
    super.key,
    required this.productData,
  });

  final ProductApi productData;

  static void popup(
    BuildContext context, {
    required ProductApi productData,
  }) {
    showDialog(
      context: context,
      builder: (context) => ScannedProductMenu(
        productData: productData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var displaySize = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        height: displaySize.height * 0.7,
        width: displaySize.width * 0.8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Scaffold(
            body: ListTile(
              title: Text(
                productData.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(productData.code),
            ),
            bottomNavigationBar: BottomAppBar(
              height: 50,
              padding: EdgeInsets.zero,
              child: addButton(),
            ),
          ),
        ),
      ),
    );
  }

  Widget addButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.black38,
      ),
      child: const Text(
        "Dodaj produkt",
        style: TextStyle(
          color: primaryTextColor,
          fontSize: 21,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
