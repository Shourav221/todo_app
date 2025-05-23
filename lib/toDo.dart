// import 'dart:ffi';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo extends StatefulWidget {
  final String? userName;
  const Todo({super.key, this.userName});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<Map<String, dynamic>> _tasks = [];
  TextEditingController TaskController = TextEditingController();

  String displayName = "Shikhu";

  @override
  void initState() {
    super.initState();
    _loadTask();

    displayName =
        widget.userName?.isNotEmpty == true ? widget.userName! : "Shikhu";
  }

  void _addTask() {
    if (TaskController.text.isNotEmpty) {
      setState(() {
        _tasks.insert(0, {'title': TaskController.text, 'done': false});
        TaskController.clear();
      });
      _saveTask();
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTask();
  }

  // For Alert Dialog

  void showAlertDialog(int index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Warning'),
                ],
              ),
              content: Text('Are you sure to delete your task ?'),
              actions: [
                TextButton(
                    onPressed: () {
                      _deleteTask(index);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ))
              ],
            ));
  }

  void _saveTask() async {
    var pref = await SharedPreferences.getInstance();
    List<String> taskStrings = _tasks.map((task) => jsonEncode(task)).toList();
    pref.setStringList('task_list', taskStrings);
  }

  void _loadTask() async {
    final pref = await SharedPreferences.getInstance();
    final savedTaskStrings = pref.getStringList('task_list');
    if (savedTaskStrings != null) {
      setState(() {
        _tasks = savedTaskStrings
            .map((task) => jsonDecode(task) as Map<String, dynamic>)
            .toList();
      });
    }
  }

  void _toggleDone(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
    _saveTask();
  }

  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context).size;
    double FontSize = ScreenSize.width > 600 ? 25 : 20;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$displayName\'s ToDo List',
          style: TextStyle(
            color: Colors.white,
            fontSize: FontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: TaskController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Add Task',
                      labelText: 'Add Task',
                      labelStyle: TextStyle(
                        color: Colors.green,
                        fontSize: FontSize,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              )),
              ElevatedButton(
                onPressed: _addTask,
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: IconButton(
                          onPressed: () {
                            _toggleDone(index);
                          },
                          icon: Icon(
                            _tasks[index]['done']
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Colors.green,
                          )),
                      title: Text(
                        '${_tasks[index]['title']}',
                        style: TextStyle(
                          fontSize: FontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: _tasks[index]['done']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showAlertDialog(index);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
