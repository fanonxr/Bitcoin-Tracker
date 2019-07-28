import 'dart:convert';
import 'package:http/http.dart' as http;

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

const bitcoinAverageUrl = 'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  // get the data from the api
  Future getCoinData(String selectedCurrency) async {
    // loop through the crypto list and make a request -> store the date in a map
    Map<String, String> cryptoPrices= {};

    for (String crypto in cryptoList) {
      // update the request url in order to get correct data
      String requestURL = '$bitcoinAverageUrl/$crypto$selectedCurrency';
      http.Response response = await http.get(requestURL);

      // check if valid request
      if (response.statusCode == 200) {
        // successful
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['last'];

        // store the price with its type of currency
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        // unsuccessful
        print(response.statusCode);
        throw 'Problem with the get request';
      }

    }
    // returns the map of the crypto price
    return cryptoPrices;
  }
}