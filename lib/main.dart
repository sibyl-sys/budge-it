import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountDetails.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/addCategory.dart';
import 'package:money_tracker/screens/home.dart';
import 'package:money_tracker/screens/loading.dart';
import 'package:money_tracker/screens/newAccount.dart';
import 'package:money_tracker/screens/rearrangeCategories.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => User(),
      child:MaterialApp(
        initialRoute: "/loading",
        routes: {
          '/home' : (context) => Home(),
          '/newAccount' : (context) => NewAccount(accountType: AccountType.wallet),
          '/addCategory' : (context) => AddCategory(),
          '/accountType' : (context) => AccountsType(),
          '/loading': (context) => LoadingScreen(),
          '/accountDetails' : (context) => AccountDetails(),
          '/rearrangeCategories' : (context) => RearrangeCategories(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Color(0x3C3A5F).withOpacity(1.0),
            secondary: Color(0xEB6467).withOpacity(1.0),
          ),
          primaryColor: Color(0x3C3A5F).withOpacity(1.0),
          fontFamily: 'Poppins'
        )
      )
  ));
}