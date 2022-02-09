//https://api.coingecko.com/api/v3/coins/
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double> getPrice(String id) async {
  try {
    var apiEndpoint = "https://api.coingecko.com/api/v3/coins/" + id;
    final Uri url = Uri.parse(apiEndpoint);
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    var value = json['market_data']['current_price']['usd'].toString();
    return double.parse(value);
  } catch (e) {
    print(e.toString());
    return 0.0;
  }
}
