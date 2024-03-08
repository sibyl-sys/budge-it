import 'package:flutter/material.dart';
import 'package:money_tracker/screens/colorSelection.dart';
import 'package:money_tracker/screens/iconSelection.dart';

class IconAndColorSelection extends StatefulWidget {
  final IconData accountIcon;
  final Color accountColor;
  final bool isDarkIcon;

  const IconAndColorSelection(
      {Key? key,
      required this.accountColor,
      required this.accountIcon,
      required this.isDarkIcon})
      : super(key: key);

  @override
  _IconAndColorSelectionState createState() => _IconAndColorSelectionState(
      accountColor: this.accountColor,
      accountIcon: this.accountIcon,
      isDarkIcon: this.isDarkIcon);
}

class _IconAndColorSelectionState extends State<IconAndColorSelection> {
  IconData accountIcon;
  Color accountColor;
  bool isDarkIcon;

  _IconAndColorSelectionState(
      {required this.accountIcon,
      required this.accountColor,
      required this.isDarkIcon});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 350,
          height: 500,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: DefaultTabController(
            length: 2,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                      height: 40,
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              "Select Account Icon",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    backgroundColor: accountColor,
                                    radius: 20,
                                    child: Icon(accountIcon,
                                        color: isDarkIcon
                                            ? Colors.black.withOpacity(0.2)
                                            : Colors.white,
                                        size: 30),
                                  ),
                                )
                              ])
                        ],
                      ))),
              ColoredBox(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: Colors.teal[500],
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Icon'),
                    Tab(text: 'Color'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(children: [
                  IconSelection(
                    iconData: accountIcon,
                    onIconChange: (IconData icon) {
                      setState(() {
                        accountIcon = icon;
                      });
                    },
                  ),
                  ColorSelection(
                    colorData: accountColor,
                    isDarkIcon: isDarkIcon,
                    onColorChange: (Color color, bool isDark) {
                      setState(() {
                        accountColor = color;
                        isDarkIcon = isDark;
                      });
                    },
                  )
                ]),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("CANCEL",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          "iconData": accountIcon,
                          "backgroundColor": accountColor,
                          "isDarkIcon": isDarkIcon
                        });
                      },
                      child: Text("DONE",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor)),
                    )
                  ])
            ]),
          ),
        ),
      ),
    );
  }
}
