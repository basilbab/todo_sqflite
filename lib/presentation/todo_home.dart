import 'package:flutter/material.dart';
import 'package:todo_sqflite/core/core.dart';
import 'package:todo_sqflite/domain/todo/todo_model.dart';
import 'package:todo_sqflite/infrastructure/todo_db.dart';

class ScreenTodoHome extends StatefulWidget {
  const ScreenTodoHome({super.key});

  @override
  State<ScreenTodoHome> createState() => _ScreenTodoHomeState();
}

class _ScreenTodoHomeState extends State<ScreenTodoHome> {
  final todoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int id = 0;
  bool flag = false;
  int editId = 0;
  List<TodoModel> todoModelList = [];
  @override
  @override
  Widget build(BuildContext context) {
    loadDB();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: TextFormField(
                          controller: todoController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Task Cannot be empty!';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: 'Task Name',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (flag == false) {
                                TodoModel t = TodoModel(
                                    todoId: 1,
                                    todoName: todoController.text,
                                    todoStatus: '0');
                                await insertDatabase(t);
                                todoController.text = '';
                              } else {
                                await updateData(editId, todoController.text);
                                setState(() {
                                  flag = false;
                                });
                              }
                            }
                          },
                          child: Text(flag == false ? 'Add' : 'Save')),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * .8,
                child: ListView.builder(
                  itemBuilder: (BuildContext, index) {
                    return ListTile(
                      onTap: () {
                        changeStatus(todoModelList[index].todoId,
                            todoModelList[index].todoStatus);
                      },
                      leading: Text((index + 1).toString()),
                      title: Text(todoModelList[index].todoName),
                      subtitle: Row(
                        children: [
                          Text(
                            todoModelList[index].todoStatus == '0'
                                ? 'Not Completed'
                                : 'Completed',
                            style: TextStyle(
                                color: todoModelList[index].todoStatus == '0'
                                    ? Colors.red
                                    : Colors.green),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                todoController.text =
                                    todoModelList[index].todoName;
                                setState(() {
                                  flag = true;
                                  editId = todoModelList[index].todoId;
                                });
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                deleteData(todoModelList[index].todoId);
                              },
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    );
                  },
                  itemCount: todoModelList.length,
                ))
          ],
        ),
      ),
    );
  }

  void loadDB() async {
    await loadDatabase();

    setState(() {
      todoModelList = todoModelGlobalList;
    });
  }
}
