import 'package:pinterest_clone/features/search/domain/entities/search_pin_entity.dart';
import 'package:pinterest_clone/features/search/domain/repositories/search_repository.dart';

class SearchPinsUseCase {
  final SearchRepository repository;

  SearchPinsUseCase(this.repository);

  Future<List<SearchPinEntity>> call({required String query, required int page}) {
    return repository.searchPins(query: query, page: page);
  }
}
