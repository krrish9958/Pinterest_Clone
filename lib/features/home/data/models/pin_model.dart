class PinModel {
  final int id;
  final String imageUrl;

  PinModel({required this.id, required this.imageUrl});

  factory PinModel.fromJson(Map<String, dynamic> json) {
    return PinModel(id: json['id'], imageUrl: json['src']['medium']);
  }
}
