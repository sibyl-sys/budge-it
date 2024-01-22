import 'package:flutter/material.dart';
import 'package:money_tracker/screens/iconSelection.dart';

class AddSubcategory extends StatefulWidget {
  final IconData categoryIcon;
  final Color categoryColor;
  final bool isDarkIcon;
  final String name;

  const AddSubcategory({Key? key, required this.categoryColor, required this.categoryIcon, required this.isDarkIcon, required this.name}) : super(key: key);

  @override
  _AddSubcategoryState createState() => _AddSubcategoryState(accountColor : this.categoryColor, accountIcon: this.categoryIcon, isDarkIcon: this.isDarkIcon, name: this.name);
}

class _AddSubcategoryState extends State<AddSubcategory> {
  IconData accountIcon;
  Color accountColor;
  bool isDarkIcon;
  String name;
  final TextEditingController categoryNameController = TextEditingController();

  _AddSubcategoryState({required this.accountIcon, required this.accountColor, required this.isDarkIcon, required this.name});
  @override
  void dispose() {
    categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 350,
          height: 400,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Column(
              children: [
                Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 2.0
                            )
                        )
                    ),
                    child: Center(
                        child: Text(
                            "New Subcategory",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            )
                        )
                    )
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: TextField(
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color(0xFF4F4F4F)
                    ),
                    controller: categoryNameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      alignLabelWithHint: true,
                      hintText: "New Subcategory",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: const Color(0xFFBDBDBD)
                      ),
                      labelText: "Subcategory Name",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: const Color(0xFFBDBDBD)
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IconSelection(
                    iconData: accountIcon,
                    onIconChange: (IconData icon) {
                      setState(() {
                        accountIcon = icon;
                      });
                    },
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text(
                            "CANCEL",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey
                            )
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context, {
                            "iconData" : accountIcon,
                            "name" : categoryNameController.text
                          });
                        },
                        child: Text(
                            "ADD",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor
                            )
                        ),
                      )
                    ]
                )
              ]
          ),
        ),
      ),
    );
  }
}
