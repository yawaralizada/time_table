import 'package:flutter/gestures.dart';
import 'package:time_table/models/category.dart';
import 'package:time_table/repositories/repository.dart';

class CategoryService{
  late Repository _repository;
  CategoryService(){
    _repository = Repository();
  }
  // Creating date or Inserting date to table
  saveCategory(Category category) async{
    return await _repository.insertData('categories', category.categoryMap());
  }
  // Reading date from table or showing date on screen
  readCategories() async{
    return await _repository.readData('categories');
  }
//Read data from table by id
  readCategoryById(categoryId) async{
    return await _repository.readDataById('categories', categoryId);
  }
// Update data from table
  updateCategory(Category category) async{
    return await _repository.updateData('categories', category.categoryMap());
  }
// delete data from table
  deleteCategory(categoryId) async{
    return await _repository.deleteData('categories', categoryId);
  }
}