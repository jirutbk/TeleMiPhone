import 'package:flutter/material.dart';
import 'package:telemiphone/magicNumberList.dart';
import 'package:telemiphone/phoneNumberPage.dart';
import 'package:telemiphone/carLicensePage.dart';
import 'package:telemiphone/namePage.dart';
//import 'package:telemiphone/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'TeleMiPhone',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: MainScreen(), //เรียก splash screen
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreen();
  }
}

class _MainScreen extends State<MainScreen> {
  String version = "1.5.0";
  var _days = [
    'อาทิตย์',
    'จันทร์',
    'อังคาร',
    'พุธกลางวัน',
    'พุธกลางคืน',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TeleMiPhone',
            style: TextStyle(color: Colors.white, fontSize: 18.0)),
        backgroundColor: Colors.pink,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            tooltip: 'เกี่ยวกับแอพพลิเคชั่น',
            onPressed: () {
              showAboutDialog(
                  context: context,
                  applicationIcon:
                      Icon(Icons.api_sharp, color: Colors.pink, size: 36.0),
                  applicationVersion: version,
                  applicationLegalese: "ผู้พัฒนา : TanunnasBK");
            },
          ),
        ],
      ),
      body: Material(
          color: Colors.pink[100],
          child: Center(
              child: Column(children: [
            Text('ศาสตร์แห่งตัวเลข',
                style: TextStyle(color: Colors.white, fontSize: 20.0)),




DropdownButton<String>(
                items: _days.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                  value: dropDownStringItem, child: Text(dropDownStringItem));
            })              ),




          ]))),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                height: 90.0,
                padding: EdgeInsets.all(0.0),
                margin: EdgeInsets.all(0.0),
                child: DrawerHeader(
                  child: Text('รายการเมนู',
                      style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                  ),
                )),
            ListTile(
                title: Text('หมายเลขโทรศัพท์'),
                leading:
                    Icon(Icons.mobile_friendly_rounded, color: Colors.green),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhoneNumberPage()));
                }),
            ListTile(
                title: Text('เลขทะเบียนรถ'),
                leading: Icon(Icons.car_rental, color: Colors.blue),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarLicensePage()));
                }),
            ListTile(
                title: Text('คำนวณชื่อมงคล'),
                leading: Icon(Icons.contact_page, color: Colors.amber),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NamePage()));
                }),
            ListTile(
                title: Text('ปฏิทินจันทรคติ'),
                leading: Icon(Icons.calendar_today, color: Colors.orange),
                onTap: () {}),
            ListTile(
              title: Text('แสดงเลขศาสตร์'),
              leading: Icon(Icons.format_list_numbered, color: Colors.red),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MagicNumberList()));
              },
            ),
            ListTile(
              title: Text('เกี่ยวกับแอพพลิเคชั่น'),
              leading: Icon(Icons.api_sharp, color: Colors.pink),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                    context: context,
                    applicationIcon:
                        Icon(Icons.api_sharp, color: Colors.pink, size: 36.0),
                    applicationVersion: version,
                    applicationLegalese: "ผู้พัฒนา : TanunnasBK");
              },
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: Container(
          color: Colors.pinkAccent[100],
          height: 50.0,
        ),
      ),
    );
  }
}
