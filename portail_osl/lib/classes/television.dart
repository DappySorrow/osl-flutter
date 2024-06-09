class Television {
  final String id;
  final String brand;
  final String model;
  final String size;
  final String height;
  final String width;
  final String depth;
  final String legs;
  final String resolution;
  final String refreshRate;
  final String articleNumber;
  final String bluetooth;
  final String link;

  Television({
    required this.id,
    required this.brand,
    required this.model,
    required this.size,
    required this.height,
    required this.width,
    required this.depth,
    required this.legs,
    required this.resolution,
    required this.refreshRate,
    required this.articleNumber,
    required this.bluetooth,
    required this.link,
  });

  factory Television.fromString(String line) {
    List<String> fields = line.split(';');
    if (fields.length != 13) {
      print('Invalid line: $line'); // Debug print
      throw RangeError('Invalid line length: ${fields.length}');
    }
    return Television(
      id: fields[0],
      brand: fields[1],
      model: fields[2],
      size: fields[3],
      height: fields[4],
      width: fields[5],
      depth: fields[6],
      legs: fields[7],
      resolution: fields[8],
      refreshRate: fields[9],
      articleNumber: fields[10],
      bluetooth: fields[11],
      link: fields[12],
    );
  }
}
