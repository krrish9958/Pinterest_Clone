import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/search_remote_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/entities/search_pin_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/search_pins_use_case.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(SearchRemoteDataSource());
});

final searchPinsUseCaseProvider = Provider<SearchPinsUseCase>((ref) {
  final repository = ref.read(searchRepositoryProvider);
  return SearchPinsUseCase(repository);
});

class SearchNotifier extends StateNotifier<AsyncValue<List<SearchPinEntity>>> {
  final SearchPinsUseCase searchPinsUseCase;

  int _page = 1;
  String _currentQuery = '';
  bool _isLoadingMore = false;

  SearchNotifier(this.searchPinsUseCase) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    final normalizedQuery = query.trim();
    _currentQuery = normalizedQuery;
    _page = 1;

    if (normalizedQuery.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final results = await searchPinsUseCase(query: normalizedQuery, page: 1);
      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (_currentQuery.isEmpty || _isLoadingMore) return;
    _isLoadingMore = true;

    try {
      final current = state.value ?? [];
      final newResults = await searchPinsUseCase(
        query: _currentQuery,
        page: _page + 1,
      );

      _page++;
      state = AsyncValue.data([...current, ...newResults]);
    } catch (_) {
      // Keep existing results visible when pagination fails.
    } finally {
      _isLoadingMore = false;
    }
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<SearchPinEntity>>>((
      ref,
    ) {
      final useCase = ref.read(searchPinsUseCaseProvider);
      return SearchNotifier(useCase);
    });
