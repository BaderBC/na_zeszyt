import 'dart:convert';
import 'package:http/http.dart' as http;

//const urlHostPrefix = "http://127.0.0.1:3000";
const urlHostPrefix = "http://10.0.0.70:3000";

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

  static Future<List<SheetApi>> fetchAll(
      {bool? includeProducts = false}) async {
    var res = await http.get(
        Uri.parse("$urlHostPrefix/sheet?includeProducts=$includeProducts"));
    print("test ${res.statusCode}");
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
  }) async {
    var res = await http.get(Uri.parse(
        "$urlHostPrefix/sheet?includeProducts=$includeProducts&name=$name"));
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
    required this.typeOfMeasure,
    required this.count,
    required this.product,
    required this.productId,
    required this.sheetId,
  });

  int id;
  String addedDate;
  bool isActive;
  String typeOfMeasure;
  double count;
  ProductApi product;
  int productId;
  int sheetId;

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
      typeOfMeasure: json["type_of_measure"],
      count: json["count"],
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
    required this.name,
  });

  int id;
  String code;
  String name;

  static Future<ProductApi?> fetchProduct(String barcode) async {
    var uri = Uri.parse('$urlHostPrefix/products?barcode=$barcode');
    var res = await http.get(uri);
    if (res.statusCode == 422) {
      return null;
    }

    return ProductApi.fromDynamic(jsonDecode(res.body));
  }

  static ProductApi fromDynamic(dynamic json) {
    return ProductApi(
      id: json["id"],
      code: json["code"],
      name: json["name"],
    );
  }
}
