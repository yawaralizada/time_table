import 'package:flutter/material.dart';
import 'package:time_table/screens/home_screen.dart';
import '../services/category_service.dart';
import '../models/category.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _categoryNameController = TextEditingController();
  final _categoryDescriptionController = TextEditingController();

  final _editCategoryNameController = TextEditingController();
  final _editCategoryDescriptionController = TextEditingController();

  final _category = Category();
  final _categoryService = CategoryService();

  List<Category> _categoryList = <Category>[];
  var category;

  @override
  void initState(){
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async{
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async{
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'نام موجود نیست';
      _editCategoryDescriptionController.text = category[0]['description'] ?? 'توضیحات موجود نیست';
    });
    _editFormDialog(context);
  }

//show form dialog
  _showFormDialog(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param){
          return AlertDialog(
            actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: ()=>Navigator.pop(context),
              child: const Text('لغو نمودن'),
            ),
            TextButton(
              style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async{
                _category.name = _categoryNameController.text;
                _category.description = _categoryDescriptionController.text;
                var result = await _categoryService.saveCategory(_category);
                if (result > 0) {
                  print(result);
                  Navigator.pop(context);
                  getAllCategories();
                }
              },
              child: const Text('ذخیره کردن')
          ),
        ],
        title: const Text('فورم کتگوری ها'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _categoryNameController,
                decoration: const InputDecoration(
                  hintText: 'یک کتگوری ایجاد کنید',
                  labelText: 'کتگوری'
                ),
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: const InputDecoration(
                    hintText: 'یک توضیحات بنوسید',
                    labelText: 'توضیحات'
                ),
              )
            ],
          ),
        ),
      );
    });
  }
//edit form dialog
  _editFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: ()=>Navigator.pop(context),
            child: const Text('لغو'),
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async{
                _category.id = category[0]['id'];
                _category.name = _editCategoryNameController.text;
                _category.description = _editCategoryDescriptionController.text;
                var result = await _categoryService.updateCategory(_category);
                if (result > 0) {
                  Navigator.pop(context);
                  getAllCategories(); // realtime update for changes
                  _showSuccessSnackBar(const Text("آپدیت شد"));
                }
              },
              child: const Text('آپدیت')
          ),
        ],
        title: const Text('ویرایش فورم کتگوری'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _editCategoryNameController,
                decoration: const InputDecoration(
                    hintText: 'یک کتگوری ایجاد کنید',
                    labelText: 'کتگوری'
                ),
              ),
              TextField(
                controller: _editCategoryDescriptionController,
                decoration: const InputDecoration(
                    hintText: 'توضیحات بنوسید',
                    labelText: 'توضیحات'
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  // delete form dialog
  _deleteFormDialog(BuildContext context, categoryId){
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

                var result = await _categoryService.deleteCategory(categoryId);
                if (result > 0) {
                  Navigator.pop(context);
                  getAllCategories(); // realtime update for changes
                  _showSuccessSnackBar(const Text("آپدیت شد"));
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
        leading: ElevatedButton(
          onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomeScreen())),
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('کتگوری ها'),
      ),
      body: ListView.builder(itemCount:_categoryList.length, itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
          child: Card(
            color: Colors.blueGrey,
            elevation: 8.0,
            child: ListTile(
              leading: IconButton(icon: const Icon(Icons.edit),
              onPressed: (){
                _editCategory(context, _categoryList[index].id);
              },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_categoryList[index].name),
                  IconButton(
                      onPressed: (){
                        _deleteFormDialog(context, _categoryList[index].id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                  ),
                ],
              ),
            ),
          ),
        );
    }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showFormDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.grey,
    );
  }
}
