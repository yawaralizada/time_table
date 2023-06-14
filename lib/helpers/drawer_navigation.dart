import 'package:flutter/material.dart';
import 'package:time_table/screens/about.dart';
import 'package:time_table/screens/categories_screen.dart';
import 'package:time_table/screens/home_screen.dart';
import 'package:time_table/screens/settings.dart';
import 'package:time_table/screens/todos_by_category.dart';
import 'package:time_table/services/category_service.dart';


class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {

  List<Widget> _categoryList = <Widget>[];

  CategoryService _categoryService = CategoryService();

  @override
  initState(){
    super.initState();
    getAllCategories();
  }

  getAllCategories() async{
    var categories = await _categoryService.readCategories();

    categories.forEach((category){
      setState(() {
        _categoryList.add(InkWell(
          onTap: ()=>Navigator.push(context,
              MaterialPageRoute(
                  builder: (context)=> TodosByCategory(category: category['name'])
              )),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/photo.JPG'),
              ),
                accountName: Text('Yawar Alizada'),
                accountEmail: Text('yawarhussain.af@gmail.com'),
                decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("صفحه اصلی"),
              onTap: ()=>Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context)=>const HomeScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text("کتگوری ها"),
              onTap: ()=>Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context)=>const CategoriesScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("تنظیمات"),
              onTap: ()=>Navigator.of(context)
                .push(MaterialPageRoute(builder: (context)=>const Settings())),
            ),
            ListTile(
              leading: const Icon(Icons.more),
              title: const Text("در باره ما"),
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const About())),
            ),
            const Divider(),
            Column(
              children: _categoryList,
            )
          ],
        ),
      ),
    );
  }
}
