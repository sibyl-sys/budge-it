import 'dart:html';

import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accounts.dart';
import 'package:money_tracker/screens/overview.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/addTransaction.dart';
import 'package:money_tracker/screens/categories.dart';
import 'package:money_tracker/screens/newAccount.dart';
import 'package:money_tracker/screens/transactions.dart';
import 'package:money_tracker/services/account.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/budgeitNav.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


Future<void> _selectAccountType(BuildContext context) async {
  switch (await showDialog<AccountType>(
      context: context,
      builder: (BuildContext context) {
        return AccountsType();
      })) {
    case AccountType.wallet:
      Navigator.of(context).push(
          PageRouteBuilder(
            barrierColor: Colors.black.withOpacity(0.25),
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (_, __, ___) => NewAccount(accountType: AccountType.wallet),
          )
      );
      break;
    case AccountType.savings:
      Navigator.of(context).push(
          PageRouteBuilder(
            barrierColor: Colors.black.withOpacity(0.25),
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (_, __, ___) => NewAccount(accountType: AccountType.savings),
          )
      );
      break;
    case AccountType.debt:
      Navigator.of(context).push(
          PageRouteBuilder(
            barrierColor: Colors.black.withOpacity(0.25),
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (_, __, ___) => NewAccount(accountType: AccountType.debt),
          )
      );
      break;
  }
}

class _HomeState extends State<Home> {
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  int _selectedIndex = 0;

  List<Widget> _bodyOptions = [
    Accounts(),
    Categories(),
    Transactions(),
    Overview(),
    Text(
        'Add Transaction'
    ),
  ];

  List<String> _headerOptions = [
    "Accounts",
    "Categories",
    "Transactions",
    "Overview"
  ];

  Widget generateAppbarAction(int index) {
    if(index == 1) {
      return IconButton(
          icon: Icon(Icons.edit),
          onPressed: (){
            Navigator.of(context).pushNamed("/rearrangeCategories");
          });
    } else if(index == 2) {
      return SizedBox(height: 0);
    } else {
      return IconButton(
        icon: Icon(Icons.add),
        onPressed: (){
          _selectAccountType(context);
        });
    }
  }

  void _onItemTapped(int index) {
    if(index == 4) {

      final user = context.read<User>();
      //TODO POPUP ADD ACCOUNT
      if(user.accounts.length > 0) {
        Navigator.of(context).push(
            PageRouteBuilder(
              barrierColor: Colors.black.withOpacity(0.25),
              barrierDismissible: true,
              opaque: false,
              pageBuilder: (_, __, ___) => AddTransaction(),
            )
        );
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    return Scaffold(
      appBar: AppBar(
          actions: [
            generateAppbarAction(_selectedIndex)
          ],
          title: Text(
            _headerOptions[_selectedIndex],
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500
            ),
          ),
          //TODO CHANGE ACTION DEPENDING ON TAB
      ),
      drawer: BudgeitNav(),
      body: _bodyOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Accounts'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.donut_large),
              label: 'Categories'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Transactions'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Overview'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Transaction'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[600],
        unselectedItemColor: Colors.grey[400],
        onTap: _onItemTapped,
      ),
    );
  }
}
