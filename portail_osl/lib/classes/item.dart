class Item {
  String id;
  String name;
  String articleNum;

  Item({required this.id, required this.name, required this.articleNum});

  // Factory constructor to create a Item object from a string
  factory Item.fromString(String line) {
    List<String> parts = line.split(';');
    return Item(
      id: parts[0],
      name: parts[1],
      articleNum: parts[2],
    );
  }

  @override
  String toString() {
    return '$id;$name;$articleNum';
  }
}
