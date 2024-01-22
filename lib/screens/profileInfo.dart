import 'package:flutter/material.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {

  final FocusNode nameFocusNode = FocusNode();
  final TextEditingController usernameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Profile"),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  nameFocusNode.requestFocus();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade400.withOpacity(0.5), width: 1)
                    )
                   ),
                  width: double.infinity,
                  height: 74,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400
                                )
                              ),
                              SizedBox(height: 8.0),
                              SizedBox(
                                width: 200,
                                height: 14,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xFF4F4F4F)
                                  ),
                                  focusNode: nameFocusNode,
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: "Guest",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xFFBDBDBD)
                                    )
                                  ),
                                )
                              )
                            ]
                          ),
                          Text(
                            "email@host.com",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFB6B6B6)
                            )
                          )
                        ],
                      )
                    ),
                  )
                )
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
                              bottom: BorderSide(color: Colors.grey.shade400.withOpacity(0.5), width: 1)
                          )
                      ),
                      width: double.infinity,
                      height: 74,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "Change Pin",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400
                                  )
                              ),
                              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary)
                            ],
                          )
                      ),
                    )
                )
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
                              bottom: BorderSide(color: Colors.grey.shade400.withOpacity(0.5), width: 1)
                          )
                      ),
                      width: double.infinity,
                      height: 74,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  "Sign Out",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red[500]
                                  )
                              ),
                              Icon(Icons.logout, color: Colors.red[500])
                            ],
                          )
                      ),
                    )
                )
            ),
          ],
        )
      )
    );
  }
}
