import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

const String _apikey = "A6CD148F-7A1F-4909-8CD9-BC37606033D7";
const String _base_url = "https://rest.coinapi.io/v1/exchangerate";

class NetworkHelper{

  NetworkHelper({this.country, this.coinType});

  Map<String, String> get headers => {
    "X-CoinAPI-Key": "$_apikey",
  };

  String coinType;
  String country;

  Future<dynamic> getDataFromAPI() async {
    try {
        print("url: $_base_url/$coinType/$country");
        var response = await http.get("$_base_url/$coinType/$country", headers: headers);

        print("body: ${response.statusCode}");
        print("body: ${response.body}");
        return response.body;
    }catch(e){
      print(e);
    }
  }
}