import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart'; // SystemChrome

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

//void main() {
//  // Forbid Landscape mode!!!
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//  runApp(MyApp());
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temp Time Tracker',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
          errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    _userTransactions.sort((a,b) {
      if (a.flagDivider || b.flagDivider) {
        a.date.add(Duration(seconds: 1));
        b.date.add(Duration(seconds: 1));
      }
      return b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch;
    });
    return _userTransactions;
  }

  void _addNewTransaction(
      String txTitle, String txDescription, double txAmount, DateTime chosenDate) {

    List<Transaction> compare = _userTransactions.where((tx) {
      return tx.getDateFormatDM(chosenDate) == tx.dateFormatDM && tx.flagDivider;
    }).toList();

    print(compare.toString());
    print(compare.isNotEmpty);

    var rand = Random();
    final Transaction headerDivider = Transaction.headerDivider(
      date: chosenDate,
      flagDivider: true,
    );
    final Transaction newTx = Transaction(
      title: txTitle,
      description: txDescription,
      amount: txAmount,
      date: chosenDate,
      id: '${DateTime.now().toString()}_${rand.nextInt(1000)}',
      flagDivider: false,
    );

    setState(() {
      if (compare.isEmpty) {
        _userTransactions.add(headerDivider);
      }
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((el) => el.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Temp Time Tracker',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Temp Time Tracker',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    final Widget txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    var pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
