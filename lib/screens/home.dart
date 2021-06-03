import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accounts.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/addTransaction.dart';
import 'package:money_tracker/screens/categories.dart';
import 'package:money_tracker/screens/transactions.dart';
import 'package:money_tracker/services/account.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/user.dart';
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
      Navigator.pushNamed(context, "/newAccount");
      break;
    case AccountType.savings:
      break;
    case AccountType.debt:
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
    Text(
        'Overview'
    ),
    Text(
        'Add Transaction'
    ),
  ];

  void _onItemTapped(int index) {
    if(index == 4) {
       Navigator.of(context).push(
          PageRouteBuilder(
            barrierColor: Colors.black.withOpacity(0.25),
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (_, __, ___) => AddTransaction(),
          )
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
    //TODO NAVIGATE WHEN ADD TRANSACTION
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    user.getTransactions(
      month: DateTime.now().month,
      year: DateTime.now().year,
      accountID: 0
    );
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 75,
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  _selectAccountType(context);
                })
          ],
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TOTAL NET:',
                      style: TextStyle(
                          fontSize: 12.0
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '${user.primaryCurrency.symbol} ${moneyFormat.format(user.totalNet)}',
                      style: TextStyle(
                          fontSize: 24.0
                      ),
                    )
                  ]
              )

              // DropdownButton(
              //     value: _value,
              //     items: [
              //       DropdownMenuItem(
              //           child: new Text(
              //             'All Accounts',
              //             style: TextStyle(
              //               color: Colors.white,
              //             )
              //           ),
              //           value: 'all'
              //       ),
              //       DropdownMenuItem(
              //           child: new Text('Others',
              //               style: TextStyle(
              //                 color: Colors.white,
              //               )
              //           ),
              //           value: 'others',
              //
              //       )
              //     ],
              //     underline: SizedBox(height: 0),
              //     onChanged: (String value) {
              //       setState(() => _value = value);
              //     },
              //     icon: Icon(
              //       Icons.arrow_drop_down,
              //       color: Colors.white
              //     ),
              //     dropdownColor: Colors.blue,
              //   ),
            ],
          ),
          //TODO CHANGE ACTION DEPENDING ON TAB
          leading: FlatButton(
            child: Icon(
                Icons.menu,
                color: Colors.white
            ),
          ),
      ),
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
