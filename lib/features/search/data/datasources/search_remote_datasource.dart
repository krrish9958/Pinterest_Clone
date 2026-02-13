import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/search_pin_model.dart';

class SearchRemoteDataSource {
  final Dio dio = DioClient.dio;

  Future<List<SearchPinModel>> searchPins({
    required String query,
    int page = 1,
  }) async {
    final response = await dio.get(
      'search',
      queryParameters: {'query': query, 'per_page': 30, 'page': page},
    );

    final List photos = response.data['photos'];

    return photos.map((e) => SearchPinModel.fromJson(e)).toList();
  }
}
