import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './Widgets/chart.dart';
import './Widgets/new_transaction.dart';
import './Widgets/transactions_list.dart';
import 'models/transactions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Expenses',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput = '';
  // String amountInput = '';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
    // Transaction(
    //   't1',
    //   'Shoes',
    //   30,
    //   DateFormat.yMMMMd().format(DateTime.now()),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    var getTransactions = _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    });
    return getTransactions.toList();
  }

  void _addNewTransactions(String txTitle, double txAmt, DateTime chosenDate) {
    final newTx = Transaction(
      DateTime.now().toString(),
      txTitle,
      txAmt,
      chosenDate,
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      return _userTransaction.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransactions);
      },
    );
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var _mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text('Shopping Expenses'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart '),
                  Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                    activeColor: Theme.of(context).accentColor,
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (_mediaQuery.size.height -
                        appBar.preferredSize.height -
                        _mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape)
              Container(
                height: (_mediaQuery.size.height -
                        appBar.preferredSize.height -
                        _mediaQuery.padding.top) *
                    0.7,
                child: TransactionList(_userTransaction, _deleteTransaction),
              ),
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (_mediaQuery.size.height -
                              appBar.preferredSize.height -
                              _mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : Container(
                      height: (_mediaQuery.size.height -
                              appBar.preferredSize.height -
                              _mediaQuery.padding.top) *
                          0.7,
                      child:
                          TransactionList(_userTransaction, _deleteTransaction),
                    ),
          ],
        ),
      ),
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
