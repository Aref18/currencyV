class Arzcurrency {
  String? id;
  String? title;
  String? price;
  String? changes;
  String? status;

  var imageUrl;

  Arzcurrency({
    required this.id,
    required this.title,
    required this.price,
    required this.changes,
    required this.status,
  });

  contains(Arzcurrency item) {}

  void remove(Arzcurrency item) {}

  void add(Arzcurrency item) {}
}

class ItemModel {
  final String? title;

  ItemModel({this.title});
}
