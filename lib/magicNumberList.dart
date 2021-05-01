import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MagicNumberList extends StatefulWidget {
  @override
  _MagicNumberListState createState() => _MagicNumberListState();
}

class _MagicNumberListState extends State<MagicNumberList> {
  List _numbers = [];
  List _searchResult = [];
  final myController = TextEditingController();

  _MagicNumberListState() {
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

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      _searchResult = List.of(_numbers); //copy list member
      setState(() {});
      return;
    }
    _numbers.forEach((item) {
      if (item["num"].contains(text)) _searchResult.add(item);
    });

    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('เลขศาสตร์', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink,
        ),
        body: GestureDetector(  //ใช้ตรวจสอบการแตะหน้าจอ
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode()); //ใช้ hide keyboard
            },
            child: Scrollbar(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.format_list_numbered, color: Colors.red),
                        title: TextField(
                          controller: myController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'ป้อนตัวเลข', border: InputBorder.none),
                          onChanged: onSearchTextChanged,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            myController.clear();
                            onSearchTextChanged('');
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
                                    subtitle: Text(
                                        _searchResult[index]["description"]),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            )));
  }
}
