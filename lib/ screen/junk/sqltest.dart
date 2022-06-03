import 'package:eoya_gaja/model/memoDateModel.dart';
import 'package:flutter/material.dart';

import '../../model/dbHelper.dart';

class sqlTest extends StatefulWidget {
  const sqlTest({Key? key}) : super(key: key);

  @override
  _sqlTestState createState() => _sqlTestState();
}

class _sqlTestState extends State<sqlTest> {
  @override
  Widget build(BuildContext context) {
    int? selectedId;
    final textController = TextEditingController();
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<memoDateModel>>(
          future: DatabaseHelper.instance.getmemoDate(),
          builder: (BuildContext context,
              AsyncSnapshot<List<memoDateModel>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading'),
              );
            }
            return snapshot.data!.isEmpty
                ? Center(child: Text('No Groceries in List'))
                : ListView(
                    children: snapshot.data!.map((memoDateModel) {
                      print(memoDateModel.id);
                      return Center(
                        child: Card(
                          color: selectedId == memoDateModel.id
                              ? Colors.white70
                              : Colors.white,
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                if (selectedId == null) {
                                  textController.text =
                                      memoDateModel.enrolledDate;
                                  selectedId = memoDateModel.id;
                                } else {
                                  textController.text = '';
                                  selectedId = null;
                                }
                              });
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(memoDateModel.enrolledDate),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      DatabaseHelper.instance
                                          .remove(memoDateModel.id!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          selectedId != null
              ? await DatabaseHelper.instance.update(
                  memoDateModel(id: selectedId, enrolledDate: 'goo12'),
                )
              : await DatabaseHelper.instance.add(
                  memoDateModel(enrolledDate: 'goo'),
                );
          setState(() {
            textController.clear();
            selectedId = null;
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
