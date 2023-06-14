class Category{
  int? id;
  late String name;
  late String description;
  categoryMap(){
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['description'] = description;

    return mapping;
  }
}