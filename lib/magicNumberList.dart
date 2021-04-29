import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MagicNumberList extends StatefulWidget {
  @override
  _MagicNumberListState createState() => _MagicNumberListState();
}

class _MagicNumberListState extends State<MagicNumberList> {
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/MagicNumber.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["number"];
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'เลขศาสตร์',
          ),
          backgroundColor: Colors.pink,
        ),
        body: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                ElevatedButton(
                  child: Text('Load Data'),
                  onPressed: readJson,
                ),

                // Display the data loaded from sample.json
                _items.length > 0
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.all(10),
                              child: ListTile(
                                leading: Text(_items[index]["num"]),
                                title: Text(_items[index]["title"]),
                                subtitle: Text(_items[index]["description"]),
                              ),
                            );
                          },
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ));
  }
}
