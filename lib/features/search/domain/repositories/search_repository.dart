import '../entities/search_pin_entity.dart';

abstract class SearchRepository {
  Future<List<SearchPinEntity>> searchPins({required String query, int page});
}
