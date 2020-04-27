import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleeptrackerapp/models/SleepTypes.dart';
import 'main.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewRecordPage extends StatefulWidget {
  @override
  _AddNewRecordPageState createState() => _AddNewRecordPageState();
}

class _AddNewRecordPageState extends State<AddNewRecordPage> {
  List<SleepTypes> sleepType = <SleepTypes>[
    const SleepTypes('Night\'s Sleep'),
    const SleepTypes('Nap')
  ];

  // type of sleep selected by user
  SleepTypes selectedType;
  // place holder for time field
  String timePlaceHolder = '-';
  // time duration chosen by user
  double currentDoubleValue = 0.0;

  // returns list of sleep records data
  Future<List> getListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> records = prefs.getStringList('recordsList');
    return records;
  }

  // add new sleeping record to shared pref
  Future<void> addNewRecordToSharedPref(
      {String clock, String sleepType, String sleepTime}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> lastList = await getListFromSharedPref();
    if (lastList == null) {
      lastList = [];
    }
    lastList.addAll([clock, sleepType, sleepTime]);
    await prefs.setStringList('recordsList', lastList);
  }

  Future showDoubleDialog() async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.decimal(
          minValue: 0,
          maxValue: 23,
          decimalPlaces: 2,
          initialDoubleValue: currentDoubleValue,
          title: new Text(
            "Pick how many hours and minutes",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => currentDoubleValue = value);
        setState(() {
          int sleepHours = currentDoubleValue.toInt();
          int sleepMinutes = (currentDoubleValue * 100 % 100).toInt();
          timePlaceHolder = '$sleepHours hours $sleepMinutes minutes';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMMM y, EEEE H:m').format(now);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                // go back to main page without saving record
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              });
            },
          ),
          title: Text('Sleep Tracker'),
          titleSpacing: 20.0,
          backgroundColor: Colors.yellow.shade800,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 20.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Image(
                          image: AssetImage('images/baby.jpg'),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Icon(
                                Icons.date_range,
                                size: 35.0,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Date and time",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                          width: double.infinity,
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Icon(
                                Icons.ac_unit,
                                size: 35.0,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Sleep type",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  DropdownButton<SleepTypes>(
                                    underline: Container(
                                      height: 0,
                                    ),
                                    hint: Text("Night, nap, etc"),
                                    value: selectedType,
                                    onChanged: (SleepTypes value) {
                                      setState(() {
                                        selectedType = value;
                                      });
                                    },
                                    items: sleepType.map((SleepTypes user) {
                                      return DropdownMenuItem<SleepTypes>(
                                        value: user,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              user.name,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.0,
                          width: double.infinity,
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Icon(
                                  Icons.access_time,
                                  size: 35.0,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Sleep duration",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  FlatButton(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text(timePlaceHolder),
                                    onPressed: () {
                                      setState(() {
                                        showDoubleDialog();
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0.0,
                          width: double.infinity,
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: FlatButton(
                            textColor: Colors.white,
                            color: Colors.blue.shade800,
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            onPressed: () {
                              if (currentDoubleValue != 0.0 &&
                                  selectedType?.name != null) {
                                setState(() {
                                  //current date
                                  var now = new DateTime.now();
                                  int hour = now.hour;
                                  int minutes = now.minute;
                                  String hourStr = hour.toString();
                                  String minutesStr = minutes.toString();

                                  // add leading 0 if hour or minutes smaller than 10
                                  if (hour < 10) hourStr = '0' + hourStr;
                                  if (minutes < 10)
                                    minutesStr = '0' + minutesStr;

                                  // change sleep doubles into hour:minute format
                                  int sleepHoursInt =
                                      currentDoubleValue.toInt();
                                  int sleepMinutesInt =
                                      (currentDoubleValue * 100 % 100).toInt();

                                  addNewRecordToSharedPref(
                                      clock: '$hourStr:$minutesStr',
                                      sleepType: selectedType.name,
                                      sleepTime:
                                          '$sleepHoursInt hours $sleepMinutesInt minutes');
                                  //go to main page after saving record
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyApp()),
                                  );
                                });
                              } else {
                                // if not all fields filled show dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Alert"),
                                      content: Text(
                                          "Please fill out all the fields."),
                                      actions: [
                                        FlatButton(
                                          child: Text('Okay'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
