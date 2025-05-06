import 'dart:ffi';

import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<String> _tasks = [];
  TextEditingController TaskController = TextEditingController();

  void _addTask() {
    if (TaskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(TaskController.text);
        TaskController.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context).size;
    double FontSize = ScreenSize.width > 600 ? 32 : 20;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shikhu\'s ToDo List',
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
                    color: Colors.purpleAccent,
                    child: ListTile(
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: FontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: Text(
                        '${_tasks[index]}',
                        style: TextStyle(
                          fontSize: FontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _deleteTask(index);
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
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
