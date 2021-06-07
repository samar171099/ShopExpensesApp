import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransaction;
  final Function _deleteTransac;

  TransactionList(this._userTransaction, this._deleteTransac);


  @override
  Widget build(BuildContext context) {

    return _userTransaction.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Container(
                  height: constraints.maxHeight * 0.15,
                  child: Text(
                    'Nothing to show',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.05,
                ),
                Container(
                  height: constraints.maxHeight * 0.5,
                  child: Image.asset(
                    'assets/image/waiting.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: FittedBox(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Rs ${_userTransaction[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    _userTransaction[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(_userTransaction[index].date),
                  ),
                  trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () =>
                              _deleteTransac(_userTransaction[index].id),
                        ),
                ),
              );
            },
            itemCount: _userTransaction.length,
          );
  }
}
