class SearchPinModel {
  final int id;
  final String imageUrl;

  SearchPinModel({required this.id, required this.imageUrl});

  factory SearchPinModel.fromJson(Map<String, dynamic> json) {
    return SearchPinModel(id: json['id'], imageUrl: json['src']['medium']);
  }
}
