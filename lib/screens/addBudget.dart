import 'package:flutter/material.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/screens/iconAndColorSelection.dart';
import 'package:money_tracker/screens/currencySelection.dart';
import 'package:money_tracker/screens/categorySelection.dart';
import 'package:provider/provider.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({Key? key}) : super(key: key);

  @override
  _AddBudgetState createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  final FocusNode nameFocusNode = FocusNode();
  final TextEditingController categoryNameController = TextEditingController();
  IconData categoryIcon = Icons.account_balance_wallet;
  Color categoryColor = Colors.blue.shade400;
  bool isDarkIcon = false;
  bool isCarryOver = false;
  late Currency selectedCurrency;
  List<Category> categories = [];

  void initState() {
    super.initState();
    User userModel = context.read<User>();
    setState(() {
      selectedCurrency = userModel.mySettings.getPrimaryCurrency();
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
                    child: Row(children: [
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
                              color: categoryColor))
                    ]),
                  ),
                )))
            .toList());
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
                //TODO ADD BUDGET
                Navigator.pop(context);
              },
            )
          ],
          title: Text("New Budget"),
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
                      backgroundColor: categoryColor,
                      child: IconButton(
                          icon: Icon(categoryIcon, size: 30),
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
                                      accountColor: this.categoryColor,
                                      accountIcon: this.categoryIcon,
                                      isDarkIcon: isDarkIcon),
                            ));
                            if (result != null) {
                              setState(() {
                                categoryIcon = result["iconData"];
                                categoryColor = result["backgroundColor"];
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
                            controller: categoryNameController,
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
                children: [
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
                              color: categoryColor,
                            )),
                        SizedBox(width: 20),
                        Text("Track Category",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: categoryColor))
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
