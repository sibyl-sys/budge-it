import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accounts.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/addTransaction.dart';
import 'package:money_tracker/screens/categories.dart';
import 'package:money_tracker/screens/newAccount.dart';
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
    Text(
        'Overview'
    ),
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
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: Color(0xFFFBFBFB),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                  height: 68,
                  child: DrawerHeader(
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Budge-it",
                          style: TextStyle(
                            color: Color(0xFF5F5C96)
                          )
                        ),
                        Text(
                            "Cloud Saving Disabled",
                            style: TextStyle(
                              color: Color(0xFF55C9C6),
                              fontSize: 10
                            )
                        )
                      ],
                    ),
                  )
              ),
              ListTile(
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontSize: 12
                  ),
                ),
                tileColor: Color(0xFFFBFBFB),
                dense: true
              ),
              ListTile(
                title: Text("Jane Doe"),
                subtitle: Text('Premium Account', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.account_circle_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
                dense: true,
                tileColor: Colors.white,
              ),
              ListTile(
                  title: Text(
                    "General Settings",
                    style: TextStyle(
                        color: Color(0xFFB6B6B6),
                        fontSize: 12
                    ),
                  ),
                  tileColor: Color(0xFFFBFBFB),
                  dense: true
              ),
              ListTile(
                title: Text("Language"),
                subtitle: Text('English (Default)', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.translate_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                  title: Text("Currency"),
                  subtitle: Text('Philippine Peso (P)', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  minLeadingWidth: 0,
                  leading: Container(height: double.infinity, child: Icon(Icons.account_balance_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                  dense: true,
                  tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                  title: Text("Spend Alert"),
                  subtitle: Text('P 5,000.00', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  minLeadingWidth: 0,
                  leading: Container(height: double.infinity, child: Icon(Icons.speed_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                  dense: true,
                  tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                  title: Text("Date Format"),
                  subtitle: Text('Monday (Day 1)', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  minLeadingWidth: 0,
                  leading: Container(height: double.infinity, child: Icon(Icons.date_range_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                  dense: true,
                  tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                  title: Text("Start Screen"),
                  subtitle: Text('Transactions', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  minLeadingWidth: 0,
                  leading: Container(height: double.infinity, child: Icon(Icons.book_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                  dense: true,
                  tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                  title: Text("Reminder"),
                  subtitle: Text('5:00 PM', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  minLeadingWidth: 0,
                  leading: Container(height: double.infinity, child: Icon(Icons.notifications_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                  trailing: Switch(value: false, onChanged:(value) {}),
                  dense: true,
                  tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Passcode"),
                subtitle: Text('PIN', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.lock_outline, color: Color(0x3C3A5F).withOpacity(0.25))),
                trailing: Switch(value: false, onChanged:(value) {}),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Theme"),
                subtitle: Text('Light', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.invert_colors_on_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                trailing: Text("Coming Soon", style: TextStyle(fontSize: 11, color: Color(0xFFB6B6B6))),
                dense: true,
                tileColor: Colors.white,
              ),
              ListTile(
                  title: Text(
                    "More",
                    style: TextStyle(
                        color: Color(0xFFB6B6B6),
                        fontSize: 12
                    ),
                  ),
                  tileColor: Color(0xFFFBFBFB),
                  dense: true
              ),
              ListTile(
                title: Text("Budge-it 1.2.3"),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.apps, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Rate Us"),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.grade_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Contact Support"),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.mail_outline, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Privacy Policy"),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.policy_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
            ],
          )
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
