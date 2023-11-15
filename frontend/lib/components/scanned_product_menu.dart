import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:na_zeszyt/api.dart';
import 'package:na_zeszyt/shared/themeData.dart';

class ScannedProductMenu extends StatefulWidget {
  ScannedProductMenu({
    super.key,
    required this.productData,
    required this.sheetData,
  });

  final ProductApi productData;
  final SheetApi sheetData;
  final countController = TextEditingController();

  static void popup(
    BuildContext context, {
    required ProductApi productData,
    required SheetApi sheetData,
  }) {
    showDialog(
      context: context,
      builder: (context) => ScannedProductMenu(
        productData: productData,
        sheetData: sheetData,
      ),
    );
  }

  @override
  State<ScannedProductMenu> createState() => _ScannedProductMenuState();
}

class _ScannedProductMenuState extends State<ScannedProductMenu> {
  bool isAddButtonEnabled = true;

  @override
  initState() {
    super.initState();
    widget.countController.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    var displaySize = MediaQuery.of(context).size;

    List<Widget> columnElements = [
      ListTile(
        title: Text(
          widget.productData.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(widget.productData.code),
      ),
      changeMeasureType(),
      countInput(),
    ];

    if (widget.productData.image != null) {
      columnElements.insert(
          0,
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: displaySize.height * 0.30,
            ),
            child: widget.productData.image!,
          ));
    }

    return Center(
      child: SizedBox(
        height: displaySize.height * 0.7,
        width: displaySize.width * 0.8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: columnElements,
              ),
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
    Future<void> addButtonOnPressed() async {
      double count;

      if (widget.countController.text.isNotEmpty) {
        count = double.parse(widget.countController.text);
      } else {
        count = 1.0;
      }

      await ProductOnSheetApi.createOrIncreaseCount(
        productCode: widget.productData.code,
        sheetId: widget.sheetData.id,
        count: count,
      );

      Navigator.of(context).pop();
      context.go('/sheet/${widget.sheetData.name}');
    }

    return ElevatedButton(
      onPressed: isAddButtonEnabled ? addButtonOnPressed : null,
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      child: Text(
        "Dodaj produkt",
        style: TextStyle(
          color:
              isAddButtonEnabled ? primaryTextColor : const Color(0xff595858),
          fontSize: 21,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget changeMeasureType() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: [
        optionButton("sztuki", "unit"),
        optionButton("dag", "kg"),
      ],
    );
  }

  Widget optionButton(String optionName, String optionNameEnglish) {
    final bool isActive = widget.productData.typeOfMeasure != optionNameEnglish;

    onPressed() {
      setState(() {
        // TODO: make here also request to change type on the backend as well
        widget.productData.typeOfMeasure = optionNameEnglish;
      });
    }

    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: isActive ? onPressed : () {},
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          backgroundColor:
              isActive ? const Color(0xffcbcbcb) : const Color(0xff3ba83b),
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Text(
          optionName,
          style: const TextStyle(
            color: primaryTextColor,
          ),
        ),
      ),
    );
  }

  Widget countInput() {
    return Center(
      child: SizedBox(
        width: 280,
        height: 50,
        child: TextFormField(
          controller: widget.countController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Ilość",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(left: 15),
          ),
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}
