class SearchPinModel {
  final int id;
  final String imageUrl;
  final String author;
  final String title;

  SearchPinModel({
    required this.id,
    required this.imageUrl,
    required this.author,
    required this.title,
  });

  factory SearchPinModel.fromJson(Map<String, dynamic> json) {
    return SearchPinModel(
      id: json['id'] ?? 0,
      imageUrl: json['src']?['large2x'] ?? json['src']?['medium'] ?? '',
      author: (json['photographer'] ?? 'Unknown').toString(),
      title: (json['alt'] ?? 'Untitled').toString(),
    );
  }
}
