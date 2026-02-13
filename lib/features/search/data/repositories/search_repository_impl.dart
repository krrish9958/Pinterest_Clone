import '../../domain/entities/search_pin_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SearchPinEntity>> searchPins({
    required String query,
    int page = 1,
  }) async {
    final pins = await remoteDataSource.searchPins(query: query, page: page);

    return pins
        .map((e) => SearchPinEntity(id: e.id, imageUrl: e.imageUrl))
        .toList();
  }
}
