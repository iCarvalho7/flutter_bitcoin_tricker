import 'dart:convert';
import 'package:bitcoin_ticker/data/networkhelper.dart';
import 'package:flutter/material.dart';
import '../utils/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'components/PriceCard.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCoin = 'USD';
  List<int> rateList = [];
  List<Widget> widgetList = [];

  DropdownButton getCurrentListItems() {
    addElements();
    List<DropdownMenuItem<String>> dropDownItems = [];

    currenciesList.forEach((element) {
      var newItem = DropdownMenuItem(
        child: Text(element),
        value: element,
      );
      dropDownItems.add(newItem);
    });

    return DropdownButton(
      value: selectedCoin,
      items: dropDownItems,
      onChanged: (value) {
        selectedCoin = value;
        getData(value, cryptoList);
        rateList.clear();
      },
    );
  }

  CupertinoPicker getPickerItems() {
    addElements();
    List<Widget> list = [];
    for (String currency in currenciesList) {
      list.add(Text(currency));
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (index) {
          var country = currenciesList[index];
          getData(country, cryptoList);
          print(index);
          rateList.clear();
        },
        children: list);
  }

  @override
  void initState() {
    super.initState();
    addElements();
    getData(selectedCoin, cryptoList);
  }

  void addElements() {
    widgetList.clear();
    cryptoList.forEach((element){
      var index = cryptoList.indexOf(element);
      try{
        rateList[index];
        widgetList.add(PriceCardContainer(rate: rateList[index].toString(), coinType: cryptoList[index], selectedCoin: selectedCoin));
      }catch(e){
        widgetList.add(PriceCardContainer(rate: "...", coinType: cryptoList[index], selectedCoin: selectedCoin));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widgetList,
            ),
          ),

          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS
                  ? getCurrentListItems()
                  : getPickerItems()),
        ],
      ),
    );
  }

  void getData(String value, List<String> currentsCoin) async {
    for(var coin in currentsCoin){
      print(coin);
      var networkHelper = NetworkHelper(country: value, coinType: coin);
      var response = await networkHelper.getDataFromAPI();
      upDateUI(response);
    }
  }

  void upDateUI(response) {
    setState(() {
      var rate = jsonDecode(response)["rate"].toInt();
      rateList.add(rate);
    });
  }
}
