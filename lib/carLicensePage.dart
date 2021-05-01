import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class CarLicensePage extends StatefulWidget {
  @override
  _CarLicensePageState createState() => _CarLicensePageState();
}

class _CarLicensePageState extends State<CarLicensePage> {
  List _numbers = [];
  List _days = [];
  List _searchResult = [];
  final myController = TextEditingController();
  var exp = RegExp(r"^[0-9]*[ก-ฮ]+[\s]*[0-9]+$");

  _CarLicensePageState() {
    this.readJson();
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/MagicNumber.json');
    final data = await json.decode(response);

    final String response2 = await rootBundle.loadString('assets/Days.json');
    final data2 = json.decode(response2);

    setState(() {
      _numbers = data["number"];
      _days = data2["days"];
    });
  }

  int calculate(String data) {
    int sum = 0;

    data.runes.forEach((rune) {
      if (!isNumeric(String.fromCharCode(rune))) //ถ้าเป็นตัวอักษร
        _days.forEach((item) {
          if (item["badChar"].contains(String.fromCharCode(rune)))
            sum += int.parse(item["id"]);
        });
      else
        sum += int.parse(String.fromCharCode(rune));
    });
    return sum;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  void onSearchPressed() async {
    int sum = 0;
    _searchResult.clear();
    if (myController.text.isNotEmpty && !exp.hasMatch(myController.text)) {
      Toast.show("เลขทะเบียนรถไม่ถูกต้อง  !", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      setState(() {});
      return;
    }

    sum = calculate(myController.text);

    if (sum > 0) {
      Toast.show("ผลรวมเท่ากับ $sum", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      _numbers.forEach((item) {
        if (item["num"].contains(sum.toString())) _searchResult.add(item);
      });
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('คำนวณเลขทะเบียนรถ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: GestureDetector(
          //ใช้ตรวจสอบการแตะหน้าจอ
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context)
                .requestFocus(new FocusNode()); //ใช้ hide keyboard
          },
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.car_rental, color: Colors.blue),
                      title: TextField(
                        controller: myController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'เลขทะเบียนรถ', border: InputBorder.none),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          myController.clear();
                          onSearchPressed();
                        },
                      ),
                    ),
                  ),

                  // Display the data loaded from sample.json
                  _numbers.length > 0
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _searchResult.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.all(10),
                                child: ListTile(
                                  leading: Text(_searchResult[index]["num"]),
                                  title: Text(_searchResult[index]["title"]),
                                  subtitle:
                                      Text(_searchResult[index]["description"]),
                                ),
                              );
                            },
                          ),
                        )
                      : Container()
                ],
              ),
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
        onPressed: onSearchPressed,
        child: Icon(
          Icons.api_sharp,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
