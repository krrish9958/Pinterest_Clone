import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/pin_model.dart';

class HomeRemoteDataSource {
  final Dio dio = DioClient.dio;

  Future<List<PinModel>> fetchPins({int page = 1}) async {
    final response = await dio.get(
      'curated',
      queryParameters: {'per_page': 30, 'page': page},
    );

    final List photos = response.data['photos'];

    return photos.map((e) => PinModel.fromJson(e)).toList();
  }
}
