import 'package:flutter/material.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/currency.dart';

final Map<String, List<IconData>> accountIconList = {
  "Accounts" : [
    Icons.account_balance_wallet,
    Icons.credit_card,
    Icons.account_balance,
    Icons.attach_money,
  ],
  "Categories" : [
    Icons.whatshot,
    Icons.shopping_cart_outlined,
    Icons.house
  ]
};

final List<Map<String, dynamic>> accountColorList = [
  {
    "name" : "Deep Purple",
    "shade" : 400,
    "value" :  Colors.deepPurple[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Purple",
    "shade" : 400,
    "value" :  Colors.purple[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Pink",
    "shade" : 400,
    "value" :  Colors.pink[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Red",
    "shade" : 400,
    "value" :  Colors.red[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Indigo",
    "shade" : 400,
    "value" :  Colors.indigo[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Blue",
    "shade" : 400,
    "value" :  Colors.blue[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Light Blue",
    "shade" : 400,
    "value" :  Colors.lightBlue[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Cyan",
    "shade" : 400,
    "value" :  Colors.cyan[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Teal",
    "shade" : 400,
    "value" :  Colors.teal[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Green",
    "shade" : 400,
    "value" :  Colors.green[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Light Green",
    "shade" : 400,
    "value" :  Colors.lightGreen[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Lime",
    "shade" : 400,
    "value" :  Colors.lime[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Deep Orange",
    "shade" : 400,
    "value" :  Colors.deepOrange[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Orange",
    "shade" : 400,
    "value" :  Colors.orange[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Amber",
    "shade" : 400,
    "value" :  Colors.amber[400],
    "isDarkIcon" : true
  },
  {
    "name" : "Yellow",
    "shade" : 400,
    "value" :  Colors.yellow[400],
    "isDarkIcon" : true
  },
  {
    "name" : "Brown",
    "shade" : 400,
    "value" :  Colors.brown[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Grey",
    "shade" : 400,
    "value" :  Colors.grey[400],
    "isDarkIcon" : false
  },
  {
    "name" : "Black",
    "shade" : 400,
    "value" :  Colors.black54,
    "isDarkIcon" : false
  },
];

// final List<Map<String, dynamic>> accountColorList = [
//   {
//     "name" : "Red",
//     "shade" : 100,
//     "value" :  Colors.red[100],
//     "isDarkIcon" : true
//   },
//   {
//     "name" : "Orange",
//     "shade" : 100,
//     "value" :  Colors.orange[100],
//     "isDarkIcon" : true,
//   },
//   {
//     "name" : "Yellow",
//     "shade" : 100,
//     "value" :  Colors.yellow[100],
//     "isDarkIcon" : true,
//   },
//   {
//     "name" : "Green",
//     "shade" : 100,
//     "value" :  Colors.green[100],
//     "isDarkIcon" : true,
//   },
//   {
//     "name" : "Blue",
//     "shade" : 100,
//     "value" :  Colors.blue[100],
//     "isDarkIcon" : true,
//   },
//   {
//     "name" : "Purple",
//     "shade" : 100,
//     "value" :  Colors.purple[100],
//     "isDarkIcon" : true,
//   },
//   {
//     "name" : "Red",
//     "shade" : 200,
//     "value" :  Colors.red[200],
//     "isDarkIcon" : false
//   },
//   {
//     "name" : "Orange",
//     "shade" : 200,
//     "value" :  Colors.orange[200],
//     "isDarkIcon" : true,
//   },
//   {
//     "name" : "Yellow",
//     "shade" : 200,
//     "value" :  Colors.yellow[200],
//     "isDarkIcon" : true,
//   },
//   {
//     "name" : "Green",
//     "shade" : 200,
//     "value" :  Colors.green[200],
//     "isDarkIcon" : false,
//
//   },
//   {
//     "name" : "Blue",
//     "shade" : 200,
//     "value" :  Colors.blue[200],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Purple",
//     "shade" : 200,
//     "value" :  Colors.purple[200],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Red",
//     "shade" : 300,
//     "value" :  Colors.red[300],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Orange",
//     "shade" : 300,
//     "value" :  Colors.orange[300],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Yellow",
//     "shade" : 300,
//     "value" :  Colors.yellow[300],
//     "isDarkIcon" : true,
//   },
//   {
//     "name" : "Green",
//     "shade" : 300,
//     "value" :  Colors.green[300],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Blue",
//     "shade" : 300,
//     "value" :  Colors.blue[300],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Purple",
//     "shade" : 300,
//     "value" :  Colors.purple[300],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Red",
//     "shade" : 400,
//     "value" :  Colors.red[400],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Orange",
//     "shade" : 400,
//     "value" :  Colors.orange[400],
//     "isDarkIcon" : false,
//
//   },
//   {
//     "name" : "Yellow",
//     "shade" : 400,
//     "value" :  Colors.yellow[400],
//     "isDarkIcon" : true,
//   },
//   {
//     "name" : "Green",
//     "shade" : 400,
//     "value" :  Colors.green[400],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Blue",
//     "shade" : 400,
//     "value" :  Colors.blue[400],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Purple",
//     "shade" : 400,
//     "value" :  Colors.purple[400],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Red",
//     "shade" : 500,
//     "value" :  Colors.red[500],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Orange",
//     "shade" : 500,
//     "value" :  Colors.orange[500],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Yellow",
//     "shade" : 500,
//     "value" :  Colors.yellow[500],
//     "isDarkIcon" : true,
//   },
//   {
//     "name" : "Green",
//     "shade" : 500,
//     "value" :  Colors.green[500],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Blue",
//     "shade" : 500,
//     "value" :  Colors.blue[500],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Purple",
//     "shade" : 500,
//     "value" :  Colors.purple[500],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Red",
//     "shade" : 600,
//     "value" :  Colors.red[600],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Orange",
//     "shade" : 600,
//     "value" :  Colors.orange[600],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Yellow",
//     "shade" : 600,
//     "value" :  Colors.yellow[600],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Green",
//     "shade" : 600,
//     "value" :  Colors.green[600],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Blue",
//     "shade" : 600,
//     "value" :  Colors.blue[600],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Purple",
//     "shade" : 600,
//     "value" :  Colors.purple[600],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Red",
//     "shade" : 700,
//     "value" :  Colors.red[700],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Orange",
//     "shade" : 700,
//     "value" :  Colors.orange[700],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Yellow",
//     "shade" : 700,
//     "value" :  Colors.yellow[700],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Green",
//     "shade" : 700,
//     "value" :  Colors.green[700],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Blue",
//     "shade" : 700,
//     "value" :  Colors.blue[700],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Purple",
//     "shade" : 700,
//     "value" :  Colors.purple[700],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Red",
//     "shade" : 800,
//     "value" :  Colors.red[800],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Orange",
//     "shade" : 800,
//     "value" :  Colors.orange[800],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Yellow",
//     "shade" : 800,
//     "value" :  Colors.yellow[800],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Green",
//     "shade" : 800,
//     "value" :  Colors.green[800],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Blue",
//     "shade" : 800,
//     "value" :  Colors.blue[800],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Purple",
//     "shade" : 800,
//     "value" :  Colors.purple[800],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Red",
//     "shade" : 900,
//     "value" :  Colors.red[900],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Orange",
//     "shade" : 900,
//     "value" :  Colors.orange[900],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Yellow",
//     "shade" : 900,
//     "value" :  Colors.yellow[900],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Green",
//     "shade" : 900,
//     "value" :  Colors.green[900],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Blue",
//     "shade" : 900,
//     "value" :  Colors.blue[900],
//     "isDarkIcon" : false,
//   },
//   {
//     "name" : "Purple",
//     "shade" : 900,
//     "value" :  Colors.purple[900],
//     "isDarkIcon" : false,
//   },
// ];

final List<Category> categoryDefault = [
  Category(color: Colors.green[800].value, categoryType: CategoryType.expense, icon: Icons.shopping_cart_outlined.codePoint, name: "Shopping", categoryID: 0, index: 0, subcategories: []),
  Category(color: Colors.blue[800].value, categoryType: CategoryType.expense, icon: Icons.fastfood.codePoint, name: "Restaurant", categoryID: 1, index: 1, subcategories: []),
  Category(color: Colors.red[800].value, categoryType: CategoryType.expense, icon: Icons.local_movies.codePoint, name: "Leisure", categoryID: 2, index: 2, subcategories: []),
  Category(color: Colors.yellow[800].value, categoryType: CategoryType.expense, icon: Icons.directions_bus.codePoint, name: "Transport", categoryID: 3, index: 3, subcategories: []),
  Category(color: Colors.green[400].value, categoryType: CategoryType.expense, icon: Icons.healing.codePoint, name: "Health", categoryID: 4, index: 4, subcategories: []),
  Category(color: Colors.orange[800].value, categoryType: CategoryType.expense, icon: Icons.wallet_giftcard.codePoint, name: "Gifts", categoryID: 5, index: 5, subcategories: []),
  Category(color: Colors.blue[300].value, categoryType: CategoryType.expense, icon: Icons.pets.codePoint, name: "Pet", categoryID: 6, index: 6, subcategories: []),
  Category(color: Colors.green[300].value, categoryType: CategoryType.income, icon: Icons.money.codePoint, name: "Salary", categoryID: 7, index: 7, subcategories: []),
  Category(color: Colors.green[600].value, categoryType: CategoryType.income, icon: Icons.receipt.codePoint, name: "Reimbursements", categoryID: 8, index:8, subcategories: []),
  Category(color: Colors.grey.value, categoryType: CategoryType.expense, icon: Icons.adjust.codePoint, name: "Untracked", categoryID: 9, index: 9, subcategories: []),
];

final List<Currency> currencyList = [
  Currency(name: "United States dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Philippine peso", symbol: "₱", exchangeRateToUSD: 0.0207),
  Currency(name: "Australian dollar", symbol: "\$", exchangeRateToUSD: 0.7632),
  Currency(name: "British pound", symbol: "£", exchangeRateToUSD: 1.379099),
  Currency(name: "Euro", symbol: "€", exchangeRateToUSD: 1.18245),
  Currency(name: "Canadian dollar", symbol: "\$", exchangeRateToUSD: 0.793035),
  Currency(name: "Chinese yuan", symbol: "¥", exchangeRateToUSD: 0.15287),
  Currency(name: "Japanese yen", symbol: "¥", exchangeRateToUSD: 0.009123),
  Currency(name: "Korean won", symbol: "₩", exchangeRateToUSD: 1.18245),
];