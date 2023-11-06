import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:na_zeszyt/api.dart';
import 'package:na_zeszyt/shared/themeData.dart';

class SheetPage extends StatelessWidget {
  SheetPage({super.key, required this.sheetName});

  final String sheetName;
  late SheetApi sheetData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SheetApi.fetchOne(sheetName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('Ładowanie...'); //TODO: make here some loader
        }
        sheetData = snapshot.data!;
        //return deleteIcon();
        return _build();
      },
    );
  }

  Widget _build() {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(),
        actions: [addProductButton()],
      ),
      body: allProducts(),
    );
  }

  Widget appBarTitle() {
    return Text(
      sheetName,
      style: const TextStyle(
        color: primaryTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 25,
      ),
    );
  }

  Widget addProductButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: const Text(
          "Dodaj produkt",
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget allProducts() {
    var products = sheetData.products;

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, i) {
        return productWidget(products[i]);
      },
    );
  }

  Widget productWidget(ProductOnSheetApi productData) {
    String count;
    String unitName;
    if (productData.typeOfMeasure == "unit") {
      count = productData.count.toInt().toString();
      unitName = productData.count < 2 ? "sztuka" : "sztuki";
    } else {
      var (_count, _unitName) = kgToReadable(productData.count);
      count = _count.toString();
      unitName = _unitName;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [deleteIcon()],
        ),
        child: Card(
          child: ListTile(
            title: Text(
              productData.product.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text("$count $unitName"),
            trailing: getReadableTimeDifference(productData.addedDate),
          ),
        ),
      ),
    );
  }

  Widget deleteIcon() {
    return Scaffold(
      body: SizedBox(
        width: 50,
        height: 50,
        child: SvgPicture.asset('assets/images/trash-can-solid.svg', semanticsLabel: "test"),
      ),
    );
  }

  Widget getReadableTimeDifference(String dateString) {
    var date = DateTime.parse(dateString);
    var timeDifference = DateTime.now().difference(date);
    int timeDifferenceInDays = timeDifference.inDays;
    final String finalText;

    if (timeDifferenceInDays == 0) {
      finalText = "Dziś";
    } else if (timeDifferenceInDays == 1) {
      finalText = "$timeDifferenceInDays Dzień temu";
    } else {
      finalText = "$timeDifferenceInDays Dni temu";
    }

    return Text(
      finalText,
      style: TextStyle(
        fontSize: 15,
      ),
    );
  }

  (double, String) kgToReadable(double kg) {
    if (kg >= 1) {
      return (kg, "Kilo");
    } else if (kg / 100 >= 1) {
      return (kg / 100, "Dag");
    } else if (kg / 1000 >= 1) {
      return (kg / 1000, "Gram");
    }

    return (kg, "Kilo");
  }
}
