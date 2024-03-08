import 'package:flutter/material.dart';
import 'package:money_tracker/screens/addSubcategory.dart';
import 'package:money_tracker/screens/categoriesType.dart';
import 'package:money_tracker/screens/currencySelection.dart';
import 'package:money_tracker/screens/iconAndColorSelection.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/subcategory.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  CategoryType _categoryType = CategoryType.expense;
  final FocusNode nameFocusNode = FocusNode();
  final TextEditingController categoryNameController = TextEditingController();
  IconData categoryIcon = Icons.account_balance_wallet;
  Color categoryColor = Colors.blue.shade400;
  bool isDarkIcon = false;
  late Currency selectedCurrency;
  List<Subcategory> subcategories = [];

  void initState() {
    super.initState();
    User userModel = context.read<User>();
    setState(() {
      selectedCurrency = userModel.mySettings.getPrimaryCurrency();
    });
  }

  Future<void> _selectCategoryType(BuildContext context) async {
    CategoryType? newCategoryType = await showDialog<CategoryType>(
        context: context,
        builder: (BuildContext context) {
          return CategoriesType();
        });
    if (newCategoryType != null) {
      setState(() {
        _categoryType = newCategoryType;
      });
    }
  }

  Widget renderSubcategoryList() {
    return Column(
        children: subcategories
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
                          color: categoryColor,
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

  String getCategoryTypeString() {
    switch (_categoryType) {
      case CategoryType.income:
        return "Income";
      case CategoryType.expense:
        return "Expense";
      default:
        return "Expense";
    }
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              User userModel = context.read<User>();
              Category newCategory = Category(
                color: categoryColor.value,
                categoryType: _categoryType,
                icon: categoryIcon.codePoint,
                name: categoryNameController.text,
                index: userModel.newCategoryIndex,
                // subcategories: subcategories
              );
              for (Subcategory subcategory in subcategories) {
                newCategory.subcategories.add(subcategory);
              }
              userModel.addCategory(newCategory);
              Navigator.pop(context);
            },
          )
        ],
        title: Text("New Category"),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    InkWell(
                        onTap: () {
                          _selectCategoryType(context);
                        },
                        child: Container(
                            width: 250,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(getCategoryTypeString(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                                Icon(Icons.arrow_right,
                                    color: Theme.of(context).primaryColor,
                                    size: 28)
                              ],
                            )))
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
            // Ink(
            //   color: Colors.white,
            //   child: InkWell(
            //     onTap: () async{
            //       final result = await Navigator.of(context).push(
            //           PageRouteBuilder(
            //             barrierColor: Colors.black.withOpacity(0.25),
            //             barrierDismissible: true,
            //             opaque: false,
            //             pageBuilder: (_, __, ___) => CurrencySelection(),
            //           )
            //       );
            //       if(result != null) {
            //         setState(() {
            //           selectedCurrency = result;
            //         });
            //       }
            //     },
            //     child: Container(
            //       decoration: BoxDecoration(
            //         border: Border(
            //             bottom: BorderSide(color: Colors.grey.shade400.withOpacity((0.5)), width: 1)
            //         ),
            //       ),
            //       width: double.infinity,
            //       height: 78,
            //       child: Padding(
            //         padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //                 "Currency",
            //                 style: TextStyle(
            //                   fontSize: 12,
            //                   fontWeight: FontWeight.w400,
            //                 )
            //             ),
            //             RichText(
            //               text: TextSpan(
            //                   text: "${selectedCurrency.symbol} ",
            //                   style: TextStyle(
            //                       color: const Color(0xFF4F4F4F),
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.w500
            //                   ),
            //                   children: [
            //                     TextSpan(
            //                         text: " (${selectedCurrency.name})",
            //                         style: TextStyle(
            //                             color: const Color(0xFF4F4F4F),
            //                             fontSize: 16,
            //                             fontFamily: "Poppins",
            //                             fontWeight: FontWeight.w500
            //                         )
            //                     ),
            //                   ]
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Subcategories:",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0x4F4F4F).withOpacity(1))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Column(
                children: [
                  renderSubcategoryList(),
                  Card(
                      child: Container(
                    height: 50,
                    child: TextButton(
                      onPressed: () async {
                        final result =
                            await Navigator.of(context).push(PageRouteBuilder(
                          barrierColor: Colors.black.withOpacity(0.25),
                          barrierDismissible: true,
                          opaque: false,
                          pageBuilder: (_, __, ___) => AddSubcategory(
                              categoryColor: this.categoryColor,
                              categoryIcon: this.categoryIcon,
                              isDarkIcon: isDarkIcon,
                              name: ""),
                        )
                                //TODO SUBCATEGORY ADD
                                );
                        if (result != null) {
                          User userModel = context.read<User>();
                          setState(() {
                            subcategories = List.from(subcategories)
                              ..add(Subcategory(
                                icon: result["iconData"].codePoint,
                                name: result["name"],
                                // id: userModel.newSubCategoryID(subcategories)
                              ));
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
                        Text("Add Subcategory",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: categoryColor))
                      ]),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
