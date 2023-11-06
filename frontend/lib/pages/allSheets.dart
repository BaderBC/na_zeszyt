import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:na_zeszyt/api.dart';
import 'package:na_zeszyt/shared/themeData.dart';

class AllSheetsPage extends StatefulWidget {
  const AllSheetsPage({super.key});

  @override
  State<AllSheetsPage> createState() => _AllSheetsPageState();
}

class _AllSheetsPageState extends State<AllSheetsPage> {
  late List<SheetApi> sheets;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SheetApi.fetchAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink(); // TODO: make e.g. loader
        }

        sheets = snapshot.data;
        return _build();
      },
    );
  }

  Widget _build() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const Text(
              "Kartki:",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            addSheet(),
            const SizedBox(height: 15),
            Expanded(child: sheetsColumn()),
          ],
        ),
      ),
    );
  }

  Widget addSheet() {
    var newSheetName = TextEditingController();

    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: const Color(0xfff1f1f1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Nazwa kartki",
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              controller: newSheetName,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String name = newSheetName.text;
              if (name.isEmpty) return;
              if (await SheetApi.createNew(name)) {
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, double.infinity),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(7),
                  bottomRight: Radius.circular(7),
                ),
              ),
              backgroundColor: const Color(0xff6cff68),
            ),
            child: const Text("Dodaj"),
          )
        ],
      ),
    );
  }

  Widget sheetsColumn() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: sheets.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: sheetWidget(sheets[index]),
        );
      },
    );
  }

  Widget sheetWidget(SheetApi sheetData) {
    final productsLen = sheetData.products.length;

    final finalSheetWidget = Container(
      decoration: BoxDecoration(
        color: const Color(0xffd5d5d5),
        borderRadius: BorderRadius.circular(7),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Row(
        children: [
          Text(
            sheetData.name,
            style: const TextStyle(
              color: primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Text(
                "Ile do spisania: ",
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                productsLen.toString(),
                style: TextStyle(
                  color: productsLen == 0
                      ? primaryTextColor
                      : const Color(0xffc91a1a),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.go('/sheet/${sheetData.name}');
        },
        child: finalSheetWidget,
      ),
    );
  }
}
