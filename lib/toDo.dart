// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo extends StatefulWidget {
  final String? userName;
  const Todo({super.key, this.userName});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<String> _tasks = [];
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
        _tasks.add(TaskController.text);
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

  void _saveTask() async {
    var pref = await SharedPreferences.getInstance();
    pref.setStringList('task_list', _tasks);
  }

  void _loadTask() async {
    final pref = await SharedPreferences.getInstance();
    final savedTask = pref.getStringList('task_list');
    if (savedTask != null) {
      _tasks = savedTask;
    }
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
                      leading: Container(
                        height: 50,
                        width: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        '${_tasks[index]}',
                        style: TextStyle(
                          fontSize: FontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _deleteTask(index);
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
