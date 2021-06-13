import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DateSeleciton extends StatefulWidget {
  const DateSeleciton({Key key}) : super(key: key);

  @override
  _DateSelecitonState createState() => _DateSelecitonState();
}

class _DateSelecitonState extends State<DateSeleciton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 350,
          height: 398,
          decoration: BoxDecoration(
              color: const Color(0xF2F2F2).withOpacity(1),
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child:  Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      height: 25,
                      child: Center(
                        child: Text(
                          "Set Date",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 16.0,
                            bottom: 16.0
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_alarm,
                                size: 24
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                "Reminder",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16
                                )
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                  "None",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.grey
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 16.0,
                              bottom: 16.0
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.repeat,
                                  size: 24
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                  "Recurrence",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  )
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                  "None",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.grey
                                  )
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 16.0,
                              bottom: 16.0
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.calendar_today,
                                  size: 24
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                  "Select Day",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 16.0,
                              bottom: 16.0
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.mode_night_outlined,
                                  size: 24
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                  "Yesterday",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  )
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                  "None",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.grey
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 16.0,
                              bottom: 16.0
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.light_mode_outlined,
                                  size: 24
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                  "Today",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  )
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                  "None",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.grey
                                  )
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
