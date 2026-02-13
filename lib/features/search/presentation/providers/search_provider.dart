import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/search_remote_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/entities/search_pin_entity.dart';
import '../../domain/repositories/search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(SearchRemoteDataSource());
});

class SearchNotifier extends StateNotifier<AsyncValue<List<SearchPinEntity>>> {
  final SearchRepository repository;

  int _page = 1;
  String _currentQuery = '';

  SearchNotifier(this.repository) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    _currentQuery = query;
    _page = 1;

    state = const AsyncValue.loading();

    try {
      final results = await repository.searchPins(query: query, page: 1);
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (_currentQuery.isEmpty) return;

    try {
      final current = state.value ?? [];
      final newResults = await repository.searchPins(
        query: _currentQuery,
        page: _page + 1,
      );

      _page++;
      state = AsyncValue.data([...current, ...newResults]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<SearchPinEntity>>>((
      ref,
    ) {
      final repo = ref.read(searchRepositoryProvider);
      return SearchNotifier(repo);
    });
