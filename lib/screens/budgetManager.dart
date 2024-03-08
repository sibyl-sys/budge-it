import 'package:flutter/material.dart';
import 'package:money_tracker/screens/setBudget.dart';
import 'package:money_tracker/services/budget.dart';
import 'package:money_tracker/services/budgetCap.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/screens/iconAndColorSelection.dart';
import 'package:money_tracker/screens/currencySelection.dart';
import 'package:money_tracker/screens/categorySelection.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BudgetManager extends StatefulWidget {
  final Budget? budgetInformation;
  const BudgetManager({Key? key, this.budgetInformation}) : super(key: key);

  @override
  _BudgetManagerState createState() => _BudgetManagerState();
}

class _BudgetManagerState extends State<BudgetManager> {
  final FocusNode nameFocusNode = FocusNode();
  final TextEditingController budgetNameController = TextEditingController();
  final DateFormat dateFormatter = DateFormat("MMM y", "en_us");
  final NumberFormat moneyFormatter = new NumberFormat("#,##0.00", "en_US");

  IconData budgetIcon = Icons.account_balance_wallet;
  Color budgetColor = Colors.blue.shade400;
  bool isDarkIcon = false;
  bool isCarryOver = false;
  late Currency selectedCurrency;
  List<Category> categories = [];
  List<BudgetCap> budgetCap = [];

  void initState() {
    super.initState();
    User userModel = context.read<User>();
    setState(() {
      if (widget.budgetInformation != null) {
        Budget budgetInfo = widget.budgetInformation!;
        budgetNameController.text = budgetInfo.name;
        categories = List.from(budgetInfo.toTrack);
        budgetCap = List.from(budgetInfo.budgetCap);
        selectedCurrency = budgetInfo.getCurrency() == null
            ? userModel.mySettings.getPrimaryCurrency()
            : budgetInfo.getCurrency()!;
        budgetColor = Color(budgetInfo.color).withOpacity(1.0);
        budgetIcon = IconData(budgetInfo.icon, fontFamily: 'MaterialIcons');
      } else {
        selectedCurrency = userModel.mySettings.getPrimaryCurrency();
      }
    });
  }

