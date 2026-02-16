class PinModel {
  final int id;
  final String imageUrl;
  final String author;
  final String title;

  PinModel({
    required this.id,
    required this.imageUrl,
    required this.author,
    required this.title,
  });

  factory PinModel.fromJson(Map<String, dynamic> json) {
    return PinModel(
      id: json['id'] ?? 0,
      imageUrl: json['src']?['large2x'] ?? json['src']?['medium'] ?? '',
      author: (json['photographer'] ?? 'Unknown').toString(),
      title: (json['alt'] ?? 'Untitled').toString(),
    );
  }
}
