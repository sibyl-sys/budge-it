import 'package:flutter/material.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/currency.dart';

final Map<String, List<IconData>> accountIconList = {
  "Accounts" : [
    Icons.account_balance_wallet_outlined,
    Icons.credit_card_outlined,
    Icons.account_balance_outlined,
    Icons.attach_money_outlined,
  ],
  "Categories" : [
    Icons.whatshot_outlined,
    Icons.shopping_cart_outlined,
    Icons.house_outlined
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
  Category(color: Colors.green[400].value, categoryType: CategoryType.expense, icon: Icons.shopping_cart_outlined.codePoint, name: "Shopping", categoryID: 0, index: 0, subcategories: []),
  Category(color: Colors.blue[400].value, categoryType: CategoryType.expense, icon: Icons.fastfood.codePoint, name: "Restaurant", categoryID: 1, index: 1, subcategories: []),
  Category(color: Colors.red[400].value, categoryType: CategoryType.expense, icon: Icons.local_movies.codePoint, name: "Leisure", categoryID: 2, index: 2, subcategories: []),
  Category(color: Colors.yellow[400].value, categoryType: CategoryType.expense, icon: Icons.directions_bus.codePoint, name: "Transport", categoryID: 3, index: 3, subcategories: []),
  Category(color: Colors.teal[400].value, categoryType: CategoryType.expense, icon: Icons.healing.codePoint, name: "Health", categoryID: 4, index: 4, subcategories: []),
  Category(color: Colors.brown[400].value, categoryType: CategoryType.expense, icon: Icons.wallet_giftcard.codePoint, name: "Gifts", categoryID: 5, index: 5, subcategories: []),
  Category(color: Colors.deepPurple[400].value, categoryType: CategoryType.expense, icon: Icons.pets.codePoint, name: "Pet", categoryID: 6, index: 6, subcategories: []),
  Category(color: Colors.lightGreen[400].value, categoryType: CategoryType.income, icon: Icons.money.codePoint, name: "Salary", categoryID: 7, index: 7, subcategories: []),
  Category(color: Colors.lime[400].value, categoryType: CategoryType.income, icon: Icons.receipt.codePoint, name: "Reimbursements", categoryID: 8, index:8, subcategories: []),
  Category(color: Colors.grey.value, categoryType: CategoryType.expense, icon: Icons.adjust.codePoint, name: "Untracked", categoryID: 9, index: 9, subcategories: []),
];

final List<Currency> currencyList = [
  Currency(name: "United States Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Philippine Peso", symbol: "₱", exchangeRateToUSD: 0.0207),
  Currency(name: "Albania Lek", symbol: "LEK", exchangeRateToUSD: 1),
  Currency(name: "Afghanistan Afghani", symbol: "؋", exchangeRateToUSD: 1),
  Currency(name: "Argentina Peso", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Aruba Guilder", symbol: "ƒ", exchangeRateToUSD: 1),
  Currency(name: "Australia dollar", symbol: "\$", exchangeRateToUSD: 0.7632),
  Currency(name: "Azerbaijan Manat", symbol: "₼", exchangeRateToUSD: 1),
  Currency(name: "Bahamas Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Barbados Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Belarus Ruble", symbol: "Br", exchangeRateToUSD: 1),
  Currency(name: "Belize Dollar", symbol: "BZ\$", exchangeRateToUSD: 1),
  Currency(name: "Bermuda Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Bolivia Bolíviano", symbol: "\$b", exchangeRateToUSD: 1),
  Currency(name: "Bosnia and Herzegovina Convertible Mark", symbol: "KM", exchangeRateToUSD: 1),
  Currency(name: "Botswana Pula", symbol: "P", exchangeRateToUSD: 1),
  Currency(name: "Bulgaria Lev", symbol: "лв", exchangeRateToUSD: 1),
  Currency(name: "Brazil Real", symbol: "R\$", exchangeRateToUSD: 1),
  Currency(name: "Brunei Darussalam Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Cambodia Riel", symbol: "៛", exchangeRateToUSD: 1),
  Currency(name: "Canada Dollar", symbol: "\$", exchangeRateToUSD: 0.793035),
  Currency(name: "Cayman Islands Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Chile Peso", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "China Yuan Renminbi", symbol: "¥", exchangeRateToUSD: 0.15287),
  Currency(name: "Colombia Peso", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Costa Rica Colon", symbol: "₡", exchangeRateToUSD: 1),
  Currency(name: "Croatia Kuna", symbol: "kn", exchangeRateToUSD: 1),
  Currency(name: "Cuba Peso", symbol: "₱", exchangeRateToUSD: 1),
  Currency(name: "Czech Republic Koruna", symbol: "Kč", exchangeRateToUSD: 1),
  Currency(name: "Denmark Krone", symbol: "kr", exchangeRateToUSD: 1),
  Currency(name: "Dominican Republic Peso", symbol: "RD\$", exchangeRateToUSD: 1),
  Currency(name: "East Caribbean Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Egypt Pound", symbol: "£", exchangeRateToUSD: 1),
  Currency(name: "El Salvador Colon", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Euro Member Countries", symbol: "€", exchangeRateToUSD: 1.18245),
  Currency(name: "Falkland Islands (Malvinas) Pound", symbol: "£", exchangeRateToUSD: 1),
  Currency(name: "Fiji Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Ghana Cedi", symbol: "¢", exchangeRateToUSD: 1),
  Currency(name: "Gibraltar Pound", symbol: "£", exchangeRateToUSD: 1),
  Currency(name: "Guyana Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Honduras Lempira", symbol: "L", exchangeRateToUSD: 1),
  Currency(name: "Hong Kong Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Hungary Forint", symbol: "Ft", exchangeRateToUSD: 1),
  Currency(name: "Iceland Krona", symbol: "kr", exchangeRateToUSD: 1),
  Currency(name: "India Rupee", symbol: "₹", exchangeRateToUSD: 1),
  Currency(name: "Indonesia Rupiah", symbol: "Rp", exchangeRateToUSD: 1),
  Currency(name: "Iran Rial", symbol: "﷼", exchangeRateToUSD: 1),
  Currency(name: "Isle of Man Pound", symbol: "£", exchangeRateToUSD: 1),
  Currency(name: "Israel Shekel", symbol: "₪", exchangeRateToUSD: 1),
  Currency(name: "Jamaica Dollar", symbol: "J\$", exchangeRateToUSD: 1),
  Currency(name: "Japan Yen", symbol: "¥", exchangeRateToUSD: 0.009123),
  Currency(name: "Jersey Pound", symbol: "£", exchangeRateToUSD: 1),
  Currency(name: "Kazakhstan Tenge", symbol: "лв", exchangeRateToUSD: 1),
  Currency(name: "Korea Won", symbol: "₩", exchangeRateToUSD: 1.18245),
  Currency(name: "Kyrgyzstan Som", symbol: "лв", exchangeRateToUSD: 1),
  Currency(name: "Laos Kip", symbol: "₭", exchangeRateToUSD: 1),
  Currency(name: "Lebanon Pound", symbol: "£", exchangeRateToUSD: 1),
  Currency(name: "Liberia Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Macedonia Denar", symbol: "ден", exchangeRateToUSD: 1),
  Currency(name: "Malaysia Ringgit", symbol: "RM", exchangeRateToUSD: 1),
  Currency(name: "Mauritius Rupee", symbol: "Rs", exchangeRateToUSD: 1),
  Currency(name: "Mexico Peso", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Mongolia Tughrik", symbol: "₮", exchangeRateToUSD: 1),
  Currency(name: "Moroccan-dirham", symbol: "د.إ", exchangeRateToUSD: 1),
  Currency(name: "Mozambique Metical", symbol: "MT", exchangeRateToUSD: 1),
  Currency(name: "Namibia Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Nepal Rupee", symbol: "₨", exchangeRateToUSD: 1),
  Currency(name: "Netherlands Antilles Guilder", symbol: "ƒ", exchangeRateToUSD: 1),
  Currency(name: "New Zealand Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Nicaragua Cordoba", symbol: "C\$", exchangeRateToUSD: 1),
  Currency(name: "Nigeria Naira", symbol: "₦", exchangeRateToUSD: 1),
  Currency(name: "Norway Krone", symbol: "kr", exchangeRateToUSD: 1),
  Currency(name: "Oman Rial", symbol: "﷼", exchangeRateToUSD: 1),
  Currency(name: "Pakistan Rupee", symbol: "Rs", exchangeRateToUSD: 1),
  Currency(name: "Panama Balboa", symbol: "B/.", exchangeRateToUSD: 1),
  Currency(name: "Paraguay Guarani", symbol: "Gs", exchangeRateToUSD: 1),
  Currency(name: "Peru Sol", symbol: "S/.", exchangeRateToUSD: 1),
  Currency(name: "Poland Zloty", symbol: "zł", exchangeRateToUSD: 1),
  Currency(name: "Qatar Riyal", symbol: "﷼", exchangeRateToUSD: 1),
  Currency(name: "Romania Leu", symbol: "lei", exchangeRateToUSD: 1),
  Currency(name: "Russia Ruble", symbol: "₽", exchangeRateToUSD: 1),
  Currency(name: "Saint Helena Pound", symbol: "£", exchangeRateToUSD: 1),
  Currency(name: "Saudi Arabia Riyal", symbol: "﷼", exchangeRateToUSD: 1),
  Currency(name: "Serbia Dinar", symbol: "Дин.", exchangeRateToUSD: 1),
  Currency(name: "Seychelles Rupee", symbol: "Rs", exchangeRateToUSD: 1),
  Currency(name: "Singapore Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Solomon Islands Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Somalia Shilling", symbol: "S", exchangeRateToUSD: 1),
  Currency(name: "South Africa Rand", symbol: "R", exchangeRateToUSD: 1),
  Currency(name: "Sri Lanka Rupee", symbol: "₨", exchangeRateToUSD: 1),
  Currency(name: "Sweden Krona", symbol: "kr", exchangeRateToUSD: 1),
  Currency(name: "Switzerland Franc", symbol: "CHF", exchangeRateToUSD: 1),
  Currency(name: "Suriname Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Syria Pound", symbol: "£", exchangeRateToUSD: 1),
  Currency(name: "Taiwan New Dollar", symbol: "NT\$", exchangeRateToUSD: 1),
  Currency(name: "Thailand Baht", symbol: "฿", exchangeRateToUSD: 1),
  Currency(name: "Trinidad and Tobago Dollar", symbol: "TT\$", exchangeRateToUSD: 1),
  Currency(name: "Turkey Lira", symbol: "₺", exchangeRateToUSD: 1),
  Currency(name: "Tuvalu Dollar", symbol: "\$", exchangeRateToUSD: 1),
  Currency(name: "Ukraine Hryvnia", symbol: "₴", exchangeRateToUSD: 1),
  Currency(name: "UAE-Dirham", symbol: "د.إ", exchangeRateToUSD: 1),
  Currency(name: "United Kingdom Pound", symbol: "£", exchangeRateToUSD: 1.379099),
  Currency(name: "Uruguay Peso", symbol: "\$U", exchangeRateToUSD: 1),
  Currency(name: "Uzbekistan Som", symbol: "лв", exchangeRateToUSD: 1),
  Currency(name: "Venezuela Bolívar", symbol: "Bs", exchangeRateToUSD: 1),
  Currency(name: "Viet Nam Dong", symbol: "₫", exchangeRateToUSD: 1),
  Currency(name: "Yemen Rial", symbol: "﷼", exchangeRateToUSD: 1),
  Currency(name: "Zimbabwe Dollar", symbol: "Z\$", exchangeRateToUSD: 1),
];