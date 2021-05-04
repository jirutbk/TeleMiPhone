import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CarLicensePage extends StatefulWidget {
  final int day;
  CarLicensePage({this.day});

  @override
  _CarLicensePageState createState() => _CarLicensePageState(day: day);
}

class _CarLicensePageState extends State<CarLicensePage> {
  List _numbers = [];
  List _charValue = [];
  List _searchResult = [];
  List _days = [];
  int day;
  double level = 0.0;
  String badchar = "  ";
  final myController = TextEditingController();
  var exp = RegExp(r"^[0-9]*[ก-ฮ]+[0-9]+$");

  _CarLicensePageState({this.day}) {
    this.readJson();
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/MagicNumber.json');
    final data = await json.decode(response);

    final String response2 =
        await rootBundle.loadString('assets/charValue.json');
    final data2 = json.decode(response2);

    final String response3 = await rootBundle.loadString('assets/Days.json');
    final data3 = json.decode(response3);

    setState(() {
      _numbers = data["number"];
      _charValue = data2["charValue"];
      _days = data3["days"];
    });
  }

  int calculate(String data) {
    int sum = 0;

    data.runes.forEach((rune) {
      if (!isNumeric(String.fromCharCode(rune))) //ถ้าเป็นตัวอักษร
        _charValue.forEach((item) {
          if (item["charSet"].contains(String.fromCharCode(rune)))
            sum += int.parse(item["value"]);
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

  void badChar() {
    String data;
    badchar = "  ";

    data = myController.text.replaceAll(new RegExp(r"\s+"), ""); //ลบชื่อว่าง
    if (day == 0)
      Toast.show("กรุณาระบุวันเกิดก่อน.. !", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

    data.runes.forEach((rune) {
      if (_days[day - 1]["badChar"].contains(String.fromCharCode(rune)))
        badchar += " " + String.fromCharCode(rune);
    });
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
    badChar();

    print("วันเกิดคือ $day");

    if (sum > 0) {
      Toast.show("ผลรวมเท่ากับ $sum", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

      for (var item in _numbers) {
        if (item["num"].contains(sum.toString())) {
          level = double.parse(item["level"]);
          _searchResult.add(item);
          break;
        }
      }
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
                          level = 0.0;
                          badchar = "  ";
                          onSearchPressed();
                        },
                      ),
                    ),
                  ),

                  Card(
                      child: ListTile(
                    leading: Text("ระดับ $level"),
                    title: RatingBar.builder(
                      initialRating: level,
                      ignoreGestures: true, //ปิดไม่ให้ tab
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    subtitle: Text("กาลกิณี : $badchar"),
                  )),

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
