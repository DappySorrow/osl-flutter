class Game {
  String id;
  String name;
  String console;
  String articleNum;

  Game({required this.id, required this.name, required this.console, required this.articleNum});

  // Factory constructor to create a Game object from a string
  factory Game.fromString(String line) {
    List<String> parts = line.split(';');
    return Game(
      id: parts[0],
      name: parts[1],
      console: parts[2],
      articleNum: parts[3],
    );
  }

  @override
  String toString() {
    return '$id;$name;$console;$articleNum';
  }
}
