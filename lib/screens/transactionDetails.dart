import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountSelection.dart';
import 'package:money_tracker/screens/dateSelection.dart';
import 'package:money_tracker/screens/recipientSelection.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/services/favoriteTransaction.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransactionDetails extends StatefulWidget {
  final int transactionID;

  const TransactionDetails({Key? key, required this.transactionID})
      : super(key: key);

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  final TextEditingController notesController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  DateFormat dateFormatter = DateFormat('EEEE, MMMM dd, yyyy');

  String getToLabel(TransactionType transactionType) {
    if (transactionType == TransactionType.expense) {
      return "To Expense";
    } else if (transactionType == TransactionType.income) {
      return "To Income";
    } else {
      return "To Account";
    }
  }

  String getValueLabel(TransactionType transactionType) {
    if (transactionType == TransactionType.expense) {
      return "Expense";
    } else if (transactionType == TransactionType.income) {
      return "Income";
    } else {
      return "Transfer";
    }
  }

  Color getLabelColor(TransactionType transactionType) {
    if (transactionType == TransactionType.expense) {
      return Color(0xEB6467).withOpacity(1);
    } else if (transactionType == TransactionType.income) {
      return Color(0x55C9C6).withOpacity(1);
    } else {
      return Color(0xB6B6B6).withOpacity(1);
    }
  }

  @override
  void dispose() {
    super.dispose();
    notesController.dispose();
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      final user = context.read<User>();
      Transaction transaction = user.findTransactionByID(widget.transactionID)!;
      transaction.note = notesController.text;
      user.updateTransaction(transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    final moneyFormat = new NumberFormat("#,##0.00", "en_US");

    Transaction transaction = user.findTransactionByID(widget.transactionID)!;
    notesController.text = transaction.note;
    return Material(
        type: MaterialType.transparency,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(children: [
                Expanded(
                  child: Ink(
                    color:
                        Color(user.findAccountByID(transaction.fromID)!.color)
                            .withOpacity(1),
                    child: InkWell(
                      splashColor: Colors.white.withOpacity(0.5),
                      onTap: () async {
                        final result =
                            await Navigator.of(context).push(PageRouteBuilder(
                          barrierColor: Colors.black.withOpacity(0.25),
                          barrierDismissible: true,
                          opaque: false,
                          pageBuilder: (_, __, ___) => AccountSelection(),
                        ));
                        if (result != null) {
                          transaction.fromID = result["accountID"];
                          user.updateTransaction(transaction);
                          //user.selectAccount(result["accountID"]);
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0.0, 4.0, 16.0, 4.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.white)),
                          height: 60,
                          child: Stack(children: [
                            Positioned(
                              left: -4,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        IconData(
                                            user
                                                .findAccountByID(
                                                    transaction.fromID)!
                                                .icon,
                                            fontFamily: 'MaterialIcons'),
                                        color: Colors.white.withOpacity(0.3),
                                        size: 50),
                                  ]),
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 55),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("From Account",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10)),
                                        SizedBox(height: 4.0),
                                        Flexible(
                                          child: Text(
                                            user
                                                .findAccountByID(
                                                    transaction.fromID)!
                                                .name,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ]),
                                ]),
                          ])),
                    ),
                  ),
                ),
                Expanded(
                  child: Ink(
                    color: Color(transaction.transactionType !=
                                TransactionType.transfer
                            ? user.findCategoryByID(transaction.toID)!.color
                            : user.findAccountByID(transaction.toID)!.color)
                        .withOpacity(1),
                    child: InkWell(
                      splashColor: Colors.white.withOpacity(0.5),
                      onTap: () async {
                        final results =
                            await Navigator.of(context).push(PageRouteBuilder(
                          barrierColor: Colors.black.withOpacity(0.25),
                          barrierDismissible: true,
                          opaque: false,
                          pageBuilder: (_, __, ___) => RecipientSelection(),
                        ));
                        if (results != null) {
                          transaction.toID = results["categoryID"];
                          user.updateTransaction(transaction);
                          //user.selectCategory(results["categoryID"]);
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0.0, 4.0, 16.0, 4.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.white)),
                          height: 60,
                          child: Stack(children: [
                            Positioned(
                              left: -4,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        IconData(
                                            transaction.transactionType !=
                                                    TransactionType.transfer
                                                ? user
                                                    .findCategoryByID(
                                                        transaction.toID)!
                                                    .icon
                                                : user
                                                    .findAccountByID(
                                                        transaction.toID)!
                                                    .icon,
                                            fontFamily: 'MaterialIcons'),
                                        color: Colors.white.withOpacity(0.3),
                                        size: 50),
                                  ]),
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 55),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            getToLabel(
                                                transaction.transactionType!),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10)),
                                        SizedBox(height: 4.0),
                                        Flexible(
                                          child: Text(
                                            transaction.transactionType !=
                                                    TransactionType.transfer
                                                ? user
                                                    .findCategoryByID(
                                                        transaction.toID)!
                                                    .name
                                                : user
                                                    .findAccountByID(
                                                        transaction.toID)!
                                                    .name,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ]),
                                ]),
                          ])),
                    ),
                  ),
                ),
              ]),
              Container(
                  color: const Color(0xFBFBFB).withOpacity(1),
                  width: double.infinity,
                  height: 82,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(getValueLabel(transaction.transactionType!),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: getLabelColor(
                                    transaction.transactionType!))),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                              text:
                                  "${user.findAccountByID(transaction.fromID)!.getCurrency().symbol}",
                              style: TextStyle(
                                color:
                                    getLabelColor(transaction.transactionType!),
                                fontSize: 26,
                              ),
                              children: [
                                TextSpan(
                                    text:
                                        "${moneyFormat.format(transaction.value).split('.')[0]}",
                                    style: TextStyle(
                                        color: getLabelColor(
                                            transaction.transactionType!),
                                        fontSize: 26,
                                        fontFamily: "Poppins")),
                                TextSpan(
                                    text:
                                        ".${moneyFormat.format(transaction.value).split('.')[1]}",
                                    style: TextStyle(
                                        color: getLabelColor(
                                            transaction.transactionType!),
                                        fontSize: 26,
                                        fontFamily: "Poppins"))
                              ]),
                        ),
                      ])),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Colors.grey.shade400.withOpacity(0.25),
                        width: 1.0),
                  ),
                  color: Colors.white,
                ),
                child: TextField(
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color(0xFF4F4F4F)),
                  textAlign: TextAlign.center,
                  controller: notesController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12.0),
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "Notes...",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: const Color(0xFFBDBDBD))),
                ),
              ),
              OutlinedButton(
                  onPressed: () async {
                    var results =
                        await Navigator.of(context).push(PageRouteBuilder(
                      barrierColor: Colors.black.withOpacity(0.25),
                      barrierDismissible: true,
                      opaque: false,
                      pageBuilder: (_, __, ___) =>
                          DateSelection(currentDate: transaction.timestamp),
                    ));
                    if (results != null) {
                      transaction.timestamp = results["currentDate"];
                      user.updateTransaction(transaction);
                    }
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                            dateFormatter
                                .format(transaction.timestamp)
                                .toUpperCase(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500))
                      ])),
              OutlinedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Future.delayed(Duration(milliseconds: 200));
                    Transaction toFavorite =
                        user.findTransactionByID(widget.transactionID)!;
                    user.addTransactionToFavorites(FavoriteTransaction(
                        toID: toFavorite.toID,
                        fromID: toFavorite.fromID,
                        isArchived: toFavorite.isArchived,
                        transactionType: toFavorite.transactionType,
                        importance: toFavorite.importance,
                        value: toFavorite.value));
                    // user.addTransactionToFavorites(user.transactions[user.getTransactionIndexByID(widget.transactionID)]);
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(0xFFB6B6B6),
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text("ADD TO FAVORITES",
                            style: TextStyle(
                                color: Color(0xFFB6B6B6),
                                fontSize: 14,
                                fontWeight: FontWeight.w500))
                      ])),
              OutlinedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Future.delayed(Duration(milliseconds: 200));
                    user.deleteTransaction(widget.transactionID);
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red[700],
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text("DELETE TRANSACTION",
                            style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w500))
                      ]))
            ],
          )),
        ));
  }
}
