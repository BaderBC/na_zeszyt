import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//const urlHostPrefix = "http://127.0.0.1:3000";
const urlHostPrefix = "http://192.168.31.136:3000";

extension IsOk on http.Response {
  bool get ok {
    int firstDigit = (statusCode ~/ 100);
    return firstDigit == 2 || firstDigit == 3;
  }
}

class SheetApi {
  SheetApi({
    required this.id,
    required this.name,
    required this.products,
    required this.productsCount,
  });

  int id;
  String name;
  List<ProductOnSheetApi> products;
  int productsCount;

  static Future<List<SheetApi>> fetchAll({
    bool? includeProducts = false,
    bool? includeProductPhoto = false,
  }) async {
    var res = await http.get(Uri.parse(
        "$urlHostPrefix/sheet?includeProducts=$includeProducts&includeProductImage=$includeProductPhoto"));
    if (!res.ok) {
      throw "Failed to fetch sheets";
    }

    var json = jsonDecode(res.body);

    List<SheetApi> allSheets = [];
    for (int i = 0; i < json.length; i++) {
      allSheets.add(fromDynamic(json[i]));
    }

    return allSheets;
  }

  static Future<SheetApi> fetchOne(
    String name, {
    bool? includeProducts = true,
    bool? includeProductPhoto = false,
  }) async {
    var res = await http.get(Uri.parse(
        "$urlHostPrefix/sheet?includeProducts=$includeProducts&name=$name&includeProductPhoto=$includeProductPhoto"));
    if (!res.ok) {
      throw "Failed to fetch sheet $name";
    }
    return fromDynamic(jsonDecode(res.body));
  }

  // returns true on successes
  static Future<bool> createNew(String name) async {
    var res = await http.post(Uri.parse("$urlHostPrefix/sheet"), body: {
      'name': name,
    });
    return res.ok;
  }

  static SheetApi fromDynamic(dynamic json) {
    return SheetApi(
      id: json["id"],
      name: json["name"],
      products:
          ProductOnSheetApi.listFromDynamic(json["productsOnSheet"] ?? []),
      productsCount: json["productsCount"],
    );
  }
}

class ProductOnSheetApi {
  ProductOnSheetApi({
    required this.id,
    required this.addedDate,
    required this.isActive,
    required this.count,
    required this.product,
    required this.productId,
    required this.sheetId,
  });

  int id;
  String addedDate;
  bool isActive;
  double count;
  ProductApi product;
  int productId;
  int sheetId;

  static Future<bool> createOrIncreaseCount({
    required String productCode,
    required int sheetId,
    required double count,
  }) async {
    var uri = Uri.parse(
      '$urlHostPrefix/products-on-sheet/createOrIncreaseCount',
    );
    var res = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "product_code": productCode,
          "sheetId": sheetId,
          "count": count,
        }));

    return res.ok;
  }

  Future<bool> changeActivity(bool isActive) async {
    var uri = Uri.parse('$urlHostPrefix/products-on-sheet?id=$id');
    var res = await http.patch(uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "is_active": isActive,
        }));

    if (res.ok) isActive = isActive;
    return res.ok;
  }

  static List<ProductOnSheetApi> listFromDynamic(dynamic json) {
    List<ProductOnSheetApi> productsOnSheet = [];
    for (int i = 0; i < json.length; i++) {
      var row = json[i];
      productsOnSheet.add(ProductOnSheetApi.fromDynamic(row));
    }
    return productsOnSheet;
  }

  static ProductOnSheetApi fromDynamic(dynamic json) {
    return ProductOnSheetApi(
      id: json["id"],
      addedDate: json["added_date"],
      isActive: json["is_active"],
      count: dynamicNumberToDouble(json["count"]),
      product: ProductApi.fromDynamic(json["product"]),
      productId: json["productId"],
      sheetId: json["sheetId"],
    );
  }
}

class ProductApi {
  ProductApi({
    required this.id,
    required this.code,
    required this.typeOfMeasure,
    required this.name,
    this.image,
  });

  int id;
  String code;
  String typeOfMeasure;
  String name;
  Image? image;

  static Future<ProductApi?> fetchProduct(String barcode) async {
    var uri = Uri.parse('$urlHostPrefix/products?barcode=$barcode');
    var res = await http.get(uri);
    if (res.statusCode == 422) {
      return null;
    }
    return ProductApi.fromDynamic(jsonDecode(res.body));
  }

  static ProductApi fromDynamic(dynamic json) {
    Image? image;

    if (json["image"] != null) {
      var intList = json["image"]["data"].cast<int>().toList();
      image = Image.memory(Uint8List.fromList(intList));
    }

    return ProductApi(
      id: json["id"],
      code: json["code"],
      typeOfMeasure: json["type_of_measure"],
      name: json["name"],
      image: image,
    );
  }
}

double dynamicNumberToDouble(dynamic number) {
  if (number is int) {
    return number.toDouble();
  } else if (number is double) {
    return number;
  } else {
    throw "type ${number.runtimeType} parsing to double is not implemented";
  }
}
