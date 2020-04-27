import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'newRecordPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  resetRecords();
  runApp(MyApp());
}

// reset all previous records
Future<void> resetRecords() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('recordsList', null);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sleep Tracker'),
          titleSpacing: 80.0,
          backgroundColor: Colors.yellow.shade800,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: MyHomePage(),
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> sleepingRecords = [];

  // build a single sleep record
  Column buildRecord(String clock, String sleepType, String sleepTime) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 80.0,
                color: Colors.grey.shade100,
                child: Center(
                  child: Text(
                    clock,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      sleepType,
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      sleepTime,
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 1.0,
          width: double.infinity,
          child: Divider(
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    setRecordsFromSharedPref();
  }

  // returns list of sleep records data
  Future<List> getListFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> records = prefs.getStringList('recordsList');
    return records;
  }

  // build records from data retrieved form shared pref
  Future<void> setRecordsFromSharedPref() async {
    List<String> sharedList = await getListFromSharedPref();
    setState(() {
      // check if shared pref list is empty
      if (sharedList != null) {
        for (int i = 0; i < sharedList.length; i += 3) {
          sleepingRecords.add(
              buildRecord(sharedList[i], sharedList[i + 1], sharedList[i + 2]));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMM y').format(now);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
      child: Center(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.yellow.shade800,
              child: Icon(
                Icons.ac_unit,
                size: 35.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
              'Get to know your baby\'s sleep patterns and keep\n track '
              'of how much sleep they are getting here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 15.0,
                color: Colors.grey.shade400,
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: FlatButton(
                textColor: Colors.white,
                color: Colors.blue.shade800,
                child: Text(
                  'Add new sleeping record',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  setState(() {
                    // go to adding new record page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNewRecordPage()),
                    );
                  });
                },
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                formattedDate.toUpperCase(),
                style: TextStyle(
                  letterSpacing: 0.5,
                  color: Colors.grey.shade600,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                verticalDirection: VerticalDirection.up,
                children: sleepingRecords,
              ),
            )
          ],
        ),
      ),
    );
  }
}
