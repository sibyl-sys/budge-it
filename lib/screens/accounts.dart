import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountsTab.dart';
import 'package:intl/intl.dart';

class Accounts extends StatefulWidget {


  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {

  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  String _value = 'all';
  TabBar get _tabBar => TabBar(
    indicatorColor: Colors.teal[500],
    labelColor: Theme.of(context).primaryColor,
    unselectedLabelColor: Colors.grey,
    tabs: [
      Tab(
          text: 'Accounts'
      ),
      Tab(
          text: 'Debts'
      ),
      Tab(
        icon: Icon(Icons.analytics),
      )
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Container(
        child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                ColoredBox(
                    color: Colors.white,
                    child: _tabBar
                ),
                Expanded(
                  child: TabBarView(
                      children: [
                        AccountsTab(
                          onAccountTapped: (int accountIndex) {
                            Navigator.pushNamed(context, "/accountDetails", arguments : {'accountIndex': accountIndex});
                          },
                        ),
                        AccountsTab(),
                        AccountsTab(),
                      ]
                  ),
                )
              ],
          )
        )
      ),
    );
  }
}
