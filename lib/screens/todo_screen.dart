import 'package:flutter/material.dart';
import 'package:time_table/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:time_table/services/todo_service.dart';

import '../models/todo.dart';


class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  //controllers
  final _todoTitleController =TextEditingController();
  final _todoDescriptionController = TextEditingController();
  final _todoDateController = TextEditingController();
  // final _todoQuantityController = TextEditingController();

  var _selectedValue;
  final _categories = List<DropdownMenuItem<String>>.from(<DropdownMenuItem<String>>[]);
  final List<Todo> _todoCategory = <Todo>[];

  @override
  void initState(){
    super.initState();
    _loadCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  _loadCategories() async{
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(
          value: category['name'],
          child: Text(category['name']),
        ));
      });
    });
  }

  //initializing the date and time
  DateTime _dateTime = DateTime.now();
  // DateTime _endTime = DateTime.timestamp();

  _selectedTodoDate(BuildContext context) async{
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100)
    );
    if(_pickedDate != null){
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }
// showing success message on screen
  _showSuccessSnackBar(message){
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text('ایجاد فعالیت'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _todoTitleController,
              decoration: const InputDecoration(
                labelText: 'نام',
                hintText: 'نام فعالیت',
              ),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: const InputDecoration(
                labelText: 'توضیحات',
                hintText: 'توضیحات بنوسید',
              ),
            ),
            TextField(
              controller: _todoDateController,
              decoration: InputDecoration(
                labelText: 'تاریخ',
                hintText: 'تاریخ شروغ پروژه',
                prefixIcon: InkWell(
                  onTap: (){
                    _selectedTodoDate(context);
                  },
                  child: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            // TextField(
            //   controller: _todoDateController,
            //   decoration: InputDecoration(
            //     labelText: 'تاریخ',
            //     hintText: 'تاریخ تکمیل پروژه',
            //     prefixIcon: InkWell(
            //       onTap: (){
            //         _selectedTodoDate(context);
            //       },
            //       child: const Icon(Icons.calendar_today),
            //     ),
            //   ),
            // ),
            // TextField(
            //   controller: _todoQuantityController,
            //   decoration: const InputDecoration(
            //     labelText: 'بودجه',
            //     hintText: 'توضیحات بنوسید',
            //   ),
            // ),
            DropdownButtonFormField(
              value: _selectedValue,
              items: _categories,
              hint: const Text('کتگوری'),
              onChanged: (value){
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async{
                  var todoObject = Todo();
                  todoObject.title = _todoTitleController.text;
                  todoObject.description = _todoDescriptionController.text;
                  todoObject.isFinished = 0;
                  todoObject.category = _selectedValue.toString();
                  todoObject.startDate = _todoDateController.text;
                  // todoObject.endDate = _todoDateController.text;
                  // todoObject.quantity = _todoQuantityController.text as double;

                  var todoService = TodoService();
                  var result = await todoService.saveTodos(todoObject);
                  if(result > 0){
                    Navigator.pop(context);
                    _showSuccessSnackBar(const Text("ایجاد گردید"));
                    print(result);
                  }

                },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
                child: const Text('ذخیره کردن'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey,
    );
  }
}
