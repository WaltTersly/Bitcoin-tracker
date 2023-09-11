import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const coinDataApiKey = '2EEB8D2A-04CE-47BB-95FA-3EF2F9531B2F';
const coinDataUrl = 'https://rest.coinapi.io/v1/exchangerate';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      //created dynamic url
      var requestUrl = Uri.parse(
          '$coinDataUrl/$crypto/$selectedCurrency?apikey=$coinDataApiKey');

      http.Response response = await http.get(requestUrl);

      if (response.statusCode == 200) {
        // decode the JSON data
        var decodedData = convert.jsonDecode(response.body);
        // get last price
        double latestRate = decodedData['rate'];

        cryptoPrices[crypto] = latestRate.toStringAsFixed(1);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
