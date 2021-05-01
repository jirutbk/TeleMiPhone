import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  List _numbers = [];
  List _searchResult = [];
  final myController = TextEditingController();
  var exp = RegExp(r"^[\d]{10}$");

  _PhoneNumberPageState() {
    this.readJson();
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/MagicNumber.json');
    final data = await json.decode(response);
    setState(() {
      _numbers = data["number"];
    });
  }

  void onSearchPressed() async {
    int sum = 0;
    _searchResult.clear();
    if (myController.text.isNotEmpty && !exp.hasMatch(myController.text)) {
      Toast.show("หมายเลขโทรศัพท์ไม่ถูกต้อง !", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      setState(() {});
      return;
    }
    myController.text.runes.forEach((int rune) {
      sum += int.parse(String.fromCharCode(rune));
    });

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
        title: Text('คำนวณหมายเลขมงคล', style: TextStyle(color: Colors.white)),
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
                      leading: Icon(Icons.mobile_friendly_rounded,color: Colors.green),
                      title: TextField(
                        controller: myController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'หมายเลขโทรศัพท์',
                            border: InputBorder.none),
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
