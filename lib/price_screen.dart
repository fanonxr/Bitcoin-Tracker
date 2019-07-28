import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  // property of selected currency
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropDown() {

    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      // get the string curr in the list
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      // add the drop down items to the new list
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        // update the selected currency
        setState(
          () {
            selectedCurrency = value;
            // get data when the dropdown changes
            getData();
          },
        );
      },
    );
  }

  // cupertino picker - will use for IOS
  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      var item = Text(currency);
      pickerItems.add(item);
    }

    return CupertinoPicker(
      backgroundColor: Colors.green,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          // save the selectedIndex -> curr
          selectedCurrency = currenciesList[selectedIndex];
          // call get data to update with selected currency
          getData();
        });
      },
      children: pickerItems,
    );
  }

  // store the prices in a map
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  // method to get data from api and make the request
  String bitcoinValueInUSD = '?';

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency); // this is a map
      isWaiting = false;
      // update the state
      setState(() {
       coinValues = data;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  // as soon as the app loads, update the state with the data fetch from the API
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            cryptoCurrency: 'BTC',
            value: isWaiting ? '?' : coinValues['BTC'],
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: 'ETH',
            value: isWaiting ? '?' : coinValues['ETH'],
            selectedCurrency: selectedCurrency,
          ),
          CryptoCard(
            cryptoCurrency: 'LTC',
            value: isWaiting ? '?' : coinValues['LTC'],
            selectedCurrency: selectedCurrency,
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.green,
              child: Platform.isIOS ? iosPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

// make a crypto card that will hold the data for mutiple currencys
class CryptoCard extends StatelessWidget {

  CryptoCard({this.value, this.selectedCurrency, this.cryptoCurrency});

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.green,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
