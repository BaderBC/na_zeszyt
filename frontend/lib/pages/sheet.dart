import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:na_zeszyt/api.dart';
import 'package:na_zeszyt/components/barcode_scanner.dart';
import 'package:na_zeszyt/shared/themeData.dart';
import 'package:go_router/go_router.dart';

class SheetPage extends StatefulWidget {
  const SheetPage({super.key, required this.sheetName});

  final String sheetName;

  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  late SheetApi sheetData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SheetApi.fetchOne(widget.sheetName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('Ładowanie...'); //TODO: make here some loader
        }
        if (snapshot.hasError) {
          throw snapshot.error!;
        }

        sheetData = snapshot.data!;
        return _build(context);
      },
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: appBarTitle(),
        actions: [addProductButton()],
      ),
      body: SafeArea(child: allProducts()),
    );
  }

  Widget appBarTitle() {
    return Text(
      widget.sheetName,
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
        onPressed: () {
          BarcodeScanner.popup(context, sheetData);
        },
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

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, i) {
          return productWidget(context, products[i], i);
        },
      ),
    );
  }

  Widget productWidget(
      BuildContext context, ProductOnSheetApi productData, int index) {
    var (count, unitName) =
        readableCountAndUnit(productData.product.typeOfMeasure, productData.count);

    var productCard = Card(
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
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: productData.isActive
          ? activeProduct(
              card: productCard,
              productData: productData,
            )
          : inactiveProduct(
              card: productCard,
              productData: productData,
              key: Key('$index'),
            ),
    );
  }

  Widget activeProduct({
    required Widget card,
    required ProductOnSheetApi productData,
  }) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) async {
              if (await productData.changeActivity(false)) setState(() {});
            },
            icon: Icons.check_box_rounded,
            label: "Spisz",
            borderRadius: BorderRadius.circular(7),
            foregroundColor: const Color(0xff1fe009),
          ),
          SlidableAction(
            onPressed: (_) async {
              await showDialog(
                context: context,
                builder: (context) => popupSettings(context, productData),
              );
            },
            icon: Icons.settings,
            label: "Zmień",
            borderRadius: BorderRadius.circular(7),
            foregroundColor: const Color(0xff565656),
          ),
        ],
      ),
      child: card,
    );
  }

  Widget inactiveProduct({
    required Widget card,
    required ProductOnSheetApi productData,
    required Key key,
  }) {
    return GestureDetector(
      onLongPress: () async {
        if (await productData.changeActivity(true)) setState(() {});
      },
      child: Dismissible(
        onDismissed: (_) {}, // TODO
        key: key,
        child: Opacity(
          opacity: 0.5,
          child: card,
        ),
      ),
    );
  }

  Widget popupSettings(
      BuildContext context, ProductOnSheetApi productOnSheetData) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Center(
          child: Material(
            child: countSettingsCard(productOnSheetData),
          ),
        ),
      ],
    );
  }

  Widget countSettingsCard(ProductOnSheetApi productOnSheetData) {
    var (productCount, measurementUnit) = readableCountAndUnit(
        productOnSheetData.product.typeOfMeasure, productOnSheetData.count);

    var countController = TextEditingController();
    countController.text = "$productCount $measurementUnit";

    return SizedBox(
      height: 70,
      child: Card(
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Text(
              "Ilość: ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: TextField(
                controller: countController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: const Size(100, double.infinity),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                backgroundColor: Colors.lightGreen,
              ),
              child: const Text(
                "Zmień",
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReadableTimeDifference(String dateString) {
    var date = DateTime.parse(dateString);
    var dateWithoutTimeData = DateTime(date.year, date.month, date.day);

    var timeDifference = DateTime.now().difference(dateWithoutTimeData);
    int timeDifferenceInDays = timeDifference.inDays;
    final String finalText;

    if (timeDifferenceInDays == 0) {
      finalText = "Dziś";
    } else if (timeDifferenceInDays == 1) {
      finalText = "Wczoraj";
    } else {
      finalText = "$timeDifferenceInDays Dni temu";
    }

    return Text(
      finalText,
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }

  (String, String) readableCountAndUnit(
      String typeOfMeasure, double productCount) {
    if (typeOfMeasure == "unit") {
      String tmpCount = productCount.toInt().toString();
      return (tmpCount, varietyOfSztuka(productCount.toInt()));
    } else {
      if (productCount >= 1) {
        return (productCount.toString(), "Kilo");
      } else if (productCount / 100 >= 1) {
        return ((productCount / 100).toString(), "Dag");
      } else if (productCount / 1000 >= 1) {
        return ((productCount / 1000).toString(), "Gram");
      }
      return (productCount.toString(), "Kilo");
    }
  }

  String varietyOfSztuka(int count) {
    if (count == 1) {
      return "Sztuka";
    }
    if (count > 10 && count < 20) {
      return "Sztuk";
    }
    int lastDigit = count % 10;
    if ([0, 2, 3, 4].contains(lastDigit)) {
      return "Sztuki";
    }

    return "Sztuk";
  }
}
