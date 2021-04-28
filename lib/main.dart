import 'package:flutter/material.dart';
import 'package:telemiphone/magicNumberList.dart';

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
      home: MainScreen(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TeleMiPhone'),
        backgroundColor: Colors.pink,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'เกี่ยวกับ App',
            onPressed: () {              
              showAboutDialog(
                  context: context,
                  applicationVersion: "1.5.0",
                  applicationLegalese: "ผู้พัฒนา : TanunnasBK");
            },
          ),
        ],
      ),
      body: Material(
          color: Colors.pink[100],
          child: Center(
              child: Text('ศาสตร์แห่งตัวเลข',
                  style: TextStyle(color: Colors.white, fontSize: 20.0)))),
      drawer: Drawer(
          child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('รายการทำนาย'),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
              ),
            ),
            ListTile(title: Text('หมายเลขโทรศัพท์'), onTap: () {}),
            ListTile(
              title: Text('เลขทะเบียนรถ'),
              onTap: () {},
            ),
            ListTile(
              title: Text('แสดงเลขศาสตร์'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MagicNumberList()));
              },
            ),
            ListTile(
              title: Text('เกี่ยวกับโปรแกรม'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                    context: context,
                    applicationVersion: "1.5.0",
                    applicationLegalese: "ผู้พัฒนา : TanunnasBK");
              },
            ),
          ],
        ),
      )),
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
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
