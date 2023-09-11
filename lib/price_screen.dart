import 'package:bitcoin_ticker_flut/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedOption = 'USD';
  String bitCoinValueIn = '?';
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  Future getCoinValue() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedOption);
      isWaiting = false;

      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  DropdownButton getDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currencyList in currenciesList) {
      String currency = currencyList;

      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropdownItems.add(newItem);
    }
    return DropdownButton(
        value: selectedOption,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedOption = value!;
            getCoinValue();
          });
          print(selectedOption);
        });
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(
        Text(currency),
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedOption = currenciesList[selectedIndex];
        getCoinValue();
      },
      children: pickerItems,
    );
  }

  Column makeCryptoCards() {
    List<CyrptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CyrptoCard(
          cryptoCurrency: crypto,
          bitCoinValue: isWaiting ? bitCoinValueIn : coinValues[crypto] ?? '',
          selectedOpt: selectedOption,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCoinValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCryptoCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : getDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class CyrptoCard extends StatelessWidget {
  const CyrptoCard({
    super.key,
    required this.cryptoCurrency,
    required this.bitCoinValue,
    required this.selectedOpt,
  });

  final String bitCoinValue;
  final String selectedOpt;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 11.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $bitCoinValue $selectedOpt',
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
