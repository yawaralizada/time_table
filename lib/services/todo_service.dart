import 'package:time_table/models/category.dart';
import 'package:time_table/repositories/repository.dart';
import '../models/todo.dart';

class TodoService{
  Repository? _repository;
  TodoService(){
    _repository = Repository();
  }
  // saving todor list on database table
  saveTodos(Todo todo) async{
    return await _repository?.insertData('todos', todo.todoMap());
  }
  // showing data from table on home screen
  readTodos() async{
    return await _repository?.readData('todos');
  }
  //readTodos by category
  readTodosByCategory(category) async{
    return await _repository?.readDataByColumnName(
        'todos', 'category', category);
  }
  // delete data from table
  deleteTodos(todoId) async{
    return await _repository?.deleteData('todos', todoId);
  }
}