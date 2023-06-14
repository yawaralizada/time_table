
class  Todo{
  int? id;
  late String title;
  late String description;
  late String category;
  late String startDate;
  late int isFinished;
  // late String endDate;
  // late double quantity;

  todoMap(){
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['title'] = title;
    mapping['description'] = description;
    mapping['category'] = category;
    mapping['startDate'] = startDate;
    // mapping['endDate'] = endDate;
    // mapping['quantity'] = quantity;
    mapping['isFinished'] = isFinished;
    return mapping;
  }
}