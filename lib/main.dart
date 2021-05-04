import 'package:flutter/material.dart';
import 'package:telemiphone/magicNumberList.dart';
import 'package:telemiphone/phoneNumberPage.dart';
import 'package:telemiphone/carLicensePage.dart';
import 'package:telemiphone/namePage.dart';
import 'package:toast/toast.dart';
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
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  String version = "1.5.0";
  int day = 0;

  void _openDrawer() {
    if (day != 0)
      _drawerKey.currentState.openDrawer();
    else
      Toast.show("กรุณาเลือกวันเกิด !", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawerEnableOpenDragGesture: false,   //ปิดไม่ให้ไสลด์ drawer
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
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(children: [
                    Image.asset(
                      "assets/myLogo.png",
                      width: 100,
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Text('ศาสตร์แห่งตัวเลข',
                            style: TextStyle(
                                color: Colors.white, fontSize: 20.0))),
                    Card(
                        child: ListTile(
                      leading: Text("วันเกิด "),
                      title: DropdownButton(
                          value: day,
                          items: [
                            DropdownMenuItem(
                                child: Text("กรุณาเลือกวันเกิด"), value: 0),
                            DropdownMenuItem(child: Text("อาทิตย์"), value: 1),
                            DropdownMenuItem(child: Text("จันทร์"), value: 2),
                            DropdownMenuItem(child: Text("อังคาร"), value: 3),
                            DropdownMenuItem(
                                child: Text("พุธ(กลางวัน)"), value: 4),
                            DropdownMenuItem(
                                child: Text("พุธ(กลางคืน)"), value: 5),
                            DropdownMenuItem(child: Text("พฤหัสบดี"), value: 6),
                            DropdownMenuItem(child: Text("ศุกร์"), value: 7),
                            DropdownMenuItem(child: Text("เสาร์"), value: 8)
                          ],
                          onChanged: (value) {
                            setState(() {
                              day = value;
                            });
                          }),
                    ))
                  ])))),
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
                      MaterialPageRoute(builder: (context) => NamePage(day: day)));
                }),
   /*         ListTile(
                title: Text('ปฏิทินจันทรคติ'),
                leading: Icon(Icons.calendar_today, color: Colors.orange),
                onTap: () {}),*/
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: _openDrawer,
        child: Icon(
          Icons.api_sharp,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
