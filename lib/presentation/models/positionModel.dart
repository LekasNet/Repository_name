class PositionModel {
  final String text;
  final String duration;
  final int price;
  int added;

  PositionModel({
    required this.text,
    required this.duration,
    required this.price,
    this.added = 0,
  });
}
