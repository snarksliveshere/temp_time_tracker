import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return transaction.flagDivider
        ? Container(
            width: double.infinity,
            margin: EdgeInsets.only(top:20.0, left: 20.0, right: 20.0),
            padding: EdgeInsets.only(bottom: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColorLight,
                  width: 1.0,
                  style: BorderStyle.solid
                ),
              ),
            ),
            child: Text(
              transaction.dateFormatDM,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Card(
            elevation: 5.0,
            margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 5,
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      '\$${transaction.amount.toStringAsFixed(2)}',
                    ),
                  ),
                ),
              ),
              title: Text(
                transaction.title,
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(transaction.date),
              ),
              trailing: MediaQuery.of(context).size.width > 360
                  ? FlatButton.icon(
                      onPressed: () => this.deleteTx(transaction.id),
                      textColor: Theme.of(context).errorColor,
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => this.deleteTx(transaction.id),
                    ),
            ),
          );
  }
}
