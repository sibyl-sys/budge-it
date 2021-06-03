import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountDetails.dart';
import 'package:money_tracker/screens/accounts.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/editAccount.dart';
import 'package:money_tracker/screens/home.dart';
import 'package:money_tracker/screens/loading.dart';
import 'package:money_tracker/screens/newAccount.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => User(),
      child:MaterialApp(
        initialRoute: "/loading",
        routes: {
          '/home' : (context) => Home(),
          '/newAccount' : (context) => NewAccount(),
          '/accountType' : (context) => AccountsType(),
          '/loading': (context) => LoadingScreen(),
          '/accountDetails' : (context) => AccountDetails(),
        },
        theme: ThemeData(
          primaryColor: Color(0x3C3A5F).withOpacity(1.0),
          accentColor: Colors.red[500]
        )
      )
  ));
}