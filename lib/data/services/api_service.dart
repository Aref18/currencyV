import 'package:currencyv/core/constants/api_constant.dart';
import 'package:currencyv/data/model/arz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ApiService {
  static Future<List<Arzcurrency>> fetchCurrencies() async {
    final response = await http.get(Uri.parse(ApiConstants.apiUrl));
    if (response.statusCode == 200) {
      List jsonList = convert.jsonDecode(response.body);
      return jsonList
          .map(
            (json) => Arzcurrency(
              id: json['id'],
              title: json['title'],
              price: json['price'],
              changes: json['changes'],
              status: json['status'],
            ),
          )
          .toList();
    }
    return [];
  }
}
