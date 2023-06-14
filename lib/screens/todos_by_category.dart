import 'package:flutter/material.dart';
import 'package:time_table/services/todo_service.dart';

import '../models/todo.dart';


class TodosByCategory extends StatefulWidget {


  final String? category;
  TodosByCategory({this.category});


  @override
  State<TodosByCategory> createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  final _todo = Todo();

  List<Todo> _todoList = <Todo>[];
  final _todoService = TodoService();
  var todo;

  @override
  void initState(){
    super.initState();
    getTodosByCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getTodosByCategories() async{
    _todoList = <Todo>[];
    var todos = await _todoService.readTodosByCategory(widget.category);
    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        model.description = todo['description'];
        model.startDate = todo['startDate'];
        // model.endDate = todo['endDate'];
        // model.quantity = todo['quantity'];
        _todoList.add(model);
      });
    });
  }


  _deleteFormDialog(BuildContext context, todoId){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            onPressed: ()=>Navigator.pop(context),
            child: const Text('لغو نمودن'),
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () async{

                var result = await _todoService.deleteTodos(todoId);
                if (result > 0) {
                  Navigator.pop(context);
                  getTodosByCategories(); // realtime update for changes
                  _showSuccessSnackBar(const Text("حذف گردید"));
                }
              },
              child: const Text('حذف نمودن')
          ),
        ],
        title: const Text('با حذف کردن شما این را از دست خواهید داد'),

      );
    });
  }



  // showing success message for updating
  _showSuccessSnackBar(message){
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("فعالیت ها با کتگوری"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
                      child: Card(
                          color: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)
                        ),
                        elevation: 8,
                        child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_todoList[index].title),
                                  IconButton(
                                      onPressed: (){
                                        _deleteFormDialog(context, _todoList[index].id);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                    ],
                              ),
                          subtitle: Text(_todoList[index].description),
                          trailing: Text(_todoList[index].startDate),
                            )
                      ),
                    );
                  })
          )
        ],
      ),
      backgroundColor: Colors.grey,
    );
  }
}
