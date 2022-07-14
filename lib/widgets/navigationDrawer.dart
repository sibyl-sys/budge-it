import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key key}) : super(key: key);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
          backgroundColor: Color(0xFFFBFBFB),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                  height: 68,
                  child: DrawerHeader(
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "Budge-it",
                            style: TextStyle(
                                color: Color(0xFF5F5C96)
                            )
                        ),
                        Text(
                            "Cloud Saving Disabled",
                            style: TextStyle(
                                color: Color(0xFF55C9C6),
                                fontSize: 10
                            )
                        )
                      ],
                    ),
                  )
              ),
              ListTile(
                  title: Text(
                    "Profile",
                    style: TextStyle(
                        color: Color(0xFFB6B6B6),
                        fontSize: 12
                    ),
                  ),
                  tileColor: Color(0xFFFBFBFB),
                  dense: true
              ),
              ListTile(
                title: Text("Jane Doe"),
                subtitle: Text('Premium Account', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.account_circle_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
                dense: true,
                tileColor: Colors.white,
              ),
              ListTile(
                  title: Text(
                    "General Settings",
                    style: TextStyle(
                        color: Color(0xFFB6B6B6),
                        fontSize: 12
                    ),
                  ),
                  tileColor: Color(0xFFFBFBFB),
                  dense: true
              ),
              ListTile(
                title: Text("Language"),
                subtitle: Text('English (Default)', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.translate_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Currency"),
                subtitle: Text('Philippine Peso (P)', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.account_balance_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Spend Alert"),
                subtitle: Text('P 5,000.00', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.speed_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Date Format"),
                subtitle: Text('Monday (Day 1)', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.date_range_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Start Screen"),
                subtitle: Text('Transactions', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.book_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Reminder"),
                subtitle: Text('5:00 PM', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.notifications_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                trailing: Switch(value: false, onChanged:(value) {}),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Passcode"),
                subtitle: Text('PIN', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.lock_outline, color: Color(0x3C3A5F).withOpacity(0.25))),
                trailing: Switch(value: false, onChanged:(value) {}),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Theme"),
                subtitle: Text('Light', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.invert_colors_on_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                trailing: Text("Coming Soon", style: TextStyle(fontSize: 11, color: Color(0xFFB6B6B6))),
                dense: true,
                tileColor: Colors.white,
              ),
              ListTile(
                  title: Text(
                    "More",
                    style: TextStyle(
                        color: Color(0xFFB6B6B6),
                        fontSize: 12
                    ),
                  ),
                  tileColor: Color(0xFFFBFBFB),
                  dense: true
              ),
              ListTile(
                title: Text("Budge-it 1.2.3"),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.apps, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Rate Us"),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.grade_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Contact Support"),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.mail_outline, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text("Privacy Policy"),
                minLeadingWidth: 0,
                leading: Container(height: double.infinity, child: Icon(Icons.policy_outlined, color: Color(0x3C3A5F).withOpacity(0.25))),
                dense: true,
                tileColor: Colors.white,
              ),
            ],
          )
      ),
    );
  }
}