  Widget renderCategoryList() {
    return Column(
        children: categories
            .map((e) => Card(
                    child: Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              IconData(e.icon, fontFamily: "MaterialIcons"),
                              color: Color(e.color).withOpacity(1),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(e.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color(e.color).withOpacity(1)))
                        ]),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                categories.remove(e);
                              });
                            },
                            icon: Icon(Icons.close, color: Color(0xFFB6B6B6)))
                      ],
                    ),
                  ),
                )))
            .toList());
  }

  Widget renderBudgetHistory(User user) {
    return Column(
        children: budgetCap.map((e) {
      double expenditures = user.getCategoryListExpenditures(
          DateTime(e.year, e.month), DateTime(e.year, e.month), categories);
      return Card(
          child: InkWell(
        splashColor: Colors.teal.shade700.withAlpha(50),
        onTap: () async {
          final results = await Navigator.of(context).push(PageRouteBuilder(
            barrierColor: Colors.black.withOpacity(0.25),
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (_, __, ___) => SetBudget(
              currencySymbol: selectedCurrency.symbol,
              budgetCap: e,
              onDelete: () {
                setState(() {
                  budgetCap.remove(e);
                });
              },
            ),
          ));
          if (results != null) {
            if (!results["isRepeatedAllYear"]) {
              allocateBudget(results["schedule"].month,
                  results["schedule"].year, results["budget"]);
            } else {
              for (var i = 1; i <= 12; i++) {
                allocateBudget(i, results["schedule"].year, results["budget"]);
              }
            }
          }
          setState(() {
            budgetCap.sort((a, b) {
              int yearComp = a.year.compareTo(b.year);
              if (yearComp == 0) {
                return a.month.compareTo(b.month);
              }
              return yearComp;
            });
          });
        },
        child: Container(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dateFormatter.format(DateTime(e.year, e.month)),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF4F4F4F))),
                      Text(moneyFormatter.format(expenditures),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: budgetColor))
                    ]),
                LinearPercentIndicator(
                    lineHeight: 3.0,
                    percent: min((expenditures / e.cap), 1),
                    backgroundColor: Colors.grey,
                    progressColor: budgetColor,
                    padding: EdgeInsets.zero),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(moneyFormatter.format(e.cap),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFB6B6B6)))
                ]),
              ])),
        ),
      ));
    }).toList());
  }

  bool checkForBudgetDuplicate(int month, int year) {
    var element = budgetCap
        .where((element) => element.month == month && element.year == year);
    return !element.isEmpty;
  }

  void allocateBudget(int month, int year, double cap) async {
    if (checkForBudgetDuplicate(month, year)) {
      //PROMPT WOULD YOU LIKE TO UPDATE?
      bool? response = await promptForDuplicates(
          dateFormatter.format(DateTime(year, month)));
      if (response == true) {
        setState(() {
          budgetCap
              .firstWhere(
                  (element) => element.month == month && element.year == year)
              .cap = cap;
        });
      }
    } else {
      setState(() {
        budgetCap = List.from(budgetCap)
          ..add(BudgetCap(cap: cap, month: month, year: year));
      });
    }
  }

  Future<bool?> promptForDuplicates(String date) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Budget already exists'),
              content: Text(
                  'Budget has already been set for ${date}. Would you like to update budget instead?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Update'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                User userModel = context.read<User>();
                if (widget.budgetInformation != null) {
                  //TODO INTEGRATE CURRENCY SELECTION
                  Budget forUpdate = widget.budgetInformation!;

                  user.addBudgetHistory(budgetCap);
                  forUpdate.color = budgetColor.value;
                  forUpdate.icon = budgetIcon.codePoint;
                  forUpdate.name = budgetNameController.text;
                  forUpdate.willCarryOver = isCarryOver;
                  forUpdate.toTrack.clear();
                  forUpdate.toTrack.addAll(categories);
                  forUpdate.budgetCap.addAll(budgetCap);
                  forUpdate.budgetCap.forEach((element) {
                    BudgetCap? existingBudgetCap;
                    budgetCap.forEach((existing) {
                      if (existing.id == element.id)
                        existingBudgetCap = element;
                    });
                    if (existingBudgetCap == null) {
                      user.removeBudgetHistory(element);
                    }
                  });
                  print(forUpdate.toTrack);

                  userModel.addBudget(forUpdate);
                  Navigator.pop(context);
                } else {
                  userModel.addBudgetHistory(budgetCap);
                  Budget newBudget = Budget(
                      color: budgetColor.value,
                      icon: budgetIcon.codePoint,
                      name: budgetNameController.text,
                      willCarryOver: isCarryOver);
                  newBudget.budgetCap.addAll(budgetCap);
                  newBudget.toTrack.addAll(categories);
                  userModel.addBudget(newBudget);
                  Navigator.pop(context);
                }
              },
            )
          ],
          title: Text(widget.budgetInformation == null
              ? "New Budget"
              : "Update Budget"),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF2F2F2),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 16.0, 20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: budgetColor,
                      child: IconButton(
                          icon: Icon(budgetIcon, size: 30),
                          color: isDarkIcon
                              ? Colors.black.withOpacity(0.2)
                              : Colors.white,
                          onPressed: () async {
                            final result = await Navigator.of(context)
                                .push(PageRouteBuilder(
                              barrierColor: Colors.black.withOpacity(0.25),
                              barrierDismissible: true,
                              opaque: false,
                              pageBuilder: (_, __, ___) =>
                                  IconAndColorSelection(
                                      accountColor: this.budgetColor,
                                      accountIcon: this.budgetIcon,
                                      isDarkIcon: isDarkIcon),
                            ));
                            if (result != null) {
                              setState(() {
                                budgetIcon = result["iconData"];
                                budgetColor = result["backgroundColor"];
                                isDarkIcon = result["isDarkIcon"];
                              });
                            }
                          }),
                    ),
                  ]),
            ),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  nameFocusNode.requestFocus();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade400.withOpacity((0.5)),
                            width: 1)),
                  ),
                  height: 74,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            )),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: const Color(0xFF4F4F4F)),
                            focusNode: nameFocusNode,
                            controller: budgetNameController,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Untitled Category",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: const Color(0xFFBDBDBD)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () async {
                  final result =
                      await Navigator.of(context).push(PageRouteBuilder(
                    barrierColor: Colors.black.withOpacity(0.25),
                    barrierDismissible: true,
                    opaque: false,
                    pageBuilder: (_, __, ___) => CurrencySelection(),
                  ));
                  if (result != null) {
                    setState(() {
                      selectedCurrency = result;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade400.withOpacity((0.5)),
                            width: 1)),
                  ),
                  width: double.infinity,
                  height: 78,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Currency",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            )),
                        RichText(
                          text: TextSpan(
                              text: "${selectedCurrency.symbol} ",
                              style: TextStyle(
                                  color: const Color(0xFF4F4F4F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                    text: " (${selectedCurrency.name})",
                                    style: TextStyle(
                                        color: const Color(0xFF4F4F4F),
                                        fontSize: 16,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500)),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Categories",
                      style: TextStyle(
                          color: Color(0xFFB6B6B6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  renderCategoryList(),
                  Card(
                      child: Container(
                    height: 50,
                    child: TextButton(
                      onPressed: () async {
                        final results =
                            await Navigator.of(context).push(PageRouteBuilder(
                          barrierColor: Colors.black.withOpacity(0.25),
                          barrierDismissible: true,
                          opaque: false,
                          pageBuilder: (_, __, ___) => CategorySelection(),
                        ));
                        if (results != null) {
                          Category categoryToAdd =
                              user.findCategoryByID(results["recipientID"])!;
                          setState(() {
                            categories = List.from(categories)
                              ..add(categoryToAdd);
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      ),
                      child: Row(children: [
                        Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.25))),
                            child: Icon(
                              Icons.add,
                              color: budgetColor,
                            )),
                        SizedBox(width: 20),
                        Text("Track Category",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: budgetColor))
                      ]),
                    ),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Budget History",
                      style: TextStyle(
                          color: Color(0xFFB6B6B6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  renderBudgetHistory(user),
                  Card(
                      child: Container(
                    height: 50,
                    child: TextButton(
                      onPressed: () async {
                        final results =
                            await Navigator.of(context).push(PageRouteBuilder(
                          barrierColor: Colors.black.withOpacity(0.25),
                          barrierDismissible: true,
                          opaque: false,
                          pageBuilder: (_, __, ___) => SetBudget(
                              currencySymbol: selectedCurrency.symbol),
                        ));
                        if (results != null) {
                          if (!results["isRepeatedAllYear"]) {
                            allocateBudget(results["schedule"].month,
                                results["schedule"].year, results["budget"]);
                          } else {
                            for (var i = 1; i <= 12; i++) {
                              allocateBudget(i, results["schedule"].year,
                                  results["budget"]);
                            }
                          }
                        }
                        setState(() {
                          budgetCap.sort((a, b) {
                            int yearComp = a.year.compareTo(b.year);
                            if (yearComp == 0) {
                              return a.month.compareTo(b.month);
                            }
                            return yearComp;
                          });
                        });
                      },
                      style: TextButton.styleFrom(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      ),
                      child: Row(children: [
                        Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.25))),
                            child: Icon(
                              Icons.add,
                              color: budgetColor,
                            )),
                        SizedBox(width: 20),
                        Text("Allocate Budget",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: budgetColor))
                      ]),
                    ),
                  )),
                ],
              ),
            ),
          ]),
        ));
  }
}
