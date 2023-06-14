import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_table/helpers/drawer_navigation.dart';
import 'package:time_table/screens/todo_screen.dart';
import 'package:time_table/screens/todos_by_category.dart';
import 'package:time_table/services/todo_service.dart';
import '../models/todo.dart';
import '../services/category_service.dart';
import 'categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> _categoryList = <Widget>[];

  CategoryService _categoryService = CategoryService();
  @override
  intitState(){
    super.initState();
    getAllTodos();
  }




  late TodoService _todoService;

  List<Todo> _todoList = <Todo>[];


  getAllTodos() async{
    _todoService = TodoService();
    _todoList = <Todo>[];

    var todos = await _todoService.readTodos();
    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.startDate = todo['startDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
        // model.endDate = todo['endDate'];
        // model.quantity = todo['quantity']
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صفحه اصلی'),
      ),
      drawer: const DrawerNavigation(),
    //   body:
    // //ListView.builder(
    //     //   itemCount: _todoList.length,
    //     //   itemBuilder: (context, index) {
    //     // return Padding(
    //     //   padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
    //     //   child: Card(
    //     //     elevation: 0,
    //     //     shape: RoundedRectangleBorder(
    //     //       borderRadius: BorderRadius.circular(0)),
    //     //     child: ListTile(
    //     //       title: Row(
    //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     //         children: [
    //     //           IconButton(
    //     //               onPressed: ()=>Navigator.of(context)
    //     //                   .push(MaterialPageRoute(builder: (context)=>const CategoriesScreen())),
    //     //               icon: Icon(Icons.category),
    //     //           )
    //     //         ],
    //     //       ),
    //     //     ),
    //     //   ),
    //     //);
    //   //}
    //   //),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const TodoScreen())),
    //     child: const Icon(Icons.add),
    //   ),




      body: Padding(
        padding: const EdgeInsets.only(top: 5.0,),
        child: Card(
          color: Colors.blueGrey,
          child: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Category'),
                    TextButton(
                      onPressed: (){Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context)=>const CategoriesScreen()));
                      },
                      child: const Icon(Icons.menu),
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('todos list'),
                    TextButton(
                      onPressed: (){Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context)=>TodosByCategory()));
                      },
                      child: Icon(Icons.more),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    floatingActionButton: FloatingActionButton(
      onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const TodoScreen())),
      child: const Icon(Icons.add),
    ),
    backgroundColor: Colors.grey,
    );
  }
}
